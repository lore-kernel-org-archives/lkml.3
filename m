Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3H0IVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:21:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53052 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3H0IV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:21:28 -0400
Date: Tue, 27 Aug 2013 18:21:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20130827182125.7437e679154062236160283e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_18_21_25_+1000_NRIXcP6puJs4WJd6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_18_21_25_+1000_NRIXcP6puJs4WJd6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/am335x-evmsk.dts between commit 97238b35d5bb ("usb:
musb: dsps: use proper child nodes") from the usb tree and commit
63f6b2550aa0 ("ARM: dts: AM33XX: don't redefine OCP bus and device
nodes") from the arm-soc tree.

I fixed it up (probably incorrectly - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/am335x-evmsk.dts
index e92446c,8e7279b..0000000
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@@ -30,210 -30,6 +30,24 @@@
  		reg =3D <0x80000000 0x10000000>; /* 256 MB */
  	};
 =20
- 	am33xx_pinmux: pinmux@44e10800 {
- 		pinctrl-names =3D "default";
- 		pinctrl-0 =3D <&gpio_keys_s0 &clkout2_pin>;
-=20
- 		user_leds_s0: user_leds_s0 {
- 			pinctrl-single,pins =3D <
- 				0x10 (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_ad4.gpio1_4 */
- 				0x14 (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_ad5.gpio1_5 */
- 				0x18 (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_ad6.gpio1_6 */
- 				0x1c (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_ad7.gpio1_7 */
- 			>;
- 		};
-=20
- 		gpio_keys_s0: gpio_keys_s0 {
- 			pinctrl-single,pins =3D <
- 				0x94 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* gpmc_oen_ren.gpio2_3 */
- 				0x90 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* gpmc_advn_ale.gpio2_2 */
- 				0x70 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* gpmc_wait0.gpio0_30 */
- 				0x9c (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* gpmc_ben0_cle.gpio2_5 */
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
- 		uart0_pins: pinmux_uart0_pins {
- 			pinctrl-single,pins =3D <
- 				0x170 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart0_rxd.uart0_rxd */
- 				0x174 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)		/* uart0_txd.uart0_txd */
- 			>;
- 		};
-=20
- 		clkout2_pin: pinmux_clkout2_pin {
- 			pinctrl-single,pins =3D <
- 				0x1b4 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)		/* xdma_event_intr1.clkout2 =
*/
- 			>;
- 		};
-=20
- 		ecap2_pins: backlight_pins {
- 			pinctrl-single,pins =3D <
- 				0x19c 0x4	/* mcasp0_ahclkr.ecap2_in_pwm2_out MODE4 */
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
-=20
- 				/* Slave 2 */
- 				0x40 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a0.rgmii2_tctl */
- 				0x44 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a1.rgmii2_rctl */
- 				0x48 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a2.rgmii2_td3 */
- 				0x4c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a3.rgmii2_td2 */
- 				0x50 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a4.rgmii2_td1 */
- 				0x54 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a5.rgmii2_td0 */
- 				0x58 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a6.rgmii2_tclk */
- 				0x5c (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a7.rgmii2_rclk */
- 				0x60 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a8.rgmii2_rd3 */
- 				0x64 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a9.rgmii2_rd2 */
- 				0x68 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a10.rgmii2_rd1 */
- 				0x6c (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* gpmc_a11.rgmii2_rd0 */
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
-=20
- 				/* Slave 2 reset value*/
- 				0x40 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x44 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x48 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x4c (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x50 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x54 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x58 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x5c (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x60 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x64 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x68 (PIN_INPUT_PULLDOWN | MUX_MODE7)
- 				0x6c (PIN_INPUT_PULLDOWN | MUX_MODE7)
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
 +			usb@47401000 {
 +				status =3D "okay";
 +			};
 +		};
-=20
- 		epwmss2: epwmss@48304000 {
- 			status =3D "okay";
-=20
- 			ecap2: ecap@48304100 {
- 				status =3D "okay";
- 				pinctrl-names =3D "default";
- 				pinctrl-0 =3D <&ecap2_pins>;
- 			};
- 		};
 +	};
 +
  	vbat: fixedregulator@0 {
  		compatible =3D "regulator-fixed";
  		regulator-name =3D "vbat";

--Signature=_Tue__27_Aug_2013_18_21_25_+1000_NRIXcP6puJs4WJd6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHGGFAAoJEECxmPOUX5FETowP+wYnTKMqoIC7dHI/ClL/0+Cj
B3OGU3s5qAHpJ77p9g8vHnHYxj+V8SVr9jhr9oaUOpJpEmPTvg+7UP8m7FPKeDTD
tyHpbiPWcLnI2BOzoY1YDwqOxeEw+LPI2/T7OAncPTdkO0g0IPlKCKDQcv2mtaOn
J7+Rvph4AqfUMNHMXpWl4lKlNLkdTfE0+Bf7+a3rX7kaasjRV6F4xnz5slm6GrvA
6wKmnkvcDZ8Iqd58kA02qboKTA4psGXReGTTtID89GddslpSLeznHopN1dRmr4Ek
wbDpUM6VDsBBHw+6qX0DnZF1PM/t5bqFbZmRGxzT09/qP3BBSFBpbwnjt+Q9B83s
sSL/XkfVlNzGI6yoOQ+3HrsyXpFX8LcmqtnZbokHWzbsae+KmVd8JUc3TcX95JJq
1Z3EQBBMPuckj9OSoQDv/AvWv5FjfWuTu0lh8XdMEeLnKaZuNEkhCXGiu8R8LGzq
sFgMYcER0sgM4mCs0kr8JaL1zmx3Sjp5IKXiRqW4taLnTSIuvarZG3FlmYhR9Oly
l04cM+qtmg0KvOIlkgeDWi2l8lIFuyxFRHzIV8Fn7V1gTSEc69qXgo/gKC3pvi3z
SBfL0WDhrfCtBnX4O4lvGYunwb+cxar2LhUeIo+f15J5fEF3iyMovhq8JuARaRA3
fHKmDS9vWi/uneDOwOhQ
=1OEP
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_18_21_25_+1000_NRIXcP6puJs4WJd6--
