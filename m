Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaECSuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:50:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60917 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752347AbaECSuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:50:07 -0400
Date: Sat, 3 May 2014 11:00:49 -0700
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
Subject: Re: [PATCH v5 3/3] ARM: sunxi: Add IR controller support in DT on A20
Message-ID: <20140503180049.GD15342@lukather>
References: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
 <1398871010-30681-4-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uxuisgdDHaNETlh8"
Content-Disposition: inline
In-Reply-To: <1398871010-30681-4-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2014 at 09:16:50PM +0600, Alexander Bersenev wrote:
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
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index 0ae2b77..bb655a5 100644
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
> +			ir1_pins_a: ir1@0 {
> +				    allwinner,pins =3D "PB22","PB23";
> +				    allwinner,function =3D "ir1";
> +				    allwinner,drive =3D <0>;
> +				    allwinner,pull =3D <0>;
> +			};
>  		};
> =20
>  		timer@01c20c00 {
> @@ -937,5 +950,23 @@
>  			#interrupt-cells =3D <3>;
>  			interrupts =3D <1 9 0xf04>;
>  		};
> +
> +       		ir0: ir@01c21800 {

This line...

> +	     		compatible =3D "allwinner,sun7i-a20-ir";
> +			clocks =3D <&apb0_gates 6>, <&ir0_clk>;
> +			clock-names =3D "apb", "ir";
> +			interrupts =3D <0 5 4>;
> +			reg =3D <0x01c21800 0x40>;
> +			status =3D "disabled";
> +		};
> +
> +       		ir1: ir@01c21c00 {

=2E.. and this one are indented a tab too far.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uxuisgdDHaNETlh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTZS7RAAoJEBx+YmzsjxAguBUP/R4YhizsM2BOcvNCLqXUqcdr
tZzhQzHC9/Lrq55oq6jie35tZAKS9ZVaa7nuihmnLUm68XR4LOQHQy2lSYKDZcX1
IPWjloMwab+5yQ/dbOL0M08zZh+Oz7s99mTMJR3TKu7D7vfMUbn1s/fUtXOUuKWk
TacUirouo3sGjtjFX2uQEIUIThOQLN5sbJhdIc3bZBMitoLtBHkmothVkuypRpon
/FDu6k4HPGMyVVE6emncCX2uzVZAaNkHIvz4rLeExpEnFJpbaN5mWFwrfb7mjNdE
HYrFQoNKSgjaYWz+yLucOn4tPxFnVoTX3FlmBGCoXNcx95BwOF+sx5udhBjyaHu+
pv9F/eBP5ttvEt8cWA7IS3ulMEAZ+Wswl/PtaTwq3YUO5RhModf+eKYTfXrKrP/z
hYn/MnirFnMc21gG5Nas78wsA7CjEmSvA4+h5nQP+0mrRqmBOEH/vyfvuOCWlRJx
up6Frbol57uGKhWIQslc/yEI/yvdzBly6a4VGVnGnJ+6NwRJzygWllsfsVnVqbwY
aFM5IVOw1oEkp87LJhqH7AfGB636rdnL3GonadxWfXVAM+8aExA+RwdeG3ZWsQP9
bL3Ud+rWIiPai3Z/41DKZtuwnymiswiioMrcOQXnbJsZaQiynporAO/P8LQtKu6b
GONEqcp4bfzQyPlPjvzd
=hN4V
-----END PGP SIGNATURE-----

--uxuisgdDHaNETlh8--
