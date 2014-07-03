Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbaGCOYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:24:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45620 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591AbaGCOYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:24:03 -0400
Date: Thu, 3 Jul 2014 09:23:47 -0500
From: Felipe Balbi <balbi@ti.com>
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>
Subject: Re: [PATCH 4/5] ARM: dts: AM437x: Add TPS65218 device tree nodes
Message-ID: <20140703142347.GJ5814@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404395102-21469-1-git-send-email-j-keerthy@ti.com>
 <1404395102-21469-5-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uuKVzAmB+c+zQlhu"
Content-Disposition: inline
In-Reply-To: <1404395102-21469-5-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uuKVzAmB+c+zQlhu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 07:15:01PM +0530, Keerthy wrote:
> Add TPS65218 device tree nodes.
>=20
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  arch/arm/boot/dts/am437x-gp-evm.dts |   38 +++++++++++++++++++++++++++++=
++++++
>  1 file changed, 38 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am43=
7x-gp-evm.dts
> index 003766c..fc35d24 100644
> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
> @@ -260,6 +260,44 @@
>          status =3D "okay";
>          pinctrl-names =3D "default";
>          pinctrl-0 =3D <&i2c0_pins>;
> +	clock-frequency =3D <400000>;

same as before, also indentation is wrong, but I see indentation was
already wrong on this file, perhaps add a patch before this one fixing
that so this file is indented with tabs only ?

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

also missing dcdc3/4/5. (6 has a non-populated 0 ohm resistor, so it
should be turned off).

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

--uuKVzAmB+c+zQlhu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtWdzAAoJEIaOsuA1yqRELwEP/195++3XGbwRNavqEyXF8V+N
23QjXPrCJX65TfLZsYL6P3U9j5TmlqDjzVgYIKduwRnOvK4NRIf+/XB+QvY2FG21
tUEgML2Rh0P+OYTB7pB/ODx8W/mMX6vnMA92XkhV7TL8tV1qU20u+St+zBhTDjD6
G+uJU2FPlQmvTGIKpqyWRQw4vRwyH6W/Nv+45n6uQUOHll2hl3zcnT5vQWoSnyCs
FGSgNguXe97yC4cG+Z1Et/jxVoNHpzx77RHsmJNs61a8A/Zvo/VsbEjlU486EUIk
a/QohQnQ99zwLrhK0WsnabYzZZsaCsX8B55pOMtIdzPaUFxivQ+3sGsZXRxz1y5C
JAS/wbdjfuaXckTFaFBOMYtMJSC/ToHuR8iA6Q+wLsxVmkCryou4MNxeUGQrAZGr
dzIxydbEy66nLMYUnFrwCUVsBEtgQDtHV7XZ1/aeqmjILsNZH81SJ/k4FfLRtOb3
ydfkHRyc+ai8yNr8Oi1/QZATFVweavDdfomSne7lwEeeYNNoq4jbVHHq0O8Me89y
Q/U3gA0cJ1zM6MWPQqtyDEjzuxwESe3RVN8KdfUSEb7q+xwv6yNtCFsm+SaS0IzJ
4To1AQKX98m2GN9H1QbLM5pLrAG1UMXp2C+R3jgPWMY0Rc4D0JBy07WF41iS7XD1
Bjx1z2G9vblSsdvyG8Gg
=w8kS
-----END PGP SIGNATURE-----

--uuKVzAmB+c+zQlhu--
