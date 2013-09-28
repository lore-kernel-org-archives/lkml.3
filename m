Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3I1W4E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 18:56:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46096 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3I1W4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 18:56:00 -0400
Date: Sat, 28 Sep 2013 23:55:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: devicetree@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20130928225535.GQ19304@sirena.org.uk>
References: <1380131272-16982-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20130925183201.GT3226@sirena.org.uk>
 <20130926152941.GQ3635@opensource.wolfsonmicro.com>
 <20130926175843.GS19304@sirena.org.uk>
 <20130928155308.GV3635@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W1G4cAX3lNqeBRc9"
Content-Disposition: inline
In-Reply-To: <20130928155308.GV3635@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] mfd: arizona: Update device tree regulator bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W1G4cAX3lNqeBRc9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 28, 2013 at 04:53:08PM +0100, Charles Keepax wrote:

> > I don't see why this would only be an issue for ASoC - it happens to

> > I would suggest that rather than unconditionally doing this on lookup
> > it'd be easier to do it the other way round and explicitly add mappings
> > from the parent to the child when registering the device.  That doesn't
> > have the potential to explode and get the wrong thing like this does.

> Been a bit delayed on this as I have been investigating the
> situation a little further. Is it just moving the supplies of the
> parent node we object to? Or do we want to keep everything tidied

No, having the supplies bound to the parent is desired (especially given
that there isn't a child node) - it's the fact that you're bodging this
in the framework by just randomly peering at the parent device and
hoping it's an MFD parent when a lookup fails.  That's not a safe thing
to do. =20

Like I said in the quote above trying to handle this in the child isn't
a good approach, it's both more idiomatic and more robust to put the
mappings from the parent device to the child devices in when creating
the child devices.

> onto the one device tree node? The reason I ask is because

Yes, for a device like this.

> looking at this further we run into other problems, the MFD
> framework is clearly intended to have a sub-node for each device.

No it isn't, see recent discussions on the list and look at the existing
drivers.  This is supported because for some devices it makes sense to
split things up but it's not something that needs to be used for every
device, it's useful when for example a device embeds a reusable generic
IP.  If you're ending up with the subdevices defined with the same level
of granularity as the parent device then that's not happening, and
remember that for these devices you do also need to support non-DT
systems.

> For example, the GPIO driver has a similar issue if anything else
> wishes to use an Arizona devices GPIO, because the GPIO driver
> is on a different device to the MFD so again it can't locate it.
> I haven't checked yet but I am guessing there will be similar
> issues with the interrupts.

No, this isn't an issue at all.  Look at how the regulator API resolves
DT lookups for example, the structure of the driver offering the service
should have no impact on anything referencing it.  The fact that Linux
happens to split things up into a particular set of subsystems at the
current time should have no bearing on the way that the DT bindings are
written since that's just a detail of how Linux works.

Linux (or any other operating system) can always decide to refactor
later on, something we take advantage of relatively often.  For example
with these devices the clocks are currently described as part of the
audio CODEC but which should probably in future move over to the clock
API once that's generally available since they're shared within the
device and can be brought out of the device to other system components.
The device tree for a system using the device shouldn't need to change
when that happens since nothing about the hardware changed.

--W1G4cAX3lNqeBRc9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSR15kAAoJELSic+t+oim9DWAP/1QUCOO896WcEKyK0zJ/PCZB
EsbTDz0HFHfgPxPdUAljayKosgqWxd97sSR07kvVS2BTl7IoOFFM5OeKTWPVo+Jc
XnqtjfLEa2lipF1ZIAu+97HDB4FK2krfAp2R6PR5UasYBir7XtIhumzMPRYKfY2I
LrJ7h6REvYxyFiolssg0tDL4FTQD1BAEHpaInd+zMON6knHeKXTVc//YIfOyQAsa
Hyb64OcW/83OuwjsQvRu4yj1Kj7/nSvoTNHHGHWkhWjsdEydcR4CflnPRaudkiVy
hhWXBZAO3y26IEagA+X/LykjgQ/ltv6i3ktK6Q3ZqYGXRKy32jWLli5YUqnAfZcZ
YYiUtbPRuV0OLQr+jwiDmhsd9eD/tt09BxbprsteDGyAkMcMuWFHPPdwPedXyJyk
MkmQ8klg4ijKIWu/Qz/IBdFzMqI0tgtskDd7dX+dvGkpGqSArJ4BsreWXVy0HeAK
e3/sE7KDmednrXCC1xgBI+qU8M2LtK3ClEXzP5KpOU/nNqS9AhmnTkTKf+gRYNvx
sjgfOwKbYi4n/3kxRo9uqZS1hDyCw4BKHnX3bZpLWKcmHKnQW1UXdAfGMQ+NiE8H
Fkof1FqhoC52UGNB6P84iw2Bhur6f13kmSFtTDsmwGsQYEjtueh0HjdNKU2aAnQ4
QGlTIW4Hov8xsVDWnuQs
=A0B6
-----END PGP SIGNATURE-----

--W1G4cAX3lNqeBRc9--
