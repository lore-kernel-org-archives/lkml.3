Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaHEOOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:14:14 -0400
Received: from 8bytes.org ([81.169.241.247]:41137 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaHEOOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:14:12 -0400
Date: Tue, 5 Aug 2014 16:14:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for Linux v3.17
Message-ID: <20140805141408.GA28907@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91:

  Linux 3.16-rc7 (2014-07-27 12:41:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-updates-v3.17

for you to fetch changes up to 4c5e9d9f0ddf5d4ba9c51eee2ef1a4d6e93ccf56:

  Merge branches 'x86/vt-d', 'x86/amd', 'arm/omap', 'ppc/pamu', 'arm/smmu', 'arm/exynos' and 'core' into next (2014-07-31 20:29:02 +0200)

----------------------------------------------------------------

IOMMU Updates for Linux v3.17

This time with:

	* Support for the generic PCI device alias code in x86 IOMMU
	  drivers

	* A new sysfs interface for IOMMUs

	* Preparations for hotplug support in the Intel IOMMU driver

	* Change the AMD IOMMUv2 driver to not hold references to core
	  data structures like mm_struct or task_struct. Rely on
	  mmu_notifers instead.

	* Removal of the OMAP IOVMM interface, all users of it are
	  converted to DMA-API now

	* Make the struct iommu_ops const everywhere

	* Initial PCI support for the ARM SMMU driver

	* There is now a generic device tree binding documented for
	  ARM IOMMUs

	* Various fixes and cleanups all over the place

Also included are some changes to the OMAP code, which are acked by the
maintainer.

----------------------------------------------------------------
Alex Williamson (12):
      iommu/core: Create central IOMMU group lookup/creation interface
      iommu/amd: Update to use PCI DMA aliases
      iommu/amd: Use iommu_group_get_for_dev()
      iommu/vt-d: Use iommu_group_get_for_dev()
      iommu/vt-d: Update to use PCI DMA aliases
      iommu/fsl: Use iommu_group_get_for_dev() for IOMMU groups
      iommu: Remove pci.h
      iommu: Add sysfs support for IOMMUs
      iommu/vt-d: Make use of IOMMU sysfs support
      iommu/amd: Add sysfs support
      iommu: Fix IOMMU sysfs stubs
      iommu/vt-d: Exclude devices using RMRRs from IOMMU API domains

Alexey Skidanov (2):
      iommu/amd: Fix for pasid initialization
      iommu/amd: Moving PPR fault flags macros definitions

Borislav Petkov (1):
      iommu/amd: Drop oprofile dependency

Chi Pham (1):
      iommu/fsl: Add void declarations in zero-arg functions.

Fabian Frederick (2):
      iommu/omap: Use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE)
      iommu/fsl_pamu: Remove unnecessary null test before kfree

Greg Edwards (1):
      iommu/vt-d: Fix race setting IRQ CPU affinity while freeing IRQ

Jiang Liu (13):
      iommu/vt-d: Match segment number when searching for dev_iotlb capable devices
      iommu/vt-d: Use correct domain id to flush virtual machine domains
      iommu/vt-d: Introduce helper functions to improve code readability
      iommu/vt-d: Introduce helper functions to make code symmetric for readability
      iommu/vt-d: Allocate dynamic domain id for virtual domains only
      iommu/vt-d: Fix possible invalid memory access caused by free_dmar_iommu()
      iommu/vt-d: Avoid freeing virtual machine domain in free_dmar_iommu()
      iommu/vt-d: Simplify include/linux/dmar.h
      iommu/vt-d: Change iommu_enable/disable_translation to return void
      iommu/vt-d: Simplify intel_unmap_sg() and kill duplicated code
      iommu/vt-d: Introduce helper domain_pfn_within_range() to simplify code
      iommu/vt-d: Introduce helper function iova_size() to improve code readability
      iommu/vt-d: Fix issue in computing domain's iommu_snooping flag

Joerg Roedel (18):
      iommu/vt-d: Don't use magic number in dma_pte_superpage
      iommu: Fix compile error in iommu-sysfs.c
      Merge branch 'for-joerg/arm-smmu/updates' of git://git.kernel.org/.../will/linux into arm/smmu
      iommu/amd: Fix typo in amd_iommu_v2 driver
      iommu/amd: Don't call mmu_notifer_unregister in __unbind_pasid
      iommu/amd: Don't free pasid_state in mn_release path
      iommu/amd: Get rid of __unbind_pasid
      iommu/amd: Drop pasid_state reference in ppr_notifer error path
      iommu/amd: Add pasid_state->invalid flag
      iommu/amd: Don't hold a reference to mm_struct
      iommu/amd: Don't hold a reference to task_struct
      iommu/amd: Don't call the inv_ctx_cb when pasid is not set up
      Merge branch 'core' into x86/vt-d
      iommu/amd: Don't set pasid_state->mm to NULL in unbind_pasid
      iommu/amd: Remove change_pte mmu_notifier call-back
      iommu/amd: Fix device_state reference counting
      iommu/amd: Fix 2 typos in comments
      Merge branches 'x86/vt-d', 'x86/amd', 'arm/omap', 'ppc/pamu', 'arm/smmu', 'arm/exynos' and 'core' into next

Laurent Pinchart (3):
      iommu/omap: Remove virtual memory manager
      ARM: omap: Don't set iommu pdata da_start and da_end fields
      iommu/omap: Remove platform data da_start and da_end fields

Mitchel Humpherys (1):
      iommu/arm-smmu: fix some checkpatch issues

Thierry Reding (2):
      iommu: Constify struct iommu_ops
      devicetree: Add generic IOMMU device tree bindings

Tushar Behera (1):
      iommu/exynos: Select ARM_DMA_USE_IOMMU

Will Deacon (6):
      iommu/arm-smmu: fix calculation of TCR.T0SZ
      iommu/arm-smmu: add support for PCI master devices
      iommu/arm-smmu: caps: add IOMMU_CAP_INTR_REMAP capability
      iommu/arm-smmu: remove support for chained SMMUs
      iommu/arm-smmu: prefer stage-1 mappings where we have a choice
      iommu/arm-smmu: fix capability checking prior to device attach

Yijing Wang (7):
      iommu/vt-d: Use list_for_each_safe() to simplify code
      iommu/vt-d: Clear the redundant assignment in dmar_enable_qi
      iommu/vt-d: Clear the redundant assignment for domain->nid
      iommu/vt-d: Use inline function dma_pte_superpage instead of macros
      iommu/vt-d: Fix reference count in iommu_prepare_isa
      iommu/vt-d: Remove the useless dma_pte_addr
      iommu/vt-d: Suppress compiler warnings

 Documentation/ABI/testing/sysfs-class-iommu        |  17 +
 .../ABI/testing/sysfs-class-iommu-amd-iommu        |  14 +
 .../ABI/testing/sysfs-class-iommu-intel-iommu      |  32 +
 .../devicetree/bindings/iommu/arm,smmu.txt         |   6 -
 Documentation/devicetree/bindings/iommu/iommu.txt  | 182 +++++
 arch/arm/mach-omap2/omap-iommu.c                   |   2 -
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   4 -
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   4 -
 drivers/iommu/Kconfig                              |  13 +-
 drivers/iommu/Makefile                             |   2 +-
 drivers/iommu/amd_iommu.c                          | 224 ++----
 drivers/iommu/amd_iommu_init.c                     |  38 +
 drivers/iommu/amd_iommu_types.h                    |  10 +-
 drivers/iommu/amd_iommu_v2.c                       | 107 ++-
 drivers/iommu/arm-smmu.c                           | 495 ++++++------
 drivers/iommu/dmar.c                               |  12 +-
 drivers/iommu/exynos-iommu.c                       |   2 +-
 drivers/iommu/fsl_pamu.c                           |   2 +-
 drivers/iommu/fsl_pamu_domain.c                    |  73 +-
 drivers/iommu/intel-iommu.c                        | 874 ++++++++++-----------
 drivers/iommu/intel_irq_remapping.c                |  60 +-
 drivers/iommu/iommu-sysfs.c                        | 134 ++++
 drivers/iommu/iommu.c                              | 201 ++++-
 drivers/iommu/ipmmu-vmsa.c                         |   2 +-
 drivers/iommu/msm_iommu.c                          |   2 +-
 drivers/iommu/omap-iommu-debug.c                   | 114 ---
 drivers/iommu/omap-iommu.c                         |  15 +-
 drivers/iommu/omap-iommu.h                         |   8 +-
 drivers/iommu/omap-iovmm.c                         | 791 -------------------
 drivers/iommu/pci.h                                |  29 -
 drivers/iommu/shmobile-iommu.c                     |   2 +-
 drivers/iommu/tegra-gart.c                         |   2 +-
 drivers/iommu/tegra-smmu.c                         |   2 +-
 include/linux/amd-iommu.h                          |   7 +
 include/linux/device.h                             |   2 +-
 include/linux/dmar.h                               |  50 +-
 include/linux/intel-iommu.h                        |   3 +
 include/linux/iommu.h                              |  32 +-
 include/linux/iova.h                               |   5 +
 include/linux/omap-iommu.h                         |  37 +-
 include/linux/platform_data/iommu-omap.h           |   6 -
 41 files changed, 1567 insertions(+), 2050 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-iommu
 create mode 100644 Documentation/ABI/testing/sysfs-class-iommu-amd-iommu
 create mode 100644 Documentation/ABI/testing/sysfs-class-iommu-intel-iommu
 create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt
 create mode 100644 drivers/iommu/iommu-sysfs.c
 delete mode 100644 drivers/iommu/omap-iovmm.c
 delete mode 100644 drivers/iommu/pci.h

Please pull.

Thanks,

	Joerg


--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJT4OawAAoJECvwRC2XARrjgXYP/RYZjMoH9h3AtHo+B05TdICK
3865aTOolv23aIsTgKIzsyfYOw+hYFLxGcp9gK0GXdJvgagXLuwdXnclqNbhwCSN
aWLEAVgng7db0orDGo5ypPAy3ZP3tblUJuwdNHWqHkFREBvtYBZI0VT+63fbvCBQ
XxsndHv87v70Bc56xcMvK+9fLkz9FLyjri//WugAeEyR42gRyQVSee2fhetwwKQm
QYlOAXzrJ0B5apex1/qQ3TKlWCEXI2HMUPTbKLX8WmbrfTzRiMkuYJtEx52ab8xt
pM0XnpR3A760P7zE+3a8J0PiA97zBdnUajukeD/ELRGhmDdRhhDDdjfimvZMfXik
hgx6m3QUhKLTTPvYKV3HIjcLc477s8qSPMUAVU2eKceFSoOxRoBbRgAwHAEkPwuq
4UL56JD07tCIMgrfKYRTyF0T2niWTGU4J1iQuAE03nV0dwa/23BJ4+I7GvqHwlm9
lApgXJT9Ii319NMDDeAEJTLP8mcoh6WJ2EHvCiLv3fU4jD7EqPISG9i+HKuYGzb8
1lXFyLhtQ3MxCAvieIliTxLOCoUqpRom5/HatvoWKOHjO+6r6ZZzB7xymqedXN8q
9pCe9IQZ91ypQjbhKY/W2h1HUm3F9g4rk2eCTNyKfDR94zv8dWEjf1q2g0VoHwG/
6CoLzIMzIr94RXRh/3/F
=5Hg/
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
