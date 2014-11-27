Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaK0J3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:29:12 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:41990 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaK0J3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:29:07 -0500
Date: Thu, 27 Nov 2014 09:29:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        jason@lakedaemon.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        kernel@stlinux.com
Subject: Re: [PATCH v2 2/8] irqchip: Supply new driver for STi based devices
Message-ID: <20141127092901.GE4628@x1>
References: <1416932705-16880-1-git-send-email-lee.jones@linaro.org>
 <2433040.4NqTrOMmEE@wuerfel>
 <20141127090255.GD4628@x1>
 <35179358.tOpRGufXmc@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35179358.tOpRGufXmc@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Arnd Bergmann wrote:

> On Thursday 27 November 2014 09:02:55 Lee Jones wrote:
> > On Tue, 25 Nov 2014, Arnd Bergmann wrote:
> > 
> > > On Tuesday 25 November 2014 16:24:59 Lee Jones wrote:
> > > 
> > > > diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> > > > index b21f12f..e502f15 100644
> > > > --- a/drivers/irqchip/Kconfig
> > > > +++ b/drivers/irqchip/Kconfig
> > > > @@ -93,6 +93,13 @@ config RENESAS_IRQC
> > > >     bool
> > > >     select IRQ_DOMAIN
> > > >  
> > > > +config ST_IRQCHIP
> > > > +   bool
> > > > +   select REGMAP
> > > > +   select MFD_SYSCON
> > > > +   help
> > > > +     Enables SysCfg Controlled IRQs on STi based platforms.
> > > > +
> > > 
> > > I'm confused by the purpose of this code. It's apparently a driver
> > > in drivers/irqchip, the Kconfig symbol contains the string IRQCHIP,
> > > yet it doesn't actually register an irq_chip.
> > > 
> > > Also, the name is a bit too generic, ST has lots of different irqchips,
> > > and this apparently isn't even one of them 
> > 
> > Hmm... now you're going to ask me to remember who I had the
> > conversation with that alluded to this as the best location for this
> > driver.  Unfortunately, I cannot.  Can you think of a better place to
> > put it then?
> 
> I suspect it's in the right place but should actually be an irqchip
> driver. I'm having trouble understanding what this code actually does,
> can you you explain the functionality in more detail so we can figure
> out what to do with it?

In the simplest terms it's an IRQ unmasker.  A9 Core IRQs are disabled
on boot; PMU, CTI (CoreSight), PL310_L2 and EXT.  In order for you to
make use of them they need to be unmasked in SYSCFG.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
