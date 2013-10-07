Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3JGUpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:45:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57634 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754986Ab3JGUpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:45:04 -0400
Date: Mon, 7 Oct 2013 22:44:09 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: oliver+list@schinagl.nl
Cc: rob.herring@calxeda.com, oliver@schinagl.nl, pawel.moll@arm.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: sunxi: dts: Add support for the cubieboard3, the
 CubieTruck
Message-ID: <20131007204409.GB3041@lukather>
References: <1380986247-29112-1-git-send-email-oliver+list@schinagl.nl>
 <1380986247-29112-2-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <1380986247-29112-2-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Sat, Oct 05, 2013 at 05:17:27PM +0200, oliver+list@schinagl.nl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>=20
> Cubieboard3, CT

Please change the commit log to something meaningful.

> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
> ---
>  arch/arm/boot/dts/Makefile                 |  1 +
>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 60 ++++++++++++++++++++++++=
++++++
>  2 files changed, 61 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>=20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index cc0f1fb..171e6c7 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -232,6 +232,7 @@ dtb-$(CONFIG_ARCH_SUNXI) +=3D \
>  	sun5i-a13-olinuxino.dtb \
>  	sun6i-a31-colombus.dtb \
>  	sun7i-a20-cubieboard2.dtb \
> +	sun7i-a20-cubietruck.dtb \
>  	sun7i-a20-olinuxino-micro.dtb
>  dtb-$(CONFIG_ARCH_TEGRA) +=3D tegra20-harmony.dtb \
>  	tegra20-iris-512.dtb \
> diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/d=
ts/sun7i-a20-cubietruck.dts
> new file mode 100644
> index 0000000..0167afe
> --- /dev/null
> +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> @@ -0,0 +1,60 @@
> +/*
> + * Copyright 2013 Oliver Schinagl
> + *
> + * Oliver Schinagl <oliver@schinagl.nl>
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/dts-v1/;
> +/include/ "sun7i-a20.dtsi"
> +
> +/ {
> +	model =3D "Cubietech Cubietruck";
> +	compatible =3D "cubietech,cubietech", "allwinner,sun7i-a20";

cubietech,cubietruck :)

> +
> +	soc@01c00000 {
> +		pinctrl@01c20800 {
> +			led_pins_cubietruck: led_pins@0 {
> +				allwinner,pins =3D "PH7", "PH11", "PH20", "PH21";
> +				allwinner,function =3D "gpio_out";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +		};
> +
> +		uart0: serial@01c28000 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&uart0_pins_a>;
> +			status =3D "okay";
> +		};
> +	};
> +
> +	leds {
> +		compatible =3D "gpio-leds";
> +		pinctrl-names =3D "default";
> +		pinctrl-0 =3D <&led_pins_cubietruck>;
> +
> +		blue {
> +			label =3D "cubietruck:blue:usr";
> +			gpios =3D <&pio 7 21 0>;
> +		};

Newline

> +		orange {
> +			label =3D "cubietruck:orange:usr";
> +			gpios =3D <&pio 7 20 0>;
> +		};

Ditto.

> +		white {
> +			label =3D "cubietruck:white:usr";
> +			gpios =3D <&pio 7 11 0>;
> +		};

Ditto.

> +		green {
> +			label =3D "cubietruck:green:usr";
> +			gpios =3D <&pio 7 7 0>;
> +		};
> +	};
> +};
> --=20
> 1.8.1.5
>=20

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSUx0ZAAoJEBx+YmzsjxAgvfUQAMAjplnrQfTPeeCCep4OQQMu
lxFpbmBQ+Um3c1+nex7Y1WpKyR0KIAdh6XW+EQQpMvuLIkzmX4m+EoI7LCPMqt2T
Ct6xL+3qrGD6ifHRgf2irtjFnQMWICP8iskegQcre3Y4hA4eij3jCsKMCA5XTVoI
J1/I7FxdHFAAlxEpbBDojE6cLpZtx5DvIMM60Trsy+9udFL10hGVzoaSNTFT1H0B
yVZ7OYiY9Cf3YG7HZwGNWL1aGSzbVSWMviO1MrUyl8It4W9F/VfWl/LcHn/FQAGD
WP4/GyJ2byGoHFUQpYGOsWn4MckvJqCP2UxUcaVeRLystr03xWVIdr6I9uUCCg+d
G5/MqVhDGwfTHx2T//RKERjsnmZP9GYPNcbKHKW74IwLJzohXxjXRWkYabNleqH2
ULh7tfwN4bh46+63ZGG8QxWFu9Sg46hPbJ0rG+ETk7qgWuQein0ngcJag3PREC1Z
VN7cW7xmM1ukyRGkNuhQ+OCxo2QZTA+1MJf+Dq+r2Dgo7Uwqm4M/Lp8rf7PgFniy
d1JB072Y5ZVg1zo8U1N5e/IA3njWMpbJrpn9J9JQTtwl9PRtL6DTnafMiq+tEt7Q
sxl79UCxQq+vzWIcVCqXOfYMGeIu/HEXkUbjq3lfz0WVBs23ll63TET2GfuNbBsP
oBzp3DPWb3JxLY5V8JBl
=4MLT
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
