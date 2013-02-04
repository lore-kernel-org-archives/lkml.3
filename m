Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3BDRCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:02:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47314 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3BDRCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:02:49 -0500
Date: Mon, 4 Feb 2013 19:02:16 +0200
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
Message-ID: <20130204170216.GC4269@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130201184915.GP2244@beef>
 <510C1D0E.6030401@mvista.com>
 <20130201185820.GE29898@arwen.pp.htv.fi>
 <510C2A47.1090607@mvista.com>
 <20130201205600.GA31762@arwen.pp.htv.fi>
 <20130201213003.GW2637@n2100.arm.linux.org.uk>
 <20130204154153.GA18237@arwen.pp.htv.fi>
 <510FF1A6.403@mvista.com>
 <20130204164712.GB4269@arwen.pp.htv.fi>
 <510FF5C9.3030600@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
In-Reply-To: <510FF5C9.3030600@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 04, 2013 at 08:54:17PM +0300, Sergei Shtylyov wrote:
> > On Mon, Feb 04, 2013 at 08:36:38PM +0300, Sergei Shtylyov wrote:
> >>> opted out of it. From the top of my head we have CPPI 3.x, CPPI 4.1,
> >>> Inventra DMA, OMAP sDMA and ux500 DMA engines supported by the driver.
>=20
> >>> Granted, CPPI 4.1 makes some assumptions about the fact that it's
> >>> handling USB tranfers,
>=20
> >>    What CPPI 4.1 code makes this assumptions? MUSB DMA driver? Then it=
's just
>=20
> > HW makes the asumptions
>=20
>    Not true at all. There is a separate set of registers (at offset 0) wh=
ich
> copes with USB specifics, but CPPI 4.1 itself doesn't know about USB anyt=
hing.

CPPI 4.1 was made for USB transfers.

> It's just the way the driver was written that it used both sets of regist=
ers but
> this needs to be changed into more abstacted accesses to the USB-specific=
 part,
> to cope with it being different on different platfroms, like AM35x. The d=
river
> as it was last posted, just needs rework now.

are you saying you will do the work ?

> >>    Don't know, I was quite content with the abstraction when writing C=
PPI 4.1
> >> driver for MUSB...
>=20
> > look closer. The whole:
>=20
> > if (is_cppi())
> > 	foo();
> > else if (is_inventra())
> > 	bar();
> > else if (is_omap_sdma())
> > 	baz();
>=20
> > is bogus.
>=20
>    That part -- yes. There were attempt to get rid of this, but without c=
hanging
> the DMA API. It was left halfway done after my only critical comment, IIR=
C. Will
> we ever see the continuation of this effort?

patches are welcome

--=20
balbi

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD+mYAAoJEIaOsuA1yqREYRYP/3EKttosWR93nRGgtWaJhy1X
3YAOwIxCTY96/vju2F32NVPkEzM86iQ5bGy7iUf+YSeq7zHE/jxI9WqXYQNVVOsU
MikYsqHQqZH1xy0Th4l8Un/tRTxG9y5fWDLXSsCyajmD9M0g5RfCHOz1glZLcVRD
Jnu1oHwFG7ls0Nsldeg6mCoR+33jl2w2KdvRMmDEm/rsqbXCg2OugWXOCEZMv7Jc
XISYbyaz2t3uatXFRKMxnpw+r1ziYzuQIqGYI7CKhowYOD7I9eokpiDRfSYzzAF2
ck4ZVAOKG+FI1lTRC3Wd9DQDgkiVxWC0QFXfHaUO8ukX0zk6Twlvf6ZLkhAHLE73
DSFwV1YElY6acAGC8UG1HFPEN0BPf2kyVZdq9jXXxCyA/ZvzEPNuaBjp5UscE7Iw
Of3VM3bpOiMer859VsZZ16z6fPTAhrTzui3icVEoeop9WaQ2wKZvVW1pAYdDjgem
Si/ywEtjIe724KjjTR8VMp2CEyziXNapbPDJ860s84EveCEFjeyOtTNH0kIP09s6
kPFmE31yi28lFSPAqc7ohO3jqDR7z+qqF2DvOh+miSKUll7TCSpnXN2wT4UJ5HGm
YLJLRe9wxrHBvb3tz02qtt0PyQAIfHAIGs8Llas+/ki2eFeise0fFWP54zjIe9eR
AEDTciWKFntvCb+P2OYt
=nSAz
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--
