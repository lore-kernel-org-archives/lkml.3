Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaLHTUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:20:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39255 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbaLHTUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:20:06 -0500
Date: Mon, 8 Dec 2014 20:18:43 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Message-ID: <20141208191843.GI8739@lukather>
References: <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
 <20141201163639.GI25249@lukather>
 <CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com>
 <CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com>
 <20141202161227.GH30256@lukather>
 <CAAVeFu+Gms6ptyK6j1Zy_wWg+9URs+9zBu=pOiwiEERO=8NjNw@mail.gmail.com>
 <20141204142741.GQ30256@lukather>
 <CAAVeFuJTjWPzQYYkV3jW3+h6uigzzeKS9d7pY2cQ-dK119msXg@mail.gmail.com>
 <20141205102427.GU30256@lukather>
 <CAAVeFuL2CYtcDnwnuWD5wfMLGK-GEwBA09BXkhBMFJCjr2rEcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="boAH8PqvUi1v1f55"
Content-Disposition: inline
In-Reply-To: <CAAVeFuL2CYtcDnwnuWD5wfMLGK-GEwBA09BXkhBMFJCjr2rEcg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--boAH8PqvUi1v1f55
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 06, 2014 at 09:08:36PM +0900, Alexandre Courbot wrote:
> On Fri, Dec 5, 2014 at 7:24 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Thu, Dec 04, 2014 at 11:49:19PM +0900, Alexandre Courbot wrote:
> >> On Thu, Dec 4, 2014 at 11:27 PM, Maxime Ripard
> >> <maxime.ripard@free-electrons.com> wrote:
> >> > Hi,
> >> >
> >> > On Thu, Dec 04, 2014 at 11:15:38PM +0900, Alexandre Courbot wrote:
> >> >> On Wed, Dec 3, 2014 at 1:12 AM, Maxime Ripard
> >> >> <maxime.ripard@free-electrons.com> wrote:
> >> >> > On Tue, Dec 02, 2014 at 03:29:46PM +0100, Linus Walleij wrote:
> >> >> >> On Tue, Dec 2, 2014 at 3:13 PM, Alexandre Courbot <gnurou@gmail.=
com> wrote:
> >> >> >> > On Tue, Dec 2, 2014 at 1:36 AM, Maxime Ripard
> >> >> >> > <maxime.ripard@free-electrons.com> wrote:
> >> >> >>
> >> >> >> >> The only thing I'd like to have would be that the request her=
e would
> >> >> >> >> be non-exclusive, so that a later driver would still be allow=
ed later
> >> >> >> >> on to request that GPIO later on and manage it itself (ideall=
y using
> >> >> >> >> the usual gpiod_request function).
> >> >> >> >
> >> >> >> > Actually we have a plan (and I have some code too) to allow mu=
ltiple
> >> >> >> > consumers per GPIO. Although like Benoit I wonder why you woul=
d want
> >> >> >> > to hog a GPIO and then request it properly later. Also, that p=
robably
> >> >> >> > means we should abandon the hog since it actively drives the l=
ine and
> >> >> >> > would interfere with the late requested. How to do that correc=
tly is
> >> >> >> > not really clear to me.
> >> >> >>
> >> >> >> I don't get the usecase. A hogged GPIO is per definition hogged.
> >> >> >> This sounds more like "initial settings" or something, which is =
another
> >> >> >> usecase altogether.
> >> >> >
> >> >> > We do have one board where we have a pin (let's say GPIO14 of the=
 bank
> >> >> > A) that enables a regulator that will provide VCC the bank B.
> >> >> >
> >> >> > Now, both banks are handled by the same driver, but in order to h=
ave a
> >> >> > working output on the bank B, we do need to set GPIO14 as soon as
> >> >> > we're probed.
> >> >> >
> >> >> > Just relying on the usual deferred probing introduces a circular
> >> >> > dependency between the gpio-regulator that needs to grab its GPIO=
 from
> >> >> > a driver not there yet, and the gpio driver that needs to enable =
its
> >> >> > gpio-regulator.
> >> >>
> >> >> I don't get it. According to what you said, the following order sho=
uld
> >> >> go through IIUC:
> >> >>
> >> >> 1) bank A is probed, gpio 14 is available
> >> >> 2) gpio-regulator is probed, acquires GPIO 14, regulator for Bank B=
 is available
> >> >> 3) bank B is probed, grabs its regulator and turn it on, probes.
> >> >>
> >> >> What am I missing?
> >> >
> >> > It would be true if bank A and B were exposed through different
> >> > drivers (or at least different instances of the same driver), which =
is
> >> > not the case.
> >> >
> >> > In our case, banks A and B are handled by the same instance.
> >>
> >> Ok, so both banks A and B are part of the same device/DT node. Now I
> >> think I understand the issue. You need to hog the pin so that bank B
> >> will work right after the device is probed.
> >
> > Exactly.
> >
> >> But you will still have the problem that the regulator device will
> >> *not* be available when your device is probed, so you cannot call
> >> regulator_get() for bank B anyway. I guess your only choice is to hog
> >> that pin and leave it active ad vitam eternam.
> >
> > Hmmm, indeed.
> >
> > I'll stop boring you with this then :)
>=20
> Please *keep* bothering us with any doubt you may have until they are
> all cleared and you are sure this feature will be useful to you.
> Especially since we are designing DT bindings that will have to be
> carried over forever. We really want to get them right, and need input
> of potential users for that.
>=20
> Having a few design arguments is a small thing compared to the hassle
> of having to work with unadapted features and bindings.

Ok. What I had in mind when I first thought about it was to set GPIO
as hogged through the GPIO flags, and then have a dumb GPIO driver
like Pantelis was suggesting.

I don't know if hogged would still be the right term, but we could
have that flag that would just allow the value to be set through
gpio_request init value, and deny/cache any subsequent change through
gpio_set_value.

gpio_request with this flag would never return EPROBE_DEFER, and just
cache the value to be set for when the driver comes in.

We could enforce driver-less GPIOs through that dumb driver, and we
would still be able to break weird dependency chains that end up in
circle.

That's just a thought though.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--boAH8PqvUi1v1f55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhfmTAAoJEBx+YmzsjxAgmLsP/ApAmAOMscaotvWPssOAGNcX
qkrYlHCl/165mp/jPuoanhPi57t1532U2uP4zzTg6njfBToLyU3By8TO9yDClwKG
u5e3/8g5UTV0zHIZuY5YeNS2b6oDm0Mh7GottDXgNTeffnU6ozP+T5VKne/kD298
w3Xia7+iCVnBOh1GxOmyjRU1viX0cQtkQqjRzh0r7TJR0TsJy8pBBi/AF7nFGEk6
7s8d7zhajjUMY5P79Boj1sY34HOYdCvzKPKdCVLgoZHfQRw7YFEmE5DPkNCc8NLw
X0f7kk6X0hw3Rj8WlKyd2H9nWuscMIDEOa0yIvjxWpIAPEJf5WTkf6zB9hiWSZKH
D6vW2NPsEXT8AfyUEv40n+Hdrb+LG4VMyiHCdGS2tA5m2uNVLjevs1OWqkggCRoh
PW1pWYHy5XvNQ0qQopEF8lWvG+dryju92yr5/m3hh7p1Hm8KOyckfwDjNCWPok7E
cW8aP7OQgqSjroujbSY/mkmmzw3NUId5uQdplrl3NSLfQYk8LJSNJ25fj5QrsyGX
F4lpJQiEoWssmelVECSuJjkBpihrwh3vhek9BrD5of2OT0yMGf6TBPuNC72oruxc
hzriDMx8aCADx+aOekWIZ4ab2YU3GL0W/LAXogy15A1uCxbDrU2YlqJsQnib4Vjb
he3ueuck7H/JPK90UD1U
=fzgU
-----END PGP SIGNATURE-----

--boAH8PqvUi1v1f55--
