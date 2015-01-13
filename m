Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbbAMNkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:40:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33992 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751093AbbAMNkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:40:05 -0500
Date: Tue, 13 Jan 2015 14:39:03 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] fbdev: ssd1307fb: check return value while setting
 offset
Message-ID: <20150113133903.GV4891@lukather>
References: <1420705079-3741-1-git-send-email-prabhakar.csengg@gmail.com>
 <1420705079-3741-3-git-send-email-prabhakar.csengg@gmail.com>
 <54B504EF.4000809@ti.com>
 <CA+V-a8u0RARw84FYa661VZCYpXkZYkXmtc03jCXU=t0aoGvg9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nT6ukc3bqTvTgwkF"
Content-Disposition: inline
In-Reply-To: <CA+V-a8u0RARw84FYa661VZCYpXkZYkXmtc03jCXU=t0aoGvg9Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nT6ukc3bqTvTgwkF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2015 at 11:53:01AM +0000, Prabhakar Lad wrote:
> On Tue, Jan 13, 2015 at 11:43 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> =
wrote:
> > On 08/01/15 10:17, Lad, Prabhakar wrote:
> >> this patch checks the return value of write command while
> >> setting the display offset.
> >>
> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> ---
> >>  drivers/video/fbdev/ssd1307fb.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd=
1307fb.c
> >> index 70e3ce8..a7ecaa6 100644
> >> --- a/drivers/video/fbdev/ssd1307fb.c
> >> +++ b/drivers/video/fbdev/ssd1307fb.c
> >> @@ -342,7 +342,7 @@ static int ssd1307fb_ssd1306_init(struct ssd1307fb=
_par *par)
> >>
> >>       /* set display offset value */
> >>       ret =3D ssd1307fb_write_cmd(par->client, SSD1307FB_SET_DISPLAY_O=
FFSET);
> >> -     ret =3D ssd1307fb_write_cmd(par->client, 0x20);
> >> +     ret =3D ret & ssd1307fb_write_cmd(par->client, 0x20);
> >>       if (ret < 0)
> >>               return ret;
> >
> > Hrm, what's that supposed to do? If both calls to ssd1307fb_write_cmd()
> > return an error, they are anded, resulting in a garbage error code...
> >
> Agreed I have just aligned this to rest of the code in this function.
>=20
> Maxime if you are OK I'll post a patch returning error then and there ?

I'm not sure what the question is, but Tomi is right, having two
returns seems the right thing to do.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--nT6ukc3bqTvTgwkF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtR/3AAoJEBx+YmzsjxAgzCMP/jGTdXsCaTRLsyxQIDEAe87/
ZYayGnfwZDuYax/iKSc+VZvQUTFtqnCyaI7J66Yz53EW9thld5aOFvXO5J6kXGXh
xbU4x912yXqEuTI5Ulgg8kdBv/KRbUsPeHQCqMwhzfrWneZ3IbVt8KTURvTmh0LG
TJ3+mmPERZNLbhdhgkPJyDhNruo/cBED5obwOzXsp2VXoWiQLw0GZerZN5S/lKXg
hrwZoOe1X+g6dYM+378Z+iBWnbsK84EZv3rY6fQpNxMnMdyLbMoTRmk/gLMbLdFu
Ksn8EPjgb3W6puorWcngCJLISDuuy2DeUeWWEqHnSSH6SJrP+cdpqkRcz57mdB81
XQWtO37ikazI0DQpp3Xhwjk1aWAmpCwWHa9d4G7FSgwzf4HFajYdOYPKEvYdG8wh
LrKyFy2nCjA4xGZ3WnK8Cc4yZWCeT1nz88VHvKqI2gsaSiXydHC1jzdTmNEjCmx8
J0bY60Ot5GHMgFaOJOLwT5VVCLwziKWSBw6RzaRC2HtH/1L+GgjBfmO1PerjDmBY
2MMXb2PzybepeIHfeXFtGrKZs++uq5KENay+DRCuGTf9MSzumJ/qVSOLbl1xtpUX
lkvxp40niWCoRyAwfC7fNoFcD6HsLLO5Si/fHXbMCIXmPxqsCCuor1AyGMpTOw3M
NrQnAMJT/o6wTC8mLEyG
=ZgGi
-----END PGP SIGNATURE-----

--nT6ukc3bqTvTgwkF--
