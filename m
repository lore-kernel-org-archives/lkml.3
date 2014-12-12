Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbaLLPoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:44:24 -0500
Received: from 8bytes.org ([81.169.241.247]:38470 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbaLLPoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:44:22 -0500
Date: Fri, 12 Dec 2014 16:44:16 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Dave Airlie <airlied@gmail.com>
Subject: [git pull] IOMMU Updates for Linux v3.19
Message-ID: <20141212154416.GA22221@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:

  Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-u=
pdates-v3.19

for you to fetch changes up to 76771c938e95ce4106c6e8092f4f614d4d1e0ecc:

  Merge branches 'arm/omap', 'arm/msm', 'arm/rockchip', 'arm/renesas', 'arm=
/smmu', 'x86/vt-d', 'x86/amd' and 'core' into next (2014-12-02 13:07:13 +01=
00)

----------------------------------------------------------------

IOMMU Updates for Linux v3.19

This time with:

	* A new IOMMU-API call: iommu_map_sg() to map multiple
	  non-contiguous pages into an IO address space with only one
	  API call. This allows certain optimizations in the IOMMU
	  driver.

	* DMAR device hotplug in the Intel VT-d driver. It is now
	  possible to hotplug the IOMMU itself.

	* A new IOMMU driver for the Rockchip ARM platform.

	* Couple of cleanups and improvements in the OMAP IOMMU driver.

	* Nesting support for the ARM-SMMU driver.

	* Various other small cleanups and improvements.

Please note that this time some branches were also pulled into other
trees, like the DRI and the Tegra tree. The VT-d branch was also pulled
into tip/x86/apic.
Some patches for the AMD IOMMUv2 driver are not in the IOMMU tree but
were merged by Andrew (or finally ended up in the DRI tree).

----------------------------------------------------------------
Antonios Motakis (3):
      iommu/arm-smmu: change IOMMU_EXEC to IOMMU_NOEXEC
      iommu: add capability IOMMU_CAP_NOEXEC
      iommu/arm-smmu: add IOMMU_CAP_NOEXEC to the ARM SMMU driver

Axel Lin (1):
      iommu/ipmmu-vmsa: Return proper error if devm_request_irq fails

Daniel Kurtz (2):
      iommu/rockchip: rk3288 iommu driver
      dt-bindings: iommu: Add documentation for rockchip iommu

Heiko St=FCbner (1):
      iommu: Improve error handling when setting bus iommu

Jiang Liu (9):
      iommu/vt-d: Introduce helper function dmar_walk_resources()
      iommu/vt-d: Dynamically allocate and free seq_id for DMAR units
      iommu/vt-d: Implement DMAR unit hotplug framework
      iommu/vt-d: Search for ACPI _DSM method for DMAR hotplug
      iommu/vt-d: Enhance intel_irq_remapping driver to support DMAR unit h=
otplug
      iommu/vt-d: Enhance error recovery in function intel_enable_irq_remap=
ping()
      iommu/vt-d: Enhance intel-iommu driver to support DMAR unit hotplug
      pci, ACPI, iommu: Enhance pci_root to support DMAR device hotplug
      iommu/vt-d: Fix an off-by-one bug in __domain_mapping()

Joerg Roedel (5):
      iommu: Do more input validation in iommu_map_sg()
      iommu/rockchip: Allow to compile with COMPILE_TEST
      powerpc/iommu: Rename iommu_[un]map_sg functions
      Merge branch 'for-joerg/arm-smmu/updates' of git://git.kernel.org/...=
/will/linux into arm/smmu
      Merge branches 'arm/omap', 'arm/msm', 'arm/rockchip', 'arm/renesas', =
'arm/smmu', 'x86/vt-d', 'x86/amd' and 'core' into next

Kiran Padwal (2):
      iommu/msm: Use dev_get_platdata()
      iommu/omap: Use dev_get_platdata()

Li, Zhen-Hua (1):
      x86/vt-d: Fix incorrect bit operations in setting values

Oded Gabbay (1):
      iommu/amd: Fix accounting of device_state

Olav Haugan (1):
      iommu: Add iommu_map_sg() function

Robin Murphy (1):
      iommu: Decouple iommu_map_sg from CPU page size

SF Markus Elfring (1):
      iommu/msm: Deletion of unnecessary checks before clk_disable()

Suman Anna (17):
      iommu/omap: Remove refcount field from omap_iommu object
      iommu/omap: Remove unused isr_priv field from omap_iommu
      iommu/omap: Remove duplicate declarations
      iommu/omap: Remove conditional definition of dev_to_omap_iommu()
      iommu/omap: Remove ver debugfs entry
      iommu/omap: Remove omap_iommu_arch_version() and version field
      iommu/omap: Remove bogus version check in context save/restore
      iommu/omap: Simplify omap2_iommu_fault_isr()
      iommu/omap: Consolidate OMAP IOMMU modules
      iommu/omap: Fix the permissions on nr_tlb_entries
      iommu/omap: Make pagetable debugfs entry read-only
      iommu/omap: Integrate omap-iommu-debug into omap-iommu
      iommu/omap: Remove couple of unused exported functions
      iommu/omap: Do not export unneeded functions
      iommu/omap: Reset the domain field upon detaching
      iommu/omap: Fix bus error on debugfs access of unattached IOMMU
      iommu/omap: Switch pagetable debugfs entry to use seq_file

Thierry Reding (1):
      iommu/arm-smmu: Play nice on non-ARM/SMMU systems

Will Deacon (2):
      iommu/amd: remove compiler warning due to IOMMU_CAP_NOEXEC
      iommu/arm-smmu: add support for DOMAIN_ATTR_NESTING attribute

 .../devicetree/bindings/iommu/rockchip,iommu.txt   |   26 +
 arch/powerpc/include/asm/iommu.h                   |   17 +-
 arch/powerpc/kernel/dma-iommu.c                    |    8 +-
 arch/powerpc/kernel/iommu.c                        |   16 +-
 arch/powerpc/platforms/cell/iommu.c                |    9 +-
 drivers/acpi/pci_root.c                            |   16 +-
 drivers/iommu/Kconfig                              |   25 +-
 drivers/iommu/Makefile                             |    2 +-
 drivers/iommu/amd_iommu.c                          |    3 +
 drivers/iommu/amd_iommu_v2.c                       |    8 +-
 drivers/iommu/arm-smmu.c                           |  134 ++-
 drivers/iommu/dmar.c                               |  532 ++++++++--
 drivers/iommu/exynos-iommu.c                       |    1 +
 drivers/iommu/intel-iommu.c                        |  308 ++++--
 drivers/iommu/intel_irq_remapping.c                |  249 +++--
 drivers/iommu/iommu.c                              |   60 +-
 drivers/iommu/ipmmu-vmsa.c                         |    3 +-
 drivers/iommu/msm_iommu.c                          |    4 +-
 drivers/iommu/msm_iommu_dev.c                      |   10 +-
 drivers/iommu/omap-iommu-debug.c                   |  242 ++---
 drivers/iommu/omap-iommu.c                         |  313 +++---
 drivers/iommu/omap-iommu.h                         |   98 +-
 drivers/iommu/omap-iommu2.c                        |  337 -------
 drivers/iommu/rockchip-iommu.c                     | 1038 ++++++++++++++++=
++++
 drivers/iommu/shmobile-iommu.c                     |    1 +
 drivers/iommu/tegra-smmu.c                         |    1 +
 include/linux/dmar.h                               |   50 +-
 include/linux/iommu.h                              |   25 +-
 28 files changed, 2532 insertions(+), 1004 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/rockchip,iommu.=
txt
 delete mode 100644 drivers/iommu/omap-iommu2.c
 create mode 100644 drivers/iommu/rockchip-iommu.c

Please pull.

Thanks,

	Joerg


--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUiw1QAAoJECvwRC2XARrj150QAMiJpJs2L06LE2KquVXLioJW
cEgpvCeY/U72+J0bu6eTY6NdruGPTnPzcXVGdhxhUCCq8vZT/m7yuey414e0N07G
/DKccoSeJyaPRkBQmyd3P4RXg0sIEVgEkKEnY+q0L24c6z3THfgPbARsDvWCToBr
/vwIYXgteRaMr+gw5nRn6EmJkyXYHAsxdNRMVdvwfzeR89Zcsr3jcZLSwuc8XUMB
EJXVEOWCTpYiOdpswa+Nl02LvxlnKLsOoOJC23EXWyHFS5ssr7Eul4fQuDXBV3KZ
zXck5bvPCrCiug6iZ2+BKMThnxVwMUbfa9Q8JLr2Pze1Rt/miTqncK86wFREdykL
5HoFlSU4jo3IOu+93I8mlcbOZJ4YRvOnTMNK2OZQzXBNLEmHzupPDYZs05k9xZ0s
U/U/JzSXIv90KtJUraOp6H5CMC2uwZUHr2tcrftnKoQOfN9Kw0VLWcFp3tg8Iw6U
3CwqlFTAtr443Qpq+Umtt+q2Vr51pDwzMT6WNV9ijgdRY82XDTkFT+AETgxStCo/
KqxLkg5Oh06WEYLi6mulQbVddfzEv5zUJlhSBGvZCpNaS4hpOeC4NgoPIXgWN2U9
5h5/cKLNPQHkkxhD5bBAA5/e3tkhX0QhstgquL6eXC2kaB3xuFVbsihdzgDIkAjY
N5FYFAZ3Q52pS2NfzVvj
=Q4cF
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
