Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaLHWZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:25:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40249 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbaLHWZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:25:03 -0500
Date: Mon, 8 Dec 2014 23:22:59 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: vishnupatekar <vishnupatekar0510@gmail.com>
Cc: linux-sunxi@googlegroups.com, dmitry.torokhov@gmail.com,
        linux@arm.linux.org.uk, leafy.myeh@newbietech.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2 3/3]  ARM:dts:sunxi:ps2 dt nodes for A10/A20 PS2
 controller.
Message-ID: <20141208222259.GN8739@lukather>
References: <1417907719-26775-1-git-send-email-VishnuPatekar0510@gmail.com>
 <1417907719-26775-4-git-send-email-VishnuPatekar0510@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5FetH82qe0Z6y/zI"
Content-Disposition: inline
In-Reply-To: <1417907719-26775-4-git-send-email-VishnuPatekar0510@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5FetH82qe0Z6y/zI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Your commit title should be less that 80 chars.

It should also be formatted using "ARM: sunxi: dts:" as a prefix (More
specific to less specific).

On Sun, Dec 07, 2014 at 04:45:19AM +0530, vishnupatekar wrote:
>  Added ps2 nodes in lime2 board dts. By default ps20 and ps21 nodes are
>  commented as ps20 pins conflict with HDMI connector
>  on Lime2 Board.
>=20
> Signed-off-by: vishnupatekar <VishnuPatekar0510@gmail.com>
> ---
>  arch/arm/boot/dts/sun4i-a10.dtsi                |   27 +++++++++++++++++=
++++
>  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts |   13 ++++++++++
>  arch/arm/boot/dts/sun7i-a20.dtsi                |   29 +++++++++++++++++=
++++++
>  3 files changed, 69 insertions(+)

This patch should also be split into three different patches:
  - The one adding the nodes for the controller to the DTSI
  - The one adding the pinctrl nodes
  - The one enabling the controller on the board.

>=20
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a=
10.dtsi
> index 5e2ec2d..4726e8d 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -615,6 +615,19 @@
>  				allwinner,drive =3D <0>;
>  				allwinner,pull =3D <0>;
>  			};

A newline here please.

> +			ps2_0_pins: ps2_0@0 {

You called the node ps20, you probably want to call it the same way
here. And we usually have a suffix like pins_a whenever we have
several muxing options (as it's probably the case).

> +				    allwinner,pins =3D "PI20","PI21";

A whitespace after the comma please.

> +				    allwinner,function =3D "ps2";
> +				    allwinner,drive =3D <0>;
> +				    allwinner,pull =3D <0>;
> +			};

Newline.

> +			ps2_1_pins: ps2_1@0 {
> +				    allwinner,pins =3D "PH12","PH13";
> +				    allwinner,function =3D "ps2";
> +				    allwinner,drive =3D <0>;
> +				    allwinner,pull =3D <0>;
> +			};
> +
>  		};
> =20
>  		timer@01c20c00 {
> @@ -781,5 +794,19 @@
>  			#address-cells =3D <1>;
>  			#size-cells =3D <0>;
>  		};

Newline.

> +		ps20: ps2@0x01c2a000 {

Drop the 0x

> +			compatible =3D "allwinner,sun4i-a10-ps2";
> +			reg =3D <0x01c2a000 0x400>;
> +			interrupts =3D <0 62 4>;
> +			clocks =3D <&apb1_gates 6>;
> +			status =3D "disabled";
> +		};

Newline

> +		ps21: ps2@0x01c2a400 {
> +			compatible =3D "allwinner,sun4i-a10-ps2";
> +			reg =3D <0x01c2a400 0x400>;
> +			interrupts =3D <0 63 4>;
> +			clocks =3D <&apb1_gates 7>;
> +			status =3D "disabled";
> +		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/b=
oot/dts/sun7i-a20-olinuxino-lime2.dts
> index ed364d5..5624e63 100644
> --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> @@ -112,6 +112,19 @@
>  			pinctrl-0 =3D <&uart0_pins_a>;
>  			status =3D "okay";
>  		};
> +		/* PS2 0 and PS2 1 are disabled by default
> +		To enable PS2 0 and PS2 1 uncomment below ps20 and ps21 nodes
> +		Please note that ps20 pins conflict with HDMI on Lime2 Board*/
> +		/*ps20: ps2@0x01c2a000 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&ps2_0_pins>;
> +			status =3D "okay";
> +		};
> +		ps21: ps2@0x01c2a400 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&ps2_1_pins>;
> +			status =3D "okay";
> +		};*/

Hmmm, no, no comments in the DTS.

Especially when it's that trivial to enable.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--5FetH82qe0Z6y/zI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhiTDAAoJEBx+YmzsjxAgqzAP/R2fzehYpsW9xYSqbc7VxFc4
ED+qSCgIcXDc+m7bsBdgRz2CXARkFoR/rIVQrIcxq/f3V+zyzJQ0YtJAOmviyaji
peDsfUHNKJTIKATIvgCXEbZZnk0on1MbB3L3XOtvdfNBLjSuHMGIWxTWb3r2BdtJ
LTMaZYXQn3RSFj/nsGUcPBq0kH6O5QTcYwFQm2NDolTeB7+KoC2Vu1xJdFMUltEa
m+7cJxTZHT9Fd3wZf8R33mNIAq94H+2ULywSk9oWYAvL2DObfpUqohmqvQcKBIn6
fkKDeSjbyqH/WYv6Psb6LWbmzZCr22CVQV2SoCZZ3tzmLEzl2p1vHD8OP6atEFnO
3SUHvDT7u5OvewRHl9fhFdHqmuvEdJTVrQtkPBFR0Kj84HJxriwRJxHhnzF7MyxY
Hg2zbg66d1Www39hCkqAYFJs3iI05mL90TADkrP49NJo7SusOtdzE6Yw+IFsf0N5
siSyraLtyfplYZiX/xudDLZSDbi8x5nN52RGpd79khNOM4ecjkK4ZnpVMAX5bWxB
BlWufXp6PK6ZqViQHQJ76A2ZZGgscsHl9ZjgBQeMLg5r7H9ydSbXAAqO/xjD6djH
FzrSpZZtH1mDMBTzLysMFDPGEKud5+ka1vtOjXQloitctHccTIfMu+ZZROpvb47R
W8SvH29U6eIbYs7U5SnP
=elFn
-----END PGP SIGNATURE-----

--5FetH82qe0Z6y/zI--
