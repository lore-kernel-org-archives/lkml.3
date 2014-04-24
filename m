Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaDXBnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:43:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34788 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaDXBnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:43:43 -0400
Date: Wed, 23 Apr 2014 20:43:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: NeilBrown <neilb@suse.de>
CC: <balbi@ti.com>, Nishanth Menon <nm@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, <marcel@holtmann.org>,
        <gustavo@padovan.org>, <johan.hedberg@gmail.com>, <jslaby@suse.cz>,
        <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
Message-ID: <20140424014334.GD13374@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
 <1398265117-11793-10-git-send-email-balbi@ti.com>
 <5357DDA8.4040206@ti.com>
 <20140424084305.20c7f301@notabene.brown>
 <20140423230121.GC10924@saruman.home>
 <20140424101329.02e6a62f@notabene.brown>
 <20140424012100.GB13374@saruman.home>
 <20140424114115.51ab3f98@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Content-Disposition: inline
In-Reply-To: <20140424114115.51ab3f98@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 24, 2014 at 11:41:15AM +1000, NeilBrown wrote:
> On Wed, 23 Apr 2014 20:21:00 -0500 Felipe Balbi <balbi@ti.com> wrote:
>=20
> > I have no problem either way, just that unused code doesn't have to be
> > sitting in the tree and I'm not entirely sure this GPIO should be
> > handled by omap-serial.c, perhaps something more generic inside
> > serial-core so other UART drivers can benefit from it.
>=20
> Perhaps.  But there there are more people I need to convince :-)

heh, Greg is in Cc, that'd be a good start.

> > > On the other hand, if you can point out to me what I'm missing, and h=
ow I can
> > > solve my problem with any virtual GPIOs, I'm all ears.
> > >=20
> > > To make my problem simple and explicit:  I have a device attached to =
a UART
> > > which has a separate regulator.  The regulator should be powered on i=
f and
> >=20
> > So you're using DTR to power the GPIO and hoping that the regulator
> > stabilizes quickly enough so that by the time your open() finishes you
> > don't have to add nonsensical msleep() calls before writing to the
> > device. Sounds a bit fragile to me.
>=20
> The gpio_set call is synchronous, and the gpio-regulator driver could add=
 a

sure, but it's synchronous towards toggling the GPIO, pulling it high.
It doesn't guarantee that the far-end regulator's output will be fully
changed.

> delay (I think).

yeah, that'd be part of the regulator-gpio with the startup-delay-ns
property (IIRC)

> > > only if the /dev/ttyXX interface to the UART is open.  The device is a
> > > bluetooth transceiver.
> >=20
> > considering this is a BTUART device, why didn't you do this at the ldisc
> > level ? hci_uart_open() sounds like a good choice from a quick thinking.
> >=20
>=20
> I'll have a look into that, thanks.

so, Ack for $subject or not ?

--=20
balbi

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWGxGAAoJEIaOsuA1yqRE7RoP/i0oa49Wd196SBwSHZOd1z0b
rXV/AotJ3XLxC45gs66aqvPB1CeDWHzPrgQrrqLTzaB6uAXmdQaGz91SAXmmijrS
4bOnmahVUmEiOXNUfKRi4cjS4BL003swKkAWmq732cY9ByHj1c7YMqZHwFUuUZC/
XyMozsf6MaZ7MswqfM54+AE9iR1uYUdhoEMxqus89A9+A1Py5Cuwg9iEoTx1EtoK
6VhmQBzrKLT0j/OBZSxYJ1SBZHnb3IJg/Kie+RJ4iiAuVduoOXGbAeG4pSueBGLV
HTezLOV247aYYAOy2eZsmIev/f1dVVsok+qb1YgYl9nJy+0L2dU2qpx3f8lco7Jj
wVbEsWfLKn81m3Mbop4Q5NVlupNNkgvjj6aug9QTl87wEDSV3zFGNVniHNmVgTbi
fOz9XI1/e0A2l8sB4Y3sE2fh+ZuUQV7/uNm2mlhqjAod4nqudT1+C3juypahzHi+
TM8hFgAWEPMgr4UzVrSt4uYk3C/RBfspUfj1HPdj3RPucxvXMZ7Jk3lxDGeu9/a3
5Pg/140DgrL/qQeO3QEQVLMSqhOevi2jG7BDb88eRBD5r036uQjvPiR98cQzUbi5
n5MFhW/Isp9k6nuN6cwd4TXHx9+5AEaokE3Hz2DQgqOqVFFG0TtgVpUwmqERVQ6g
ExojUxOktA9Ba5URSoNV
=z7lG
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
