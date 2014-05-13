Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbaEMImV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:42:21 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53097 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaEMImS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:42:18 -0400
Message-ID: <5371DAE5.2010400@gmail.com>
Date: Tue, 13 May 2014 10:42:13 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
CC: Mike Turquette <mturquette@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] ARM: dts: berlin: convert BG2CD to DT clock nodes
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com> <1399839881-29895-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399839881-29895-8-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 10:24 PM, Sebastian Hesselbarth wrote:
> This converts Berlin BG2CD SoC dtsi to make use of the new DT clock
> nodes for Berlin SoCs. Also add a binding include to ease core clock
> references.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
[...]
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index 094968c27533..c1b8dc8264d3 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
[...]
> @@ -169,6 +164,153 @@
>   			};
>   		};
>
> +		syspll: pll@ea0014 {
> +			compatible = "marvell,berlin2-pll";
> +			#clock-cells = <0>;
> +			reg = <0xea0014 0x14>;
> +			clocks = <&refclk>;
> +		};
> +
> +		mempll: pll@ea0028 {
> +			compatible = "marvell,berlin2-pll";
> +			#clock-cells = <0>;
> +			reg = <0xea0028 0x14>;
> +			clocks = <&refclk>;
> +		};
> +
> +		cpupll: pll@ea003c {
> +			compatible = "marvell,berlin2-pll";
> +			#clock-cells = <0>;
> +			reg = <0xea003c 0x14>;
> +			clocks = <&refclk>;
> +		};
> +
> +		avpll: pll@ea0040 {
> +			compatible = "marvell,berlin2-avpll";
> +			#clock-cells = <2>;
> +			reg = <0xea0050 0x100>;
> +			clocks = <&refclk>;
> +		};
> +
> +		coreclk: clock@ea0150 {
> +			compatible = "marvell,berlin2-core-clocks";
> +			#clock-cells = <1>;
> +			reg = <0xea0150 0x1c>;
> +			clocks = <&refclk>, <&syspll>, <&mempll>, <&cpupll>,
> +				<&avpll 0 1>, <&avpll 0 2>,
> +				<&avpll 0 3>, <&avpll 0 4>,
> +				<&avpll 0 5>, <&avpll 0 6>,
> +				<&avpll 0 7>, <&avpll 0 8>,
> +				<&avpll 1 1>, <&avpll 1 2>,
> +				<&avpll 1 3>, <&avpll 1 4>,
> +				<&avpll 1 5>, <&avpll 1 6>,
> +				<&avpll 1 7>, <&avpll 1 8>;
> +			clock-names = "refclk", "syspll", "mempll", "cpupll",
> +				"avpll_a1", "avpll_a2", "avpll_a3", "avpll_a4",
> +				"avpll_a5", "avpll_a6", "avpll_a7", "avpll_a8",
> +				"avpll_b1", "avpll_b2", "avpll_b3", "avpll_b4",
> +				"avpll_b5", "avpll_b6", "avpll_b7", "avpll_b8";
> +		};
> +
> +		gfx3dcore_clk: clock@ea022c {
> +			compatible = "marvell,berlin2-clk-div";

correct compatible should be "marvell,berlin2-div"...

> +			#clock-cells = <0>;
> +			reg = <0xea0022c 0x4>;

... and reg is off by an extra '0'.

I'll fix it up for v2.

Sebastian

> +			clocks = <&syspll>,
> +				<&avpll 1 4>, <&avpll 1 5>,
> +				<&avpll 1 6>, <&avpll 1 7>;
> +			clock-names = "mux_bypass",
> +				"mux0", "mux1", "mux2", "mux3";
> +		};
> +
> +		gfx3dsys_clk: clock@ea0230 {
> +			compatible = "marvell,berlin2-clk-div";
> +			#clock-cells = <0>;
> +			reg = <0xea00230 0x4>;
> +			clocks = <&syspll>,
> +				<&avpll 1 4>, <&avpll 1 5>,
> +				<&avpll 1 6>, <&avpll 1 7>;
> +			clock-names = "mux_bypass",
> +				"mux0", "mux1", "mux2", "mux3";
> +		};
> +
> +		arc_clk: clock@ea0234 {
> +			compatible = "marvell,berlin2-clk-div";
> +			#clock-cells = <0>;
> +			reg = <0xea00234 0x4>;
> +			clocks = <&syspll>,
> +				<&avpll 1 4>, <&avpll 1 5>,
> +				<&avpll 1 6>, <&avpll 1 7>;
> +			clock-names = "mux_bypass",
> +				"mux0", "mux1", "mux2", "mux3";
> +		};
> +
> +		vip_clk: clock@ea0238 {
> +			compatible = "marvell,berlin2-clk-div";
> +			#clock-cells = <0>;
> +			reg = <0xea00238 0x4>;
> +			clocks = <&syspll>,
> +				<&avpll 1 4>, <&avpll 1 5>,
> +				<&avpll 1 6>, <&avpll 1 7>;
> +			clock-names = "mux_bypass",
> +				"mux0", "mux1", "mux2", "mux3";
> +		};
> +
> +		sdio0xin_clk: clock@ea023c {
> +			compatible = "marvell,berlin2-clk-div";
> +			#clock-cells = <0>;
> +			reg = <0xea0023c 0x4>;
> +			clocks = <&syspll>,
> +				<&avpll 1 4>, <&avpll 1 5>,
> +				<&avpll 1 6>, <&avpll 1 7>;
> +			clock-names = "mux_bypass",
> +				"mux0", "mux1", "mux2", "mux3";
> +		};
> +
> +		sdio1xin_clk: clock@ea0240 {
> +			compatible = "marvell,berlin2-clk-div";
> +			#clock-cells = <0>;
> +			reg = <0xea00240 0x4>;
> +			clocks = <&syspll>,
> +				<&avpll 1 4>, <&avpll 1 5>,
> +				<&avpll 1 6>, <&avpll 1 7>;
> +			clock-names = "mux_bypass",
> +				"mux0", "mux1", "mux2", "mux3";
> +		};
> +
> +		gfx3dextra_clk: clock@ea0244 {
> +			compatible = "marvell,berlin2-clk-div";
> +			#clock-cells = <0>;
> +			reg = <0xea00244 0x4>;
> +			clocks = <&syspll>,
> +				<&avpll 1 4>, <&avpll 1 5>,
> +				<&avpll 1 6>, <&avpll 1 7>;
> +			clock-names = "mux_bypass",
> +				"mux0", "mux1", "mux2", "mux3";
> +		};
> +
> +		gc360_clk: clock@ea024c {
> +			compatible = "marvell,berlin2-clk-div";
> +			#clock-cells = <0>;
> +			reg = <0xea0024c 0x4>;
> +			clocks = <&syspll>,
> +				<&avpll 1 4>, <&avpll 1 5>,
> +				<&avpll 1 6>, <&avpll 1 7>;
> +			clock-names = "mux_bypass",
> +				"mux0", "mux1", "mux2", "mux3";
> +		};
> +
> +		sdio_dllmst_clk: clock@ea0250 {
> +			compatible = "marvell,berlin2-clk-div";
> +			#clock-cells = <0>;
> +			reg = <0xea00250 0x4>;
> +			clocks = <&syspll>,
> +				<&avpll 1 4>, <&avpll 1 5>,
> +				<&avpll 1 6>, <&avpll 1 7>;
> +			clock-names = "mux_bypass",
> +				"mux0", "mux1", "mux2", "mux3";
> +		};
> +
>   		apb@fc0000 {
>   			compatible = "simple-bus";
>   			#address-cells = <1>;
> @@ -183,7 +325,7 @@
>   				reg-shift = <2>;
>   				reg-io-width = <1>;
>   				interrupts = <8>;
> -				clocks = <&smclk>;
> +				clocks = <&refclk>;
>   				status = "disabled";
>   			};
>
> @@ -193,7 +335,7 @@
>   				reg-shift = <2>;
>   				reg-io-width = <1>;
>   				interrupts = <9>;
> -				clocks = <&smclk>;
> +				clocks = <&refclk>;
>   				status = "disabled";
>   			};
>
> diff --git a/drivers/clk/berlin/Makefile b/drivers/clk/berlin/Makefile
> index f0a7dc8b5e30..2b33e1e74503 100644
> --- a/drivers/clk/berlin/Makefile
> +++ b/drivers/clk/berlin/Makefile
> @@ -1 +1,3 @@
>   obj-y += berlin2-avpll.o berlin2-pll.o berlin2-div.o
> +obj-$(CONFIG_MACH_BERLIN_BG2)	+= bg2.o
> +obj-$(CONFIG_MACH_BERLIN_BG2CD)	+= bg2.o
> diff --git a/include/dt-bindings/clock/berlin2.h b/include/dt-bindings/clock/berlin2.h
> new file mode 100644
> index 000000000000..dacf7edec4d3
> --- /dev/null
> +++ b/include/dt-bindings/clock/berlin2.h
> @@ -0,0 +1,35 @@
> +/*
> + * Berlin2 BG2/BG2CD clock tree IDs
> + */
> +
> +#define CLKID_SYS		0
> +#define CLKID_CPU		1
> +#define CLKID_DRMFIGO		2
> +#define CLKID_CFG		3
> +#define CLKID_GFX		4
> +#define CLKID_ZSP		5
> +#define CLKID_PERIF		6
> +#define CLKID_PCUBE		7
> +#define CLKID_VSCOPE		8
> +#define CLKID_NFC_ECC		9
> +#define CLKID_VPP		10
> +#define CLKID_APP		11
> +#define CLKID_AUDIO0		12
> +#define CLKID_AUDIO2		23
> +#define CLKID_AUDIO3		14
> +#define CLKID_AUDIO1		15
> +#define CLKID_GETH0		16
> +#define CLKID_GETH1		17
> +#define CLKID_SATA		18
> +#define CLKID_AHBAPB		19
> +#define CLKID_USB0		20
> +#define CLKID_USB1		21
> +#define CLKID_PBRIDGE		22
> +#define CLKID_SDIO0		23
> +#define CLKID_SDIO1		24
> +#define CLKID_NFC		25
> +#define CLKID_SMEMC		26
> +#define CLKID_AUDIOHD		27
> +#define CLKID_VIDEO0		28
> +#define CLKID_VIDEO1		29
> +#define CLKID_VIDEO2		30
>

