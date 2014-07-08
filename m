Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaGHNiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:38:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43313 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbaGHNin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:38:43 -0400
Date: Tue, 8 Jul 2014 08:38:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <broonie@kernel.org>
Subject: Re: [PATCH v2 3/7] ARM: dts: AM43x: Add TPS65218 device tree nodes
Message-ID: <20140708133830.GE25811@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404814597-4404-1-git-send-email-j-keerthy@ti.com>
 <1404814597-4404-4-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rgf3q3z9SdmXC6oT"
Content-Disposition: inline
In-Reply-To: <1404814597-4404-4-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Rgf3q3z9SdmXC6oT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 03:46:33PM +0530, Keerthy wrote:
> Add TPS65218 device tree nodes. i2c clock frequency setting
> also added as part of tps65218 nodes addition. As i2c clock
> enabling is required.
>=20
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>=20
> Changes in V2:
>   * Added dcdc3, dcdc5, dcdc6 nodes.

It might be worth noting that dcdc4 is missing because of a possible
PMIC bug you're dealing with. Other than that:

Reviewed-by: Felipe Balbi <balbi@ti.com>

>  arch/arm/boot/dts/am43x-epos-evm.dts |   59 ++++++++++++++++++++++++++++=
++++++
>  1 file changed, 59 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am4=
3x-epos-evm.dts
> index 90098f9..f1ee7495 100644
> --- a/arch/arm/boot/dts/am43x-epos-evm.dts
> +++ b/arch/arm/boot/dts/am43x-epos-evm.dts
> @@ -327,6 +327,65 @@
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
> +
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
> =20
>  	at24@50 {
>  		compatible =3D "at24,24c256";
> --=20
> 1.7.9.5
>=20

--=20
balbi

--Rgf3q3z9SdmXC6oT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTu/RWAAoJEIaOsuA1yqREeYYP/iIM4vzXyia0aftE5QyjOWnE
4c0FMrR28RUQs2GnS3ucCg3fKqV6pjc2RdLbdPG69H1R0LEPB8uIRJs6AUGzYNlu
UDbzNPqaw18JtQJu/frPn7wHmHAGN+bDbOvFEtJOO4f7dU2CfjHA614QjiKJVzuN
KPfk8bSNEkND3q3j3yeWEDCd2YKSjUVSW3lSC9Bb2KIAbcrYoQ/jEVHJbgPo1BEb
XTNaxaFCuai5fQwbbRA87e8X2m2IJBpln8RdEzmoOctPJn2ZFghnBttC2DyMY0tS
kRrvWNUPQ8FEKz7p07H9UeGX9MIaEFBE+AmS7oakefj7M8trPpO40rV+2YEIpxe8
PLN3Jok+b7F9QhTK+H/BJ0D3MQlTOvgGbXy6asTrgHb5JD4DEkjoGggy3Vj3vHV8
iy2m3SHAotfuq2RlK0mTKj+zte5xI9F32TSJzosFfi7pHGAgSqIgqLJJnakCWuLu
4hswJRTQ6cR+E3fvs6Tmmxt/8DSj3tLVG76sPoOp+dwzltT3X2zdHdrf7q8rLEsW
bgxVpSKdWshsvb6fLdZrT+jGpXBRdttU+d9RhdLCn0r6QsMLubXOyT0zyDOYdCtO
+R/lLosk/+i00q4TPyovPsM6YE/dWG+0gJxAyHozsxGnh4MwGULw0FXgKZEEJu5J
GRw19w8r7PwWYBavZ536
=I00C
-----END PGP SIGNATURE-----

--Rgf3q3z9SdmXC6oT--
