Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaG2PU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:20:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45694 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaG2PU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:20:57 -0400
Date: Tue, 29 Jul 2014 10:19:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 30/35] irqchip: add irq-omap-intc.h header
Message-ID: <20140729151936.GC17808@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-31-git-send-email-balbi@ti.com>
 <20140729120133.GQ29045@atomide.com>
 <20140729141045.GA17808@saruman.home>
 <20140729150655.GU29045@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <20140729150655.GU29045@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 08:06:55AM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [140729 07:13]:
> > On Tue, Jul 29, 2014 at 05:01:33AM -0700, Tony Lindgren wrote:
> > > * Felipe Balbi <balbi@ti.com> [140728 14:19]:
> > > > OMAP INTC irqchip driver will be moved under
> > > > drivers/irqchip/ soon but we still have a dependency
> > > > with mach-omap2 when it comes to idle functions.
> > > >=20
> > > > In order to make it easy to share those function
> > > > prototypes with OMAP PM code, we introduce this new
> > > > header.
> > > >=20
> > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > ---
> > > >  arch/arm/mach-omap2/board-3430sdp.c        |  1 +
> > > >  arch/arm/mach-omap2/board-am3517crane.c    |  1 +
> > > >  arch/arm/mach-omap2/board-am3517evm.c      |  1 +
> > > >  arch/arm/mach-omap2/board-cm-t35.c         |  1 +
> > > >  arch/arm/mach-omap2/board-cm-t3517.c       |  1 +
> > > >  arch/arm/mach-omap2/board-devkit8000.c     |  1 +
> > > >  arch/arm/mach-omap2/board-ldp.c            |  1 +
> > > >  arch/arm/mach-omap2/board-omap3beagle.c    |  1 +
> > > >  arch/arm/mach-omap2/board-omap3logic.c     |  1 +
> > > >  arch/arm/mach-omap2/board-omap3pandora.c   |  1 +
> > > >  arch/arm/mach-omap2/board-omap3stalker.c   |  1 +
> > > >  arch/arm/mach-omap2/board-omap3touchbook.c |  1 +
> > > >  arch/arm/mach-omap2/board-overo.c          |  1 +
> > > >  arch/arm/mach-omap2/board-rx51.c           |  1 +
> > > >  arch/arm/mach-omap2/board-ti8168evm.c      |  1 +
> > > >  arch/arm/mach-omap2/common.h               |  9 ---------
> > > >  arch/arm/mach-omap2/cpuidle34xx.c          |  1 +
> > > >  arch/arm/mach-omap2/irq.c                  |  1 +
> > > >  arch/arm/mach-omap2/pm24xx.c               |  1 +
> > > >  arch/arm/mach-omap2/pm34xx.c               |  1 +
> > > >  include/linux/irqchip/irq-omap-intc.h      | 32 ++++++++++++++++++=
++++++++++++
> > > ...
> > >=20
> > > > +void omap2_init_irq(void);
> > > > +void omap3_init_irq(void);
> > > > +void ti81xx_init_irq(void);
> > >=20
> > > I think these will all go away with DT based booting?
> > > So it might be worth waiting for that rather than churn
> > > all these files, or..
> >=20
> > you just asked me to rebase this series because now we had OMAP3 idle
> > working with DT. And now, you're asking me to hold on to this series
> > because not everything is DT-based yet.
>=20
> I just don't like the idea of patching all these board files that
> are going away anyways. If we need to do that, let's just add it

when are they going away ? Are we really gonna delay this series until
those board-files eventually vanish ?

> to common.h that's already included by all the remaining board-*.c
> files. I know we should rather include the files directly, but in
> this case that's just extra churn.
>=20
> The real problem is how to properly deal with the save and
> restore calls that idle code needs.

well, for system sleep we have callbacks from irq generic itself. The
real problem is just with runtime PM.

> In any case, it seems we can merge quite a bit of this series
> already and then deal with the problem parts.

sure, it at least some of those patches get merged, then it's less crap
for me to rebase every now and again.

> > This is the third time I rebase the series after a long hiatus and it
> > always comes out to the same result -> "let's wait some more".
>=20
> Nope, it's always been "this series causes PM regressions"

you just said that we haven't been in any position to really test this,
so can it be that the status has always been "this series causes PM
regressions". We couldn't test that before, right ?

> and few other minor comments. And we have not been in any
> position to really test that until with v3.16-rc4. And then
> you always run out of time and nobody else does anything :)

sure, I have other stuff to do as well.

--=20
balbi

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT17uIAAoJEIaOsuA1yqREu+wQAKp0vxeRKSvIRWGcpFowY2QV
9miirsvWCJjbs1y6PunDefjBDv22uej1kLs9xwPN1dUn2pUysKCCTTP4xDBXJxzS
XSqfvNU4rEuaig0u5j5Net1mR/JdHWILCYLTdKz2KDKJ4fTBdkjw7KlSODGPbqL5
/EJsmvbb485G4y0f3vuLuSyLBQUU+05LxHBvSeW1ffs2XQHe895ot/lsfB9oRKzp
1F/mcZUx/UfjGhwzob/hRbMTlrFOER9ThsJZMETy9w/RYIWO+2Va9C+DFVt1rRNa
0awNWwVIRExyV1Iz/nNjsndcpOhcnNLMV0DUbmBlWjeeXTpb5lTOflyd0Gf8N8NV
eder4Rly2UI7utK5MwPUw6ps0Cy6cR6Sbt2eoLJCcUU6o6BRoTTWHT8TuTJEDwmy
PggpPxmzpWWeEjUAdiHdvxbooQzv/Wlu0Yx6+D0u4Q70s4Bn2mlk2H0J2UaJKKNA
sqrCOmSnxjCw5b8kCBPIvZcVLn4iLcUeD2VWOxI4umV2CXInkKKdUsXfHd7iqfWB
Wrb51CSvOdI3opk0JOI8mQE1h8YdkafxniQEeSs9y2R7ESNDn9dFvUhrYdPWZqZg
QgTskPOX08Py7bYnwo8pnOILC42cWKHY+PS40tkRVWr85uRMWQZqHO5zKYqWnmxI
fwTUlKnk7nmjvUPqjBQR
=EGxO
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
