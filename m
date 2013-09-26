Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3IZMEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:04:31 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:47547 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3IZME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:04:28 -0400
Date: Thu, 26 Sep 2013 14:02:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mike Dunn <mikedunn@newsguy.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: add support for device tree gpio control
Message-ID: <20130926120248.GB1680@ulmo>
References: <1378236372-15711-1-git-send-email-mikedunn@newsguy.com>
 <20130910172130.GC22111@ulmo>
 <523056A6.5060000@newsguy.com>
 <524408BE.40402@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <524408BE.40402@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2013 at 01:13:18PM +0300, Tomi Valkeinen wrote:
> On 11/09/13 14:40, Mike Dunn wrote:
> > On 09/10/2013 10:21 AM, Thierry Reding wrote:
>=20
> >> Do you have a real setup that actually needs multiple GPIOs? Usually
> >> such a setup requires some kind of timing or other additional constrai=
nt
> >> which can't be represented by this simple binding.
> >>
> >> Looking at the Palm Treo code it seems like the reason why multiple
> >> GPIOs are needed is because one is to enable the backlight, while the
> >> other is in fact used to enable the LCD panel.=20
> >=20
> >=20
> > There are actually four GPIOs involved!  (There is an embarrasingly hor=
rible
> > hack in arch/arm/mach-pxa/palmtreo.c that handles the others.)  One is =
almost
> > certainly simply backlight power.  The other three are probably LCD rel=
ated.
>=20
> When you say "power", do you mean the gpio enables a regulator to feed
> power to the backlight? If so, wouldn't that be a regulator, not gpio,
> from the bl driver's point of view?
>=20
> Generally speaking, this same problem appears in many places, but for
> some reason especially in display. I'm a bit hesitant in adding "free
> form" gpio/regulator support for drivers, as, as Thierry pointed out,
> there are often timing requirements, or sometimes the gpios are
> inverted, or sometimes the gpio is, in fact, a reset gpio, where you'll
> assert the gpio for a short moment only.

I sent out another series a few days ago that somewhat obsoletes this
patch. What it does is basically add a single enable GPIO that can be
used to turn the backlight on and off. In a separate patch, support is
added for a power regulator. The combination of both should be able to
cover the majority of use-cases.

That series doesn't handle any timing requirements, but again, for the
majority of the setups supported by a power supply and enable GPIO the
timing doesn't matter.

> I haven't seen new versions for the power sequences framework (without
> DT support), I think it could help us here a bit by simplifying how we
> present the sequences inside the driver. But we still need multiple
> drivers or the same driver supporting multiple devices.

I'm not sure if power sequences will be very helpful here. There was an
attempt to get those merged, but the patches were NAKed in the end. I'm
not aware of any work currently being done on them.

But as I said above, the combination of an enable GPIO and power supply
should be enough to get a lot of use-cases supported.

> And I also think that the model where we have just one driver for, say,
> backlight may not be enough. There may be multiple hardware components,
> that used together will generate the backlight. And each component
> requires specific management.

I'm not sure what other components you are talking about here. Can you
elaborate?

Thierry

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRCJoAAoJEN0jrNd/PrOhn90P/A/xij0rquswxJW82s/KNwss
JntXJtI77Jwt6CXMBA8mBnDiJAySNurn81Kts71r6wxdyMtKu39LVNJ3QMGjV0VX
xVqaYCR37J4S78qu6e9CfWLc4PJ+pmxowfWFq0yPg9+Ug9itCjaQ98FMDJWm9QVw
e/0IdBatWv4ZWA7wihYczwMGBIFtJKf5iaDA1i2S2+CYvz5aaj4LYDEHGZSOijD5
0c7IF5PY+Bi0/bbidsINIaBRwKj4bjDkYKW1Gi6bhQJ5SGhOIYjUvUvZahXqT2bk
lw5PVgne7jB5FVtE3wZzeQV4yDs0E2b1V36jpARWtOSCPnf2TurGpMMJ7qROPReG
Uu+CPr97Cd6inKswyjU7vGATLmBqabeBBjvJFyONFDQCLkt4CzNS/Gjge40y7Hw1
Vc4hWLtCLNgvXX5lOfadsPEp7sn0Cx1AWTsfOUvO7qRPvW+tbp8cLmBj9RcRO7sx
8fY35+ddvnB5rCkK7MmyfOYTgKGANrqZReL8yzU53zNLTkkkNsDYupdiumftykFD
V3qX8FiA8W7oL/W0Hh5Sl9hV6HbhNDow6nfICY5jtIOrs3AbCMyuxlWrSrKNW/Vb
vCqdrGiz1OFqyRBgA6x8PoFP6CMrBZAFbsOEB7lrNGS+/ITgww7bXAcDnYTSukSH
6VroKRzGyaUcav0+DAOk
=qidt
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
