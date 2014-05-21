Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaEUI2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:28:34 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:58983 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaEUI2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:28:31 -0400
Date: Wed, 21 May 2014 10:26:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        iommu@lists.linux-foundation.org, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140521082606.GB11068@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <8663464.40PHEumOar@wuerfel>
 <20140520152458.GB5041@e103592.cambridge.arm.com>
 <5612206.Fzsy1mf3q3@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <5612206.Fzsy1mf3q3@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 10:26:12PM +0200, Arnd Bergmann wrote:
> On Tuesday 20 May 2014 16:24:59 Dave Martin wrote:
> > On Tue, May 20, 2014 at 02:41:18PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 20 May 2014 14:02:43 Thierry Reding wrote:
[...]
> > > > Multiple-master IOMMU:
> > > > ----------------------
> > > >=20
> > > > 	iommu {
> > > > 		/* the specifier represents the ID of the master */
> > > > 		#address-cells =3D <1>;
> > > > 		#size-cells =3D <0>;
> >=20
> > How do we know the size of the input address to the IOMMU?  Do we
> > get cases for example where the IOMMU only accepts a 32-bit input
> > address, but some 64-bit capable masters are connected through it?
>=20
> I was stuck on this question for a while before, but then I realized
> that it doesn't matter at all: It's the IOMMU driver itself that
> manages the address space, and it doesn't matter if a slave can
> address a larger range than the IOMMU can accept. If the IOMMU
> needs to deal with the opposite case (64-bit input addresses
> but a 32-bit master), that limitation can be put into the specifier.

Isn't this what DMA masks are for? Couldn't the IOMMU simply use the
master device's DMA mask to do the right thing here?

As such I don't think this information needs to be in device tree at
all. The DMA mask should typically be set by the driver in the first
place because it has knowledge about the capabilities of the device.
A different way of saying that is that the DMA mask is implied by the
device's compatible string.

> > For determining dma masks, it is the output address that it
> > important.  Santosh's code can probably be taught to handle this,
> > if given an additional traversal rule for following "iommus"
> > properties.  However, deploying an IOMMU whose output address size
> > is smaller than the=20
>=20
> Something seems to be missing here. I don't think we want to handle
> the case where the IOMMU output cannot the entire memory address
> space. If necessary, that would mean using both an IOMMU driver
> and swiotlb, but I think it's a reasonable assumption that hardware
> isn't /that/ crazy.

Similarily, should the IOMMU not be treated like any other device here?
Its DMA mask should determine what address range it can access.

Thierry

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfGMeAAoJEN0jrNd/PrOhv5EQALfvr2lSx0S9k01y73YuWzan
TkcAR8wOwlZPBhLHLsqHNrnFLVHTPDMLPLL6P0YRH50xBuSfwB67ARPyLly+MmOZ
csxsw/sphzZnWtw+zMO72lOkYnM+Rehea0CJCo7Vb9vIzzQythdp13OZDUCR2R1G
zhDwEsyOCU86YbCo7pWH0LfBSgYNmsYmU4qrqGpxhUYTghCmapBDX04TMZkh0uHV
hBFIYQD540KWkdSLRrSK+l4muFPycDK0iqg/xSPjwNIuuSPC0o/ljH5anPtZ3dte
h8UiGbh2H+3nGvESLDL+CutryCEGuGWmKL+nT8zfeh1p+Y6snXMsshnpbt0C3ybY
mQuqIhwhumX0gjhfB4ln0XZssy19cf85IYFFgUULQrFtUoh3bTRKg4DPTyXCKf9P
Cv+mt2azJfZq5Oc5jnv3IjppN7Cg8cL1Ut/KG2DUSZmkhioFNYo7VbDgz7r3qsE8
1YkfzCVD+DFhhEwtxIbp0aaqhLdTSEZsZSMv5tkT0im5JzpAY1/ewEnAfQKuF0lv
7DDy2v5p5pE+yGp67koMihp7quYquh/cmtlCYrq9Dqbqrl1JKjSpp8MrUMZfXKNg
xanh0H9yYaSbgEh1jAPSdZVZlYnbEaEI/t6Y0dKcDeY93O/k7ltRurDir785CS81
IVgaDo38fmuNzNO1cwC4
=jyBu
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
