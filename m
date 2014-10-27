Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaJ0QnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:43:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44571 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaJ0QnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:43:06 -0400
Date: Mon, 27 Oct 2014 11:41:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lucas Stach <l.stach@pengutronix.de>
CC: Romain Perier <romain.perier@gmail.com>, <heiko@sntech.de>,
        <devicetree@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <johan@kernel.org>, <linux-pm@vger.kernel.org>, <linux@roeck-us.net>,
        <lee.jones@linaro.org>, <balbi@ti.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 06/10] mfd: tps65910: Use the standard DT property
 system-power-controller
Message-ID: <20141027164153.GE14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427215-14380-6-git-send-email-romain.perier@gmail.com>
 <1414427749.2421.5.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Content-Disposition: inline
In-Reply-To: <1414427749.2421.5.camel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 05:35:49PM +0100, Lucas Stach wrote:
> Am Montag, den 27.10.2014, 16:26 +0000 schrieb Romain Perier:
> > No longer use custom property to define poweroff capability, use the st=
andard
> > DT property instead.
> >=20
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > ---
> >  drivers/mfd/tps65910.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> > index 7612d89..a7faff2 100644
> > --- a/drivers/mfd/tps65910.c
> > +++ b/drivers/mfd/tps65910.c
> > @@ -423,8 +423,7 @@ static struct tps65910_board *tps65910_parse_dt(str=
uct i2c_client *client,
> > =20
> >  	board_info->irq =3D client->irq;
> >  	board_info->irq_base =3D -1;
> > -	board_info->pm_off =3D of_property_read_bool(np,
> > -			"ti,system-power-controller");
> > +	board_info->pm_off =3D of_is_system_power_controller();
> > =20
> >  	return board_info;
> >  }
> You are breaking compatibility with older DTs here. This is not
> acceptable.
>=20
> You may change all in-tree DTs to use the new property and also patch
> the driver to understand it, but you must make sure that the driver
> still understands the old, custom property. And especially in this case
> it isn't really hard to do.

correct, it should be simple to hide that under
of_is_system_power_controller() itself.

--=20
balbi

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnXRAAoJEIaOsuA1yqRERxwP/2AHly2pu7cXGX/fdKPI1ZjJ
Bre18GxheHs6Qbf8IeKoEV056oYPr6ylykY7nxIpC69UWAXqwv7Zf+e+dp406Wxg
XAFp86eg7WYKG4sIPN7+wcL1LggOuB4TD2IV8mEcW/4/0OdnEOWtGK6CNRJ0rqFA
wYR0Z4M+/2GuXYnqAhoTKoHuTILbTD1l4J6GivYxMNfV85MKqDyJ/h0V1jYe36cG
RVBZ0nOQNLzAdF33uhWWqDbVAr29YRmBAZfHbfrtid4pJOMwM2p0Nz03p810PK3R
uY7H32Bujz1GT7YtzqabPnsp9kvkwOLDe1p+PC42eeJn0xH/a5Q2OHhMfzOreHRc
0mf4auDW1sEFIH68jGnMej/PmBWU5U02Gyy9j9qqq/PH3LyV3gH/hxiOaj142SxY
MBCeweYwvTMGAgAmHNdL756J4ZtYMEVO2b+f414DpE4iv5H/JZgH9iZ6r4VsNZC5
hupblGqVLmXI63912c/kPZCb6zb4S8KOFHONY4v12OHEsxjZzUt48fY2F/QWB2pY
oHuWYCUotfdAb1/stExpFPKetRSIbzxavqNSfl/+uKkcGGF5lmL5nc9hScaCKfyR
eFMogl8hyJN8IoMd9ZnBgZTqroXeoegnhZebOQvQuNL3mfQDDVxi+nOEeqjhcDlo
jDG8J7j5ncALbqpkv6DF
=20yu
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--
