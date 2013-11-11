Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3KKVjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:39:08 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33677 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3KKVi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:38:57 -0500
Date: Mon, 11 Nov 2013 14:38:54 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.13
Message-ID: <20131111213854.GA30350@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.13-changes

for you to fetch changes up to eaaeb1cb33310dea6c3fa45d8bfc63e5a1d0a846:

  Merge branch 'pci/misc' into next (2013-11-07 15:02:04 -0700)

----------------------------------------------------------------

PCI changes for the v3.13 merge window:

  Resource management
    - Fix host bridge window coalescing (Alexey Neyman)
    - Pass type, width, and prefetchability for window alignment (Wei Yang)

  PCI device hotplug
    - Convert acpiphp, acpiphp_ibm to dynamic debug (Lan Tianyu)

  Power management
    - Remove pci_pm_complete() (Liu Chuansheng)

  MSI
    - Fail initialization if device is not in PCI_D0 (Yijing Wang)

  MPS (Max Payload Size)
    - Use pcie_get_mps() and pcie_set_mps() to simplify code (Yijing Wang)
    - Use pcie_set_readrq() to simplify code (Yijing Wang)
    - Use cached pci_dev->pcie_mpss to simplify code (Yijing Wang)

  SR-IOV
    - Enable upstream bridges even for VFs on virtual buses (Bjorn Helgaas)
    - Use pci_is_root_bus() to avoid catching virtual buses (Wei Yang)

  Virtualization
    - Add x86 MSI masking ops (Konrad Rzeszutek Wilk)

  Freescale i.MX6
    - Support i.MX6 PCIe controller (Sean Cross)
    - Increase link startup timeout (Marek Vasut)
    - Probe PCIe in fs_initcall() (Marek Vasut)
    - Fix imprecise abort handler (Tim Harvey)
    - Remove redundant of_match_ptr (Sachin Kamat)

  Renesas R-Car
    - Support Gen2 internal PCIe controller (Valentine Barshak)

  Samsung Exynos
    - Add MSI support (Jingoo Han)
    - Turn off power when link fails (Jingoo Han)
    - Add Jingoo Han as maintainer (Jingoo Han)
    - Add clk_disable_unprepare() on error path (Wei Yongjun)
    - Remove redundant of_match_ptr (Sachin Kamat)

  Synopsys DesignWare
    - Add irq_create_mapping() (Pratyush Anand)
    - Add header guards (Seungwon Jeon)

  Miscellaneous
    - Enable native PCIe services by default on non-ACPI (Andrew Murray)
    - Cleanup _OSC usage and messages (Bjorn Helgaas)
    - Remove pcibios_last_bus boot option on non-x86 (Bjorn Helgaas)
    - Convert bus code to use bus_, drv_, and dev_groups (Greg Kroah-Hartman)
    - Remove unused pci_mem_start (Myron Stowe)
    - Make sysfs functions static (Sachin Kamat)
    - Warn on invalid return from driver probe (Stephen M. Cameron)
    - Remove Intel Haswell D3 delays (Todd E Brandt)
    - Call pci_set_master() in core if driver doesn't do it (Yinghai Lu)
    - Use pci_is_pcie() to simplify code (Yijing Wang)
    - Use PCIe capability accessors to simplify code (Yijing Wang)
    - Use cached pci_dev->pcie_cap to simplify code (Yijing Wang)
    - Removed unused "is_pcie" from struct pci_dev (Yijing Wang)
    - Simplify sysfs CPU affinity implementation (Yijing Wang))

----------------------------------------------------------------
Alexey Neyman (1):
      x86/PCI: Coalesce multiple overlapping host bridge windows

Andrew Murray (1):
      PCI: Update pcie_ports 'auto' behavior for non-ACPI platforms

Bjorn Helgaas (41):
      ACPI: Write _OSC bit field definitions in hex
      ACPI: Rename OSC_QUERY_TYPE to OSC_QUERY_DWORD
      ACPI: Tidy acpi_run_osc() declarations
      ACPI: Remove unused OSC_PCI_NATIVE_HOTPLUG
      ACPI: Write OSC_PCI_CONTROL_MASKS like OSC_PCI_SUPPORT_MASKS
      PCI/ACPI: Name _OSC #defines more consistently
      PCI/ACPI: Drop unnecessary _OSC existence tests
      PCI/ACPI: Move _OSC stuff from acpi_pci_root_add() to negotiate_os_control()
      PCI/ACPI: Split _OSC "support" and "control" flags into separate variables
      PCI/ACPI: Run _OSC only once for OSPM feature support
      PCI/ACPI: Skip _OSC control tests if _OSC support call failed
      PCI/ACPI: Separate out _OSC "PCIe port services disabled" path
      PCI/ACPI: Separate out _OSC "we don't support enough services" path
      PCI/ACPI: Decode _OSC bitmasks symbolically
      Merge branch 'pci/bjorn-osc' into next
      Merge branch 'pci/yijing-pci_is_pcie-v2' into next
      PCI: Drop "setting latency timer" messages
      [SCSI] qla2xxx: Use standard PCIe Capability Link register field names
      PCI: Document reason for using pci_is_root_bus()
      Merge branch 'pci/host-exynos' into next
      Merge branch 'pci/host-imx6' into next
      Merge branch 'pci/host-tegra' into next
      Merge branch 'pci/misc' into next
      IB/qib: Drop qib_tune_pcie_caps() and qib_tune_pcie_coalesce() return values
      PCI: designware: Make dw_pcie_rd_own_conf(), etc., static
      MAINTAINERS: Add arch/x86/pci to PCI file patterns
      frv/PCI: Remove pcibios_last_bus
      mn10300/PCI: Remove useless pcibios_last_bus
      PCI: Report pci_pme_active() kmalloc failure
      Merge branch 'pci/gregkh-driver-core' into next
      Merge branch 'pci/host-exynos' into next
      Merge branch 'pci/host-imx6' into next
      Merge branch 'pci/host-rcar' into next
      Merge branch 'pci/yijing-mps-v1' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/yijing-pci_is_pcie-v2' into next
      PCI: Drop warning about drivers that don't use pci_set_master()
      Merge branch 'pci/misc' into next
      PCI: Add pci_upstream_bridge()
      PCI: Enable upstream bridges even for VFs on virtual buses
      Merge branch 'pci/misc' into next

Greg Kroah-Hartman (3):
      PCI: convert bus code to use bus_groups
      PCI: convert bus code to use drv_groups
      PCI: convert bus code to use dev_groups

Jingoo Han (4):
      MAINTAINERS: Add Jingoo Han as Samsung Exynos PCIe driver maintainer
      PCI: exynos: Add support for MSI
      PCI: exynos: Turn off power of phy block when link failed
      PCI: tegra: Add missing __iomem annotation

Joe Perches (1):
      PCI: Fix comment typo, remove unnecessary !! in pci_is_pcie()

Konrad Rzeszutek Wilk (1):
      PCI: Add x86_msi.msi_mask_irq() and msix_mask_irq()

Lan Tianyu (2):
      PCI: acpiphp: Convert to dynamic debug
      PCI: acpiphp_ibm: Convert to dynamic debug

Liu Chuansheng (1):
      PCI/PM: Remove pci_pm_complete()

Marek Vasut (2):
      PCI: imx6: Increase link startup timeout
      PCI: imx6: Probe the PCIe in fs_initcall()

Myron Stowe (2):
      cris/PCI: Remove unused pci_mem_start
      mn10300/PCI: Remove unused pci_mem_start

Pratyush Anand (1):
      PCI: designware: Add irq_create_mapping()

Sachin Kamat (4):
      PCI: Make pci_bus_attrs, pci_dev_attrs, dev_rescan_attr, dev_remove_attr, vga_attr static
      PCI: Make pci_dev_pm_ops static
      PCI: exynos: Remove redundant of_match_ptr
      PCI: imx6: Remove redundant of_match_ptr

Sean Cross (2):
      ARM: imx6q: Add PCIe bits to GPR syscon definition
      PCI: imx6: Add support for i.MX6 PCIe controller

Seungwon Jeon (1):
      PCI: designware: Add header guards

Stephen M. Cameron (1):
      PCI: Warn on driver probe return value greater than zero

Tim Harvey (1):
      PCI: imx6: Fix imprecise abort handler

Todd E Brandt (1):
      PCI: Remove Intel Haswell D3 delays

Valentine Barshak (1):
      PCI: Add R-Car Gen2 internal PCI support

Wei Yang (2):
      PCI: Use pci_is_root_bus() to check for root bus
      PCI: Pass type, width, and prefetchability for window alignment

Wei Yongjun (2):
      PCI: exynos: Add missing clk_disable_unprepare() on error path
      PCI: imx6: Remove redundant dev_err() in imx6_pcie_probe()

Yijing Wang (18):
      PCI: Use pci_is_pcie() to simplify code
      x86/pci: Use cached pci_dev->pcie_cap to simplify code
      [SCSI] bfa: Use pcie_set()/get_readrq() to simplify code
      [SCSI] csiostor: Use pcie_capability_clear_and_set_word() to simplify code
      [SCSI] qla2xxx: Use pcie_is_pcie() to simplify code
      powerpc/pci: Use pci_is_pcie() to simplify code
      PCI: Export pcie_set_mps() and pcie_get_mps()
      tile/PCI: use cached pci_dev->pcie_mpss to simplify code
      IB/qib: Use pci_is_root_bus() to check whether it is a root bus
      IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify code
      PCI: Update pci_find_slot() description in pci.txt
      PCI: Remove unused "is_pcie" from pci_dev structure
      PCI: Remove unused PCI_MSIX_FLAGS_BIRMASK definition
      staging: et131x: Use pci_dev->pcie_mpss and pcie_set_readrq() to simplify code
      drm/radeon: use pcie_get_readrq() and pcie_set_readrq() to simplify code
      PCI: Add pci_dev_show_local_cpu() to simplify code
      PCI: Fail MSI/MSI-X initialization if device is not in PCI_D0
      powerpc/pci: Use pci_is_pcie() to simplify code [fix]

Yinghai Lu (1):
      PCI: Workaround missing pci_set_master in pci drivers

 Documentation/PCI/pci.txt                          |   8 +-
 .../devicetree/bindings/pci/designware-pcie.txt    |   7 +-
 MAINTAINERS                                        |   7 +
 arch/cris/include/asm/pci.h                        |   1 -
 arch/frv/mb93090-mb00/pci-frv.h                    |   1 -
 arch/frv/mb93090-mb00/pci-vdk.c                    |  36 --
 arch/mn10300/include/asm/pci.h                     |   1 -
 arch/mn10300/kernel/setup.c                        |   3 -
 arch/mn10300/unit-asb2305/pci-asb2305.h            |   1 -
 arch/mn10300/unit-asb2305/pci.c                    |   5 -
 arch/powerpc/kernel/eeh.c                          |   5 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   2 +-
 arch/tile/kernel/pci.c                             |   7 +-
 arch/x86/include/asm/x86_init.h                    |   3 +
 arch/x86/kernel/x86_init.c                         |  10 +
 arch/x86/pci/acpi.c                                |   8 +-
 arch/x86/pci/fixup.c                               |  18 +-
 arch/x86/pci/xen.c                                 |  13 +-
 drivers/acpi/apei/apei-base.c                      |   6 +-
 drivers/acpi/bus.c                                 |  18 +-
 drivers/acpi/pci_root.c                            | 246 +++++----
 drivers/gpu/drm/radeon/evergreen.c                 |  19 +-
 drivers/infiniband/hw/qib/qib_pcie.c               | 126 ++---
 drivers/pci/host/Kconfig                           |  14 +
 drivers/pci/host/Makefile                          |   2 +
 drivers/pci/host/pci-exynos.c                      | 132 ++++-
 drivers/pci/host/pci-imx6.c                        | 568 +++++++++++++++++++++
 drivers/pci/host/pci-rcar-gen2.c                   | 333 ++++++++++++
 drivers/pci/host/pci-tegra.c                       |   4 +-
 drivers/pci/host/pcie-designware.c                 | 257 +++++++++-
 drivers/pci/host/pcie-designware.h                 |  26 +-
 drivers/pci/hotplug/acpi_pcihp.c                   |   2 +-
 drivers/pci/hotplug/acpiphp.h                      |  10 -
 drivers/pci/hotplug/acpiphp_core.c                 |  37 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |  23 +-
 drivers/pci/hotplug/acpiphp_ibm.c                  |  58 +--
 drivers/pci/hotplug/shpchp.h                       |   2 +-
 drivers/pci/msi.c                                  |  28 +-
 drivers/pci/pci-driver.c                           |  40 +-
 drivers/pci/pci-sysfs.c                            | 132 +++--
 drivers/pci/pci.c                                  |  30 +-
 drivers/pci/pci.h                                  |   4 +-
 drivers/pci/pcie/portdrv_core.c                    |  15 +-
 drivers/pci/probe.c                                |   4 +-
 drivers/pci/quirks.c                               |  23 +
 drivers/pci/setup-bus.c                            |   4 +-
 drivers/scsi/bfa/bfad.c                            |  53 +-
 drivers/scsi/csiostor/csio_hw.c                    |  22 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |   6 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  14 +-
 drivers/staging/et131x/et131x.c                    |  14 +-
 include/linux/acpi.h                               |  81 ++-
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |   8 +
 include/linux/msi.h                                |   2 +
 include/linux/pci.h                                |  19 +-
 include/uapi/linux/pci_regs.h                      |   4 +-
 56 files changed, 1906 insertions(+), 616 deletions(-)
 create mode 100644 drivers/pci/host/pci-imx6.c
 create mode 100644 drivers/pci/host/pci-rcar-gen2.c
