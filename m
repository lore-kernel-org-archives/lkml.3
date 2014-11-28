Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaK1QBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:01:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42280 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaK1QBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:01:03 -0500
Date: Fri, 28 Nov 2014 16:00:36 +0000
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20141128160036.GW7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <54753168.9010303@linux.intel.com>
 <20141126111716.GE7712@sirena.org.uk>
 <7202604.4LK4s7RH1S@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k9ssVBY1NpawPNl1"
Content-Disposition: inline
In-Reply-To: <7202604.4LK4s7RH1S@vostro.rjw.lan>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k9ssVBY1NpawPNl1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2014 at 12:09:55AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 26, 2014 11:17:16 AM Mark Brown wrote:

> > > As to registering ACPI IDs, I believe this is the right link:
> > > http://www.uefi.org/PNP_ACPI_Registry

> > No, those are vendors as far as I can tell.  I mean identifiers for
> > specific devices - it appears to be common for for example Intel to
> > allocate identifiers for devices they don't produce, I'd expect there to
> > be some effort to keep track of that especially given that _DSD
> > properties may well end up being specific to the identifier used to
> > register in cases of parallel evolution.

> The vendor (or more precisely the owner of the initial 3 or 4 letter code)
> is supposed to do that.  I'm not aware of any common registry of those IDs
> for all vendors.

OK, we probably should have one to aid discoverability since as far as I
can tell what's happening is that people (hi Intel!) are allocating
their own identifiers for devices produced by other vendors that turn up
on their boards.  If people can find the set of IDs in use there's more
chance they'll use the same ones as other people.

> > > Or did you mean a HID/CID<->DSD mapping?

> > I don't really know what that is, sorry.

> The device ID is supposed to determine the way all of the ACPI objects for that
> device will work, including what is returned by _DSD.  Pretty much in analogy
> with PCI device IDs.

So the HID and CID are device IDs then?  Please bear in mind that we're
not all familiar with the acronym soup that tends to go along with ACPI!

If those are device IDs then what you're saying is what I'd expect to
happen and it's part of the reason I'd expect us to be registering IDs
along with registering properties - if people are defining device
specific properties they really ought to be tied to the IDs that are in
use especially if (as seems likely to be the case with the current state
of the world) people are doing things without attempting to coordinate
and we're ending up trying to document the deployed reality.

--k9ssVBY1NpawPNl1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeJwjAAoJECTWi3JdVIfQxtMH/2cuOV21Uzdi4IFBLyfUPBIa
p8BDMGt8BGM5NGXpm0yqBASgXmn+PMNMPFjP+PHH1hMNiZrnf31ujH3b9E3N6yMG
VRLyrrQH0yskR72vxmhMntv6UN/PMvi0YLUXg6acEOjJJpMjWY2PKUAAPeHQWdc3
e9LPeLrdKc6PXQmN3WKM3APASfAeq3+hySDXb5T0efUEJbXo28zUnTJkW/sXpajo
PcvxwxT/v4vl85v4YBO00G76XJMYKEy4P3CX2ebIk0MEp3/h0c6r8EES7nVY9kmP
O2hllc17iDHacjCtgv+jaVCBfIHsnkDWqxm2MPGivVMeZsaChbVk1+D39E6WjPk=
=R77u
-----END PGP SIGNATURE-----

--k9ssVBY1NpawPNl1--
