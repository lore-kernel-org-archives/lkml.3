Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbaGVWvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:51:33 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65367 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbaGVWv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:51:29 -0400
Date: Tue, 22 Jul 2014 15:51:25 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>, Olof Johansson <olof@lixom.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v8 02/11] power: reset: Add reboot driver for brcmstb
Message-ID: <20140722225125.GI28323@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
 <62122849.RXJHvac7Iy@wuerfel>
 <20140722200213.GF28323@ld-irv-0074>
 <5224854.YNJjMxFltp@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5224854.YNJjMxFltp@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Sebastian

On Tue, Jul 22, 2014 at 11:02:07PM +0200, Arnd Bergmann wrote:
> On Tuesday 22 July 2014 13:02:13 Brian Norris wrote:
> > How about a third option, where we drop the 'select' statement and
> > set POWER_RESET_BRCMSTB to be 'default y'? Then we don't have to modify
> > the defconfig, and it gives the added bonus of choosing a sane default
> > even if you're not based on the multi_v7_defconfig. i.e.:
> > 
> > diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> > index 58c01aed9752..634de7b7fd28 100644
> > --- a/arch/arm/mach-bcm/Kconfig
> > +++ b/arch/arm/mach-bcm/Kconfig
> > @@ -94,7 +94,6 @@ config ARCH_BRCMSTB
> >         select MIGHT_HAVE_PCI
> >         select HAVE_SMP
> >         select HAVE_ARM_ARCH_TIMER
> > -       select POWER_RESET_BRCMSTB
> >         select BRCMSTB_GISB_ARB
> >         select BRCMSTB_L2_IRQ
> >         help
> > diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> > index fcb9825debe5..ab5d57e2766d 100644
> > --- a/drivers/power/reset/Kconfig
> > +++ b/drivers/power/reset/Kconfig
> > @@ -23,6 +23,7 @@ config POWER_RESET_AXXIA
> >  config POWER_RESET_BRCMSTB
> >         bool "Broadcom STB reset driver"
> >         depends on POWER_RESET && ARCH_BRCMSTB
> > +       default y
> >         help
> >           This driver provides restart support for ARM-based Broadcom STB
> >           boards.
> 
> I don't like this too much. Why do you want to allow disabling the
> driver if you make it 'default y' in the first place?

Not much of a reason, but I thought configurability is a positive.
There's really not a good reason to not have this driver though; I can't
imagine someone wanting to build our platform but not be able to reboot
it.

> We try to avoid 'default y' for user-selectable drivers in general.

I didn't know that. A default is technically different than "should a
user be able to disable this," but I suppose the policy makes sense.

> I noticed that in my example, I was missing the default.

I see. That's why I immediately ruled it out.

> It should have been 
> 
> config POWER_RESET_BRCMSTB
>         bool "Broadcom STB reset driver" if COMPILE_TEST
>         depends on POWER_RESET && ARM
> 	default ARCH_BRCMSTB

OK, that's OK with me if it's OK with Sebastian, et al. Respin coming
soon, separate from the mach-bcm and ARM stuff...

(BTW, we might consider rewriting the other config entries to be
similar, if we really want to make this things consistently
nitpick-proof.)

> This way, it always gets selected when ARCH_BRCMSTB is on and
> COMPILE_TEST is off. With COMPILE_TEST enabled, it defaults to
> ARCH_BRCMSTB but can be enabled or disabled for the purpose
> of compile testing.

Thanks,
Brian
