Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3FFQ0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:26:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64533 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3FFQ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:26:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Neil Zhang <zhangwm@marvell.com>
Subject: Re: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
Date: Thu, 6 Jun 2013 18:26:19 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Xie <cxie4@marvell.com>
References: <1369969115-4279-1-git-send-email-zhangwm@marvell.com> <1726105.oKcjXShr89@wuerfel> <175CCF5F49938B4D99B2E3EF7F558EBE3B3BA09137@SC-VEXCH4.marvell.com>
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE3B3BA09137@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <201306061826.19551.arnd@arndb.de>
X-Provags-ID: V02:K0:k1kdPK6YD12qf+OD/kHa5H3V5uA5+53RZqPh0gyKwua
 AutmHcUYTqQ6Ji8W7hSfMJoIIwKQ0gmvytbIT2uI9ZT9mgJ61M
 VNlBzCH73Y0M+Beb9DolxoVHMxacJVY/oaK0AEeVQT8NtPraAX
 uFlrUxvrAtEKqRkAhZZMxuhz1IaLRbiOmNFow+/3Dpf8VR1I4k
 eOkH9oiDWdQmq3YISSeb9YkwMH89UCSPEasz+vvSZ+gLkBHP6w
 P+g8EprxHc4nFq4TFXyQGqRuycd/B+paTUKCfVCt+DzhMK2JOo
 3bLbeT+wJp6KhEzPxRaZbdl1jRIxZ8VJCAKhiYGkGzezf3zWwQ
 wrMHa2RFeqi0xvXFNMts=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 June 2013, Neil Zhang wrote:
> > > diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
> > > index ebdda83..0955191 100644
> > > --- a/arch/arm/mach-mmp/Kconfig
> > > +++ b/arch/arm/mach-mmp/Kconfig
> > > @@ -107,6 +107,16 @@ config MACH_MMP2_DT
> > >  	  Include support for Marvell MMP2 based platforms using
> > >  	  the device tree.
> > >
> > > +config MACH_MMPX_DT
> > > +	bool "Support no-PJ/PJ4(ARMv7) platforms from device tree"
> > > +	depends on !CPU_MOHAWK && !CPU_PJ4
> > > +	select CPU_PXA988
> > > +	select USE_OF
> > > +	select PINCTRL
> > > +	select PINCTRL_SINGLE
> > 
> > Why would this be mutually exclusive with PJ4? Cortex-A9 and PJ4 are both
> > ARMv7 based, so we should be able to have them in the same kernel.
> 
> The MACH_MMPX_DT here is for standard ARM core based SoC.
> But PJ4 is modified by Marvell, which includes IWMMXT.

That should not stop us from supporting them with the same kernel.
We can already build a kernel that will work with IWMMXT on
ArmadaXP (PJ4B) and Calxeda Highbank (Cortex-A9) for instance.

> > __initdata = {
> > >  		.virtual	= (unsigned long)AXI_VIRT_BASE,
> > >  		.length		= AXI_PHYS_SIZE,
> > >  		.type		= MT_DEVICE,
> > > -	},
> > > +	}, {
> > > +		.pfn		= __phys_to_pfn(MMP_CORE_PERIPH_PHYS_BASE),
> > > +		.virtual	= (unsigned long)MMP_CORE_PERIPH_VIRT_BASE,
> > > +		.length		= MMP_CORE_PERIPH_PHYS_SIZE,
> > > +		.type		= MT_DEVICE,
> > > +	}
> > >  };
> > >
> > >  void __init mmp_map_io(void)
> > 
> > What is this needed for?
> 
> This function is used to static map the device registers.

I understand what map_io does. Why do you need a static mapping?

> > > +/* PXA988 */
> > > +static const struct of_dev_auxdata pxa988_auxdata_lookup[] __initconst
> > = {
> > > +	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0",
> > NULL),
> > > +	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1",
> > NULL),
> > > +	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2",
> > NULL),
> > > +	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0",
> > NULL),
> > > +	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1",
> > NULL),
> > > +	OF_DEV_AUXDATA("mrvl,mmp-gpio", 0xd4019000, "pxa-gpio", NULL),
> > > +	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
> > > +	{}
> > > +};
> > 
> > Why do you need auxdata?
> 
> Two reasons:
> 1. some of the device still need platform data at this time.

None of the ones above do apparently.

> 2. we use device name as clk name.
> Will change it later, but need some time.

If you have no platform_data, I think you should modify the clkdev
lookup table to refer to the DT based names so you no longer have
to pass auxdata.

The long term solution of course is to describe the clocks in the
device tree as well.

> > > +void __init pxa988_dt_init_timer(void) {
> > > +	extern void __init mmp_dt_init_timer(void);
> > 
> > You should never put 'extern' declarations into a .c file.
> > 
> > > +	/*
> > > +	 * Is is a SOC timer, and will be used for broadcasting
> > > +	 * when local timers are disabled.
> > > +	 */
> > > +	mmp_dt_init_timer();
> > > +
> > > +	clocksource_of_init();
> > > +}
> > 
> > Please just change the mmp_dt_init_timer function to use
> > CLOCKSOURCE_OF_DECLARE(), and if possible move the file to
> > drivers/clocksource.
> 
> Yes, we will change to use CLOCKSOURCE_OF_DECLARE later.
> But it need time, so let's keep it at this time.

It should be a trivial change, I'm not asking you to put the clocks
in the DT right away, just change the way that this function gets
called.

	Arnd
