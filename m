Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbaEMIjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:39:18 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57739 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaEMIip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:38:45 -0400
Message-ID: <5371DA0F.6000903@gmail.com>
Date: Tue, 13 May 2014 10:38:39 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
CC: Mike Turquette <mturquette@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] clk: berlin: add clock binding docs for Marvell Berlin2
 SoCs
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com> <1399839881-29895-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399839881-29895-3-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 10:24 PM, Sebastian Hesselbarth wrote:
> This adds mandatory device tree binding documentation for the clock related
> IP found on Marvell Berlin2 (BG2, BG2CD, and BG2Q) SoCs.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   .../devicetree/bindings/clock/berlin2-clock.txt    | 169 +++++++++++++++++++++
>   1 file changed, 169 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/berlin2-clock.txt
>
> diff --git a/Documentation/devicetree/bindings/clock/berlin2-clock.txt b/Documentation/devicetree/bindings/clock/berlin2-clock.txt
> new file mode 100644
> index 000000000000..3da87a488402
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/berlin2-clock.txt
> @@ -0,0 +1,169 @@
> +* Marvell Berlin2 clock bindings
> +
> +Marvell Berlin2 (BG2, BG2CD, BG2Q) share the same IP for PLLs and clocks,
> +with some minor differences in features and register layout. The below
> +describes the individual clock related IP:
> +
> +* Audio/Video PLL
> +
> +The Audio/Video PLL (AVPLL) is a dual-VCO PLL with 8 channels each. Each
> +of the VCOs can sythesize a single VCO frequency based on a single input
> +reference clock. Each of the 8 channels then, can derive an output clock
> +from that VCO frequency by various dividers/multipliers.
> +
> +Required properties:
> +- compatible: shall be "marvell,berlin2-avpll"
> +- reg: address and length of the corresponding AVPLL registers
> +- #clock-cells: shall be set to 2
> +- clocks: single clock specifier referencing the AVPLL input clock
> +
> +To ease match-up with the desired AVPLL output clock, clock specifiers
> +referencing AVPLL clocks shall contain two cells. The first refers to
> +the VCO (0=AVPLL_A, 1=AVPLL_B) while the second refers to the corresponding
> +channel starting with 1. For example, to reference AVPLL_B3 the clock
> +specifier shall be: <&avpll 1 3>.
> +
> +Example:
> +
> +avpll: pll@ea0040 {
> +	compatible = "marvell,berlin2-avpll";
> +	#clock-cells = <2>;
> +	reg = <0xea0050 0x100>;
> +	clocks = <&refclk>;
> +};
> +
> +* Simple PLLs
> +
> +Simple PLLs are memory mapped PLLs that can sythesize a single output clock
> +based on a single input reference clock.
> +
> +Required properties:
> +- compatible: shall be one of the following:
> +	"marvell,berlin2-pll" for Berlin BG2/BG2CD PLLs
> +	"marvell,berlin2q-pll" for Berlin BG2Q PLLs
> +- reg: address and length of the corresponding PLL registers
> +- #clock-cells: shall be set to 0
> +- clocks: single clock specifier referencing the PLL input clock
> +
> +Example:
> +
> +cpupll: pll@ea003c {
> +	compatible = "marvell,berlin2-pll";
> +	#clock-cells = <0>;
> +	reg = <0xea003c 0x14>;
> +	clocks = <&refclk>;
> +};
> +
> +* Single-register clock dividers
> +
> +Single-register clock dividers are complex divider cells, allowing
> +to divide a reference clock with a set of fixed dividers. Also they
> +comprise and input clock mux with bypass and an ouput clock gate.
> +
> +Required properties:
> +- compatible: shall be "marvell,berlin2-clk-div"
> +- reg: address and length of the corresponding DIV registers
> +- #clock-cells: shall be set to 0
> +- clocks: clock specifiers referencing the DIV input clocks
> +- clock-names: array of strings describing the clock specifiers above.
> +    Allowed clock-names are "mux_bypass" for the clock mux bypass selection
> +    and "muxN" (N=0..7) for each of the 8 possible clock mux inputs.
> +
> +Example:
> +
> +gfx3dcore_clk: clock@ea022c {
> +	compatible = "marvell,berlin2-clk-div";

Actually using the clock driver for SDHCI IP revealed some issues
already. Above compatible should have been "marvell,berlin2-div".
I'll fix it up for v2.

Also, the commit msg should start with 'dt-binding: clk:' I guess.

Sebastian

> +	#clock-cells = <0>;
> +	reg = <0xea0022c 0x4>;
> +	clocks = <&syspll>,
> +		<&avpll AVPLL_B 4>, <&avpll AVPLL_B 5>,
> +		<&avpll AVPLL_B 6>, <&avpll AVPLL_B 7>;
> +	clock-names = "mux_bypass",
> +		"mux0", "mux1", "mux2", "mux3";
> +};
> +
> +* SoC-specific core clocks
> +
> +In addition to the above, there is a register set dealing with SoC
> +specific clock dividers, muxes, and gates. There is also the complex
> +divider cell used above, but instead of independent registers, they
> +share a common set of registers. The core clocks are represented by
> +a single DT node providing access to the remaining clocks.
> +
> +Required properties:
> +- compatible: shall be one of
> +	"marvell,berlin2-core-clocks" for BG2/BG2CD SoCs
> +	"marvell,berlin2q-core-clocks" for BG2Q SoCs
> +- reg: address and length of the corresponding clock registers
> +- #clock-cells: shall be set to 1
> +- clocks: clock specifiers referencing the core clock input clocks
> +- clock-names: array of strings describing the clock specifiers above.
> +    Allowed clock-names for the reference clocks are
> +      "refclk", "syspll", "mempll", "cpupll"
> +    also Audio/Video PLL clocks shall be named with
> +      "avpll_VN" (V=0...1 for AVPLL_A and AVPLL_B, N=1..8 for the
> +      corresponding reference input from AVPLL).
> +
> +Optional properties for BG2/BG2CD SoCs:
> +- clocks/clock-names: in addition to the allowed clock names above,
> +    there is an external video clock input that shall be named "video_ext0".
> +
> +Clocks provided by core clocks shall be referenced by a clock specifier
> +indexing one of the provided clocks. A SoC-specific list of available clocks
> +is below the example.
> +
> +Example:
> +coreclk: clock@ea0150 {
> +	compatible = "marvell,berlin2-core-clocks";
> +	#clock-cells = <1>;
> +	reg = <0xea0150 0x1c>;
> +	clocks = <&refclk>, <&syspll>, <&mempll>, <&cpupll>,
> +		<&avpll 0 1>, <&avpll 0 2>,
> +		<&avpll 0 3>, <&avpll 0 4>,
> +		<&avpll 0 5>, <&avpll 0 6>,
> +		<&avpll 0 7>, <&avpll 0 8>,
> +		<&avpll 1 1>, <&avpll 1 2>,
> +		<&avpll 1 3>, <&avpll 1 4>,
> +		<&avpll 1 5>, <&avpll 1 6>,
> +		<&avpll 1 7>, <&avpll 1 8>,
> +		<&externalvideoclk>;
> +	clock-names = "refclk", "syspll", "mempll", "cpupll",
> +		"avpll_a1", "avpll_a2", "avpll_a3", "avpll_a4",
> +		"avpll_a5", "avpll_a6", "avpll_a7", "avpll_a8",
> +		"avpll_b1", "avpll_b2", "avpll_b3", "avpll_b4",
> +		"avpll_b5", "avpll_b6", "avpll_b7", "avpll_b8",
> +		"video_ext0";
> +};
> +
> +* BG2/BG2CD core clock indicies:
> +0  - SYS
> +1  - CPU
> +2  - DRMFIGO
> +3  - CFG
> +4  - GFX
> +5  - ZSP
> +6  - PERIF
> +7  - PCUBE
> +8  - VSCOPE
> +9  - NFC_ECC
> +10 - VPP
> +11 - APP
> +12 - AUDIO0
> +23 - AUDIO2
> +14 - AUDIO3
> +15 - AUDIO1
> +16 - GETH0
> +17 - GETH1
> +18 - SATA
> +19 - AHBAPB
> +20 - USB0
> +21 - USB1
> +22 - PBRIDGE
> +23 - SDIO0
> +24 - SDIO1
> +25 - NFC
> +26 - SMEMC
> +27 - AUDIOHD
> +28 - VIDEO0
> +29 - VIDEO1
> +30 - VIDEO2
>

