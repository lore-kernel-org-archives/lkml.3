Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaA0ADH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:03:07 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59831 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaA0ADE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:03:04 -0500
Date: Mon, 27 Jan 2014 00:03:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Manish Badarkhe <badarkhe.manish@gmail.com>, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140127000300.GR11727@sirena.org.uk>
References: <1390673154-15839-1-git-send-email-badarkhe.manish@gmail.com>
 <20140126213653.GB18840@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1pyOwMoA9G3DWfK"
Content-Disposition: inline
In-Reply-To: <20140126213653.GB18840@core.coreip.homeip.net>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: fixed: Use devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1pyOwMoA9G3DWfK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 01:36:53PM -0800, Dmitry Torokhov wrote:
> On Sat, Jan 25, 2014 at 11:35:54PM +0530, Manish Badarkhe wrote:

> > Use "devm_regulator_register" instead of "regulator_register"
> > which simplifies the code.

> ... and also breaks the driver: now you are freeing desc->name and
> desc->supply_name while regulator structures are still alive and can be
> referenced from its sysfs attributes, etc.

Yup, they need to be converted to managed allocations too if the
regulator_register() is going to be converted (see previous discussions
on similar patches).  It would be good to do so.

--X1pyOwMoA9G3DWfK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5aIxAAoJELSic+t+oim92QsP/0NPhMMAgwoVcy4afvg8XV10
J/PWI+Kc/vOpJVjP5hMYZmijtKA/YvaD8tOuZ0afKXehdt8oOOzXpK8zlSV3FDsm
W0ZnS6ojtEjJ5t2teVexrBpGaA/kUK9hsQ12nu6aBEDU9Lup/aSn6BKMglEw+zzw
Y9YqkiqOLczpsjvUx6zV/gFuRhW4NOWTJwWfHlwJlCpqMM1aA70AYwGTvRVoRoBM
yjy5I5mc7mbeEjXCNi6Uoh+SldBMGeGskF8DhcKlIod1oUh2HjMR6HemD5YDtrDb
uQdbTXqvCIohbytEvE8vX55BbDQB8Hf9FBNGn5qV1FQ3ZIAMcZJaIpl7ZZ/pGbzp
40CIYZU3y8MqWpk7ePr62fkJj5USylxCytKpjSSFpkNCYW6/eC08rJUd0DO73FbE
E+lm+32nIUArgsp6I8Hrh/NZkBqZjLLAegwNH0fkBgIwBdynGMJyvm0HZcUv7jZE
ZJcxEKL6BqjO54APojRoyL/Qw0vkrkdwahX1/n4t566s+0/uBachRYOkbMYzh+Yi
YTyxYQxUsYjzLlXsAztNpCvWucVuQZKo5HGCiz+IfK4oA73FxRUM/JPssMUXSvey
m7Dx2+pJMsQMEtcXMaqHXGO4x6IZA7qNYUH+MuY3lbmFfYGbNxkO0JLC6nfiNxTA
Z50ZbRQceqBSSN6Pb3d6
=2z/J
-----END PGP SIGNATURE-----

--X1pyOwMoA9G3DWfK--
