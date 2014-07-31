Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbaGaKJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:09:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59397 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaGaKJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:09:14 -0400
Date: Thu, 31 Jul 2014 12:09:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140731100905.GA7458@ulmo>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140730152646.GC20162@leverpostej>
 <CAOesGMi3zM1-cqmeGddJ69RNXx0ktFm_zXO_yq7N0EeA3HNrUQ@mail.gmail.com>
 <20140730181842.GG20162@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20140730181842.GG20162@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 07:18:42PM +0100, Mark Rutland wrote:
[...]
> > >> +
> > >> +Multiple-master IOMMU with configurable DMA window:
> > >> +---------------------------------------------------
> > >> +
> > >> +     / {
> > >> +             #address-cells =3D <1>;
> > >> +             #size-cells =3D <1>;
> > >> +
> > >> +             iommu {
> > >> +                     /* master ID, address and length of DMA window=
 */
> > >> +                     #iommu-cells =3D <4>;
> > >> +             };
> > >> +
> > >> +             master {
> > >> +                     /* master ID 42, 4 GiB DMA window starting at =
0 */
> > >> +                     iommus =3D <&/iommu  42  0  0x1 0x0>;
> > >
> > > Is this that window is from the POV of the master, i.e. the master can
> > > address 0x0 to 0xffffffff when generating transactions, and these get
> > > translated somehow?
> > >
> > > Or is this the physical addresses to allocate to the master?
> >=20
> > It needs to be clarified in the documentation, but as far as I know it
> > is the DMA address space that is used.
>=20
> Ok. So that's pre-translation, from the POV of the master?

Correct. It represents the window of the IOMMU's addressable I/O virtual
address space that should be assigned to this particular master.

> If we don't have that knowledge about the master already (e.g. based on
> the compatible string), surely we always need that information in a
> given iommu-specifier format? Otherwise certain iommus won't be able to
> handle masters with limited addressing only due to limitations of their
> binding.

This is only used for what's often called a windowed IOMMU. Many IOMMUs
(non-windowed) typically allow only a complete address space to be
assigned to a master without additional control over subregions. So this
is really a property/capability of the IOMMU rather than the masters
themselves.

There are already other means to respect the addressing limitations of
masters. We typcially use a device's DMA mask for this, and it's natural
to reuse that for I/O virtual addresses since they will in fact take the
place of physical addresses for the master when translation is enabled.

Thierry

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2hXBAAoJEN0jrNd/PrOhuRYP/1FmGWrTgAmEHgjkkvtOXP/a
vuqoaIZ3/U0tvA/CKMeBwrGWEbv+J8/y0XXYUj7UPnvB4lo6KKymFwWCp2DoaUyt
szt9210CIhfFdFpCANjJRpTUqkPrUrtp6dcF0W0EnbzVAGJitkrJaYUZF/KF806z
o2fodgySJk/VMabQ/Zol3XvrTrbuNpigLkTy2haB8ONuCcxLChhM91gMh+zhbjgZ
YqD2ltczrRWt9DuTvmoSQxonGZQhjyn2SFQB40Twsq3DNKtnjOlMm6rXxKs9GSuc
uBZbYmKPHo6bTchWNHGcuZ/klu8pwai0zeXkTcmjOmRuicZ0pJn1Tw6DC75zrpyN
vG8HJ4Yj0p/Fd2bDrGjp6xY9GrdjPAOsz9pT/TblphLUIx6VEFeef3G5IcDcyzHm
kw5sbG1j4bpSMdNYLCe0IxAuttA04Bnhq/tlmYCI2+tlh7VrjpGk+1pbYdTrMh20
URr6wE5wNbgiuk6UsInrNqT4zfmvFW4H+gjaRb7DzzS4XsWx1p/329FL5524fnlC
4mEGQwhbk+gVGtRIdRQKF2rhh1R4yXC4D/yUnTV5Uwm+WSauvEx5Mq6vHl6T4K+3
fw3X5QoZ6eZPSW13DJqXN2zqet8hyq/TMyixOIBrZfSWRRIhkJX8OW+7i/CFInLu
PbaRSzzA1ijTjAIHpm0A
=Z04E
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
