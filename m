Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaJGJOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:14:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53051 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaJGJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:14:49 -0400
Date: Tue, 7 Oct 2014 11:14:41 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, kernel@pengutronix.de,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] regulator: Remove unnecessary ena_gpio
 initializations
Message-ID: <20141007091441.GE5042@pengutronix.de>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-6-git-send-email-mpa@pengutronix.de>
 <5433A9CD.8090007@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline
In-Reply-To: <5433A9CD.8090007@samsung.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:12:56 up 27 days,  2:00, 91 users,  load average: 0.38, 0.32,
 0.25
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 10:52:29AM +0200, Krzysztof Koz=C5=82owski wrote:
> On 06.10.2014 22:17, Markus Pargmann wrote:
> >It is not necessary to setup config.ena_gpio with -EINVAL or similar.
> >This patch removes these unnecessary initializations.
> >
> >Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> >---
> >  drivers/regulator/pfuze100-regulator.c | 1 -
> >  drivers/regulator/s5m8767.c            | 2 --
> >  2 files changed, 3 deletions(-)
> >
> >diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/=
pfuze100-regulator.c
> >index c879dff597ee..d7455ee309bf 100644
> >--- a/drivers/regulator/pfuze100-regulator.c
> >+++ b/drivers/regulator/pfuze100-regulator.c
> >@@ -509,7 +509,6 @@ static int pfuze100_regulator_probe(struct i2c_clien=
t *client,
> >  		config.init_data =3D init_data;
> >  		config.driver_data =3D pfuze_chip;
> >  		config.of_node =3D match_of_node(i);
> >-		config.ena_gpio =3D -EINVAL;
> >
> >  		pfuze_chip->regulators[i] =3D
> >  			devm_regulator_register(&client->dev, desc, &config);
> >diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
> >index d258e6613831..2c7817f12516 100644
> >--- a/drivers/regulator/s5m8767.c
> >+++ b/drivers/regulator/s5m8767.c
> >@@ -949,8 +949,6 @@ static int s5m8767_pmic_probe(struct platform_device=
 *pdev)
> >  		config.driver_data =3D s5m8767;
> >  		config.regmap =3D iodev->regmap_pmic;
> >  		config.of_node =3D pdata->regulators[i].reg_node;
> >-		config.ena_gpio =3D -EINVAL;
> >-		config.ena_gpio_flags =3D 0;
> >  		if (gpio_is_valid(pdata->regulators[i].ext_control_gpio))
> >  			s5m8767_regulator_config_ext_control(s5m8767,
> >  					&pdata->regulators[i], &config);
>=20
> This would bring back problem with carried over ena_gpio (commit
> f4fbb3ce342bc1 "regulator: s5m8767: Fix carried over ena_gpio
> assignment").
>=20
> The "config" is re-used in loop for next regulators. This means that
> the "config.ena_gpio" has to be set here to prevent using the same
> value for next regulator.
>=20
> I think these lines shouldn't be removed.

Yes right, thanks.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUM68BAAoJEEpcgKtcEGQQml0QALB50ymWF6UR+7fbAtpKseg/
DxSZonhKr5Gq6Jpmow9+XQKLXwrPb6yEStTzczI9AYgD71BlWVn/JgkakqVxzAw4
NRAlHVQjPLavtAkXrOEic3sPpbq+UThlBPI/zO77Cim1KoG4UVhltakSW0jWTrsG
2H6DMss58qSAvfJ7Z4nnjxMh7LEMCWIMu8K35g7QYDE6d15ZVqAJJq1kgTpCJMG7
4pcPe2QwQQFGjkEhw21hfEMXkbLk2qbKy+eM2M21sXT/AeA65cyDYxR9Z2r6pnRE
0CiaOrSCCjTdzI5TLzv9q3fPSsUIBP8WkOms2xRF87Vo9VsErriZtNIs51CHY+Tj
lsRHX19XUBWhrdjvuFrMtezOqZEndRkvgWrql+rY0H+Pg+R5SLzXUb5j68t4zbgz
9B1NORQgk6Cfx/IiSWQWD503hd3wx8juLNcgslD6/jip8Uy7VrxUV0FFhon5fVmT
JO02sl3q9sUQE9ov7uN2Wk68pfNTxi3fShnLI4m6Mi7boSLlIiPyF2koKG/78WOk
WCTg5Hq0QT6qMKUUWs4HVlLzGABBusKVj0OIgKZ2d97ZDQkrfeDDiXhUzEuegQXX
cfHKQMfPOL9OjIrIIRSYH9CQlkhs9Ly2hNp2KFw+L2SPl6MchiPZA+n76RUiT96M
PKorN6cSAJxT4hyStnum
=e4m+
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
