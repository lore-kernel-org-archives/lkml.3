Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab3HBJTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:19:35 -0400
Received: from up.free-electrons.com ([94.23.35.102]:58512 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758253Ab3HBJTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:19:31 -0400
Date: Fri, 2 Aug 2013 11:19:26 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: plagnioj@jcrosoft.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com, Thomas Petazzoni <thomas@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCHv3 1/3] video: mxsfb: fix color settings for 18bit data
 bus and 32bpp
Message-ID: <20130802091926.GR2911@lukather>
References: <1375346437-18991-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375346437-18991-2-git-send-email-maxime.ripard@free-electrons.com>
 <51FB6F51.7090500@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AonAANj1daC6QcQu"
Content-Disposition: inline
In-Reply-To: <51FB6F51.7090500@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AonAANj1daC6QcQu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 02, 2013 at 11:35:29AM +0300, Tomi Valkeinen wrote:
> On 01/08/13 11:40, Maxime Ripard wrote:
> > From: Hector Palacios <hector.palacios@digi.com>
> >=20
> > For a combination of 18bit LCD data bus width and a color
> > mode of 32bpp, the driver was setting the color mapping to
> > rgb666, which is wrong, as the color in memory realy has an
> > rgb888 layout.
> >=20
> > This patch also removes the setting of flag CTRL_DF24 that
> > makes the driver dimiss the upper 2 bits when handling 32/24bpp
> > colors in a diplay with 18bit data bus width. This flag made
> > true color images display wrong in such configurations.
> >=20
> > Finally, the color mapping rgb666 has also been removed as nobody
> > is using it and high level applications like Qt5 cannot work
> > with it either.
> >=20
> > Reference: https://lkml.org/lkml/2013/5/23/220
> > Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> > Acked-by: Juergen Beisert <jbe@pengutronix.de>
> > Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/video/mxsfb.c | 26 --------------------------
> >  1 file changed, 26 deletions(-)
>=20
> This one is labeled as "fix". Should it got to v3.11?

It would be better yes. Otherwise, 3.12 will do.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--AonAANj1daC6QcQu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+3mdAAoJEBx+YmzsjxAg8TgP/RFm7buWsIYEep+d2LCo8wok
oJGE5ibDdMr8zzJP1ekUE12WBF7vYsuZfR1h7LTYJcnVBSa3oc8QYIbWwlkvzJeR
K5wojui/WjJMecJyQ5D3ZqUGx7KXLbZjva0HNDceIpW5RDWNaJgQPBCmES4VcrSd
mY81nD+0+i86HB2kdSX7OXQYyEcVbMaUbyrfVSyRSed7zpJd48x9xpWdh+L9gclf
ktAXAXZqcy5xPWYMgygQbrrh5dkJwmHrRU8Xy4bmmVfobKM41dFXScIHFdJGukaU
Tl/ow3CyEy50ScsQM0OOBSED4sQB8kxwzjd+s4tWowmyNkcoDibKiIYmp7Nn4c5O
eaIg5m40bSxN6pX+/woYh/N4hWTaG/0vF5S6gP9MSiOxgjjGGd8YrtI1tj1AOavX
PKV24bunYd3GPfMId4Uh/vqUH+6TMjBrpS0oj+h6udk+I/kehMtEOLvfk8RGtP9O
yZfjlSGvZjD5dj+EEZ2jU36GeSnDoPgYKsK30j9XVuaThVw4UoXQd1N4LUP7D1nk
vC2Tuk3VfgrzHwIvSThcI14Li0p8gKS0zrUNDsS8XlQ+D7m5wBWgIefsN2aXmYpi
SKnjXoeRrBisqLlDyhY7KH0o89sr7ZFr+rOeAb3O2utZFY+1o23nxt6lWcIfZYlT
uBQ2oQtyUgEV59NenDlu
=2ROJ
-----END PGP SIGNATURE-----

--AonAANj1daC6QcQu--
