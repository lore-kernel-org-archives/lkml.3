Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3K2Xo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 18:44:56 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43328 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3K2Xoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 18:44:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dmaengine@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] lib/vsprintf.c: add %paD format specifier for dma_addr_t types
Date: Sat, 30 Nov 2013 00:44:53 +0100
Message-ID: <2554479.4o3B19tG25@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385763040.12210.34.camel@joe-AO722>
References: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com> <1385729760.1871.23.camel@smile> <1385763040.12210.34.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Friday 29 November 2013 14:10:40 Joe Perches wrote:
> On Fri, 2013-11-29 at 14:56 +0200, Andy Shevchenko wrote:
> > On Thu, 2013-11-28 at 10:32 -0800, Joe Perches wrote:
> > > On Thu, 2013-11-28 at 13:28 +0200, user.email wrote:
> > > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > 
> > > > Add the %paD format specifier for printing a dma_addr_t type, since
> > > > the
> > > > DMA address size on some platforms can vary based on build options,
> > > > regardless of the native integer type.
> > > 
> > > OK, but I prefer this one because upper case is
> > > sometimes used to specify upper case only output.
> > > ala %x %X and %pUl %pUL.
> > 
> > No objections.
> > 
> > > https://lkml.org/lkml/2013/9/12/483
> > 
> > Hmm... Still not in kernel. Do you know reason why it so?
> 
> It was just for discussion and I didn't sign or push it
> to anyone else.
> 
> What's slightly funny is how far back dma_addr_t printk
> discussions go.
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0202.1/1221.html
> 
> Anyway, if you think you're going to do a lot of
> transforms of printk("%x", dma_addr_t) with or without
> (unsigned long long) or (u64) casts, I'll submit a signed
> patch to Andrew.
> 
> Let me know.

Just FYI, I've recently submitted a couple of patches that cast dma_addr_t for 
printk purpose, which resulted in Andy proposing a printk format extension 
instead.

> In an aside for Julia Lawall (added to cc's), I tried to
> do a spatch grep for dma_addr_t (and phys_addr_t) types
> that were cast to (unsigned long) or (u64) but I was
> unsuccessful.  Is there something else I need to do?
> 
> $ cat dma_addr_t.cocci
> @@
> dma_addr_t foo;
> @@
> 
> * (unsigned long long)foo;
> 
> $ cat t.c
> #include <linux/types.h>
> #include <linux/printk.h>
> 
> int foo(dma_addr_t a)
> {
> 	printk("test: %llx\n", (unsigned long long)a);
> }
> 
> $ spatch --all-includes --local-includes  -I include/ --sp-file
> dma_addr_t.cocci t.c init_defs_builtins:
> /usr/local/share/coccinelle/standard.h
> HANDLING: t.c
> $
-- 
Regards,

Laurent Pinchart

