Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaBUOFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:05:02 -0500
Received: from 8bytes.org ([85.214.48.195]:43930 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbaBUOFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:05:00 -0500
Date: Fri, 21 Feb 2014 15:04:54 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for Linux v3.14-rc3
Message-ID: <20140221140452.GA5472@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Feb 21 15:04:57 2014
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53075d0920861639110949
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.14-rc3

for you to fetch changes up to 972157cac528f6cfd1f7e640139287951066106e:

  arm/smmu: Use irqsafe spinlock for domain lock (2014-02-20 13:04:47 +0100)

----------------------------------------------------------------
IOMMU Fixes for Linux v3.14-rc3

The fixes are only for the ARM-SMMU driver. Here is the summary from
Will Deacon:

  - Andreas Herrmann took the driver for a run with a real SATA
    controller, which caused the new mutex-based locking to explode
    since we require mappings in atomic context

  - Yifan fixed an issue with the page table creation, which then caused
    breakages with the way in which we flush descriptors out to the
    table walker

  - I ran the driver on a system where the SMMU is hooked into a
    coherent interconnect for table walks, and noticed a shareability
    mismatch between the CPU and the SMMU

These issues are all fixed here and have been tested on both arm and
arm64 based systems.

Besides that I put a fix on-top to make the spinlock irq-safe, so that the
code-paths can be used in the DMA-API.

----------------------------------------------------------------
Joerg Roedel (2):
      Merge branch 'for-joerg/arm-smmu/fixes' of git://git.kernel.org/.../will/linux into iommu/fixes
      arm/smmu: Use irqsafe spinlock for domain lock

Will Deacon (4):
      iommu/arm-smmu: really fix page table locking
      iommu/arm-smmu: fix table flushing during initial allocations
      iommu/arm-smmu: set CBARn.BPSHCFG to NSH for s1-s2-bypass contexts
      iommu/arm-smmu: fix compilation issue when !CONFIG_ARM_AMBA

Yifan Zhang (1):
      iommu/arm-smmu: fix pud/pmd entry fill sequence

 drivers/iommu/arm-smmu.c |  105 +++++++++++++++++++++++++++-------------------
 1 file changed, 63 insertions(+), 42 deletions(-)

Please pull.

Thanks,

	Joerg


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTB10EAAoJECvwRC2XARrj03gQAMpnhWNyV/aiu0Xr5ah8DfMa
T/dFu4BrwezXWKfDoqs8Fzb6ySqzET7uLz+pymPheHmyAVmGH5noZ88eN3m7tjg2
/MJZmkDblY7TRSnqUZowfkY72j9y26nMKYagWG5FrAV5zGJuwK9Kz4OdR2crnks0
cpVPm6ZI+ahtbTiNAco0hFYBAGF78qLhTjRfuKzi7exvXYV0k8+gJkjrms3A7pCj
qONr5fwJz7e7fxVc23I1MUUavA9mtfQqK7LLgVl4dyILx/E3YOxtmUUMmDbW3vxU
H4rJh1U25vO2gxBe0Dfnb8AmC2JwQbxIKifW0/5BP6K773QdfHYICPSk8fHIqkG1
EV4XIHmfQCEmqkmAGFapJpfcXEmi84ImBqnuWYW5/Wtu5zJGb84oQEZGLbPqPjPj
j2boChFuzYLLF9YDjbGGW2uluO6z/9XY7cstqNVTiTOxR10t/dmpXmD3OI7fCdQl
EySlEw1UZMnNgeNCCfrun05+a1+EZ6M2MbYg5mAorIPeLn9JG+sXzj5Pvv7rg77S
43VSr5gxALLKrBU4+eN2JVj6HIDwVXvEe5exVe/lABIbrmRpd763dcBgoa9+yhOL
vM1iOU5AP9w4b8Xg1eK8B6L36n0+A9sV4yq84I/w4j+Q5/fD7bZSkPgsStt8c5Hf
AYFevvG/C4/lbjNCvj+g
=zgKU
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--


