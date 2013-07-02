Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3GBVGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:06:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59862 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3GBVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:06:43 -0400
Date: Tue, 2 Jul 2013 22:06:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20130702210617.GA27646@sirena.org.uk>
References: <201307011447.r61Els8t019635@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YI/KIGiRofOEmDiH"
Content-Disposition: inline
In-Reply-To: <201307011447.r61Els8t019635@swsrvapps-01.diasemi.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC V2] DA9210 driver files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YI/KIGiRofOEmDiH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 01, 2013 at 03:10:28PM +0100, Steve Twiss wrote:
> From: Steve Twiss <stwiss.opensource@diasemi.com>
>=20
> This is the regulator driver for the Dialog DA9210 Multi-phase Buck.
> The patch is relative to linux-next next-20130701
> and this is RFC attempt number 2

Please follow the patch submission process in SubmittingPatches.  This
doesn't visually resemble most patch submissions...

>  >This looks like you should be using a regmap range.

> The use of regmap_range is not being considered because I am not intending
> to use PAGE_CON register page selection in any of the driver development.

Makes sense to map things in for diagnostics...

> +config REGULATOR_DA9210
> +	tristate "Dialog Semiconductor DA9210 Regulator"

Capitalisation is wrong Here.

> +static int da9210_set_current_limit(struct regulator_dev *rdev, int min_=
uA,
> +				    int max_uA)
> +{
> +	struct da9210 *chip =3D rdev_get_drvdata(rdev);
> +	unsigned int sel;
> +	int i;
> +
> +	/* search for closest to maximum */
> +	for (i =3D N_CURRENT_LIMITS-1; i >=3D 0; i--) {

Coding style.

> +	ret =3D regmap_read(chip->regmap, DA9210_REG_BUCK_ILIM, &data);
> +	if (ret < 0)
> +		return ret;
> +
> +	sel =3D (data & DA9210_BUCK_ILIM_MASK) >> DA9210_BUCK_ILIM_SHIFT;
> +
> +	return da9210_buck_limits[sel];

There's no unused values in the selector?

> +	chip->desc.id =3D 0;
> +	chip->desc.type =3D REGULATOR_VOLTAGE;
> +	chip->desc.n_voltages =3D ((DA9210_MAX_MV - DA9210_MIN_MV)
> +				/ DA9210_STEP_MV) + 1;
> +	chip->desc.ops =3D &da9210_buck_ops;
> +	chip->desc.owner =3D THIS_MODULE;
> +	chip->desc.name =3D "DA9210";
> +	chip->desc.enable_reg =3D DA9210_REG_BUCK_CONT;
> +	chip->desc.enable_mask =3D DA9210_BUCK_EN;
> +	chip->desc.vsel_reg =3D DA9210_REG_VBUCK_A;
> +	chip->desc.vsel_mask =3D DA9210_VBUCK_MASK;
> +	chip->desc.min_uV =3D (DA9210_MIN_MV * 1000);
> +	chip->desc.uV_step =3D (DA9210_STEP_MV * 1000);

Why is this not just global static data?  There's nothing variable
here...

> +	dev_info(&i2c->dev,
> +		"DA9210 device detected\n");
> +

Remove this - it's just noise, apart from anything else nothing here has
actually verified that the chip exists.

--YI/KIGiRofOEmDiH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR00DGAAoJELSic+t+oim9YLoP/iUcTjiGuOUxSVdYFrfBrF5H
UmninaTjKChAMGCYUb7ZqAbo4I6G4Ptbp+mWOhzXT4/AIAZNTAkJ2jRBHrmXDWZT
wKQ8cKSz1WhDmOaCbgch8coYIvqbDocDcosknPbIbkZQIyS/FlF1QcrttFg1dz1z
ptmP5zpFQNknsy+GthmiFrn/aYa2Bmpz9J7ckzbjM+T9xPSNtw7X9aHUeeockZrl
zJteMGHzNf3Rw5StbZzMdhof47sGUOQ4EHPZcmQPGkeNy/n5l++HpLF4zEuzChuS
WOiTDAhNFuhcecDTWiE34v401nLfaUfEJUr/ldw5dIu7otnxwMPpKCTi/ofc1mu3
tdRPZO3UxFa5HePOncRMjV+u93PChYK0SarLy4bKeAIA51ffeLvmQIwYDjVLxNyp
svkwTbskU8KA5iElQG8xD8YWJl1GtRWnI78kFtkhVhtHWFSLEvumZmi2ADt4zBeP
kXA8w/7ofsaVPd9hNYVo73+xU0LgGR3sc6GZUz147CJ28JPq3oqK5oIIVRhc37EZ
oTmBm1OlEGywqqhXJxGyXC4KIPuM+UQ2mksc+IudgoN5BT6tYRf9m7KpQGjovZiq
7jiAU07SZ+upBGwvFOu8FnEyqdYeAZPl0JMaMim3JI7+djVdp4gj06lldmcaakRf
YuVAEz7RLWc8iLqNAzGa
=jKm7
-----END PGP SIGNATURE-----

--YI/KIGiRofOEmDiH--
