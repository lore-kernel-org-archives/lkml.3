Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaJALXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:23:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60181 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbaJALXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:23:36 -0400
Date: Wed, 1 Oct 2014 12:23:33 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: Re: [PATCH 2/6] arm64: Add DTS support for Spreadtrum's Shark64 SoC
Message-ID: <20141001112332.GB13759@leverpostej>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
 <1411992293-7729-3-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411992293-7729-3-git-send-email-zhang.lyra@gmail.com>
Thread-Topic: [PATCH 2/6] arm64: Add DTS support for Spreadtrum's Shark64 SoC
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 01:04:49PM +0100, zhang.lyra@gmail.com wrote:
> From: "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>
> 
> Adds the device tree support for Spreadtrum Shark64 SoC based on ARMv8 architecture.
> 
> Signed-off-by: zhizhou.zhang <zhizhou.zhang@spreadtrum.com>
> Signed-off-by: chunyan.zhang <chunyan.zhang@spreadtrum.com>
> ---
>  arch/arm64/boot/dts/sprd_shark64.dts |  110 ++++++++++++++++++++++++++++++++++
>  1 file changed, 110 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/sprd_shark64.dts
> 
> diff --git a/arch/arm64/boot/dts/sprd_shark64.dts b/arch/arm64/boot/dts/sprd_shark64.dts
> new file mode 100644
> index 0000000..537cd6d
> --- /dev/null
> +++ b/arch/arm64/boot/dts/sprd_shark64.dts
> @@ -0,0 +1,110 @@
> +/*
> + * dts file for Spreadtrum(sprd) Shark64 SOC
> + *
> + * Copyright (C) 2014,  Spreadtrum Communications Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + */
> +
> +/dts-v1/;
> +
> +/memreserve/ 0x80000000 0x00010000;

What is this protecting?

Please add a comment.

> +
> +/ {
> +	model = "shark64 Board";
> +	compatible = "sprd,shark64";

This feels like it would make more sense as an SoC dtsi to be included
by various boards (which can override the model and compatible).

> +	interrupt-parent = <&gic>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	chosen {
> +		bootargs = "earlycon=serial_sprd,0x70000000";

Can we not use stdout-path for this?

> +      };
> +
> +	cpus {
> +		#address-cells = <2>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";

Can we have the particular CPU name, please?

> +			reg = <0x0 0x0>;
> +			enable-method = "spin-table";
> +			cpu-release-addr = <0x0 0x8000fff8>;

No PSCI?

What are you using for your bootloader/firmware?

If you must use spin-table, please give each CPU a unique release
address.

> +		};
> +		cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";
> +			reg = <0x0 0x1>;
> +			enable-method = "spin-table";
> +			cpu-release-addr = <0x0 0x8000fff8>;
> +		};
> +		cpu@2 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";
> +			reg = <0x0 0x2>;
> +			enable-method = "spin-table";
> +			cpu-release-addr = <0x0 0x8000fff8>;
> +		};
> +		cpu@3 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";
> +			reg = <0x0 0x3>;
> +			enable-method = "spin-table";
> +			cpu-release-addr = <0x0 0x8000fff8>;
> +		};
> +	};
> +
> +	memory@80000000 {
> +		device_type = "memory";
> +		reg = <0 0x80000000 0 0x20000000>;
> +	};
> +
> +	aliases {
> +		serial0 = &uart0;
> +		serial1 = &uart1;
> +	};

Could you move this up above chosen, please?

> +
> +	gic: interrupt-controller@12001000 {
> +		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
> +		#interrupt-cells = <3>;
> +		#address-cells = <0>;
> +		interrupt-controller;
> +		reg = <0 0x12001000 0 0x1000>,
> +		      <0 0x12002000 0 0x1000>;

No GICH or GICV?

Which exception level do your CPUs boot in?

I would strongly recommend booting at EL2. That gives the kernel more
flexibility to perform fixups (e.g. zeroing CNTVOFF), and requires less
work in your bootloader.

> +	};
> +
> +	intc:interrupt-controller@71400000 {
> +		compatible = "sprd,intc";
> +		#interrupt-cells = <0>;
> +		interrupt-controller;
> +		reg =	<0 0x71400000 0 0x1000>,
> +			<0 0x71500000 0 0x1000>,
> +			<0 0x71600000 0 0x1000>,
> +			<0 0x71700000 0 0x1000>;
> +	};

This binding doesn't exist in mainline, and isn't added by this series.
I'm especially confused by the #interrupt-cells = <0>.

What exactly is this, and how do you intend to use it?

> +
> +	timer {
> +		compatible = "arm,armv8-timer";
> +		interrupts = <1 13 0xff01>,
> +			     <1 14 0xff01>,
> +			     <1 11 0xff01>,
> +			     <1 10 0xff01>;
> +		clock-frequency = <26000000>;

Please have your FW or bootloader program CNTFRQ_EL1 on each CPU, and
get rid of the clock-frequency property here.

> +	};
> +
> +	uart0: uart@70000000 {
> +		compatible = "sprd,serial";
> +		reg = <0 0x70000000 0 0x100>;
> +		interrupts = <0 2 0xf04>;
> +	};

No clocks/dmas/etc necessary?

Mark.

> +
> +	uart1: uart@70100000 {
> +		compatible = "sprd,serial";
> +		reg = <0 0x70100000 0 0x100>;
> +		interrupts = <0 3 0xf04>;
> +	};
> +};
> -- 
> 1.7.9.5
> 
> 
