Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaJQNAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:00:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47303 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbaJQNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:00:49 -0400
Date: Fri, 17 Oct 2014 14:00:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
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
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>
Subject: Re: [PATCH v2 3/5] arm64: dts: Add support for Spreadtrum Sharkl3
 SoC in dts and Makefile.
Message-ID: <20141017130040.GB5587@leverpostej>
References: <sprd-1017-v2>
 <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1413539665-11484-4-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413539665-11484-4-git-send-email-chunyan.zhang@spreadtrum.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 10:54:23AM +0100, Chunyan Zhang wrote:
> From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
> 
> Adds the device tree support for Spreadtrum Sharkl3 SoC which is based on
> Sharkl platform.
> 
> Sharkl platform contains the common nodes of Spreadtrum's arm64-based SoCs.
> 
> Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> ---
>  arch/arm64/boot/dts/Makefile              |    1 +
>  arch/arm64/boot/dts/sprd-sharkl.dtsi      |   33 ++++++++++++++
>  arch/arm64/boot/dts/sprd-sharkl3-fpga.dts |   41 +++++++++++++++++
>  arch/arm64/boot/dts/sprd-sharkl3.dtsi     |   69 +++++++++++++++++++++++++++++
>  4 files changed, 144 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/sprd-sharkl.dtsi
>  create mode 100644 arch/arm64/boot/dts/sprd-sharkl3-fpga.dts
>  create mode 100644 arch/arm64/boot/dts/sprd-sharkl3.dtsi
> 
> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> index c52bdb0..0030e44 100644
> --- a/arch/arm64/boot/dts/Makefile
> +++ b/arch/arm64/boot/dts/Makefile
> @@ -1,3 +1,4 @@
> +dtb-$(CONFIG_ARCH_SHARKL) += sprd-sharkl3-fpga.dtb
>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>  
> diff --git a/arch/arm64/boot/dts/sprd-sharkl.dtsi b/arch/arm64/boot/dts/sprd-sharkl.dtsi
> new file mode 100644
> index 0000000..26a28c3
> --- /dev/null
> +++ b/arch/arm64/boot/dts/sprd-sharkl.dtsi
> @@ -0,0 +1,33 @@
> +/*
> + * dtsi file for Spreadtrum(sprd) Sharkl Platform based on AArch64.
> + *
> + * Copyright (C) 2014,  Spreadtrum Communications Inc.
> + *
> + * Sharkl Platform is the base of Spreadtrum arm64 SoCs whose common
> + * nodes are listed in this file.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + */
> +
> +/ {
> +	interrupt-parent = <&gic>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	uart0: serial@70000000 {
> +		compatible = "sprd,serial";
> +		reg = <0 0x70000000 0 0x100>;
> +		interrupts = <0 2 0xf04>;
> +		status = "disabled";
> +	};
> +
> +	uart1: serial@70100000 {
> +		compatible = "sprd,serial";
> +		reg = <0 0x70100000 0 0x100>;
> +		interrupts = <0 3 0xf04>;
> +		status = "disabled";
> +	};
> +};
> diff --git a/arch/arm64/boot/dts/sprd-sharkl3-fpga.dts b/arch/arm64/boot/dts/sprd-sharkl3-fpga.dts
> new file mode 100644
> index 0000000..faa0a2e
> --- /dev/null
> +++ b/arch/arm64/boot/dts/sprd-sharkl3-fpga.dts
> @@ -0,0 +1,41 @@
> +/*
> + * DTS file for Spreadtrum(sprd) Sharkl3 FPGA board based on
> + * the Sharkl Platform.
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
> +#include "sprd-sharkl3.dtsi"
> +
> +/ {
> +        model = "Spreadtrum Sharkl3 FPGA board";

For some reason this line begins with spaces rather than a tab, which
breaks the alignment and is a little annoying. Could you please fix the
spaces here to a tab?

> +
> +	compatible = "sprd,sharkl3-fpga", "sprd,sharkl3";
> +
> +	aliases {
> +	};
> +
> +	memory@80000000 {
> +		device_type = "memory";
> +		reg = <0 0x80000000 0 0x20000000>;
> +	};
> +
> +	chosen {
> +		stdout-path = &uart0;
> +	};
> +
> +	uart0: serial@70000000 {
> +		status = "okay";
> +	};
> +
> +	uart1: serial@70100000 {
> +		status = "okay";
> +	};
> +};
> diff --git a/arch/arm64/boot/dts/sprd-sharkl3.dtsi b/arch/arm64/boot/dts/sprd-sharkl3.dtsi
> new file mode 100644
> index 0000000..0ab4a94
> --- /dev/null
> +++ b/arch/arm64/boot/dts/sprd-sharkl3.dtsi
> @@ -0,0 +1,69 @@
> +/*
> + * dtsi file for Spreadtrum(sprd) Sharkl3 SoC based on the Sharkl Platform.
> + *
> + * Copyright (C) 2014,  Spreadtrum Communications Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + */
> +
> +#include "sprd-sharkl.dtsi"
> +
> +/ {
> +	compatible = "sprd,sharkl3";
> +
> +	gic: interrupt-controller@12001000 {
> +		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
> +		#interrupt-cells = <3>;
> +		interrupt-controller;
> +		reg = <0 0x12001000 0 0x1000>,
> +		      <0 0x12002000 0 0x1000>,
> +		      <0 0x12004000 0 0x2000>,
> +		      <0 0x12006000 0 0x2000>;
> +	};

Could we move this after the cpus node please?

> +
> +	cpus {
> +		#address-cells = <2>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";

Could we have the compatible string for the actual CPU rather than just
"arm,armv8"?

> +			reg = <0x0 0x0>;
> +			enable-method = "psci";
> +		};
> +		cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";
> +			reg = <0x0 0x1>;
> +			enable-method = "psci";
> +		};
> +		cpu@2 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";
> +			reg = <0x0 0x2>;
> +			enable-method = "psci";
> +		};
> +		cpu@3 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";
> +			reg = <0x0 0x3>;
> +			enable-method = "psci";
> +		};
> +	};
> +
> +	psci {
> +		compatible = "arm,psci-0.2";
> +		method = "smc";
> +	};

What are you using as your PSCI implementation?

> +	timer {
> +		compatible = "arm,armv8-timer";
> +		interrupts = <1 13 0xff01>,
> +			     <1 14 0xff01>,
> +			     <1 11 0xff01>,
> +			     <1 10 0xff01>;
> +	};

I take it that CNTFRQ is programmed correctly on all CPUs?

Thanks,
Mark.
