Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaGHNj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:39:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52942 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbaGHNjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:39:25 -0400
Date: Tue, 8 Jul 2014 08:39:12 -0500
From: Felipe Balbi <balbi@ti.com>
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <broonie@kernel.org>
Subject: Re: [PATCH v2 6/7] regulator: tps65218: Add get_voltage ops for
 dcdc5 and dcdc6
Message-ID: <20140708133912.GH25811@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404814597-4404-1-git-send-email-j-keerthy@ti.com>
 <1404814597-4404-7-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3ecMC0kzqsE2ddMN"
Content-Disposition: inline
In-Reply-To: <1404814597-4404-7-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3ecMC0kzqsE2ddMN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 03:46:36PM +0530, Keerthy wrote:
> Add get_voltage ops for dcdc5 and dcdc6. Both dcdc5 and 6 are fixed regul=
ators
> and hence return min_uV (or max_uV).
>=20
> Signed-off-by: Keerthy <j-keerthy@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/regulator/tps65218-regulator.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/t=
ps65218-regulator.c
> index 9effe48..700c652 100644
> --- a/drivers/regulator/tps65218-regulator.c
> +++ b/drivers/regulator/tps65218-regulator.c
> @@ -151,6 +151,14 @@ static int tps65218_pmic_disable(struct regulator_de=
v *dev)
>  				   dev->desc->enable_mask, TPS65218_PROTECT_L1);
>  }
> =20
> +static int tps65218_pmic_dcdc56_get_voltage(struct regulator_dev *dev)
> +{
> +	struct tps65218 *tps =3D rdev_get_drvdata(dev);
> +	unsigned int rid =3D rdev_get_id(dev);
> +
> +	return tps->info[rid]->min_uV;
> +}
> +
>  /* Operations permitted on DCDC1, DCDC2 */
>  static struct regulator_ops tps65218_dcdc12_ops =3D {
>  	.is_enabled		=3D regulator_is_enabled_regmap,
> @@ -179,6 +187,7 @@ static struct regulator_ops tps65218_dcdc56_pmic_ops =
=3D {
>  	.is_enabled		=3D regulator_is_enabled_regmap,
>  	.enable			=3D tps65218_pmic_enable,
>  	.disable		=3D tps65218_pmic_disable,
> +	.get_voltage		=3D tps65218_pmic_dcdc56_get_voltage,
>  };
> =20
>  static const struct regulator_desc regulators[] =3D {
> --=20
> 1.7.9.5
>=20

--=20
balbi

--3ecMC0kzqsE2ddMN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTu/SAAAoJEIaOsuA1yqREUeoP/iDIo5ifmVx0iAgw93HQDAsg
18fDBGYwHDUDnn2zmuMoRk28ozSzJBx8w6PdN3FQ0h3gWX6thA3yPT+HrMOUAr3t
T0/oFxNk6zmqy60/q9mbK0p0y+QE2fu3qEDX70FjPWyOqsUg4GhNtZ+bc1O+GjN9
LEjlrhZNHr6XOZnKIniRvEsaHgnytuv5XJg5deHHkuvFAgOCUIeRzJW1g1FabotQ
E2kxCsoziz2yeBBY/mzr/acimBclIWlq6Yk2x1OLataGOQVL3wrPRySBZnM0rHik
fq3PTusTP5+7LKLKqak2ISWEz/ynhvj5QY2l+IM/VIg/ulrwXvSiZdk+Bz3dt3o0
bf9OUAOL1KsWROmy9bsX8lP7shLpFBXAwUzKKV8uaALINuh97ckADceJNFgkKp0A
6ivUYr5/2LakiF5Ge36TyA9Qt8JEB+JayiePgTXn5nwNO8NpzUgl/dqvOE//wxsW
DuGJmJnRRYakPHS87m55vca7nmr8qxI2uKw7zfWDCIbOFYfXgKqtwSsl7atncXrY
cnmifoB0Zr5rd9dKcMSZ8P8J1T79ZFbiZr6nSIXWiO6vJ5yT8wSl6tHDrZm4Mhhb
f4K1spwT+jr+HWgFRVkCF2aYJFJTVzU1UbgyMoGDN64syRAnRYP3aOeCM434BzqG
U3j+glVT0gyynRODJBXg
=U0kp
-----END PGP SIGNATURE-----

--3ecMC0kzqsE2ddMN--
