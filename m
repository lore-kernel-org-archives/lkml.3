Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaDGUAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:00:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:55533 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbaDGUAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:00:32 -0400
Date: Mon, 7 Apr 2014 22:00:23 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/5] Input: add common DT binding for touchscreens
Message-ID: <20140407200022.GA20023@earth.universe>
References: <1396736821-14395-1-git-send-email-sre@kernel.org>
 <1396736821-14395-2-git-send-email-sre@kernel.org>
 <CAL_Jsq+46bPtgnQc5aAN8bcaw=te6MX=cvMMNP6+6xjG8Drkbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+46bPtgnQc5aAN8bcaw=te6MX=cvMMNP6+6xjG8Drkbg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 07, 2014 at 11:38:01AM -0500, Rob Herring wrote:
> On Sat, Apr 5, 2014 at 5:26 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > Add common DT binding documentation for touchscreen devices and
> > implement input_parse_touchscreen_of_params, which parses the common
> > properties and configures the input device accordingly.
>=20
> Good.
>=20
> [...]
> > +Optional properties for Touchscreens:
> > + - touchscreen-size-x          : horizontal resolution of touchscreen
> > + - touchscreen-size-y          : vertical resolution of touchscreen
>=20
> While I like the consistency, x-size and y-size are already commonly
> used. Perhaps the common binding should have both and x-size/y-size be
> marked deprecated.

So you want me to add something like the following?

- x-size : deprecated name for touchscreen-size-x
- y-size : deprecated name for touchscreen-size-y

> > + - touchscreen-max-pressure    : maximum reported pressure
> > + - touchscreen-fuzz-x          : horizontal noise value of the absolut=
e input device
> > + - touchscreen-fuzz-y          : vertical noise value of the absolute =
input device
> > + - touchscreen-fuzz-pressure   : pressure noise value of the absolute =
input device
>=20
> What are the units or are they just an arbitrary range dependent on
> the controller? Several existing bindings appear to be in pixels, but
> that seems wrong to me.

x/y related properties: pixels
pressure related properties: arbitrary range dependent on the controller

> There's also these various properties that should have common versions cr=
eated:
>=20
> ti,x-plate-resistance and ti,x-plate-ohms (tsc2007)

I think this is ti specific. But I should probably name the tsc2005
property "ti,x-plate-ohms", so that its in sync with tsc2007.

> - rohm,flip-x             : Flip touch coordinates on the X axis
> - rohm,flip-y             : Flip touch coordinates on the Y axis
> - x-invert: invert X axis
> - y-invert: invert Y axis

like this?

- touchscreen-inverted-x: X axis is inverted
- touchscreen-inverted-y: Y axis is inverted
- x-invert: deprecated name for touchscreen-inverted-x
- y-invert: deprecated name for touchscreen-inverted-y

Inverting is currently not supported by the input system, though. So
adding support for it to input_parse_touchscreen_of_params() is not
trivial :/

> - contact-threshold:
> - moving-threshold:

I think those are hardware specific. The properties are currently
used by one driver, which writes them directly into some registers.
The DT binding does not give more information about them.

I think those should have been vendor-prefixed.

-- Sebastian

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTQwPWAAoJENju1/PIO/qaBU0P+QGx5/DnvpBtIPKQan8JRCvL
K8o644Hnj1ZDgbclPa3S9CYoktSIN2on6n8tkCKQBCGz2htJf8atOoA93ICLcdpS
gVacYmWbVfUjx4fNuObJGWhYF82c9KEawq4hAC5oLZPLHwflWi3wkA1aoKZ6eqm3
I3iNRwENcbppRM7shFV9QGz/9DgBf6LFKvEWHWTB+BrkGZcOI7qB06HoSZpZwOwc
TJKSHY39stOydO87oQthoeOmjxd7DfAtXfCOFX5uiZgzPJmWuolH9+mln49Z8sjF
W9LoPcsYN4LSEvpPtRJySqvXvo2NH6ICpB5njKOE0Nmhl3J046ARqC7oySNXfgwv
xaCPQZQYjgIknuV+tURYFzGTuEcYsKIFmCIw9Fc6VEgDvZzbiFW26hFr2QG4ZXKU
p57KjJ8kZxVBL9pdOJ5BZnBACRaIljN99M/09VQ7Fn2nKn18ZguKU6su5W1hV9kf
7aIuByVngIyDO27lqnh3nK2nGipfY2/HxcWF8UBoi0OEUGpgZjr2fxVWGNf+s42y
sNPZFeaKje8pm6QYvyydoshDIcthDQKnf8HimGcfQoEGnIdgwzb5l13yZBdqPbPX
xU7MKeroDv0mJbYHahMA8u6oiaVLZklhR1bT9qXHO0VyoGs+ENOF6i7YNr9H0ODd
sEh9En//12ikHus98xaU
=fPNy
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
