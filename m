Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbaDBB4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 21:56:06 -0400
Received: from ozlabs.org ([203.10.76.45]:42499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaDBB4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 21:56:04 -0400
Date: Wed, 2 Apr 2014 12:55:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: linux-next: manual merge of the staging tree with the arm-soc
 tree
Message-Id: <20140402125557.2d2f48716b8ff79f7042f223@canb.auug.org.au>
In-Reply-To: <20140225170944.d322d9868871bc2f669b92e5@canb.auug.org.au>
References: <20140225170944.d322d9868871bc2f669b92e5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Apr_2014_12_55_57_+1100_esZUKu.PVbTNyxes"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Apr_2014_12_55_57_+1100_esZUKu.PVbTNyxes
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 25 Feb 2014 17:09:44 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the staging tree got a conflict in
> arch/arm/boot/dts/imx53-qsb.dts between commit d5eb195f26fa ("ARM: dts:
> i.MX53: move common QSB nodes to new file") from the arm-soc tree and
> commit 17b5001b5143 ("imx-drm: convert to componentised device support")
> from the staging tree.

These merge fixups are now required when the arm-soc tree is merged with
Linus' tree.

> I fixed it up (see at bottom) and can carry the fix as necessary (no
> action is required).  I also added the following fix up patch:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 25 Feb 2014 17:07:01 +1100
> Subject: [PATCH] ARM: dts: i.MX53: merge fix patch
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/arm/boot/dts/imx53-qsb-common.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/imx53-qsb-common.dtsi b/arch/arm/boot/dts/=
imx53-qsb-common.dtsi
> index 2dca98b79f48..5dd37c7c38b8 100644
> --- a/arch/arm/boot/dts/imx53-qsb-common.dtsi
> +++ b/arch/arm/boot/dts/imx53-qsb-common.dtsi
> @@ -17,7 +17,7 @@
>  		reg =3D <0x70000000 0x40000000>;
>  	};
> =20
> -	display@di0 {
> +	display0: display@di0 {
>  		compatible =3D "fsl,imx-parallel-display";
>  		crtcs =3D <&ipu 0>;
>  		interface-pix-fmt =3D "rgb565";
> --=20
> 1.9.0
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc arch/arm/boot/dts/imx53-qsb.dts
> index dec4b073ceb1,3cb4f7791a91..000000000000
> --- a/arch/arm/boot/dts/imx53-qsb.dts
> +++ b/arch/arm/boot/dts/imx53-qsb.dts
> @@@ -16,6 -16,182 +16,11 @@@
>   / {
>   	model =3D "Freescale i.MX53 Quick Start Board";
>   	compatible =3D "fsl,imx53-qsb", "fsl,imx53";
>  -
>  -	memory {
>  -		reg =3D <0x70000000 0x40000000>;
>  -	};
>  -
>  -	display0: display@di0 {
>  -		compatible =3D "fsl,imx-parallel-display";
>  -		crtcs =3D <&ipu 0>;
>  -		interface-pix-fmt =3D "rgb565";
>  -		pinctrl-names =3D "default";
>  -		pinctrl-0 =3D <&pinctrl_ipu_disp0_1>;
>  -		status =3D "disabled";
>  -		display-timings {
>  -			claawvga {
>  -				native-mode;
>  -				clock-frequency =3D <27000000>;
>  -				hactive =3D <800>;
>  -				vactive =3D <480>;
>  -				hback-porch =3D <40>;
>  -				hfront-porch =3D <60>;
>  -				vback-porch =3D <10>;
>  -				vfront-porch =3D <10>;
>  -				hsync-len =3D <20>;
>  -				vsync-len =3D <10>;
>  -				hsync-active =3D <0>;
>  -				vsync-active =3D <0>;
>  -				de-active =3D <1>;
>  -				pixelclk-active =3D <0>;
>  -			};
>  -		};
>  -	};
>  -
>  -	gpio-keys {
>  -		compatible =3D "gpio-keys";
>  -
>  -		power {
>  -			label =3D "Power Button";
>  -			gpios =3D <&gpio1 8 0>;
>  -			linux,code =3D <116>; /* KEY_POWER */
>  -		};
>  -
>  -		volume-up {
>  -			label =3D "Volume Up";
>  -			gpios =3D <&gpio2 14 0>;
>  -			linux,code =3D <115>; /* KEY_VOLUMEUP */
>  -			gpio-key,wakeup;
>  -		};
>  -
>  -		volume-down {
>  -			label =3D "Volume Down";
>  -			gpios =3D <&gpio2 15 0>;
>  -			linux,code =3D <114>; /* KEY_VOLUMEDOWN */
>  -			gpio-key,wakeup;
>  -		};
>  -	};
>  -
> + 	imx-drm {
> + 		compatible =3D "fsl,imx-drm";
> + 		crtcs =3D <&ipu 0>;
> + 		connectors =3D <&display0>;
> + 	};
>  -
>  -	leds {
>  -		compatible =3D "gpio-leds";
>  -		pinctrl-names =3D "default";
>  -		pinctrl-0 =3D <&led_pin_gpio7_7>;
>  -
>  -		user {
>  -			label =3D "Heartbeat";
>  -			gpios =3D <&gpio7 7 0>;
>  -			linux,default-trigger =3D "heartbeat";
>  -		};
>  -	};
>  -
>  -	regulators {
>  -		compatible =3D "simple-bus";
>  -
>  -		reg_3p2v: 3p2v {
>  -			compatible =3D "regulator-fixed";
>  -			regulator-name =3D "3P2V";
>  -			regulator-min-microvolt =3D <3200000>;
>  -			regulator-max-microvolt =3D <3200000>;
>  -			regulator-always-on;
>  -		};
>  -
>  -		reg_usb_vbus: usb_vbus {
>  -			compatible =3D "regulator-fixed";
>  -			regulator-name =3D "usb_vbus";
>  -			regulator-min-microvolt =3D <5000000>;
>  -			regulator-max-microvolt =3D <5000000>;
>  -			gpio =3D <&gpio7 8 0>;
>  -			enable-active-high;
>  -		};
>  -	};
>  -
>  -	sound {
>  -		compatible =3D "fsl,imx53-qsb-sgtl5000",
>  -			     "fsl,imx-audio-sgtl5000";
>  -		model =3D "imx53-qsb-sgtl5000";
>  -		ssi-controller =3D <&ssi2>;
>  -		audio-codec =3D <&sgtl5000>;
>  -		audio-routing =3D
>  -			"MIC_IN", "Mic Jack",
>  -			"Mic Jack", "Mic Bias",
>  -			"Headphone Jack", "HP_OUT";
>  -		mux-int-port =3D <2>;
>  -		mux-ext-port =3D <5>;
>  -	};
>  -};
>  -
>  -&esdhc1 {
>  -	pinctrl-names =3D "default";
>  -	pinctrl-0 =3D <&pinctrl_esdhc1_1>;
>  -	status =3D "okay";
>  -};
>  -
>  -&ssi2 {
>  -	fsl,mode =3D "i2s-slave";
>  -	status =3D "okay";
>  -};
>  -
>  -&esdhc3 {
>  -	pinctrl-names =3D "default";
>  -	pinctrl-0 =3D <&pinctrl_esdhc3_1>;
>  -	cd-gpios =3D <&gpio3 11 0>;
>  -	wp-gpios =3D <&gpio3 12 0>;
>  -	bus-width =3D <8>;
>  -	status =3D "okay";
>  -};
>  -
>  -&iomuxc {
>  -	pinctrl-names =3D "default";
>  -	pinctrl-0 =3D <&pinctrl_hog>;
>  -
>  -	hog {
>  -		pinctrl_hog: hoggrp {
>  -			fsl,pins =3D <
>  -				MX53_PAD_GPIO_0__CCM_SSI_EXT1_CLK 0x80000000
>  -				MX53_PAD_GPIO_8__GPIO1_8          0x80000000
>  -				MX53_PAD_PATA_DATA14__GPIO2_14    0x80000000
>  -				MX53_PAD_PATA_DATA15__GPIO2_15    0x80000000
>  -				MX53_PAD_EIM_DA11__GPIO3_11       0x80000000
>  -				MX53_PAD_EIM_DA12__GPIO3_12       0x80000000
>  -				MX53_PAD_PATA_DA_0__GPIO7_6       0x80000000
>  -				MX53_PAD_PATA_DA_2__GPIO7_8	  0x80000000
>  -				MX53_PAD_GPIO_16__GPIO7_11        0x80000000
>  -			>;
>  -		};
>  -
>  -		led_pin_gpio7_7: led_gpio7_7@0 {
>  -			fsl,pins =3D <
>  -				MX53_PAD_PATA_DA_1__GPIO7_7 0x80000000
>  -			>;
>  -		};
>  -	};
>  -
>  -};
>  -
>  -&uart1 {
>  -	pinctrl-names =3D "default";
>  -	pinctrl-0 =3D <&pinctrl_uart1_1>;
>  -	status =3D "okay";
>  -};
>  -
>  -&i2c2 {
>  -	pinctrl-names =3D "default";
>  -	pinctrl-0 =3D <&pinctrl_i2c2_1>;
>  -	status =3D "okay";
>  -
>  -	sgtl5000: codec@0a {
>  -		compatible =3D "fsl,sgtl5000";
>  -		reg =3D <0x0a>;
>  -		VDDA-supply =3D <&reg_3p2v>;
>  -		VDDIO-supply =3D <&reg_3p2v>;
>  -		clocks =3D <&clks 150>;
>  -	};
>   };
>  =20
>   &i2c1 {

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__2_Apr_2014_12_55_57_+1100_esZUKu.PVbTNyxes
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTO24xAAoJEMDTa8Ir7ZwVhlYP/3cG+epMVapmrmVHqCoFAXz6
VRJHo+reT84enXarDMM9S9gq223YhHjL1IcARmfJElSbIXu+BoU0otmuvJhghjCq
3gSuBzCS+IZ6AVEVdNwmfkVBzQHkSEWt58b9xPAdm7xT7vfMSNw6veuy3cIa75/S
vD+RJCiFOc61hQx+1c2KpwXhbsQT80MYVOLs/Xi4EM9RExMn+hyjItedtbcBUchy
rXcCDmXmKouRbY5dpWCE8JJtvE4swUQJVQn9hOuyiNa8OkGbUGnqdwa0+TcXrcI8
Aaukkojjjq0pKesZFIRidiJqLdj+CF4XtGieMnmuobPRRpZMbBgLdIUkepneK72L
xc20vI6PEN0D3gXlo7LqCGIpyLunVhQTiLgGzQcgZc3blleRv8yfpV2KOTqZ1kE/
0bo3krz1xLgwZSCv09tC08A6ECBu7UazpfxBz7gsBcEy2h/TNbVgjPi0R1Ai/bZW
QV/DUUocwI2Hy7n2MdZg6bRfFGrAEjj3QtLsLNf+z5zUluBdZ2USW4Th1eIPBHC0
gzLDj4P04qUve75ewK5CZ3fCt6wyur/ITIw0TVpZMfEaopxF48KqWsz9YCh994X6
0G+QWsomI+0c2LU46CZgfXiGydYCqAZhsIZnFpW0GWmEuHikhzMnS2zRwAqxfi1b
3YHuMDpVSTHsS8TPBi7e
=lY02
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Apr_2014_12_55_57_+1100_esZUKu.PVbTNyxes--
