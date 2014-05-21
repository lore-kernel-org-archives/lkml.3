Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaEUJDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:03:01 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63726 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaEUJC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:02:57 -0400
Date: Wed, 21 May 2014 11:00:38 +0200
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
Message-ID: <20140521090037.GA19268@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <5612206.Fzsy1mf3q3@wuerfel>
 <20140521082606.GB11068@ulmo>
 <4367469.BqpJyVF8PT@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <4367469.BqpJyVF8PT@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 10:50:38AM +0200, Arnd Bergmann wrote:
> On Wednesday 21 May 2014 10:26:11 Thierry Reding wrote:
> > On Tue, May 20, 2014 at 10:26:12PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 20 May 2014 16:24:59 Dave Martin wrote:
> > > > On Tue, May 20, 2014 at 02:41:18PM +0200, Arnd Bergmann wrote:
> > > > > On Tuesday 20 May 2014 14:02:43 Thierry Reding wrote:
> > [...]
> > > > > > Multiple-master IOMMU:
> > > > > > ----------------------
> > > > > >=20
> > > > > > 	iommu {
> > > > > > 		/* the specifier represents the ID of the master */
> > > > > > 		#address-cells =3D <1>;
> > > > > > 		#size-cells =3D <0>;
> > > >=20
> > > > How do we know the size of the input address to the IOMMU?  Do we
> > > > get cases for example where the IOMMU only accepts a 32-bit input
> > > > address, but some 64-bit capable masters are connected through it?
> > >=20
> > > I was stuck on this question for a while before, but then I realized
> > > that it doesn't matter at all: It's the IOMMU driver itself that
> > > manages the address space, and it doesn't matter if a slave can
> > > address a larger range than the IOMMU can accept. If the IOMMU
> > > needs to deal with the opposite case (64-bit input addresses
> > > but a 32-bit master), that limitation can be put into the specifier.
> >=20
> > Isn't this what DMA masks are for? Couldn't the IOMMU simply use the
> > master device's DMA mask to do the right thing here?
>=20
> Ah, yes. I guess that's the right way to do it.
>=20
> > > > For determining dma masks, it is the output address that it
> > > > important.  Santosh's code can probably be taught to handle this,
> > > > if given an additional traversal rule for following "iommus"
> > > > properties.  However, deploying an IOMMU whose output address size
> > > > is smaller than the=20
> > >=20
> > > Something seems to be missing here. I don't think we want to handle
> > > the case where the IOMMU output cannot the entire memory address
> > > space. If necessary, that would mean using both an IOMMU driver
> > > and swiotlb, but I think it's a reasonable assumption that hardware
> > > isn't /that/ crazy.
> >=20
> > Similarily, should the IOMMU not be treated like any other device here?
> > Its DMA mask should determine what address range it can access.
>=20
> Right. But for that we need a dma-ranges property in the parent of the
> iommu, just so the mask can be set correctly and we don't have to
> rely on the 32-bit fallback case.

Shouldn't the IOMMU driver be the one to set the DMA mask for the device
in exactly the same way that other drivers override the 32-bit default?

Thierry

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfGs1AAoJEN0jrNd/PrOhIPwP/R1z0diAWm8nHHeDV0xiIRxS
tLD/7OIxrBGp1JC6wg86r1tsq7hKW3c09mpSc8cooDJTcRL6PCT8RQCEguITP7Xe
OHpT/QX6guTwpD+HBCEOmB0sDuitF5Ut7aoGqA1EjDctBTIRLnvzBHMmVshUBbQv
X6XEmaobZxv1SO1JBaETX1HyWaLsIbiw4ScFzEmtVX69OnCM1IlggJK713DLV79N
fDaQA67znm7Ee6iWoyIU1x3Dkl/l1Hy/S4cRZCemuk94uaVQopbqn122ylbS/iFz
sx/ceZu0lBf9W0atWk0gek+r6/CfGp/YU1VW+3mX1S/dr2OoxygC8ZOwRCxWhvlw
2CBScvd1u/HgK++rrZaZ7vN5kZ8XZWufPOeoPJHOo0JdccRDw6F6AjYYGCbNDPZg
4TS+MveTZodRa8LkdFAWnGepZdTmEbKMxoATfQLtrndvy76ZW3HE5BWH/iXhBjGY
h4Zy6Ufdx1qhg6P8nw3QO5h93pGCwK4QTtbluj7986dpLEYVsLJi666LcrFEq5mf
gBUVE1Us7LXa4XrWmD3eqJE9NEEOf8KPI6bhGY0CVNEvXP5y+qn2BFHbh1dJFAcj
EVZDadDReFEowOqaoLf0oLEAOBtA3rcICxM/Fafl0MQ25NIVx8oU9AB0RfznWOAN
t3Bf1w5/uGATq9ZIWvPh
=SiJ1
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
