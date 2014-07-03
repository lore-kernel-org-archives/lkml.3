Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbaGCOVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:21:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40543 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbaGCOU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:59 -0400
Date: Thu, 3 Jul 2014 09:20:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>
Subject: Re: [PATCH 3/5] ARM: dts: AM43x: Add TPS65218 device tree nodes
Message-ID: <20140703142045.GI5814@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404395102-21469-1-git-send-email-j-keerthy@ti.com>
 <1404395102-21469-4-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fU0UwhtRbpo05rnG"
Content-Disposition: inline
In-Reply-To: <1404395102-21469-4-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fU0UwhtRbpo05rnG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 07:15:00PM +0530, Keerthy wrote:
> Add TPS65218 device tree nodes.
>=20
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  arch/arm/boot/dts/am43x-epos-evm.dts |   38 ++++++++++++++++++++++++++++=
++++++
>  1 file changed, 38 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am4=
3x-epos-evm.dts
> index 19f1f7e..749098b 100644
> --- a/arch/arm/boot/dts/am43x-epos-evm.dts
> +++ b/arch/arm/boot/dts/am43x-epos-evm.dts
> @@ -323,6 +323,44 @@
>  	status =3D "okay";
>  	pinctrl-names =3D "default";
>  	pinctrl-0 =3D <&i2c0_pins>;
> +	clock-frequency =3D <400000>;

looks unrelated but small enough that it should suffice to mention on
commit log.

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
> +			/* VDD_CORE voltage limits min of OPP50 and max of OPP100 */
> +			regulator-name =3D "vdd_core";
> +			regulator-min-microvolt =3D <912000>;
> +			regulator-max-microvolt =3D <1144000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +
> +		dcdc2: regulator-dcdc2 {
> +			compatible =3D "ti,tps65218-dcdc2";
> +			/* VDD_MPU voltage limits min of OPP50 and max of OPP_NITRO */
> +			regulator-name =3D "vdd_mpu";
> +			regulator-min-microvolt =3D <912000>;
> +			regulator-max-microvolt =3D <1378000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};

missing vdcdc3, vdcdc4, vdcdc5 and vdcdc6.

> +
> +		ldo1: regulator-ldo1 {
> +			compatible =3D "ti,tps65218-ldo1";
> +			regulator-min-microvolt =3D <1800000>;
> +			regulator-max-microvolt =3D <1800000>;
> +			regulator-boot-on;
> +			regulator-always-on;
> +		};
> +	};
> =20
>  	at24@50 {
>  		compatible =3D "at24,24c256";

--=20
balbi

--fU0UwhtRbpo05rnG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtWa9AAoJEIaOsuA1yqRENboQAKRyjHGvdnLDdnlwaTV2KoPC
6giTcpVJksywCTSy3oe/0ZV5I0u3tBYTQGc+epj7bMweG0BiA4o8A04OXjgYkGwG
SfiaTLee54h/OiseSLe3QhgQCkaaYF69YarU8xlWRCbXGnaVX+I0ucE2zD661zH1
vOoIzFnJPfFzGGZ4EQW4pfVVT8zRAOGMcWMl24//U1Y6ESjATkXaSLN/TfNbs1/a
kYt8jI01QLm1jZdrqHm6AFuy3q6EmwaNTXfWJYmyZ+OA5V631dO5bnfA0qdetSYK
Xi7wcugi0TNMEGMUb2gCHlk81AmyoD+OA5NNkSIEPwk4P5Dd1OLXsqLZi+RMY7vE
eL7nuaK+T93rZ0vRTLgqiumyaA4K5kPbdL6EK1NJjJZ+VEiWs+OFilnVBp0ok8+h
rCOKN+JVa5cTmlSB6ROnwvaz02VE76OxJWeCHBmVaYJWtf7SlQHkvgetf6y/kPfJ
YLSDY/0F0asywzUwtnNtJHleXp/IRGgn155CXWjZtgEa3fzo7hnSlFiIXCnFF4fH
/B+ijVuQimymZKvefohHk+VBZHAAB0Dm91CxvJEVQGIT2iOOXcq4uGypp53oRPq2
q+CLzPOrw0mMAHUybBnrErd4+5eniIAz32rmkwMBiTdqmfmY+0t49Bke81N/NtSB
HkFmOkiDqZfiCvCeeZzz
=ugrz
-----END PGP SIGNATURE-----

--fU0UwhtRbpo05rnG--
