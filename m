Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3HKTIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 15:08:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43852 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3HKTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 15:08:41 -0400
Date: Sun, 11 Aug 2013 20:08:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130811190826.GH6427@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K2ilJF7ocWQIPRKZ"
Content-Disposition: inline
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K2ilJF7ocWQIPRKZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Looking at the enumerable buses in the kernel I don't see any which have
real support for any kind of registration of devices prior to their
enumeration.  Similarly currently all the DT bindings in the kernel I've
been able to notice cover only non-enumerable buses.  This generally
makes sense where enumerable buses are used in standard fashions since
the binding would be at best redundant and at worst inaccurate.  However
there are often corner cases in embedded systems where hardware has been
hooked up outside of the normal enumeration mechanisms, for example with
software power control or extra signals wired.

One example that's bugging me right now is that on the Insignal Arndale
platform there's a USB hub connected to one of the USB ports on the SoC
(not as a PHY, it seems we also need the internal PHY running to talk to
the device).  The hub needs to be "plugged" into the SoC after the SoC
USB controller has started with some GPIOs so we need to tell the system
that the hub exists and needs to be synchronised with the USB controller.

Another case that's going to be problematic once it's in mainline is
Slimbus - this is a bus used in some embedded audio subsystems which is
enumerable in a similar manner to USB but where the devices on the bus
are normally powered up only on demand (causing them to hotplug when
used and unplug when idle) and have at least interrupt lines wired to
the SoC using a normal interrupt outside the enumerable bus.

I know there's been some discussion of this topic but do we have any
general consensus on how to handle such things both from a Linux driver
model point of view and from a DT/ACPI point of view?

--K2ilJF7ocWQIPRKZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSB+EnAAoJELSic+t+oim9NUUP/jZ3eJIVGvymQ9wkCHIZtCnM
ZqmmzLYEI8sKbIGNTJ1dduaoQOZZhy/Mt51nzjbMfIWIYvv1OLD+AcY61RHxW/Xx
1ilPKc7z8xDsEM0/mDSXP2D8QsHUShQ6ug3Xzlehf6A2LRWPRxjIXUPptReyFoMu
KdU4Yx0U4/Io200WxcpO2/MEwJzBiK5kDdoF8PNjHPZnuhvrRqXAQVwM5xZl2xoc
TvMzvYehqSq7VT7XzGTja2gC/UtgXN2H94HaSWb5OKbLVed6fpqVjeN8fbHjFUpE
+6+4gHkDMIBkrHDzrLmpHua1/SZeDnCGvs048+TQcz+jzIeZ+Cnth4keiUsHtJ9I
70g0X/k72lj9t9UmOUSvZpPk3DstwcPbXyW9qhW2jctoXwnLHt7tqkNxObWB1Nw7
8qXLghKSZd4n+MBzZ1yBgZt9+1OoSUBTjxFGohX32QLSOpyrRk9shne0p/EPqd+p
L4ssoLwwIXOrQGa2HnfEft4X/mPBvaPyfL5KKktGa1hmehNPpESNEi3ROckciBU5
tBYSrGSwOVDsRhdHXO/fgJb6UzYDrxFPhZyIDtg6dowNUWnB0bratgUj+R/cUDpJ
b70KzcBm0mxFAaGBXC1b5mfKW9eBMXYRssYkjA75myFCWZEKpC6FrmJ1z2MVDdAL
8rcAL0JpE8sCDZhIQRi/
=s6o4
-----END PGP SIGNATURE-----

--K2ilJF7ocWQIPRKZ--
