Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaK0JPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:15:31 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:61935 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbaK0JPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:15:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        jason@lakedaemon.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        kernel@stlinux.com
Subject: Re: [PATCH v2 2/8] irqchip: Supply new driver for STi based devices
Date: Thu, 27 Nov 2014 10:15 +0100
Message-ID: <35179358.tOpRGufXmc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141127090255.GD4628@x1>
References: <1416932705-16880-1-git-send-email-lee.jones@linaro.org> <2433040.4NqTrOMmEE@wuerfel> <20141127090255.GD4628@x1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3KnrKtacOCFGNHlggOSDzrxAtVhLDCq4SvmrkpS0hgn
 OBESgfGY+c/3YtMpX9nfV86rbmUWSSe/HuhENxLYqJSKw/etfl
 sRSiRXMKdsMEqZE2+qERVsFte4tt6iiOrFPJeUxdWYEDGt9+5e
 mUgHW/VZY5zqsrQ5JTZRQnt0eOjHTUWsrhyAEzcURxFlHoF+R5
 4yal7IgPLPNjptu3IlAhAJpmMuW1aAetzSDi7ZsbsU6ajo6p3h
 jWRBmNIrTBqy3WMT+R/hxC/YtdEyYneGzZedtJbYdADA88QOV6
 mHMB+A9YeaaFYK6jKMyw4sfr+Cix+SU8LF/FcPe4Zmx8URvC+F
 f3XYwmKcB44OnU1+5IHA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 09:02:55 Lee Jones wrote:
> On Tue, 25 Nov 2014, Arnd Bergmann wrote:
> 
> > On Tuesday 25 November 2014 16:24:59 Lee Jones wrote:
> > 
> > > diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> > > index b21f12f..e502f15 100644
> > > --- a/drivers/irqchip/Kconfig
> > > +++ b/drivers/irqchip/Kconfig
> > > @@ -93,6 +93,13 @@ config RENESAS_IRQC
> > >     bool
> > >     select IRQ_DOMAIN
> > >  
> > > +config ST_IRQCHIP
> > > +   bool
> > > +   select REGMAP
> > > +   select MFD_SYSCON
> > > +   help
> > > +     Enables SysCfg Controlled IRQs on STi based platforms.
> > > +
> > 
> > I'm confused by the purpose of this code. It's apparently a driver
> > in drivers/irqchip, the Kconfig symbol contains the string IRQCHIP,
> > yet it doesn't actually register an irq_chip.
> > 
> > Also, the name is a bit too generic, ST has lots of different irqchips,
> > and this apparently isn't even one of them 
> 
> Hmm... now you're going to ask me to remember who I had the
> conversation with that alluded to this as the best location for this
> driver.  Unfortunately, I cannot.  Can you think of a better place to
> put it then?

I suspect it's in the right place but should actually be an irqchip
driver. I'm having trouble understanding what this code actually does,
can you you explain the functionality in more detail so we can figure
out what to do with it?

	Arnd
