Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaBMT31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:29:27 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42975 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaBMT2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:28:43 -0500
Date: Thu, 13 Feb 2014 19:07:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
Message-ID: <20140213190730.GB28112@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-8-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JSPlny27wWFXU/ig"
Content-Disposition: inline
In-Reply-To: <1392282847-25444-8-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 07/14] regulator: s2mps11: Copy supported regulators
 from initconst
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JSPlny27wWFXU/ig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 10:14:00AM +0100, Krzysztof Kozlowski wrote:

> -	for (i = 0; i < S2MPS11_REGULATOR_CNT; i++)
> +	s2mps11->rdev = devm_kzalloc(&pdev->dev,
> +			sizeof(*s2mps11->rdev)*rdev_num, GFP_KERNEL);
> +	if (!s2mps11->rdev)
> +		return -ENOMEM;

If we're using managed allocations do we actually need to keep the rdev
table at all?  We only normally use it to free.

> +	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata)*rdev_num, GFP_KERNEL);
> +	if (!rdata)
> +		return -ENOMEM;
> +

> +	/* rdata was needed only for of_regulator_match() during probe */
> +	if (rdata)
> +		devm_kfree(&pdev->dev, rdata);
> +

If this is always going to be freed within the probe path (in the same
function indeed) why is it a managed allocaton at all?

--JSPlny27wWFXU/ig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/RfvAAoJELSic+t+oim9WbkP/RlkJ7EQw2+eNFL32x5YCjra
QBU8N3GmiF43anP7q8lV8k93HXK5ZxlJesd+odTDAdsjA4lt6+wP4zuLjDfFKvSP
DI5RqjjbA7bvDxdVmiSfHtah1d9VQ7ewz6VlvFaDFavawvmg8WjvdO5L32aqdg67
I5FHqLXhvtZsHNOEKC9gZPk7k7FkjvHfx1aCARkaezvjUiRcWZIoQzQgi6IPen3y
2rVxrcoZNKF3gCLarcIr297pOAB9MOOIJL/OdbgWYzOBBibeMuBrFsx6cvGlwmFr
m9rqRxpxGt2yX4OAYyv8zVGqVf5pDO703Wkch9uSVDv+QnvuwkvW+UROjJXj9TUt
dHIwF9NI6G0QE0rYdVlncR4OASs9NgDtfZZvSxHy9nE6AA2EyNzZz189gJY9PVjD
mt05VH2x8rutnkNFNysL2U4Fqx2h+MQYKUFwZhXrMfnGx6QriP2KgIVV9hmZ0Inz
JQpb79uxW6WBRWbkv6Qj3ymw64s47bopPXAYp8Mmk5r4omApc4rLpzeLHNX4hAJq
Pa7szTKfLNTc+QHH7QfH3/pKNVFeBDHXru5zg8QPmT6sre/z++ntuL+JEHFeSehp
bFHvo2XxqvmBP55HcmRSMXHXha9G5MzKLFKrt3qdMeQE8hFkn9llrXLcKZPjmA5N
LGv89444Dk9BfdmTIW/4
=pS+i
-----END PGP SIGNATURE-----

--JSPlny27wWFXU/ig--
