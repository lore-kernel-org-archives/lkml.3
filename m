Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaEAWkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:40:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54440 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbaEAWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:40:18 -0400
Date: Thu, 1 May 2014 15:36:29 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
Message-ID: <20140501223629.GJ3000@lukather>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
 <20140430180609.GC3000@lukather>
 <20140501011811.GF3245@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BFVE2HhgxTpCzM8t"
Content-Disposition: inline
In-Reply-To: <20140501011811.GF3245@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BFVE2HhgxTpCzM8t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2014 at 06:18:11PM -0700, Mark Brown wrote:
> On Wed, Apr 30, 2014 at 11:06:09AM -0700, Maxime Ripard wrote:
> > On Tue, Apr 29, 2014 at 11:37:58AM -0700, Mark Brown wrote:
>=20
> > > Why can we not handle this by using sysfs to bind spidev to the
> > > device?
>=20
> > I just tried it, and apparently, you can't really use this, since spi
> > devices are created from the device tree (or ACPI) whenever the master
> > registers.
>=20
> Can you be more specific as to what the issue is here?  If we actually
> have a specific kernel driver for a device I would strongly expect that
> we would want to use it and not spidev, if we don't have one I don't see
> the issue.
>
> > It doesn't really work either for a device that would be bound to a
> > driver, that you unbind, and then try to bind to spidev instead. It
> > looks like the device is released whenever you unbind it, so you can't
> > really use it afterwards.
>=20
> I guess this is the issue...  what exactly is the use case here?  I
> would only expect spidev to be used if there is no in kernel driver for
> a device.

The issue and use case is this: we don't have an upstreamable way to
use spidev.

You suggested a while back to add the compatibles of devices we would
want to drive with spidev in the spidev compatible list. It's fine for
devices where we should have a driver, but don't, or devices that will
never ever be handled by the kernel.

But it actually doesn't work in a case where you can't really predict
what is on the other side of the bus. Either because, on the board
you're using the pins are exposed and it's pretty much up to the user
to know what to put on it. That could be handled by DT overlays
though.

What never works is where the device on the other side is so generic
that you really can't tell what it does. Think of a microcontroller
that would behave as a SPI slave. It's behaviour and what it does is
pretty much dependant of what we flashed on it, and suddenly the
compatible string is not the proper reprensentation anymore.

i2c-dev works great in these cases, because you always have access to
all the bus, and all the devices, except if the device is already used
by someone. The patch I suggested is an attempt to mimic this.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BFVE2HhgxTpCzM8t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTYsxtAAoJEBx+YmzsjxAgPaoP/1yT1gi1QB0SMFK+pVWqhW2Y
fNPA4556SH973n6hsDY1H4MQLmb7vPdTn2htOPAq0Ew3ngEDenZNeWDv4RYwGR/m
SWU3Mdkddc7kvawfhNFkAQdGH3zaAxnkaT2Rk5slUftqFOJiVhm5RjcoyvQal5Ay
9BD15JtxxO9vGGI78nsTRuMbaRhX7uqEAy1Jp8Ku2U6YZd7zvxqI4BUsxZ/ionTt
Ph96jrCGpCdcqJSIc9i6EH5iERPKs85rn+fCLwSCQTxK5aIt8OasWiUHZ++sxOgQ
D4XHNcsEj3dPhSFeNUYLgrh9Gd7slcfhtNUdt10hkDrroCCD5fSqPEU+wSe5YoXQ
9rrLUo+7K4lTxDgAqFfvz3NJskR6spKdPsvvsE2yadXhkCE7jMi05/RMrqcN82t8
osDUAV3LrSg1xnY3UeNnRSCvYqvv3iFZPbt1HwvSSvLoM8ZM8bab6RIi76hstn5C
jlVWQ9kOsSw39Qtte4CUWWw98djnY9ikl3nwanqEawLIFexRHc1ol+xTbRx70P2/
l5LL2QG06lyvNUXBj0Iv0nxzHxDkXTE1ZCb1XKkqefmzJ8C/FiDW/T4QGXO3AMW1
YskVhDB1nxJkCFynG5AAnygPbTQRFBoW96zu01obbN0Jj+N8TeKNxfQKC8bNRnkk
CAzLvJIEl+/Pc8knv+8d
=k3eJ
-----END PGP SIGNATURE-----

--BFVE2HhgxTpCzM8t--
