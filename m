Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaKHAkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:40:00 -0500
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:48942 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753415AbaKHAi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:38:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:421:541:599:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3872:3874:4250:4321:5007:6119:6261:7903:8957:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: arch76_1381b1e7b815b
X-Filterd-Recvd-Size: 2266
Message-ID: <1415407132.23530.23.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Make SI unit tolerance more lenient with
 3-character units
From: Joe Perches <joe@perches.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Nov 2014 16:38:52 -0800
In-Reply-To: <1415405880-8520-1-git-send-email-jwerner@chromium.org>
References: <1415405880-8520-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 16:18 -0800, Julius Werner wrote:
> Checkpatch flags CamelCase identifiers in strict mode, but it has a
> feature to ignore parts with only two characters to allow for SI units
> like mV or uA. Unfortunately, not all SI units fit in two characters,
> and not all are lower case followed by upper case.
> 
> This patch changes the check from [a-z][A-Z] to [a-zA-Z]{1,3} (any
> combination of up to three lower and upper case characters), so that it
> will also allow units like MHz, As or KiB.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4055,8 +4055,8 @@ sub process {
>  			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
>  #Ignore Page<foo> variants
>  			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
> -#Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
> -			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/) {
> +#Ignore SI style variants like nS, mV, MHz and dB (ie: max_uV, regulator_min_uA_show)
> +			    $var !~ /^(?:[a-z_]*?)_?[a-zA-Z]{1,3}(?:_[a-z_]+)?$/) {
>  				while ($var =~ m{($Ident)}g) {
>  					my $word = $1;
>  					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);

I think this may miss too many uses like pDB and
other variables used for hungarian notations.

It may be better to enumerate the specific character
sequences to exempt.

