Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaJOCpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:45:40 -0400
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:59252 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755772AbaJOCpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:45:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2689:2828:2892:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:4384:5007:6119:6261:7903:8527:10004:10400:10848:11026:11232:11657:11658:11914:12043:12295:12296:12517:12519:12679:12740:13161:13229:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pear56_13ef1267a423c
X-Filterd-Recvd-Size: 3238
Message-ID: <1413340944.7475.5.camel@perches.com>
Subject: Re: get_maintainers.pl doesn't actually get the real MAINTAINERS?
From: Joe Perches <joe@perches.com>
To: Scott Branden <sbranden@broadcom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        swarren@wwwdotorg.org
In-Reply-To: <543DDC6D.8030701@broadcom.com>
References: <543DD959.2060801@broadcom.com>
	 <1413339973.7475.1.camel@perches.com> <543DDC6D.8030701@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 14 Oct 2014 19:42:24 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.12.7-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 19:31 -0700, Scott Branden wrote:
> On 14-10-14 07:26 PM, Joe Perches wrote:
> > On Tue, 2014-10-14 at 19:18 -0700, Scott Branden wrote:
> >> Hello,
> >>
> >> I try running scripts/get_maintainers.pl but it doesn't seem to get the
> >> real maintainers properly.  Please note this is run against the current
> >> MAINTAINERS file.
> >>
> >> One Example:  I would expect drivers/mmc/host/sdhci-bcm2835.c to be
> >> maintained by Stephen Warren based on drivers/*/*bcm2835* below.
> >
> > get_maintainers doesn't use * as a depth wildcard
> >
> > */ matches a single top level directory level
> > */*/ matches one level below the top directory level.
> >
> >>    But
> >> the get_maintainers.pl script does not seem to process the information
> >> in such a way.  So what needs to be corrected - the script or the syntax
> >> used in the MAINTAINERS file?
> >>
> >> BROADCOM BCM2835 ARM ARCHICTURE
> >> M:	Stephen Warren <swarren@wwwdotorg.org>
> >> L:	linux-rpi-kernel@lists.infradead.org (moderated for non-subscribers)
> >> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-rpi.git
> >> S:	Maintained
> >> F:	arch/arm/mach-bcm/board_bcm2835.c
> >> F:	arch/arm/boot/dts/bcm2835*
> >> F:	arch/arm/configs/bcm2835_defconfig
> >> F:	drivers/*/*bcm2835*
> >
> > F:	drivers/*/*/*bmc2835*
> Thanks for the explanation.  So somebody should really do the following 
> to maintain any files no matter where they are located?
> F:	*/*bcm2835*
> F:	*/*/*bcm2835*
> F:	*/*/*/*bcm2835*
> F:	*/*/*/*/*bcm2835*
> F:	*/*/*/*/*/*bcm2835*
> F:	*/*/*/*/*/*/*bcm2835*
> F:	*/*/*/*/*/*/*/*bcm2835*
> 
> Or, can a recursive option be added in the script?

Hasn't been much of a need for that but knock yourself
out if you think something like a ... might be useful.

Look for function "file_match_pattern" if you want
to extend it.

There is a file name matching option "N:" that
does something similar.

Difference is that F: patterns matches do not
use git history by default to find other people
that have submitted patches, N: does.


