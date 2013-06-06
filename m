Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3FFCwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:52:41 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:54025 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755721Ab3FFCwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:52:39 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Xie <cxie4@marvell.com>
Date: Wed, 5 Jun 2013 19:48:16 -0700
Subject: RE: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
Thread-Topic: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
Thread-Index: Ac5d8YwzFHQCdgXWT4WVeeF04KT89ADxCabQ
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE3B3BA09137@SC-VEXCH4.marvell.com>
References: <1369969115-4279-1-git-send-email-zhangwm@marvell.com>
 <1369969115-4279-2-git-send-email-zhangwm@marvell.com>
 <1726105.oKcjXShr89@wuerfel>
In-Reply-To: <1726105.oKcjXShr89@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r562qmi5007306

Hi Arnd,

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: 2013Äê5ÔÂ31ÈÕ 19:25
> To: linux-arm-kernel@lists.infradead.org
> Cc: Neil Zhang; haojian.zhuang@gmail.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
> 
> On Friday 31 May 2013 10:58:35 Neil Zhang wrote:
> > bring up pxa988 with device tree support.
> >
> > Change-Id: I6fc869b7d5ff8dc6e4eb0042a89429200f7a9fb1
> 
> Please don't post silly extra headers like that.

Sorry for the noise, will remove it.

> 
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> 
> A couple of comments on the DT structure:
> 
> > +	gic: interrupt-controller@d1dfe100 {
> > +		compatible = "arm,cortex-a9-gic";
> > +		interrupt-controller;
> > +		#interrupt-cells = <3>;
> > +		reg = <0xd1dff000 0x1000>,
> > +		      <0xd1dfe100 0x0100>;
> > +	};
> > +
> > +	L2: l2-cache-controller@d1dfb000 {
> > +		compatible = "arm,pl310-cache";
> > +		reg = <0xd1dfb000 0x1000>;
> > +		arm,data-latency = <2 1 1>;
> > +		arm,tag-latency = <2 1 1>;
> > +		arm,pwr-dynamic-clk-gating;
> > +		arm,pwr-standby-mode;
> > +		cache-unified;
> > +		cache-level = <2>;
> > +	};
> > +
> > +	local-timer@d1dfe600 {
> > +		compatible = "arm,cortex-a9-twd-timer";
> > +		reg = <0xd1dfe600 0x20>;
> > +		interrupts = <1 13 0x304>;
> > +	};
> 
> Why are these all top-level devices, rather than part of the 'soc' node?

Yes, we can move it as child of soc.

> 
> > +	soc {
> > +		#address-cells = <1>;
> > +		#size-cells = <1>;
> > +		compatible = "simple-bus";
> > +		interrupt-parent = <&gic>;
> > +		ranges;
> > +
> > +		axi@d4200000 {	/* AXI */
> > +			compatible = "mrvl,axi-bus", "simple-bus";
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			reg = <0xd4200000 0x00200000>;
> > +			ranges;
> > +
> > +			intc: wakeupgen@d4282000 {
> > +				compatible = "mrvl,mmp-intc";
> > +				reg = <0xd4282000 0x1000>;
> > +				mrvl,intc-wakeup = <0x114 0x3
> > +						    0x144 0x3>;
> > +			};
> > +
> > +		};
> 
> What is a 'mrvl,axi-bus'? Is that different from ARM's AXI bus?
> 
> The documented vendor prefix for Marvell is 'marvell', not 'mrvl', please be
> consistent with that.
> 
> What is the purpose of the 'reg' property in the axi bus? I notice that it
> overlaps with its own children, wich seens very strange.
> Maybe you meant this:
> 
> 	axi {
> 		ranges = <0xd4200000 0xd4200000 0x00200000>;
> 		...
> 	};
> 
> > +		apb@d4000000 {	/* APB */
> > +			compatible = "mrvl,apb-bus", "simple-bus";
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			reg = <0xd4000000 0x00200000>;
> > +			ranges;
> 
> Same comments apply here.
> 
Thanks for the comments here, will modify it later.

> > diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
> > index ebdda83..0955191 100644
> > --- a/arch/arm/mach-mmp/Kconfig
> > +++ b/arch/arm/mach-mmp/Kconfig
> > @@ -107,6 +107,16 @@ config MACH_MMP2_DT
> >  	  Include support for Marvell MMP2 based platforms using
> >  	  the device tree.
> >
> > +config MACH_MMPX_DT
> > +	bool "Support no-PJ/PJ4(ARMv7) platforms from device tree"
> > +	depends on !CPU_MOHAWK && !CPU_PJ4
> > +	select CPU_PXA988
> > +	select USE_OF
> > +	select PINCTRL
> > +	select PINCTRL_SINGLE
> 
> Why would this be mutually exclusive with PJ4? Cortex-A9 and PJ4 are both
> ARMv7 based, so we should be able to have them in the same kernel.

The MACH_MMPX_DT here is for standard ARM core based SoC.
But PJ4 is modified by Marvell, which includes IWMMXT.
 
> 
> > +	help
> > +	  Include support for Marvell MMP2 based platforms using
> > +	  the device tree.
> >  endmenu
> 
> You should probably change the help texts to say different things here, e.g.
> list the models supported under these.

Thanks for the remind, will modify it later.

> 
> > diff --git a/arch/arm/mach-mmp/common.c
> b/arch/arm/mach-mmp/common.c
> > index 9292b79..0c621bc 100644
> > --- a/arch/arm/mach-mmp/common.c
> > +++ b/arch/arm/mach-mmp/common.c
> > @@ -11,6 +11,10 @@
> >  #include <linux/init.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/io.h>
> > +#include <linux/ioport.h>
> > +#include <linux/of_address.h>
> >
> >  #include <asm/page.h>
> >  #include <asm/mach/map.h>
> > @@ -36,7 +40,12 @@ static struct map_desc standard_io_desc[]
> __initdata = {
> >  		.virtual	= (unsigned long)AXI_VIRT_BASE,
> >  		.length		= AXI_PHYS_SIZE,
> >  		.type		= MT_DEVICE,
> > -	},
> > +	}, {
> > +		.pfn		= __phys_to_pfn(MMP_CORE_PERIPH_PHYS_BASE),
> > +		.virtual	= (unsigned long)MMP_CORE_PERIPH_VIRT_BASE,
> > +		.length		= MMP_CORE_PERIPH_PHYS_SIZE,
> > +		.type		= MT_DEVICE,
> > +	}
> >  };
> >
> >  void __init mmp_map_io(void)
> 
> What is this needed for?

This function is used to static map the device registers.

> 
> > +/* PXA988 */
> > +static const struct of_dev_auxdata pxa988_auxdata_lookup[] __initconst
> = {
> > +	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0",
> NULL),
> > +	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1",
> NULL),
> > +	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2",
> NULL),
> > +	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0",
> NULL),
> > +	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1",
> NULL),
> > +	OF_DEV_AUXDATA("mrvl,mmp-gpio", 0xd4019000, "pxa-gpio", NULL),
> > +	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
> > +	{}
> > +};
> 
> Why do you need auxdata?

Two reasons:
1. some of the device still need platform data at this time.
2. we use device name as clk name.
Will change it later, but need some time.

> 
> > +void __init pxa988_dt_init_timer(void) {
> > +	extern void __init mmp_dt_init_timer(void);
> 
> You should never put 'extern' declarations into a .c file.
> 
> > +	/*
> > +	 * Is is a SOC timer, and will be used for broadcasting
> > +	 * when local timers are disabled.
> > +	 */
> > +	mmp_dt_init_timer();
> > +
> > +	clocksource_of_init();
> > +}
> 
> Please just change the mmp_dt_init_timer function to use
> CLOCKSOURCE_OF_DECLARE(), and if possible move the file to
> drivers/clocksource.

Yes, we will change to use CLOCKSOURCE_OF_DECLARE later.
But it need time, so let's keep it at this time.

> 
> > +static const char *pxa988_dt_board_compat[] __initdata = {
> > +	"mrvl,pxa988-dkb",
> > +	NULL,
> > +};
> > +
> > +DT_MACHINE_START(PXA988_DT, "Marvell PXA988 (Device Tree
> Support)")
> > +	.smp		= smp_ops(mmp_smp_ops),
> > +	.map_io		= mmp_map_io,
> > +	.init_irq	= irqchip_init,
> 
> You can leave out the init_irq, it's implicit.
> 
> > +	.init_time	= pxa988_dt_init_timer,
> > +	.init_machine	= pxa988_dt_init_machine,
> > +	.dt_compat	= pxa988_dt_board_compat,
> > +MACHINE_END
> 
> 
> > +
> > +static int __init mmp_entry_vector_init(void) {
> > +	int cpu;
> > +
> > +	/* We will reset from DDR directly by default */
> > +	writel(__pa(mmp_cpu_reset_entry), CIU_CA9_WARM_RESET_VECTOR);
> > +
> > +	for (cpu = 1; cpu < CONFIG_NR_CPUS; cpu++)
> > +		mmp_set_entry_vector(cpu, __pa(mmp_secondary_startup)); }
> > +
> > +early_initcall(mmp_entry_vector_init);
> 
> You need to check which machine you are running on here. Best just move
> the call into one of the init functions of the machine descriptor, e.g.
> init_machine or init_late.

Thanks for the remind, will use init_early for it.

> 
> CONFIG_NR_CPUS is probably the wrong constant to use here, it does not
> have to match the physically present CPU cores.

Thanks, will use nr_cpu_ids here.

> 
> 	Arnd

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
