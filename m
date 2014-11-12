Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaKLLhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:37:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34775 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKLLhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:37:08 -0500
Date: Wed, 12 Nov 2014 11:35:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20141112113541.GD3815@sirena.org.uk>
References: <20141112111835.GA12635@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DcG5MYjlKYity2pa"
Content-Disposition: inline
In-Reply-To: <20141112111835.GA12635@opensource.wolfsonmicro.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: export function to check if regulator
 always on
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DcG5MYjlKYity2pa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 11:18:35AM +0000, Richard Fitzgerald wrote:
> Export a function to allow a consumer to check if its supply
> regulator is always on. Drivers might wish to take different
> action based on this - for example skipping time-consuming
> power-saving preparations that are irrelevant if the regulator
> cannot be disabled.

I'd like to see a user here, and I'd also like to understand why this is
a better approach than using a callback to postpone these expensive
operations until the regulator is actually powered off like we already
do for some things like register cache resyncs.  That is normally better
since it also avoids the work in cases where the regulator isn't always
on like reenabling during a delayed powerdown or shared regulators.

You're also missing a !CONFIG_REGULATOR stub.

--DcG5MYjlKYity2pa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUY0YMAAoJECTWi3JdVIfQIcAH/0ddT94YGL8VD4Dq1ylRTLo1
j1Q16cE6pGG1mI97OeZGprSNK6I/XGU4z5d+g54Au1gImAF2HQ4DFMk/Ih4HozHl
1DVFH9dYh9OC+p3F0At6AxQ74J3Xzbx3O5Z3PSSiunMh8aqapsvHVqrefDNUbkNy
YAjMuar8078ceNss1WBLJ/8LGUE6DJWBTuWaKpwivFA+VIaccYPqGwzdwHPrsH32
wc/DWWs6qGiMXVKmQZi8gsJqJdpKiUG5sv+BnslIASO4l/l0ICr3CC1c0xXZypgp
xDrYsn5lvXgtYrYPETSRfWuO0POMbFT6Q4jlG5Q6zGiTcKFfTRB+RJ/7s6FG/DM=
=CiqT
-----END PGP SIGNATURE-----

--DcG5MYjlKYity2pa--
