Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaBOKIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:08:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60439 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaBOKIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:08:37 -0500
Date: Fri, 14 Feb 2014 20:55:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20140214205532.GU4451@sirena.org.uk>
References: <1392359551-7170-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ivd6Nf4GAZ12BQqh"
Content-Disposition: inline
In-Reply-To: <1392359551-7170-1-git-send-email-milo.kim@ti.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 09/10] regulator: Add LM3631 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ivd6Nf4GAZ12BQqh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 03:32:31PM +0900, Milo Kim wrote:
> LM3631 regulator driver has 5 regulators.
> One boost output and four LDOs are used for the display module.
> Boost voltage is configurable but always on.
> Supported operations for LDOs are enabled/disabled and voltage change.

This looks basically good, a couple of minor nits below but nothing
substantial.

> +static const int lm3631_boost_vtbl[] = {
> +	4500000, 4550000, 4600000, 4650000, 4700000, 4750000, 4800000, 4850000,
> +	4900000, 4950000, 5000000, 5050000, 5100000, 5150000, 5200000, 5250000,
> +	5300000, 5350000, 5400000, 5450000, 5500000, 5550000, 5600000, 5650000,
> +	5700000, 5750000, 5800000, 5850000, 5900000, 5950000, 6000000, 6050000,
> +	6100000, 6150000, 6200000, 6250000, 6300000, 6350000,
> +};

This looks like a linear range so could use the linear range helpers
(4.5-6.35V in steps of 0.05V)?  Similarly for the LDO.

> +static struct of_regulator_match lm3631_regulator_matches[] = {
> +	{ .name = "vboost", .driver_data = (void *)LM3631_BOOST, },
> +	{ .name = "vcont",  .driver_data = (void *)LM3631_LDO_CONT, },
> +	{ .name = "voref",  .driver_data = (void *)LM3631_LDO_OREF, },
> +	{ .name = "vpos",   .driver_data = (void *)LM3631_LDO_POS,  },
> +	{ .name = "vneg",   .driver_data = (void *)LM3631_LDO_NEG,  },
> +};

These names don't correspond to what was in the binding document and
there's a couple of extra LDOs.

--Ivd6Nf4GAZ12BQqh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oLBAAoJELSic+t+oim9bFEP/jkCCe4C96CdrlH11eR62LDQ
mRTDjV0IOhDKDf1f1pARF2g/as6yneDUobCQL85TWGz88niKxPX3r0tR7MW4azvB
JfbVFkaX7HBTlkX4G6AdNMnngp9TTSxnosb36PvwycsAtdnqoy7Fbrgcsd9EsKHN
cYEx0vaEfe4cDZ9Fvqk0lTmWU64yF4gzbSf38du29lEFxoqRiW33WCLzQZB5AFhT
+ugmfJs7ay1beK424avu3pUsfUfJp5LeahYCVsO4CKZzacJor5ESNlSvThzBlDBR
eMvg2W1QCLPGfIkc+kq+CocLuVGG8hMNbJqsNHjysDYSKN0T9MD6WAfc3WoUD/dq
XZbHFbR6+0kIMKWCs6Q4eOMiunbn8u8XD947hkpAO1k4moVWzsjF1DFodAmhzNiB
zmqdaJ6RK1vgkOpR11Bg0pJ+m0xnYYSsH61Tabl34XRf8BTY2YpPZccmqzarbApv
j4hfDsxkw93vctx3i9VW11UwOiJKTn9zgzI1WkOxriwcT/FHUvgQlbnhXrfXCRYx
gcdDzBk+OKnIHVPNDH48y/2u5jBLUqIum6rEmCrEj9BG73MYVIacMJb1SDr8QSab
WeaQyrGB+us4/G/M4FkM7+yh6oM5DuewDJ8FzP4T52mdctMGEao0N2sesreJaeCq
jv9QCMRgqG6DIOhpzEGI
=yC7R
-----END PGP SIGNATURE-----

--Ivd6Nf4GAZ12BQqh--
