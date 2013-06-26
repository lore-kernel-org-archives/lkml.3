Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3FZPQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:16:14 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49055 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3FZPQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:16:13 -0400
Date: Wed, 26 Jun 2013 17:16:10 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        jimwall@q.com, brian@crystalfontz.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: mxs: dt: Add Crystalfontz CFA-10058 device tree
Message-ID: <20130626151610.GE5803@lukather>
References: <1372258347-18422-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1372258347-18422-4-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Content-Disposition: inline
In-Reply-To: <1372258347-18422-4-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexandre,

On Wed, Jun 26, 2013 at 04:52:27PM +0200, Alexandre Belloni wrote:
> From: Brian Lilly <brian@crystalfontz.com>
>=20
> The CFA-10057 is a breakout board for the CFA-10036 that has Ethernet, US=
B and a
> 5" LCD screen on it.
>=20
> Signed-off-by: Brian Lilly <brian@crystalfontz.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/Makefile           |   1 +
>  arch/arm/boot/dts/imx28-cfa10058.dts | 183 +++++++++++++++++++++++++++++=
++++++
>  2 files changed, 184 insertions(+)
>  create mode 100644 arch/arm/boot/dts/imx28-cfa10058.dts
>=20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index d494f37..ddd6f32 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -133,6 +133,7 @@ dtb-$(CONFIG_ARCH_MXS) +=3D imx23-evk.dtb \
>  	imx28-cfa10055.dtb \
>  	imx28-cfa10056.dtb \
>  	imx28-cfa10057.dtb \
> +	imx28-cfa10058.dtb \
>  	imx28-evk.dtb \
>  	imx28-m28evk.dtb \
>  	imx28-sps1.dtb \
> diff --git a/arch/arm/boot/dts/imx28-cfa10058.dts b/arch/arm/boot/dts/imx=
28-cfa10058.dts
> new file mode 100644
> index 0000000..438e042
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx28-cfa10058.dts
> @@ -0,0 +1,183 @@
> +/*
> + * Copyright 2013 Crystalfontz America, Inc.
> + * Copyright 2012 Free Electrons
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
> + * The CFA-100587 is an expansion board for the CFA-10036 module, thus we
                   ^ typo

> + * need to include the CFA-10036 DTS.
> + */
> +/include/ "imx28-cfa10036.dts"
> +
> +/ {
> +	model =3D "Crystalfontz CFA-10058 Board";
> +	compatible =3D "crystalfontz,cfa10058", "crystalfontz,cfa10036", "fsl,i=
mx28";
> +
> +	apb@80000000 {
> +		apbh@80000000 {
> +			pinctrl@80018000 {
> +				pinctrl-names =3D "default", "default";
> +				pinctrl-1 =3D <&hog_pins_cfa10058
> +					&hog_pins_cfa10058_pullup>;
> +
> +				hog_pins_cfa10058: hog-10058@0 {
> +					reg =3D <0>;
> +					fsl,pinmux-ids =3D <
> +						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
> +						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */
> +					>;
> +					fsl,drive-strength =3D <0>;
> +					fsl,voltage =3D <1>;
> +					fsl,pull-up =3D <0>;
> +				};
> +
> +				hog_pins_cfa10058_pullup: hog-10058-pullup@0 {
> +					reg =3D <0>;
> +					fsl,pinmux-ids =3D <
> +						0x2133 /* MX28_PAD_SSP2_D3__GPIO_2_19 */
> +						0x3183 /* MX28_PAD_I2C0_SCL__GPIO_3_24 */
> +						0x3193 /* MX28_PAD_I2C0_SDA__GPIO_3_25 */
> +						0x31a3 /* MX28_PAD_SAIF_SDATA0__GPIO_3_26 */
> +						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
> +					>;
> +					fsl,drive-strength =3D <0>;
> +					fsl,voltage =3D <1>;
> +					fsl,pull-up =3D <1>;
> +				};

As said in the previous mail, these pins don't seem to be used anywhere.
You should remove that node.

> +				spi3_pins_cfa10058: spi3-cfa10058@0 {
> +					reg =3D <0>;
> +					fsl,pinmux-ids =3D <
> +						0x0183 /* MX28_PAD_GPMI_RDN__GPIO_0_24 */
> +						0x01c3 /* MX28_PAD_GPMI_RESETN__GPIO_0_28 */
> +						0x0113 /* MX28_PAD_GPMI_CE1N__GPIO_0_17 */
> +						0x01a3 /* MX28_PAD_GPMI_ALE__GPIO_0_26 */
> +						0x01b3 /* MX28_PAD_GPMI_CLE__GPIO_0_27 */
> +					>;
> +					fsl,drive-strength =3D <1>;
> +					fsl,voltage =3D <1>;
> +					fsl,pull-up =3D <1>;
> +				};
> +
> +				lcdif_pins_cfa10058: lcdif-evk@0 {
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
> +						 &lcdif_pins_cfa10058>;
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
> +							clock-frequency =3D <30000000>;
> +							hactive =3D <800>;
> +							vactive =3D <480>;
> +							hback-porch =3D <40>;
> +							hfront-porch =3D <40>;
> +							vback-porch =3D <13>;
> +							vfront-porch =3D <29>;
> +							hsync-len =3D <8>;
> +							vsync-len =3D <8>;
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
> +			lradc@80050000 {
> +				fsl,lradc-touchscreen-wires =3D <4>;
> +				status =3D "okay";
> +			};
> +
> +			pwm: pwm@80064000 {
> +				pinctrl-names =3D "default";
> +				pinctrl-0 =3D <&pwm3_pins_b>;
> +				status =3D "okay";
> +			};
> +
> +			i2c1: i2c@8005a000 {
> +				pinctrl-names =3D "default";
> +				pinctrl-0 =3D <&i2c1_pins_a>;
> +				status =3D "okay";
> +			};

Unused i2c bus on this board.

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
> +	backlight {
> +		compatible =3D "pwm-backlight";
> +		pwms =3D <&pwm 3 5000000>;
> +		brightness-levels =3D <0 4 8 16 32 64 128 255>;
> +		default-brightness-level =3D <6>;
> +	};
> +
> +	fiq {
> +		compatible =3D "crystalfontz,cfa10049-fiq";
> +		interrupts =3D <50>;
> +	};

Again, out-of-tree driver :)

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRywW6AAoJEBx+YmzsjxAgf3sP+gJWux5/MxvHup1UPnzfd46n
0D9i+LI+Tw4GjgL2Np85IGHCcPEh2zNWNeFnylkf41/+lSLCB+vfXLT+7Xy6KK7w
d7cHtDy06jFz5n4erC/fWaQEGVL3XRO7lxFMnkOeBH6abOP4QIBTX5eEpfL3KZvY
uFl2rreswtkvVEt/mCRFRmZtz92hKN9hRu3ojnUDqSVAJgCMs01RsILEPjVFBO4P
qfvKil5zr9xQ9zS9UwnM7xBHDgY9N6my/8LbgHqhBviPU2Ctdpf0pFT8J2icEQ4z
JBcpntI0qoEFhuDXxWUdKfimN7+yHMBy6Pal9uodmobK0Gv04lD8rjcdohOt/i5e
uOGyeAVHOkzMrRJyXtorIQ42g0U9sdTUmrLbFz0PsSp03b/okV7vVKGw+Lwlhc9P
ePPv006maXLYVbuynQNO+MfYkPl1xPRSiPUywSS1LmHNZJHwf0/JNOKCOA/O1G5a
YFihFbmnGWC/noVUdZK4P6NgNTvQYXQUyCJfsl3FuEAbWFK4hYlY76u+zwqytu3J
+Zwew9CQa7V4vYp8rlpMI2mNFdaaC5y2kcjsreXQcdeiZolo0wLdbwPOMErJIQky
4uX5aaVkCuyiF/7HRrhINxSfIXC6l2S5MP/CsJtUzQI1FAvV2kDbjXmfRaQeelca
YybI0dV8jikpwfcxJB5M
=Cakj
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--
