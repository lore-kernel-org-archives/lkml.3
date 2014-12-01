Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaLARvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:51:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45267 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbaLARvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:51:36 -0500
Date: Mon, 1 Dec 2014 17:51:00 +0000
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
Message-ID: <20141201175100.GH7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <2127240.rWRTDu6LHQ@vostro.rjw.lan>
 <20141129115209.GD7712@sirena.org.uk>
 <1820241.GUleD5gbzs@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MRL9B5bOucwGAkwp"
Content-Disposition: inline
In-Reply-To: <1820241.GUleD5gbzs@vostro.rjw.lan>
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


--MRL9B5bOucwGAkwp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 29, 2014 at 11:27:52PM +0100, Rafael J. Wysocki wrote:
> On Saturday, November 29, 2014 11:52:09 AM Mark Brown wrote:

> > > There's the PRP0001 ID that can be use to in combination with the
> > > "compatible" property which then works the same way as for DT.

> > > That should be sufficient if the properties are going to be the
> > > same for ACPI (_DSD) and DT.

> > We've got people making BIOSs right now for systems you can actually buy=20
> > that are intended to run Windows which we need to support; right now the
> > pressing problem I'm seeing is that we've got BIOS vendors not using
> > properties at all and we're going to be ending up with configuration
> > coming from big DMI tables instead which is miserable, Windows is
> > perfectly happy to have custom drivers installed per machine.  Do we
> > know if Windows supports PRP0001 as it currently stands?

> No, it doesn't.

> Separate device IDs are necessary for Windows compatibility AFAICS.

OK, then PRP0001 is a complete non-starter for the applications I'm
looking at.

> But that also means any device ID registered by us won't be suitable in that
> case, because Windows won't use it.

The dream here is that people working on building systems, people
working on Windows drivers and people working on Linux drivers will at
some point be able to collaborate.  If we're going to go off and do our
own thing for Linux without talking to anyone that's not really
addressing the issue.

> There are two different problems here, though.  The first one is a way to
> provide the existing Linux drivers with the information expected by them via
> ACPI and that's what _DSD (plus PRP0001 optionally) is.  The second one is
> to be able to handle systems with ACPI tables from a random vendor who only
> cares about Windows and that's more difficult to address, because our
> ecosystem is different from theirs.

> There basically are two ways around that.  The first one is to have all
> knowledge related to device IDs in drivers (which effectively is what
> Windows does and which implies "board files" of sorts) and the second one is
> to make it possible to use overlays on top of the existing ACPI tables that
> will allow people to provide the properties expected by a more generic driver
> (this way, if the vendor didn't care to provide _DSD, for example, in the
> original ACPI tables, the system integrator would be able to use an overlay
> in an initramfs or boot partition to amend them).

There's also the option that Windows drivers start using _DSD themselves
which is, I understand, the goal towards which the people working on at
least audio are heading.

> There is a plan to do the latter, but that is going to take some time to
> complete.

Like I keep saying we have people trying to ship systems now, you can
buy affected systems already and there's going to be more coming and I'm
not convinced it's going to be fun for system integrators (distros?) to
have to quirk every system that comes out.

> > This is a reasonable idea but we do need it to be compatible with
> > Windows and we still need to make sure we have a process in place that
> > BIOS authors and driver authors focused on Windows can reasonably be
> > expected to work with.  That's not something we have right now for DT
> > (our DT process involves contributing to Linux) so the problem remains
> > effectively the same.

> We can't make Windows use our stuff and they have a different model
> (a custom driver per device ID vs a common driver per IP block possibly
> matching multiple device IDs).

The hardware already doesn't match the Windows model well here, it's
causing them some problems too (and it's making life miserable for the
CODEC vendors who want to ship both Windows and Linux drivers too).  We
should at least try to pull things together so we get something that
works for everyone; in Linux we have quite a bit of experience with this
sort of system which we can hopefully share with the Windows people to
help make everyone's lives better.

One of the things that would help this would be if we were able to give
people a way to write their ACPI tables in a way that is likely to both
work well for us and avoid lots of make work for the Windows people.

Note that all this discussion is pretty much about drivers for single
devices which can be wired into the system in a flexible manner, even in
a Windows world you won't vary the device ID.  At present we're quirking
on DMI.

> > We also need a way of getting the word out to people that they should be
> > doing this (also a problem no matter if we use PRP0001 or something UEFI
> > specific).

> What do you mean by "something UEFI specific"?

Sorry, I mean ACPI specific (UEFI forum).

> > > Otherwise, a new device ID needs to be allocated for the device and _HID
> > > should return that ID.  Also, if the device is compatible with another
> > > device with an already allocated ID (for _HID), _CID may return the devic=
> > e ID
> > > of the compatible device.  [Of course, it's better if _HID is the same for
> > > identical devices.]

> > I honestly don't see BIOS authors as being likely to care about adding
> > things to the CID if their systems are working (I'm assuming that HID is
> > the primary device ID and CID are further backup compatible IDs).

> They will if they care to be compatible with old (binary) OSes that didn't
> know about the new device ID, but shipped drivers that could handle the
> device (although possibly in a "crippled" way).

It's not just the device IDs you need, it's the properties too.

--MRL9B5bOucwGAkwp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfKqDAAoJECTWi3JdVIfQcKwH/05riiu24ZTOgoDUj5bCbF+q
oG07cTC2XFb0Si8pg1Bz2gYiykw3DCWA+Fx47rjZP+2EKuR5sFWXmurtDVJv4/Hh
HwjKa9dvGiSx3KfLm6YRdAxXc3zM0JMhAANs2Jdz22Wr1WWIZAebHkAdlJNq1niT
D81usZzcsso/rKMdOQ7yBf31YW0hHWoXaPxizLAQTkZ/VGxSuZ/n1pLkxp1Eftir
uTHjlDQhNi4Fgq6z8h8aqjhXg9h8q3nOpt+JNKsKBIrlbW+ztu2gLRIMv3gMZgwb
ga9BSia+vHXWCQ3l/wSkf6SPtDfeO8l4MIwgj48jNJWLeyuBG06VIR04NSu6Jzc=
=7/my
-----END PGP SIGNATURE-----

--MRL9B5bOucwGAkwp--
