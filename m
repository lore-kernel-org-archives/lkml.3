Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaGHNjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:39:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47378 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaGHNjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:39:20 -0400
Date: Tue, 8 Jul 2014 08:39:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <broonie@kernel.org>
Subject: Re: [PATCH v2 5/7] ARM: dts: AM437x: Add TPS65218 device tree nodes
Message-ID: <20140708133905.GG25811@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404814597-4404-1-git-send-email-j-keerthy@ti.com>
 <1404814597-4404-6-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VACxsDaSTfeluoxK"
Content-Disposition: inline
In-Reply-To: <1404814597-4404-6-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VACxsDaSTfeluoxK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 03:46:35PM +0530, Keerthy wrote:
> Add TPS65218 device tree nodes. i2c clock frequency setting
> also added as part of tps65218 nodes addition. As i2c clock
> enabling is required.
>=20
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>=20
> Changes in V2:
>   *Added dcdc3, dcdc5, dcdc6 nodes

same thing wrt dcdc4

>=20
>  arch/arm/boot/dts/am437x-gp-evm.dts |   58 +++++++++++++++++++++++++++++=
++++++
>  1 file changed, 58 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am43=
7x-gp-evm.dts
> index 85ca430..f0422c2 100644
> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
> @@ -260,6 +260,64 @@
>  	status =3D "okay";
>  	pinctrl-names =3D "default";
>  	pinctrl-0 =3D <&i2c0_pins>;
> +	clock-frequency =3D <400000>;
> +
> +	tps65218: tps65218@24 {
> +		reg =3D <0x24>;
> +		compatible =3D "ti,tps65218";
> +		interrupts =3D <GIC_SPI 7 IRQ_TYPE_NONE>; /* NMIn */
> +		interrupt-parent =3D <&gic>;
> +		interrupt-controller;
> +		#interrupt-cells =3D <2>;
> +
> +		dcdc1: regulator-dcdc1 {
> +			compatible =3D "ti,tps65218-dcdc1";
> +			regulator-name =3D "vdd_core";
> +			regulator-min-microvolt =3D <912000>;
> +			regulator-max-microvolt =3D <1144000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		dcdc2: regulator-dcdc2 {
> +			compatible =3D "ti,tps65218-dcdc2";
> +			regulator-name =3D "vdd_mpu";
> +			regulator-min-microvolt =3D <912000>;
> +			regulator-max-microvolt =3D <1378000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		dcdc3: regulator-dcdc3 {
> +			compatible =3D "ti,tps65218-dcdc3";
> +			regulator-name =3D "vdcdc3";
> +			regulator-min-microvolt =3D <1350000>;
> +			regulator-max-microvolt =3D <1350000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};

add a blank line here

Reviewed-by: Felipe Balbi <balbi@ti.com>


> +		dcdc5: regulator-dcdc5 {
> +			compatible =3D "ti,tps65218-dcdc5";
> +			regulator-name =3D "v1_0bat";
> +			regulator-min-microvolt =3D <1000000>;
> +			regulator-max-microvolt =3D <1000000>;
> +		};
> +
> +		dcdc6: regulator-dcdc6 {
> +			compatible =3D "ti,tps65218-dcdc6";
> +			regulator-name =3D "v1_8bat";
> +			regulator-min-microvolt =3D <1800000>;
> +			regulator-max-microvolt =3D <1800000>;
> +		};
> +
> +		ldo1: regulator-ldo1 {
> +			compatible =3D "ti,tps65218-ldo1";
> +			regulator-min-microvolt =3D <1800000>;
> +			regulator-max-microvolt =3D <1800000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +	};
>  };
> =20
>  &i2c1 {
> --=20
> 1.7.9.5
>=20

--=20
balbi

--VACxsDaSTfeluoxK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTu/R5AAoJEIaOsuA1yqREcbEP/jy18kqtYmwaQF0yW2T735uE
eMi+Jtjj0uM6iMawYhjhyFXhFBDKGTVizf7qEbTtHqj8j2RJQG6stsF5eBFh/S8C
7WOIs/0zJKbIZbSAfo3GcG4O6hrsBit+7bTRRJtTGVQdAevd0vuNK0ixKy5/PwZe
Yae+CYXUHTcaa46SH5v8EpLn6+gel8Zm3FdXRQt4JLLC8ZN43kVrXHB6rzYQZWa2
DxsUvc4XwqK/ZWE+fpPebLIxVVY94nPsAt5xUVNbRdKZKf8Bc3ZE62ZJ8imz2dpm
4Vcrxqmk3On9wSghuoygcwfzEbAn0JfOeBObcYP+5BDlM3Ffz7j3+cT0SDftrq43
ZRJof3udC8mVeqq4BtqsB7ZR01aybvdkY5a3qn17sglAIIg172N9qKJqIQMKF/0x
5Ofs2UrD8fWld1gxLQpk3CcGwEbytj2iU83GykpTHbSp1XfISpJDf1Sa7o6kR1eo
LxNm/ODvm98Mv5zwGhExJ6Day7jgFQE2tny8MR99nOQ7XqJmje1JJ1LirVQahydh
Hac588ibMIr2fuhu080bh0pirbO/mP5A57sATzJZGpTfVhSOy4ZxWD465M8sslYs
hZU8YqNXD+3r7kbPxRHjSQ9S0AmJ9FPiDbNXZc57etNzwEqlzIqcYJ/dhsrTTn6w
qSLm6xiQ/YoZ3JBFCBJd
=+8Y3
-----END PGP SIGNATURE-----

--VACxsDaSTfeluoxK--
