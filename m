Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134Ab3HNSrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:47:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58347 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396Ab3HNSrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:47:03 -0400
Date: Wed, 14 Aug 2013 19:46:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130814184643.GL2401@sirena.org.uk>
References: <20130814173028.GB2401@sirena.org.uk>
 <Pine.LNX.4.44L0.1308141410190.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jnYfR+Q8IWTs8BNa"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308141410190.1701-100000@iolanthe.rowland.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jnYfR+Q8IWTs8BNa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 02:35:07PM -0400, Alan Stern wrote:
> On Wed, 14 Aug 2013, Mark Brown wrote:

> > What I'm proposing is that we have a way of telling buses that devices
> > exist via a mechanism other than their actually being visible on the bus
> > at the current time.  If you're doing that the driver can be running
> > prior to the hardware being there, just like it does with all the
> > non-enumerable buses.

> This may work for other buses, but it isn't feasible for USB.  Not only
> do many of the drivers need to communicate with their device during
> their probe routine, the subsystem itself needs to communicate with the
> device before many of the important data structures can be constructed. =
=20
> Without these structures, the device can't be bound to a driver.  We=20
> wouldn't even know which driver to bind it to!

The identification information for the device would of course have to be
provided as part of registering that the device was going to appear -
I'd expect to provide the same information that's read out of the
hardware during enumeration, with enumeration checking to see if it
knows about the device already.

> My impression is that much of what you want could be handled by a
> platform callback invoked when a particular bus -- i.e., one whose
> upstream controller is a particular platform device -- is registered. =20
> Is that correct?  For example, in the USB case, the on-board hub's
> GPIOs could be set when the USB bus is registered (or perhaps when the
> bus's root hub is registered).

That sort of bodge is probably adequate for basic "power this on" stuff
but it's not going to scale to a general solution, especially where the
driver wants to use some of the information at runtime.  Currently
systems are doing things like bodging callbacks into controller drivers
which is basically what you're talking about here.

> > It means that there are situations where a driver wants to take the
> > hardware offline but still offer services to userspace which will
> > require the hardware to be brought on line again.  The fact that this is
> > a very generic thing is exactly why I'm raising this as a generic issue.

> This is a separate issue, more or less independent of whether the
> platform needs to carry out special actions for the device in question. =
=20
> If you're suggesting these off-line/on-line transitions are appropriate
> places for a platform hook, then yes, that makes sense.

I think in the general case it's the same issue - grab all the resources
and enable them at probe time is the simplest implementation but it's
not the only one by a long stretch.

--jnYfR+Q8IWTs8BNa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC9CQAAoJELSic+t+oim9qIkP/3RLlLzJwb8Vwgqgeo/ZTBzY
8xJSK6J+1KGZ+lizOjie+bmlQcgxgIR/J6EtqStLmMr3c0HpiW8QB2fAMNZIsUDq
IJm3oYKxBxtd6VzxX66grWYWZKpxs1GUQOF3kBUCDUJGcwNV/a4oMV5cSWXTIrM6
cWy/EsPt+3QS/FKhM2IctuDd9x0NKgEljLZFCkxHkdAIWbeSw0XFYT0nrp+QVh4O
H/LizuUb1JoqvRUQ4PSPngFKVcYA368MVPcMJm1jBFhE8w+lGMghzeIuSII/doUy
1dRywM6gHeUOyExqIxXVt65eNmxHaBjhIdH6KdOlR13tilMT12YEr3j6Zb4R2rqN
YzDdVTCX3DTF9gBKqPj5DMnR0xXDJj0wsRERlhbTGtBAYpnumB3q8dB12l6FsmC4
zWHdAGvl/Pp4v1OYul969aAkBLnVEpXDGYCZVGWeZs2rE7Lbx9aVPSJBNoXLj45j
wwYfE3WVlIt3Rz8dpzHMe40VKdxSC3MlnohiJSXLviGWwoebf6u3wL2O6/HmYD4H
IzOgTBxqhJQ+jJNKrRuy4wzlXe5NglemMMrztcBgQGGVztJuv/cyblNMtABYCP7C
Zk7vTFXfa1U6wC/DSyxlDrnXUg1JOMvWNRL56rmcqaIs1bpTkDgQr+nI/WtDFHJi
L3cVDk/iwef3ug9jLhN3
=7PJI
-----END PGP SIGNATURE-----

--jnYfR+Q8IWTs8BNa--
