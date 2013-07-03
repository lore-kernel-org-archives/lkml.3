Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3GCSBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:01:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60253 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3GCSA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:00:59 -0400
Date: Wed, 3 Jul 2013 19:00:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, yadi.brar01@gmail.com, sbkim73@samsung.com,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org
Message-ID: <20130703180033.GX27646@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
 <1372072858-6559-5-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/GLpYSe53BI9iu8K"
Content-Disposition: inline
In-Reply-To: <1372072858-6559-5-git-send-email-yadi.brar@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] regulator: s2mps11: Add device tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/GLpYSe53BI9iu8K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 04:50:58PM +0530, Yadwinder Singh Brar wrote:

> +static void s2mps11_pmic_parse_dt(struct of_regulator_match *rdata,
> +					struct s2mps11_info *s2mps11)
> +{
> +	if (!of_find_property(rdata[S2MPS11_BUCK2].of_node,
> +				"regulator-ramp-disable", NULL))
> +		s2mps11->buck2_ramp = true;

This property should be specific to this binding rather than named as a
generic regulator property.  It's also a bit odd that setting a property
called "regulator-ramp-disable" causes the flag buckN_ramp to be set to
true - if the ramp is being disabled I'd expect a flag with that name to
be false not true.  Seems something isn't named right.

--/GLpYSe53BI9iu8K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1Ga+AAoJELSic+t+oim9mI8P/3vMUg4sXyss8yVmG+cBUnwK
rkqS1pbOzYvDI/ly34i6WogVTaLNpwRrPKKeJlxl54YCULilyfaYZpGR2LVujANf
nRyh0pxfOVahZizWDKnqoJas8SUx9z97eJMezpEw9WvJxmbsOjilkQUwPWCYH5up
1W+3WRHB60hVer28lTZoj/hudva8yJxncAIHyM87z9gqWwEjXfdo8zcxnq5nZHyU
dPTl4xkaYxJEjSzXnuB6tgm/a8imfBXpzUDgImh4LSNPeYGvBNlMKTkMNfhAb8i8
TzzCm020E34y34QWkPL1V3aNqLLco7sb0xrbLVECfw75YSDSijLioXfKhFceT1Gr
LBw/cxNiwqpK5zHSnP16EiVU3sT6GJpphy/MokzLTBcwwmzKoZRb/gi5GEJZJfRl
Clhlfpnv8+Yx6cqvCMSHS8S0vhkVxOSailOW4N+1hfJrWN1w+WG9g4aVprex0kpA
aDeM2Vmi1hPvo6v2ULpJHoitMnazlfqXxrhxaG3++aFiesWGvqeiAQnb6Us07tl8
Ht7WM3U+6tVRAJwBrODmc/wqle9XgpINmbIYmPgLPU8fRao5vCFYwVA/vl79esw4
qGq/VOo7nz44TIPyzcVoM6oo1H9AayjBOTNrq2VpOTuBi761ZPa6PrWUnmh/M9CQ
P3FA/bfsN+cP3GPOCuI0
=nD+7
-----END PGP SIGNATURE-----

--/GLpYSe53BI9iu8K--
