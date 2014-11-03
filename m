Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaKCNiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:38:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41001 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKCNiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:38:50 -0500
Date: Mon, 3 Nov 2014 14:38:40 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 3/4] regulator: fixed: Use gpio_is_valid
Message-ID: <20141103133840.GF24292@pengutronix.de>
References: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
 <1412776028-15655-4-git-send-email-mpa@pengutronix.de>
 <20141013144733.GK27755@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
Content-Disposition: inline
In-Reply-To: <20141013144733.GK27755@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:22:32 up 19 days, 36 min, 66 users,  load average: 0.00, 0.04,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2014 at 04:47:33PM +0200, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 03:47:07PM +0200, Markus Pargmann wrote:
> > Use gpio_is_valid instead of an explicit comparison with 0.
> >=20
> > Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> > ---
> >  drivers/regulator/fixed.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> > index 441a3e90e266..696f53cc1927 100644
> > --- a/drivers/regulator/fixed.c
> > +++ b/drivers/regulator/fixed.c
> > @@ -157,7 +157,7 @@ static int reg_fixed_voltage_probe(struct platform_=
device *pdev)
> > =20
> >  	drvdata->desc.fixed_uV =3D config->microvolts;
> > =20
> > -	if (config->gpio >=3D 0) {
> > +	if (gpio_is_valid(config->gpio)) {
>=20
> Have you audited all users to ensure that they don't rely on zero being
> ignored?  Right now we're sharing the core behaviour here so the same
> issues apply to this platform data as apply to the core.

For all other drivers this should be fine (just rechecked again). But
the fixed regulator driver patch has this problem.

Thanks,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUV4VfAAoJEEpcgKtcEGQQ9EIP/1ljheZLeWTmPnKP2rgLEY64
CTqcha2eBQoFGMRKszgxiKP6x6px3G9DofmjNZNZvPb5kLdTvcR/iw5rP5FqS4FW
2NayBqvZFbkoZ6XXtYd4ocQw/7mPXbM2cNUnnhCuX6A94I3iHK240XKg0EUh6IDA
k80lmwzaCmxxlicCG6CQYniBfquvfdyNm+HajUjQF4JgI1qBcsmz/gKOViSsyt5l
f3FZy8JzcNV9BegS6TxatgFMW3MaVuRf1T0S8iqIALZZYjpFnPtKB8+rSnN+QuA9
Iz63E2SS9KOwaN3Hw6vwcoC1xuuB8aSogUl6tgcF3KdxaZ3R75WOgzdRUfyFJF/2
V2OjpKNGIwpu0NKsbEcJ/mOYZu9h6t/3RB04pFJR0QlF2FvKDEYWpTFCC49UOB7s
0hpL2Ia8mOD3y1hp+5M0Y9d7x6olnXDHPS3HhQhjAep0JnRKa+JRNA97Og39mz2n
ouj/l110ZEbeUcrhu8xc4zW248Wzlxn2+W60Uzod6yGKwKOaH+w2xGgoZgvtDGnY
Vs4ARChuZw/Ua0rJ3kp5uPTrfy0zOEfW8Ev94J5Aay73HoPCt5l0rCaM+Mohl5Jv
gAfooiHIAPiW2zJxNXzXK31iI+6S/3WlKh9qjaYf+rpRqmotB0E+BQ7GvhFLKKFe
4ChXkZItEcY6mt59glum
=MlVs
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
