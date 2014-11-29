Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaK2Lwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 06:52:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43151 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaK2Lwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 06:52:45 -0500
Date: Sat, 29 Nov 2014 11:52:09 +0000
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
Message-ID: <20141129115209.GD7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <7202604.4LK4s7RH1S@vostro.rjw.lan>
 <20141128160036.GW7712@sirena.org.uk>
 <2127240.rWRTDu6LHQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9GYGtdBumnmR69ER"
Content-Disposition: inline
In-Reply-To: <2127240.rWRTDu6LHQ@vostro.rjw.lan>
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


--9GYGtdBumnmR69ER
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2014 at 12:51:59AM +0100, Rafael J. Wysocki wrote:
> On Friday, November 28, 2014 04:00:36 PM Mark Brown wrote:

> > OK, we probably should have one to aid discoverability since as far as I
> > can tell what's happening is that people (hi Intel!) are allocating
> > their own identifiers for devices produced by other vendors that turn up
> > on their boards.  If people can find the set of IDs in use there's more
> > chance they'll use the same ones as other people.

> There's the PRP0001 ID that can be use to in combination with the
> "compatible" property which then works the same way as for DT.

> That should be sufficient if the properties are going to be the
> same for ACPI (_DSD) and DT.

We've got people making BIOSs right now for systems you can actually buy=20
that are intended to run Windows which we need to support; right now the
pressing problem I'm seeing is that we've got BIOS vendors not using
properties at all and we're going to be ending up with configuration
coming from big DMI tables instead which is miserable, Windows is
perfectly happy to have custom drivers installed per machine.  Do we
know if Windows supports PRP0001 as it currently stands?

> > If those are device IDs then what you're saying is what I'd expect to
> > happen and it's part of the reason I'd expect us to be registering IDs
> > along with registering properties - if people are defining device
> > specific properties they really ought to be tied to the IDs that are in
> > use especially if (as seems likely to be the case with the current state
> > of the world) people are doing things without attempting to coordinate
> > and we're ending up trying to document the deployed reality.

> The rule of thumb (in my view) should be that if the device object's _DSD=
 is
> going to return the same set of properties as for DT and no other special
> handling determined by the ID is required (ie. nothing along the lines of
> "if the device ID is X, the _ABC method works like that" which has to be =
known
> by the driver), "PRP0001" should be returned by _HID and then the value o=
f the
> "compatible" property should be the same as for DT.

This is a reasonable idea but we do need it to be compatible with
Windows and we still need to make sure we have a process in place that
BIOS authors and driver authors focused on Windows can reasonably be
expected to work with.  That's not something we have right now for DT
(our DT process involves contributing to Linux) so the problem remains
effectively the same.

We also need a way of getting the word out to people that they should be
doing this (also a problem no matter if we use PRP0001 or something UEFI
specific).

> Otherwise, a new device ID needs to be allocated for the device and _HID
> should return that ID.  Also, if the device is compatible with another
> device with an already allocated ID (for _HID), _CID may return the devic=
e ID
> of the compatible device.  [Of course, it's better if _HID is the same for
> identical devices.]

I honestly don't see BIOS authors as being likely to care about adding
things to the CID if their systems are working (I'm assuming that HID is
the primary device ID and CID are further backup compatible IDs).

--9GYGtdBumnmR69ER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUebNoAAoJECTWi3JdVIfQA4oH/2mXNQW9mhqDg1f8FCkZRN7S
2zDyp4oth2YQSVN94nqlyqU3k1lZVNZ0dvhf3bWvrcuJgEJ20ZN8ZIAJ9n8JcDtl
UNcNMGIObUge06gW1bhPG7YjsE9ldnrm4wqpkDFG8fVithcRxHbzeY/sulrc2iPP
fvCyCMn5vtTKgtEwDB7v+F+9gX4RPBcKFIrYYjmgivy3AeNsjXINtLiRMXewxqdv
e0CVcuLyN71uouSy/1mDQ1u9diENyczdJHAXrN3K3NtmgxsNvHI1QnnCpPXEbXFC
P3S0dnhEdSIuhkyE20Wcamo9Un+rgQFahNt5tl0HOpMS3U1ODRQNP9vWBMisYlw=
=HFsa
-----END PGP SIGNATURE-----

--9GYGtdBumnmR69ER--
