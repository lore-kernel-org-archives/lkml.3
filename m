Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaFMQcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:32:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40168 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbaFMQcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:32:14 -0400
Date: Fri, 13 Jun 2014 11:31:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Elliot <jelliott@ti.com>, Darren Etheridge <detheridge@ti.com>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>
Subject: Re: [PATCH 2/2] arm: dts: add support for AM437x StarterKit
Message-ID: <20140613163118.GJ8319@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-3-git-send-email-balbi@ti.com>
 <20140613162334.GI8319@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3snK74p7ddXn3Qrx"
Content-Disposition: inline
In-Reply-To: <20140613162334.GI8319@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3snK74p7ddXn3Qrx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

adding devicetree and some others

On Fri, Jun 13, 2014 at 11:23:34AM -0500, Felipe Balbi wrote:
> On Fri, Jun 13, 2014 at 11:15:47AM -0500, Felipe Balbi wrote:
> > Add support for TI's AM437x StarterKit Evaluation
> > Module.
> >=20
> > Cc: Josh Elliot <jelliott@ti.com>
> > Cc: Darren Etheridge <detheridge@ti.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >=20
> > Thanks to Josh and Darren for helping out with Audio and Display parts =
of this
> > DTS.
> >=20
> >  .../devicetree/bindings/arm/omap/omap.txt          |   3 +
> >  arch/arm/boot/dts/Makefile                         |   1 +
> >  arch/arm/boot/dts/am437x-sk-evm.dts                | 539 +++++++++++++=
++++++++
> >  3 files changed, 543 insertions(+)
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
> > index 0f1e8be..749cdc8 100644
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
> > index 0000000..51ffab1
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/am437x-sk-evm.dts
> > @@ -0,0 +1,539 @@
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
> > +	vmmcsd_fixed: fixedregulator-sd {
> > +		compatible =3D "regulator-fixed";
> > +		regulator-name =3D "vmmcsd_fixed";
> > +		regulator-min-microvolt =3D <3300000>;
> > +		regulator-max-microvolt =3D <3300000>;
> > +		enable-active-high;
> > +	};
> > +
> > +	v33_fixed: fixedregulator-v33 {
> > +		compatible =3D "regulator-fixed";
> > +		regulator-name =3D "v33_fixed";
> > +		regulator-min-microvolt =3D <3300000>;
> > +		regulator-max-microvolt =3D <3300000>;
> > +		enable-active-high;
> > +	};
> > +
> > +	v18_fixed: fixedregulator-v18 {
> > +		compatible =3D "regulator-fixed";
> > +		regulator-name =3D "v18_fixed";
> > +		regulator-min-microvolt =3D <1800000>;
> > +		regulator-max-microvolt =3D <1800000>;
> > +		enable-active-high;
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
> > +
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
> > +
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
> > +
> > +	tps@2d {
> > +		compatible =3D "ti,tps65218";
> > +		reg =3D <0x2d>;
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
> > +
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
> > +
> > +		touchscreen-size-x =3D <800>;
> > +		touchscreen-size-y =3D <600>;
> > +	};
> > +
> > +	tlv320aic3106: tlv320aic3106@1b {
> > +		compatible =3D "ti,tlv320aic3106";
> > +		reg =3D <0x1b>;
> > +		status =3D "okay";
> > +
> > +		/* Regulators */
> > +		AVDD-supply =3D <&v33_fixed>;
> > +		IOVDD-supply =3D <&v33_fixed>;
> > +		DRVDD-supply =3D <&v33_fixed>;
> > +		DVDD-supply =3D <&v18_fixed>;
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
> > +	vmmc-supply =3D <&vmmcsd_fixed>;
> > +	bus-width =3D <4>;
> > +	pinctrl-names =3D "default";
> > +	pinctrl-0 =3D <&mmc1_pins>;
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
> > +
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
> > +		 * The ROM checks the first 512KiB
> > +		 * for a valid file to boot(XIP).
> > +		 */
> > +		partition@0 {
> > +			label =3D "QSPI.U_BOOT";
> > +			reg =3D <0x00000000 0x000080000>;
> > +		};
> > +		partition@1 {
> > +			label =3D "QSPI.U_BOOT.backup";
> > +			reg =3D <0x00080000 0x00080000>;
> > +		};
> > +		partition@2 {
> > +			label =3D "QSPI.U-BOOT-SPL_OS";
> > +			reg =3D <0x00100000 0x00010000>;
> > +		};
> > +		partition@3 {
> > +			label =3D "QSPI.U_BOOT_ENV";
> > +			reg =3D <0x00110000 0x00010000>;
> > +		};
> > +		partition@4 {
> > +			label =3D "QSPI.U-BOOT-ENV.backup";
> > +			reg =3D <0x00120000 0x00010000>;
> > +		};
> > +		partition@5 {
> > +			label =3D "QSPI.KERNEL";
> > +			reg =3D <0x00130000 0x0800000>;
> > +		};
> > +		partition@6 {
> > +			label =3D "QSPI.FILESYSTEM";
> > +			reg =3D <0x00930000 0x36D0000>;
> > +		};
> > +	};
> > +};
> > +
> > +&mac {
> > +	pinctrl-names =3D "default", "sleep";
> > +	pinctrl-0 =3D <&cpsw_default>;
> > +	pinctrl-1 =3D <&cpsw_sleep>;
> > +	dual_emac =3D <1>;
> > +	status =3D "okay";
> > +};
> > +
> > +&davinci_mdio {
> > +	pinctrl-names =3D "default", "sleep";
> > +	pinctrl-0 =3D <&davinci_mdio_default>;
> > +	pinctrl-1 =3D <&davinci_mdio_sleep>;
> > +	status =3D "okay";
> > +};
> > +
> > +&cpsw_emac0 {
> > +	phy_id =3D <&davinci_mdio>, <4>;
> > +	phy-mode =3D "rgmii";
> > +	dual_emac_res_vlan =3D <1>;
> > +};
> > +
> > +&cpsw_emac1 {
> > +	phy_id =3D <&davinci_mdio>, <5>;
> > +	phy-mode =3D "rgmii";
> > +	dual_emac_res_vlan =3D <2>;
> > +};
> > +
> > +&elm {
> > +	status =3D "okay";
> > +};
> > +
> > +&mcasp1 {
> > +	pinctrl-names =3D "default";
> > +	pinctrl-0 =3D <&mcasp1_pins>;
> > +
> > +	status =3D "okay";
> > +
> > +	op-mode =3D <0>;
> > +	tdm-slots =3D <2>;
> > +	serial-dir =3D <
> > +		0 0 1 2
> > +	>;
> > +
> > +	tx-num-evt =3D <1>;
> > +	rx-num-evt =3D <1>;
> > +};
> > +
> > +&dss {
> > +	status =3D "okay";
> > +
> > +	pinctrl-names =3D "default";
> > +	pinctrl-0 =3D <&dss_pins>;
> > +
> > +	port {
> > +		dpi_out: endpoint@0 {
> > +			remote-endpoint =3D <&lcd_in>;
> > +			data-lines =3D <24>;
> > +		};
> > +	};
> > +};
> > --=20
> > 2.0.0.rc1
> >=20
>=20
> --=20
> balbi



--=20
balbi

--3snK74p7ddXn3Qrx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmydWAAoJEIaOsuA1yqRET0QP/2l+159jGKI+ElJvZquCkNm9
SlchfTXaSww6DvBwbeqiiHyLbo6fTHYmBmMSTqk5uvE7unFZfBEcrqqlCFF2jGax
Nf7oFjuBgsHeMhYXjrt9NePaMkiq3Y6bZi5+KQ+1KK3JdF3M/c+jvQrEND/j1VVX
LlJyuzjnyUrtwObP7yubX3/5EXofaBaKHM5lqmjVLO6uVxXJdcdTkBRCyuyOhL7u
xw60mvmebz1FSEEZenAKXT7LHDphn1q62+XSgOW1x2dUUhwdKbnDWDK6V359w3CQ
bciSv42RhCEK5cNaEJtH5cAM5OJJ8O5UDV2h8Uk1CphatzGazVWZm0M2qLp5jKTJ
F+gYIHHT63EQ6ouQcgWJM26BlunorRnU2JFGon97hZj9ye4SLNoEWrXgCBA4ReYr
QHZUG4A5E//lsLvpDGNhyXffk8A7Fkyns0w/l9CrV5nMV2NypYnMRN5teLwXsM9W
ibgYBa7rjYmC5XiE/izNygUxusLzJpXtFj5JBqlyiSBhHtOkBh/n/FwqZXGVZRF6
AxeYxxGZvfF6TIiXQNOeqZY2xoVMRug7rxilUafWwzg21pK+/dM7Mt2TXuN9x/2Z
Te238AcnRPIrRj3JQGQS+c72QHNVcuBqSm1/C3mgGDQ/Wzlp1mYCrybr/4r6VQLn
kPBT9TVFGPCuMrkE6BWz
=6i19
-----END PGP SIGNATURE-----

--3snK74p7ddXn3Qrx--
