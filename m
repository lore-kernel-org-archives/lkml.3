Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaI2Ozb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:55:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbaI2Oza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:55:30 -0400
Message-ID: <542972DD.8020700@suse.de>
Date: Mon, 29 Sep 2014 16:55:25 +0200
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: zhang.lyra@gmail.com
CC: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] arm64: Add DTS support for Spreadtrum's Shark64 SoC
References: <1411991314-6636-1-git-send-email-zhang.lyra@gmail.com> <1411991314-6636-3-git-send-email-zhang.lyra@gmail.com>
In-Reply-To: <1411991314-6636-3-git-send-email-zhang.lyra@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 29.09.2014 um 13:48 schrieb zhang.lyra@gmail.com:
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
> +
> +/ {
> +	model = "shark64 Board";

The commit message says SoC but here it says Board. Usually the SoC goes
into a .dtsi file that can then be reused for multiple boards (.dts).
Even if you only have one board for now, this distinction makes sense.

You can use status = "disabled"; to prepare nodes in the .dtsi and then
override the ones used via status = "okay"; in the .dts file. UARTs are
a typical example where you will see this pattern used.

> +	compatible = "sprd,shark64";
> +	interrupt-parent = <&gic>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	chosen {
> +		bootargs = "earlycon=serial_sprd,0x70000000";
> +      };

Some spaces snuck into this line. ;)

Cheers,
Andreas

> +
> +	cpus {
> +		#address-cells = <2>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";
> +			reg = <0x0 0x0>;
> +			enable-method = "spin-table";
> +			cpu-release-addr = <0x0 0x8000fff8>;
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
> +
> +	gic: interrupt-controller@12001000 {
> +		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
> +		#interrupt-cells = <3>;
> +		#address-cells = <0>;
> +		interrupt-controller;
> +		reg = <0 0x12001000 0 0x1000>,
> +		      <0 0x12002000 0 0x1000>;
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
> +
> +	timer {
> +		compatible = "arm,armv8-timer";
> +		interrupts = <1 13 0xff01>,
> +			     <1 14 0xff01>,
> +			     <1 11 0xff01>,
> +			     <1 10 0xff01>;
> +		clock-frequency = <26000000>;
> +	};
> +
> +	uart0: uart@70000000 {
> +		compatible = "sprd,serial";
> +		reg = <0 0x70000000 0 0x100>;
> +		interrupts = <0 2 0xf04>;
> +	};
> +
> +	uart1: uart@70100000 {
> +		compatible = "sprd,serial";
> +		reg = <0 0x70100000 0 0x100>;
> +		interrupts = <0 3 0xf04>;
> +	};
> +};

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
