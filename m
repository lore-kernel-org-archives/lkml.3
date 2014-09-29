Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaI2Qam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:30:42 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:44581 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753249AbaI2Qal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:30:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 20,1.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2565:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3291:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6691:7652:7903:8985:9010:9025:10009:10400:10848:10967:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: bird67_22b6d3cce3d62
X-Filterd-Recvd-Size: 2298
Message-ID: <1412008235.4302.31.camel@joe-AO725>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Sep 2014 09:30:35 -0700
In-Reply-To: <20140929121534.34c3ebd9@gandalf.local.home>
References: <20140926143721.52206f95@gandalf.local.home>
	 <20140929144121.GA30562@pathway.suse.cz>
	 <20140929154711.GF7996@ZenIV.linux.org.uk>
	 <1412006881.4302.29.camel@joe-AO725>
	 <20140929121534.34c3ebd9@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 12:15 -0400, Steven Rostedt wrote:
> On Mon, 29 Sep 2014 09:08:01 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Mon, 2014-09-29 at 16:47 +0100, Al Viro wrote:
> > > On Mon, Sep 29, 2014 at 04:41:22PM +0200, Petr Mladek wrote:
> > > > Hmm, this inconsistency seems to be in more functions. I would divide
> > > > it into three categories:
> > []
> > > No.  _Any_ caller that decides to report that error to its caller is fucking
> > > broken.  We had some cases like that.
> > []
> > > And let's make seq_printf and friends return void.  Any breakage we miss
> > > on grep will be caught by compiler.  Enough is enough.
> > 
> > https://lkml.org/lkml/2013/12/11/8
> > 
> 
> Since you like posting links:
> 
> https://lkml.org/lkml/2013/12/11/76
> 
> If you want to resurrect your patches, go ahead. I'll pull them into my
> list. Probably should rename seq_overflow() to seq_is_full(), which
> makes it sound less of an error.
> 
> And as Al noted, only fix what's there (just the places that check the
> return values). Don't add anything else.

I did that too

https://lkml.org/lkml/2013/12/11/713

Then I gave up.

