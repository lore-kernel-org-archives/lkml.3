Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3ISOuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:50:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51434 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3ISOuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:50:11 -0400
Date: Thu, 19 Sep 2013 15:50:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, swarren@nvidia.com
Message-ID: <20130919145001.GD21013@sirena.org.uk>
References: <1379601988-25839-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPyQn7mfIBXOql8K"
Content-Disposition: inline
In-Reply-To: <1379601988-25839-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: set current constraints while setting
 machine constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPyQn7mfIBXOql8K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 19, 2013 at 08:16:28PM +0530, Laxman Dewangan wrote:

> +	if (!rdev->desc->ops->set_current_limit ||
> +			!rdev->desc->ops->get_current_limit)
> +		return 0;
> +

The indentation here is odd and we probably ought to complain if someone
tries to set a current constarint on a regulator that doesn't support
the operation, if only to avoid surprises later on when the limits don't
take effect.

> +	current_uA = rdev->desc->ops->get_current_limit(rdev);
> +	if (current_uA < rdev->constraints->min_uA ||
> +			current_uA > rdev->constraints->max_uA) {
> +		ret = rdev->desc->ops->set_current_limit(rdev,
> +				rdev->constraints->min_uA,
> +				rdev->constraints->max_uA);
> +		if (ret < 0) {
> +			rdev_err(rdev,
> +				"Failed to set current constraint, %d\n", ret);
> +			return ret;
> +		}

Why is this conditional on the existing setting?  Just apply the
constraint.

> +	}
> +	return 0;

Missing blank.

--ZPyQn7mfIBXOql8K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOw8WAAoJELSic+t+oim95TYP/A003HgFSsMeiT5JbZ28OGlf
6wxQJZrg4OhBLwgg2jYexZdicusISOD6zx6S379tyrAjPa/k8rru5fhZsSSgwWZV
RBJTjb7VCyvDj9CaR/A7FsZiZFHxvdTZSqZmcQHjkQYYpGPAirJr5OdKShdh8Jvo
sJQUhw3cusfHERWWa23MtawJfa8vSZYLOJqQBTL4vRlTlgYqst/acVWlqGd+/rOl
qQru3uOyo6tqNBU/dl4T4q9FdCvAUsjThiPlyszTyehsmAHp6WhAMIsCz9vlCnDD
iZf5dYRMn2TxdWF0G1gZj6ZuNKsRODuXFWk6w+NklV0aI+4inGlh+zWMPiynUgB3
+xN0LGu2HPbQInwMlOa+whRw4OrkZytcluTSFyHAQWPKIGlcxmJy2Umns8raRKoI
a7bCBRZdiT+60yvG01LsCJRa/wmcI8VpJ0PlzIxBY/RYqj6NcxReIUIN2OFJPB+V
mUDuKdBjfHGxCI5kmhQxgZWnEluri9fpcLUls+ZqU4g6tvDl2KMbIXyLpkWm4e1J
DG8uDEOyB401fAIxWT0NGoQBSrjcOFB4BvPbRoJ/XiXOQK9c0MRJtO2bCRnPjkMH
WW0F+hG9UGA1h8M7p0ILpNxcDUBI1d/1wlZbXXEfFfMC/zOoENjdAOofAcGFl24H
BADavOzUEKndQPtzHoiw
=hU4Y
-----END PGP SIGNATURE-----

--ZPyQn7mfIBXOql8K--
