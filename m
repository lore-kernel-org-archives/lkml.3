Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaJMOr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:47:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51162 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaJMOr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:47:58 -0400
Date: Mon, 13 Oct 2014 16:47:33 +0200
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Message-ID: <20141013144733.GK27755@sirena.org.uk>
References: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
 <1412776028-15655-4-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BvhWI31Ceb2Zf+Ez"
Content-Disposition: inline
In-Reply-To: <1412776028-15655-4-git-send-email-mpa@pengutronix.de>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/4] regulator: fixed: Use gpio_is_valid
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BvhWI31Ceb2Zf+Ez
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 03:47:07PM +0200, Markus Pargmann wrote:
> Use gpio_is_valid instead of an explicit comparison with 0.
>=20
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> ---
>  drivers/regulator/fixed.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index 441a3e90e266..696f53cc1927 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -157,7 +157,7 @@ static int reg_fixed_voltage_probe(struct platform_de=
vice *pdev)
> =20
>  	drvdata->desc.fixed_uV =3D config->microvolts;
> =20
> -	if (config->gpio >=3D 0) {
> +	if (gpio_is_valid(config->gpio)) {

Have you audited all users to ensure that they don't rely on zero being
ignored?  Right now we're sharing the core behaviour here so the same
issues apply to this platform data as apply to the core.

--BvhWI31Ceb2Zf+Ez
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO+YFAAoJECTWi3JdVIfQf8AH/26RW/CSFmboS1Pohd+O0JRS
2Tr2Jly2zMrb5EjtIGrApys+VJlCZTwPCyxY2ZxMNrwGR+UNXOAx9VNRssVaIiA9
5W7GgA9dRHKMfImt5/9cljbEPa8KINVZAtlbXQR2l/bQG90cb89ba9d4Vh7Zh7vk
WtZTbYCyxYImvzsokFuCQzd5JGVBoXMPrTD9tVtbBy+aLvKyp1kI66e/q76QTRAf
74C9zX0OLAjPMSBgR2+QfRLc1NoYpx6+dbtNY6rOCjyKITugapwDn/nSoQ/NOEFR
qHGD8/J1wfS/T8AMo93wDM1CFnI9x39T2yENYpaUlYhrXxXwtcDwJQulT9m5CSw=
=mS/J
-----END PGP SIGNATURE-----

--BvhWI31Ceb2Zf+Ez--
