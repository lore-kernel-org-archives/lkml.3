Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbaLAWTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:19:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45487 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaLAWTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:19:31 -0500
Date: Mon, 1 Dec 2014 22:19:07 +0000
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
Message-ID: <20141201221907.GR7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <1820241.GUleD5gbzs@vostro.rjw.lan>
 <20141201175100.GH7712@sirena.org.uk>
 <1437951.HUEy7xa933@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wBRMoyAtsbmwI0yu"
Content-Disposition: inline
In-Reply-To: <1437951.HUEy7xa933@vostro.rjw.lan>
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


--wBRMoyAtsbmwI0yu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 01, 2014 at 11:16:31PM +0100, Rafael J. Wysocki wrote:
> On Monday, December 01, 2014 05:51:00 PM Mark Brown wrote:

> > The dream here is that people working on building systems, people
> > working on Windows drivers and people working on Linux drivers will at
> > some point be able to collaborate. If we're going to go off and do our
> > own thing for Linux without talking to anyone that's not really addressing
> > the issue.

> Well, that's already going on in the DT land, isn't it?  It has been going on
> for quite a while AFAICS.

In theory (and where it's actually relevant in practice to at least some
extent) this stuff is all OS neutral, there's a definite willingness for
it to be so.

> > There's also the option that Windows drivers start using _DSD themselves
> > which is, I understand, the goal towards which the people working on at
> > least audio are heading.

> Technically, Windows driver writers can evaluate _DSD and handle the
> information the way we do, but I'm not sure if this is really convenient for
> them.

I'm not sure how convenient it is, though I'm reasonably sure a helper
library could make it so.

> We use _DSD, because we want drivers to work with DT as well with ACPI without
> adding special DT-specific or ACPI-specific code to them.  The people who work
> on Windows drivers don't have this problem, so as I said, if they care about
> Linux at all, that may be a good enough motivation for them to look at _DSD,
> but if they don't, I honestly don't see why they would do that.

They care about getting properties out, or at least they should, and in
this market many of the device vendors care about Linux at least as much
as they do Windows (sometimes even more than they care about Windows,
there's overlap with the Android market).

> > Note that all this discussion is pretty much about drivers for single
> > devices which can be wired into the system in a flexible manner, even in
> > a Windows world you won't vary the device ID.  At present we're quirking
> > on DMI.

> So the answer to that in my view is: Use _DSD and allocate your own device IDs
> for Windows drivers to bind to.

Right, so we circle back to the original question about documenting
those IDs and _DSD properties.  :)

> > > > We also need a way of getting the word out to people that they should be
> > > > doing this (also a problem no matter if we use PRP0001 or something UEFI
> > > > specific).

> > > What do you mean by "something UEFI specific"?

> > Sorry, I mean ACPI specific (UEFI forum).

> Do you mean a special device ID of some sort, then?

No, just a regular one.

> > It's not just the device IDs you need, it's the properties too.

> I suppose you have some specific examples in mind that I may not be familiar
> with and we may spend an arbitrary amount of time speaking past each other. :-)

Things like Documentation/devicetree/bindings/sound/wm8962.txt (at least
the optional properties), basically "how is this device wired into the
board" properties.

> That's where we are today.  Do you have any suggestions on what else we can do?

I'd like to see a space where people working with a device can publish
what they've done in terms of firmware binding for it in a manner that
might work for them; at present it seems like the UEFI forum is the best
place to start doing that, there's the start of a register and process
for updating it there at least.

--wBRMoyAtsbmwI0yu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfOlbAAoJECTWi3JdVIfQuBMH/RxtbwTXic0lu7vaq06vzh/g
lZyQPL5wjJNt/tcsqDRw3LNC+heau1YFqGj/lU4tIdjmKwmKEwXmS7Lmnf1Uu4mR
gBl0RLjkuTG4WjO6W7Nht5gGYruevbubxYLIU3zeg+FoHC6amvXlX63blCoEENo4
ncGYS0tzqhnfRDKm6dXHzKGJt5mzaPVKBiBa+K20oUZY3byCBc6iCS/o7fY95Zmg
KNH3/uUOPeSOhsiTwH1e9aaYhd4eyEQZs1UYF3Asbv31YK1VbqqdscDckqt2bEro
J/NaCQfJaa4tcM/gJ12uYZXszhbILmMS1rjxZwuW6h66YxRyNH7QRcXD4EdBwiw=
=5o5C
-----END PGP SIGNATURE-----

--wBRMoyAtsbmwI0yu--
