Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3BDPnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:43:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41590 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab3BDPm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:42:58 -0500
Date: Mon, 4 Feb 2013 17:41:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Felipe Balbi <balbi@ti.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
        Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, "Cousson, Benoit" <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130204154153.GA18237@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
 <1359742975-10421-2-git-send-email-mporter@ti.com>
 <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com>
 <20130201184915.GP2244@beef>
 <510C1D0E.6030401@mvista.com>
 <20130201185820.GE29898@arwen.pp.htv.fi>
 <510C2A47.1090607@mvista.com>
 <20130201205600.GA31762@arwen.pp.htv.fi>
 <20130201213003.GW2637@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20130201213003.GW2637@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 01, 2013 at 09:30:03PM +0000, Russell King - ARM Linux wrote:
> > > > I guess to make the MUSB side simpler we would need musb-dma-engine=
 glue
> > > > to map dmaengine to the private MUSB API. Then we would have some
> > > > starting point to also move inventra (and anybody else) to dmaengine
> > > > API.
> > >=20
> > >    Why? Inventra is a dedicated device's private DMA controller, why =
make
> > > universal DMA driver for it?
> >=20
> > because it doesn't make sense to support multiple DMA APIs. We can check
> > from MUSB's registers if it was configured with Inventra DMA support and
> > based on that we can register MUSB's own DMA Engine to dmaengine API.
>=20
> Hang on.  This is one of the DMA implementations which is closely
> coupled with the USB and only the USB?  If it is...
>=20
> I thought this had been discussed _extensively_ before.  I thought the
> resolution on it was:
> 1. It would not use the DMA engine API.
> 2. It would not live in arch/arm.
> 3. It would be placed nearby the USB driver it's associated with.
>=20
> (1) because we don't use APIs just for the hell of it - think.  Do we
> use the DMA engine API for PCI bus mastering ethernet controllers?  No.
> Do we use it for PCI bus mastering SCSI controllers?  No.  Because the
> DMA is integral to the rest of the device.

that's not really a fair comparison, however. MUSB is used with several
DMA engines.

The only DMA engine which is really coupled with MUSB is the Inventra
DMA engine which comes as an optional feature to the IP. Many users have
opted out of it. From the top of my head we have CPPI 3.x, CPPI 4.1,
Inventra DMA, OMAP sDMA and ux500 DMA engines supported by the driver.

Granted, CPPI 4.1 makes some assumptions about the fact that it's
handling USB tranfers, but nevertheless, the IP can be, and in fact is,
used with many different DMA engines and driver needs to cope with it.

Current DMA abstraction is quite poor, for example there's no way to
compile support for multiple DMA engines. Code also makes certain, IMO
unnecessary, assumptions about the underlying DMA engine (abstraction is
poor, as said above but it we could follow MUSB's programming guide when
it comes to programming DMA transfers).

Considering all of the above, it's far better to use DMA engine and get
rid of all the mess.

--=20
balbi

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD9bBAAoJEIaOsuA1yqREHr0QAIN9sPE+HWMHWgt6/r5f97Wd
hlwJOmsHdNpy2Sr5DhUqBSTSAyC6F/6hmNAxJHt3ksg2sOHoxhF0MV1OWPAyeRym
DRiLJu3kC1y6NcxHofiEvW5lE3QkkdpMYipz9q2QVOuWw8mps67qimmk8Wj1zgID
zBOBWiWlq3NgYVXyBsjAUTpUuSt5ZGJ5qqLutzhJwm070rgqTsqcRnKgRvkmb6lE
nqhk3HTrkFrZ/zfO1vt4HFMcOriLRIVOvLxXzQsU+FJuzdlO8KtcknMch6CISVX3
viOPyxwutfs+XeWwwW7DlNn5pGWExW34HpJkAHB+tawpHkck9Obw+gxlvOu2HANY
XN9EPDrwZRZegWasrrQHXfOhVaPy0OCDUTjyzeBEHQg7sK1y4zRFWOHaJlrv30Jn
Bke7Tmj8kSuhRJkjOX7TbUhZa+plKr+YZN9VnUhz4KoiTfS8VsdgBzoDprO+R41W
k0pjIH/IG5b7bUxs5JnWmDFNhQ394WzCAshbKJQHfSGnf9C4p36ysTAaPnIuOXCv
pzWEu2Fbq9YASj5KE2xcFngnYwoz2+hsDATG4eMYzJXh+U00/GU9OvnY0WfnPyHO
JOeG2OVpTiI+cthakJ6ee2y4w2zMeBwJdR317Rm/0D+/KvbDnDx/QxLNa4L/FtN6
qO45LowEcZb5/rQEN7rV
=Dvxb
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
