Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaF0LPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:15:22 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:49800 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaF0LPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:15:20 -0400
Date: Fri, 27 Jun 2014 13:15:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
Message-ID: <20140627111514.GE2797@ulmo>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
 <9283417.yKmnrljUYI@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Content-Disposition: inline
In-Reply-To: <9283417.yKmnrljUYI@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2014 at 01:07:04PM +0200, Arnd Bergmann wrote:
> On Thursday 26 June 2014 22:49:44 Thierry Reding wrote:
> > +static const struct tegra_mc_client tegra124_mc_clients[] =3D {
> > +       {
> > +               .id =3D 0x01,
> > +               .name =3D "display0a",
> > +               .swgroup =3D TEGRA_SWGROUP_DC,
> > +               .smmu =3D {
> > +                       .reg =3D 0x228,
> > +                       .bit =3D 1,
> > +               },
> > +               .latency =3D {
> > +                       .reg =3D 0x2e8,
> > +                       .shift =3D 0,
> > +                       .mask =3D 0xff,
> > +                       .def =3D 0xc2,
> > +               },
> > +       }, {
>=20
> This is a rather long table that I assume would need to get duplicated
> and modified for each specific SoC. Have you considered to put the inform=
ation
> into DT instead, as auxiliary data in the iommu specifier as provided by
> the device?

Most of this data really is register information and I don't think that
belongs in DT. Also since this is fixed for a given SoC and in no way
configurable (well, with the exception of the .def field above) I don't
see any point in parsing this from device tree.

Also only the .smmu substruct is immediately relevant to the IOMMU part
of the driver. The .swgroup field could possibly also be moved into that
substructure since it is only relevant to the IOMMU.

So essentially what this table does is map SWGROUPs (which are provided
in the IOMMU specifier) to the clients and registers that the IOMMU
programming needs. As an analogy it corresponds roughly to the pins and
pingroups tables of pinctrl drivers. Those don't belong in device tree
either.

Thierry

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrVJCAAoJEN0jrNd/PrOhoJwP/3bcyKeMM9rOidAK/YuG2rkx
wxOt4mD+g6YYYCAPjsijMjbzdA17V/PAnSEnLUFQdwnsqD88SCIt2gQsgDdhchN/
KXuWatve2B08m+S0rnaJrTsImcC/uSnKTAgyvOP8brC8zkc+5N04FB+fTiVhz1YE
XPjcib08jgdOsasFyhCRJDHukdDXDjrv8xBhpDBZwuSxVjKWzXJFQPW8Lca8/Qm6
fPxYJftIlMEXq/1CuuG7vEka56bJX7jBJK6qQX2nRBM0jMx55N7z/5fdbFwN2rlU
3dD1fGbcEjcgJiyMABtZJFPHoEtKkQ52S6vtJFMr6NrnaVnQr/Xlmp8j1iBxAE4h
zVwi/v9zHj6371jBaU0YkGp20sSj3+o0mkqTbq4+oOK7q4bWa6Hg2nGIsrgHkZ0K
boVNARzkU4p/iF3MWVSJ23oDSgTtH85hHRUFnzOQySMOb1/2Rd2RdRGhJE/Aypli
pYzgKei3ESWERIf/EKphRTz33johFZGJW65UXOlh39C0Lwzn0ehPPiZvhorIn86E
0kAB73a/Ar2JY7o6AIJnh46YcMJXUTaUJPf7qknfK7GH+YztcVU4yEbhDtvzWjr0
vUf5XREWOb/0WcotPxCTbyslSwdK7AQdBvCIIdOUmoUkw+0owbOpJySgUub8kP6O
lG+7+Jkzm1YqClKMUxvH
=edre
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
