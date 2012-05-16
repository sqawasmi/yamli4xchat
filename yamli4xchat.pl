#!/usr/bin/perl
use strict;
use LWP::Simple;
use JSON; 

sub yamli {
	#IRC::print(@_);
	my $snt = "@_";
	my $channel = IRC::get_info(2);
	#IRC::print($channel);
	#IRC::print($snt);
	#my $snt = 'mar7ba ya wallad , keefak sho akhbarak ? 11.04';
	my @asnt = split(' ', $snt);
	my $snt = '';

	foreach my $word (@asnt) {
		#print "Current word: $word\n";
		my $url = 'http://api.yamli.com/transliterate.ashx?word='.$word.'&tool=api&account_id=000006&prot=http%3A&hostname=www.yamli.com&path=%2F&build=5152&sxhr_id=7';
		# Just an example: the URL for the most recent /Fresh Air/ show
		my $content = get $url;
		#print $content."\n";
		$content =~ s/if(.*)back\((.*)\);};/$2/;
		#print "$content\n";
		my $my_text = from_json($content);
		#print "here is JSON: \n".$my_text;
		#for (keys %$my_text) {
		#	print $_."\n";
		#}
		my $result = from_json($my_text->{ 'data' })->{ 'r' };
		#print $result."\n";

		if ($result =~ /(.*)\/0(.*)/) {
			$result =~ s/(.*)\/0(.*)[|\/0]?(.*)/$1/g;
		} else {
			$result = $word;
		}
		#print "Result is: $result\n";
		$snt .=' '.$result;
	}
	
	IRC::command( "/msg ". $channel . " " . $snt);

	#print $snt;
	
	return 1;

}

IRC::register( "ya", "1.0", "", "" );
IRC::add_command_handler( "ya", "yamli" );
