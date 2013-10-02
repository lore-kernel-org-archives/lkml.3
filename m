Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3JBUyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:54:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36672 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3JBUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:54:17 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 4/6] ARM: dts: Add initial device tree support for EXYNOS5410
Date: Wed, 02 Oct 2013 22:54:15 +0200
Message-ID: <14713455.3bE9d8ejOo@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <1380644227-12244-5-git-send-email-v.tyrtov@samsung.com>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com> <1380644227-12244-5-git-send-email-v.tyrtov@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vyacheslav, Tarek,

On Tuesday 01 of October 2013 20:17:05 Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.
[snip]
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

As I mentioned in my reply to the patch adding the clock driver, please 
consider using generic fixed rate clock bindings instead of introducing 
new platform specific ones. I know that previous Exynos SoCs do it this 
way, but this is no good.

> +
> +	dwmmc0@12200000 {

I believe there has been a patch series renaming these dwmmcX nodes to 
follow correct DT conventions and doing some more clean-up. IMHO you 
should consider basing your patch on top of that series.

> +		num-slots = <1>;
> +		supports-highspeed;
> +		broken-cd;
> +		fifo-depth = <0x80>;
> +		card-detect-delay = <200>;
> +		samsung,dw-mshc-ciu-div = <3>;
> +		samsung,dw-mshc-sdr-timing = <2 3>;
> +		samsung,dw-mshc-ddr-timing = <1 2>;

nit: Please separate subnodes from properties with a blank line.

> +		slot@0 {
> +			reg = <0>;
> +			bus-width = <8>;
> +		};
> +	};
> +
> +	dwmmc1@12210000 {
> +		status = "disabled";

Oh, the series I mentioned above also corrected the way the status 
property is used, so board level dtses need to enable nodes which they use 
instead of disabling nodes they can't use, which makes much more sense, 
since you don't need to specify nodes in board level dts just to say it's 
disabled.

> +	};
> +
> +	dwmmc2@12220000 {
> +		num-slots = <1>;
> +		supports-highspeed;
> +		fifo-depth = <0x80>;
> +		card-detect-delay = <200>;
> +		samsung,dw-mshc-ciu-div = <3>;
> +		samsung,dw-mshc-sdr-timing = <2 3>;
> +		samsung,dw-mshc-ddr-timing = <1 2>;

nit: A blank line would be nice here.

> +		slot@0 {
> +			reg = <0>;
> +			bus-width = <4>;
> +			disable-wp;
> +		};
> +	};
> +
> +};
> diff --git a/arch/arm/boot/dts/exynos5410.dtsi
> b/arch/arm/boot/dts/exynos5410.dtsi new file mode 100644
> index 0000000..c0ea166
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos5410.dtsi
> @@ -0,0 +1,189 @@
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
> + * it under the terms of the GNU General Public License version 2 as +
> * published by the Free Software Foundation.
> + */
> +
> +#include "exynos5.dtsi"
> +/ {
> +	compatible = "samsung,exynos5410";
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		CPU0: cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a15";
> +			reg = <0>;
> +			cci-control-port = <&cci_control2>;
> +			clock-frequency = <1600000000>;
> +		};

nit: Please keep spacing between nodes.

> +		CPU1: cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a15";
> +			reg = <1>;
> +			cci-control-port = <&cci_control2>;
> +			clock-frequency = <1600000000>;
> +		};
> +		CPU2: cpu@2 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a15";
> +			reg = <2>;
> +			cci-control-port = <&cci_control2>;
> +			clock-frequency = <1600000000>;
> +		};
> +		CPU3: cpu@3 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a15";
> +			reg = <3>;
> +			cci-control-port = <&cci_control2>;
> +			clock-frequency = <1600000000>;
> +		};
> +		CPU4: cpu@4 {

The @unit-address suffix of node name must be equal to first address entry 
of reg property.

> +			device_type = "cpu";
> +			compatible = "arm,cortex-a7";
> +			reg = <0x100>;
> +			cci-control-port = <&cci_control1>;
> +			clock-frequency = <1200000000>;
> +		};
> +		CPU5: cpu@5 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a7";
> +			reg = <0x101>;
> +			cci-control-port = <&cci_control1>;
> +			clock-frequency = <1200000000>;
> +		};
> +		CPU6: cpu@6 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a7";
> +			reg = <0x102>;
> +			cci-control-port = <&cci_control1>;
> +			clock-frequency = <1200000000>;
> +		};
> +		CPU7: cpu@7 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a7";
> +			reg = <0x103>;
> +			cci-control-port = <&cci_control1>;
> +			clock-frequency = <1200000000>;
> +		};
> +
> +	};
> +
> +	edcs{

nit: Missing space before the brace.

> +		compatible = "samsung,edcs";
> +	};

Is this a real device? Are bindings for it documented somewhere?

> +
> +	cci@10d20000 {

nit: Please be consistent with case of hexadecimal characters.

> +		compatible = "arm,cci-400";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		reg = <0x10d20000 0x1000>;

nit: Ditto.

> +		ranges = <0 0x10d20000 0x6000>;

nit: Ditto.

> +
> +		cci_control0: slave-if@1000 {
> +			compatible = "arm,cci-400-ctrl-if";
> +			interface-type = "ace-lite";
> +			reg = <0x1000 0x1000>;
> +		};
> +
> +		cci_control1: slave-if@4000 {
> +			compatible = "arm,cci-400-ctrl-if";
> +			interface-type = "ace";
> +			reg = <0x4000 0x1000>;
> +		};
> +
> +		cci_control2: slave-if@5000 {
> +			compatible = "arm,cci-400-ctrl-if";
> +			interface-type = "ace";
> +			reg = <0x5000 0x1000>;
> +		};
> +	};
> +
> +	clock: clock-controller@10010000 {
> +		compatible = "samsung,exynos5410-clock";
> +		reg = <0x10010000 0x30000>;
> +		#clock-cells = <1>;
> +	};
> +
> +

nit: Unnecessary extra blank line.

> +	mct@101C0000 {
> +		compatible = "samsung,exynos4210-mct";
> +		reg = <0x101C0000 0xb00>;

nit: Inconsistent case of hexadecimal characters.

> +		interrupt-controller;
> +		#interrups-cells = <1>;

I don't think MCT has ever been an interrupt controller.

Best regards,
Tomasz

