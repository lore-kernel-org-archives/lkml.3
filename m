Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3FZP5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:57:13 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49460 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3FZP5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:57:12 -0400
Date: Wed, 26 Jun 2013 17:57:08 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        jimwall@q.com, brian@crystalfontz.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] ARM: mxs: dt: Add Crystalfontz CFA-10056 device
 tree
Message-ID: <20130626155708.GG5803@lukather>
References: <1372261232-21051-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1372261232-21051-3-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJguvTgX93MxBIIe"
Content-Disposition: inline
In-Reply-To: <1372261232-21051-3-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vJguvTgX93MxBIIe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 05:40:31PM +0200, Alexandre Belloni wrote:
> From: Brian Lilly <brian@crystalfontz.com>
>=20
> The CFA-10056 is a breakout board for the CFA-10036, and is
> basically a CFA-10037, with a 4.3" screen.
>=20
> Signed-off-by: Brian Lilly <brian@crystalfontz.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/Makefile           |   1 +
>  arch/arm/boot/dts/imx28-cfa10056.dts | 171 +++++++++++++++++++++++++++++=
++++++
>  2 files changed, 172 insertions(+)
>  create mode 100644 arch/arm/boot/dts/imx28-cfa10056.dts
>=20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 225d939..d494f37 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -131,6 +131,7 @@ dtb-$(CONFIG_ARCH_MXS) +=3D imx23-evk.dtb \
>  	imx28-cfa10037.dtb \
>  	imx28-cfa10049.dtb \
>  	imx28-cfa10055.dtb \
> +	imx28-cfa10056.dtb \
>  	imx28-cfa10057.dtb \
>  	imx28-evk.dtb \
>  	imx28-m28evk.dtb \
> diff --git a/arch/arm/boot/dts/imx28-cfa10056.dts b/arch/arm/boot/dts/imx=
28-cfa10056.dts
> new file mode 100644
> index 0000000..dd6d217
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx28-cfa10056.dts
> @@ -0,0 +1,171 @@
> +/*
> + * Copyright 2013 Free Electrons
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/*
> + * The CFA-10056 is an expansion board for the CFA-10036 module, thus we
> + * need to include the CFA-10036 DTS.
> + */
> +/include/ "imx28-cfa10036.dts"
> +
> +/ {
> +	model =3D "Crystalfontz CFA-10056 Board";
> +	compatible =3D "crystalfontz,cfa10056", "crystalfontz,cfa10036", "fsl,i=
mx28";
> +
> +	apb@80000000 {
> +		apbh@80000000 {
> +			pinctrl@80018000 {
> +				pinctrl-names =3D "default", "default";
> +				pinctrl-1 =3D <&hog_pins_cfa10056
> +					&hog_pins_cfa10056_pullup>;
> +
> +				hog_pins_cfa10056: hog-10056@0 {
> +					reg =3D <0>;
> +					fsl,pinmux-ids =3D <
> +						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
> +						0x2153 /* MX28_PAD_SSP2_D5__GPIO_2_21 */
> +						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */
> +					>;
> +					fsl,drive-strength =3D <0>;
> +					fsl,voltage =3D <1>;
> +					fsl,pull-up =3D <0>;
> +				};

These hogs pins don't have much sense anymore.

Maybe you should split out the three pins in:
  - usb_pins_cfa10056
  - mac0_pins_cfa10056
  - move the last one in spi2_pins_cfa10056

> +
> +				hog_pins_cfa10056_pullup: hog-10056-pullup@0 {
> +					reg =3D <0>;
> +					fsl,pinmux-ids =3D <
> +						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
> +					>;
> +					fsl,drive-strength =3D <0>;
> +					fsl,voltage =3D <1>;
> +					fsl,pull-up =3D <1>;
> +				};

You could probably rename it to lcdif_pins_cfa10056_pullups or something
then, and make the lcdif driver grab these pins.

> +
> +				spi2_pins_cfa10056: spi2-cfa10056@0 {
> +					reg =3D <0>;
> +					fsl,pinmux-ids =3D <
> +						0x2103 /* MX28_PAD_SSP2_SCK__GPIO_2_16 */
> +						0x2113 /* MX28_PAD_SSP2_CMD__GPIO_2_17 */
> +						0x2123 /* MX28_PAD_SSP2_D0__GPIO_2_18 */
> +					>;
> +					fsl,drive-strength =3D <1>;
> +					fsl,voltage =3D <1>;
> +					fsl,pull-up =3D <1>;
> +				};
> +
> +				lcdif_pins_cfa10056: lcdif-evk@0 {
> +					reg =3D <0>;
> +					fsl,pinmux-ids =3D <
> +						0x1181 /* MX28_PAD_LCD_RD_E__LCD_VSYNC */
> +						0x1191 /* MX28_PAD_LCD_WR_RWN__LCD_HSYNC */
> +						0x11a1 /* MX28_PAD_LCD_RS__LCD_DOTCLK */
> +						0x11b1 /* MX28_PAD_LCD_CS__LCD_ENABLE */
> +					>;
> +					fsl,drive-strength =3D <0>;
> +					fsl,voltage =3D <1>;
> +					fsl,pull-up =3D <0>;
> +				};
> +			};
> +
> +			lcdif@80030000 {
> +				pinctrl-names =3D "default";
> +				pinctrl-0 =3D <&lcdif_24bit_pins_a
> +						 &lcdif_pins_cfa10056>;
> +				display =3D <&display>;
> +				status =3D "okay";
> +
> +				display: display {
> +					bits-per-pixel =3D <32>;
> +					bus-width =3D <24>;
> +
> +					display-timings {
> +						native-mode =3D <&timing0>;
> +						timing0: timing0 {
> +							clock-frequency =3D <32000000>;
> +							hactive =3D <480>;
> +							vactive =3D <800>;
> +							hback-porch =3D <2>;
> +							hfront-porch =3D <2>;
> +							vback-porch =3D <2>;
> +							vfront-porch =3D <2>;
> +							hsync-len =3D <5>;
> +							vsync-len =3D <5>;
> +							hsync-active =3D <0>;
> +							vsync-active =3D <0>;
> +							de-active =3D <1>;
> +							pixelclk-active =3D <1>;
> +						};
> +					};
> +				};
> +			};
> +		};
> +
> +		apbx@80040000 {
> +			usbphy1: usbphy@8007e000 {
> +				status =3D "okay";
> +			};
> +		};
> +	};
> +
> +	ahb@80080000 {
> +		usb1: usb@80090000 {
> +			vbus-supply =3D <&reg_usb1_vbus>;
> +			pinctrl-0 =3D <&usbphy1_pins_a>;
> +			pinctrl-names =3D "default";
> +			status =3D "okay";
> +		};
> +	};
> +
> +	regulators {
> +		compatible =3D "simple-bus";
> +
> +		reg_usb1_vbus: usb1_vbus {
> +			compatible =3D "regulator-fixed";
> +			regulator-name =3D "usb1_vbus";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			gpio =3D <&gpio0 7 1>;
> +		};
> +	};
> +
> +	ahb@80080000 {
> +		mac0: ethernet@800f0000 {
> +			phy-mode =3D "rmii";
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&mac0_pins_a>;
> +			phy-reset-gpios =3D <&gpio2 21 0>;
> +			phy-reset-duration =3D <100>;
> +			status =3D "okay";
> +		};
> +	};
> +
> +	spi2 {
> +		compatible =3D "spi-gpio";
> +		pinctrl-names =3D "default";
> +		pinctrl-0 =3D <&spi2_pins_cfa10056>;
> +		status =3D "okay";
> +		gpio-sck =3D <&gpio2 16 0>;
> +		gpio-mosi =3D <&gpio2 17 0>;
> +		gpio-miso =3D <&gpio2 18 0>;
> +		cs-gpios =3D <&gpio3 5 0>;
> +		num-chipselects =3D <1>;
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +
> +		hx8369: hx8369@0 {
> +			compatible =3D "himax,hx8369a", "himax,hx8369";
> +			reg =3D <0>;
> +			spi-max-frequency =3D <100000>;
> +			spi-cpol;
> +			spi-cpha;
> +			gpios-reset =3D <&gpio3 30 0>;
> +		};
> +	};
> +};
> --=20
> 1.8.1.2
>=20

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vJguvTgX93MxBIIe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyw9UAAoJEBx+YmzsjxAgc9UQAIbmQd4+VOnfoV7xSlnsrjK3
R6PSHnRlbmKT/wv9L5MIeXsBo94PG0BG8RrS3FnBiYucyj1/ukZKZc8KmS843Bg2
fsh9clEDIovAU0Hbdj0drCCHoKopHUmgBCuvhfK1SLwKcSlKa9iKC3aQOihkWjgG
6QGWh4LvjH/UPdOhkr4bOIYBBBra7s0z+6PYF6r4qnjvffbjykQsMYmdFgvFMbpn
nAikS8qw4I7I4iRFBR9Z7kqfzbUo3lOjqK5WtI11FE/bS2vx4BwWyAbaPUNcQYP/
bemsECoos07kkLkPyhbPopS42HJKWaFV0/sKmTouUQeOnV9nhtcHyCn/R8Wc8UYE
ZK6fv+Mrnt5wVG0tinzuHkTza2LArt43+Vit0EUpFC0zQYkz5mGOyKO68mHZhTWI
8NnrIwtMfwKP3DSJYnHfa3kouPEZmgrVA/PRENs6XApn9JL7OQFr1ejFSTFfilg3
CAm0ikmllV81AQjvQh1qTiM9HFejtJfT/JT++4ozyLvd9/20Z42Tx6eLkQ1VVv3w
GnInjUWxhSrdFnzBfEfVlGl3LOw3UQpjR+w+Vd2H6Xxsln2S+EomNYCtrGIQcfPo
HxTGuIkNAMwqV+aNOYnGBy1eW+z6pbKIHXo3i2flXYC4hjNqHqq8RgK+a5xJRKEk
n7w0sbD7rGZIppZMv0jC
=Kl+d
-----END PGP SIGNATURE-----

--vJguvTgX93MxBIIe--
