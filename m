Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaKQTJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:09:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36459 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbaKQTJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:09:36 -0500
Date: Mon, 17 Nov 2014 13:09:00 -0600
From: Felipe Balbi <balbi@ti.com>
To: George McCollister <george.mccollister@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Joachim Eastwood <manabian@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Carlos Garcia <carlos@cgarcia.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:OMAP DEVICE TREE..." <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ARM: dts: Add devicetree for NovaTech OrionLXm
Message-ID: <20141117190847.GA4857@saruman>
Reply-To: <balbi@ti.com>
References: <1416250957-11065-1-git-send-email-george.mccollister@gmail.com>
 <1416250957-11065-2-git-send-email-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <1416250957-11065-2-git-send-email-george.mccollister@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 01:02:35PM -0600, George McCollister wrote:
> This adds the NovaTech OrionLXm which is based on the AM335x SoC
> http://www.novatechweb.com/substation-automation/orionlxm/
>=20
> RAM: 512MiB
> Flash: 4GB eMMC
> Ethernet PHYs: 2x Micrel KSZ8041FTLI
> USB ports are used internally by the expansion cards.
> Internal micro SD slot is available.
>=20
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

this looks might better to my eyes:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  .../devicetree/bindings/arm/omap/omap.txt          |   3 +
>  arch/arm/boot/dts/Makefile                         |   3 +-
>  arch/arm/boot/dts/am335x-lxm.dts                   | 362 +++++++++++++++=
++++++
>  3 files changed, 367 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/am335x-lxm.dts
>=20
> diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Docume=
ntation/devicetree/bindings/arm/omap/omap.txt
> index ddd9bcd..4f6a82c 100644
> --- a/Documentation/devicetree/bindings/arm/omap/omap.txt
> +++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
> @@ -132,6 +132,9 @@ Boards:
>  - AM335X Bone : Low cost community board
>    compatible =3D "ti,am335x-bone", "ti,am33xx", "ti,omap3"
> =20
> +- AM335X OrionLXm : Substation Automation Platform
> +  compatible =3D "novatech,am335x-lxm", "ti,am33xx"
> +
>  - OMAP5 EVM : Evaluation Module
>    compatible =3D "ti,omap5-evm", "ti,omap5"
> =20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 38c89ca..454ee6c 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -331,7 +331,8 @@ dtb-$(CONFIG_SOC_AM33XX) +=3D am335x-base0033.dtb \
>  	am335x-evm.dtb \
>  	am335x-evmsk.dtb \
>  	am335x-nano.dtb \
> -	am335x-pepper.dtb
> +	am335x-pepper.dtb \
> +	am335x-lxm.dtb
>  dtb-$(CONFIG_ARCH_OMAP4) +=3D omap4-duovero-parlor.dtb \
>  	omap4-panda.dtb \
>  	omap4-panda-a4.dtb \
> diff --git a/arch/arm/boot/dts/am335x-lxm.dts b/arch/arm/boot/dts/am335x-=
lxm.dts
> new file mode 100644
> index 0000000..7266a00
> --- /dev/null
> +++ b/arch/arm/boot/dts/am335x-lxm.dts
> @@ -0,0 +1,362 @@
> +/*
> + * Copyright (C) 2014 NovaTech LLC - http://www.novatechweb.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +/dts-v1/;
> +
> +#include "am33xx.dtsi"
> +
> +/ {
> +	model =3D "NovaTech OrionLXm";
> +	compatible =3D "novatech,am335x-lxm", "ti,am33xx";
> +
> +	cpus {
> +		cpu@0 {
> +			cpu0-supply =3D <&vdd1_reg>;
> +		};
> +	};
> +
> +	memory {
> +		device_type =3D "memory";
> +		reg =3D <0x80000000 0x20000000>; /* 512 MB */
> +	};
> +
> +	/* Power supply provides a fixed 5V @2A */
> +	vbat: fixedregulator@0 {
> +		compatible =3D "regulator-fixed";
> +		regulator-name =3D "vbat";
> +		regulator-min-microvolt =3D <5000000>;
> +		regulator-max-microvolt =3D <5000000>;
> +		regulator-boot-on;
> +	};
> +
> +	/* Power supply provides a fixed 3.3V @3A */
> +	vmmcsd_fixed: fixedregulator@1 {
> +		compatible =3D "regulator-fixed";
> +		regulator-name =3D "vmmcsd_fixed";
> +		regulator-min-microvolt =3D <3300000>;
> +		regulator-max-microvolt =3D <3300000>;
> +		regulator-boot-on;
> +	};
> +};
> +
> +&am33xx_pinmux {
> +	mmc1_pins: pinmux_mmc1_pins {
> +		pinctrl-single,pins =3D <
> +			0xf0 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_dat3 */
> +			0xf4 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_dat2 */
> +			0xf8 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_dat1 */
> +			0xfc (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_dat0 */
> +			0x100 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_clk */
> +			0x104 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_cmd */
> +		>;
> +	};
> +
> +	i2c0_pins: pinmux_i2c0_pins {
> +		pinctrl-single,pins =3D <
> +			0x188 (PIN_INPUT | MUX_MODE0)	/* i2c0_sda.i2c0_sda */
> +			0x18c (PIN_INPUT | MUX_MODE0)	/* i2c0_scl.i2c0_scl */
> +		>;
> +	};
> +
> +	cpsw_default: cpsw_default {
> +		pinctrl-single,pins =3D <
> +			/* Slave 1 */
> +			0x64 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_int */
> +			0x10c (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii1_crs_dv */
> +			0x110 (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii1_rxer */
> +			0x114 (PIN_OUTPUT_PULLDOWN | MUX_MODE1)	/* rmii1_txen */
> +			0x124 (PIN_OUTPUT_PULLDOWN | MUX_MODE1)	/* rmii1_td1 */
> +			0x128 (PIN_OUTPUT_PULLDOWN | MUX_MODE1)	/* rmii1_td0 */
> +			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii1_rd1 */
> +			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii1_rd0 */
> +			0x144 (PIN_INPUT_PULLDOWN | MUX_MODE0)	/* rmii1_refclk */
> +
> +			/* Slave 2 */
> +			0x40 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)	/* rmii2_txen */
> +			0x50 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)	/* rmii2_td1 */
> +			0x54 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)	/* rmii2_td0 */
> +			0x68 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* rmii2_rd1 */
> +			0x6c (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* rmii2_rd0 */
> +			0x70 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* rmii2_crs_dv */
> +			0x74 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* rmii2_rxer */
> +			0x78 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_int */
> +			0x108 (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii2_refclk */
> +		>;
> +	};
> +
> +	cpsw_sleep: cpsw_sleep {
> +		pinctrl-single,pins =3D <
> +			/* Slave 1 reset value */
> +			0x64 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_int */
> +			0x10c (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_crs_dv */
> +			0x110 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_rxer */
> +			0x114 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_txen */
> +			0x124 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_td1 */
> +			0x128 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_td0 */
> +			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_rd1 */
> +			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_rd0 */
> +			0x144 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_refclk */
> +
> +			/* Slave 2 reset value*/
> +			0x40 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_txen */
> +			0x50 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_td1 */
> +			0x54 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_td0 */
> +			0x68 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_rd1 */
> +			0x6c (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_rd0 */
> +			0x70 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_crs_dv */
> +			0x74 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_rxer */
> +			0x78 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_int */
> +			0x108 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_refclk */
> +		>;
> +	};
> +
> +	davinci_mdio_default: davinci_mdio_default {
> +		pinctrl-single,pins =3D <
> +			/* MDIO */
> +			0x148 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)	/* mdio_data.mdi=
o_data */
> +			0x14c (PIN_OUTPUT_PULLUP | MUX_MODE0)			/* mdio_clk.mdio_clk */
> +		>;
> +	};
> +
> +	davinci_mdio_sleep: davinci_mdio_sleep {
> +		pinctrl-single,pins =3D <
> +			/* MDIO reset value */
> +			0x148 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +		>;
> +	};
> +
> +	emmc_pins: pinmux_emmc_pins {
> +		pinctrl-single,pins =3D <
> +			0x80 (PIN_INPUT_PULLUP | MUX_MODE2) /* gpmc_csn1.mmc1_clk */
> +			0x84 (PIN_INPUT_PULLUP | MUX_MODE2) /* gpmc_csn2.mmc1_cmd */
> +			0x00 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad0.mmc1_dat0 */
> +			0x04 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad1.mmc1_dat1 */
> +			0x08 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad2.mmc1_dat2 */
> +			0x0c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad3.mmc1_dat3 */
> +			0x10 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad4.mmc1_dat4 */
> +			0x14 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad5.mmc1_dat5 */
> +			0x18 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad6.mmc1_dat6 */
> +			0x1c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad7.mmc1_dat7 */
> +		>;
> +	};
> +
> +	uart0_pins: pinmux_uart0_pins {
> +		pinctrl-single,pins =3D <
> +			0x170 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart0_rxd.uart0_rxd */
> +			0x174 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* uart0_txd.uart0_txd */
> +		>;
> +	};
> +};
> +
> +&i2c0 {
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&i2c0_pins>;
> +
> +	status =3D "okay";
> +	clock-frequency =3D <400000>;
> +
> +	serial_config1: serial_config1@20 {
> +		compatible =3D "nxp,pca9539";
> +		reg =3D <0x20>;
> +	};
> +
> +	serial_config2: serial_config2@21 {
> +		compatible =3D "nxp,pca9539";
> +		reg =3D <0x21>;
> +	};
> +
> +	tps: tps@2d {
> +		compatible =3D "ti,tps65910";
> +		reg =3D <0x2d>;
> +	};
> +};
> +
> +/include/ "tps65910.dtsi"
> +
> +&tps {
> +	vcc1-supply =3D <&vbat>;
> +	vcc2-supply =3D <&vbat>;
> +	vcc3-supply =3D <&vbat>;
> +	vcc4-supply =3D <&vbat>;
> +	vcc5-supply =3D <&vbat>;
> +	vcc6-supply =3D <&vbat>;
> +	vcc7-supply =3D <&vbat>;
> +	vccio-supply =3D <&vbat>;
> +
> +	regulators {
> +		/* vrtc - unused */
> +
> +		vio_reg: regulator@1 {
> +			regulator-name =3D "vio_1v5,ddr";
> +			regulator-min-microvolt =3D <1500000>;
> +			regulator-max-microvolt =3D <1500000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		vdd1_reg: regulator@2 {
> +			regulator-name =3D "vdd1,mpu";
> +			regulator-min-microvolt =3D <600000>;
> +			regulator-max-microvolt =3D <1500000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		vdd2_reg: regulator@3 {
> +			regulator-name =3D "vdd2_1v1,core";
> +			regulator-min-microvolt =3D <1100000>;
> +			regulator-max-microvolt =3D <1100000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		/* vdd3 - unused */
> +
> +		/* vdig1 - unused */
> +
> +		vdig2_reg: regulator@6 {
> +			regulator-name =3D "vdig2_1v8,vdds_pll";
> +			regulator-min-microvolt =3D <1800000>;
> +			regulator-max-microvolt =3D <1800000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		/* vpll - unused */
> +
> +		vdac_reg: regulator@8 {
> +			regulator-name =3D "vdac_1v8,vdds";
> +			regulator-min-microvolt =3D <1800000>;
> +			regulator-max-microvolt =3D <1800000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		vaux1_reg: regulator@9 {
> +			regulator-name =3D "vaux1_1v8,usb";
> +			regulator-min-microvolt =3D <1800000>;
> +			regulator-max-microvolt =3D <1800000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		vaux2_reg: regulator@10 {
> +			regulator-name =3D "vaux2_3v3,io";
> +			regulator-min-microvolt =3D <3300000>;
> +			regulator-max-microvolt =3D <3300000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		vaux33_reg: regulator@11 {
> +			regulator-name =3D "vaux33_3v3,usb";
> +			regulator-min-microvolt =3D <3300000>;
> +			regulator-max-microvolt =3D <3300000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		vmmc_reg: regulator@12 {
> +			regulator-name =3D "vmmc_3v3,io";
> +			regulator-min-microvolt =3D <3300000>;
> +			regulator-max-microvolt =3D <3300000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +	};
> +};
> +
> +&sham {
> +	status =3D "okay";
> +};
> +
> +&aes {
> +	status =3D "okay";
> +};
> +
> +&uart0 {
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&uart0_pins>;
> +
> +	status =3D "okay";
> +};
> +
> +&usb {
> +	status =3D "okay";
> +};
> +
> +&usb_ctrl_mod {
> +	status =3D "okay";
> +};
> +
> +&usb0_phy {
> +	status =3D "okay";
> +};
> +
> +&usb1_phy {
> +	status =3D "okay";
> +};
> +
> +&usb0 {
> +	status =3D "okay";
> +	dr_mode =3D "host";
> +};
> +
> +&usb1 {
> +	status =3D "okay";
> +	dr_mode =3D "host";
> +};
> +
> +&cppi41dma  {
> +	status =3D "okay";
> +};
> +
> +&cpsw_emac0 {
> +	phy_id =3D <&davinci_mdio>, <5>;
> +	phy-mode =3D "rmii";
> +	dual_emac_res_vlan =3D <2>;
> +};
> +
> +&cpsw_emac1 {
> +	phy_id =3D <&davinci_mdio>, <4>;
> +	phy-mode =3D "rmii";
> +	dual_emac_res_vlan =3D <3>;
> +};
> +
> +&mac {
> +	pinctrl-names =3D "default", "sleep";
> +	pinctrl-0 =3D <&cpsw_default>;
> +	pinctrl-1 =3D <&cpsw_sleep>;
> +	dual_emac =3D <1>;
> +	status =3D "okay";
> +};
> +
> +&davinci_mdio {
> +	pinctrl-names =3D "default", "sleep";
> +	pinctrl-0 =3D <&davinci_mdio_default>;
> +	pinctrl-1 =3D <&davinci_mdio_sleep>;
> +	status =3D "okay";
> +};
> +
> +&mmc1 {
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&mmc1_pins>;
> +	vmmc-supply =3D <&vmmcsd_fixed>;
> +	bus-width =3D <4>;
> +	status =3D "okay";
> +};
> +
> +&mmc2 {
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&emmc_pins>;
> +	vmmc-supply =3D <&vmmcsd_fixed>;
> +	bus-width =3D <8>;
> +	ti,non-removable;
> +	status =3D "okay";
> +};
> +
> --=20
> 2.1.0
>=20

--=20
balbi

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUakfMAAoJEIaOsuA1yqREIJIP/AgWj+qVYgVo/jvI6VYB0a0Q
LNL7gXev7qkrmBRGqAEe5fuGnswn2XpW9aUXCq/CA2c4i3ILM83J7mTyY+OUiioS
Q7Ct23OxPRO7l1C18MZ65xwRb8bbi1iIJmAD0N55tHHNUEzF9YBah85KYfO/QgCx
EfvtMiYllJz/979fyGgB4eW1PURxN22u45kjcEj1GW44/qGKEqbziUKUhlTNjHjJ
duFGMh5/bFbAMw23uhKQi+KofXQ4teq+EMlCvleUZf7fNTEzBW/vPwt+pGs6ZdaS
z7DJMD8GwtNMb8zLAkLS/59gv+9Ltg541pkJWnytmHZ1kq67lQ/cpt9pGkyQigAX
vP27UY53pLSMJGixn5DPESOCSnfVJ7qpApW504DGRHft0x9eYHSbuGgexAKW2i2P
RmE5yiVUhEwqSbWQ7IpeU/jga1oNUIgN3i/L9SxduAWWDdyLMqUdzHKdeKTvz5RG
A5LEo+ip2krzgvFfDIIbi0mm61ry8CVpPhmDRcbr/PhR57fkj7mYy6zIk2guZMHt
loh5TclZJ0uCHHi2xVld7zAFxsgajf/rjNvqpovQtQGo7tWcLWWG306S41eYSKzA
6c46tblwBFZU26N6HihyQUr38ZXeCHzQZjH4g6M99eC1Jf1kipPZchZCmoMXVYFx
ggESKqqnBq1aoerszhc1
=ln5H
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
