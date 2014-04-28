Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaD1Kk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:40:56 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51647 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaD1Kkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:40:52 -0400
Date: Mon, 28 Apr 2014 12:39:20 +0200
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
Message-ID: <20140428103919.GF19455@ulmo>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <1398584283-22846-12-git-send-email-shaik.ameer@samsung.com>
 <4447051.OnJtcFSqFV@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OzxllxdKGCiKxUZM"
Content-Disposition: inline
In-Reply-To: <4447051.OnJtcFSqFV@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OzxllxdKGCiKxUZM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 27, 2014 at 08:23:06PM +0200, Arnd Bergmann wrote:
> On Sunday 27 April 2014 13:07:43 Shaik Ameer Basha wrote:
> > +- mmu-masters: A phandle to device nodes representing the master for w=
hich
> > +               the System MMU can provide a translation. Any additiona=
l values
> > +              after the phandle will be ignored because a System MMU n=
ever
> > +              have two or more masters. "#stream-id-cells" specified i=
n the
> > +              master's node will be also ignored.
> > +              If more than one phandle is specified, only the first ph=
andle
> > +              will be treated.
>=20
> This seems completely backwards: Why would you list the masters for an IO=
MMU
> in the IOMMU node?
>=20
> The master should have a standard property pointing to the IOMMU instead.
>=20
> We don't have a generic binding for IOMMUs yet it seems, but the time is
> overdue to make one.
>=20
> Consider this NAKed until there is a generic binding for IOMMUs that all
> relevant developers have agreed to.

I'd like to take this opportunity and revive one of the hibernating
patch sets that we have for Tegra. The last effort to get things merged
was back in January I think. I haven't bothered to look up the reference
since it's probably good to start from scratch anyway.

The latest version of the binding that was under discussion back then I
think looked something like this:

	device@... {
		iommus =3D <&iommu [spec]>[, <&other_iommu [other_spec]>...];
	};

And possibly with a iommu-names property to go along with that. The idea
being that a device can be a master on possibly multiple IOMMUs. Using
the above it would also be possible to have one device be multiple
masters on the same IOMMU.

On Tegra the specifier would be used to encode a memory controller's
client ID. One discussion point back at the time was to encode the ID as
a bitmask to allow more than a single master per entry. Another solution
which I think is a little cleaner and more generic, would be to use one
entry per master and use a single cell to encode the client ID. Devices
with multiple clients to the same IOMMU could then use multiple entries
referencing the same IOMMU.

I've added Hiroshi Doyu on Cc since he knows the Tegra IOMMU best.
Hiroshi, can you summarize exactly what the proposed bindings were. If
my memory serves me well they were mostly along the lines of what Arnd
proposes here, and perhaps they are something that can also be used for
Exynos.

Will Deacon (I think) had some comments on the earlier discussion as
well, so I've added him on Cc for visibility. Sorry if I'm confusing you
with someone else, Will. In that case perhaps you know who to include in
the discussion from the ARM side.

Also adding Stephen Warren for visibility.

Thierry

--OzxllxdKGCiKxUZM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXi/XAAoJEN0jrNd/PrOhC9kQAJhNUI7/j97xgFjGVeB2IPkl
z1FZYXz4/0HagUOZ3sd2thCn3YhiGTggEYAEmXymyUIhaPXD9dzUMw2H9ZAab4CW
ONWI1pPbv6QowSVlvsEC4bZCTt8wpamsLeuS7C0rjqaw4bkK8TQ15oDfD5Rfv27g
KM2YiURjiKcEm7mkdpwa8hBgz5hvO7N5ulV2n1E52D7YGhA/e4IGQYzp/RkOj0s+
byzfA9edGiZA0c7y19uR5+TrmRcaH5ERR1+fvOdl1jMw54rYdolkm857BrbFlKEN
EO79HCcQaSFY71fR/EqPWO6M5ZJ2LLVNNIZw6hD8dBCiX8Nu8Z6obsnMEkzFNx48
YBxHhZT2lngtIGVpEeoNJfn4V8E9q2/RnzxKN3lZh1P9eQ7uTWOUROaCgqKfETL0
Nqd8bcvsOFtHwjI5/JCeUvP8e6DtrnIhDDur8x+29wVeiKyDNEQ4g2EOIxeDjqhy
maRYRal2u643H6cFAnYnuZFdkJy5zrHG6ZwF/BoKwib+2mZKpveOP494ybgAF7h7
DiqbwyviutAqZ2hfKjdzYZB9VkSSGV2M+dhOkfet4sEEhMq8gbAcwxP2i/fllDN5
qjOQ8wG3rmu2GsncbOtF54oZCT2O5mP7MTGtFkgBUDwK605Hml0QRo6+GsU8qNhT
2c+7sqiN3FnrwF8QpcYA
=TPNI
-----END PGP SIGNATURE-----

--OzxllxdKGCiKxUZM--
