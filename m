Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaENHzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:55:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44318 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750781AbaENHzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:55:15 -0400
Date: Wed, 14 May 2014 09:50:17 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexander Bersenev <bay@hackerdom.ru>
Cc: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rdunlap@infradead.org, robh+dt@kernel.org,
        sean@mess.org, srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v6 3/3] ARM: sunxi: Add IR controller support in DT on A20
Message-ID: <20140514075017.GH29258@lukather>
References: <1400006342-2968-1-git-send-email-bay@hackerdom.ru>
 <1400006342-2968-4-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LwthZj+AV2mq5CX"
Content-Disposition: inline
In-Reply-To: <1400006342-2968-4-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4LwthZj+AV2mq5CX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 12:39:02AM +0600, Alexander Bersenev wrote:
> This patch adds IR controller in A20 Device-Tree:
> - Two IR devices found in A20 user manual
> - Pins for two devices
> - One IR device physically found on Cubieboard 2
> - One IR device physically found on Cubietruck
>=20
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
> ---
>  arch/arm/boot/dts/sun7i-a20-cubieboard2.dts |  6 ++++++
>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts  |  6 ++++++
>  arch/arm/boot/dts/sun7i-a20.dtsi            | 31 +++++++++++++++++++++++=
++++++
>  3 files changed, 43 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/=
dts/sun7i-a20-cubieboard2.dts
> index feeff64..2564e8c 100644
> --- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> @@ -164,6 +164,12 @@
>  				reg =3D <1>;
>  			};
>  		};
> +
> +		ir0: ir@01c21800 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&ir0_pins_a>;
> +			status =3D "okay";
> +		};
>  	};
> =20
>  	leds {
> diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/d=
ts/sun7i-a20-cubietruck.dts
> index e288562..e375e89 100644
> --- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> @@ -232,6 +232,12 @@
>  				reg =3D <1>;
>  			};
>  		};
> +
> +		ir0: ir@01c21800 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&ir0_pins_a>;
> +			status =3D "okay";
> +		};
>  	};
> =20
>  	leds {

Please make these two changes a separate patch.

> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index 0ae2b77..40ded74 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -724,6 +724,19 @@
>  				allwinner,drive =3D <2>;
>  				allwinner,pull =3D <0>;
>  			};
> +
> +			ir0_pins_a: ir0@0 {
> +				    allwinner,pins =3D "PB3","PB4";
> +				    allwinner,function =3D "ir0";
> +				    allwinner,drive =3D <0>;
> +				    allwinner,pull =3D <0>;
> +			};

Extra line

> +			ir1_pins_a: ir1@0 {
> +				    allwinner,pins =3D "PB22","PB23";
> +				    allwinner,function =3D "ir1";
> +				    allwinner,drive =3D <0>;
> +				    allwinner,pull =3D <0>;
> +			};
>  		};

Do you use ir1_pins_a at all?

I also prefer whenever such additions are in a patch of their own.

>  		timer@01c20c00 {
> @@ -937,5 +950,23 @@
>  			#interrupt-cells =3D <3>;
>  			interrupts =3D <1 9 0xf04>;
>  		};
> +
> +		ir0: ir@01c21800 {
> +			compatible =3D "allwinner,sun7i-a20-ir";
> +			clocks =3D <&apb0_gates 6>, <&ir0_clk>;
> +			clock-names =3D "apb", "ir";
> +			interrupts =3D <0 5 4>;
> +			reg =3D <0x01c21800 0x40>;
> +			status =3D "disabled";
> +		};
> +
> +		ir1: ir@01c21c00 {
> +			compatible =3D "allwinner,sun7i-a20-ir";
> +			clocks =3D <&apb0_gates 7>, <&ir1_clk>;
> +			clock-names =3D "apb", "ir";
> +			interrupts =3D <0 6 4>;
> +			reg =3D <0x01C21c00 0x40>;

You're mixing upper and lower case letters here, please make it lower
case.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--4LwthZj+AV2mq5CX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcyA4AAoJEBx+YmzsjxAg2F4QALlYjQJBlnJFHqVS4hlcB8o+
f1RTfqtm0cxd6TXQZSzo+GavdD83WTbN/4vRAGfvA6p8gQD4pr8sYwlMdhFKLkiI
qNJuKVAS6ISkT8AfSOO4dJi4oaU0BMGUYIL3DBUxGNjf+7iMLwVKwimQ9ogkL75V
I/ybY48t2ojJWrK5bm9YDDT/Zh2uewtKdtL0hFE7q6s8wEckBluWykscXLlPU1ID
KDCP27RkWT0MTYTgxAoWK4CpSHmCeXA9/4cFEG5WDh2IeoxOcbbQ6QLasOF0o+AY
KGrQHYUT4IFYHFJWPhdHOsgBz28O0IC+SJs7CbFt8KfiAzEBGEbQbv5eOkvJCmbU
732RPsLhq3tEkIJUZRbnwT7T/vnAfhmlfjlhEDo8Mkb/T5crU7az5PfX9SqJh9hT
Xzo47favlpsXVWBn7k2sGcLsm8BqaLjovn9HwnlXxZ6iPP+aFrah3MRoViawy+j1
qH6fc9JXtHxD1DYEMiLm7NkT9VA2njsmqIgm7lVvcENdx9Hg25ggpnIUtJ0SSuSG
H1T0HLaooCoGcHwPksBOwnzQiCTzFjkRbqT4+HU0llzcJCshHEKuebNEI4Xw6B4r
Dthw3tAI0dAEvxbWLwHOJn+zV4bZ8JEE1iTpymWPXOWeLm8jKxNewWB9OxKbLFVJ
qPUK/8eDeVj3Tc8HtYSy
=G1BZ
-----END PGP SIGNATURE-----

--4LwthZj+AV2mq5CX--
