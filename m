Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3IKN6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:58:33 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36867 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3IKN63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:58:29 -0400
Date: Wed, 11 Sep 2013 15:57:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC 4/5] gpiolib: add gpiod_get() and gpiod_put() functions
Message-ID: <20130911135728.GA24351@ulmo>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
 <1378294169-22661-5-git-send-email-acourbot@nvidia.com>
 <52279082.5010105@wwwdotorg.org>
 <CAAVeFuJCCnx+kY46BTkqTbno-j9YwV=GN3dS1aLzxc+ZYWxEdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <CAAVeFuJCCnx+kY46BTkqTbno-j9YwV=GN3dS1aLzxc+ZYWxEdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2013 at 12:44:34PM +0900, Alexandre Courbot wrote:
> On Thu, Sep 5, 2013 at 4:56 AM, Stephen Warren <swarren@wwwdotorg.org> wr=
ote:
> > On 09/04/2013 05:29 AM, Alexandre Courbot wrote:
> >> Add gpiod_get() and gpiod_put() functions that provide safer handling =
of
> >> GPIOs.
> >>
> >> These functions put the GPIO framework in line with the conventions of
> >> other frameworks in the kernel, and help ensure every GPIO is declared
> >> properly and valid while it is used.
> >
> >> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consum=
er.h
> >
> >> +struct gpio_desc *__must_check gpiod_get(struct device *dev,
> >> +                                      const char *con_id);
> >> +void gpiod_put(struct gpio_desc *desc);
> >
> > It might be nice to add an "int index" parameter to this function. For
> > example, a bit-banged parallel bus protocol driver might have 1
> > chip-select GPIO, 1 clock GPIO, and 8 data GPIOs. gpiod_get(dev, "bus",
> > 0)..gpiod_get(dev, "bus", 7) might be nicer than gpiod_get(dev,
> > "bus0")..gpiod_get(dev, "bus7")? Possibly for client-simplicity,
> > implement both gpiod_get(dev, con_id) (as an inline wrapper for ...) and
> > gpiod_get_index(dev, con_id, index)?
> >
> > In DT terms, this would map to:
> >
> > cs-gpios =3D <&gpio 3 0>;
> > clock-gpios =3D <&gpio 5 0>;
> > bus-gpios =3D <&gpio 10 0 ... &gpio 17 0>;
> >
> > ... and with the mapping table registration mechanism, we could
> > presumably add "int index" to struct gpiod_lookup.
>=20
> Having the index argument of of_get_named_gpiod_flags() propagated
> into gpiod_get() is something I also thought about (see the cover
> letter), but I really can't make up my mind about it.
>=20
> On the one hand, having several GPIO per DT property is already
> allowed, and presumably used in bindings already. It might also make
> sense to have several lines under the same name, e.g. for bitbanging.
>=20
> On the other hand, I'm afraid people will abuse this, and group all
> the GPIOs for a device under a single property instead of using proper
> names.

I wouldn't worry about this too much. Preventing abuse is a large part
of why we have DT bindings reviews and I think that regardless of what
the implementation allows us to, that shouldn't influence the way how
bindings are defined.

After all the bindings would ideally be usable on any other OS as well,
so it should be sound irrespective of the specific implementation.

I think having a gpiod_get_index(dev, con_id, index) with an inline
wrapper gpiod_get(dev, con_id) will give us the same functionality that
we have using the current set of helpers from include/linux/of_gpio.h
and allows non-DT to specify them in an analogous way.

In my opinion that's enough for now. We can always refactor common
patterns (such as busses with 0..n GPIOs) when they start to emerge.

Thierry

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMHbIAAoJEN0jrNd/PrOhfMwP/33SflnaUq0Sxc16i7J+nufj
0ZLXTNxGll6byP3UbICgiIevBKANz+pXmZyVNbNVsBiFiWmp0UE4U6T5m3cLUJec
/JK3QIdZZCBYnJ6dNCAmzUcQUt5dLpj8UDbNwQwKX1kgF6IWqwnFifLKGeUS1L+/
E5Jh+td2kggcdyuBzxeONE8WRISsWmPOV3uBD8+7p9aQjOr5IZwJT1CHS4oAAiBA
mmkFTTiXvzClOR1qmhSzJJTYkdo5kiA8KTGsMUDo1Z6ZgW7a4ufqQydrhGDSOXsM
OMFjWErdxeYUw8AMvVJmqvSkXUHiXFihYV8nKMZnoRU8INbPbs28gu5Jzi51bDFO
SeNSN4PGP4aVjgtuDiytwPe+9euSsH8EX6/xPAf5KKmUIVnAwt8WgjV0a5QbGB2i
k4MCxy3zunvi8D6B8/cKUnTtAhkGjn2sY4txYWMmg0Sep2wXeQGVWCYXo/RCt8HT
ms9kCiUqzh3rU3MFE0cTvA74QovILFw9zUcuH+mXN37BVifZQPVgxZcEHUx+Tu10
6++a9Q2i2kV0Y8RfxjWxIRpBQEBFXwi4z6G+tXKinfZW7fb4ySGlQ2T8dWCEzvz+
xpqdn+FlM7ryTXeC8W7eMcP4CL3IKBxXrynvzThgtQghCJW2D/KcbPJDnOuM0NTS
r3telgNvSvJvenJRyrb8
=TxGY
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
