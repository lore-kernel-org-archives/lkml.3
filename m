Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab3G3UbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:31:18 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43864 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757016Ab3G3UbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:31:17 -0400
Date: Tue, 30 Jul 2013 22:31:15 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [linux-sunxi] [PATCH 04/10] pinctrl: sunxi: Wrap long compatible
 declaration lines
Message-ID: <20130730203115.GE12562@lukather>
References: <1375196394-21138-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375196394-21138-5-git-send-email-maxime.ripard@free-electrons.com>
 <1375196953.32691.61.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EgVrEAR5UttbsTXg"
Content-Disposition: inline
In-Reply-To: <1375196953.32691.61.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EgVrEAR5UttbsTXg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ian,

On Tue, Jul 30, 2013 at 04:09:13PM +0100, Ian Campbell wrote:
> On Tue, 2013-07-30 at 16:59 +0200, Maxime Ripard wrote:
> > The compatible declaration and their associated data are exceeding the
> > 80-characters width limit.
> >=20
> > Split these lines to make them more readable and fit in the kernel
> > coding guidelines.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > ---
> >  drivers/pinctrl/pinctrl-sunxi.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-=
sunxi.c
> > index 5985e60..246310b 100644
> > --- a/drivers/pinctrl/pinctrl-sunxi.c
> > +++ b/drivers/pinctrl/pinctrl-sunxi.c
> > @@ -628,10 +628,22 @@ static void sunxi_pinctrl_irq_handler(unsigned ir=
q, struct irq_desc *desc)
> >  }
> > =20
> >  static struct of_device_id sunxi_pinctrl_match[] =3D {
> > -	{ .compatible =3D "allwinner,sun4i-a10-pinctrl", .data =3D (void *)&s=
un4i_a10_pinctrl_data },
> > -	{ .compatible =3D "allwinner,sun5i-a10s-pinctrl", .data =3D (void *)&=
sun5i_a10s_pinctrl_data },
> > -	{ .compatible =3D "allwinner,sun5i-a13-pinctrl", .data =3D (void *)&s=
un5i_a13_pinctrl_data },
> > -	{ .compatible =3D "allwinner,sun6i-a31-pinctrl", .data =3D (void *)&s=
un6i_a31_pinctrl_data },
> > +	{
> > +		.compatible =3D "allwinner,sun4i-a10-pinctrl",
> > +		.data =3D (void *)&sun4i_a10_pinctrl_data,
> > +	},
>=20
> I'm not sure this is actually an improvement, the original reads quite
> naturally even if it is a little long. What about a #define such that
> you can write:
>          COMPAT("allwinner,sun4i-a10-pinctrl", sun4i_a10_pinctrl_data),
> and thereby stay within 80-chars?
>=20
> If you wanted to go overboard you could code the macro such that:
>         SUNXI_COMPAT(sun4i,a10),
> expanded to what you want, that's pretty obfuscated though.

To be honest, I'm not convinced by any of the constructs seen above. The
one we had is too long, the 4-lines one is not that great either, and
the macro only obfuscates things away.

You know what, I'll drop this patch.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--EgVrEAR5UttbsTXg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+CKTAAoJEBx+YmzsjxAgY6cQAKE4RP+nMAwxP15NcAZKwB67
KBZv8fxBgqt3ZraFrJ6xxTJK/Pror5P9JprnFK3hyVyOkgiIJfCH/wfo/Qn4fk+c
C63Wyk4gVmKWsxDOFBCoh6qxUYx8spbJC8cEubmlSCbKVGv4aoJ9WpCPeh5rls00
bsPLIXnIdh6wuS+pIUbqoryvkUgzskXBvKqMpO2M1C4+fHFyWsHZxa4NV67dvaRh
T+OYOHlNyFCwR6z8mMrBh6HRbHdxsdJnXV7njkLiFiwkaSxI43Zha7ueD6Fivn6Z
ANMwn1Jmh73w+qAdWqdBk/d1fS6CD8Re64fIpNVor6RE/CvMy/rqJPVmB2YPQbAn
lHw95+2FcQwob2pBToMW/PCwYx9rVOCUKrH3VWCvcQi7NK3FCJY1wwG6Oc5RGHso
kcjjNeTgHZOxWK85Ht+XQY6Ozl3oQJi50olIApJlNbG7W+NxCKGQV60RLR7WLavx
JI2cN3nq6ElUQOD5ZNNEnT87wR7xNJ9kt6dyKu41wIyH0IsbNvf7Ozs8mNEJ6Qax
NZQHACkkVhKp+V00NZjwEojOYCq5ZP8JFLGmBC3FSrY0e2zNymJHGbrFLk1Ni+hs
GjPQo1gQ1hGEMRrW2KR8H0VoCMUc3z7E7jX0jjumSwhzKEuFZR5SgXePYpfPl8wW
Tb/eQ2sUkU36/OCv0l4q
=UYUD
-----END PGP SIGNATURE-----

--EgVrEAR5UttbsTXg--
