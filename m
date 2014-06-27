Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaF0IRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:17:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65101 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaF0IRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:17:05 -0400
Date: Fri, 27 Jun 2014 10:17:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Joseph Lo <josephl@nvidia.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <AMartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
Message-ID: <20140627081659.GA10794@ulmo>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
 <53AD2020.1050802@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <53AD2020.1050802@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2014 at 03:41:20PM +0800, Joseph Lo wrote:
> Hi Thierry,
>=20
> On 06/27/2014 04:49 AM, Thierry Reding wrote:
> [snip]
> >+
> >+#define MC_INTSTATUS 0x000
> >+#define  MC_INT_DECERR_MTS (1 << 16)
> >+#define  MC_INT_SECERR_SEC (1 << 13)
> >+#define  MC_INT_DECERR_VPR (1 << 12)
> >+#define  MC_INT_INVALID_APB_ASID_UPDATE (1 << 11)
> >+#define  MC_INT_INVALID_SMMU_PAGE (1 << 10)
> >+#define  MC_INT_ARBITRATION_EMEM (1 << 9)
> >+#define  MC_INT_SECURITY_VIOLATION (1 << 8)
> >+#define  MC_INT_DECERR_EMEM (1 << 6)
> >+#define MC_INTMASK 0x004
> >+#define MC_ERR_STATUS 0x08
> >+#define MC_ERR_ADR 0x0c
> >+
> [snip]
> >+
> >+#define SMMU_PDE_ATTR          (SMMU_PDE_READABLE | SMMU_PDE_WRITABLE |=
 \
> >+                                SMMU_PDE_NONSECURE)
> >+#define SMMU_PTE_ATTR          (SMMU_PTE_READABLE | SMMU_PTE_WRITABLE |=
 \
> >+                                SMMU_PTE_NONSECURE)
> >+
> >+#define SMMU_PDE_VACANT(n)     (((n) << 10) | SMMU_PDE_ATTR)
> >+#define SMMU_PTE_VACANT(n)     (((n) << 12) | SMMU_PTE_ATTR)
>=20
> There is an ISR to catch the invalid SMMU translation. Do you want to mod=
ify
> the identity mapping with read/write attribute of the unused SMMU pages?

I'm not sure I understand what you mean by "identity mapping". None of
the public documentation seems to describe the exact layout of PDEs or
PTEs, so it's somewhat hard to tell what to set them to when pages are
unmapped.

> This can make sure we capture the invalid SMMU translation. And helps for
> driver to capture issues when using SMMU.

That certainly sounds like a useful thing to have. Like I said this is
an RFC and I'm not even sure if it's acceptable in the current form, so
I wanted to get feedback early on to avoid wasting effort on something
that turn out to be a wild-goose chase.

Thierry

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrSh7AAoJEN0jrNd/PrOhHXsQAIofIx+IcObVIU5pebdVPE64
KB9+bvQGZfjn6EiaoqDuJ9DsiFKhWFrn3cFXZM9nkgYioPK/IVY6/wPguoC1MEW3
95sX9SkVhXjjbQOLAuDu2hYJZXB0ljpYnV23ag2rJtCcqQqOoiKuSdziqSmoYPdA
JerEdaZQRU3yy0wBGkG+pAeHCZLmJCX6zAGYGqIaFks9Y7TUE3tfLOffZHxY22nc
uMP7Q756Py1KMxObpEcU6twL5I6gRloVP8maES54ZfNJ2aUMDyhHHn0+2LMEil1f
4nEmkOuFTBgJpMHtzA4I1VtudRzsDXbrINgEP1WVyUrmol1xwI918+kMj3ap+Pd0
H5Qw0AvlXsIvTYSVj+y+mrPrfTR07m1vxutUE1Fxcj7FI55X7HLM3aaAG+Qrxei4
z41szUY1JSxLBPJckbhdyV5EA290y9n/8iCRMCzITeohXM1JDTg5Qa91eGPtvAYa
rRbJEE5mPdkIRAlieTUrqxKaZ0k4mYQNd7v5AuglEA42FMEJB1YugkcveKVMpOdg
x3sfPuT1lHGsMcM1G/s11zWeGK1Mc4dWbiwTdaXMGDgdC9pjG79Zo8pBObocJSlH
YlPCizYYlOizZoOMp5fCoc2QFwCwxJ2XNYUs8fhY2veSOF9yN6SZFzTwsMxUMS81
makzzz/StBEFKD5aUsLM
=DBY2
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
