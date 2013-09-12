Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3ILOkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:40:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54412 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3ILOke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:40:34 -0400
Date: Thu, 12 Sep 2013 15:33:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Fan Rong <cinifr@gmail.com>, "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/4] Add physical count arch timer support for
	clocksource in ARMv7.
Message-ID: <20130912143340.GL12758@n2100.arm.linux.org.uk>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com> <1378968687-8200-4-git-send-email-cinifr@gmail.com> <20130912112452.GA22013@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912112452.GA22013@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 12:24:52PM +0100, Mark Rutland wrote:
> On Thu, Sep 12, 2013 at 07:51:26AM +0100, Fan Rong wrote:
> > diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> > index 41c6946..a4981d2 100644
> > --- a/drivers/clocksource/Kconfig
> > +++ b/drivers/clocksource/Kconfig
> > @@ -109,3 +109,11 @@ config VF_PIT_TIMER
> >  	bool
> >  	help
> >  	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> > +menu "Clock Source"
> > +
> > +config ARM_ARCH_TIMER_USE_PHYCNT
> > +	bool "Use Physical Count Timer"
> > +	depends on ARM_ARCH_TIMER
> > +	help
> > +          If bootloader dont set Virtual Offset register,Physical Count Timer is needed to replace Virtual Count Timer.
> > +endmenu
> 
> This cannot be a compile-time option as above in a multiplatform build.
> Other paltforms (e.g. KVM guests) *must* use the virtual counters to get
> any semblance of a consistent view of time.

Also, for future reference:

1. Use a single blank lines to separate thing like 'menu' and 'endmenu'.
2. Wrap your the help sensibly, don't put it all on one line.
3. It's conventional to use tabs up to below "help" and then two spaces
   to indent the help text.
4. "," always has one space after it.

Thanks.
