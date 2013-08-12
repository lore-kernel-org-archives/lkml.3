Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3HLJwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 05:52:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36364 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3HLJwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:52:16 -0400
Date: Mon, 12 Aug 2013 10:51:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130812095136.GJ6427@sirena.org.uk>
References: <20130811190826.GH6427@sirena.org.uk>
 <Pine.LNX.4.44L0.1308112146410.29546-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7OnDFbl3rdzPmmvv"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308112146410.29546-100000@netrider.rowland.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7OnDFbl3rdzPmmvv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 11, 2013 at 09:53:01PM -0400, Alan Stern wrote:
> On Sun, 11 Aug 2013, Mark Brown wrote:

> > One example that's bugging me right now is that on the Insignal Arndale
> > platform there's a USB hub connected to one of the USB ports on the SoC
> > (not as a PHY, it seems we also need the internal PHY running to talk to
> > the device).  The hub needs to be "plugged" into the SoC after the SoC
> > USB controller has started with some GPIOs so we need to tell the system
> > that the hub exists and needs to be synchronised with the USB controlle=
r.

> On the surface, this seems like a particularly simple case.  Why wait=20
> until the SoC's USB controller has started?  Why not "plug in" the hub=20
> via the GPIOs right from the beginning?

I tried that, it doesn't seem to work - for some reason it seems that
the hub is only successfully enumerated if it starts after its parent is
running.  I don't know enough about USB to speculate on why that might
be, the GPIOs are brining the device out of reset not applying power or
anything.

> > Another case that's going to be problematic once it's in mainline is
> > Slimbus - this is a bus used in some embedded audio subsystems which is
> > enumerable in a similar manner to USB but where the devices on the bus
> > are normally powered up only on demand (causing them to hotplug when
> > used and unplug when idle) and have at least interrupt lines wired to
> > the SoC using a normal interrupt outside the enumerable bus.

> That is indeed more difficult, because it requires geniune cooperation=20
> between the bus and platform subsystems.

Yeah.  You might want to do the same with for example a USB network
controller when you're in flight only mode, that seems to be one of the
more common reasons for doing this sort of thing with USB.

--7OnDFbl3rdzPmmvv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCLAlAAoJELSic+t+oim98swP/j2DDHFTNziNJJHLm1xJ3tGw
dsoRp0otZu/OHiRjT+GxoDITbmbU8Cc6V1OeBXijxVkL9FdOtr/n2zV4+dSfXXTn
T/7me1OQvy2x3ypFnFhWswAeB30bsTDqWu3d4BbqhMvXuf0J+tElem7g2QceJ2zf
cVChwLf8CNOV13RsSB/mjZk6XbJQpbcyF4PxXwsbbjw2KYnOu379QuoIGW9SmRvr
WOu0kOVHWy6Yn78NUHgcnH+/D5ODLmFnz+O34A4KpGBuWDdmxHrRLuqiS5I4IIOF
xqxjlYA9VpKUBLdL4z9O9f+WmrVColJjK3OGHGreWklbu8+X4i1tzw591p8F1GSD
yyr57aCPQilRjbY5ygUcb4vcWtxTslI6/tLh9A13tG9V8SS6WYQR2tlBhCSRSN3C
FRYCun4gPJYnmejhDubKUlPP4CrW2bMm+2ROLymiLu8q+vuvNtckkDnwgFpnHdF1
0q2WaM6tLLjRlIpLgE1l3iLFSqBq/0zCs1mAmdd8UQsSOR/Cywq9iwiLU2P4LThy
3+5sCYuCo3ItB52sGEOQtB4CBW1ryiHZjJQzt6Ic9Fm73T+yVTAqwISL0Ma/MWCV
J3jZ3eyLEJ0bdtYqRfRV/YLH+Z/p0GL6aorUQ82PNGi0xXg3bNqU0W1T8rSvtfzu
DXYow1KP5l8k8sdXeOBe
=x0hs
-----END PGP SIGNATURE-----

--7OnDFbl3rdzPmmvv--
