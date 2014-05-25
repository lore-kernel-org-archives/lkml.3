Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaEYTnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:43:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33641 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751477AbaEYTni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:43:38 -0400
Date: Sun, 25 May 2014 21:38:45 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 21/22] ARM: sunxi: Add Allwinner A23 dtsi
Message-ID: <20140525193845.GA10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-22-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ELawpaRm0uGyL1wg"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-22-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ELawpaRm0uGyL1wg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:24PM +0800, Chen-Yu Tsai wrote:
> The Allwinner A23 is a tablet oriented SoC with 2 Cortex-A7 cores
> and a Mali-400MP2 GPU.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun8i-a23.dtsi | 524 +++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 524 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun8i-a23.dtsi
>=20
> diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a=
23.dtsi
> new file mode 100644
> index 0000000..1cff087
> --- /dev/null
> +++ b/arch/arm/boot/dts/sun8i-a23.dtsi
> @@ -0,0 +1,524 @@
> +/*
> + * Copyright 2014 Chen-Yu Tsai
> + *
> + * Chen-Yu Tsai <wens@csie.org>
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	interrupt-parent =3D <&gic>;
> +
> +	aliases {
> +		serial0 =3D &uart0;
> +		serial1 =3D &uart1;
> +		serial2 =3D &uart2;
> +		serial3 =3D &uart3;
> +		serial4 =3D &uart4;
> +		serial5 =3D &r_uart;
> +	};
> +
> +
> +	cpus {
> +		enable-method =3D "allwinner,sun8i-a23";
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +
> +		cpu@0 {
> +			compatible =3D "arm,cortex-a7";
> +			device_type =3D "cpu";
> +			reg =3D <0>;
> +			clocks =3D <&cpu>;
> +		};
> +
> +		cpu@1 {
> +			compatible =3D "arm,cortex-a7";
> +			device_type =3D "cpu";
> +			reg =3D <1>;
> +			clocks =3D <&cpu>;

The clocks attributes have not been merged yet.

> +		};
> +	};
> +
> +	memory {
> +		reg =3D <0x40000000 0x80000000>;
> +	};
> +
> +	pmu {
> +		compatible =3D "arm,cortex-a7-pmu", "arm,cortex-a15-pmu";
> +		interrupts =3D <0 120 4>,
> +			     <0 121 4>,
> +			     <0 122 4>,
> +			     <0 123 4>;
> +	};

The PMU usually have as much interrupts as CPU core, so this is most
likely wrong.

Also, do you know if the arch timers are usable on the A23?

> +
> +	clocks {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges;
> +
> +		osc24M: osc24M_clk {
> +			#clock-cells =3D <0>;
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <24000000>;
> +			clock-output-names =3D "osc24M";
> +		};
> +
> +		osc32k: osc32k_clk {
> +			#clock-cells =3D <0>;
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <32768>;
> +			clock-output-names =3D "osc32k";
> +		};
> +
> +		pll1: clk@01c20000 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun8i-a23-pll1-clk";
> +			reg =3D <0x01c20000 0x4>;
> +			clocks =3D <&osc24M>;
> +			clock-output-names =3D "pll1";
> +		};
> +
> +		pll6: clk@01c20028 {
> +			#clock-cells =3D <1>;
> +			compatible =3D "allwinner,sun6i-a31-pll6-clk";
> +			reg =3D <0x01c20028 0x4>;
> +			clocks =3D <&osc24M>;
> +			clock-output-names =3D "pll6_other", "pll6";
> +		};
> +
> +		cpu: cpu_clk@01c20050 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun4i-a10-cpu-clk";
> +			reg =3D <0x01c20050 0x4>;
> +
> +			/*
> +			 * PLL1 is listed twice here.
> +			 * While it looks suspicious, it's actually documented
> +			 * that way both in the datasheet and in the code from
> +			 * Allwinner.
> +			 */
> +			clocks =3D <&osc32k>, <&osc24M>, <&pll1>, <&pll1>;
> +			clock-output-names =3D "cpu";
> +		};
> +
> +		axi: axi_clk@01c20050 {
> +			#clock-cells =3D <0>;
> +			/*
> +			 * AXI clock on A23 is actually wider,
> +			 * but extra bit is useless for divider
> +			 */

Then please add a new compatible for this, even though we're not doing
anything differently (yet).

> +			compatible =3D "allwinner,sun4i-a10-axi-clk";
> +			reg =3D <0x01c20050 0x4>;
> +			clocks =3D <&cpu>;
> +			clock-output-names =3D "axi";
> +		};
> +
> +		ahb1_pll6: ahb1_pll6_clk@01c20054 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun6i-a31-ahb1-pll6-clk";
> +			reg =3D <0x01c20054 0x4>;
> +			clocks =3D <&pll6 0>;
> +			clock-output-names =3D "ahb1_pll6";
> +		};
> +
> +		ahb1_mux: ahb1_mux_clk@01c20054 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun6i-a31-ahb1-mux-clk";
> +			reg =3D <0x01c20054 0x4>;
> +			clocks =3D <&osc32k>, <&osc24M>, <&axi>, <&ahb1_pll6>;
> +			clock-output-names =3D "ahb1_mux";
> +		};
> +
> +		ahb1: ahb1_clk@01c20054 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun4i-a10-ahb-clk";
> +			reg =3D <0x01c20054 0x4>;
> +			clocks =3D <&ahb1_mux>;
> +			clock-output-names =3D "ahb1";
> +		};
> +
> +		ahb1_gates: clk@01c20060 {
> +			#clock-cells =3D <1>;
> +			compatible =3D "allwinner,sun8i-a23-ahb1-gates-clk";
> +			reg =3D <0x01c20060 0x8>;
> +			clocks =3D <&ahb1>;
> +			clock-output-names =3D "ahb1_mipidsi", "ahb1_dma",
> +					"ahb1_mmc0", "ahb1_mmc1", "ahb1_mmc2",
> +					"ahb1_nand", "ahb1_sdram",
> +					"ahb1_hstimer", "ahb1_spi0",
> +					"ahb1_spi1", "ahb1_otg", "ahb1_ehci",
> +					"ahb1_ohci", "ahb1_ve", "ahb1_lcd",
> +					"ahb1_csi", "ahb1_be",	"ahb1_fe",
> +					"ahb1_gpu", "ahb1_spinlock",
> +					"ahb1_drc";
> +		};
> +
> +		apb1: apb1_clk@01c20054 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun4i-a10-apb0-clk";
> +			reg =3D <0x01c20054 0x4>;
> +			clocks =3D <&ahb1>;
> +			clock-output-names =3D "apb1";
> +		};
> +
> +		apb1_gates: clk@01c20068 {
> +			#clock-cells =3D <1>;
> +			compatible =3D "allwinner,sun8i-a23-apb1-gates-clk";
> +			reg =3D <0x01c20068 0x4>;
> +			clocks =3D <&apb1>;
> +			clock-output-names =3D "apb1_codec", "apb1_pio",
> +					"apb1_daudio0",	"apb1_daudio1";
> +		};
> +
> +		apb2_mux: apb2_mux@01c20058 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun4i-a10-apb1-mux-clk";
> +			reg =3D <0x01c20058 0x4>;
> +			clocks =3D <&osc32k>, <&osc24M>, <&pll6 0>, <&pll6 0>;
> +			clock-output-names =3D "apb2_mux";
> +		};

It doesn't look to be ordered by physical address.=20

> +		apb2: apb2@01c20058 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun6i-a31-apb2-div-clk";
> +			reg =3D <0x01c20058 0x4>;
> +			clocks =3D <&apb2_mux>;
> +			clock-output-names =3D "apb2";
> +		};
> +
> +		apb2_gates: clk@01c2006c {
> +			#clock-cells =3D <1>;
> +			compatible =3D "allwinner,sun8i-a23-apb2-gates-clk";
> +			reg =3D <0x01c2006c 0x4>;
> +			clocks =3D <&apb2>;
> +			clock-output-names =3D "apb2_i2c0", "apb2_i2c1",
> +					"apb2_i2c2", "apb2_uart0",
> +					"apb2_uart1", "apb2_uart2",
> +					"apb2_uart3", "apb2_uart4";
> +		};
> +
> +		mmc0_clk: clk@01c20088 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun4i-a10-mod0-clk";
> +			reg =3D <0x01c20088 0x4>;
> +			clocks =3D <&osc24M>, <&pll6 0>;
> +			clock-output-names =3D "mmc0";
> +		};
> +
> +		mmc1_clk: clk@01c2008c {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun4i-a10-mod0-clk";
> +			reg =3D <0x01c2008c 0x4>;
> +			clocks =3D <&osc24M>, <&pll6 0>;
> +			clock-output-names =3D "mmc1";
> +		};
> +
> +		mmc2_clk: clk@01c20090 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun4i-a10-mod0-clk";
> +			reg =3D <0x01c20090 0x4>;
> +			clocks =3D <&osc24M>, <&pll6 0>;
> +			clock-output-names =3D "mmc2";
> +		};
> +
> +		spi0_clk: clk@01c200a0 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun4i-a10-mod0-clk";
> +			reg =3D <0x01c200a0 0x4>;
> +			clocks =3D <&osc24M>, <&pll6 0>;
> +			clock-output-names =3D "spi0";
> +		};
> +
> +		spi1_clk: clk@01c200a4 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "allwinner,sun4i-a10-mod0-clk";
> +			reg =3D <0x01c200a4 0x4>;
> +			clocks =3D <&osc24M>, <&pll6 0>;
> +			clock-output-names =3D "spi1";
> +		};
> +	};
> +
> +	soc@01c00000 {
> +		compatible =3D "simple-bus";
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges;
> +
> +		pio: pinctrl@01c20800 {
> +			compatible =3D "allwinner,sun8i-a23-pinctrl";
> +			reg =3D <0x01c20800 0x400>;
> +			interrupts =3D <0 11 4>,
> +				     <0 15 4>,
> +				     <0 17 4>;
> +			clocks =3D <&apb1_gates 5>;
> +			gpio-controller;
> +			interrupt-controller;
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +			#gpio-cells =3D <3>;
> +
> +			uart0_pins_a: uart0@0 {
> +				allwinner,pins =3D "PF2", "PF4";
> +				allwinner,function =3D "uart0";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +
> +			i2c0_pins_a: i2c0@0 {
> +				allwinner,pins =3D "PH2", "PH3";
> +				allwinner,function =3D "i2c0";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +
> +			i2c1_pins_a: i2c1@0 {
> +				allwinner,pins =3D "PH4", "PH5";
> +				allwinner,function =3D "i2c1";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +		};
> +
> +		ahb1_rst: reset@01c202c0 {
> +			#reset-cells =3D <1>;
> +			compatible =3D "allwinner,sun6i-a31-ahb1-reset";
> +			reg =3D <0x01c202c0 0xc>;
> +		};
> +
> +		apb1_rst: reset@01c202d0 {
> +			#reset-cells =3D <1>;
> +			compatible =3D "allwinner,sun6i-a31-clock-reset";
> +			reg =3D <0x01c202d0 0x4>;
> +		};
> +
> +		apb2_rst: reset@01c202d8 {
> +			#reset-cells =3D <1>;
> +			compatible =3D "allwinner,sun6i-a31-clock-reset";
> +			reg =3D <0x01c202d8 0x4>;
> +		};
> +
> +		timer@01c20c00 {
> +			compatible =3D "allwinner,sun4i-a10-timer";
> +			reg =3D <0x01c20c00 0xa0>;
> +			interrupts =3D <0 18 4>,
> +				     <0 19 4>;
> +			clocks =3D <&osc24M>;
> +		};
> +
> +		wdt0: watchdog@01c20ca0 {
> +			compatible =3D "allwinner,sun6i-a31-wdt";
> +			reg =3D <0x01c20ca0 0x20>;
> +			interrupts =3D <0 25 4>;
> +		};
> +
> +		uart0: serial@01c28000 {
> +			compatible =3D "snps,dw-apb-uart";
> +			reg =3D <0x01c28000 0x400>;
> +			interrupts =3D <0 0 4>;
> +			reg-shift =3D <2>;
> +			reg-io-width =3D <4>;
> +			clocks =3D <&apb2_gates 16>;
> +			resets =3D <&apb2_rst 16>;
> +			status =3D "disabled";
> +		};
> +
> +		uart1: serial@01c28400 {
> +			compatible =3D "snps,dw-apb-uart";
> +			reg =3D <0x01c28400 0x400>;
> +			interrupts =3D <0 1 4>;
> +			reg-shift =3D <2>;
> +			reg-io-width =3D <4>;
> +			clocks =3D <&apb2_gates 17>;
> +			resets =3D <&apb2_rst 17>;
> +			status =3D "disabled";
> +		};
> +
> +		uart2: serial@01c28800 {
> +			compatible =3D "snps,dw-apb-uart";
> +			reg =3D <0x01c28800 0x400>;
> +			interrupts =3D <0 2 4>;
> +			reg-shift =3D <2>;
> +			reg-io-width =3D <4>;
> +			clocks =3D <&apb2_gates 18>;
> +			resets =3D <&apb2_rst 18>;
> +			status =3D "disabled";
> +		};
> +
> +		uart3: serial@01c28c00 {
> +			compatible =3D "snps,dw-apb-uart";
> +			reg =3D <0x01c28c00 0x400>;
> +			interrupts =3D <0 3 4>;
> +			reg-shift =3D <2>;
> +			reg-io-width =3D <4>;
> +			clocks =3D <&apb2_gates 19>;
> +			resets =3D <&apb2_rst 19>;
> +			status =3D "disabled";
> +		};
> +
> +		uart4: serial@01c29000 {
> +			compatible =3D "snps,dw-apb-uart";
> +			reg =3D <0x01c29000 0x400>;
> +			interrupts =3D <0 4 4>;
> +			reg-shift =3D <2>;
> +			reg-io-width =3D <4>;
> +			clocks =3D <&apb2_gates 20>;
> +			resets =3D <&apb2_rst 20>;
> +			status =3D "disabled";
> +		};
> +
> +		i2c0: i2c@01c2ac00 {
> +			compatible =3D "allwinner,sun6i-a31-i2c";
> +			reg =3D <0x01c2ac00 0x400>;
> +			interrupts =3D <0 6 4>;
> +			clocks =3D <&apb2_gates 0>;
> +			clock-frequency =3D <100000>;
> +			resets =3D <&apb2_rst 0>;
> +			status =3D "disabled";
> +		};
> +
> +		i2c1: i2c@01c2b000 {
> +			compatible =3D "allwinner,sun6i-a31-i2c";
> +			reg =3D <0x01c2b000 0x400>;
> +			interrupts =3D <0 7 4>;
> +			clocks =3D <&apb2_gates 1>;
> +			clock-frequency =3D <100000>;
> +			resets =3D <&apb2_rst 1>;
> +			status =3D "disabled";
> +		};
> +
> +		i2c2: i2c@01c2b400 {
> +			compatible =3D "allwinner,sun6i-a31-i2c";
> +			reg =3D <0x01c2b400 0x400>;
> +			interrupts =3D <0 8 4>;
> +			clocks =3D <&apb2_gates 2>;
> +			clock-frequency =3D <100000>;
> +			resets =3D <&apb2_rst 2>;
> +			status =3D "disabled";
> +		};
> +
> +		spi0: spi@01c68000 {
> +			compatible =3D "allwinner,sun6i-a31-spi";
> +			reg =3D <0x01c68000 0x1000>;
> +			interrupts =3D <0 65 4>;
> +			clocks =3D <&ahb1_gates 20>, <&spi0_clk>;
> +			clock-names =3D "ahb", "mod";
> +			resets =3D <&ahb1_rst 20>;
> +			status =3D "disabled";
> +		};
> +
> +		spi1: spi@01c69000 {
> +			compatible =3D "allwinner,sun6i-a31-spi";
> +			reg =3D <0x01c69000 0x1000>;
> +			interrupts =3D <0 66 4>;
> +			clocks =3D <&ahb1_gates 21>, <&spi1_clk>;
> +			clock-names =3D "ahb", "mod";
> +			resets =3D <&ahb1_rst 21>;
> +			status =3D "disabled";
> +		};
> +
> +		gic: interrupt-controller@01c81000 {
> +			compatible =3D "arm,cortex-a7-gic", "arm,cortex-a15-gic";
> +			reg =3D <0x01c81000 0x1000>,
> +			      <0x01c82000 0x1000>;
> +			interrupt-controller;
> +			#interrupt-cells =3D <3>;
> +		};
> +
> +		nmi_intc: interrupt-controller@01f00c0c {
> +			compatible =3D "allwinner,sun6i-a31-sc-nmi";
> +			interrupt-controller;
> +			#interrupt-cells =3D <2>;
> +			reg =3D <0x01f00c0c 0x38>;
> +			interrupts =3D <0 32 4>;
> +		};
> +
> +		prcm@01f01400 {
> +			compatible =3D "allwinner,sun8i-a23-prcm";
> +			reg =3D <0x01f01400 0x200>;
> +
> +			ar100: ar100_clk {
> +				compatible =3D "fixed-factor-clock";
> +				#clock-cells =3D <0>;
> +				clock-div =3D <1>;
> +				clock-mult =3D <1>;
> +				clocks =3D <&osc24M>;
> +				clock-output-names =3D "ar100";
> +			};
> +
> +			ahb0: ahb0_clk {
> +				compatible =3D "fixed-factor-clock";
> +				#clock-cells =3D <0>;
> +				clock-div =3D <1>;
> +				clock-mult =3D <1>;
> +				clocks =3D <&ar100>;
> +				clock-output-names =3D "ahb0";
> +			};
> +
> +			apb0: apb0_clk {
> +				compatible =3D "allwinner,sun8i-a23-apb0-clk";
> +				#clock-cells =3D <0>;
> +				clocks =3D <&ahb0>;
> +				clock-output-names =3D "apb0";
> +			};
> +
> +			apb0_gates: apb0_gates_clk {
> +				compatible =3D "allwinner,sun6i-a31-apb0-gates-clk";
> +				#clock-cells =3D <1>;
> +				clocks =3D <&apb0>;
> +				clock-indices =3D <0>, <2>, <3>, <4>, <6>;
> +				clock-output-names =3D "apb0_pio", "apb0_timer",
> +						"apb0_rsb", "apb0_uart",
> +						"apb0_i2c";
> +			};
> +
> +			apb0_rst: apb0_rst {
> +				compatible =3D "allwinner,sun6i-a31-clock-reset";
> +				#reset-cells =3D <1>;
> +			};
> +		};
> +
> +		cpucfg@01f01c00 {
> +			compatible =3D "allwinner,sun8i-a23-cpuconfig";
> +			reg =3D <0x01f01c00 0x300>;
> +		};
> +
> +		r_uart: serial@01f02800 {
> +			compatible =3D "snps,dw-apb-uart";
> +			reg =3D <0x01f02800 0x400>;
> +			interrupts =3D <0 38 4>;
> +			reg-shift =3D <2>;
> +			reg-io-width =3D <4>;
> +			clocks =3D <&apb0_gates 4>;
> +			resets =3D <&apb0_rst 4>;
> +			status =3D "disabled";
> +		};
> +
> +		r_pio: pinctrl@01f02c00 {
> +			compatible =3D "allwinner,sun8i-a23-r-pinctrl";
> +			reg =3D <0x01f02c00 0x400>;
> +			interrupts =3D <0 45 4>;
> +			clocks =3D <&apb0_gates 0>;
> +			resets =3D <&apb0_rst 0>;
> +			gpio-controller;
> +			interrupt-controller;
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +			#gpio-cells =3D <3>;
> +
> +			r_uart_pins_a: r_uart@0 {
> +				allwinner,pins =3D "PL2", "PL3";
> +				allwinner,function =3D "s_uart";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +
> +		};
> +	};
> +};

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ELawpaRm0uGyL1wg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgkbFAAoJEBx+YmzsjxAg1GAQAItJPVZCNs8cdD60dL9IvwzJ
hUj5+AqNZOMFOtMQdoKIVXljnPlrjrvQvB0H+9t/G2sdXWkFFVbJ2lvKm+kaHGs/
/vMy1qK61ylpjC2CxH/WN+8fnV6j/Hi3GIcXFE0eVVHZq6f/4crbRyxT7l+RRqa9
BgUGqwDap5KANjhwtrseEThGcukSs+euhWoMJoto8fdb32VkvisnYf6Crbk26kfv
nJgvVV2w2IStX0oIh7Tn6KhFWZeyWoJA2pET5Eku69EBh8wiKwaEIyE/OsBAPuzK
7aVnQ3r/6rsRdoA25w3MwrnTTa7Bf7fRc127nLQKRPteCxzAcEbL6l3IDb0M3Gps
5kMM9u5gnBwnnacz+ajWpMYdYF5bZ9lSgg+iDwVuehAMNYHnKV/nnNTbpCE51iGu
xui1l2l3kkQ5ZS6H4dauqGZuQnjAd8LNzqIegzcFfv2OcVPZC0HzBL4wyohRtDHK
jmiyNym246qKM0e7hwkhtZ7qs5EUaqy60mBUVZXso0cue8VrR/h1NN/zWDTTiEvq
vniQCVGPpG5Qb7HuyQLAbxWTugEzrHwX4aRS+N+4XkKGjog0g3zfPfyDVTsgRmaT
dp78OedOE67IGs+48rPK8FAOFgry5LIcNJBPcODO3DIelbtxRVJo1qOdGHkhZMT2
D90K3nvxTAE7zkSmbIKj
=ogRc
-----END PGP SIGNATURE-----

--ELawpaRm0uGyL1wg--
