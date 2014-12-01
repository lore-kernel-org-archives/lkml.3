Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaLAQkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:40:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53793 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752817AbaLAQkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:40:04 -0500
Date: Mon, 1 Dec 2014 17:36:39 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Message-ID: <20141201163639.GI25249@lukather>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-2-git-send-email-bparrot@ti.com>
 <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b+chlBtRKJDCtqTb"
Content-Disposition: inline
In-Reply-To: <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b+chlBtRKJDCtqTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 28, 2014 at 04:30:01PM +0900, Alexandre Courbot wrote:
> > +/**
> > + * do_gpio_hog - Given node is a GPIO hog configuration, handle it
> > + * @np:                device node to get GPIO from
> > + *
> > + * This is only used by of_gpiochip_add to request/set GPIO initial
> > + * configuration.
> > + */
> > +static int do_gpio_hog(struct device_node *np)
> > +{
> > +       struct gpio_desc *desc =3D NULL;
> > +       int err;
> > +       const char *name;
> > +       enum gpio_lookup_flags lflags;
> > +       enum gpiod_flags dflags;
> > +
> > +       desc =3D of_get_gpio_hog(np, &name, &lflags, &dflags);
> > +       if (!desc)
> > +               return -ENOTSUPP;
> > +       else if (IS_ERR(desc))
> > +               return PTR_ERR(desc);
> > +
> > +       err =3D gpiod_request(desc, name);
>=20
> Using this function means that a GPIO chip module cannot be unloaded
> if it uses GPIO hogs. Is it the intended behavior? If not, please use
> gpiochip_request_own_desc() instead, and make sure to call
> gpiochip_free_own_desc() for each hog when the driver is unloaded.

The only thing I'd like to have would be that the request here would
be non-exclusive, so that a later driver would still be allowed later
on to request that GPIO later on and manage it itself (ideally using
the usual gpiod_request function).

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--b+chlBtRKJDCtqTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfJkXAAoJEBx+YmzsjxAgqY0QAJbT5ky9AzUmJVMbI/JXLVEJ
sRSHFLrRDQzD9VMaE8tVERMyKOW2KLVZKY74MY6qxhtokSgSa49KICJkSc5nIKIR
J0Tp73BpB2XPcBHBahtvWiKSvvekpKn3+FslG0Fx4s+8UkgYdPlweNT9D7lWuuTx
wgBhkU+c7ehPloiKFg4m1EDW0OhL3iAkrXGgh7zVcglGOb489B1sc8FvDvn+DL2o
kQoxJkoc1ZQMlLV74Uf/fYLeDNWAGiB0f9sDLS3ZLYw0IPgxREV7UJJxXbJkTLZa
rjKVfD0uDrlKt5THovz/Mw4jA1VAnnkGNJF3YvidPm0bsMoKimJ3i2YKK3ZKnU2F
gRqA3Ew1AXNLLuBWaR6kfhX4TcJ6KoYIXQOLZYM02jhjkZkyuefunlnBMGiGDnOn
wwIx6jhYtKIEWxolQBYcISBYnG5XPkxbmW+bb6pKObutlTQP/cPZr6Z4/whbjQvY
Z3ClNygSoX2PlsvD4iC90o0X11rseJgaLZV0A6f/bFXxyfeTy2o8mmqLOOb+XkA7
wILCrA8NAe9oKj744/qCj+obtwDd5rbNkm2XwXWEPs17xDyJzMT0QDskrABxNSTV
N3wLFGE7jhy+fdHRS8GBdr6BQb+u8L6EQHyij6sNDtu5jbqEGqozjy1LzdFxFwlX
84/vYq92GfF/7QNVUGp2
=Oa5f
-----END PGP SIGNATURE-----

--b+chlBtRKJDCtqTb--
