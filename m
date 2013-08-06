Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab3HFScq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:32:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52337 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab3HFScp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:32:45 -0400
Message-ID: <5201414A.7050901@codeaurora.org>
Date: Tue, 06 Aug 2013 11:32:42 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: msm: Add support for MSM8974 Dragonboard
References: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org> <CABxcv==vAPZ0vP7Dichm5VPW=35cHBtXCcVzwtpHZTXDjF-yBw@mail.gmail.com>
In-Reply-To: <CABxcv==vAPZ0vP7Dichm5VPW=35cHBtXCcVzwtpHZTXDjF-yBw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/2013 7:01 AM, Javier Martinez Canillas wrote:
> On Tue, Aug 6, 2013 at 1:02 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
>> This patch adds basic board support for MSM8974 Dragonboard
>> which belongs to the Snapdragon 800 family.
>> For now, just support a basic machine with device tree.
>>
>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>> ---
>>   arch/arm/boot/dts/Makefile        |  3 ++-
>>   arch/arm/boot/dts/msm8974-db.dts  | 26 ++++++++++++++++++++++++++
>>   arch/arm/mach-msm/Kconfig         | 21 ++++++++++++++++++---
>>   arch/arm/mach-msm/Makefile        |  1 +
>>   arch/arm/mach-msm/board-dt-8974.c | 23 +++++++++++++++++++++++
>>   5 files changed, 70 insertions(+), 4 deletions(-)
>>   create mode 100644 arch/arm/boot/dts/msm8974-db.dts
>>   create mode 100644 arch/arm/mach-msm/board-dt-8974.c
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 641b3c9a..62cea36 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -97,7 +97,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
>>          kirkwood-openblocks_a6.dtb
>>   dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
>>   dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
>> -       msm8960-cdp.dtb
>> +       msm8960-cdp.dtb \
>> +       msm8974-db.dtb
>>   dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
>>          armada-370-mirabox.dtb \
>>          armada-370-rd.dtb \
>> diff --git a/arch/arm/boot/dts/msm8974-db.dts b/arch/arm/boot/dts/msm8974-db.dts
>> new file mode 100644
>> index 0000000..badfc61
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/msm8974-db.dts
>> @@ -0,0 +1,26 @@
>> +/dts-v1/;
>> +
>> +/include/ "skeleton.dtsi"
>> +
>> +/ {
>> +       model = "Qualcomm MSM8974 Dragonboard";
>> +       compatible = "qcom,msm8974-db", "qcom,msm8974";
>> +       interrupt-parent = <&intc>;
>> +
>> +       intc: interrupt-controller@f9000000 {
>> +               compatible = "qcom,msm-qgic2";
>> +               interrupt-controller;
>> +               #interrupt-cells = <3>;
>> +               reg = < 0xf9000000 0x1000 >,
>> +                     < 0xf9002000 0x1000 >;
>> +       };
>> +
>> +       timer {
>> +               compatible = "arm,armv7-timer";
>> +               interrupts = <1 2 0xf08>,
>> +                            <1 3 0xf08>,
>> +                            <1 4 0xf08>,
>> +                            <1 1 0xf08>;
>> +               clock-frequency = <19200000>;
>> +       };
>> +};
>> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
>> index 614e41e..343675b 100644
>> --- a/arch/arm/mach-msm/Kconfig
>> +++ b/arch/arm/mach-msm/Kconfig
>> @@ -1,12 +1,12 @@
>>   if ARCH_MSM
>>
>>   comment "Qualcomm MSM SoC Type"
>> -       depends on (ARCH_MSM8X60 || ARCH_MSM8960)
>> +       depends on ARCH_MSM_DT
>>
>>   choice
>>          prompt "Qualcomm MSM SoC Type"
>>          default ARCH_MSM7X00A
>> -       depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
>> +       depends on !ARCH_MSM_DT
>>
>>   config ARCH_MSM7X00A
>>          bool "MSM7x00A / MSM7x01A"
>> @@ -60,6 +60,19 @@ config ARCH_MSM8960
>>          select MSM_SCM if SMP
>>          select USE_OF
>>
>> +config ARCH_MSM8974
>> +       bool "MSM8974"
>> +       select ARM_GIC
>> +       select CPU_V7
>> +       select HAVE_ARM_ARCH_TIMER
>> +       select HAVE_SMP
>> +       select MSM_SCM if SMP
>> +       select USE_OF
>> +
>> +config ARCH_MSM_DT
>> +       def_bool y
>> +       depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
>> +
>>   config MSM_HAS_DEBUG_UART_HS
>>          bool
>>
>> @@ -68,6 +81,7 @@ config MSM_SOC_REV_A
>>
>>   config  ARCH_MSM_ARM11
>>          bool
>> +
>>   config  ARCH_MSM_SCORPION
>>          bool
>>
>> @@ -75,6 +89,7 @@ config  MSM_VIC
>>          bool
>>
>>   menu "Qualcomm MSM Board Type"
>> +       depends on !ARCH_MSM_DT
>>
>>   config MACH_HALIBUT
>>          depends on ARCH_MSM
>> @@ -121,7 +136,7 @@ config MSM_SMD
>>          bool
>>
>>   config MSM_GPIOMUX
>> -       depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
>> +       depends on !ARCH_MSM_DT
>>          bool "MSM V1 TLMM GPIOMUX architecture"
>>          help
>>            Support for MSM V1 TLMM GPIOMUX architecture.
>> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
>> index d257ff4..80e3b15 100644
>> --- a/arch/arm/mach-msm/Makefile
>> +++ b/arch/arm/mach-msm/Makefile
>> @@ -29,5 +29,6 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
>>   obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
>>   obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
>>   obj-$(CONFIG_ARCH_MSM8960) += board-dt-8960.o
>> +obj-$(CONFIG_ARCH_MSM8974) += board-dt-8974.o
>>   obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
>>   obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o
>> diff --git a/arch/arm/mach-msm/board-dt-8974.c b/arch/arm/mach-msm/board-dt-8974.c
>> new file mode 100644
>> index 0000000..697623e
>> --- /dev/null
>> +++ b/arch/arm/mach-msm/board-dt-8974.c
>> @@ -0,0 +1,23 @@
>> +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/of_platform.h>
>> +#include <asm/mach/arch.h>
>> +
>> +static const char * const msm8974_dt_match[] __initconst = {
>> +       "qcom,msm8974-db",
>> +       NULL
>> +};
>> +
>> +DT_MACHINE_START(MSM8974_DT, "Qualcomm MSM (Flattened Device Tree)")
>> +       .dt_compat = msm8974_dt_match,
>> +MACHINE_END
>> --
> Hi Rohit,
>
> I wonder if this arch/arm/mach-msm/board-dt-8974.c boad file is really
> needed. I just noticed that already exist an
> arch/arm/mach-msm/board-dt-8960.c and
> arch/arm/mach-msm/board-dt-8660.c board files which doesn't seem to be
> that different.
>
> I'm not familiar with msm at all so maybe all these boards files are
> needed. But one of the goals of having DeviceTree for ARM is to get
> rid of all the board files so I don't think is a good idea to add a
> board file for each DT added.
>
> In OMAP for example we only have one board file that is used for DT
> booting (arch/arm/mach-omap2/board-generic.c). These board file has a
> struct machine_desc for each OMAP family which defines a dt_compact
> for the family (i.e: ti,omap4).
>
> Since the machine init is almost the same for each SoC in a given
> family a board DTB can just define:
>
> compatible = "foo,bard", "ti,omap3";
>
> Since the compatible string is processed from specific to generic, a
> board can define its own struct machine_desc in case it really needs
> but it should just use the generic one in case it works for it.
>
> Again, I'm not familiar with the Snapdragon 800 SoC family but maybe
> you can do something similar to what we do in OMAP for this SoC
> family.
>
> Thanks a lot and best regards,
> Javier

Thanks Javier for the info. I agree with your reasoning and the analogy. 
This is a new family for Snapdragons and we expect to have differences 
that would go into this board file for 8974.
If the unification of board files seems possible once those changes are 
made, this will be done.

-Rohit
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

