Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaDZLmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:42:00 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45979 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaDZLly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:41:54 -0400
Message-ID: <535B9B7E.4090802@gmail.com>
Date: Sat, 26 Apr 2014 13:41:50 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@samsung.com>, linux-kernel@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v8 3/3] ARM: dts: Add initial device tree support for
 EXYNOS5410
References: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com> <1397459860-21869-4-git-send-email-t.dakhran@samsung.com>
In-Reply-To: <1397459860-21869-4-git-send-email-t.dakhran@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since I've started enforcing reference-based DT syntax due to multiple 
advantages over the plain full-tree based one, you should do the same 
for your dts/i files. You can take the series adding support for 
Exynos5260 as an example:

http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29360

Best regards,
Tomasz

On 14.04.2014 09:17, Tarek Dakhran wrote:
> Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.
>
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>   arch/arm/boot/dts/Makefile                |    1 +
>   arch/arm/boot/dts/exynos5410-smdk5410.dts |   65 ++++++++++++++
>   arch/arm/boot/dts/exynos5410.dtsi         |  140 +++++++++++++++++++++++++++++
>   3 files changed, 206 insertions(+)
>   create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>   create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 35c146f..191dd19 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -74,6 +74,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
>   	exynos5250-smdk5250.dtb \
>   	exynos5250-snow.dtb \
>   	exynos5420-arndale-octa.dtb \
> +	exynos5410-smdk5410.dtb \
>   	exynos5420-smdk5420.dtb \
>   	exynos5440-sd5v1.dtb \
>   	exynos5440-ssdk5440.dtb
> diff --git a/arch/arm/boot/dts/exynos5410-smdk5410.dts b/arch/arm/boot/dts/exynos5410-smdk5410.dts
> new file mode 100644
> index 0000000..d69e152
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos5410-smdk5410.dts
> @@ -0,0 +1,65 @@
> +/*
> + * SAMSUNG SMDK5410 board device tree source
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +/dts-v1/;
> +#include "exynos5410.dtsi"
> +/ {
> +	model = "Samsung SMDK5410 board based on EXYNOS5410";
> +	compatible = "samsung,smdk5410", "samsung,exynos5410";
> +
> +	memory {
> +		reg = <0x40000000 0x80000000>;
> +	};
> +
> +	chosen {
> +		bootargs = "console=ttySAC2,115200";
> +	};
> +
> +	fixed-rate-clocks {
> +		oscclk {
> +			compatible = "samsung,exynos5410-oscclk";
> +			clock-frequency = <24000000>;
> +		};
> +	};
> +
> +	mmc@12200000 {
> +		status = "okay";
> +		num-slots = <1>;
> +		supports-highspeed;
> +		broken-cd;
> +		card-detect-delay = <200>;
> +		samsung,dw-mshc-ciu-div = <3>;
> +		samsung,dw-mshc-sdr-timing = <2 3>;
> +		samsung,dw-mshc-ddr-timing = <1 2>;
> +
> +		slot@0 {
> +			reg = <0>;
> +			bus-width = <8>;
> +		};
> +	};
> +
> +	mmc@12220000 {
> +		status = "okay";
> +		num-slots = <1>;
> +		supports-highspeed;
> +		card-detect-delay = <200>;
> +		samsung,dw-mshc-ciu-div = <3>;
> +		samsung,dw-mshc-sdr-timing = <2 3>;
> +		samsung,dw-mshc-ddr-timing = <1 2>;
> +
> +		slot@0 {
> +			reg = <0>;
> +			bus-width = <4>;
> +			disable-wp;
> +		};
> +	};
> +
> +};
> diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
> new file mode 100644
> index 0000000..e7cc930
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos5410.dtsi
> @@ -0,0 +1,140 @@
> +/*
> + * SAMSUNG EXYNOS5410 SoC device tree source
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * SAMSUNG EXYNOS5410 SoC device nodes are listed in this file.
> + * EXYNOS5410 based board files can include this file and provide
> + * values for board specfic bindings.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <dt-bindings/clock/exynos5410.h>
> +#include "exynos5.dtsi"
> +/ {
> +	compatible = "samsung,exynos5410", "samsung,exynos5";
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		CPU0: cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a15";
> +			reg = <0>;
> +			clock-frequency = <1600000000>;
> +		};
> +
> +		CPU1: cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a15";
> +			reg = <1>;
> +			clock-frequency = <1600000000>;
> +		};
> +
> +		CPU2: cpu@2 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a15";
> +			reg = <2>;
> +			clock-frequency = <1600000000>;
> +		};
> +
> +		CPU3: cpu@3 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a15";
> +			reg = <3>;
> +			clock-frequency = <1600000000>;
> +		};
> +	};
> +
> +	clock: clock-controller@10010000 {
> +		compatible = "samsung,exynos5410-clock";
> +		reg = <0x10010000 0x30000>;
> +		#clock-cells = <1>;
> +	};
> +
> +	timer@101C0000 {
> +		compatible = "samsung,exynos4210-mct";
> +		reg = <0x101C0000 0xB00>;
> +		interrupt-parent = <&interrupt_map>;
> +		interrupts = <0>, <1>, <2>, <3>,
> +			<4>, <5>, <6>, <7>,
> +			<8>, <9>, <10>, <11>;
> +		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MCT>;
> +		clock-names = "fin_pll", "mct";
> +
> +		interrupt_map: interrupt-map {
> +			#interrupt-cells = <1>;
> +			#address-cells = <0>;
> +			#size-cells = <0>;
> +			interrupt-map = <0 &combiner 23 3>,
> +					<1 &combiner 23 4>,
> +					<2 &combiner 25 2>,
> +					<3 &combiner 25 3>,
> +					<4 &gic 0 120 0>,
> +					<5 &gic 0 121 0>,
> +					<6 &gic 0 122 0>,
> +					<7 &gic 0 123 0>,
> +					<8 &gic 0 128 0>,
> +					<9 &gic 0 129 0>,
> +					<10 &gic 0 130 0>,
> +					<11 &gic 0 131 0>;
> +		};
> +	};
> +
> +	mmc_0: mmc@12200000 {
> +		compatible = "samsung,exynos5250-dw-mshc";
> +		interrupts = <0 75 0>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		reg = <0x12200000 0x1000>;
> +		clocks = <&clock CLK_MMC0>, <&clock CLK_SCLK_MMC0>;
> +		clock-names = "biu", "ciu";
> +		fifo-depth = <0x80>;
> +		status = "disabled";
> +	};
> +
> +	mmc_1: mmc@12210000 {
> +		compatible = "samsung,exynos5250-dw-mshc";
> +		interrupts = <0 76 0>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		reg = <0x12210000 0x1000>;
> +		clocks = <&clock CLK_MMC1>, <&clock CLK_SCLK_MMC1>;
> +		clock-names = "biu", "ciu";
> +		fifo-depth = <0x80>;
> +		status = "disabled";
> +	};
> +
> +	mmc_2: mmc@12220000 {
> +		compatible = "samsung,exynos5250-dw-mshc";
> +		interrupts = <0 77 0>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		reg = <0x12220000 0x1000>;
> +		clocks = <&clock CLK_MMC2>, <&clock CLK_SCLK_MMC2>;
> +		clock-names = "biu", "ciu";
> +		fifo-depth = <0x80>;
> +		status = "disabled";
> +	};
> +
> +	serial@12C00000 {
> +		clocks = <&clock CLK_UART0>, <&clock CLK_SCLK_UART0>;
> +		clock-names = "uart", "clk_uart_baud0";
> +	};
> +
> +	serial@12C10000 {
> +		clocks = <&clock CLK_UART1>, <&clock CLK_SCLK_UART1>;
> +		clock-names = "uart", "clk_uart_baud0";
> +	};
> +
> +	serial@12C20000 {
> +		clocks = <&clock CLK_UART2>, <&clock CLK_SCLK_UART2>;
> +		clock-names = "uart", "clk_uart_baud0";
> +	};
> +
> +};
>
