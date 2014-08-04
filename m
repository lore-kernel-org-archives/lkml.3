Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaHDDrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:47:08 -0400
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:39034 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752081AbaHDDrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:47:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3874:4321:5007:7652:9040:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: house98_2b9f6aef145f
X-Filterd-Recvd-Size: 2073
Message-ID: <1407124017.16152.31.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Add test for printf formats with 0x that
 emit decimal
From: Joe Perches <joe@perches.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Date: Sun, 03 Aug 2014 20:46:57 -0700
In-Reply-To: <53DEF81B.1000303@hanshq.net>
References: <1407018043-648-1-git-send-email-hans@hanshq.net>
	 <1407026806.1835.21.camel@joe-AO725> <53DD8E17.1@hanshq.net>
	 <1407046215.1835.24.camel@joe-AO725> <53DED2E9.5090205@hanshq.net>
	 <1407112425.16152.10.camel@joe-AO725> <1407120645.16152.28.camel@joe-AO725>
	 <53DEF81B.1000303@hanshq.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-08-03 at 20:03 -0700, Hans Wennborg wrote:
> On 08/03/2014 07:50 PM, Joe Perches wrote:
> > 0x%<foo> should be used to emit hexadecimal values.
> >
> > Uses of 0x%[udi] emit decimal values but these should
> > probably instead use 0x%x variants.
> >
> > Warn on these uses.
> 
> Good idea!
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > @@ -4985,6 +4985,10 @@ sub process {
> >   		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
> >   			$string = substr($rawline, $-[1], $+[1] - $-[1]);
> >   			$string =~ s/%%/__/g;
> > +			if ($string =~ /(0x(?<!%)%[0-9.\*]*[Ll]*[udi])(?![xX])/) {
> 
> Maybe the regex should have a \b to check for a word boundary before the 
> 0 to avoid matching things like "800x%d"? (I don't know if that occurs 
> in the kernel, but I've seen it elsewhere.)

Maybe.

Code it to do the appropriate thing and test it too.
See if there any other cases that should be emitted.

cheers, Joe


