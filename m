Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbaEEXET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:04:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:56239 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860AbaEEXER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:04:17 -0400
Date: Tue, 6 May 2014 01:04:12 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-input@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/5] Input: add common DT binding for touchscreens
Message-ID: <20140505230412.GC6261@earth.universe>
References: <1398470179-20880-1-git-send-email-sre@kernel.org>
 <1398470179-20880-2-git-send-email-sre@kernel.org>
 <20140505194125.GD25949@atomide.com>
 <20140505195139.GA26978@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline
In-Reply-To: <20140505195139.GA26978@core.coreip.homeip.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 12:51:39PM -0700, Dmitry Torokhov wrote:
> On Mon, May 05, 2014 at 12:41:26PM -0700, Tony Lindgren wrote:
> > * Sebastian Reichel <sre@kernel.org> [140425 16:56]:
> > > Add common DT binding documentation for touchscreen devices and
> > > implement input_parse_touchscreen_of_params, which parses the common
> > > properties and configures the input device accordingly.
> > >=20
> > > The method currently does not interpret the axis inversion properties,
> > > since there is no matching flag in the generic linux input device.
> > >=20
> > > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > > ---
> > >  .../bindings/input/touchscreen/touchscreen.txt     | 27 ++++++++++++=
+++++
> > >  drivers/input/input.c                              | 34 ++++++++++++=
++++++++++
> > >  include/linux/input.h                              |  8 +++++
> > >  3 files changed, 69 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/input/touchscre=
en/touchscreen.txt
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/input/touchscreen/touc=
hscreen.txt b/Documentation/devicetree/bindings/input/touchscreen/touchscre=
en.txt
> > > new file mode 100644
> > > index 0000000..d8e0616
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen=
=2Etxt
> > > @@ -0,0 +1,27 @@
> > > +General Touchscreen Properties:
> > > +
> > > +Optional properties for Touchscreens:
> > > + - touchscreen-size-x		: horizontal resolution of touchscreen
> > > +				  (in pixels)
> > > + - touchscreen-size-y		: vertical resolution of touchscreen
> > > +				  (in pixels)
> > > + - touchscreen-max-pressure	: maximum reported pressure (arbitrary r=
ange
> > > +				  dependent on the controller)
> > > + - touchscreen-fuzz-x		: horizontal noise value of the absolute input
> > > +				  device (in pixels)
> > > + - touchscreen-fuzz-y		: vertical noise value of the absolute input
> > > +				  device (in pixels)
> > > + - touchscreen-fuzz-pressure	: pressure noise value of the absolute =
input
> > > +				  device (arbitrary range dependent on the
> > > +				  controller)
>=20
> Fuzz seems like linux-specific property, not generic one.

I don't know about the term "fuzz", but the idea is pretty generic
IMHO. It's similar to debouncing switches/buttons.

> > > + - touchscreen-inverted-x	: X axis is inverted (boolean)
> > > + - touchscreen-inverted-y	: Y axis is inverted (boolean)
> >=20
> > We probably also need something to swap x and y depending on the
> > display orientation in addition to the touchscreen-inverted-x and y.
> > Just swapping x and y is not enough depending if we rotate by 270
> > degrees instead of 90 degrees.
> >=20
> > Naturally that part can be added later.
>=20
> So far we've been relying on upper layers (such as tslib) to perform
> such transformations rather than re-implementing it in every driver. Are
> we saying that we need to implement this in input core?

I would appreciate to add this later to move on with this patchset.
Having the N900's touchscreen working via DT in 3.16 would be nice
now that the display is working :)

-- Sebastian

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTaBjsAAoJENju1/PIO/qa5X0P/0R6YC4fy8gLQSMy3uNyrjIe
QnU0boUqNPvYV9XPeF+L6/u+psMZKJBRUhEYkKlUwFy/rsuuCDL2eFxX/AmdTEyk
sp7rBMBAZgmtSMd1NJ8D3HjjRtqZqF7dPYHlDpbqSQhjF7geKB00wQcckq+ntsib
n439+TQeveSGc4M4x+jEhO1dMa97GmHoKIaFFVFl6MnZqy6PhssPRzkNlS1ryIfq
yy19QY6Bixnnn7PAx48MseWigwWNdESgORPgJGdr8L+y7wVbd39HYwEClUMbBgxA
yWdeH9C/+01rJjVxmUGBS0iHdVZzz9gfUL6rjCc33bVpGLuwCQEFc/BMnEMschiF
mRAPXA12JXkxGPgiE1wlEhk237ERRtCnF4nv/Fu20LxJgtqrHrHFz+T8NzfQvwCT
EeZE2n3Y0Xd2xK1P5pGHFWAdKxEH0l8tc8YKcYNu7ZzDuelNQbQ2kYEyM/iNcNHe
b+fvZhX+GF0EzaExXcoWwG+eyPHZ/5maUOp44H0vb+1ySK5XWbLFvoIXrahiy2jd
NnKWLnFJQhcfil6TfQ7p6B9s4rE6EjYHWUwXcFNr/Cn7axDDHtYWYEz8++YYnkyI
Rmx2SftckSLdV7iPiPJt64RMcrHLB13V94Af87+IGBWYe7TvPS2pdbqsQZmb3ThH
ciYDaqDGjhNGc0puoGsh
=C06e
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
