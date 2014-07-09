Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaGIOVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:21:34 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:63299 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaGIOVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:21:32 -0400
Date: Wed, 9 Jul 2014 16:21:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Joerg Roedel <joro@8bytes.org>, Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140709142125.GB3262@ulmo>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140709134050.GN9485@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <20140709134050.GN9485@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 02:40:50PM +0100, Will Deacon wrote:
> On Fri, Jul 04, 2014 at 04:29:17PM +0100, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > This commit introduces a generic device tree binding for IOMMU devices.
> > Only a very minimal subset is described here, but it is enough to cover
> > the requirements of both the Exynos System MMU and Tegra SMMU as
> > discussed here:
> >=20
> >     https://lkml.org/lkml/2014/4/27/346
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
>   Acked-by: Will Deacon <will.deacon@arm.com>
>=20
> I would like to move the ARM SMMU driver over to this for 3.18, if possib=
le.
> One use-case there is the ability to describe groups of masters behind a
> multi-master IOMMU but which must be part of the same domain (i.e. an
> iommu_group). This is useful for presenting devices to a guest with a
> virtual SMMU, where the physical devices share a stage-2 context.
>=20
> With your binding, does this simply mean determining the set of master IDs
> in the group, then describing the complete set for each master?

I'm not sure I properly understand what you're trying to do, but I don't
think the binding is designed to cover that. Rather the goal was to
describe the IDs belonging to each master, so that an IOMMU can be
properly configured.

Anything beyond that (e.g. logical grouping of masters) isn't directly
within the scope of the binding (it doesn't describe hardware but some
policy pertaining to some specific use-case).

That said, the IOMMU driver that I prototyped for Tegra did some similar
grouping of devices, although in a much more restricted way. The goal of
that was to add a known set of devices into one group, "peripherals", so
that they could share one IOMMU domain. This was meant to separate them
=66rom devices with more advanced needs (such as a GPU driver). Devices in
the "peripherals" group would be using the DMA mapping API integration
whereas other devices would have to explicitly allocate an IOMMU domain.

I'm not sure how much that helps for the use-case that you have in mind.

Thierry

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvU/lAAoJEN0jrNd/PrOhN50P/1dI3aJhI4/+i6WX1nsXpCN2
8VcmnlCJHdY1rmynJNk3WMEAepjVM6DRhDykwpPGRTD226yJWbiIfyIo53+yyx4a
A4RjJKluaIfGL0bnlN/cg3lafoh3GwEkahTEPjhOHD8DgvYJNWu6ziojbaUplC9D
V/UgfqHWtKrrxlum0nNJb8ObdJS/ef7RxAKLN08DMbZJe162Q+FNU/dMEQiueoJ8
+dGtEM27qP9+XMvgpeiqynyXTnc+/ZyTNQsrZuhwqHyhd3C0ey3aBQ0BF0Z2u4Yg
ok//PUQcCYgL3mQaK0Ev2zlcHKwXIqt7HiSlIluzKXSPXvx/CUuEXaIjgzceWse8
9VZ1HmPnTW/UKlcvDdrG9GFtsXTZ9H4p/JGYbTsPM1+Ffc7wzwcKoXrqWigkd9iH
KdYT3ZsYD/rqz2BrR+8twQJRgFqjku55vu4tojNNs0tt4s5u1RWqbF/9e/y8tPIb
oM+tLOAsesyBcjlUeYogjT02XHh7SqWg8dSQFm+fMjmlbX6t4nuGCrJrVvSFBJtf
BwRVX0bA1NM19ybK02GSeTgEOHyQUsQJ0tbkNF/RvYUvqEaXFShhDYZrLxSEk/j3
WoUhqKO48NvyWMlonaCwMM3DswiJX4raer6gbNUNXhSSSDIl+WQitkhqx81cKIQP
bdnXlao7qtH18ZygWVGj
=Hh+x
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
