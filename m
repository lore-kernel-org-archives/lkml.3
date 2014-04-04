Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaDDJwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:52:40 -0400
Received: from 8bytes.org ([85.214.48.195]:45947 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaDDJwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:52:38 -0400
Date: Fri, 4 Apr 2014 11:52:34 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for Linux v3.15
Message-ID: <20140404095233.GA3692@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Apr  4 11:52:36 2014
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 533e80e420861397221422
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-updates-v3.15

for you to fetch changes up to e172b81222548b856ecbe59b305d2cb733d512c4:

  Merge branches 'iommu/fixes', 'arm/smmu', 'x86/amd', 'arm/omap', 'arm/shmobile' and 'x86/vt-d' into next (2014-04-02 19:13:12 +0200)

----------------------------------------------------------------

IOMMU Upates for Linux v3.15

This time a few more updates queued up.

	* Rework VT-d code to support ACPI devices

	* Improvements for memory and PCI hotplug support
	  in the VT-d driver

	* Device-tree support for OMAP IOMMU

	* Convert OMAP IOMMU to use devm_* interfaces

	* Fixed PASID support for AMD IOMMU

	* Other random cleanups and fixes for OMAP, ARM-SMMU
	  and SHMOBILE IOMMU

Most of the changes are in the VT-d driver because some rework was
necessary for better hotplug and ACPI device support.

----------------------------------------------------------------
Andreas Herrmann (3):
      iommu/arm-smmu: set MAX_MASTER_STREAMIDS to MAX_PHANDLE_ARGS
      iommu/arm-smmu: support buggy implementations with secure cfg accesses
      documentation/iommu: update description of ARM System MMU binding

Dan Carpenter (1):
      iommu/vt-d: returning free pointer in get_domain_for_dev()

David Woodhouse (39):
      iommu/vt-d: Clean up size handling for intel_iommu_unmap()
      iommu/vt-d: Clean up and fix page table clear/free behaviour
      iommu/vt-d: Honour intel_iommu=sp_off for non-VMM domains
      iommu/vt-d: Be less pessimistic about domain coherency where possible
      iommu/vt-d: Add ACPI namespace device reporting structures
      iommu/vt-d: Parse ANDD records
      iommu/vt-d: Allocate space for ACPI devices
      iommu/vt-d: Change scope lists to struct device, bus, devfn
      iommu/vt-d: Add ACPI devices into dmaru->devices[] array
      iommu/vt-d: Make iommu_dummy() take struct device instead of struct pci_dev
      iommu/vt-d: Make dmar_insert_dev_info() take struct device instead of struct pci_dev
      iommu/vt-d: Use struct device in device_domain_info, not struct pci_dev
      iommu/vt-d: Pass iommu to domain_context_mapping_one() and iommu_support_dev_iotlb()
      iommu/vt-d: Stop dmar_insert_dev_info() freeing domains on losing race
      iommu/vt-d: use dmar_insert_dev_info() from dma_add_dev_info()
      iommu/vt-d: Use domain_remove_one_dev_info() in domain_add_dev_info() error path
      iommu/vt-d: Always store iommu in device_domain_info
      iommu/vt-d: Simplify iommu check in domain_remove_one_dev_info()
      iommu/vt-d: Remove device_to_iommu() call from domain_remove_dev_info()
      iommu/vt-d: Store PCI segment number in struct intel_iommu
      iommu/vt-d: Remove segment from struct device_domain_info()
      iommu/vt-d: Make identity_mapping() take struct device not struct pci_dev
      iommu/vt-d: Make device_to_iommu() cope with non-PCI devices
      iommu/vt-d: Make domain_context_mapp{ed,ing}() take struct device
      iommu/vt-d: Make get_domain_for_dev() take struct device
      iommu/vt-d: Handle RMRRs for non-PCI devices
      iommu/vt-d: Make iommu_should_identity_map() take struct device
      iommu/vt-d: Make get_valid_domain_for_dev() take struct device
      iommu/vt-d: Remove some pointless to_pci_dev() calls
      iommu/vt-d: Rename 'hwdev' variables to 'dev' now that that's the norm
      iommu/vt-d: Make domain_remove_one_dev_info() take struct device
      iommu/vt-d: Make domain_add_dev_info() take struct device
      iommu/vt-d: Remove pdev from iommu_no_mapping()
      iommu/vt-d: Remove pdev from intel_iommu_attach_device()
      iommu/vt-d: Remove to_pci_dev() in intel_map_page()
      iommu/vt-d: Finally enable translation for non-PCI devices
      iommu/vt-d: Include ACPI devices in iommu=pt
      iommu/vt-d: Only call dmar_acpi_dev_scope_init() if DRHD units present
      iommu/vt-d: Fix error handling in ANDD processing

Florian Vaussard (3):
      iommu/omap: Allow enable/disable even without pdata
      Documentation: dt: add OMAP iommu bindings
      iommu/omap: Add devicetree support

Jay Cornwall (1):
      iommu/amd: Fix PASID format in INVALIDATE_IOTLB_PAGES command

Jiang Liu (17):
      iommu/vt-d: Avoid double free of g_iommus on error recovery path
      iommu/vt-d: Avoid caching stale domain_device_info and fix memory leak
      iommu/vt-d: Avoid caching stale domain_device_info when hot-removing PCI device
      iommu/vt-d: Factor out dmar_alloc_dev_scope() for later reuse
      iommu/vt-d: Move private structures and variables into intel-iommu.c
      iommu/vt-d: Simplify function get_domain_for_dev()
      iommu/vt-d: Free resources if failed to create domain for PCIe endpoint
      iommu/vt-d: Reduce duplicated code to handle virtual machine domains
      iommu/vt-d: Fix incorrect iommu_count for si_domain
      iommu/vt-d: Check for NULL pointer when freeing IOMMU data structure
      iommu/vt-d: Fix error in detect ATS capability
      iommu/vt-d: Introduce macro for_each_dev_scope() to walk device scope entries
      iommu/vt-d: Introduce a rwsem to protect global data structures
      iommu/vt-d: Use RCU to protect global resources in interrupt context
      iommu/vt-d: Update DRHD/RMRR/ATSR device scope caches when PCI hotplug happens
      iommu/vt-d: Unify the way to process DMAR device scope array
      iommu/vt-d: Update IOMMU state when memory hotplug happens

Joerg Roedel (3):
      Merge branch 'for-joerg/arm-smmu/updates' of git://git.kernel.org/.../will/linux into arm/smmu
      iommu/vt-d: Check for NULL pointer in dmar_acpi_dev_scope_init()
      Merge branches 'iommu/fixes', 'arm/smmu', 'x86/amd', 'arm/omap', 'arm/shmobile' and 'x86/vt-d' into next

Laurent Pinchart (1):
      iommu/omap: Allocate archdata on the fly for DT-based devices

Paul Bolle (1):
      iommu/shmobile: Depend on ARCH_SHMOBILE

Suman Anna (3):
      iommu/omap: Convert to devm_* interfaces
      iommu/omap: Fix error return paths in omap_iommu_attach()
      iommu/omap: Enable bus-error back on supported iommus

Suravee Suthikulpanit (1):
      iommu/amd: Fix logic to determine and checking max PASID

Will Deacon (3):
      iommu/arm-smmu: clean up use of `flags' in page table handling code
      iommu/arm-smmu: provide option to dsb macro when publishing tables
      iommu/arm-smmu: fix incorrect comment regarding TLB invalidation

Zhouyi Zhou (1):
      iommu/omap: Check for NULL in iopte_free()

 .../devicetree/bindings/iommu/arm,smmu.txt         |    6 +
 .../devicetree/bindings/iommu/ti,omap-iommu.txt    |   26 +
 arch/arm/mach-omap2/omap-iommu.c                   |    5 +
 drivers/iommu/Kconfig                              |    2 +-
 drivers/iommu/amd_iommu.c                          |    8 +-
 drivers/iommu/amd_iommu_init.c                     |   16 +-
 drivers/iommu/amd_iommu_types.h                    |   11 +-
 drivers/iommu/arm-smmu.c                           |  105 +-
 drivers/iommu/dmar.c                               |  513 +++++--
 drivers/iommu/intel-iommu.c                        | 1610 +++++++++++---------
 drivers/iommu/intel_irq_remapping.c                |  108 +-
 drivers/iommu/iova.c                               |   64 +-
 drivers/iommu/omap-iommu.c                         |  162 +-
 drivers/iommu/omap-iommu.h                         |    5 +
 drivers/iommu/omap-iommu2.c                        |    3 +
 include/acpi/actbl2.h                              |   15 +-
 include/linux/dmar.h                               |   82 +-
 include/linux/intel-iommu.h                        |    1 +
 include/linux/iova.h                               |    2 +
 19 files changed, 1754 insertions(+), 990 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt

Please pull.

Thanks,

	Joerg


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTPoDgAAoJECvwRC2XARrjeQMP/R11mX+bs2ZSU8LdzD2ckRf1
FRe2f9KypR94vWXrb9xt3RbJlqEY9RbZUJ5hgwcOK3zdiV8VvkI+0eHE7+2d4U4+
IuKjP5enetnctV8iGVqLB3+zVtw5JbxpYc6jjjP5GeGr8Na9CS7Wkm41qXlLfCAE
9WKPhbPJ8OPRVrhoJfLKXlvc4bOaQWheeoFnn0QHvJOsQO/g0u/4bloSneiytXJH
BEhLbDV1KPXbVdKwYkPbPHGQakbAA2KoxRTfZ0Qc9jO+QELjy2y1xAP3DaPQRG39
t5dGIxXKKWMv3JPath8zl6rC+7Pu3HbqUClgiFrZDWmdJergb0gUcR6vAQ+e0K+v
CNpqBWqyBfa9l1Gkz4/dTY5DFSKbfbRKeF0yqObRMpdKaUdIkt6dxUVen8QPzYs7
pihbWdO4aDCmINLXfLIZNT5GO2Zyfroc1+fP3X+9vOJt7teV3zk6ID8kIpBeE0vY
mi3f/jI/+G2o3xA/hMvlmFFRHjupqvu7iXMdZPE3y0ZEq0gse0Nhx5LWclcRhF/i
z6XZFe4+SFH9i/UvECCNTTLCTPdBcULpYwAPv88RK/7n9Qjo+cZjwv9cU6xjiJza
VS/2mgF6ezpMZY/u5SVwQ6BMbSaVQ3mlbSBhT7CPv8e48XHhCkrp6G0Edo6ksN73
UeFbYobiguwGrKoTm/Je
=InVo
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--


