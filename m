Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab3HPWSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:18:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39411 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3HPWSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:18:21 -0400
Date: Fri, 16 Aug 2013 21:00:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130816200009.GU30073@sirena.org.uk>
References: <20130816183934.GQ30073@sirena.org.uk>
 <Pine.LNX.4.44L0.1308161457300.1532-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tn/+KOyBVBGpvvUM"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308161457300.1532-100000@iolanthe.rowland.org>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tn/+KOyBVBGpvvUM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2013 at 03:27:58PM -0400, Alan Stern wrote:
> On Fri, 16 Aug 2013, Mark Brown wrote:

> >  or those for getting platform data to a device when it
> > does enumerate.

> ?  I can't make any sense out of that comment.  For one thing, why do
> you need to send platform data to a device?  (It's obvious that a
> _driver_ would need to use platform data; it's not so clear that a
> _device_ would.)

The device in this context is a running instance of the driver.

> > > (The second proposal also has the advantage that the power-on code ma=
y=20
> > > be shared between the driver and the subsystem.)

> > Can you explain in more detail please, I don't follow?

> Let's say the subsystem powers up the device when the bus is first
> registered, so that the device can be detected and enumerated.  Let's
> also say that the driver wants to power-off and power-on the device
> from time to time, as part of normal runtime PM.  Then instead of
> having its own power-on routine (which would be code duplication), the
> driver can simply call the subsystem's power-on routine.  (Of course,
> this would mean that the routine would no longer be run-once.)

Oh, OK.  I don't think that's a meaningful difference, the driver is
going to have the code and be able to reuse it one way or another
anyway.  In many cases if the device has been in a low power idle mode a
slightly difference sequence would be needed anyway.

--tn/+KOyBVBGpvvUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDoTGAAoJELSic+t+oim9amYQAI3sV5dIqWFg9D0m1NJXOQxc
K21hwDTPrNrMYfd/o613WaBBw1jdTdtmQH7qvw68E+X1iWydxQwS+De+kSbHMll+
DEZVBf0wwDR7PDO8Hqud9F3jbjDJZXciNNpbAAHxq7fTQqTyM9LNXU+aOAv/tayz
KEZWUtiAMHMecMJYK/jDxRWIirhMgdvbOyvIlOWR/gSR/dmgm+n4luYF6amiDV/P
7yH3Pcl6R8UbIh0X7LHN2Y9nBumSQrqvPFtBH1qOpKME0tHvkG3IrZH/3xrZkVyZ
Awhg7dw/pIjndmmtnQge8zyh26IXQ2F5EqSb2K4TqQDKx9Aftk0D0nxOij6iO3Cl
L93rlGe0s/6yq1LymaZm4oScxL6FHuY+kFtTwJyhMRXa2bgYotsLTg1epvvFwxs3
N09mCrrKZJwZdRaPsxOyg0fQ8rfGD6s0w04sE1zuxeSyxdKxoooTaCga8HE1zNi2
ays2KOixIT7Kfugz66fFqHnqXYKw5XWZOtMUzqhhJWrq0am4ESqIPWrexiS9Wqme
H6VQjHjau9/VrOxhqzTOLpGNueiSwzUIvuqEd7r1pqT2tX9gP03amI/iJWjnefgg
QlVwJpE1e+gA7Sp0jCu5NMqZXi2mYZlcdfVF98e5Hm1IJB4dlq1O+2OvFgLbgG6Q
9NN8bZPxW3pHfIJWfMt3
=+9X3
-----END PGP SIGNATURE-----

--tn/+KOyBVBGpvvUM--
