Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966285AbaLLLQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:16:49 -0500
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:59416 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966236AbaLLLQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:16:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6261:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spark70_f647a31343a
X-Filterd-Recvd-Size: 2005
Message-ID: <1418383004.18092.46.camel@perches.com>
Subject: Re: [PATCH 1/3] checkpatch: Check for use of disallowed macros
From: Joe Perches <joe@perches.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 12 Dec 2014 03:16:44 -0800
In-Reply-To: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-12 at 11:51 +0100, Rasmus Villemoes wrote:
> Since fe7c36c7 ("Makefile: Build with -Werror=date-time if the
> compiler supports it"), use of __DATE__, __TIME__, __TIMESTAMP__ has
> been disallowed. This hasn't prevented a few new users from creeping
> in. Make checkpatch complain.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -3008,6 +3008,12 @@ sub process {
>  		$line =~ s@//.*@@;
>  		$opline =~ s@//.*@@;
>  
> +
> +# Use of __DATE__, __TIME__, __TIMESTAMP__ is not allowed
> +		if ($line =~ m/\b__(?:DATE|TIME|TIMESTAMP)__\b/) {
> +		    ERROR("DATETIME", "Do not use the macros __DATE__, __TIME__ and __TIMESTAMP__\n" . $herecurr)

I'd probably add that adjacent to the existing __FUNCTION__
test near line 5000 and make the test show the specific macro
used.

Maybe add __LINE__ and __FILE__ as a separate --strict test too.

Also the error message should should show the specific macro and
if __DATE__ and __TIME__ are on the same line, the error should
be emitted twice.

Maybe:
		while ($line =~ /\b(__(?:DATE|TIME|TIMESTAMP)__)\b/g) {
			ERROR("DATETIME",
			      "Do not use the $1 macro\n" . $herecurr);
		}
 

