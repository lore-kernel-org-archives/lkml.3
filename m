Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbbAILrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:47:41 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56041 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346AbbAILrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:47:39 -0500
Date: Fri, 9 Jan 2015 11:46:24 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] ARM: digicolor: add minimal device tree
 description
Message-ID: <20150109114624.GB12942@leverpostej>
References: <cover.1420744368.git.baruch@tkos.co.il>
 <9d8d7aed6220e9e92ab70217a65d3291924cfa71.1420744369.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d8d7aed6220e9e92ab70217a65d3291924cfa71.1420744369.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 07:39:59PM +0000, Baruch Siach wrote:
> cx92755.dtsi describes CX92755 on chip peripherals. conexant_equinox.dts
> describes the Equinox evaluation board for the CX92755 SoC.

I didn't spot any cpu nodes below. While that might happen to work at
the moment for UP, there really should be a node for the boot CPU.

Thanks,
Mark.

> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  arch/arm/boot/dts/Makefile             |   1 +
>  arch/arm/boot/dts/conexant_equinox.dts |  67 +++++++++++++++++++++
>  arch/arm/boot/dts/cx92755.dtsi         | 103 +++++++++++++++++++++++++++++++++
>  3 files changed, 171 insertions(+)
>  create mode 100644 arch/arm/boot/dts/conexant_equinox.dts
>  create mode 100644 arch/arm/boot/dts/cx92755.dtsi
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 91bd5bd62857..fbeb65eaddda 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -75,6 +75,7 @@ dtb-$(CONFIG_ARCH_BRCMSTB) += \
>  	bcm7445-bcm97445svmb.dtb
>  dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
>  	da850-evm.dtb
> +dtb-$(CONFIG_ARCH_DIGICOLOR) += conexant_equinox.dtb
>  dtb-$(CONFIG_ARCH_EFM32) += efm32gg-dk3750.dtb
>  dtb-$(CONFIG_ARCH_EXYNOS) += exynos3250-monk.dtb \
>  	exynos3250-rinato.dtb \
> diff --git a/arch/arm/boot/dts/conexant_equinox.dts b/arch/arm/boot/dts/conexant_equinox.dts
> new file mode 100644
> index 000000000000..b2917d914740
> --- /dev/null
> +++ b/arch/arm/boot/dts/conexant_equinox.dts
> @@ -0,0 +1,67 @@
> +/*
> + * Device Tree file for the Conexant Equinox CX92755 EVK
> + *
> + * Author: Baruch Siach <baruch@tkos.co.il>
> + *
> + *  Copyright (C) 2014 Paradox Innovation Ltd.
> + *
> + * This file is dual-licensed: you can use it either under the terms
> + * of the GPL or the X11 license, at your option. Note that this dual
> + * licensing only applies to this file, and not this project as a
> + * whole.
> + *
> + *  a) This file is free software; you can redistribute it and/or
> + *     modify it under the terms of the GNU General Public License as
> + *     published by the Free Software Foundation; either version 2 of the
> + *     License, or (at your option) any later version.
> + *
> + *     This file is distributed in the hope that it will be useful,
> + *     but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *     GNU General Public License for more details.
> + *
> + * Or, alternatively,
> + *
> + *  b) Permission is hereby granted, free of charge, to any person
> + *     obtaining a copy of this software and associated documentation
> + *     files (the "Software"), to deal in the Software without
> + *     restriction, including without limitation the rights to use,
> + *     copy, modify, merge, publish, distribute, sublicense, and/or
> + *     sell copies of the Software, and to permit persons to whom the
> + *     Software is furnished to do so, subject to the following
> + *     conditions:
> + *
> + *     The above copyright notice and this permission notice shall be
> + *     included in all copies or substantial portions of the Software.
> + *
> + *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> + *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> + *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> + *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + *     OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +/dts-v1/;
> +
> +#include "cx92755.dtsi"
> +
> +/ {
> +	model = "Conexant Equinox CX92755 EVK";
> +	compatible = "cnxt,equinox", "cnxt,cx92755";
> +
> +	memory@0 {
> +		reg = <0 0x8000000>;
> +		device_type = "memory";
> +	};
> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200 earlyprintk";
> +	};
> +};
> +
> +&uart0 {
> +	status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/cx92755.dtsi b/arch/arm/boot/dts/cx92755.dtsi
> new file mode 100644
> index 000000000000..4088e8974b4b
> --- /dev/null
> +++ b/arch/arm/boot/dts/cx92755.dtsi
> @@ -0,0 +1,103 @@
> +/*
> + * Device Tree Include file for the Conexant Digicolor CX92755 SoC
> + *
> + * Author: Baruch Siach <baruch@tkos.co.il>
> + *
> + *  Copyright (C) 2014 Paradox Innovation Ltd.
> + *
> + * This file is dual-licensed: you can use it either under the terms
> + * of the GPL or the X11 license, at your option. Note that this dual
> + * licensing only applies to this file, and not this project as a
> + * whole.
> + *
> + *  a) This file is free software; you can redistribute it and/or
> + *     modify it under the terms of the GNU General Public License as
> + *     published by the Free Software Foundation; either version 2 of the
> + *     License, or (at your option) any later version.
> + *
> + *     This file is distributed in the hope that it will be useful,
> + *     but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *     GNU General Public License for more details.
> + *
> + * Or, alternatively,
> + *
> + *  b) Permission is hereby granted, free of charge, to any person
> + *     obtaining a copy of this software and associated documentation
> + *     files (the "Software"), to deal in the Software without
> + *     restriction, including without limitation the rights to use,
> + *     copy, modify, merge, publish, distribute, sublicense, and/or
> + *     sell copies of the Software, and to permit persons to whom the
> + *     Software is furnished to do so, subject to the following
> + *     conditions:
> + *
> + *     The above copyright notice and this permission notice shall be
> + *     included in all copies or substantial portions of the Software.
> + *
> + *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> + *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> + *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> + *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + *     OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +#include "skeleton.dtsi"
> +
> +/ {
> +	compatible = "cnxt,cx92755";
> +
> +	interrupt-parent = <&intc>;
> +
> +	aliases {
> +		serial0 = &uart0;
> +		serial1 = &uart1;
> +		serial2 = &uart2;
> +	};
> +
> +	main_clk: main_clk {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency  = <200000000>;
> +	};
> +
> +	intc: intc@f0000000 {
> +		compatible = "cnxt,cx92755-ic";
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +		reg = <0xf0000000 0x1000>;
> +	};
> +
> +	timer@f0000fc0 {
> +		compatible = "cnxt,cx92755-timer";
> +		reg = <0xf0000fc0 0x40>;
> +		interrupts = <19>, <31>, <34>, <35>, <52>, <53>, <54>, <55>;
> +		clocks = <&main_clk>;
> +	};
> +
> +	uart0: uart@f0000740 {
> +		compatible = "cnxt,cx92755-usart";
> +		reg = <0xf0000740 0x20>;
> +		clocks = <&main_clk>;
> +		interrupts = <44>;
> +		status = "disabled";
> +	};
> +
> +	uart1: uart@f0000760 {
> +		compatible = "cnxt,cx92755-usart";
> +		reg = <0xf0000760 0x20>;
> +		clocks = <&main_clk>;
> +		interrupts = <45>;
> +		status = "disabled";
> +	};
> +
> +	uart2: uart@f0000780 {
> +		compatible = "cnxt,cx92755-usart";
> +		reg = <0xf0000780 0x20>;
> +		clocks = <&main_clk>;
> +		interrupts = <46>;
> +		status = "disabled";
> +	};
> +};
> -- 
> 2.1.4
> 
> 
