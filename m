Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3GQE4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 00:56:19 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:42866 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3GQE4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 00:56:17 -0400
Date: Wed, 17 Jul 2013 06:56:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Jay Agarwal <jagarwal@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "olof@lixom.net" <olof@lixom.net>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
Subject: Re: [PATCH V3 3/4] ARM: dts: tegra: Correct PCIe entry
Message-ID: <20130717045607.GC11359@mithrandir>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
 <1370372252-4332-3-git-send-email-jagarwal@nvidia.com>
 <20130610195511.GC25859@mithrandir>
 <20130611073048.GR3847@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
Content-Disposition: inline
In-Reply-To: <20130611073048.GR3847@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 10:30:48AM +0300, Peter De Schrijver wrote:
> On Mon, Jun 10, 2013 at 09:55:12PM +0200, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Wed, Jun 05, 2013 at 12:27:31AM +0530, Jay Agarwal wrote:
> > [...]
> > > @@ -29,7 +29,7 @@
> > >  		ranges =3D <0x82000000 0 0x00000000 0x00000000 0 0x00001000   /* p=
ort 0 configuration space */
> > >  			  0x82000000 0 0x00001000 0x00001000 0 0x00001000   /* port 1 con=
figuration space */
> > >  			  0x82000000 0 0x00004000 0x00004000 0 0x00001000   /* port 2 con=
figuration space */
> > > -			  0x81000000 0 0          0x02000000 0 0x00010000   /* downstream=
 I/O */
> > > +			  0x81000000 0 0          0x02000000 0 0x00100000   /* downstream=
 I/O */
> > >  			  0x82000000 0 0x20000000 0x20000000 0 0x10000000   /* non-prefet=
chable memory */
> > >  			  0xc2000000 0 0x30000000 0x30000000 0 0x10000000>; /* prefetchab=
le memory */
> >=20
> > That increases the I/O region size from 64 KiB to 1 MiB. Why is that
> > necessary? I/O operations can only address 64 KiB, so I don't think
> > adding more makes any sense.
>=20
> At least PCI allows 32bit I/O addresses. No idea if anyone uses them thou=
gh.

I just realized that we are constrained to 64 KiB by the implementation
of pci_ioremap_io(), which assumes each mapping is 64 KiB. Not that it
couldn't be changed, but unless there actually is a use-case where more
than 64 KiB are required I don't think we should worry about it.

Thierry

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5iPmAAoJEN0jrNd/PrOhrBMP/0vz8TPy4041QDMywygKLoBd
wqq4TzpO3Tq3y8m8zk8anVQ9CtSdXiJVzbvum9IehAeWUUYoPVK2ENcaC6Atkzi2
pWDfSICda40hZyEukwUXh0ncOLwM5+sK5Shz0hCk2lOr2HTk34LgGr0I0Nb9eSM+
KkCFSqLPaH2QZuGxvTPgMKP2EcrGdcMYVDB7pZ1ENu8WKwHJmDZLRz6QisXqYIVF
osKhmUIuVpuP7RafvjU0wOHghx2yZD9FZG5x1guiAiWox78MvrYwJNULzRlq1IPA
nxvnasLM3ZOUk7YQYJkD6WE184MJYYXmGUNwymyfdWFNe17xEGy0j2y4fOxkb87a
TUytPwi5RuidPu/FNlCcb0sCxdbbjuwxzBUDvR/zQ6i5YUPPvVXwADCOV/i6WoPI
FIY3JhiqKkapo5YSWOrlskImpQZPGfLOJXTH2TiGAHc6oBF18OjielG+xUAPbX1A
GcOSg5leYEHjIihC/BEvXYun2vBa4yca6F0mcOiTIjFHAbB7s8OYQFGSX84htwmT
bgw+2869EtP5LJUnTMONM/FZv487/UWICqLNXEmlNHFrmwuxOzyfQk6WxHtiYiVS
eY4SjpJ/HfDS5VClFESozo0SkzG2nG5ogQvsUnrEjtkPnIINnK2qXOSU6Cks9Q+G
BLC2lvtmjh1SNFBYMzso
=Rjk/
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
