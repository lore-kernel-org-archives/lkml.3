Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaFEPuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:50:24 -0400
Received: from 8bytes.org ([85.214.48.195]:53243 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbaFEPuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:50:20 -0400
Date: Thu, 5 Jun 2014 17:50:16 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for Linux v3.16
Message-ID: <20140605155016.GA12798@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun  5 17:50:18 2014
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 539091ba20868443016726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit c7208164e66f63e3ec1759b98087849286410741:

  Linux 3.15-rc7 (2014-05-25 16:06:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-updates-v3.16

for you to fetch changes up to c0981b863a31a1891aa2719957983f4297770f87:

  Merge branches 'iommu/fixes', 'arm/omap', 'arm/smmu', 'arm/shmobile', 'x86/amd', 'arm/exynos', 'arm/renesas', 'ppc/pamu' and 'arm/msm' into next (2014-05-30 20:22:10 +0200)

----------------------------------------------------------------

IOMMU Updates for Linux v3.16

The changes include:

	* A new IOMMU driver for ARM Renesas SOCs

	* Updates and fixes for the ARM Exynos driver to bring it closer
	  to a usable state again

	* Convert the AMD IOMMUv2 driver to use the
	  mmu_notifier->release call-back instead of the task_exit
	  notifier

	* Random other fixes and minor improvements to a number of other
	  IOMMU drivers

----------------------------------------------------------------
Antonios Motakis (1):
      iommu/exynos: Add devices attached to the System MMU to an IOMMU group

Bjorn Helgaas (1):
      iommu/exynos: Remove unnecessary "&" from function pointers

Cho KyongHo (18):
      iommu/exynos: Fix build errors
      iommu/exynos: Change error handling when page table update is failed
      iommu/exynos: Allocate lv2 page table from own slab
      iommu/exynos: Fix L2TLB invalidation
      iommu/exynos: Remove prefetch buffer setting
      iommu/exynos: Add missing cache flush for removed page table entries
      iommu/exynos: Always enable runtime PM
      iommu/exynos: Remove dbgname from drvdata of a System MMU
      iommu/exynos: Use managed device helper functions
      iommu/exynos: Gating clocks of master H/W
      iommu/exynos: Remove custom fault handler
      iommu/exynos: Change rwlock to spinlock
      iommu/exynos: Use exynos-iommu specific typedef
      iommu/exynos: Enhanced error messages
      documentation: iommu: Add binding document of Exynos System MMU
      iommu/exynos: Support for device tree
      iommu/exynos: Turn on useful configuration options
      iommu/exynos: Apply workaround of caching fault page table entries

Joerg Roedel (10):
      Merge branch 'for-joerg/arm-smmu/updates' of git://git.kernel.org/.../will/linux into arm/smmu
      Merge branch 'iommu/for-v3.16' of git://linuxtv.org/pinchartl/fbdev into arm/shmobile
      iommu/amd: Don't access IOMMUv2 state_table directly
      iommu/amd: Convert IOMMUv2 state_table into state_list
      iommu/amd: Implement mmu_notifier_release call-back
      iommu/amd: Remove IOMMUv2 pasid_state_list
      iommu/amd: Handle parallel invalidate_range_start/end calls correctly
      arm/ipmmu-vmsa: Fix compile error
      iommu/amd: Fix recently introduced compile warnings
      Merge branches 'iommu/fixes', 'arm/omap', 'arm/smmu', 'arm/shmobile', 'x86/amd', 'arm/exynos', 'arm/renesas', 'ppc/pamu' and 'arm/msm' into next

Kefeng Wang (2):
      iommu/arm-smmu: fix incorrect use of S2CR_TYPE_SHIFT
      iommu/msm: Use devm_ioremap_resource to simplify code

Laurent Pinchart (15):
      iommu/omap: Fix 'no page for' debug message in flush_iotlb_page()
      iommu/omap: Remove comment about supporting single page mappings only
      iommu/omap: Fix map protection value handling
      iommu/shmobile: Don't ignore the ipmmu_iommu_init() return value
      iommu/shmobile: Use devm_ioremap_resource()
      iommu: Add driver for Renesas VMSA-compatible IPMMU
      iommu/ipmmu-vmsa: Refactor micro-TLB lookup
      iommu/ipmmu-vmsa: Fix the supported page sizes
      iommu/ipmmu-vmsa: Define driver-specific page directory sizes
      iommu/ipmmu-vmsa: Set the PTE contiguous hint bit when possible
      iommu/ipmmu-vmsa: PMD is never folded, PUD always is
      iommu/ipmmu-vmsa: Rewrite page table management
      iommu/ipmmu-vmsa: Support 2MB mappings
      iommu/ipmmu-vmsa: Remove stage 2 PTE bits definitions
      iommu/ipmmu-vmsa: Support clearing mappings

Rickard Strandqvist (1):
      iommu: fsl_pamu.c: Fix for possible null pointer dereference

Sachin Kamat (3):
      iommu/exynos: Remove invalid symbol dependency
      iommu/exynos: Fix trivial typo
      iommu/exynos: Fix checkpatch warning

Shaik Ameer Basha (1):
      documentation/iommu: Add note on existing DT binding status

Suman Anna (3):
      iommu/omap: Correct init value of iotlb_entry valid field
      iommu/omap: Remove omap_iommu_domain_has_cap() function
      iommu/omap: Move to_iommu definition from omap-iopgtable.h

Vaughan Cao (1):
      iommu/amd: Remove duplicate checking code

Will Deacon (1):
      iommu/arm-smmu: allow 42-bit stage-1 output size with 64K pages

 .../devicetree/bindings/iommu/samsung,sysmmu.txt   |   70 ++
 drivers/iommu/Kconfig                              |   26 +-
 drivers/iommu/Makefile                             |    1 +
 drivers/iommu/amd_iommu.c                          |    8 -
 drivers/iommu/amd_iommu_v2.c                       |  184 ++-
 drivers/iommu/arm-smmu.c                           |    4 +-
 drivers/iommu/exynos-iommu.c                       | 1052 +++++++++-------
 drivers/iommu/fsl_pamu.c                           |    3 +-
 drivers/iommu/ipmmu-vmsa.c                         | 1255 ++++++++++++++++++++
 drivers/iommu/msm_iommu_dev.c                      |   38 +-
 drivers/iommu/omap-iommu.c                         |   31 +-
 drivers/iommu/omap-iopgtable.h                     |    3 -
 drivers/iommu/shmobile-ipmmu.c                     |   20 +-
 include/linux/platform_data/ipmmu-vmsa.h           |   24 +
 14 files changed, 2094 insertions(+), 625 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
 create mode 100644 drivers/iommu/ipmmu-vmsa.c
 create mode 100644 include/linux/platform_data/ipmmu-vmsa.h

Please pull.

Thanks,

	Joerg


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTkJG3AAoJECvwRC2XARrj4WIQANfKRKRTzb1j23dxFIL1nyRu
A2xRv/8Z78UHRTdc9veYuq/7flEtpjPTAtlwXszTYSrBLEK/W8iODZV7D4YdPwjE
LlUwa4CvskLFH9sDbLRJsG4eucbiXutT/sTGJ8upGWeCDnsAognE3wGXtdU9w9iC
yO3t/CkSkYSjychbaT8H+7eCDXt54X2qkqbiomFW/QPKZ5ZvIHIWoAS9Aw7Vi6oS
CuZimmhyUFngy8dalQ3/V1kY9che7MmLvpvO6JNTWQ7aTsxwBmhgrm0L8K/V7Ru4
y/AeT2aLV57MFwcjzfvhHkjuqGtcUJy6qHAnhEe0ojSfzJ0mQ+ipX56fohNYwiHV
/kx6qqwZMXsKyGzjtEQbWPebirdjanAeb3BvtIMxJ3ZLGXFWlctzjfLfX0Hlvs0d
O0sNu2hIVx1uE1uRrWcpivY0lGoSKHOMslx4y5fFU7L+MECoFd9RMgHP4IN0lQ65
dMifmNwDApluaSIYfMuLiTEEonDFqvsUv54kcEOULpeiqRnxEOgKpaOQDim1oefk
yasQbdat8IrvsTy13JADu6geJJKhsPjKFjSA84qYV7c2pNQaa+hxCQS/BLo7Kt54
vvwh64icMwu+GQSo+mlclhWwp5PqhE40s67LsazQefq37HaQVaG5J+c6mO2ghc6l
399gRZpI7Q3Cw4SrTYys
=rySK
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--


