Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaAaVp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:45:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38843 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbaAaVp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:45:56 -0500
Date: Fri, 31 Jan 2014 15:44:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [RFC/PATCH] base: platform: add generic clock handling for
 platform-bus
Message-ID: <20140131214405.GC2502@saruman.home>
Reply-To: <balbi@ti.com>
References: <1391191965-31102-1-git-send-email-balbi@ti.com>
 <Pine.LNX.4.44L0.1401311614100.12368-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401311614100.12368-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 31, 2014 at 04:34:27PM -0500, Alan Stern wrote:
> On Fri, 31 Jan 2014, Felipe Balbi wrote:
>=20
> > Still TODO a commit log. Not for merging!!!!!
> >=20
> > NYET-Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >=20
> > This patch is an idea I've had recently in order to combine several dif=
ferent
> > PM implementations into the platform-bus.
> >=20
> > This patch is bare minimum for platforms which need to handle functiona=
l and
> > interface clocks but the whole thing is made optional.
> >=20
> > Note that this patch makes sure that by the time a platform_driver's pr=
obe is
> > called, we already have clocks enabled and pm_runtime_set_active() has =
been
> > called, thus making sure that a device driver's pm_runtime_get_sync() w=
ill
> > solely increase the pm usage counter.
> >=20
> > I have *NOT* tested this anywhere *YET*, but I suppose it shouldn't cau=
se any
> > issues since the clock API has ref counting too.
> >=20
> > Would really like to get some review from several folks involved with A=
RM SoC
> > PM so that's the reason for the wide audience. If I have missed anybody=
, please
> > add them to Cc.
> >=20
> > As mentioned above, this is *NOT* meant for merging, but serves as a st=
arting
> > point for discussing some convergence of several PM domain implementati=
ons on
> > different arch/arm/mach-* directories.
>=20
> You might want to copy the runtime-PM approach used by the PCI=20
> subsystem.  It works like this:
>=20
> 	The core invokes a driver's probe routine with runtime PM=20
> 	enabled, the device in the ACTIVE state, and the usage counter=20
> 	incremented by 1.
>=20
> 	If the driver wants to support runtime PM, the probe routine
> 	can call pm_runtime_put_noidle.
>=20
> 	The core does pm_runtime_get_sync before invoking the driver's
> 	remove routine.  At this point a runtime-PM-aware driver whould=20
> 	call pm_runtime_get_noresume, to balance the _put during probe.
>=20
> 	After invoking the remove routine, the core does a put_noidle
> 	(to balance the get_sync) and a final put_sync (to balance the
> 	increment before probe and to leave the device at low power.)
>=20
> A nice consequence is that everything is transparent for drivers that=20
> don't support runtime PM.  The usage counter remains > 0 the entire=20
> time the driver is bound.
>=20
> Conversely, drivers that do support runtime PM merely have to add one=20
> call during probe and one during remove.
>=20
> There is one tricky aspect to all this.  The driver core sets the
> dev->driver field before calling the subsystem core's probe routine. =20
> As a result, the subsystem has to be very careful about performing
> runtime PM before invoking the driver's probe routine.  Otherwise you
> will end up calling the driver's runtime_resume callback before the
> driver's probe!  (And of course, the same problem exists in reverse
> during remove.)

I can, certainly, do that and that would, most likely, simplify a whole
bunch of drivers. But that change, I suppose, would be a whole lot more
invasive. I'll spend some time studying PCI pm_runtime support, thanks
for the tip.

cheers

--=20
balbi

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS7BklAAoJEIaOsuA1yqREBV4P/2Y7SWU4tvML4whSd0CaXAXP
r37bsQ70osNklLjaYhpG9d5mKonRmgJRTaFVxdKDIe9D2mQJNvw7tUGrUtO1YU7C
7v1NQuKUAmOBV6S7E+7r5SuL9WukeVEFoyCmltJzZXmNOEUiLd4hpaQGsisplJ+I
z8vo2QaLPW5ZBdv+i7Cck6zP+4jG5QPVPffFIDByry54DPZK0XHVXPHngdybf2IK
GCUjBGZoZfJy0TqtJA1my39ZRiB0TSyx2bK43mc83Jymm/XIvrRbVojbQqMK2eo1
hUdWG50FPpF8KI/Ops/BFuA/p3UsJkblFfspAiCG65Gz1fyBsMjdIH3UiNhMflHS
AN9/2Do2kkIxtflxWRoIWRY+xWNlvr5IZpN9TZ1P6ppQPbMwHhEXFa7XfAjKRMOR
/4P+0YHC6/0q+JQD/0lPXwt6vt4nYhvYkN2nN/hu0h1NKB8ntU0PHRGrxwdLovgO
CyOBVISQMWLo5msIyVRaZnZKIR3b2ZCIWxx8hELGAuOZsDuXwfSdNpMIwR7IhMV6
kk65wfyUKspp+apAW61OdZE6RlkpxLl7ir0kHz9PhkFw9UZbmSkvZpQRvwf6vOFz
/mzNqgD0G+lVyowMdh3hd1+bEdxmlLToNjjAPRkvrmcc5/U3cVd3hkSFS2GVSq9l
ySAjtK4bdtez7UXsLGcv
=CGs4
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
