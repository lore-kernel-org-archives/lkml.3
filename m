Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaFQMBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:01:46 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:48254 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaFQMBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:01:44 -0400
Date: Tue, 17 Jun 2014 13:58:30 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Dave P Martin <Dave.Martin@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140617115829.GB18816@ulmo>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com>
 <538757B6.4010109@wwwdotorg.org>
 <20140530073006.GA24748@ulmo>
 <20140530112728.GB3949@e103592.cambridge.arm.com>
 <20140604211237.GC18710@mithrandir>
 <20140616125704.GE16758@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <20140616125704.GE16758@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2014 at 01:57:04PM +0100, Will Deacon wrote:
> On Wed, Jun 04, 2014 at 10:12:38PM +0100, Thierry Reding wrote:
> > On Fri, May 30, 2014 at 12:27:28PM +0100, Dave Martin wrote:
> > > On Fri, May 30, 2014 at 08:30:08AM +0100, Thierry Reding wrote:
> > [...]
> > > > Arnd, can you take another look at this binding and see if there's
> > > > anything else missing? If not I'll go through the document again and
> > > > update all #address-cells/#size-cells references with #iommu-cells =
as
> > > > appropriate and submit v3.
> > >=20
> > > How do you envisage propagation of the master ID bits downstream of t=
he
> > > IOMMU would be described?
> > >=20
> > > We will definitely need a way to describe this for GICv3.  How those
> > > values are propagated is likely to vary between related SoCs and does=
n't
> > > feel like it should be baked into a driver, especially for the ARM SM=
MU
> > > which may get reused in radically different SoC families from differe=
nt
> > > vendors.
> >=20
> > Well, we've had cases like these in the past (power sequences come to
> > mind). Some concepts are just too difficult or unwieldy to be put into
> > device tree. I think that this is one of them.
> >=20
> > > The most likely types of remapping are the adding of a base offset or
> > > some extra bits to the ID -- because not all MSIs to the GIC will
> > > necessarily pass through the IOMMU.  It's also possible that we might
> > > see ID squashing or folding in some systems.
> >=20
> > It can easily be argued that if the algorithm used to remap the ID
> > varies, the compatibility of the device changes. Therefore I would
> > expect any variant of the GICv3 that deviates from the "standard"
> > mapping (if there is such a thing) to have its own compatible string.
>=20
> There is no standard mapping; it's a property defined at system integrati=
on
> time. I fully expect different SoCs to do different things here.

My point was that the mapping itself seems to be fundamental enough to
make devices with different mappings "incompatible". Therefore I think
this could probably be handled by using different compatible values,
something along the lines of this:

	compatible =3D "vendor,soc-gicv3", "arm,gicv3";

Then the mapping can be described in code, which should be a whole lot
easier and more flexible than a more or less generic notation in device
tree.

Thierry

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToC1lAAoJEN0jrNd/PrOhoDoQAIrRLnCfk4INnOK9LyQbVali
ZiChXj0F9DYqy+drqd/trV4ogPjHcaylSGyK4w/3c0kpEr8ENs0axnoDtO34HxFz
AU1LoFTaNZoevj3ZUC7XN26CUgGRe/Jq9+BolD0c5Jw41mD0mStKpJTSZOPkGpYs
8b7y+2/04s2uidndI6oOymM2Yp3rC8qAsjI6ppBE0oypwRzzcvBS65JIod3MKIx9
oYDOMan8+twFIBXl4DP5azQv8sGfCMdM4cv1436jTNRJXW2E2hoN4D3ED6tDOFWK
ubucFt7o0YPbsJkVgpXt2o8qUw9f99+h0UE9n+92mzpnzykfe1BrNX3TS7Rb/smw
ZIbgJsCjOsCmPLfpXlaFxf3dHPh2Fz73vXWz/8jm+pFgW+QLZ37tLLRssuTZzMlZ
cdRivcKVrkN+pDvsJ8atZ/fL2c00kc3l0pjdFUVL8+M5qn8/Xbg2S/GBItL6d2Kk
Ij9gg/6irAjjnrpyUzCjXU3R2ILeBDHSc1iLUjwx0tV70qVbheFylNsPMJisUDeu
Bbevv4mMsvxSwiei+FHHGlJ5VGeZx4NoII8a0HnROLdd5T1x8+WnHFQpwnYD8wxz
pkI7pCIB5RpMw+1bq6XWiwym0TU9Ep3Qkabc0oknnJ8NnikvLStPW3AMFsWeFaKR
anoBpU795w1snQT2xFWG
=sthc
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
