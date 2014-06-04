Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaFDNm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:42:26 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56689 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaFDNmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:42:22 -0400
Date: Wed, 4 Jun 2014 15:39:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140604133934.GD28484@ulmo>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <4545972.cM7IP1qTXQ@wuerfel>
 <87tx87rrp2.fsf@nvidia.com>
 <4462924.8iRbdkOPp7@wuerfel>
 <20140601095546.GA8625@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Content-Disposition: inline
In-Reply-To: <20140601095546.GA8625@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 01, 2014 at 10:55:46AM +0100, Will Deacon wrote:
> On Fri, May 30, 2014 at 08:54:37PM +0100, Arnd Bergmann wrote:
> > On Friday 30 May 2014 22:29:13 Hiroshi Doyu wrote:
> > > Tegra,SMMU has a similar problem and we have used a fixed size bitmap=
(64
> > > bit) to afford 64 stream IDs so that a single device can hold multiple
> > > IDs. If we apply the same bitmap to the above exmaple:
> > >=20
> > >        iommu {
> > >                /* the specifier represents the ID of the master */
> > >                #address-cells =3D <1>;
> > >                #size-cells =3D <0>;
> > >        };
> > >=20
> > >         master@a {
> > >                 ...
> > >                 iommus =3D <&smmu (BIT(1) | BIT(2) | BIT(3))>; # IDs =
1 2 3
> > >         };
> > >=20
> > >         master@b {
> > >                 ...
> > >                 iommus =3D <&smmu BIT(4)>;     # ID 4
> > >         };
> > >=20
> > > The disadvantage of this is that this limits the max number of stream=
IDs
> > > to support. If # of streamID is increased later more than 64, this
> > > format cannot cover any more. You have to predict the max # of stream=
IDs
> > > in advance if steamID is statically assigned.
> > >=20
> >=20
> > Well, the iommu specific binding could allow a variable #address-cells.
> > That way, you just need to know the number of stream IDs for that insta=
nce
> > of the iommu.
>=20
> In general, though, the SMMU will be able to support a large number of
> stream IDs (say a 16-bit space). The restriction we're interested in here=
 is
> how many different stream IDs can be emitted by a single master device
> coming into the SMMU. *That* is a property of the master, not the SMMU.
>=20
> In the current arm,smmu binding I have a #stream-id-cells property in each
> master. I can then feed that straight into of_parse_phandle_with_args to
> enumerate the IDs for that master. The problem with that is we're
> artificially restricted by MAX_PHANDLE_ARGS.

Maybe I don't fully understand, but since we leave it up to the IOMMU
binding to define the exact meaning of #iommu-cells, can't you simply
use that to your advantage and define something like:

	iommus =3D <&smmu 0 7>;

to mean IDs 0 to 7 for this particular IOMMU type?

Thierry

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjyGWAAoJEN0jrNd/PrOhJxsP/1QEAS+0iTQlOqf1sv4Oez0K
DasrIeJ6Hg9a/Rgr3N+LLHF0uocLBhW17z+gG1wzPghsRyqzsnK9574Rlc+hpCEz
98+hbQq1Vv+gZJbm80kuSNZEwScteyNblaG7tSk83YQhqLs7EXczVuU9Mlg2TnCX
z+bZArGke7KrMAseG4HcdoZiauMwM+2CcMXE8Nib43+OZj5Xpin8HHn9so53VZCc
VSE+m+SVydcEVIq3DlEQOTNywCRHiyOtYy1esUPo+H9lkMOOFUkXnm0PYDP5iCFb
TZ4NZ0AoJO6zjXSFRba9M1TpJEZ+ZXoEA8HxmRKXCUUZnoSpcnJc490T09K3cKLf
bkdhqdwkGairvX849B9GaHWDFLy6v6ZBqYrFSC5xWh1J9SFDoq/7rpCosJxBmdOK
EH6SSmPaQgtko3iFbSxU75BQoHLB+/TD/9xx5eWhmDTkfmV79Sg1cCo2sBrTZmvm
J2m1Qmp1LKv7gwSq8dVQmhW+g19WyPKzr3GsqnZuaNpFvSPik61BloeNe9iTOLvS
f1MHMWFhypILGZyhXmV7RCoMfl36L9eKAdgHY9oDZNBqGRgk7G19kCxxHA1lKbw/
/jiwG1IuFwme9QRODqgmfUJtYQcroGP6aQRQQ7ethVp9oxUH8AH5hHUFoB1P3mzO
bu+xsmkOPv/NcGnNT1Ps
=KYXF
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
