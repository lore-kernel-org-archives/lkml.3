Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaK0Js0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:48:26 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51346 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaK0JsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:48:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        jason@lakedaemon.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        kernel@stlinux.com
Subject: Re: [PATCH v2 2/8] irqchip: Supply new driver for STi based devices
Date: Thu, 27 Nov 2014 10:47:34 +0100
Message-ID: <2111250.BPZOtBCtcF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141127092901.GE4628@x1>
References: <1416932705-16880-1-git-send-email-lee.jones@linaro.org> <35179358.tOpRGufXmc@wuerfel> <20141127092901.GE4628@x1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Kf7/cKRrK+CW2mLkeBvC14y9aMhYG5vaXtDa116g0z1
 LFg38zpzmrK127tayz2/l+3/MSqeyUGrpwOWoRJtuG4nlCMJZU
 6ueoMxzlqZBKOGAc+pmuZ7fvdV1PfaEziFOlPM02L7DCKzvxJD
 CuMlPmMFRvkmCKsqr9emV+zAY80CSWaWwfohTDF/D0xVd6vGpX
 XGyvBEMm9g2KtjfNn2AvUq2Ytkl7pOkP9PTpTxQMQeDzlhFnu5
 bKTZlppZQkN9rJ9lOUIXwE3yiLhHd2S++y+ksilu432hphxXq0
 kLgpEuRg4ZqtSuy05HXm+VaqrmXrvIIr2hA5YAT5+Fqncfw3Lt
 IH9YrcQ9hYC6GUi0EeFE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 09:29:01 Lee Jones wrote:
> On Thu, 27 Nov 2014, Arnd Bergmann wrote:
> > On Thursday 27 November 2014 09:02:55 Lee Jones wrote:
> > > On Tue, 25 Nov 2014, Arnd Bergmann wrote:
> > > 
> > > > On Tuesday 25 November 2014 16:24:59 Lee Jones wrote:
> > > > 
> > > > > diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> > > > > index b21f12f..e502f15 100644
> > > > > --- a/drivers/irqchip/Kconfig
> > > > > +++ b/drivers/irqchip/Kconfig
> > > > > @@ -93,6 +93,13 @@ config RENESAS_IRQC
> > > > >     bool
> > > > >     select IRQ_DOMAIN
> > > > >  
> > > > > +config ST_IRQCHIP
> > > > > +   bool
> > > > > +   select REGMAP
> > > > > +   select MFD_SYSCON
> > > > > +   help
> > > > > +     Enables SysCfg Controlled IRQs on STi based platforms.
> > > > > +
> > > > 
> > > > I'm confused by the purpose of this code. It's apparently a driver
> > > > in drivers/irqchip, the Kconfig symbol contains the string IRQCHIP,
> > > > yet it doesn't actually register an irq_chip.
> > > > 
> > > > Also, the name is a bit too generic, ST has lots of different irqchips,
> > > > and this apparently isn't even one of them 
> > > 
> > > Hmm... now you're going to ask me to remember who I had the
> > > conversation with that alluded to this as the best location for this
> > > driver.  Unfortunately, I cannot.  Can you think of a better place to
> > > put it then?
> > 
> > I suspect it's in the right place but should actually be an irqchip
> > driver. I'm having trouble understanding what this code actually does,
> > can you you explain the functionality in more detail so we can figure
> > out what to do with it?
> 
> In the simplest terms it's an IRQ unmasker.  A9 Core IRQs are disabled
> on boot; PMU, CTI (CoreSight), PL310_L2 and EXT.  In order for you to
> make use of them they need to be unmasked in SYSCFG.

So you just apply static configuration once, or are there reasons why you
would mask the interrupts again later?

If it's all static, why doesn't the boot loader unmask all interrupts before
starting the kernel?

	Arnd
