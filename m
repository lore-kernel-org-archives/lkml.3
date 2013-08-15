Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3HOWyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:54:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49266 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3HOWyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:54:45 -0400
Date: Thu, 15 Aug 2013 23:54:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130815225427.GA18597@sirena.org.uk>
References: <20130815193242.GF30073@sirena.org.uk>
 <Pine.LNX.4.44L0.1308151616440.905-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308151616440.905-100000@iolanthe.rowland.org>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2013 at 04:42:01PM -0400, Alan Stern wrote:

> Okay.  Here's a restatement of what you wrote above:

> 	In the case where platform data is required to enumerate the
> 	device, you need to know about the device prior to enumeration.

> Obviously true.

> 	You need to get the platform data to the driver when it does
> 	enumerate.

> Not necessarily; see below.

I think this is pretty essential - there is no point in having platform
data if you can't pass it to the device.  It needs to make it to the
driver at the very least by the time the probe function runs.

> > Powering on the device is exactly the sort of thing I'm talking about
> > here.

> So something needs to power-on the device.  But what?  The driver that
> enumerates it, or some other part of the kernel?

> If some other part of the kernel takes care of this then you _don't_
> have to get the platform data to the driver when it enumerates.

Right, but my contention would be that if it's not the driver for the
device that is being instantiated it's probably not going to be
anything scalable since that's where we generally put our knowledge of a
given bit of silicon.

> >  I'm not sure what you think "the platform" is here but it sounds
> > awfully like the sort of random board specific bodge code that people
> > currently use - something has got to know what's needed to get the
> > device up and running and how to do it and the device driver seems like
> > the sensible place to do that.

> Just the reverse.  The driver should deal with things it knows about: =20
> how to discover and enumerate devices on its bus.  It should not

For a bus controller of course, they should be totally out of this.

> contain anything platform-specific.  Adding this in would be a
> logistical nightmare -- you'd have to stuff power-on procedures for all
> sorts of different platforms into this one poor driver!

No, this really is something that's very much generic to the device and
will apply to anywhere the silicon is used.  The power on process for a
device isn't something that changes, the mapping of resources that might
be used in that sequence is but we've got good abstractions for pretty
much all the resources that a device might need - clocks, power, GPIOs
and so on - which do the mapping of those resources onto the device at
board level so neither the provider not the user need to know about it.
That's just data and is much easier to encode in DT or equivalent than
actual sequences.

We've got a bunch of existing drivers in the kernel which do this sort
of stuff, they ask for resources and then know what to do with them and
can also make use of these resources at runtime if they want.

> > I think I completely misunderstood what you mean by powering up on
> > initial use.  If you're saying that we should have some platform code
> > for doing this I don't think that's a scalable solution.

> How can it be avoided?  The powering-up operation is platform-specific. =
=20
> By definition, whatever code carries out the operation is platform
> code.

Like I say device power management isn't system specific, it's silicon
specific - think of what's in the driver as being the power up sequence
=66rom the datasheet.

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDVwgAAoJELSic+t+oim9L1gP/RwPPlgWvKq2wFq+senbTU6A
engwC5mFBaUW5ECV1bCdzsRaxkyNIEOgUwqO6oBP1LyPyMqxR7Ry8FE0FHCgRtBX
hd6ZSUupcBTIJpQ7uCclEq/7b1iZyo88BbWqc2iKM7ftRCzeFc9gzv2rovGvbfQ1
q8WLmjv8rCrxOaDoZrCNYflscrX2icck3MkJ+E1vsvyiyOrJdKuisdAuyB5CRSkV
BkqLZ/XhpFyHAVPpQnR1a9jxSlxuF1Y1TrHOigTAm65flTfRPLjPVSCJpsTBrw0r
nqBQTYLB7yuOy8WN+JplU5m1nd3vURl2fMlyFycNK9XbRK0wWVn4/maVtCBHfHRx
HUyGGTOvocG6IK5Omo86dF+XYOtXk8FihJjNbO8apU1/mtzeVBc465vqG2+a6EQg
bsqCeUiQui7RVtlD3/qTO4lpLNUP/x5gR7BhGOMlqMrRzvY9zaOWUYwFxWI+K2YI
OHarh9FyqrfOYkp19IauJpzHHtb0OOOL1cxywHI30YepMKyqrycEV5mYi2iU4IYf
7Swf8HOmZarfhV4USh8Db1hU2shMc85DDYVQLcyV8tqKh7lOw5/0tnXa5K01oAaf
QImlxJacbjJegBDUiQ0YomOl5wRZAYhHNi657cWYjv4GDLFs6t3FReY5A1KMp2Yu
et31eLLNI6Ju2mG3LnsX
=/a0A
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
