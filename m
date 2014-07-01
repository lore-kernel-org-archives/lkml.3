Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaGAKdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:33:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36489 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbaGAKdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:33:41 -0400
Date: Tue, 1 Jul 2014 12:33:38 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] regmap: Fix debugfs-file 'registers' mode
Message-ID: <20140701103338.GG28033@pengutronix.de>
References: <1403961791-15376-1-git-send-email-mpa@pengutronix.de>
 <20140630054507.GX14781@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Content-Disposition: inline
In-Reply-To: <20140630054507.GX14781@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:31:51 up 69 days,  4:03, 70 users,  load average: 0.12, 0.14,
 0.14
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXr400anF0jyguTS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Uwe,

On Mon, Jun 30, 2014 at 07:45:07AM +0200, Uwe Kleine-K=C3=B6nig wrote:
> Hi Markus,
>=20
> On Sat, Jun 28, 2014 at 03:23:11PM +0200, Markus Pargmann wrote:
> > The macro "REGMAP_ALLOW_WRITE_DEBUGFS" can be used to enable write
> minor nit: I'd not call it "macro", but "cpp symbol" because macro
> sounds more function-like. (There is another "macro" at the end of the
> commit log.)

Okay.

>=20
> > support on the registers file in the debugfs. The mode of the file is
> > fixed to 0400 so it is not possible to write the file ever.
> >=20
> > This patch fixes the mode by setting it to the correct value depending
> > on the macro.
> >=20
> > Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> > Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> > ---
> >=20
> > Hi,
> >=20
> > as the kconfig option will probably not be merged, I extracted the mode=
 fix of
> > my previous patch.
> >=20
> > Regards,
> >=20
> > Markus
> >=20
> >  drivers/base/regmap/regmap-debugfs.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap=
/regmap-debugfs.c
> > index 45d812c0ea77..f45a0a0e0371 100644
> > --- a/drivers/base/regmap/regmap-debugfs.c
> > +++ b/drivers/base/regmap/regmap-debugfs.c
> > @@ -512,7 +512,14 @@ void regmap_debugfs_init(struct regmap *map, const=
 char *name)
> >  			    map, &regmap_reg_ranges_fops);
> > =20
> >  	if (map->max_register || regmap_readable(map, 0)) {
> > -		debugfs_create_file("registers", 0400, map->debugfs,
> > +		unsigned int registers_mode;
> > +
> > +		if (IS_ENABLED(REGMAP_ALLOW_WRITE_DEBUGFS))
> > +			registers_mode =3D 0600;
> > +		else
> > +			registers_mode =3D 0400;
> > +
> > +		debugfs_create_file("registers", registers_mode, map->debugfs,
> >  				    map, &regmap_map_fops);
> debugfs_create_file takes an umode_t as 2nd parameter. Maybe you should
> pick that type for registers_mode here, too?

Yes that should be changed, thanks.

Regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTso6BAAoJEEpcgKtcEGQQ9BgQALIVgabBbSctem6SbXs0fNpR
DU48/v+9kowpl/WR9XTvT63ykPf2GDScvX6uRAc+JqUgcd3nRnJ4R90SXewFNkXg
prKiqhaad3FjzU6njkiVDDVrwo9EMqc56FqFV3P7uh3uf8+Qxvobl7cwzptpmgJL
nqsFv2dHgaaFA9BkDghaADAkvNLD6ZJQ8pjC8BBu+K7/75Pp94fasP7WXRPweTM2
Y+TrRWgLmLfdnqqoPy3F8hFO9LBQH4ZyUJdzsY+Grv1b8AZyOYZJowx6n0iCeGqI
MHplwdjCb2mLCJ23amnEeFHagbX79dZlCkBdGLaSF5PPztEwgSipaqBfUWWn7Lv9
cpM/aJO9nRkYm0CgXmnOuzBtFuiML+CEeeyiAjto4FxkXtpKPBHwQl4qqPsZlF1V
DeuG33av8ZtLtjTtIm2h6LR84ffjBG8cvGS8Mha+GbGZQobHX4KO+q5IKzMvYkLn
1qHQLtcstMdEZfGiKsFwAOU1P4QZicOSjHsKgdcLZSfoEcIRNagU8CU7O4DGq18X
aek8qDiQMuuWx1zo31BWXcf2UezIZrCHu6AKYEr4q8IyoUYY00yc4aUu2H+Yfcyu
lv2JrRQ8Dwcd1DahXNNB+bLd8/gfTUarE1IzIbj1iIZyS2dNubujujrWu/7vWqvZ
aGouG9Jn5upwyuOV5CUb
=qkaH
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--
