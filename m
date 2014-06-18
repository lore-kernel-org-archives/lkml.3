Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaFRTbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:31:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55154 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbaFRTbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:31:48 -0400
Date: Wed, 18 Jun 2014 14:31:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Felipe Balbi <balbi@ti.com>, Benoit Cousson <bcousson@baylibre.com>,
        <robh+dt@kernel.org>, <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, <r.sricharan@ti.com>,
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Josh Elliot <jelliott@ti.com>, Darren Etheridge <detheridge@ti.com>
Subject: Re: [PATCH v2 2/2] arm: dts: add support for AM437x StarterKit
Message-ID: <20140618193113.GC4570@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403106200-777-1-git-send-email-balbi@ti.com>
 <1403106200-777-3-git-send-email-balbi@ti.com>
 <53A1BADD.7050309@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <53A1BADD.7050309@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 11:14:21AM -0500, Nishanth Menon wrote:
> On 06/18/2014 10:43 AM, Felipe Balbi wrote:
> > Add support for TI's AM437x StarterKit Evaluation
> > Module.
>=20
> is there a link for this platform?

internal only

> > Cc: Josh Elliot <jelliott@ti.com>
> > Cc: Darren Etheridge <detheridge@ti.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  .../devicetree/bindings/arm/omap/omap.txt          |   3 +
> >  arch/arm/boot/dts/Makefile                         |   1 +
> >  arch/arm/boot/dts/am437x-sk-evm.dts                | 583 +++++++++++++=
++++++++
> >  3 files changed, 587 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/am437x-sk-evm.dts
> >=20
> > diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Docu=
mentation/devicetree/bindings/arm/omap/omap.txt
> > index d22b216..0edc903 100644
> > --- a/Documentation/devicetree/bindings/arm/omap/omap.txt
> > +++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
> > @@ -129,6 +129,9 @@ Boards:
> >  - AM437x GP EVM
> >    compatible =3D "ti,am437x-gp-evm", "ti,am4372", "ti,am43"
> > =20
> > +- AM437x SK EVM: AM437x StarterKit Evaluation Module
> > +  compatible =3D "ti,am437x-sk-evm", "ti,am4372", "ti,am43"
> > +
> >  - DRA742 EVM:  Software Development Board for DRA742
> >    compatible =3D "ti,dra7-evm", "ti,dra742", "ti,dra74", "ti,dra7"
> > =20
> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> > index 621c6c5..a85a4b8 100644
> > --- a/arch/arm/boot/dts/Makefile
> > +++ b/arch/arm/boot/dts/Makefile
> > @@ -306,6 +306,7 @@ dtb-$(CONFIG_ARCH_OMAP4) +=3D omap4-duovero-parlor.=
dtb \
> >  	omap4-var-dvk-om44.dtb \
> >  	omap4-var-stk-om44.dtb
> >  dtb-$(CONFIG_SOC_AM43XX) +=3D am43x-epos-evm.dtb \
> > +	am437x-sk-evm.dtb \
> >  	am437x-gp-evm.dtb
> >  dtb-$(CONFIG_SOC_OMAP5) +=3D omap5-cm-t54.dtb \
> >  	omap5-sbc-t54.dtb \
> > diff --git a/arch/arm/boot/dts/am437x-sk-evm.dts b/arch/arm/boot/dts/am=
437x-sk-evm.dts
> > new file mode 100644
> > index 0000000..e7a2bbe
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/am437x-sk-evm.dts
> > @@ -0,0 +1,583 @@
> > +/*
> > + * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.c=
om/
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +/* AM437x SK EVM */
> ??
> > +
> > +/dts-v1/;
> > +
> > +#include "am4372.dtsi"
> > +#include <dt-bindings/pinctrl/am43xx.h>
> > +#include <dt-bindings/pwm/pwm.h>
> > +#include <dt-bindings/gpio/gpio.h>
> > +#include <dt-bindings/input/input.h>
> > +
> > +/ {
> > +	model =3D "TI AM437x SK EVM";
> > +	compatible =3D "ti,am437x-sk-evm","ti,am4372","ti,am43";
> > +
> > +	aliases {
> > +		display0 =3D &lcd0;
> > +	};
> > +
> > +	backlight {
> > +		compatible =3D "pwm-backlight";
> > +		pwms =3D <&ecap0 0 50000 PWM_POLARITY_INVERTED>;
> > +		brightness-levels =3D <0 51 53 56 62 75 101 152 255>;
> > +		default-brightness-level =3D <8>;
> > +	};
> > +
> > +	sound {
> > +		compatible =3D "ti,da830-evm-audio";
> > +		ti,model =3D "AM437x-SK-EVM";
> > +		ti,audio-codec =3D <&tlv320aic3106>;
> > +		ti,mcasp-controller =3D <&mcasp1>;
> > +		ti,codec-clock-rate =3D <24000000>;
> > +		ti,audio-routing =3D
> > +			"Headphone Jack",       "HPLOUT",
> > +			"Headphone Jack",       "HPROUT";
> > +	};
> > +
> > +	matrix_keypad: matrix_keypad@0 {
> > +		compatible =3D "gpio-matrix-keypad";
>=20
> no pinctrl needed?

pins are gpio by default

> > +		debounce-delay-ms =3D <5>;
> > +		col-scan-delay-us =3D <1500>;
> > +
> > +		row-gpios =3D <&gpio5 5 GPIO_ACTIVE_HIGH		/* Bank5, pin5 */
> > +				&gpio5 6 GPIO_ACTIVE_HIGH>;	/* Bank5, pin6 */
> > +
> > +		col-gpios =3D <&gpio5 13 GPIO_ACTIVE_HIGH		/* Bank5, pin13 */
> > +				&gpio5 4 GPIO_ACTIVE_HIGH>;	/* Bank5, pin4 */
> > +
> > +		linux,keymap =3D <
> > +				MATRIX_KEY(0, 0, KEY_DOWN)
> > +				MATRIX_KEY(0, 1, KEY_RIGHT)
> > +				MATRIX_KEY(1, 0, KEY_LEFT)
> > +				MATRIX_KEY(1, 1, KEY_UP)
> > +			>;
> > +	};
> > +
> > +	leds {
> > +		compatible =3D "gpio-leds";
> no pinctrl needed?

likewise

> > +		led@0 {
> > +			label =3D "am437x-sk:red:heartbeat";
> > +			gpios =3D <&gpio5 0 GPIO_ACTIVE_HIGH>;	/* Bank 5, pin 0 */
> > +			linux,default-trigger =3D "heartbeat";
> > +			default-state =3D "off";
> > +		};
> > +
> > +		led@1 {
> > +			label =3D "am437x-sk:green:mmc1";
> > +			gpios =3D <&gpio5 1 GPIO_ACTIVE_HIGH>;	/* Bank 5, pin 1 */
> > +			linux,default-trigger =3D "mmc0";
> > +			default-state =3D "off";
> > +		};
> > +
> > +		led@2 {
> > +			label =3D "am437x-sk:blue:cpu0";
> > +			gpios =3D <&gpio5 2 GPIO_ACTIVE_HIGH>;	/* Bank 5, pin 2 */
> > +			linux,default-trigger =3D "cpu0";
> > +			default-state =3D "off";
> > +		};
> > +
> > +		led@3 {
> > +			label =3D "am437x-sk:blue:usr3";
> > +			gpios =3D <&gpio5 3 GPIO_ACTIVE_HIGH>;	/* Bank 5, pin 3 */
> > +			default-state =3D "off";
> > +		};
> > +	};
> > +
> > +	lcd0: display {
> > +		compatible =3D "osddisplays,osd057T0559-34ts", "panel-dpi";
> > +		label =3D "lcd";
> > +
> > +		pinctrl-names =3D "default";
> > +		pinctrl-0 =3D <&lcd_pins>;
> > +
> > +		enable-gpios =3D <&gpio1 7 GPIO_ACTIVE_HIGH>;
> > +
> > +		panel-timing {
> > +			clock-frequency =3D <9000000>;
> > +			hactive =3D <480>;
> > +			vactive =3D <272>;
> > +			hfront-porch =3D <8>;
> > +			hback-porch =3D <43>;
> > +			hsync-len =3D <4>;
> > +			vback-porch =3D <12>;
> > +			vfront-porch =3D <4>;
> > +			vsync-len =3D <10>;
> > +			hsync-active =3D <0>;
> > +			vsync-active =3D <0>;
> > +			de-active =3D <1>;
> > +			pixelclk-active =3D <1>;
> > +		};
> > +
> > +		port {
> > +			lcd_in: endpoint {
> > +				remote-endpoint =3D <&dpi_out>;
> > +			};
> > +		};
> > +	};
> > +};
> > +
> > +&am43xx_pinmux {
> > +	i2c0_pins: i2c0_pins {
> > +		pinctrl-single,pins =3D <
> > +			0x188 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)  /* i2c0_sda.i=
2c0_sda */
> > +			0x18c (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)  /* i2c0_scl.i=
2c0_scl */
> > +		>;
> > +	};
> > +
> > +	i2c1_pins: i2c1_pins {
> > +		pinctrl-single,pins =3D <
> > +			0x15c (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE2)  /* spi0_cs0.i=
2c1_scl */
> > +			0x158 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE2)  /* spi0_d1.i2=
c1_sda  */
> > +		>;
> > +	};
> > +
> > +	mmc1_pins: pinmux_mmc1_pins {
> > +		pinctrl-single,pins =3D <
> > +			0x160 (PIN_INPUT | MUX_MODE7) /* spi0_cs1.gpio0_6 */
> > +		>;
> > +	};
> > +
> > +	ecap0_pins: backlight_pins {
> > +		pinctrl-single,pins =3D <
> > +			0x164 MUX_MODE0       /* eCAP0_in_PWM0_out.eCAP0_in_PWM0_out MODE0 =
*/
> pin direction?



> > +		>;
> > +	};
> > +
> > +	edt_ft5306_ts_pins: edt_ft5306_ts_pins {
> > +		pinctrl-single,pins =3D <
> > +			0x74 (PIN_INPUT | MUX_MODE7)	/* gpmc_wpn.gpio0_31 */
> > +			0x78 (PIN_OUTPUT | MUX_MODE7)	/* gpmc_be1n.gpio1_28 */
> > +		>;
> > +	};
> > +
> > +	cpsw_default: cpsw_default {
> > +		pinctrl-single,pins =3D <
> > +			/* Slave 1 */
> > +			0x12c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txclk.rmii1_tclk */
> > +			0x114 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txen.rgmii1_tctl */
> > +			0x128 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd0.rgmii1_td0 */
> > +			0x124 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd1.rgmii1_td1 */
> > +			0x120 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd0.rgmii1_td2 */
> > +			0x11c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd1.rgmii1_td3 */
> > +			0x130 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxclk.rmii1_rclk */
> > +			0x118 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxdv.rgmii1_rctl */
> > +			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd0.rgmii1_rd0 */
> > +			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd1.rgmii1_rd1 */
> > +			0x138 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd0.rgmii1_rd2 */
> > +			0x134 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd1.rgmii1_rd3 */
> > +
> > +			/* Slave 2 */
> > +			0x58 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a6.rgmii2_tclk */
> > +			0x40 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a0.rgmii2_tctl */
> > +			0x54 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a5.rgmii2_td0 */
> > +			0x50 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a4.rgmii2_td1 */
> > +			0x4c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a3.rgmii2_td2 */
> > +			0x48 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a2.rgmii2_td3 */
> > +			0x5c (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a7.rgmii2_rclk */
> > +			0x44 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a1.rgmii2_rtcl */
> > +			0x6c (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a11.rgmii2_rd0 */
> > +			0x68 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a10.rgmii2_rd1 */
> > +			0x64 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a9.rgmii2_rd2 */
> > +			0x60 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a8.rgmii2_rd3 */
> > +		>;
> > +	};
> > +
> > +	cpsw_sleep: cpsw_sleep {
> > +		pinctrl-single,pins =3D <
> > +			/* Slave 1 reset value */
> > +			0x12c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x114 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x128 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x124 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x120 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x11c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x130 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x118 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x138 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x134 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +
> > +			/* Slave 2 reset value */
> > +			0x58 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x40 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x54 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x50 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x4c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x48 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x5c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x44 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x6c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x68 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x64 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x60 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +		>;
> > +	};
> > +
> > +	davinci_mdio_default: davinci_mdio_default {
> > +		pinctrl-single,pins =3D <
> > +			/* MDIO */
> > +			0x148 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)	/* mdio_data.m=
dio_data */
> > +			0x14c (PIN_OUTPUT_PULLUP | MUX_MODE0)			/* mdio_clk.mdio_clk */
> > +		>;
> > +	};
> > +
> > +	davinci_mdio_sleep: davinci_mdio_sleep {
> > +		pinctrl-single,pins =3D <
> > +			/* MDIO reset value */
> > +			0x148 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +			0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> > +		>;
> > +	};
> > +
> > +	dss_pins: dss_pins {
> > +		pinctrl-single,pins =3D <
> > +			0x020 (PIN_OUTPUT_PULLUP | MUX_MODE1)	/* gpmc ad 8 -> DSS DATA 23 */
> > +			0x024 (PIN_OUTPUT_PULLUP | MUX_MODE1)
> > +			0x028 (PIN_OUTPUT_PULLUP | MUX_MODE1)
> > +			0x02c (PIN_OUTPUT_PULLUP | MUX_MODE1)
> > +			0x030 (PIN_OUTPUT_PULLUP | MUX_MODE1)
> > +			0x034 (PIN_OUTPUT_PULLUP | MUX_MODE1)
> > +			0x038 (PIN_OUTPUT_PULLUP | MUX_MODE1)
> > +			0x03c (PIN_OUTPUT_PULLUP | MUX_MODE1)	/* gpmc ad 15 -> DSS DATA 16 =
*/
> > +			0x0a0 (PIN_OUTPUT_PULLUP | MUX_MODE0)	/* DSS DATA 0 */
> > +			0x0a4 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0a8 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0ac (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0b0 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0b4 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0b8 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0bc (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0c0 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0c4 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0c8 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0cc (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0d0 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0d4 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0d8 (PIN_OUTPUT_PULLUP | MUX_MODE0)
> > +			0x0dc (PIN_OUTPUT_PULLUP | MUX_MODE0)	/* DSS DATA 15 */
> > +			0x0e0 (PIN_OUTPUT_PULLUP | MUX_MODE0)	/* DSS VSYNC */
> > +			0x0e4 (PIN_OUTPUT_PULLUP | MUX_MODE0)	/* DSS HSYNC */
> > +			0x0e8 (PIN_OUTPUT_PULLUP | MUX_MODE0)	/* DSS PCLK */
> > +			0x0ec (PIN_OUTPUT_PULLUP | MUX_MODE0)	/* DSS AC BIAS EN */
> > +
> > +		>;
> > +	};
> > +
> > +	qspi_pins: qspi_pins {
> > +		pinctrl-single,pins =3D <
> > +			0x7c (PIN_OUTPUT_PULLUP | MUX_MODE3)	/* gpmc_csn0.qspi_csn */
> > +			0x88 (PIN_OUTPUT | MUX_MODE2)		/* gpmc_csn3.qspi_clk */
> > +			0x90 (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_advn_ale.qspi_d0 */
> > +			0x94 (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_oen_ren.qspi_d1 */
> > +			0x98 (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_wen.qspi_d2 */
> > +			0x9c (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_be0n_cle.qspi_d3 */
> > +		>;
> > +	};
> > +
> > +	mcasp1_pins: mcasp1_pins {
> > +		pinctrl-single,pins =3D <
> > +			0x10c (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* mii1_crs.mcasp1_aclkx */
> > +			0x110 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* mii1_rxerr.mcasp1_fsx */
> > +			0x108 (PIN_OUTPUT_PULLDOWN | MUX_MODE4)	/* mii1_col.mcasp1_axr2 */
> > +			0x144 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* rmii1_ref_clk.mcasp1_axr3=
 */
> > +		>;
> > +	};
> > +
> > +	lcd_pins: lcd_pins {
> > +		pinctrl-single,pins =3D <
> > +			/* GPIO 5_8 to select LCD / HDMI */
> > +			0x238 (PIN_OUTPUT_PULLUP | MUX_MODE7)
> > +		>;
> > +	};
> > +};
> > +
> > +&i2c0 {
> > +        status =3D "okay";
> > +        pinctrl-names =3D "default";
> > +        pinctrl-0 =3D <&i2c0_pins>;
>=20
> what speed are you running this on? -> also can you align these to 1

100kHz ?

> tab instead of spaces?

weird, I remember aligning everything with tabs. Will fix that up.

> > +	tps@24 {
> > +		compatible =3D "ti,tps65218";
> > +		reg =3D <0x24>;
> > +		interrupt-parent =3D <&gic>;
> > +		interrupts =3D <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
>=20
> is this muxed?

there's no configuration for this. This pin is a single function.

> > +		interrupt-controller;
> > +		#interrupt-cells =3D <2>;
> > +
> > +		dcdc1: regulator-dcdc1 {
> > +			compatible =3D "ti,tps65218-dcdc1";
> > +			/* VDD_CORE limits min of OPP50 and max of OPP100 */
> > +			regulator-name =3D "vdd_core";
> > +			regulator-min-microvolt =3D <912000>;
> > +			regulator-max-microvolt =3D <1144000>;
> > +			regulator-boot-on;
> > +			regulator-always-on;
> > +		};
> > +
> > +		dcdc2: regulator-dcdc2 {
> > +			compatible =3D "ti,tps65218-dcdc2";
> > +			/* VDD_MPU limits min of OPP50 and max of OPP_NITRO */
> > +			regulator-name =3D "vdd_mpu";
> > +			regulator-min-microvolt =3D <912000>;
> > +			regulator-max-microvolt =3D <1378000>;
> > +			regulator-boot-on;
> > +			regulator-always-on;
> > +		};
> > +
> > +		dcdc3: regulator-dcdc3 {
> > +			compatible =3D "ti,tps65218-dcdc3";
> > +			regulator-name =3D "vdds_ddr";
> no voltage ?

has no users in kernel. Also, it comes out with default, and correct,
voltage.

> > +			regulator-boot-on;
> > +			regulator-always-on;
> > +		};
> > +
> > +		dcdc4: regulator-dcdc4 {
> > +			compatible =3D "ti,tps65218-dcdc4";
> > +			regulator-name =3D "v3_3d";
> > +			regulator-min-microvolt =3D <3300000>;
> > +			regulator-max-microvolt =3D <3300000>;
> > +			regulator-boot-on;
> > +			regulator-always-on;
> > +		};
> > +
> > +		ldo1: regulator-ldo1 {
> > +			compatible =3D "ti,tps65218-ldo1";
> > +			regulator-name =3D "v1_8d";
> > +			regulator-min-microvolt =3D <1800000>;
> > +			regulator-max-microvolt =3D <1800000>;
> > +			regulator-boot-on;
> > +			regulator-always-on;
> > +		};
> > +
> > +	};
> > +
> > +	at24@50 {
> > +		compatible =3D "at24,24c256";
> > +		pagesize =3D <64>;
> > +		reg =3D <0x50>;
> > +	};
> > +};
> > +
> > +&i2c1 {
> > +        status =3D "okay";
> > +        pinctrl-names =3D "default";
> > +        pinctrl-0 =3D <&i2c1_pins>;
> ^^ alignment problem
>=20
> Also speed please.

will add.

> > +	edt-ft5306@38 {
> > +		status =3D "okay";
> > +		compatible =3D "edt,edt-ft5306", "edt,edt-ft5x06";
> > +		pinctrl-names =3D "default";
> > +		pinctrl-0 =3D <&edt_ft5306_ts_pins>;
> > +		reg =3D <0x38>;
> > +		interrupt-parent =3D <&gpio0>;
> > +		interrupts =3D <31 0>;
> > +
> > +		wake-gpios =3D <&gpio1 28 GPIO_ACTIVE_HIGH>;
>=20
> why wake-gpios? we should be using pinctrl with interrupt-extended to
> do wakeup sequence, no?

sure, can you patch the edt driver ? I'll fix the DTS after that gets
merged

> > +		touchscreen-size-x =3D <480>;
> > +		touchscreen-size-y =3D <272>;
> > +	};
> > +
> > +	tlv320aic3106: tlv320aic3106@1b {
> > +		compatible =3D "ti,tlv320aic3106";
> > +		reg =3D <0x1b>;
> > +		status =3D "okay";
> > +
> > +		/* Regulators */
> > +		AVDD-supply =3D <&dcdc4>;
> > +		IOVDD-supply =3D <&dcdc4>;
> > +		DRVDD-supply =3D <&dcdc4>;
> > +		DVDD-supply =3D <&ldo1>;
> > +	};
> > +
> > +	lis331dlh@18 {
> > +		compatible =3D "st,lis331dlh";
> > +		reg =3D <0x18>;
> > +		status =3D "okay";
> > +
> > +		Vdd-supply =3D <&dcdc4>;
> > +		Vdd_IO-supply =3D <&dcdc4>;
> > +		interrupts-extended =3D <&gpio1 6 0>, <&gpio2 1 0>;
> > +	};
> > +};
> > +
> > +&epwmss0 {
> > +	status =3D "okay";
> > +};
> > +
> > +&ecap0 {
> > +	status =3D "okay";
> > +	pinctrl-names =3D "default";
> > +	pinctrl-0 =3D <&ecap0_pins>;
> > +};
> > +
> > +&gpio0 {
> > +	status =3D "okay";
> > +};
> > +
> > +&gpio1 {
> > +	status =3D "okay";
> > +};
> > +
> > +&gpio5 {
> > +	status =3D "okay";
> > +};
> > +
> > +&mmc1 {
> > +	status =3D "okay";
> > +	vmmc-supply =3D <&dcdc4>;
> > +	bus-width =3D <4>;
> > +	pinctrl-names =3D "default";
> > +	pinctrl-0 =3D <&mmc1_pins>;
>=20
> just for style, wonder if moving the pinctrl just after status is better?

why ? makes no difference.

> > +	cd-gpios =3D <&gpio0 6 GPIO_ACTIVE_HIGH>;
> > +};
> > +
> > +&usb2_phy1 {
> > +	status =3D "okay";
> > +};
> > +
> > +&usb1 {
> > +	dr_mode =3D "peripheral";
> > +	status =3D "okay";
> > +};
> > +
> > +&usb2_phy2 {
> > +	status =3D "okay";
> > +};
> > +
> > +&usb2 {
> > +	dr_mode =3D "host";
> > +	status =3D "okay";
> > +};
> none of the above need pinctrl? no regulator supplies?

pins in default states, drivers don't use regulators.

> > +&qspi {
> > +	status =3D "okay";
> > +	pinctrl-names =3D "default";
> > +	pinctrl-0 =3D <&qspi_pins>;
> > +
> > +	spi-max-frequency =3D <48000000>;
> > +	m25p80@0 {
> > +		compatible =3D "mx66l51235l";
> > +		spi-max-frequency =3D <48000000>;
> > +		reg =3D <0>;
> > +		spi-cpol;
> > +		spi-cpha;
> > +		spi-tx-bus-width =3D <1>;
> > +		spi-rx-bus-width =3D <4>;
> > +		#address-cells =3D <1>;
> > +		#size-cells =3D <1>;
> > +
> > +		/* MTD partition table.
> /*
>  * MTD partition table.
> ?

can be fixed.

--=20
balbi

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToekBAAoJEIaOsuA1yqREH38QAIptr1aSdMZqTK05B8YJUcan
pFYfuuiIXSy7D2nGa/fv4LsvRoKmNh/HhUwHRLkbuyW6V/007R5N45zYVYiZ1oYW
PTd9QriqhNza4WYt/N/CYlLRGEJeDT/jCiJCY+6vQlxedbnIQFXKzZ1tL/Rs8eqo
NEUuSoEjqOSGLY7/2D1pNIn6b7UUrvq/7xP7ZpT1+jmO+mANQ5wu4ZZwUZI0SZmo
aveUz2PzlD4i3wf9+s7B8lrXLD2n6a4YN/aVRdLLN4FAbDBVjl5LeKq4g/4yYPFs
3+bdi307XFNh07k8dHkSBUuO4250k6DRVDLJxFimfBaKF/cnfX08KeFlgOxR+Hse
oAfg3GeNxx9EoKAO9711yZidP2mLUuNVtRSYkbQUuujMeN/xLj11e9mIwWM2HBRo
CbqwShDfTXqbmkL9va92Cj9hKzpjm3o4nSq/y2oW44aPEZA8pe5QzA1rEzQYg9Ji
ykHN9SIJHH5dblqVluAEQLSF0LoulXm/R0ed6QMlzmh98hUBfqwu+reCPK9drtSt
9wweGxrOVlPLaXMQjNRESYoR8XExqtzRRqOlJJ1nsDCBZaBBwYzfpxANGOaEc9v3
aCuHdC0x2Bpyn8lWW+ipAcAdRshwoBf/CgPcpQTlVilkio20TflmCFOVbaIdovM7
B/Lm14LPBZ+zjzFVB/4V
=E9mJ
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
