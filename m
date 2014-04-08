Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbaDHPDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:03:13 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:37400 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757067AbaDHPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:03:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3870:3872:3873:4321:4389:5007:7652:7875:7901:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13019:13069:13311:13357:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: idea66_386fb2816db0e
X-Filterd-Recvd-Size: 2131
Message-ID: <1396969386.2812.6.camel@joe-AO722>
Subject: Re: [PATCH 1/2] checkpatch: fix wildcard DT compatible string
 checking
From: Joe Perches <joe@perches.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 08 Apr 2014 08:03:06 -0700
In-Reply-To: <1396963505-11119-1-git-send-email-robherring2@gmail.com>
References: <1396963505-11119-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 08:25 -0500, Rob Herring wrote:
> We attempt to search for compatible strings which use a variable
> token in the documented name such as <chip> or <soc>. While this
> was attempted to be handled, it's utterly broken.

Looks like you've left some debugging stuff in this patch.

> The desired forms of matching are:
> 
> vendor,<chip>-*
> vendor,name<part#>-*

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 34eb216..0e960b1 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2093,8 +2093,11 @@ sub process {
>  
>  			foreach my $compat (@compats) {
>  				my $compat2 = $compat;
> -				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
> -				`grep -Erq "$compat|$compat2" $dt_path`;
> +				$compat2 =~ s/\,[a-zA-Z0-9]*\-/\,<\.\*>\-/;
> +				my $compat3 = $compat;
> +				$compat3 =~ s/\,([a-z]*)[0-9]*\-/\,$1<\.\*>\-/;
> +				print "$compat3\n";

debugging code?

> +				`grep -Erq "$compat|$compat2|$compat3" $dt_path`;
>  				if ( $? >> 8 ) {
>  					WARN("UNDOCUMENTED_DT_STRING",
>  					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);



