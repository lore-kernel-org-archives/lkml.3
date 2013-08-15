Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab3HOTdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:33:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52973 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130Ab3HOTdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:33:03 -0400
Date: Thu, 15 Aug 2013 20:32:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130815193242.GF30073@sirena.org.uk>
References: <20130815171048.GC30073@sirena.org.uk>
 <Pine.LNX.4.44L0.1308151335310.905-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z0eOaCaDLjvTGF2l"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308151335310.905-100000@iolanthe.rowland.org>
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


--z0eOaCaDLjvTGF2l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2013 at 01:55:18PM -0400, Alan Stern wrote:
> On Thu, 15 Aug 2013, Mark Brown wrote:
> > On Thu, Aug 15, 2013 at 10:42:00AM -0400, Alan Stern wrote:

> > To be honest I don't see how that helps much if you're going to handle
> > the case where platform data is required to enumerate the device.  You
> > need to know about the device prior to enumeration in order to get the
> > platform data to the driver when it does enumerate and you can't
> > enumerate it until you do that anyway.

> You're a little imprecise here.  Which driver do you mean?  The driver
> that will ultimately bind to the device, or the driver that will
> discover and enumerate it (which generally is bound to the device's
> upstream parent)?  I'll assume the latter.

The driver that's binding to the device - obviously going through
teaching all controller drivers about how to start up any random child
device they might encounter is not going to be a good idea, this should
be encapsulated in the child driver.

> Under what circumstances is platform data required to enumerate a
> device on a discoverable bus?  We're assuming the platform has already
> taken care of everything required to make the device appear on the bus
> in the usual manner (such as bringing it to full power).  Can you give
> an example where something more is needed?

Powering on the device is exactly the sort of thing I'm talking about
here.  I'm not sure what you think "the platform" is here but it sounds
awfully like the sort of random board specific bodge code that people
currently use - something has got to know what's needed to get the
device up and running and how to do it and the device driver seems like
the sensible place to do that.

> (Were you thinking of the case where the device's IRQ signal doesn't go
> over the bus but uses a different platform mechanism?  I don't quite=20
> see how this can work.  What about devices on the bus that aren't known=
=20
> to the platform beforehand?  How do they send their IRQ signals?)

Either the bus doesn't support anything like interrupts at all or they'd
use the standard bus mechanisms.  Typical reasons for bypassing the bus
include things like latency and power, or excessive cost for
implementation on the device side.

> >  A bus could insist on this if it
> > needed the information from enumeration for some reason but really it
> > seems like an implementation detail.

> It isn't an implementation detail.  The "power-up for initial
> detection" scheme is a general solution to the problem of setting up a
> complicated communication path between the bus and the platform. =20
> (I.e., it gives a simple way to avoid the need for this communication,
> that can be used on any discoverable bus.)  It also is a general=20
> solution for avoiding the problem of registering a device on a bus=20
> before that device has been discovered and enumerated.

I think I completely misunderstood what you mean by powering up on
initial use.  If you're saying that we should have some platform code
for doing this I don't think that's a scalable solution.

--z0eOaCaDLjvTGF2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDSzXAAoJELSic+t+oim9aRYP/1sAWoTB7lqcDyVd7mVYc6SD
YIMZbLBlphUWJYrGpGpn7/SebMg8HSPY4niX9muKgKY0XlBz9JITJTb8ay1rMPgv
qcPtiwxvx3BPmO8UOdtJLImtiaHhjlIzyvw2SBc6DWN+oas4UW6dW/ZZU58UolpM
+7eBlaVoCvovOXAbD96oV9zHpwEnbp+s2f0SVgZfHTBwDcDHQX7Un+AgJMpTvgrf
i9h1EJAM3MOVqw7Ny50DCLYoJdHVqhmSyk11ADgkAwPw1bkHRdHsybX5EXo5Odzv
6wsInjJbYd0TZfn6HEeaTKFKt8QIWyi8RBDoa+5d0M8hVkYy4217yzB9l89ZfG5P
0WByFu7fjv/wLGrjgTcZu1kZQoARgtGcHzDweEeaO/2FT2/WsKlnSvTJGambXF0x
Rg2wNoUv3ndzpr/0fMm6s/Rjj6/ThhSEhoV7Fh9z8VnHcOd6msn6wHEfWIRS4Kl6
sRbtoSmIILk9EU+TU78GdPk5QQNzrVrHcrrGVpRH8HSATknw21IVRGu6EXRiRato
/8O/9poADnHq+kEYzxKcb1PyylEttlG5ykHWozEKfV8O07lCMIh0wy1LRFKOadgZ
ydZ3iqaMjCw57GtpJIZxyNPnmj3z3eA555Iv7AlcLhJuRJ6nnOFeHouS3HbHn19a
DtAe++pGF9ggeDFKZBcQ
=SSQc
-----END PGP SIGNATURE-----

--z0eOaCaDLjvTGF2l--
