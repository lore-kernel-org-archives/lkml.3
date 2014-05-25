Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaEYTnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:43:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33650 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751408AbaEYTnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:43:41 -0400
Date: Sun, 25 May 2014 21:39:55 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 22/22] ARM: sun8i: dt: Add Ippo-q8h v5 support
Message-ID: <20140525193955.GB10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-23-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JoJCGVnM/36AiBh+"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-23-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JoJCGVnM/36AiBh+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:25PM +0800, Chen-Yu Tsai wrote:
> The Ippo-q8h is a tablet circiut board commonly found in cheap Android
> tablets with A23 SoCs. There are at least 2 versions of the board, with
> different peripherals, such as WiFi chips.
>=20
> This patch add supports for v5 of such boards, which has a ESP8089 WiFi
> chip (not supported) connected to mmc1.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/Makefile                  |  2 ++
>  arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts | 51 +++++++++++++++++++++++=
++++++
>  2 files changed, 53 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
>=20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 6967393..f809a53 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -354,6 +354,8 @@ dtb-$(CONFIG_MACH_SUN7I) +=3D \
>  	sun7i-a20-cubietruck.dtb \
>  	sun7i-a20-i12-tvbox.dtb \
>  	sun7i-a20-olinuxino-micro.dtb
> +dtb-$(CONFIG_MACH_SUN8I) +=3D \
> +	sun8i-a23-ippo-q8h-v5.dtb
>  dtb-$(CONFIG_ARCH_TEGRA) +=3D tegra20-harmony.dtb \
>  	tegra20-iris-512.dtb \
>  	tegra20-medcom-wide.dtb \
> diff --git a/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts b/arch/arm/boot/=
dts/sun8i-a23-ippo-q8h-v5.dts
> new file mode 100644
> index 0000000..7d0bd97
> --- /dev/null
> +++ b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
> @@ -0,0 +1,51 @@
> +/*
> + * Copyright 2014 Chen-Yu Tsai
> + *
> + * Chen-Yu Tsai <wens@csie.org>
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
> +/include/ "sun8i-a23.dtsi"
> +
> +/ {
> +	model =3D "Ippo Q8H Dual Core Tablet (v5)";
> +	compatible =3D "ippo,q8h-v5", "allwinner,sun8i-a23";
> +
> +	chosen {
> +		bootargs =3D "earlyprintk console=3DttyS0,115200";
> +	};

You should probably add the memory node here too.

> +
> +	soc@01c00000 {
> +		uart0: serial@01c28000 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&uart0_pins_a>;
> +			status =3D "okay";
> +		};
> +
> +		i2c0: i2c@01c2ac00 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&i2c0_pins_a>;
> +			status =3D "okay";
> +		};
> +
> +		i2c1: i2c@01c2b000 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&i2c1_pins_a>;
> +			status =3D "okay";
> +		};

What are the two i2c busses wired to?

> +		r_uart: serial@01f02800 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&r_uart_pins_a>;
> +			status =3D "okay";
> +		};
> +	};
> +};
> +
> --=20
> 2.0.0.rc2
>=20

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JoJCGVnM/36AiBh+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgkcLAAoJEBx+YmzsjxAgMewP/j3gNNEr2DrVxSSiPcKCYp2k
kCORsgpAeST/lhnHS8U7FJZAObgpfOh3y0gveiMnR0H5nycJWL+1sRZCK+TcUy1/
VqgxH19iJ6Ja2WSJJMLSz/otGaF+YeTRBr+ESE3/yo2TPkqZjkjPb9qQUH5DlEIM
pAMj1/1fXq8vUoddsTQWxo//cEebDE+Io3dlxEBPsYyrVlSUcsNNSVCjL1kTTAk/
0xVEvo84ttgD908RcIPgIJ04s3XFk/2c/uA0wUmKdyL6Z+A7NtZvdaoo56TZbbrp
aoWT/6D2CYFSUYq9439LJRa69vPnodKqRhnFcZHM4U2xjZPqV6ZuqG76pNPPRm9k
xX2AxiAeXH2bkJSkK8j1Y2Oi7iZKdhNLv9JWf3Y53dwS5RZOVg5VRiQ9ooB5uqQ5
ptyJywshobS5lY/BEepJ9F4/n3M4cLsurGdyiPbDMGW8KhYZzsMaIE0yGWKFBiNl
mVwyCEv7DV1bJGQhrjw8/XI9cER8TLNHEl1nezAEX7nqyzgmlXRZ+ZGaDbHRG4so
9Lctq8ZLWqHqRT/bQMGifS49CzFZk8+l1kQD0c47ultwVh4TBW998AAu7abaCotn
rjbM6uimChfTu/A/EcQwPuP/OIYc4e13DYmuNndW50xo6NXIcBBIt2fkPBRex8XW
wbf4FsDOiyOgyDGzT01d
=fJnx
-----END PGP SIGNATURE-----

--JoJCGVnM/36AiBh+--
