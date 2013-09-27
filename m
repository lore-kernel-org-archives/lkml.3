Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3I0TWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:22:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44904 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3I0TWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:22:43 -0400
Date: Fri, 27 Sep 2013 20:22:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20130927192233.GN19304@sirena.org.uk>
References: <1380292469-17347-1-git-send-email-lars@metafoo.de>
 <20130927183456.GM19304@sirena.org.uk>
 <5245D2A0.4090909@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OE5XN2KVoD5QaTkR"
Content-Disposition: inline
In-Reply-To: <5245D2A0.4090909@metafoo.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: Add a spi_w8r16be() helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OE5XN2KVoD5QaTkR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2013 at 08:46:56PM +0200, Lars-Peter Clausen wrote:

> According to the documentation of spi_w8r16() it is a feature.

> 	* The number is returned in wire-order, which is at least sometimes
>  	* big-endian.

Indeed.  I don't think that's terribly well thought through though,
especially not now we have annotations for endianness (as you noticed!).

> There seem to be at least two users though which assume that the result is
> in native endianness drivers/hwmon/ads7871.c and drivers/mfd/stmpe-spi.c

Yeah, I saw.  The ads7871 is just going to break when run on the
opposite endianness to the one it was (hopefully) tested on since it
doesn't make any effort I saw to cope with endianness.  Looking at the
history it's not terribly obvious which that was but it'd be surprising
to see a little endian register...

STMPE is doing a byte swap so it's another user for your function -
it's for ARM systems so it'll be assuming that little endian is the
native format.

--OE5XN2KVoD5QaTkR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRdr1AAoJELSic+t+oim9PG8P/0UKnEJ+rkGxtGoV5ZnwJF2p
peYcJ8hOsEcuo+ZY4U7anWZ4vN3igH5XCCapKK5D5Aw4hf6PwZEqdeYo43ZYlwkD
Q+65VDp1A8QyAJgQPnyBINZDwYZV4YEMkOSX5mbqrcOU1slIM3l5L2BJ0rF9jKvT
NXUX7dzv1i+CVK6LkpVwTgboE+li8vtIqb7HdU5aQUDgJWKHGv/oNLW5ooNi+1I3
t99iH/zUCjqLoM9P0T6RBisL6VOqMDM/OK6cqkcIsm83eeC0YGqcDlYc/RIi4GAT
eaTVc5IRdPOLarL7YOFNId5p4+4q5Qoommyb51UKXsOmJIhM2dKUdo2OIwmRF7B5
LeqzeuXktCtRUJQ5Qtx6u/FRBMI/Hs2Zt2G+97dPa5RLvBWqnc/sQ7+kowUWjiQt
1aCQ+y9pUbQQlmlLtpflidR9yvK9UacxCaqpEJl8gErl3FrcdInvx5waX9gBYdvC
isBVVQjJKOYLNzyO1DvxLEQDgZXDtfgGQvgwvoCnykqrtw/xkgEt4eMqtolhyerB
fkdpVcK60dqHW3D/VKeXhyr+AhY/1KeSHHtMMnqqsUp0I0oDDyqCKy5RnjYf4qpN
al2eToBPtXe8iJtRiod7nVhLBJTa44BhGk5UZWy6QIJT0imthvd+SLAScUVR3lDf
Gg3Wc6jxbVlGAr+ygdUM
=cA06
-----END PGP SIGNATURE-----

--OE5XN2KVoD5QaTkR--
