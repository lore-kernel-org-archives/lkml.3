Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaD1LTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:19:38 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:49502 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaD1LTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:19:34 -0400
Date: Mon, 28 Apr 2014 13:18:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, Shaik Ameer Basha <shaik.ameer@samsung.com>,
        prathyush.k@samsung.com, grundler@chromium.org, joro@8bytes.org,
        supash.ramaswamy@linaro.org, linux-kernel@vger.kernel.org,
        pullip.cho@samsung.com, tomasz.figa@gmail.com, sachin.kamat@linaro.org,
        iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        s.nawrocki@samsung.com, a.motakis@virtualopensystems.com,
        Varun.Sethi@freescale.com, joshi@samsung.com, t.figa@samsung.com,
        rahul.sharma@samsung.com, Hiroshi Doyu <hdoyu@nvidia.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v12 11/31] documentation: iommu: add binding document of
 Exynos System MMU
Message-ID: <20140428111802.GI19455@ulmo>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <4447051.OnJtcFSqFV@wuerfel>
 <20140428103919.GF19455@ulmo>
 <6544270.ddFBoY6LMm@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7SrMUQONj8Rl9QNG"
Content-Disposition: inline
In-Reply-To: <6544270.ddFBoY6LMm@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7SrMUQONj8Rl9QNG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 12:56:03PM +0200, Arnd Bergmann wrote:
> On Monday 28 April 2014 12:39:20 Thierry Reding wrote:
> > On Sun, Apr 27, 2014 at 08:23:06PM +0200, Arnd Bergmann wrote:
> > > On Sunday 27 April 2014 13:07:43 Shaik Ameer Basha wrote:
> > > > +- mmu-masters: A phandle to device nodes representing the master f=
or which
> > > > +               the System MMU can provide a translation. Any addit=
ional values
> > > > +              after the phandle will be ignored because a System M=
MU never
> > > > +              have two or more masters. "#stream-id-cells" specifi=
ed in the
> > > > +              master's node will be also ignored.
> > > > +              If more than one phandle is specified, only the firs=
t phandle
> > > > +              will be treated.
> > >=20
> > > This seems completely backwards: Why would you list the masters for a=
n IOMMU
> > > in the IOMMU node?
> > >=20
> > > The master should have a standard property pointing to the IOMMU inst=
ead.
> > >=20
> > > We don't have a generic binding for IOMMUs yet it seems, but the time=
 is
> > > overdue to make one.
> > >=20
> > > Consider this NAKed until there is a generic binding for IOMMUs that =
all
> > > relevant developers have agreed to.
> >=20
> > I'd like to take this opportunity and revive one of the hibernating
> > patch sets that we have for Tegra. The last effort to get things merged
> > was back in January I think. I haven't bothered to look up the reference
> > since it's probably good to start from scratch anyway.
> >=20
> > The latest version of the binding that was under discussion back then I
> > think looked something like this:
> >=20
> > 	device@... {
> > 		iommus =3D <&iommu [spec]>[, <&other_iommu [other_spec]>...];
> > 	};
> >=20
> > And possibly with a iommu-names property to go along with that. The idea
> > being that a device can be a master on possibly multiple IOMMUs. Using
> > the above it would also be possible to have one device be multiple
> > masters on the same IOMMU.
>=20
> Yes, that seems reasonable. Just one question: How would you represent a
> device that has multiple masters, with at least one connected to an IOMMU
> and another one connected to memory directly, without going to the IOMMU?

Heh, I don't think I've ever thought about that use-case. I guess I was
always assuming that in the absence of an IOMMU the device would simply
access memory directly. From what I can tell that's how Tegra works at
least. If the IOMMU is not enabled for a given client, that client will
access physical memory untranslated.

I suppose if that really must be represented then a global dummy IOMMU
could be introduced to help with these cases.

> > On Tegra the specifier would be used to encode a memory controller's
> > client ID. One discussion point back at the time was to encode the ID as
> > a bitmask to allow more than a single master per entry. Another solution
> > which I think is a little cleaner and more generic, would be to use one
> > entry per master and use a single cell to encode the client ID. Devices
> > with multiple clients to the same IOMMU could then use multiple entries
> > referencing the same IOMMU.
>=20
> I'm not completely following here. Are you talking about the generic
> binding, or the part that is tegra specific for the specifier?
>=20
> My first impression is that the generic binding should just allow an
> arbitrary specifier with a variable #iommu-cells, and leave the format
> up to the IOMMU driver.

Yes, I was getting ahead of myself. The idea was to have #iommu-cells
and allow the specifier to be IOMMU-specific. On Tegra that would
translate to the memory controller client ID, on other devices I suspect
something similar might exist, but for the generic binding it should be
completely opaque and hence irrelevant.

Really just like any of the other bindings that have foos and #foo-cells
properties.

> A lot of drivers probably only support one
> master, so they can just set #iommu-cells=3D<0>, others might require
> IDs that do not fit into one cell.

You mean "#iommu-cells =3D <1>" for devices that only require one master?
There still has to be one cell to specify which master. Unless perhaps
if they can be arbitrarily assigned. I guess even if there's a fixed
mapping that applies to one SoC generation, it might be good to still
employ a specifier and have the mapping in DT for flexibility.

Thierry

--7SrMUQONj8Rl9QNG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXjjqAAoJEN0jrNd/PrOh694P/0oLJF8Cc/zfMQ9l+N3j/YZf
uGkUbAFZGRUomXEiHUzBp7tAsefrIs5RQnAlKm1LL6GYYrSTrWYcPAdOv3z9s/0V
JjbXQ+XpPuyuJMYPa1S6HZhm2BixKS21ValCHz8ubEjsDsMHIgL7MXeiCoou5Y3M
Qv66zIB60jrhnUJ12B3xbQQ2wJOE0XBGDc2Vofq9y6uqKAbkNGkTZGd9TbMn05fl
IGr9jhnHlkxCBHjB48cg28nxrnG5PuxQDBX3GCQy1gId21MceEglmBvcF69mTrup
F8pDrT6vUzQ22ieX6RPc5YKRwF32QmCntMY9NhBFdIEJP3IxQa22EN6pn7etx7IK
dPeAw9GOb4RTiLIdeGWHj+pZ7PXBQCbyVBA7uqCsiVIuuuNB4OvKcUCa5D1llKAQ
9VDnpSPqCRHEB4BMgw1ISGNDC76WTtZWSzrNZt6nLCjirxYpt3z6osvOoH/XauWL
6NsYQGPCRjH3OJNOR/RWB9OrUfJK/6R/TxVSwkNqLq89qINX3nGfQvRptiThfsxD
Jk2a/iFe7gAlNlMwGHDv6A7h12OSbYkMUzksXggxBDo/Kup6nTOWgK2l+sTqt+Ah
Nrlc/+LWwqi63dc1jlsSCvd2772yncnS06E10j8OUYp7H/CRRULY/HPMQ+uvxOuA
TDDJvh/X71we9QM4yE9/
=0JBD
-----END PGP SIGNATURE-----

--7SrMUQONj8Rl9QNG--
