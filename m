Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3IFVvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:51:31 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41970 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3IFVv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:51:29 -0400
Date: Fri, 6 Sep 2013 14:50:51 -0700
From: Olof Johansson <olof@lixom.net>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv3 1/2] ARM: msm: Add support for APQ8074 Dragonboard
Message-ID: <20130906215051.GA29253@quad.lixom.net>
References: <1378495943-2572-1-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378495943-2572-1-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some comments below.

On Fri, Sep 06, 2013 at 12:32:22PM -0700, Rohit Vaswani wrote:
> This patch adds basic board support for APQ8074 Dragonboard
> which belongs to the Snapdragon 800 family.
> For now, just support a basic machine with device tree.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/boot/dts/Makefile                |  3 ++-
>  arch/arm/boot/dts/apq8074-dragonboard.dts |  6 ++++++
>  arch/arm/boot/dts/msm8974.dtsi            | 35 +++++++++++++++++++++++++++++++
>  arch/arm/mach-msm/Kconfig                 | 20 ++++++++++++++++--
>  arch/arm/mach-msm/Makefile                |  1 +
>  arch/arm/mach-msm/board-dt-8974.c         | 24 +++++++++++++++++++++
>  6 files changed, 86 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/boot/dts/apq8074-dragonboard.dts
>  create mode 100644 arch/arm/boot/dts/msm8974.dtsi
>  create mode 100644 arch/arm/mach-msm/board-dt-8974.c
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 641b3c9a..bea54a7 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -97,7 +97,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
>  	kirkwood-openblocks_a6.dtb
>  dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
>  dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
> -	msm8960-cdp.dtb
> +	msm8960-cdp.dtb \
> +	apq8074-dragonboard.dtb

Please add boards alphabetically.

>  dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
>  	armada-370-mirabox.dtb \
>  	armada-370-rd.dtb \
> diff --git a/arch/arm/boot/dts/apq8074-dragonboard.dts b/arch/arm/boot/dts/apq8074-dragonboard.dts
> new file mode 100644
> index 0000000..5b7b6a0
> --- /dev/null
> +++ b/arch/arm/boot/dts/apq8074-dragonboard.dts

arch/arm/boot/dts/ is getting really crowded. It's been working best if the SoC
family or vendor is used as a prefix to keep things a bit more organized. In
that spirit, prefixing these with msm-<foo> makes sense. Can you please do so?

> @@ -0,0 +1,6 @@
> +/include/ "msm8974.dtsi"
> +
> +/ {
> +	model = "Qualcomm APQ8074 Dragonboard";
> +	compatible = "qcom,apq8074-dragonboard", "qcom,apq8074";
> +};

Ok, I'm all for merging a early minimal dts file, but things like memory and
a default bootargs tend to make sense.

> diff --git a/arch/arm/boot/dts/msm8974.dtsi b/arch/arm/boot/dts/msm8974.dtsi
> new file mode 100644
> index 0000000..f04b643
> --- /dev/null
> +++ b/arch/arm/boot/dts/msm8974.dtsi
> @@ -0,0 +1,35 @@
> +/dts-v1/;
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "Qualcomm MSM8974";
> +	compatible = "qcom,msm8974";

the board uses "qcom,apq8074" and this overrides this. Which way is it?

> +	interrupt-parent = <&intc>;
> +
> +	soc: soc { };

For files that include this it's ok to use the &phandle syntax, but in this
base dtsi, please use proper structure. In other words, move the contents of
the soc node up above instead.

> +};
> +
> +&soc {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	ranges;
> +	compatible = "simple-bus";
> +
> +	intc: interrupt-controller@f9000000 {
> +		compatible = "qcom,msm-qgic2";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		reg = <0xf9000000 0x1000>,
> +		      <0xf9002000 0x1000>;
> +	};
> +
> +	timer {
> +		compatible = "arm,armv7-timer";
> +		interrupts = <1 2 0xf08>,
> +			     <1 3 0xf08>,
> +			     <1 4 0xf08>,
> +			     <1 1 0xf08>;
> +		clock-frequency = <19200000>;
> +	};
> +};

It'd make a lot of sense to include at least cpu nodes here as well, and
ideally basics for the drivers you have already merged, such as uarts.

> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 905efc8..499e8fe 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -1,12 +1,12 @@
>  if ARCH_MSM
>  
>  comment "Qualcomm MSM SoC Type"
> -	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
> +	depends on ARCH_MSM_DT
>  
>  choice
>  	prompt "Qualcomm MSM SoC Type"
>  	default ARCH_MSM7X00A
> -	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
> +	depends on !ARCH_MSM_DT

This has nothing to do with adding support for dragonboard. Please break
out the cleanup separately.

I'm not sure what the purpose of ARCH_MSM_DT is either, it just looks to
complicate matter here?

> +config ARCH_MSM8974
> +	bool "MSM8974"
> +	select ARM_GIC
> +	select CPU_V7
> +	select HAVE_ARM_ARCH_TIMER
> +	select HAVE_SMP
> +	select MSM_SCM if SMP
> +	select USE_OF
> +
> +config ARCH_MSM_DT
> +	def_bool y
> +	depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
> +
>  config MSM_HAS_DEBUG_UART_HS
>  	bool
>  
> @@ -68,6 +81,7 @@ config MSM_SOC_REV_A
>  
>  config  ARCH_MSM_ARM11
>  	bool
> +
>  config  ARCH_MSM_SCORPION
>  	bool
>  
> @@ -75,6 +89,7 @@ config  MSM_VIC
>  	bool
>  
>  menu "Qualcomm MSM Board Type"
> +	depends on !ARCH_MSM_DT
>  
>  config MACH_HALIBUT
>  	depends on ARCH_MSM
> @@ -122,6 +137,7 @@ config MSM_SMD
>  
>  config MSM_GPIOMUX
>  	bool
> +	depends on !ARCH_MSM_DT
>  	help
>  	  Support for MSM V1 TLMM GPIOMUX architecture.


All of the above should be in a separate patch and motivated.

>  
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index d257ff4..80e3b15 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -29,5 +29,6 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
>  obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
>  obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
>  obj-$(CONFIG_ARCH_MSM8960) += board-dt-8960.o
> +obj-$(CONFIG_ARCH_MSM8974) += board-dt-8974.o
>  obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
>  obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o
> diff --git a/arch/arm/mach-msm/board-dt-8974.c b/arch/arm/mach-msm/board-dt-8974.c
> new file mode 100644
> index 0000000..01ed8d0
> --- /dev/null
> +++ b/arch/arm/mach-msm/board-dt-8974.c
> @@ -0,0 +1,24 @@
> +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of_platform.h>
> +#include <asm/mach/arch.h>
> +
> +static const char * const msm8974_dt_match[] __initconst = {
> +	"qcom,msm8974",
> +	"qcom,apq8074",
> +	NULL
> +};
> +
> +DT_MACHINE_START(MSM8974_DT, "Qualcomm MSM (Flattened Device Tree)")
> +	.dt_compat = msm8974_dt_match,
> +MACHINE_END

This file should be shared across SoCs. You should avoid adding a new dt board
file for every SoC like this.


-Olof
