Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3K2WKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:10:49 -0500
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:35613 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753229Ab3K2WKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:10:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3657:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:6119:7576:7652:7903:8599:8603:8985:9025:9388:10004:10049:10400:10848:11026:11232:11658:11914:12043:12517:12519:12679:12682:12740:12776:13069:13311:13357:13618,0,RBL:none,CacheIP:none,Bayesian:0.5,
X-HE-Tag: title30_60eeb4ff2301
X-Filterd-Recvd-Size: 2846
Message-ID: <1385763040.12210.34.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf.c: add %paD format specifier for
 dma_addr_t types
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dmaengine@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Date: Fri, 29 Nov 2013 14:10:40 -0800
In-Reply-To: <1385729760.1871.23.camel@smile>
References: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1385663555.12210.19.camel@joe-AO722> <1385729760.1871.23.camel@smile>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-29 at 14:56 +0200, Andy Shevchenko wrote:
> On Thu, 2013-11-28 at 10:32 -0800, Joe Perches wrote:
> > On Thu, 2013-11-28 at 13:28 +0200, user.email wrote:
> > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > 
> > > Add the %paD format specifier for printing a dma_addr_t type, since the
> > > DMA address size on some platforms can vary based on build options,
> > > regardless of the native integer type.
> > 
> > OK, but I prefer this one because upper case is
> > sometimes used to specify upper case only output.
> > ala %x %X and %pUl %pUL.
> 
> No objections.
> 
> > https://lkml.org/lkml/2013/9/12/483
> 
> Hmm... Still not in kernel. Do you know reason why it so?

It was just for discussion and I didn't sign or push it
to anyone else.

What's slightly funny is how far back dma_addr_t printk
discussions go.

http://lkml.indiana.edu/hypermail/linux/kernel/0202.1/1221.html

Anyway, if you think you're going to do a lot of
transforms of printk("%x", dma_addr_t) with or without
(unsigned long long) or (u64) casts, I'll submit a signed
patch to Andrew.

Let me know.

In an aside for Julia Lawall (added to cc's), I tried to
do a spatch grep for dma_addr_t (and phys_addr_t) types
that were cast to (unsigned long) or (u64) but I was
unsuccessful.  Is there something else I need to do?

$ cat dma_addr_t.cocci
@@
dma_addr_t foo;
@@

* (unsigned long long)foo;

$ cat t.c
#include <linux/types.h>
#include <linux/printk.h>

int foo(dma_addr_t a)
{
	printk("test: %llx\n", (unsigned long long)a);
}

$ spatch --all-includes --local-includes  -I include/ --sp-file dma_addr_t.cocci t.c
init_defs_builtins: /usr/local/share/coccinelle/standard.h
HANDLING: t.c
$ 

