Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaJNIdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:33:15 -0400
Received: from 8bytes.org ([81.169.241.247]:50301 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbaJNIdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:33:10 -0400
Date: Tue, 14 Oct 2014 10:33:07 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for Linux v3.18
Message-ID: <20141014083307.GA9598@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-updates-v3.18

for you to fetch changes up to 09b5269a1b3d47525d7c25efeb16f5407ef82ea2:

  Merge branches 'arm/exynos', 'arm/omap', 'arm/smmu', 'x86/vt-d', 'x86/amd' and 'core' into next (2014-10-02 12:24:45 +0200)

----------------------------------------------------------------

IOMMU Updates for Linux v3.18

This pull-request includes:

	* Change in the IOMMU-API to convert the former iommu_domain_capable
	  function to just iommu_capable

	* Various fixes in handling RMRR ranges for the VT-d driver (one fix
	  requires a device driver core change which was acked
	  by Greg KH)

	* The AMD IOMMU driver now assigns and deassigns complete alias groups
	  to fix issues with devices using the wrong PCI request-id

	* MMU-401 support for the ARM SMMU driver

	* Multi-master IOMMU group support for the ARM SMMU driver

	* Various other small fixes all over the place

----------------------------------------------------------------
Alex Williamson (2):
      iommu: Rework iommu_group_get_for_pci_dev()
      iommu/amd: Split init_iommu_group() from iommu_init_device()

Andreea-Cristina Bernat (1):
      iommu: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Jan Kiszka (1):
      iommu/vt-d: Don't store SIRTP request

Joerg Roedel (23):
      iommu/amd: Move struct iommu_dev_data to amd_iommu.c
      iommu/amd: Keep a list of devices in an alias group
      iommu/amd: Attach and detach complete alias group
      iommu/amd: Remove device binding reference count
      Merge branch 'for-joerg/arm-smmu/updates' of git://git.kernel.org/.../will/linux into arm/smmu
      iommu: Convert iommu-caps from define to enum
      iommu: Introduce iommu_capable API function
      iommu/amd: Convert to iommu_capable() API function
      iommu/arm-smmu: Convert to iommu_capable() API function
      iommu/fsl: Convert to iommu_capable() API function
      iommu/vt-d: Convert to iommu_capable() API function
      iommu/msm: Convert to iommu_capable() API function
      iommu/tegra: Convert to iommu_capable() API function
      kvm: iommu: Convert to use new iommu_capable() API function
      vfio: Convert to use new iommu_capable() API function
      IB/usnic: Convert to use new iommu_capable() API function
      iommu: Remove iommu_domain_has_cap() API function
      iommu/amd: Fix devid mapping for ivrs_ioapic override
      driver core: Add BUS_NOTIFY_REMOVED_DEVICE event
      iommu/vt-d: Only remove domain when device is removed
      iommu/vt-d: Store bus information in RMRR PCI device path
      iommu/vt-d: Work around broken RMRR firmware entries
      Merge branches 'arm/exynos', 'arm/omap', 'arm/smmu', 'x86/vt-d', 'x86/amd' and 'core' into next

Kiran Padwal (1):
      iommu: Make of_device_id array const

Laurent Pinchart (1):
      iommu/omap: Remove omap_iommu unused owner field

Mark Salter (1):
      iommu: Fix bus notifier breakage

Maurizio Lombardi (1):
      amd_iommu: do not dereference a NULL pointer address.

Mitchel Humpherys (1):
      iommu/arm-smmu: fix bug in pmd construction

Robin Murphy (2):
      iommu/arm-smmu: fix architecture version detection
      iommu/arm-smmu: support MMU-401

Sachin Kamat (1):
      iommu/exynos: Fix trivial typos

Suman Anna (2):
      iommu/omap: Check for valid archdata in attach_dev
      iommu/omap: Fix iommu archdata name for DT-based devices

Will Deacon (5):
      iommu/arm-smmu: allow translation stage to be forced on the cmdline
      iommu/arm-smmu: add support for multi-master iommu groups
      iommu/arm-smmu: put iommu_domain pointer in dev->archdata.iommu
      iommu/arm-smmu: use page shift instead of page size to avoid division
      iommu/arm-smmu: don't bother truncating the s1 output size to VA_BITS

Yijing Wang (1):
      iommu/irq_remapping: Fix the regression of hpet irq remapping

 .../devicetree/bindings/iommu/arm,smmu.txt         |   1 +
 drivers/base/core.c                                |   3 +
 drivers/infiniband/hw/usnic/usnic_uiom.c           |   2 +-
 drivers/iommu/amd_iommu.c                          | 117 ++++++-----
 drivers/iommu/amd_iommu_init.c                     |  21 +-
 drivers/iommu/amd_iommu_types.h                    |  21 --
 drivers/iommu/arm-smmu.c                           | 220 ++++++++++++---------
 drivers/iommu/dmar.c                               |  25 ++-
 drivers/iommu/exynos-iommu.c                       |  51 ++---
 drivers/iommu/fsl_pamu_domain.c                    |   5 +-
 drivers/iommu/intel-iommu.c                        |  16 +-
 drivers/iommu/intel_irq_remapping.c                |   7 +-
 drivers/iommu/iommu.c                              | 208 +++++++++++--------
 drivers/iommu/irq_remapping.c                      |  11 +-
 drivers/iommu/irq_remapping.h                      |   2 +-
 drivers/iommu/msm_iommu.c                          |   7 +-
 drivers/iommu/omap-iommu.c                         |  27 +--
 drivers/iommu/omap-iommu.h                         |   1 -
 drivers/iommu/tegra-gart.c                         |   9 +-
 drivers/iommu/tegra-smmu.c                         |   9 +-
 drivers/vfio/vfio_iommu_type1.c                    |   4 +-
 include/linux/device.h                             |  11 +-
 include/linux/dmar.h                               |   8 +-
 include/linux/iommu.h                              |  25 ++-
 virt/kvm/iommu.c                                   |   6 +-
 25 files changed, 461 insertions(+), 356 deletions(-)

Please pull.

Thanks,

	Joerg


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUPN/DAAoJECvwRC2XARrjM4MP/0rSGyaYRpFyFCHUlJsvWUHk
B2ELCDnhEy/LYvBH1NI+YdLHefjl4yF2g6kikYjszF/1hrOBDWJXbFFY8xYx0mhS
CWw5rmdIedBbDKJex8vk+/nPsez+o0k5NLK91qlaIpERAW7rXVJ1Slnbc9uKBRfi
CqMBojPsncY/uPinRu+eteK1XCEqCNZJZV/maiZTNYSDAdbQy+5QDrKFhBDNxow9
lPFnTPT2MH77vPjx8yfu/DVHj1Uj/I0s6tobFllWMSLhLUeTthMBX4DFSYtDZT9O
xl/ubXnB3KVabDoTDMgWmF2zu5WNMoakQ538OpDtA49shJ162O54qibXBOkCjHaf
8nLM/orFMx0C1XyW/BsVjTr8eGZGh6hsJ/hQt7Kbq0DtUzynnRWj2oB1S1xG+Got
2/J1XuB6b0DxWnnfuWQp6LprKCp8RgUp0rbzUgGaFDbIyr/uWjUIFpZVJpwgcr5D
79AuYpSlHWTMC5zXCZv0/Y+Le+cE3WPbBIJlZjvid6Ly7s6aDdhLStGra0jzUpaQ
ejQmCqP5cw/LaJLguMCF/NtWR/ph7UQUAFK9+wpQ9Rz73WxElI7YE8bBq9OKR1eY
4jwvEts97D/BcdGiOSb+mDqBVNZwNb5Sy752O4fkyifIq7ky9War/5rVQ/mxXUXc
E7FiUsfIii/qTZNYmYS8
=3TXL
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
