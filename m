Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3GKLiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:38:21 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:36170 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904Ab3GKLiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:38:19 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chao Xie <cxie4@marvell.com>
Date: Thu, 11 Jul 2013 04:35:16 -0700
Subject: RE: [PATCH V3 3/3] ARM: mmp: bring up pxa988 with device tree
 support
Thread-Topic: [PATCH V3 3/3] ARM: mmp: bring up pxa988 with device tree
 support
Thread-Index: Ac588IELUvWBANohQOeCGCtDfYXuXQBOJvfw
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FE11@SC-VEXCH4.marvell.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
 <1373352166-10064-4-git-send-email-zhangwm@marvell.com>
 <201307100005.21769.arnd@arndb.de>
In-Reply-To: <201307100005.21769.arnd@arndb.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6BBcPpZ022641

Arnd,



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: 2013Äê7ÔÂ10ÈÕ 6:05
> To: Neil Zhang
> Cc: grant.likely@linaro.org; haojian.zhuang@gmail.com;
> devicetree-discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; Chao Xie
> Subject: Re: [PATCH V3 3/3] ARM: mmp: bring up pxa988 with device tree
> support
> 
> On Tuesday 09 July 2013, Neil Zhang wrote:
> > +	soc {
> > +		compatible = "simple-bus";
> > +		#address-cells = <1>;
> > +		#size-cells = <1>;
> > +		interrupt-parent = <&gic>;
> > +		ranges;
> > +
> > +		gic: interrupt-controller@d1dfe100 {
> > +			compatible = "arm,cortex-a9-gic";
> > +			#interrupt-cells = <3>;
> > +			#address-cells = <1>;
> > +			interrupt-controller;
> > +			reg = <0xd1dff000 0x1000>,
> > +			      <0xd1dfe100 0x0100>;
> > +		};
> > +
> > +		L2: l2-cache-controller@d1dfb000 {
> > +			compatible = "arm,pl310-cache";
> > +			reg = <0xd1dfb000 0x1000>;
> > +			arm,data-latency = <2 1 1>;
> > +			arm,tag-latency = <2 1 1>;
> > +			arm,pwr-dynamic-clk-gating;
> > +			arm,pwr-standby-mode;
> > +			cache-unified;
> > +			cache-level = <2>;
> > +		};
> > +
> > +		local-timer@d1dfe600 {
> > +			compatible = "arm,cortex-a9-twd-timer";
> > +			reg = <0xd1dfe600 0x20>;
> > +			interrupts = <1 13 0x304>;
> > +		};
> > +
> > +		axi@d4200000 {	/* AXI */
> > +			compatible = "simple-bus";
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			ranges = <0xd4200000 0xd4200000 0x00200000>;
> > +
> > +			intc: wakeupgen@d4282000 {
> > +				compatible = "marvell,mmp-intc";
> > +				reg = <0xd4282000 0x1000>;
> > +				marvell,intc-wakeup = <0x114 0x3
> > +						    0x144 0x3>;
> > +			};
> > +		};
> 
> I am guessing that the structure does not actually reflect the hardware.
> 
> Shouldn't AXI be the top-level bus, with the other stuff under it?
> 
> > +
> > +
> > +			uart1: uart@d4017000 {
> > +				compatible = "marvell,mmp-uart";
> > +				reg = <0xd4017000 0x1000>;
> > +				interrupts = <0 27 0x4>;
> > +				status = "disabled";
> > +			};
> 
> The uart node should be called "serial@d4017000" instead of
> "uart@d4017000".

Thanks for the catch!

> 
> > diff --git a/arch/arm/mach-mmp/reset.c b/arch/arm/mach-mmp/reset.c
> new
> > file mode 100644 index 0000000..b90ec54
> > --- /dev/null
> > +++ b/arch/arm/mach-mmp/reset.c
> > @@ -0,0 +1,66 @@
> > +/*
> > + * linux/arch/arm/mach-mmp/reset.c
> 
> I think this could just be part of the smp.c file.

Sorry, but which smp.c do you mean?

> 
> > + *
> > + * Author:	Neil Zhang <zhangwm@marvell.com>
> > + * Copyright:	(C) 2012 Marvell International Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + modify
> > + * it under the terms of the GNU General Public License as published
> > + by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/smp.h>
> > +
> > +#include <asm/io.h>
> > +#include <asm/cacheflush.h>
> > +#include <asm/mach/map.h>
> > +
> > +#include <mach/addr-map.h>
> > +
> > +#include "reset.h"
> > +
> > +#define PMU_CC2_AP			APMU_REG(0x0100)
> > +#define CIU_CA9_WARM_RESET_VECTOR	CIU_REG(0x00d8)
> 
> You should not hardcode the addresses here, better find them from the
> device tree.

Thanks for your suggestion, we will consider it.

> > +
> > +#define CPU_CORE_RST(n)	(1 << ((n) * 4 + 16))
> > +#define CPU_DBG_RST(n)	(1 << ((n) * 4 + 18))
> > +#define CPU_WDOG_RST(n)	(1 << ((n) * 4 + 19))
> 
> This should probably go into a reset controller driver, in drivers/reset/
> 

It should not related to drivers/reset/.
What this file does is to set reset handler for core bootup or reset from power down (suspend or C2 power down).

> 	Arnd

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
