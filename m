Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3GHUZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:25:45 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:60541 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3GHUZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:25:43 -0400
Date: Mon, 8 Jul 2013 22:25:38 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: MTD EEPROM support and driver integration
Message-ID: <20130708202538.GK11243@lukather>
References: <20130705201118.GM2959@lukather>
 <5811519.oHVuMujf0I@wuerfel>
 <20130706120112.GA11069@lukather>
 <8997501.Dchyii8uWX@wuerfel>
 <20130708083426.GO27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rn7IEEq3VEzCw+ji"
Content-Disposition: inline
In-Reply-To: <20130708083426.GO27646@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rn7IEEq3VEzCw+ji
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 08, 2013 at 09:34:26AM +0100, Mark Brown wrote:
> On Sat, Jul 06, 2013 at 09:06:49PM +0200, Arnd Bergmann wrote:
> > On Saturday 06 July 2013 14:01:12 Maxime Ripard wrote:
>=20
> > > > > > a) like interrupts, regs, dmas, clocks, pinctrl, reset, pwm: fi=
xed property names
>=20
> > > > > >       regmap =3D <&at25 0xstart 0xlen>;
> > > > > >       regmap-names =3D "mac-address";
>=20
> > > > > > b) like gpio, regulator: variable property names
>=20
> > > > > >       mac-storage =3D <&at25 0xstart 0xlen>;
>=20
> > > > > > It's unfortunate that we already have examples of both. They ar=
e largely
> > > > > > equivalent, but the tendency is towards the first.
>=20
> > > > > I don't have a strong feeling for one against another, so whateve=
r works
> > > > > best. Both solutions will be a huge improvement anyway=20
>=20
> > > > > Just out of curiosity, is there any advantages besides having a f=
ixed
> > > > > property name to the first solution?
>=20
> > > > I think it's mostly for consistency: trying to get most subsystems =
to
> > > > do it the same way to make it easier for people to write dts files.
>=20
> > > > A lesser point is that it simplifies the driver code if you don't
> > > > have to pass a name.
>=20
> On the other hand something with human readable names is much more
> legible if humans ever have to read or write the DT bindings.  This
> mostly applies when there are many instances of the property (for
> example, many devices have lots of power supplies) or when some
> instances of the property are optional (for example, many devices can
> use GPIOs for many different functions but usually not all of them are
> connected and there's no particular order in which they might get
> connected).

I guess we would have only a few of these in our cases, so it doesn't
really qualify for the "many instances" I guess, but I do find the
GPIO/regulator-like properties more intuitive and more readable as
well.

> > > So that leave us with mainly one path to achieve this goal:
> > >   - Add a regmap-mtd backend
> > >   - Add DT parsing code for regmap
> > >   - Move the EEPROM drivers from misc to mtd
>=20
> > Yes, I think that would be good. For the last step, we definitely need
> > buy-in from Wolfgand and Jean, as they are maintaining the current eepr=
om
> > drivers.
>=20
> I'd really like to see more discussion of this "DT parsing code for
> regmap" idea...  I've missed almost all the context here.

The context was that I found we lack a way to simply express the need
for one driver to get a value from an EEPROM-like device, for example to
get a MAC Address, or a serial number, in a generic way, without having
to poke directly with some custom function that would be exported by the
EEPROM driver.

And the lack of infrastructure/framework to handle the EEPROM right now
only make the thing a bit harder.

What we've been discussing so far is that:
  - To have a common framework we could base our work on, we could move
    the EEPROM drivers from drivers/misc/eeprom to MTD
  - To declare the ranges that needed to be used by a driver that was
    needing a value from one of those MTD drivers, we would use regmap
    with a MTD backend
  - And since we actually need to declare which ranges and in which
    device one driver would have to retrieve this value from, we were
    actually in need of DT bindings.

This is pretty much the only context involved, and we are at the early
stage of the discussion, so any comment is very welcome :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Rn7IEEq3VEzCw+ji
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2yBCAAoJEBx+YmzsjxAgSoQQALKvwWDerSrTMbEvlwtiTcj1
ZhH+J/qdJsu8lXL2CpG6ZMT/R0g4DOGMUU4lv/lC/T4YCKuNs+vA2Vmv6QY74CGB
WjYp9HyxHeG1IIOAJlJwRst3flelDEl2u2zm39uODe5AjaB5lM5uchXZNLX+2zzd
1V0hUZqr9osudzgsjGMjaj3DrM+GxpSxSgTq3ow4M/5H2tDhiK7aFLeUeQCZWVu4
uHBmpYrPDJxOxh3cuXxNnyczqk/sUCtc9HTtEeyrOP2z4Us1q+XzRwG2hvH55ZqS
K175BfrP8jbLU44HLfKJSyIcwGCxSu2En5pU8LejHXFWDNZlj27tcGYnW5ny+8Xi
VZTf42chG4gTbTFeFRrfZcdAfz1bb91ltMF0JGxi8I9080EfuHJti1toe2AJC632
PgGn2wNzNE4TSCyXf+8SxcRXZjphgAcgzmUCt1KizQiH6T+2NZdwkZsTKRM1NRWh
LgiteSled/w898itZJGgGV5CfQvFmKlB6IBczqLUEDk5Hv0WpiKwdj8Ns3Q94kBa
wchu/Sp3KtaN6jnpJ4RrOkHCxMtvgqk+HgdGml61EzJIxvLqdnJMVGNhSP5jk71G
6hR/efzELXwgawY2sb5CbF2o/kQ8fHIZIJceqj+1uB3ItSmP8SKc8Y4dOkAVN5WN
Q/Weo/qLowtzO/LS32nc
=A9YG
-----END PGP SIGNATURE-----

--Rn7IEEq3VEzCw+ji--
