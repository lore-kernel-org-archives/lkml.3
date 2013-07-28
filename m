Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3G1MKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 08:10:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47030 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3G1MKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 08:10:53 -0400
Date: Sun, 28 Jul 2013 13:10:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Message-ID: <20130728121021.GN9858@sirena.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726045433.GB4100@netboy>
 <20130726171524.GB28895@obsidianresearch.com>
 <20130727085259.GA6207@netboy>
 <20130727113602.GD9858@sirena.org.uk>
 <20130727180752.GB4813@netboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/45fpkxfdnDqFSDa"
Content-Disposition: inline
In-Reply-To: <20130727180752.GB4813@netboy>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/45fpkxfdnDqFSDa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 27, 2013 at 08:07:54PM +0200, Richard Cochran wrote:
> On Sat, Jul 27, 2013 at 12:36:02PM +0100, Mark Brown wrote:

> Yes, lets, and remember the question was, why do I say that dealing
> with DT is such a PITA.

There are definite issues with DT (getting a good process for quality
bindings together being the major one, and we're still working on some
of the subsystem bindings) but we shouldn't conflate other things with
those.  What you and others are saying about the need for a stable ABI
for DT is correct but we're going off on tangents here.

My read on what you're saying is that it's more to do with bleeding edge
stuff being painful than it is to do with DT itself; DT gets mentioned a
lot because it is an active area of development and gets used a lot
during bringup but it's not the cause.

> > >   http://www.spinics.net/lists/arm-kernel/msg198431.html

> > This actually sounds pretty good - glancing over the thread it seems you
> > were trying to boot a shiny new board that people were in the process of
> > trying to upstream support for and were just a bit too early.  Device
> > tree doesn't seem to have made a difference either way here.

> Did you miss the part about CONFIG_ARM_APPENDED_DTB?

It didn't seem terribly relevant - it's a feature if people and/or
systems want to use it.

> > >   http://www.spinics.net/lists/linux-omap/msg79731.html

> > Paul's reply here seems fairly clear - someone had merged a driver which
> > had been developed in an out of tree or pre-DT environment without DT
> > support so they just hadn't added DT support.  Sadly doing that is new
> > feature development and so not appropriate for the stabalisation phase
> > of development.

> This is me asking for maintainers to take patches to fix a driver in
> version v3.7 where the driver merged in v3.4.=20

> The patches contain the missing DT part, and the maintainer rejects
> them, saying, no new features!

> Q: What the heck kind of process is that?
> A: DT process.

No, this is nothing to do with DT - this is just the general kernel
development process.  DT was a new feature for that driver (which
would've been merged a year or so before we got our first DT only ARM
platform...), it's unfortunate that you needed it for your system since
it was a DT only system but it's still a new feature with respect to the
driver.

> Seriously, why is it too hard for y'all to insist on merging drivers
> only when they are really, truly ready (and don't forget the DT part,
> please).

There's a couple of things there.  One is that subsystem maintainers
have no real way of telling if a driver actually works unless they
happen to have a system they can test it on.  For the most part that's
just not the case so we have to trust that someone will say something if
there's a problem.  We can spot some problems through review but there's
a huge set that just won't be obvious without knowledge of the hardware.

The other is that a partially featured driver in the kernel tends to be
a better thing for development than something out of tree - if it's
useful for someone that's great and it provides a starting point for
someone else to come along and add more features.  So long as it's not
causing problems at a subsystem level it's generally better to have it
than not, that way other people can come along and incrementally improve
the driver without having to work out some way of collaborating out of
tree.

You mention DT specifically here - obviously a lot of platforms don't
require DT (only some architectures use it at all) so it can't be a
requirement for drivers and if someone's done the work to get the
hardware working it seems more useful to get that merged and then let
someone who cares about DT add the bindings later.

> > > * When people try in good faith to conduct methodical boot tests,
> > >   DT is working against them.

> > >   http://www.spinics.net/lists/linux-omap/msg79960.html

> > Again I don't see anything particularly related to DT here but instead
> > do with using a SoC and board that are in the early phases of mainline
> > integration.

> It is ring around the rosie, DT, boot loader, and kernel.

> Understandably, Paul doesn't want to upgrade his boot loader. He says
> he is "not interested" in testing the boot loader, just the kernel.
> And, if you follow the sage of Paul's test reports, you will find him
> being told to update his boot loader and not to forget the delete old
> dtb files.

> So, like I said, it is a pity PITA.

New systems especially those using new SoCs generally are a pain; had
the issues not mentioned DT they might well have been something else
like missing pinmux in the bootloader, some bit of kernel functionality
not being merged yet or something else.  The flow of discussion there
looks very familiar to me from way before DT was talked about for ARM -
it reminds me a bit of some work I did before even PowerPC adopted DT!

--/45fpkxfdnDqFSDa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9QopAAoJELSic+t+oim9uw8P+QHDaIxqXS+8KxLaDwyz0fai
PsGt7fJ5oDvbLzBGPlat2jB/GqogFPlsao64BEY4B3UoKC3NmqMOWehRKW3cscsX
Kvkp+eoOuvZxjYrqm7qfvB9S0jOhwtoUy4pH2MbMqRlZerlhELmArrOs/hZz1rJ6
/JfTRgBRbQQQLq732Kv0OcOMZByUSTdc4/PCoFEyPtZsACIIn/rSjNBCT+/eFgaR
4LCT1lCXYjuw9xznPx3DbX9mnP/9Mf7RwmeSSMqF5ujsKcb0sOnBGgCR4fM2+ic+
VfyBWvOBAkRnDkI7HubWHgZ1RKDvsihBMjoP5URd2kn8+aigY3Gvxrsg/k/GOYOI
0sVhYnu1Nsrq8DTjv0RhxJmhJjSc/sAyesf0MTAs4b98zqgc+RWCr9GC45bpvb+B
elv9jY2Z/BvVkG4YJHLIkKslTQRG816Q6IeiMOGeiQP824jch6fhWQZ89BWwjgNd
AbgB28DcbIgyBIVyHxfY4HGGg86U14md/x2ovwnNAwgqm1XHlQYROPw7JmpBNENM
qwKYP4oQlg1mJokJjQJ04lYz5HV46udpC4r5lIAz6K2vfNI/0UE496+EnIfO7jI3
BCwYMthb7C1XPQmTwCbDYkEy3cFo59bAUfpzt27xWEtJ0hZHWmptzEzvqR7ul//1
ySSn9OBgzHIhUqErhq96
=T8zV
-----END PGP SIGNATURE-----

--/45fpkxfdnDqFSDa--
