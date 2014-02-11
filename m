Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaBKTEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:04:12 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55253 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaBKTEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:04:08 -0500
Date: Tue, 11 Feb 2014 11:04:04 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>,
        "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 15/28] Remove TI_AEMIF
Message-ID: <20140211190404.GI18440@ld-irv-0074>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-16-git-send-email-richard@nod.at>
 <1391979242.25855.37.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391979242.25855.37.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Ivan, others

On Sun, Feb 09, 2014 at 09:54:02PM +0100, Paul Bolle wrote:
> On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> > The symbol is an orphan, get rid of it.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  drivers/mtd/nand/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> > index 90ff447..a195d57 100644
> > --- a/drivers/mtd/nand/Kconfig
> > +++ b/drivers/mtd/nand/Kconfig
> > @@ -465,7 +465,7 @@ config MTD_NAND_SH_FLCTL
> >  
> >  config MTD_NAND_DAVINCI
> >          tristate "Support NAND on DaVinci/Keystone SoC"
> > -        depends on ARCH_DAVINCI || (ARCH_KEYSTONE && TI_AEMIF)
> > +        depends on ARCH_DAVINCI || ARCH_KEYSTONE
> >          help
> >  	  Enable the driver for NAND flash chips on Texas Instruments
> >  	  DaVinci/Keystone processors.
> 
> What's strange about the current dependency is that the only aemif code
> I could find lives at arch/arm/mach-davinci/aemif.c. Is that reachable
> for code in arch/arm/mach-keystone?

It looks like I merged this code before the supporting aemif driver [1] was
merged. I think this is harmless, and so I plan to leave it as-is for
now. Or if Ivan prefers, I can drop the Keystone dependency entirely
until it is ready.

https://lkml.org/lkml/2013/11/20/283

Brian
