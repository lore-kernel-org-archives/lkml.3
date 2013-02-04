Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab3BDQrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:47:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43792 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3BDQrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:47:49 -0500
Date: Mon, 4 Feb 2013 18:47:12 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: <balbi@ti.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
Message-ID: <20130204164712.GB4269@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359742975-10421-2-git-send-email-mporter@ti.com>
 <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com>
 <20130201184915.GP2244@beef>
 <510C1D0E.6030401@mvista.com>
 <20130201185820.GE29898@arwen.pp.htv.fi>
 <510C2A47.1090607@mvista.com>
 <20130201205600.GA31762@arwen.pp.htv.fi>
 <20130201213003.GW2637@n2100.arm.linux.org.uk>
 <20130204154153.GA18237@arwen.pp.htv.fi>
 <510FF1A6.403@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <510FF1A6.403@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 04, 2013 at 08:36:38PM +0300, Sergei Shtylyov wrote:
> > opted out of it. From the top of my head we have CPPI 3.x, CPPI 4.1,
> > Inventra DMA, OMAP sDMA and ux500 DMA engines supported by the driver.
>=20
> > Granted, CPPI 4.1 makes some assumptions about the fact that it's
> > handling USB tranfers,
>=20
>    What CPPI 4.1 code makes this assumptions? MUSB DMA driver? Then it's =
just

HW makes the asumptions

> > but nevertheless, the IP can be, and in fact is,
> > used with many different DMA engines and driver needs to cope with it.
>=20
>    What IP, CPPI 4.1 or MUSB?

MUSB

> > Current DMA abstraction is quite poor, for example there's no way to
> > compile support for multiple DMA engines. Code also makes certain, IMO
> > unnecessary, assumptions about the underlying DMA engine (abstraction is
> > poor, as said above but it we could follow MUSB's programming guide when
> > it comes to programming DMA transfers).
>=20
>    Don't know, I was quite content with the abstraction when writing CPPI=
 4.1
> driver for MUSB...

look closer. The whole:

if (is_cppi())
	foo();
else if (is_inventra())
	bar();
else if (is_omap_sdma())
	baz();

is bogus.

> > Considering all of the above, it's far better to use DMA engine and get
> > rid of all the mess.
>=20
>    In my eyes, getting rid of the mess doesn't justify breaking the rules=
 that
> Russell formulated above.

MUSB is no PCI, there is no single, standard interface to the DMA
engine (unlike Synopsys' dwc-usb3 and dwc-usb2, where we don't use DMA
engine), every DMA engine comes with its own set of registers, its own
programming model and so forth.

--=20
balbi

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD+YQAAoJEIaOsuA1yqREBdEQAIdS03SIpNCILhGxYd5xrVgC
pWFFJc/tQ4bWPqyYZsN/emeqBfX2kOlbDOmVw1Uj0V/nkKnPH1TmA7GRVmughaiH
R6yKgYlU/2hi0ilqW+DJ/74XCtncdXEmUCFilaxhkyP1npfLN8dmjX7tgHdHwva8
vQHUBs2H5c7+dqGQCTNi3smE4i1dgVeTb+ckP3Ery8IiTZgSFoEoJpLWJACUk39i
4hrAMTuYCYWnxOK/XfRhs+M6qID6VLQTAkxu6ndRHmOEaAuE4KJBU/QmTSfOD7wu
Mx3cEPguamEgf4DytrqZpKZ7m5qjB/W+wC30SYVdQtGMihqCDCdFxVGGgMbQj64/
fuiZHftzKwCCY8OJAbVTNPYJ6y/vf8aQl8ft/Fal07c/pdNXhkJA84DHT/1Abo4r
/seD8ZAk1iyduKaXFtubmd3Iq27KV6/s0A7hgyQUwkKhN8V+klxGMszvoIjlrTds
eO5XfPIx0MMXzKn3gUADMjcKLTNh3GcM/boxzG8/ySacZr+guvWCPnDlXTuQsZFt
oSRVPgXOdKy+m+z6AQtsb3LH1QNbuOd1dgVKJYlC7rULeUmgQJCOxsdsaJFg557J
ookEDb7W/oYwvKjM7cBpNEYnIlc4PPqBM8XdyImoFlau7FSanv9+6wUhDM6a5UVl
jECLvstr45ncnhjrTyg1
=T5H9
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
