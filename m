Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaGHNhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:37:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42969 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaGHNh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:37:29 -0400
Date: Tue, 8 Jul 2014 08:37:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <broonie@kernel.org>
Subject: Re: [PATCH v2 1/7] mfd: Add DT bindings for tps65218 PMIC
Message-ID: <20140708133713.GC25811@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404814597-4404-1-git-send-email-j-keerthy@ti.com>
 <1404814597-4404-2-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
Content-Disposition: inline
In-Reply-To: <1404814597-4404-2-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 03:46:31PM +0530, Keerthy wrote:
> Add DT bindings for tps65218 PMIC
>=20
> Signed-off-by: Keerthy <j-keerthy@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>=20
> Changes in V2:
>   * Added dcdc3, dcdc5, dcdc6 compatible properties.
>=20
>  Documentation/devicetree/bindings/mfd/tps65218.txt |   89 ++++++++++++++=
++++++
>  1 file changed, 89 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/tps65218.txt
>=20
> diff --git a/Documentation/devicetree/bindings/mfd/tps65218.txt b/Documen=
tation/devicetree/bindings/mfd/tps65218.txt
> new file mode 100644
> index 0000000..01ac973
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/tps65218.txt
> @@ -0,0 +1,89 @@
> +Texas Instruments TPS65218 family
> +
> +The TPS65218 are Integrated Power Management Chips.
> +
> +Required properties:
> +- compatible : Must be "ti,tps65218";
> +  For Integrated power-management used in AM437x based boards
> +- interrupts : This i2c device has an IRQ line connected to the main SoC
> +- interrupt-controller : Since the tps65218 supports several interrupts
> +  internally, it is considered as an interrupt controller cascaded to the
> +  SoC one.
> +- #interrupt-cells =3D <2>;
> +- interrupt-parent : The parent interrupt controller which is gic.
> +
> +Optional node:
> +- TPS65218 PMIC has a number of child nodes. Mainly the regularors and S=
MPSs.
> +
> +Example:
> +/*
> + * Integrated Power Management Chip
> + */
> +tps65218: tps65218@24 {
> +	reg =3D <0x24>;
> +	compatible =3D "ti,tps65218";
> +	interrupts =3D <GIC_SPI 7 IRQ_TYPE_NONE>; /* NMIn */
> +	interrupt-parent =3D <&gic>;
> +	interrupt-controller;
> +	#interrupt-cells =3D <2>;
> +
> +	dcdc1: regulator-dcdc1 {
> +		compatible =3D "ti,tps65218-dcdc1";
> +		/* VDD_CORE voltage limits min of OPP50 and max of OPP100 */
> +		regulator-name =3D "vdd_core";
> +		regulator-min-microvolt =3D <912000>;
> +		regulator-max-microvolt =3D <1144000>;
> +		regulator-boot-on;
> +		regulator-always-on;
> +	};
> +
> +	dcdc2: regulator-dcdc2 {
> +		compatible =3D "ti,tps65218-dcdc2";
> +		/* VDD_MPU voltage limits min of OPP50 and max of OPP_NITRO */
> +		regulator-name =3D "vdd_mpu";
> +		regulator-min-microvolt =3D <912000>;
> +		regulator-max-microvolt =3D <1378000>;
> +		regulator-boot-on;
> +		regulator-always-on;
> +	};
> +
> +	dcdc3: regulator-dcdc3 {
> +		compatible =3D "ti,tps65218-dcdc3";
> +		regulator-name =3D "vdcdc3";
> +		regulator-min-microvolt =3D <1350000>;
> +		regulator-max-microvolt =3D <1350000>;
> +		regulator-boot-on;
> +		regulator-always-on;
> +	};
> +
> +	dcdc4: regulator-dcdc4 {
> +		compatible =3D "ti,tps65218-dcdc4";
> +		regulator-name =3D "v3_3d";
> +		regulator-min-microvolt =3D <3300000>;
> +		regulator-max-microvolt =3D <3300000>;
> +		regulator-boot-on;
> +		regulator-always-on;
> +	};
> +
> +	dcdc5: regulator-dcdc5 {
> +		compatible =3D "ti,tps65218-dcdc5";
> +		regulator-name =3D "v1_0bat";
> +		regulator-min-microvolt =3D <1000000>;
> +		regulator-max-microvolt =3D <1000000>;
> +	};
> +
> +	dcdc6: regulator-dcdc6 {
> +		compatible =3D "ti,tps65218-dcdc6";
> +		regulator-name =3D "v1_8vat";
> +		regulator-min-microvolt =3D <1800000>;
> +		regulator-max-microvolt =3D <1800000>;
> +	};
> +
> +	ldo1: regulator-ldo1 {
> +		compatible =3D "ti,tps65218-ldo1";
> +		regulator-min-microvolt =3D <1800000>;
> +		regulator-max-microvolt =3D <1800000>;
> +		regulator-boot-on;
> +		regulator-always-on;
> +	};
> +};
> --=20
> 1.7.9.5
>=20

--=20
balbi

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTu/QJAAoJEIaOsuA1yqRERooQALZrkXHBAaS1F18oTbvuneev
fjUCr2WolNpa8YMy/as8TRUmdbb6Hl8x3T6LxnhzE2afdQmInMkRK9Xh75fcnDwI
jcErcjE9lhYsOFWo9wvSWSEbBosGkPWWwAfspGLMpJcjWxUgU8eawpQqPSDu++eH
Frka171Sbf6p7qi6bfa7MG/LVxUyOdrRTQENhi9W2hO4yaTU/F5hX+D4kz9QO1HV
YTGJl6cjrtOqdHv9gvsDEokErsI0vl+J6kJoX298FsZ3LqbnhkdbaCTS2bgjaBLu
vm+ytEKHF45MbWyXUbgzg5sPjZenzVmLhcfHBCdJ3VKYQzL5NMlZUzdW7I8pDK9k
P6CJ/IuvMXZH9fWbb60wPsYb+Kyk0odXS4sosUmaoY90WfIIMutOpOT/75R5pWcS
/SbtAt5WIkVobut25qYhp9I7/5Cl/1///Us3o31kIKYIXJxHK3xCytSxrdvdx720
+ChgyjRfAO4hq6DBRC8BnQNAgTAGHNDkl7AbzCLR8U3F01u2iYU3WE57FbwN2HT1
Ut6vYBIdEStgXgh0xLAPniMB4WuJkSoUFfpvKZ3l5flI3XU3nEtji9F+VaWXNZrx
o+phbxaSOOoP+VBazN6wbTwoaiuRxgdZBa9xgPvl/9mgGb5eU3gnn24oUKBbGQA1
G9YRQgDtplboZ/+9sg+c
=/SHQ
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
