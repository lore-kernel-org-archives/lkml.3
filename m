Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3H0IOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:14:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36605 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3H0IOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:14:09 -0400
Date: Tue, 27 Aug 2013 18:13:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_18_13_53_+1000_lumkT3nddFSFeAvB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_18_13_53_+1000_lumkT3nddFSFeAvB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/am335x-bone.dts between commit 97238b35d5bb ("usb:
musb: dsps: use proper child nodes") from the  tree and commit
63f6b2550aa0 ("ARM: dts: AM33XX: don't redefine OCP bus and device
nodes") from the arm-soc tree.

I fixed it up (probably incorrectly - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/am335x-bone.dts
index a8907b5,d99be03..0000000
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@@ -24,132 -24,6 +24,24 @@@
  		reg =3D <0x80000000 0x10000000>; /* 256 MB */
  	};
 =20
- 	am33xx_pinmux: pinmux@44e10800 {
- 		pinctrl-names =3D "default";
- 		pinctrl-0 =3D <&clkout2_pin>;
-=20
- 		user_leds_s0: user_leds_s0 {
- 			pinctrl-single,pins =3D <
- 				0x54 (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a5.gpio1_21 */
- 				0x58 (PIN_OUTPUT_PULLUP | MUX_MODE7)	/* gpmc_a6.gpio1_22 */
- 				0x5c (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a7.gpio1_23 */
- 				0x60 (PIN_OUTPUT_PULLUP | MUX_MODE7)	/* gpmc_a8.gpio1_24 */
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
- 		cpsw_default: cpsw_default {
- 			pinctrl-single,pins =3D <
- 				/* Slave 1 */
- 				0x110 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxerr.mii1_rxerr */
- 				0x114 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txen.mii1_txen */
- 				0x118 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxdv.mii1_rxdv */
- 				0x11c (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txd3.mii1_txd3 */
- 				0x120 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txd2.mii1_txd2 */
- 				0x124 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txd1.mii1_txd1 */
- 				0x128 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txd0.mii1_txd0 */
- 				0x12c (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_txclk.mii1_txclk */
- 				0x130 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxclk.mii1_rxclk */
- 				0x134 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxd3.mii1_rxd3 */
- 				0x138 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxd2.mii1_rxd2 */
- 				0x13c (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxd1.mii1_rxd1 */
- 				0x140 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxd0.mii1_rxd0 */
- 			>;
- 		};
-=20
- 		cpsw_sleep: cpsw_sleep {
- 			pinctrl-single,pins =3D <
- 				/* Slave 1 reset value */
- 				0x110 (PIN_INPUT_PULLDOWN | MUX_MODE7)
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
- 		i2c0: i2c@44e0b000 {
- 			pinctrl-names =3D "default";
- 			pinctrl-0 =3D <&i2c0_pins>;
-=20
- 			status =3D "okay";
- 			clock-frequency =3D <400000>;
-=20
- 			tps: tps@24 {
- 				reg =3D <0x24>;
- 			};
-=20
- 		};
 +	};
 +
  	leds {
  		pinctrl-names =3D "default";
  		pinctrl-0 =3D <&user_leds_s0>;

--Signature=_Tue__27_Aug_2013_18_13_53_+1000_lumkT3nddFSFeAvB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHF/FAAoJEECxmPOUX5FE99IP/jW1B419X0YXXp8c1WE20yVU
0jueo3sQT8jCaFDeRs5K5Q+J1DWt2eT/f2IKbTxlmAqDMgHY2jPL7nqH0MvaJtMS
532biu0MP7qTUqtssyVsfzA2CI/n4loPvAp1EvCtsOYx5RqSEdLPbr3P1T5Lol7G
mnWnYCfcWUxDeC8ZLMGQdHcptS5T1vEKrQobXQ5L8tAq414O5Zr5ayIcPnjjudq3
uTOn3b/kBfe6UnajY422xLQblf5gvHYTwbg8U51YhBGr3ygMAy2cOh89JTuNyLkK
+UzJi+n8ggTRI47CMJ5c2Nk75QnbkCkjPAj249H6SkO0MJ6vSyWaXE5TICATxGI2
aJLvKfS9hmgj+ou6nkEwdQQAKg6/XdWyvjdlakRqeOy4BFlEDLy8szud/JKHUmP7
B4MthGr1leMH1+v3fMKR0eicesMEfszMtUCST2DldDHuw9/Im85SsDHdAVKQkNSk
pHI5Dw8HVAwnXavXzBpKN9rOWSDRYQuPwBJG30vkjACFISBpO+5B6uG1tzrbCnCe
BcbZ3yhG6j94h6389661ypbFcSJSwPFhHIrbYSz+jDxPtbjtxu2jLD0toCyIzouW
gzAHZHxVkJEsDtsA3bUE4Rst2AKJpQIQVTR5mCtEnGlEfJ0jkrbb+MhFA+0rI8IT
K9cR/yLu7RVChQsDmj7Z
=9TbG
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_18_13_53_+1000_lumkT3nddFSFeAvB--
