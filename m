Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaFDOiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:38:02 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46182 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaFDOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:37:56 -0400
Date: Wed, 4 Jun 2014 16:35:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140604143509.GF28484@ulmo>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <4545972.cM7IP1qTXQ@wuerfel>
 <CAL_Jsq+tkFNpjSEZboT+o69B_Z3a8e-ZVKaYDmLwtkyYoPy6VQ@mail.gmail.com>
 <5288123.eXagyPAxNq@wuerfel>
 <20140602104104.GD3855@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FeAIMMcddNRN4P4/"
Content-Disposition: inline
In-Reply-To: <20140602104104.GD3855@e103592.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FeAIMMcddNRN4P4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 11:41:04AM +0100, Dave Martin wrote:
> On Fri, May 30, 2014 at 09:49:59PM +0200, Arnd Bergmann wrote:
> > On Friday 30 May 2014 14:31:55 Rob Herring wrote:
> > > On Fri, May 30, 2014 at 2:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > > On Friday 30 May 2014 08:16:05 Rob Herring wrote:
> > > >> On Fri, May 23, 2014 at 3:33 PM, Thierry Reding
> > > >> <thierry.reding@gmail.com> wrote:
> > > >> > From: Thierry Reding <treding@nvidia.com>
> > > >> > +IOMMU master node:
> > > >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >> > +
> > > >> > +Devices that access memory through an IOMMU are called masters.=
 A device can
> > > >> > +have multiple master interfaces (to one or more IOMMU devices).
> > > >> > +
> > > >> > +Required properties:
> > > >> > +--------------------
> > > >> > +- iommus: A list of phandle and IOMMU specifier pairs that desc=
ribe the IOMMU
> > > >> > +  master interfaces of the device. One entry in the list descri=
bes one master
> > > >> > +  interface of the device.
> > > >> > +
> > > >> > +When an "iommus" property is specified in a device tree node, t=
he IOMMU will
> > > >> > +be used for address translation. If a "dma-ranges" property exi=
sts in the
> > > >> > +device's parent node it will be ignored. An exception to this r=
ule is if the
> > > >> > +referenced IOMMU is disabled, in which case the "dma-ranges" pr=
operty of the
> > > >> > +parent shall take effect.
> > > >>
> > > >> Just thinking out loud, could you have dma-ranges in the iommu node
> > > >> for the case when the iommu is enabled rather than putting the DMA
> > > >> window information into the iommus property?
> > > >>
> > > >> This would probably mean that you need both #iommu-cells and #addr=
ess-cells.
> > > >
> > > > The reason for doing like this was that you may need a different wi=
ndow
> > > > for each device, while there can only be one dma-ranges property in
> > > > an iommu node.
> > >=20
> > > My suggestion was that you also put the IDs in the dma-ranges as the
> > > first cell much as ranges for PCI encodes other information in the
> > > first cell. Then you can have an entry for each ID. The downside is
> > > another special case like PCI.
> > >=20
> > > The argument for using #address-cells and #size-cells seems to be to
> > > align with how ranges work. If that's the route we want to go, then I
> > > say we should not stop there and actually use dma-ranges as well.
> > > Otherwise, I don't see the advantage over #iommu-cells.
> >=20
> > I can see how dma-ranges in bus nodes work, it just doesn't seem to
> > have any reasonable meaning in the iommu node itself.
>=20
> dma-ranges defines a static mapping for mastering through the bus node.
>=20
> The whole point of an IOMMU is that it maps dynamically, so I agree:
> I'm unclear on what dma-ranges should mean in the IOMMU node itself
> (if anything).
>=20
> >=20
> > > > I don't understand the problem. If you have stream IDs 0 through 7,
> > > > you would have
> > > >
> > > >         master@a {
> > > >                 ...
> > > >                 iommus =3D <&smmu 0>;
> > > >         };
> > > >
> > > >         master@b {
> > > >                 ...
> > > >                 iommus =3D <&smmu 1;
> > > >         };
> > > >
> > > >         ...
> > > >
> > > >         master@12 {
> > > >                 ...
> > > >                 iommus =3D <&smmu 7;
> > > >         };
> > > >
> > > > and you don't need a window at all. Why would you need a mask of
> > > > some sort?
> > >=20
> > > 1 master with 7 IDs like this:
> > >=20
> > >          master@a {
> > >                  ...
> > >                  iommus =3D <&smmu 0> <&smmu 1> <&smmu 2> <&smmu 3>
> > > <&smmu 4> <&smmu 5> <&smmu 6> <&smmu 7>;
> > >          };
> > >=20
> > > If there was any sort of window, then it is almost certainly the same
> > > window for each ID.
>=20
> Do we have real examples of using a window *and* an ID?  I thought the
> windowed-IOMMU concept was partly a way of encoding the ID in some
> real address bits on the bus.  If you're doing that, it seems less likely
> that there is a true "ID" as such (though it is possible).
>=20
> > Ok, I see. In that case you'd probably want to have #address-cells =3D =
<1>
> > and #size-cells =3D <1> and give a range of IDs like
> >=20
> > 	iommus =3D <&smmu 0 8>;
> >=20
> > Do you think that ranges can have a meaningful definition with the ARM
> > SMMU stream IDs?
>=20
> In the strictest sense, no.
>=20
> But for a large set of sane configurations, this probably works.
>=20
> Small sets of randomly-assigned IDs can just be enumerated one by one.
>=20
> We wouldn't be able to describe folding and bit shuffling, but we
> probably don't want to encourage that anyway.

I'm having some difficulty understanding this. You make it sound like
there's a fairly arbitrary number of IDs that the SMMU can handle. So
how is the mapping to devices defined? If you say encourage that does
make it sound like the assignment of IDs is purely defined by some
mechanism in software rather than in hardware. Or they are more or less
randomly picked by someone. If that's the case, is that not something
that should be dynamically allocated by the kernel rather than put into
the device tree?

Maybe in the above case all you really need to know is how many IDs a
device needs to be assigned so that they can be properly allocated,
rather than the device exactly specifying which ones.

Thierry

--FeAIMMcddNRN4P4/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjy6dAAoJEN0jrNd/PrOhcOAQAJqUSIBzsGrY10WGZKf6eFFU
SiNsCrnpvKvQ9f98ZwGrCLjad/d+h7N5Wy7CrlBuZnM48gwvxjJd8upD0ovqNGO6
vXWee/4QT6dVxqobcRFwoyca8JQOu+rhbCWXod5+APvkE5JUYgnQgztLdzTYV+Z5
3WWwku3KXH2uDCSCeqkpCVYOdWZ8a2tMvGFQdFqi+eFHZrSkAPie4IEm9IO7m8A6
ob+qT/QLFJ2QPEmE6OAUCoVbF75KSaPZyjJsQ6EoQ8ZCX/pnzfRMYiHqi2sEuymS
O7YgrSeauCdJwck5KU1Qyy3XthIDo9MdykN6MxVKKR0B4pDtn7aTQxfpgyu79+Fk
Mhi2j2K6CAYVtpD+UR4qP53WGrpVW1DhevCXOLeGio89LmUFx4AoMhl+3YxRLsPV
oWDO1iaESD2ZVHa1moQ2iyAWltb9Ox/yJuyIjKkJfXgQ1ehZSrR9v1lOhoBxJuGe
qYpmQKXphXtSa10XH88c8FtwYxvUJRwD7bWDSZ86qKbTm65rzD/ajN7D0CFb4mBx
9P5YYqXX8u90Nbb7EpDHHtBJrxN1ZE3zuHVKtDupOv5UXPcLlu9DDThIkm2Po4Jc
Q3QcweMzt4ROb1JJ/pq25AxW3WrUNxu1+qeumcCH4sGs2CS/9sIzeCdsLvYG22M/
qPP4LCQYQ36BNu6Ma8LH
=xaoS
-----END PGP SIGNATURE-----

--FeAIMMcddNRN4P4/--
