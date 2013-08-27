Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3H0ISX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:18:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52831 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3H0ISR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:18:17 -0400
Date: Tue, 27 Aug 2013 18:18:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20130827181813.c40de9771c6b33ad5eba9bec@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_18_18_13_+1000_5XbEoUnJmcjg7s6i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_18_18_13_+1000_5XbEoUnJmcjg7s6i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/am335x-evm.dts between commits 97238b35d5bb ("usb:
musb: dsps: use proper child nodes") and 9b3452d1fa3c ("usb: musb dma:
add cppi41 dma driver") from the usb tree and commit 63f6b2550aa0 ("ARM:
dts: AM33XX: don't redefine OCP bus and device nodes") from the arm-soc
tree.

I fixed it up (probably incorrectly - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/am335x-evm.dts
index c26c16c,1a0f33e..0000000
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@@ -24,323 -24,6 +24,36 @@@
  		reg =3D <0x80000000 0x10000000>; /* 256 MB */
  	};
 =20
- 	am33xx_pinmux: pinmux@44e10800 {
- 		pinctrl-names =3D "default";
- 		pinctrl-0 =3D <&matrix_keypad_s0 &volume_keys_s0 &clkout2_pin>;
-=20
- 		matrix_keypad_s0: matrix_keypad_s0 {
- 			pinctrl-single,pins =3D <
- 				0x54 (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a5.gpio1_21 */
- 				0x58 (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a6.gpio1_22 */
- 				0x64 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a9.gpio1_25 */
- 				0x68 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a10.gpio1_26 */
- 				0x6c (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a11.gpio1_27 */
- 			>;
- 		};
-=20
- 		volume_keys_s0: volume_keys_s0 {
- 			pinctrl-single,pins =3D <
- 				0x150 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* spi0_sclk.gpio0_2 */
- 				0x154 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* spi0_d0.gpio0_3 */
- 			>;
- 		};
-=20
- 		i2c0_pins: pinmux_i2c0_pins {
- 			pinctrl-single,pins =3D <
- 				0x188 (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c0_sda.i2c0_sda */
- 				0x18c (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c0_scl.i2c0_scl */
- 			>;
- 		};
-=20
- 		i2c1_pins: pinmux_i2c1_pins {
- 			pinctrl-single,pins =3D <
- 				0x158 (PIN_INPUT_PULLUP | MUX_MODE2)	/* spi0_d1.i2c1_sda */
- 				0x15c (PIN_INPUT_PULLUP | MUX_MODE2)	/* spi0_cs0.i2c1_scl */
- 			>;
- 		};
-=20
- 		uart0_pins: pinmux_uart0_pins {
- 			pinctrl-single,pins =3D <
- 				0x170 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart0_rxd.uart0_rxd */
- 				0x174 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* uart0_txd.uart0_txd */
- 			>;
- 		};
-=20
- 		clkout2_pin: pinmux_clkout2_pin {
- 			pinctrl-single,pins =3D <
- 				0x1b4 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)	/* xdma_event_intr1.clkout2 */
- 			>;
- 		};
-=20
- 		nandflash_pins_s0: nandflash_pins_s0 {
- 			pinctrl-single,pins =3D <
- 				0x0 (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_ad0.gpmc_ad0 */
- 				0x4 (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_ad1.gpmc_ad1 */
- 				0x8 (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_ad2.gpmc_ad2 */
- 				0xc (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_ad3.gpmc_ad3 */
- 				0x10 (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_ad4.gpmc_ad4 */
- 				0x14 (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_ad5.gpmc_ad5 */
- 				0x18 (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_ad6.gpmc_ad6 */
- 				0x1c (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_ad7.gpmc_ad7 */
- 				0x70 (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_wait0.gpmc_wait0 */
- 				0x74 (PIN_INPUT_PULLUP | MUX_MODE7)	/* gpmc_wpn.gpio0_30 */
- 				0x7c (PIN_OUTPUT | MUX_MODE0)		/* gpmc_csn0.gpmc_csn0  */
- 				0x90 (PIN_OUTPUT | MUX_MODE0)		/* gpmc_advn_ale.gpmc_advn_ale */
- 				0x94 (PIN_OUTPUT | MUX_MODE0)		/* gpmc_oen_ren.gpmc_oen_ren */
- 				0x98 (PIN_OUTPUT | MUX_MODE0)		/* gpmc_wen.gpmc_wen */
- 				0x9c (PIN_OUTPUT | MUX_MODE0)		/* gpmc_be0n_cle.gpmc_be0n_cle */
- 			>;
- 		};
-=20
- 		ecap0_pins: backlight_pins {
- 			pinctrl-single,pins =3D <
- 				0x164 0x0	/* eCAP0_in_PWM0_out.eCAP0_in_PWM0_out MODE0 */
- 			>;
- 		};
-=20
- 		cpsw_default: cpsw_default {
- 			pinctrl-single,pins =3D <
- 				/* Slave 1 */
- 				0x114 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txen.rgmii1_tctl */
- 				0x118 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxdv.rgmii1_rctl */
- 				0x11c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd3.rgmii1_td3 */
- 				0x120 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd2.rgmii1_td2 */
- 				0x124 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd1.rgmii1_td1 */
- 				0x128 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd0.rgmii1_td0 */
- 				0x12c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txclk.rgmii1_tclk */
- 				0x130 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxclk.rgmii1_rclk */
- 				0x134 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd3.rgmii1_rd3 */
- 				0x138 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd2.rgmii1_rd2 */
- 				0x13c (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd1.rgmii1_rd1 */
- 				0x140 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd0.rgmii1_rd0 */
- 			>;
- 		};
-=20
- 		cpsw_sleep: cpsw_sleep {
- 			pinctrl-single,pins =3D <
- 				/* Slave 1 reset value */
- 				0x114 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x118 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x11c (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x120 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x124 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x128 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x12c (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x130 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x134 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x138 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x13c (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x140 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 			>;
- 		};
-=20
- 		davinci_mdio_default: davinci_mdio_default {
- 			pinctrl-single,pins =3D <
- 				/* MDIO */
- 				0x148 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)	/* mdio_data.mdi=
o_data */
- 				0x14c (PIN_OUTPUT_PULLUP | MUX_MODE0)			/* mdio_clk.mdio_clk */
- 			>;
- 		};
-=20
- 		davinci_mdio_sleep: davinci_mdio_sleep {
- 			pinctrl-single,pins =3D <
- 				/* MDIO reset value */
- 				0x148 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 			>;
- 		};
- 	};
-=20
 +	ocp {
- 		uart0: serial@44e09000 {
- 			pinctrl-names =3D "default";
- 			pinctrl-0 =3D <&uart0_pins>;
-=20
- 			status =3D "okay";
- 		};
-=20
- 		i2c0: i2c@44e0b000 {
- 			pinctrl-names =3D "default";
- 			pinctrl-0 =3D <&i2c0_pins>;
-=20
- 			status =3D "okay";
- 			clock-frequency =3D <400000>;
-=20
- 			tps: tps@2d {
- 				reg =3D <0x2d>;
- 			};
- 		};
-=20
 +		musb: usb@47400000 {
 +			status =3D "okay";
 +
 +			control@44e10000 {
 +				status =3D "okay";
 +			};
 +
 +			phy@47401300 {
 +				status =3D "okay";
 +			};
 +
 +			phy@47401b00 {
 +				status =3D "okay";
 +			};
 +
 +			usb@47401000 {
 +				status =3D "okay";
 +			};
 +
 +			usb@47401800 {
 +				status =3D "okay";
 +			};
 +
 +			dma@07402000  {
 +				status =3D "okay";
 +			};
 +		};
-=20
- 		i2c1: i2c@4802a000 {
- 			pinctrl-names =3D "default";
- 			pinctrl-0 =3D <&i2c1_pins>;
-=20
- 			status =3D "okay";
- 			clock-frequency =3D <100000>;
-=20
- 			lis331dlh: lis331dlh@18 {
- 				compatible =3D "st,lis331dlh", "st,lis3lv02d";
- 				reg =3D <0x18>;
- 				Vdd-supply =3D <&lis3_reg>;
- 				Vdd_IO-supply =3D <&lis3_reg>;
-=20
- 				st,click-single-x;
- 				st,click-single-y;
- 				st,click-single-z;
- 				st,click-thresh-x =3D <10>;
- 				st,click-thresh-y =3D <10>;
- 				st,click-thresh-z =3D <10>;
- 				st,irq1-click;
- 				st,irq2-click;
- 				st,wakeup-x-lo;
- 				st,wakeup-x-hi;
- 				st,wakeup-y-lo;
- 				st,wakeup-y-hi;
- 				st,wakeup-z-lo;
- 				st,wakeup-z-hi;
- 				st,min-limit-x =3D <120>;
- 				st,min-limit-y =3D <120>;
- 				st,min-limit-z =3D <140>;
- 				st,max-limit-x =3D <550>;
- 				st,max-limit-y =3D <550>;
- 				st,max-limit-z =3D <750>;
- 			};
-=20
- 			tsl2550: tsl2550@39 {
- 				compatible =3D "taos,tsl2550";
- 				reg =3D <0x39>;
- 			};
-=20
- 			tmp275: tmp275@48 {
- 				compatible =3D "ti,tmp275";
- 				reg =3D <0x48>;
- 			};
- 		};
-=20
- 		elm: elm@48080000 {
- 			status =3D "okay";
- 		};
-=20
- 		epwmss0: epwmss@48300000 {
- 			status =3D "okay";
-=20
- 			ecap0: ecap@48300100 {
- 				status =3D "okay";
- 				pinctrl-names =3D "default";
- 				pinctrl-0 =3D <&ecap0_pins>;
- 			};
- 		};
-=20
- 		gpmc: gpmc@50000000 {
- 			status =3D "okay";
- 			pinctrl-names =3D "default";
- 			pinctrl-0 =3D <&nandflash_pins_s0>;
- 			ranges =3D <0 0 0x08000000 0x10000000>;	/* CS0: NAND */
- 			nand@0,0 {
- 				reg =3D <0 0 0>; /* CS0, offset 0 */
- 				nand-bus-width =3D <8>;
- 				ti,nand-ecc-opt =3D "bch8";
- 				gpmc,device-nand =3D "true";
- 				gpmc,device-width =3D <1>;
- 				gpmc,sync-clk-ps =3D <0>;
- 				gpmc,cs-on-ns =3D <0>;
- 				gpmc,cs-rd-off-ns =3D <44>;
- 				gpmc,cs-wr-off-ns =3D <44>;
- 				gpmc,adv-on-ns =3D <6>;
- 				gpmc,adv-rd-off-ns =3D <34>;
- 				gpmc,adv-wr-off-ns =3D <44>;
- 				gpmc,we-on-ns =3D <0>;
- 				gpmc,we-off-ns =3D <40>;
- 				gpmc,oe-on-ns =3D <0>;
- 				gpmc,oe-off-ns =3D <54>;
- 				gpmc,access-ns =3D <64>;
- 				gpmc,rd-cycle-ns =3D <82>;
- 				gpmc,wr-cycle-ns =3D <82>;
- 				gpmc,wait-on-read =3D "true";
- 				gpmc,wait-on-write =3D "true";
- 				gpmc,bus-turnaround-ns =3D <0>;
- 				gpmc,cycle2cycle-delay-ns =3D <0>;
- 				gpmc,clk-activation-ns =3D <0>;
- 				gpmc,wait-monitoring-ns =3D <0>;
- 				gpmc,wr-access-ns =3D <40>;
- 				gpmc,wr-data-mux-bus-ns =3D <0>;
-=20
- 				#address-cells =3D <1>;
- 				#size-cells =3D <1>;
- 				elm_id =3D <&elm>;
-=20
- 				/* MTD partition table */
- 				partition@0 {
- 					label =3D "SPL1";
- 					reg =3D <0x00000000 0x000020000>;
- 				};
-=20
- 				partition@1 {
- 					label =3D "SPL2";
- 					reg =3D <0x00020000 0x00020000>;
- 				};
-=20
- 				partition@2 {
- 					label =3D "SPL3";
- 					reg =3D <0x00040000 0x00020000>;
- 				};
-=20
- 				partition@3 {
- 					label =3D "SPL4";
- 					reg =3D <0x00060000 0x00020000>;
- 				};
-=20
- 				partition@4 {
- 					label =3D "U-boot";
- 					reg =3D <0x00080000 0x001e0000>;
- 				};
-=20
- 				partition@5 {
- 					label =3D "environment";
- 					reg =3D <0x00260000 0x00020000>;
- 				};
-=20
- 				partition@6 {
- 					label =3D "Kernel";
- 					reg =3D <0x00280000 0x00500000>;
- 				};
-=20
- 				partition@7 {
- 					label =3D "File-System";
- 					reg =3D <0x00780000 0x0F880000>;
- 				};
- 			};
- 		};
 +	};
 +
  	vbat: fixedregulator@0 {
  		compatible =3D "regulator-fixed";
  		regulator-name =3D "vbat";

--Signature=_Tue__27_Aug_2013_18_18_13_+1000_5XbEoUnJmcjg7s6i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHGDFAAoJEECxmPOUX5FEhHQP/2tF6O8oPI4/KR5EkiEb+Xf/
UrsR1vul6yroLh7cAXhe4jgE3DBvaD87xGpbF68umREfVthYD565/0ZPGbwVxerj
chx26urMlViIdGmtlg7zSwfIq46UFgxeCIGaMETCneO5eTgjKkeTC2ec/q1bcnSJ
yoBhrKUVfJwZtfkdmPFM23DvUYwtL8zn5W4da98Jn7MegxCTZyVIVAXqHGR1/6KP
Q96AsXQCeh9LaJBVE7q54cf++8tUMkQVvNj6+RSJhLsts49kmpgjUW7TJuREsqRB
6IVX91IVaBZbTZPMeNvK3uN/XG1zdf88q9lQgUiHbKWD2+jUVdYrikfc3BtMSzNz
kxwGBc7Tz6x/Gqbhi9jQBC7YNna+l3TfkQhKrKVpxR7YKPLk0ovbuCssCYo8K94J
51fZlK1N8HwBAOjk9+h4j8gB7xzfpQcGGXqPP0XtnB1GqlC6gcgpUEh0Dp3B0o8H
wO9fUuJpRmxkxZU3aRoJRQRXoO1zqNYiTBcF/DIDEuBeFvjvdosgtuJuqtMkKfBv
k+8wx59gCsTP6v0dzY+s71KOfub//JXfpLxvu/G0HkutZekQVh5jZrkvfDfj6C4a
hIHSCHfKIVzcaGJ5t5HrN10aLzK+QN7qzoQrRYN64hWSUlBTxoIi++tEHrlQJKdk
vXdt6JuxFnSrqsA6GqVy
=U5kN
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_18_18_13_+1000_5XbEoUnJmcjg7s6i--
