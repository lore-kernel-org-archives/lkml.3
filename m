Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3JNSEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:04:43 -0400
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:39059 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756254Ab3JNSEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:04:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6119:6691:7652:8531:8603:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boats43_8016ae1e88342
X-Filterd-Recvd-Size: 2649
Message-ID: <1381773878.25528.24.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Allow spaces before the ':' of a bitfield
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org,
        Nandini Hanumanthagowda <nandu.hgowda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Mon, 14 Oct 2013 11:04:38 -0700
In-Reply-To: <20131014180001.GA20139@jtriplet-mobl1>
References: <20131013121635.GA29395@nandinih-Inspiron-5521>
	 <20131013153943.GA27861@kroah.com>
	 <687af3bd-edc6-40cf-b994-0d0fdb7cd30d@googlegroups.com>
	 <20131014173207.GE16517@jtriplet-mobl1>
	 <1381773108.25528.22.camel@joe-AO722>
	 <20131014180001.GA20139@jtriplet-mobl1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 11:00 -0700, Josh Triplett wrote:
> On Mon, Oct 14, 2013 at 10:51:48AM -0700, Joe Perches wrote:
> > On Mon, 2013-10-14 at 10:32 -0700, Josh Triplett wrote:
> > > checkpatch warns about spaces both before and after the ':' separating a
> > > bitfield name from its width.  However, many drivers do put space before
> > > the : to line up the widths, which makes the definition significantly
> > > more readable; checkpatch should not warn about that.  Remove the
> > > warning for space before the ':' of a bitfield.
> > 
> > There are a _bunch_ of different styles used for
> > alignment of bitfields.
> > 
> > $ grep -rPh --include=*.[ch] \
> >   '(?:unsigned\s+|signed\s+|)(char|short|long|long\s+long|\w+_t|(?:__|)(?:u|s)(?:8|16|32|64))\s+\w+\s*:\s*\d+\s*(?:,|;)' *
> > 
> > spaces before colon
> > spaces after colon
> > aligned on bitfield size
> > 
> > I'd just as soon make it a --strict check.
> 
> I'd be fine with removing the check entirely, or making it --strict;
> however, even for --strict mode I'd suggest applying this patch, as I
> don't think checkpatch should ever prohibit spaces before the ':'.

Maybe something like that patch, but spaces probably
should be prohibited after the : in a bitfield either.

This style is pretty common

		u32 dma_address0                   :30;
		u32 dma_0No_update                 : 1;
		u32 dma_0start                     : 1;
		u32 dma_addr_size                  :24;
		u32 DMA_maxpackets                 : 8;


