Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3HLLYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:24:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55259 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab3HLLXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:23:53 -0400
Date: Mon, 12 Aug 2013 12:23:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130812112344.GS6427@sirena.org.uk>
References: <20130811190826.GH6427@sirena.org.uk>
 <20130812020257.GA7028@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hlBpHj2D9ifWzbWk"
Content-Disposition: inline
In-Reply-To: <20130812020257.GA7028@kroah.com>
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


--hlBpHj2D9ifWzbWk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 11, 2013 at 07:02:57PM -0700, Greg Kroah-Hartman wrote:
> On Sun, Aug 11, 2013 at 08:08:26PM +0100, Mark Brown wrote:

> > I know there's been some discussion of this topic but do we have any
> > general consensus on how to handle such things both from a Linux driver
> > model point of view and from a DT/ACPI point of view?

> As these are usually bus-specific things, and really, platform-specific

I don't think they're bus specific - the main issue with a lot of this
is that they're outside the infrastructure that the bus standardises so
we should have a general way of understanding this.  There will be bits
where the bus needs to get involved but the overall pattern is generic.

> things, I'd fall back and just recommend a "platform driver" that
> "knows" about where these gpios are, and how/when to enable them, which
> will cause the discoverable bus logic to kick in now that it notices a
> device is present/removed.

This doesn't work in general.  These things aren't really platform
specific at all, they're features of the devices that apply to any
system using them and while for some use cases (like WiFi and BT power)
an external thing that just manually applies power will be enough in
other cases we want to know about the device even while it's off and the
driver might be able to do extra things at runtime if it knows about for
example having some control over signals to the device.

For example in the Slimbus case we're normally talking about audio
CODECs.  In order to preserve the userspace API the device has to appear
to be present at all times, the driver will remember the settings the
user is making to be applied when it actually powers up and indeed the
powering up should be kicked off as a result of userspac acting on the
apparently present device.

Another example here (including USB devices) is interrupt signals wired
directly back to the processor, completely outside of the bus.

> Perhaps a semi-generic "platform" driver could be created, that knows
> how to handle these settings in the DT, but odds are, that might be
> difficult to make generic enough to cover a wide range of boards, but
> without specifics, it's hard to tell.

There's things like the rfkill stuff already, and the reset controller
on the way, but again this only covers a fairly small subset of the
issues.

--hlBpHj2D9ifWzbWk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCMW9AAoJELSic+t+oim9BPoP/0mVGfrfUU56GRnO/P2cowV7
8ZmKrgzPUiMMH/6NOYZWgD6QSX5Y0BefnuZB8VuaXFJ9pk2TR8Ho+gkMNsrXYDUP
WVJgp1r+uIN3b8G4ub6nhne8n/J7Na4or8Iqht2BSBX70Z8KAxHtuMkBhE/RWnLM
Qhi+O2G92tXSpQ9jWs0IxrvuvBGaZat8kKPyqgD0Wf1bVCREAHpAETmuOb0XZ3jh
jrQD9mRS2qEGEc1c1tC2a+OHx9GpoiHonmFzq6sUF1BJbpGCdJ3g+mKaoROaZ2yC
ev0tuymWRyF93Ng+V0xgiXDW5R354nM7ORRPQRp4COQSL5AhO1zXUKBmrwE1yfEl
7x+jxcSLt4FPINvZ7slzeeHABjp29v1U9VFIZ+sBLZpDIe3MT8mSMWTse3OoQdEs
8GbUcIp8I0uoPAcq7VW/eFD9KeG9AvDCmn9O96H9Z06ZfRN5o0QwX2SAaaTipjtK
gsQP1H4JP6j3HuZpWtJDXH/716Mazefv2geRMeA3zFJjrotTzuSwoEcatyuBiQlI
8oqZZijNx7O+ORimY2BsoJTBVhoqa3LRadgtsqB22ax3DQznsZRXha+3JCYqWF5Q
9ABtYVLJAbNfzAH/VSy9slli0LzFEn0VjjjJ0JP95cjuhypyw/AEqy/xNrHEx0SG
IhLfVwubVOo4Vp6uA6Hs
=ceYx
-----END PGP SIGNATURE-----

--hlBpHj2D9ifWzbWk--
