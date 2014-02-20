Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaBTNBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:01:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51232 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaBTNBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:01:14 -0500
Date: Thu, 20 Feb 2014 14:01:08 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: core: Replace direct ops->disable usage
Message-ID: <20140220130108.GD21048@pengutronix.de>
References: <1392894472-11956-1-git-send-email-mpa@pengutronix.de>
 <1392894472-11956-3-git-send-email-mpa@pengutronix.de>
 <20140220125130.GQ2669@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DrWhICOqskFTAXiy"
Content-Disposition: inline
In-Reply-To: <20140220125130.GQ2669@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:55:59 up 179 days, 22:26, 54 users,  load average: 0.04, 0.08,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 09:51:30PM +0900, Mark Brown wrote:
> On Thu, Feb 20, 2014 at 12:07:52PM +0100, Markus Pargmann wrote:
>=20
> > --- a/drivers/regulator/core.c
> > +++ b/drivers/regulator/core.c
> > @@ -1908,8 +1908,6 @@ static int _regulator_do_disable(struct regulator=
_dev *rdev)
> > =20
> >  	trace_regulator_disable_complete(rdev_get_name(rdev));
> > =20
> > -	_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
> > -			     NULL);
> >  	return 0;
> >  }
> > =20
> > @@ -1933,6 +1931,8 @@ static int _regulator_disable(struct regulator_de=
v *rdev)
> >  				rdev_err(rdev, "failed to disable\n");
> >  				return ret;
> >  			}
> > +			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
> > +					NULL);
> >  		}
> > =20
> >  		rdev->use_count =3D 0;
>=20
> This change doesn't seem obviously related?

I am using this function from _regulator_force_disable(), which calls
_notifier_call_chain() with one additional flag
"REGULATOR_EVENT_FORCE_DISABLE". To prevent calling
_notifier_call_chain() twice for the force_disable case, I moved that
function call out of _regulator_do_disable().

Regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--DrWhICOqskFTAXiy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTBfyTAAoJEEpcgKtcEGQQbzAP/is4lFFNEBIsEaaQKt4lByP2
pew2oXFuRCbqQq3ik5lvwNCXcRRKMXCFXvbpVP0Tfe6SPbMDJ3ZEGI9J+mKAFQmh
WRCJwPXciaLXENmKorr6580DNgcThBZ8pwYfvlKATgUVa9p5l841cPnvwXAjDGMo
g6blGvZmJrKduv887bidxP7lXHAQTiqss+VV0TFqOIwoeJsSjIkIIfTlkCBJtUv7
kGrDce+kj2xspuRSwMGtmkRj7aUKXiQyiyRxOtHtQciVu/pRiaW/treRlBTvAfQs
cDqJcl4kGICcXCNnM44pqzPTmDsYrCUZb8FOvEAv0rAz5rbadqLDLBzaH9X7LhRE
o/c/A1gbOvww1CvFb/bEKmvcEpGustswJZFJpW23mpT9lZXGOnuDQCuq1kGkVFqS
QeLKA2BmfA7MBbglkOxye2XZwRjQOcAJ4Y9GZZnPBcrsqpQR5rnhnghFtKK4Hoza
3uJImmnSOBXUUaRvkUpDS6CtE3NLQI2cR1dq1CJqoySq/4XbuKru6kDc0tqvg5zt
m8wcNHfWLgobeY+2fpFHd3swW0n1TtOFMpafRMZoA5qLqwIWMM+JPrgqhJ/J7a7F
2oyfyBQrrpCSYoanAC5F5wTXA2+XYu1Gcs6zdEQzndx/F0zmRIYlASbhQZlRYJ9h
KsjEAJH5sHRMritteajy
=hTFt
-----END PGP SIGNATURE-----

--DrWhICOqskFTAXiy--
