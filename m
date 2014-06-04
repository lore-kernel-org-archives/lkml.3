Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaFDVMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:12:45 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:41095 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaFDVMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:12:43 -0400
Date: Wed, 4 Jun 2014 23:12:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Joerg Roedel <joro@8bytes.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140604211237.GC18710@mithrandir>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com>
 <538757B6.4010109@wwwdotorg.org>
 <20140530073006.GA24748@ulmo>
 <20140530112728.GB3949@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
In-Reply-To: <20140530112728.GB3949@e103592.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 12:27:28PM +0100, Dave Martin wrote:
> On Fri, May 30, 2014 at 08:30:08AM +0100, Thierry Reding wrote:
[...]
> > Arnd, can you take another look at this binding and see if there's
> > anything else missing? If not I'll go through the document again and
> > update all #address-cells/#size-cells references with #iommu-cells as
> > appropriate and submit v3.
>=20
> How do you envisage propagation of the master ID bits downstream of the
> IOMMU would be described?
>=20
> We will definitely need a way to describe this for GICv3.  How those
> values are propagated is likely to vary between related SoCs and doesn't
> feel like it should be baked into a driver, especially for the ARM SMMU
> which may get reused in radically different SoC families from different
> vendors.

Well, we've had cases like these in the past (power sequences come to
mind). Some concepts are just too difficult or unwieldy to be put into
device tree. I think that this is one of them.

> The most likely types of remapping are the adding of a base offset or
> some extra bits to the ID -- because not all MSIs to the GIC will
> necessarily pass through the IOMMU.  It's also possible that we might
> see ID squashing or folding in some systems.

It can easily be argued that if the algorithm used to remap the ID
varies, the compatibility of the device changes. Therefore I would
expect any variant of the GICv3 that deviates from the "standard"
mapping (if there is such a thing) to have its own compatible string.

At that point there are two possibilities: a) handle the remapping in
code hooked into the driver via matching of the compatible string or
b) specifying a different specifier for each of these and keep the
description in DT. From an implementation point of view, variant b) is
likely going to be very similar to a), though (I'm thinking .of_xlate
type of functions here).

Thierry

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTj4vFAAoJEN0jrNd/PrOheCAP/i+lBZElAIcRlK6s2zrZYOSX
92zTVfj0mb8G1wjEGuuFARffdwwjiiy6EvSMvFHelQr7eHdhBaWS1NnXDTArNeHe
1GXXRMG7v3uJaIY7FDIHWxloL+v6/8FOpiQD8oyXwnZRE7cUwp1wikYO34fwRURH
KQ4TwBNFYe8wXku1gffSYLKIF5HeN0zd+36f2E+JmbzEJEcvjagRSDdfV03uj3KA
lqzwHNuIqBzsUVBCg7SI5fInfstUOTo/yRqXA6KYNms0twy7xC5wbKi5K2MQhAl4
3xHrfwaC42Z6W2tXt8XGYRgS31V5nvq3Xg+sd/pr9v73jnwXzvyYNrlAuRBPvrPO
UdKOpI8//EqU1+abQDpO0nZZtGEPYFqg7Rljz66gCav2faEn+44qZlAsQvDIzON3
1FyEQIbFEUd/2m/RGEMO+Dhk0M0cpkVlmYteSvuNNRK/nrzCldYH8ubhGF5lFOCr
dYfZfXXRS8JT3jH1o+i4eSts/cDQr29h9rE/fqhOercD2vc6DQjzC8UHFNgO78yN
ozBhBd1EyQ1McT5SROrTqY1VXHjOAsADfP5pW2fbdDCyBnX3mVznqHYx0G5CINf7
Ux1xscC6qGldF9+xFMTXJd8g5xAglPRZzXf9pP68ZJnxV+OJcuwsDixP3zcLIpMg
UX+JzjNS4F7MccluPvrz
=xLVK
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--
