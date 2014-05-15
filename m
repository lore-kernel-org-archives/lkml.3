Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaEOUhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:37:37 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50761 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaEOUhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:37:35 -0400
Date: Thu, 15 May 2014 22:37:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, t.figa@samsung.com,
        Will Deacon <will.deacon@arm.com>, tomasz.figa@gmail.com,
        joshi@samsung.com, s.nawrocki@samsung.com, Varun.Sethi@freescale.com,
        kgene.kim@samsung.com, prathyush.k@samsung.com,
        sachin.kamat@linaro.org, joro@8bytes.org, devicetree@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>, grundler@chromium.org,
        linux-samsung-soc@vger.kernel.org, a.motakis@virtualopensystems.com,
        pullip.cho@samsung.com, rahul.sharma@samsung.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        supash.ramaswamy@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v12 11/31] documentation: iommu: add binding document of
 Exynos System MMU
Message-ID: <20140515203729.GA7136@mithrandir>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <6544270.ddFBoY6LMm@wuerfel>
 <20140428111802.GI19455@ulmo>
 <4780885.JaktFvJeC7@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <4780885.JaktFvJeC7@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 02:05:30PM +0200, Arnd Bergmann wrote:
[...]
> let me clarify by example:
>=20
> 	iommu@1 {
> 		compatible =3D "some,simple-iommu";
> 		reg =3D <1>;
> 		#iommu-cells =3D <0>; /* supports only one master */
> 	};
>=20
> 	iommu@2 {
> 		compatible =3D "some,other-iommu";
> 		reg =3D <3>;
> 		#iommu-cells =3D <1>; /* contains master ID */
> 	};
>=20
> 	iommu@3 {
> 		compatible =3D "some,windowed-iommu";
> 		reg =3D <2>;
> 		#iommu-cells =3D <2>; /* contains dma-window */
> 	};
>=20
> 	device@4 {
> 		compatible =3D "some,ethernet";
> 		iommus =3D <&/iommu@1>;
> 	};
>=20
> 	device@5 {
> 		compatible =3D "some,dmaengine";
> 		iommus =3D <&/iommu@2 0x40000000 0x1000000>,
> 			 <&/iommu@3 0x101>;
> 	};
>=20
> The device at address 4 has a one-one relationship with iommu@1, so there
> is no need for any data. device@5 has two master ports. One is connected =
to
> an IOMMU that has a per-device aperture, device@5 can only issue transfers
> to the 256MB area at 0x40000000, and the IOMMU will have to put entries f=
or
> this device into that address. The second master port is connected to
> iommu@3, which uses a master ID that gets passed along with each transfer,
> so that needs to be put into the IOTLBs.

iommu@3 and the second port of device@5 seem to match what we need for
Tegra (and as I understand also Exynos). Can we settle on this for now
so that Hiroshi and Cho can go update their drivers for this binding?

> A variation would be to not use #iommu-cells at all, but provide a
> #address-cells / #size-cells pair in the IOMMU, and have a translation
> as we do for dma-ranges. This is probably most flexible.

The remainder of this discussion seems to indicate that #iommu-cells and
dma-ranges don't have to be mutually exclusive. For some IOMMUs it might
make sense to use both.

In fact perhaps we should require every IOMMU user to also specify a
dma-ranges property, even if for some cases the range would be simply
the complete physical address space. Perhaps in analogy to the ranges
property an empty dma-ranges property could be taken to mean all of the
physical address space.

I'm aware that this doesn't cover any of the more exotic cases out
there, but the fact is that we have real devices out there that ship
with some variations of these simple IOMMUs and I don't think we're
doing ourselves a favour by blocking support for these to be added on
the hope of merging the perfect solution that covers all use-cases.
Patches for Tegra have already been around for close to half a year.

Thierry

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTdSWIAAoJEN0jrNd/PrOhNlcQAL3IQystbn7k1fYhGLuqJ15t
FnHMNLIrL5LroGQBJ0F/zGd+tGe8lSlo+pwbAK5ewxVdPCJL29VpeuEPLwZpZGiN
QRrxFHnZPhyKTiTiFVGJJThCW0yY4IMLZ/c3wZk/17KYKftTFyOaWjGQFLwMQ6Hu
xDZOO+5dmcc9SckHRJUOn+WDLExBDV3GNOZxSGbMNtiYqYjCV6vRmqI+O55lq9+1
vmN78TzdKCj+lHN4jsRk2ehn1Zfqy/mNkmjcV1I4wL5CPl4XV7XC1SxFaZNBINIT
12cp+2NcGE+yuizM+mOyF/hVdGR8P4i3wMBTAuX8fzH6g2gAnelRkzCGvefLe5aX
2qJbUJ/S/pXxq+kga9eBgyMzTj8xLqZMawHCfDUSIv1YDfRXBWyZy0xK44aD+a/g
igQOpSLhJc0xb3QF8EUntTB8Et23OzbyKXWW+cMXnuAcW1ahL0M85Z+ixuYRfJl+
MggbJUUVa14EJvJMrAwFMVHm2j7Kjsalhfy8m8dke/3HoAeeaY1Lrehdf8DbsGtu
edFGeuwLyUCwYc1jh620+qeNjDjo6ovORjPOJo6fIxf+gaiszXxFf7Fm/KHtBAoQ
ns8fOahCGwFvch3snzU12QhVW6cBNtMPINL3+nqyeThN3shf6neaqrgWJPOiUSwh
zoYccPp4OLvP5zEZCEmA
=tf6d
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
