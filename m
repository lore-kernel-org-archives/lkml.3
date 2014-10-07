Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaJGJKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:10:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56558 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaJGJKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:10:50 -0400
Date: Tue, 7 Oct 2014 11:10:41 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, kernel@pengutronix.de,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] regulator: Set ena_gpio_valid in regulator drivers
Message-ID: <20141007091041.GD5042@pengutronix.de>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-3-git-send-email-mpa@pengutronix.de>
 <5433A863.1040206@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
In-Reply-To: <5433A863.1040206@samsung.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:07:37 up 27 days,  1:55, 91 users,  load average: 0.10, 0.22,
 0.21
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 10:46:27AM +0200, Krzysztof Koz=C5=82owski wrote:
> On 06.10.2014 22:17, Markus Pargmann wrote:
> >This patch sets the new field ena_gpio_valid for all drivers which set a
> >valid ena_gpio.
> >
> >Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> >---
>=20
> (... looking only on s2m/s5m drivers)
>=20
> >diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> >index b16c53a8272f..4d78477b9f57 100644
> >--- a/drivers/regulator/s2mps11.c
> >+++ b/drivers/regulator/s2mps11.c
> >@@ -986,6 +986,7 @@ common_reg:
> >  			config.of_node =3D rdata[i].of_node;
> >  		}
> >  		config.ena_gpio =3D s2mps11->ext_control_gpio[i];
> >+		config.ena_gpio_valid =3D true;
>=20
> This way you'll mark all regulators as GPIO enabled. This is won't
> produce an error (ena_gpio is initialized to -EINVAL by default) but
> I think it is misuse of the idea "ena_gpio_valid".
>=20
> Instead maybe:
> +		if (gpio_is_valid(s2mps11->ext_control_gpio[i]))
> +			config.ena_gpio_valid =3D true;
> ?

The regulator core also checks if the gpio is valid. Perhaps the name
'ena_gpio_valid' is a bit confusing here.
But yes, it may be better to check gpio_is_valid here to see if
there is an actual valid gpio.

Thanks,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUM64RAAoJEEpcgKtcEGQQB+MP/18yOB4sNRk9RG1MEgs2GM1u
ESYDWYUdYHzKeEfdhNGB2DpzADwplAUKmM2Jcj0ezs8WDoS4j8zDST2bFOEKnERx
8RX5VpLcgNHDeETDQhHvQIQbK7XgM5wgPvBiDWM5xPgg/bfBr6Qz4KryAjtIwnTW
s2XLqwDokOuR5Oj8lGnxE9mC0SQ8VnUSwZwr2czZBa9D9az5xldiGXYl+UBOp6F/
3sGlF9u0r1n+xeESq4L4xLQh/tUEHYXCfqp0WVmuEg8EWDQJWBh93922PuwPK0Qi
eS1YOEI0dNWze2tdANaB2aA1qQnCqhxOzMEzCNqQCHtX6tJ61f+jMSsYgqv9Bx+4
SsDGnvThCnk9M5lL4uSPxEgAFqiNElk6MkrHX0HXGzm/rG6V66trEbphwm1H8eRI
8uPyiL1d7NMNMOx9C1aHrfL+DcohENkYQcKPhkrPm2vfj0rk77PN12K4F9f1qOE6
LNXvTdy9PQb617Y+nUQVUj86qUpegnXXT54gIWJtbdVIOmyNSQVOUC4B/+HABls5
2XA1MM2Np5XMgrQyGmf6O3PvEFWfPuQ/AjaYlfLoXQ67zwFXdIKuKI+W2oNjH+Bt
enBTvW+pxEWNOACU6IScYiI0cack3KaZS2s6V4joBBGmN41gVAPcjTMGNrp70egv
UhbXH9tk9pWiEa6IWIbz
=hXKh
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
