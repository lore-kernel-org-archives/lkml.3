Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3FGPmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:42:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36851 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab3FGPmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:42:25 -0400
Date: Fri, 7 Jun 2013 16:41:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130607154134.GU31367@sirena.org.uk>
References: <20130605210715.GA16013@core.coreip.homeip.net>
 <51AFAF6D.7050204@itdev.co.uk>
 <20130606100346.GC1883@sirena.org.uk>
 <51B0651D.3090902@itdev.co.uk>
 <20130606105530.GT31367@sirena.org.uk>
 <51B06FE4.7040805@itdev.co.uk>
 <20130606131638.GX31367@sirena.org.uk>
 <51B0B52C.1090807@itdev.co.uk>
 <20130606164629.GG31367@sirena.org.uk>
 <51B1F859.1010504@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DFEKJgrLFALZaGlA"
Content-Disposition: inline
In-Reply-To: <51B1F859.1010504@itdev.co.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DFEKJgrLFALZaGlA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 07, 2013 at 04:12:25PM +0100, Nick Dyer wrote:
> Mark Brown wrote:

> > Who said anything about names?  I'd assume the userspace stuff is
> > eventually talking to the device based on numbers of some kind and I'd
> > expect that this would be what ends up in the API.

> OK. But if user-space is talking to the device based on register numbers, a
> binary attribute seems like the correct way to present that - isn't that
> what they're designed for?

I thought there was this protocol you're concerned aboout, not raw
registers?  Presenting the actual data in binary form seems sane, how
one gets to the data is the issue.

> >> And we wouldn't have won anything, because the user could still write to
> >> the register that turns off reporting (for example) by mistake with both
> >> methods.

> > You'd not have access to the entire device register map which seems like
> > a win

> Not really.

> The chip itself will enforce which registers are read-only (by ignoring
> writes) or write-only (by returning zeros if read). Encoding all this
> information in the driver would just make it more brittle in the face of
> touch controller firmware updates.

So not only do you interact with the firmware via this protocol but the
actual hardware register map is unstable and there's nothing in the
device that the driver itself actually interacts with, all it does is
ferry these messages from the application layer to the device?  Given
the number of other patches here that doesn't seem to be the case...

> It would be possible for the driver to intermediate for some of the
> registers that it cares about. For example, if we change the screen width
> then the driver could reinitialise the input device. But I can't see that
> it makes sense if you are changing several settings in a row for the input
> device to be reinitialised several times. It is far less buggy to provide a
> single way of tearing down everything and reinitialising (which could be
> simply triggered from user space) than to encode all of the dependencies
> (which is bound to introduce bugs).

I am having an extremely hard time connecting anything you're talking
about here with the discussion at hand I'm afraid...

> > Having lots of configuration and having the parameters change regularly
> > doesn't immediately mean that it has to be complex - the requirement is
> > very common, touchscreens aren't too remarkable here.  The usual thing
> > is for the kernel to understand how to transfer data back and forth but
> > not the content of the data.

> Sure, that's what I'm trying to accomplish. It's just that as far as I can
> see it makes more sense to use the established protocol that these chips
> have implemented rather than trying to bodge something else over the top or
> crowbar it into a different model that will cause abstraction problems. We
> have thought about this problem at great length, and discussed it on these
> lists, and with other kernel engineers at customers, etc.

Nobody is talking about changing the protocol for interacting with the
device.  The discussion here is about the ABI the driver offers to the
application layer.

--DFEKJgrLFALZaGlA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsf8rAAoJELSic+t+oim91V8P/077c5Jeb/s9gBoN7/+DT8Jj
WSyLs3CxLRHv8OJo8nqsuvlOC0aPLu+VAMjGmze8O3YtczDRCpbvwOnjNA6SyIsY
mnwXd5+KOJ15HM7Eb2yFkDLAqeYedxMWEi3YWOhG5pQh6qH+Zr5H+1b1aXVKgQ2j
9V4UzJqymQLChac3LA2tc/TheK3VZi8R0jXUR1Lo3Bs/650bvyGtHKgYFDVz/FVd
jCkzyoh1vh12Eq9nY4C3dA0aHzeqPS0dvpqTwX120n21eCAmWDg9SI0YtYDtQNV0
0Xvd+RO3F8rYbOXKUKBQ8QMcBbfVMCx1EAhYaZ9mjtw083bhRChn3nKDCfAYU8nj
fI92xmQE9d9TwEKjnFRcpQexxznEm3CNyIlzCCEvT5P1i0RH7otXqKsBFwlInyoF
PVy6XAmvQKFo+3ljtxugOsScWoI39beRyOJsKklaOV+QHelyT1A+4KM4+uGzo0NR
Be81VEaOLuAIerwnQuZCVPLetIvy9TP2Uw1WOsTZKdr5avqPAsDbeCotYsIalzpx
4rUVWv3J56WRXsW/m5GIbdIP0vLOcnxskBvICVBVYPHpfcQEXfJC2ClHmNsp2C/R
GkCIE5/9TjOg1sRQUlhcbngkd+K7LRjj5dICXmVKRxz05rJtb0Ns+yY9ViUT98iI
80HcdklHUBFyqtVlEENk
=Yz+Y
-----END PGP SIGNATURE-----

--DFEKJgrLFALZaGlA--
