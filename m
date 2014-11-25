Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaKYVQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:16:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38561 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaKYVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:16:37 -0500
Date: Tue, 25 Nov 2014 21:14:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20141125211431.GP7712@sirena.org.uk>
References: <5474E91E.6000401@metafoo.de>
 <1416949399-29718-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GrAAUVrjkPOLxTcM"
Content-Disposition: inline
In-Reply-To: <1416949399-29718-1-git-send-email-olof@lixom.net>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: provide dummy regmap_exit()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GrAAUVrjkPOLxTcM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 01:03:19PM -0800, Olof Johansson wrote:
> Fixes build error:
>=20
> sound/soc/soc-core.c: In function 'snd_soc_component_exit_regmap':
> sound/soc/soc-core.c:2644:2: error: implicit declaration of function 'reg=
map_exit' [-Werror=3Dimplicit-function-declaration]
>   regmap_exit(component->regmap);

In which configuration?

> Due to the other regmap functions providing appropriate stubs when
> !CONFIG_REGMAP, but this one is missing. Add it.

Be careful on this one, you'll notice that the matching creation
functions *aren't* stubbed since there is no way to reference them
without an active dependency on regmap and indeed this use is a bit
dodgy since the core ends up freeing something that a driver allocated
which isn't ideal but probably is OK due to the general horrificness of
the AC'97 device model integration.  We only stub functions that generic
code might have a sensible reason to use in order to make it less faff
to provide generic helpers for things. =20

I'll tweak the commit message when applying.

--GrAAUVrjkPOLxTcM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdPE2AAoJECTWi3JdVIfQVzAH/08WMIkEKPYyPHqKOkb1cnsX
ZIEyZmt3n0i6fOEFrmqJf7chuVbH3yG111t8u7HKsT09xgoiTqtc/iHiP5mtKUwW
0jYL7rsxAfsF4MFejdttx7Nk+c8F8gSv9+oKGsGNxwe9zIUTV68h56rzSPXA6F4v
aY5s4bt/pURxZ6sAZS8K/SSC12TnatT5xJcyYpysVz45WbvqAm+TZiwM+BTkUYZc
ZNgWPXhusiLNTrVUtfupxr6l+dmvhl2Y7bMYeE+TOSOYzIic9xZjp4KE48fBzrTW
BrnRYtpeG/uBmg3HK2Zc+n2VoCRfaA3ZsooivRS23fs/e76CuXWMRgAcYUYKKbk=
=0y58
-----END PGP SIGNATURE-----

--GrAAUVrjkPOLxTcM--
