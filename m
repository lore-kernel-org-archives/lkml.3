Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaK1SuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:50:17 -0500
Received: from smtprelay0035.hostedemail.com ([216.40.44.35]:33057 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750994AbaK1SuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:50:16 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:152:355:379:541:599:960:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2196:2199:2393:2553:2559:2562:2733:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6119:6261:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:13894:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: range59_595c8838da92b
X-Filterd-Recvd-Size: 2541
Message-ID: <1417200612.4305.7.camel@perches.com>
Subject: Re: [PATCH] scripts/kconfig/menu.c warning for uninitialized "jump"
From: Joe Perches <joe@perches.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Peter Teoh <htmldeveloper@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 28 Nov 2014 10:50:12 -0800
In-Reply-To: <547879BE.4050502@suse.cz>
References: <CAHnt0GXeTAmAaa3queHDP2kssYESgHLmohXj41F04gQvcB__ug@mail.gmail.com>
	 <547879BE.4050502@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-28 at 14:33 +0100, Michal Marek wrote:
> On 2014-11-21 05:22, Peter Teoh wrote:
> > This warning was found in v3.18-rc3-68-g20f3963 of Linus git-tree.
> > 
> >   SHIPPED scripts/kconfig/zconf.hash.c
> >   HOSTCC  scripts/kconfig/zconf.tab.o
> > In file included from scripts/kconfig/zconf.tab.c:2537:0:
> > scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> > scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used
> > uninitialized in this function [-Wmaybe-uninitialized]
> >      jump->offset = strlen(r->s);
> >                   ^
> > scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
> >   struct jump_key *jump;
> >                    ^
> 
> First of all, the warning is bogus (the condition under which 'jump' is
> used is stronger than that under which 'jump' is initialized). But since
> people have been reporting the warning on and off for some time, we have
> to shut it up somehow, as the affected gcc versions are not dying out,
> apparently.
> 
> 
> > -                       if (head && location && menu == location)
> > +                       if (head && location && (menu == location) && (jump))
> >                                 jump->offset = strlen(r->s);
> 
> Let's assume, for the sake of argument, that gcc is right and jump may
> be uninitialized here. Then the added check for jump being non-null just
> tests an uninitialized variable and thus behaves randomly. It prevents
> the code from writing to NULL->offset, but does not prevent it from
> writing to <random address>->offset.

Maybe the 'right' thing to do is to mark the xmalloc
prototype as "__attribute__((returns_nonnull))"


