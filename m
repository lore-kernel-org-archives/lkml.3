Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918AbaLKSC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:02:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55238 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934104AbaLKSCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:02:54 -0500
Date: Thu, 11 Dec 2014 18:02:46 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Robert Richter <rrichter@cavium.com>, Mark Brown <broonie@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>
Subject: Re: [PATCH 3/4] arm64: dts: Add mediatek MT8173 SoC and evaluation
 board dts and Makefile
Message-ID: <20141211180245.GE28150@leverpostej>
References: <1418208602-35584-1-git-send-email-eddie.huang@mediatek.com>
 <1418208602-35584-4-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418208602-35584-4-git-send-email-eddie.huang@mediatek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 10, 2014 at 10:50:01AM +0000, Eddie Huang wrote:
> Add device tree support for MT8173 SoC and evalutaion board based on it.
> 
> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> ---
>  arch/arm64/boot/dts/Makefile       |   1 +
>  arch/arm64/boot/dts/mt8173-evb.dts |  31 +++++++
>  arch/arm64/boot/dts/mt8173.dtsi    | 164 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 196 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/mt8173-evb.dts
>  create mode 100644 arch/arm64/boot/dts/mt8173.dtsi
> 
> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> index f8001a6..db7661e 100644
> --- a/arch/arm64/boot/dts/Makefile
> +++ b/arch/arm64/boot/dts/Makefile
> @@ -1,3 +1,4 @@
> +dtb-$(CONFIG_ARCH_MEDIATEK) += mt8173-evb.dtb
>  dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> diff --git a/arch/arm64/boot/dts/mt8173-evb.dts b/arch/arm64/boot/dts/mt8173-evb.dts
> new file mode 100644
> index 0000000..adf26dd
> --- /dev/null
> +++ b/arch/arm64/boot/dts/mt8173-evb.dts
> @@ -0,0 +1,31 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Eddie Huang <eddie.huang@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +/dts-v1/;
> +#include "mt8173.dtsi"
> +
> +/ {
> +	model = "mediatek,mt8173-evb";
> +
> +	aliases {
> +		serial0 = &uart0;
> +		serial1 = &uart1;
> +		serial2 = &uart2;
> +		serial3 = &uart3;

Do any of these support earlycon?

> +	};
> +
> +	memory {

Nit: should be memory@40000000 (and you'll need to add device_type =
"memory").

> +		reg = <0 0x40000000 0 0x40000000>;
> +	};
> +};
> diff --git a/arch/arm64/boot/dts/mt8173.dtsi b/arch/arm64/boot/dts/mt8173.dtsi
> new file mode 100644
> index 0000000..1286801
> --- /dev/null
> +++ b/arch/arm64/boot/dts/mt8173.dtsi
> @@ -0,0 +1,164 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Eddie Huang <eddie.huang@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "skeleton.dtsi"
> +
> +/ {
> +	compatible = "mediatek,mt8173";
> +	interrupt-parent = <&sysirq>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	cpu-map {

This should live under /cpus, as documented in
Documentation/devicetree/bindings/arm/topology.txt.

> +		cluster0 {
> +			core0 {
> +				cpu = <&cpu0>;
> +			};
> +			core1 {
> +				cpu = <&cpu1>;
> +			};
> +		};
> +
> +		cluster1 {
> +			core0 {
> +				cpu = <&cpu2>;
> +			};
> +			core1 {
> +				cpu = <&cpu3>;
> +			};
> +		};
> +	};
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu0: cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a53";
> +			reg = <0x000>;
> +			enable-method = "psci";
> +		};
> +
> +		cpu1: cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a53";
> +			reg = <0x001>;
> +			enable-method = "psci";
> +		};
> +
> +		cpu2: cpu@2 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a57";
> +			reg = <0x100>;
> +			enable-method = "psci";
> +		};
> +
> +		cpu3: cpu@3 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a57";
> +			reg = <0x101>;
> +			enable-method = "psci";
> +		};
> +	};
> +
> +	psci {
> +		compatible = "arm,psci-0.2";
> +		method = "smc";
> +	};

What are you using as your PSCI 0.2 implementation?

Is it fully compliant? (e.g. are the reset and power off functions
implemented, may CPU0 be hotplugged)?

Given only portions of the GIC seem to be described below, what
exception level is your kernel entered at? Per the spec it should be
EL2, but given the brokenness below with the GIC I'm suspicious.

> +
> +	clocks {

Please remove the clock container node. It serves no purpose whatsoever.

Just put these clocks directly under the root.

> +		clk26m: clk26m {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <26000000>;
> +		};
> +
> +		clk32k: clk32k {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <32000>;
> +		};
> +
> +		uart_clk: dummy26m {
> +			compatible = "fixed-clock";
> +			clock-frequency = <26000000>;
> +			#clock-cells = <0>;
> +		};
> +	};
> +
> +	timer {
> +		compatible = "arm,armv8-timer";
> +		interrupt-parent = <&gic>;
> +		interrupts = <1 13 0x8>,
> +			     <1 14 0x8>,
> +			     <1 11 0x8>,
> +			     <1 10 0x8>;

Shouldn't these have a non-zero cpu mask?

> +		clock-frequency = <13000000>;

Your firmware should be programming CNTFREQ_EL0, so you shouldn't need
this (PSCI 0.2 requires CNTFREQ_EL0 to be programmed correctly on all
CPUs).

> +	};
> +
> +	soc {
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		compatible = "simple-bus";
> +		ranges;
> +
> +		sysirq: intpol-controller@10200620 {
> +			compatible = "mediatek,mt8173-sysirq", "mediatek,mt6577-sysirq";
> +			interrupt-controller;
> +			#interrupt-cells = <3>;
> +			interrupt-parent = <&gic>;
> +			reg = <0 0x10200620 0 0x20>;
> +		};
> +
> +		gic: interrupt-controller@10220000 {
> +			compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";

Surely this should be "arm,gic-400"?

> +			#interrupt-cells = <3>;
> +			interrupt-parent = <&gic>;
> +			interrupt-controller;
> +			reg = <0 0x10221000 0 0x1000>,
> +			      <0 0x10222000 0 0x1000>,
> +			      <0 0x10200620 0 0x1000>;

You're missing GICV here, and that GICH address is fundamentally wrong
(it _must_ be page aligned). 

The CPU interface (and virtual CPU interface) should be 0x2000 long.

The GIC maintenance interrupt also seems to be missing.

Thanks,
Mark.
