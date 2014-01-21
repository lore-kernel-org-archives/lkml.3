Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaAUWsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:48:38 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:41624 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaAUWsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:48:36 -0500
Date: Tue, 21 Jan 2014 15:48:32 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.14
Message-ID: <20140121224832.GA4887@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f0b75693cbb26439ba959ba7d3b4f43e2fcf3da6:

  MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers (2013-12-11 10:40:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.14-changes

for you to fetch changes up to cef09b808e584c13b7126b83dc37c80b00234137:

  Merge branch 'eisa' into next (2014-01-18 07:30:25 -0700)

----------------------------------------------------------------

PCI changes for the v3.14 merge window:

  Resource management
    - Change pci_bus_region addresses to dma_addr_t (Bjorn Helgaas)
    - Support 64-bit AGP BARs (Bjorn Helgaas, Yinghai Lu)
    - Add pci_bus_address() to get bus address of a BAR (Bjorn Helgaas)
    - Use pci_resource_start() for CPU address of AGP BARs (Bjorn Helgaas)
    - Enforce bus address limits in resource allocation (Yinghai Lu)
    - Allocate 64-bit BARs above 4G when possible (Yinghai Lu)
    - Convert pcibios_resource_to_bus() to take pci_bus, not pci_dev (Yinghai Lu)

  PCI device hotplug
    - Major rescan/remove locking update (Rafael J. Wysocki)
    - Make ioapic builtin only (not modular) (Yinghai Lu)
    - Fix release/free issues (Yinghai Lu)
    - Clean up pciehp (Bjorn Helgaas)
    - Announce pciehp slot info during enumeration (Bjorn Helgaas)

  MSI
    - Add pci_msi_vec_count(), pci_msix_vec_count() (Alexander Gordeev)
    - Add pci_enable_msi_range(), pci_enable_msix_range() (Alexander Gordeev)
    - Deprecate "tri-state" interfaces: fail/success/fail+info (Alexander Gordeev)
    - Export MSI mode using attributes, not kobjects (Greg Kroah-Hartman)
    - Drop "irq" param from *_restore_msi_irqs() (DuanZhenzhong)

  SR-IOV
    - Clear NumVFs when disabling SR-IOV in sriov_init() (ethan.zhao)

  Virtualization
    - Add support for save/restore of extended capabilities (Alex Williamson)
    - Add Virtual Channel to save/restore support (Alex Williamson)
    - Never treat a VF as a multifunction device (Alex Williamson)
    - Add pci_try_reset_function(), et al (Alex Williamson)

  AER
    - Ignore non-PCIe error sources (Betty Dall)
    - Support ACPI HEST error sources for domains other than 0 (Betty Dall)
    - Consolidate HEST error source parsers (Bjorn Helgaas)
    - Add a TLP header print helper (Borislav Petkov)

  Freescale i.MX6
    - Remove unnecessary code (Fabio Estevam)
    - Make reset-gpio optional (Marek Vasut)
    - Report "link up" only after link training completes (Marek Vasut)
    - Start link in Gen1 before negotiating for Gen2 mode (Marek Vasut)
    - Fix PCIe startup code (Richard Zhu)

  Marvell MVEBU
    - Remove duplicate of_clk_get_by_name() call (Andrew Lunn)
    - Drop writes to bridge Secondary Status register (Jason Gunthorpe)
    - Obey bridge PCI_COMMAND_MEM and PCI_COMMAND_IO bits (Jason Gunthorpe)
    - Support a bridge with no IO port window (Jason Gunthorpe)
    - Use max_t() instead of max(resource_size_t,) (Jingoo Han)
    - Remove redundant of_match_ptr (Sachin Kamat)
    - Call pci_ioremap_io() at startup instead of dynamically (Thomas Petazzoni)

  NVIDIA Tegra
    - Disable Gen2 for Tegra20 and Tegra30 (Eric Brower)

  Renesas R-Car
    - Add runtime PM support (Valentine Barshak)
    - Fix rcar_pci_probe() return value check (Wei Yongjun)

  Synopsys DesignWare
    - Fix crash in dw_msi_teardown_irq() (Bjørn Erik Nilsen)
    - Remove redundant call to pci_write_config_word() (Bjørn Erik Nilsen)
    - Fix missing MSI IRQs (Harro Haan)
    - Add dw_pcie prefix before cfg_read/write (Pratyush Anand)
    - Fix I/O transfers by using CPU (not realio) address (Pratyush Anand)
    - Whitespace cleanup (Jingoo Han)

  EISA
    - Call put_device() if device_register() fails (Levente Kurusa)
    - Revert EISA initialization breakage ((Bjorn Helgaas)

  Miscellaneous
    - Remove unused code, including PCIe 3.0 interfaces (Stephen Hemminger)
    - Prevent bus conflicts while checking for bridge apertures (Bjorn Helgaas)
    - Stop clearing bridge Secondary Status when setting up I/O aperture (Bjorn Helgaas)
    - Use dev_is_pci() to identify PCI devices (Yijing Wang)
    - Deprecate DEFINE_PCI_DEVICE_TABLE (Joe Perches)
    - Update documentation 00-INDEX (Erik Ekman)

----------------------------------------------------------------
Alex Williamson (7):
      PCI: Add pci_wait_for_pending() (refactor pci_wait_for_pending_transaction())
      PCI: Add support for save/restore of extended capabilities
      PCI: Add Virtual Channel to save/restore support
      PCI: Rename PCI_VC_PORT_REG1/2 to PCI_VC_PORT_CAP1/2
      PCI: Never treat a VF as a multifunction device
      PCI: Add pci_try_reset_function(), pci_try_reset_slot(), pci_try_reset_bus()
      vfio-pci: Use pci "try" reset interface

Alexander Gordeev (9):
      s390/PCI: Fix single MSI only check
      s390/PCI: Remove superfluous check of MSI type
      PCI/MSI: Return msix_capability_init() failure if populate_msi_sysfs() fails
      PCI/MSI: Return -ENOSYS for unimplemented interfaces, not -1
      PCI/MSI: Make pci_enable_msi/msix() 'nvec' argument type as int
      PCI/MSI: Add pci_msi_vec_count()
      PCI/MSI: Remove pci_enable_msi_block_auto()
      PCI/MSI: Add pci_msix_vec_count()
      PCI/MSI: Add pci_enable_msi_range() and pci_enable_msix_range()

Andrew Lunn (1):
      PCI: mvebu: Remove duplicate of_clk_get_by_name() call

Betty Dall (3):
      PCI/AER: Ignore non-PCIe AER error sources in aer_hest_parse()
      ACPICA: Add helper macros to extract bus/segment numbers from HEST table.
      PCI/AER: Support ACPI HEST AER error sources for PCI domains other than 0

Bjorn Helgaas (61):
      PCI: designware: Use typical "for" loop idiom
      PCI: Prevent bus conflicts while checking for bridge apertures
      PCI: Stop clearing bridge Secondary Status when setting up I/O aperture
      Merge branch 'for-linus' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/yijing-dev_is_pci' into next
      PCI/AER: Consolidate HEST error source parsers
      PCI: pciehp: Drop pciehp_readw()/pciehp_writew() wrappers
      PCI: pciehp: Remove error checks when accessing PCIe Capability
      PCI: pciehp: Make various functions void since they can't fail
      PCI: pciehp: Announce slot capabilities (slot #, button, LEDs, etc)
      PCI: pciehp: Simplify "Power Fault Detected" checking/clearing
      PCI: pciehp: Use symbolic constants, not hard-coded bitmask
      PCI: pciehp: Use symbolic constants for Slot Control fields
      PCI: pciehp: Move Attention & Power Indicator support tests to accessors
      Merge branch 'eisa' into next
      Merge branch 'pci/aer' into next
      Merge branch 'pci/deletion' into next
      Merge branch 'pci/host-designware' into next
      Merge branch 'pci/host-imx6' into next
      Merge branch 'pci/host-mvebu' into next
      Merge branch 'pci/host-rcar' into next
      Merge branch 'pci/host-tegra' into next
      Merge branch 'pci/pciehp' into next
      Merge branch 'pci/vc' into next
      PCI/portdrv: Cleanup error paths
      PCI/portdrv: Remove extra get_device()/put_device() for pcie_device
      Merge branch 'pci/host-imx6' into next
      Merge branch 'pci/host-mvebu' into next
      Merge branch 'pci/host-designware' into next
      Merge branch 'pci/deletion' into next
      Merge branch 'pci/msi' into next
      Merge branch 'pci/misc' into next
      PCI: Change pci_bus_region addresses to dma_addr_t
      PCI: Add pci_bus_address() to get bus address of a BAR
      agp: Support 64-bit APBASE
      agp: Use pci_resource_start() to get CPU physical address for BAR
      drm/i915: Rename gtt_bus_addr to gtt_phys_addr
      agp/intel: Rename gtt_bus_addr to gtt_phys_addr
      agp/intel: Use pci_bus_address() to get MMADR bus address
      agp/intel: Use pci_bus_address() to get GTTADR bus address
      agp/intel: Use CPU physical address, not bus address, for ioremap()
      agp/ati: Use PCI_COMMAND instead of hard-coded 4
      PCI: Split out bridge window override of minimum allocation address
      Merge branch 'pci/host-designware' into next
      Merge branch 'pci/host-mvebu' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/msi' into next
      Merge branch 'pci/resource' into next
      Merge branch 'pci/aer' into next
      Merge branch 'pci/dead-code' into next
      PCI: Reorder so actual code comes before stubs
      PCI: Cleanup pci.h whitespace
      Merge branch 'pci/ifndefs' into next
      PCI: Fix pci_check_and_unmask_intx() comment typos
      Merge branch 'pci/misc' into next
      Merge branch 'pci/locking' into next
      Merge branch 'pci/reset' into next
      Revert "EISA: Log device resources in dmesg"
      Revert "EISA: Initialize device before its resources"
      Merge branch 'eisa' into next

Bjørn Erik Nilsen (2):
      PCI: designware: Fix crash in dw_msi_teardown_irq()
      PCI: designware: Remove redundant call to pci_write_config_word()

Borislav Petkov (2):
      PCI/AER: Add a TLP header print helper
      PCI/AER: Clean up error printing code a bit

DuanZhenzhong (1):
      PCI: Drop "irq" param from *_restore_msi_irqs()

Eric Brower (1):
      PCI: Disable Gen2 for Tegra20 and Tegra30

Erik Ekman (1):
      PCI: Update documentation 00-INDEX file

Fabio Estevam (2):
      PCI: imx6: Remove unneeded check of platform_get_resource()
      PCI: imx6: Remove unneeded 'goto err'

Geert Uytterhoeven (1):
      PCI/portdrv: Remove superfluous name cast

Greg Kroah-Hartman (1):
      PCI/MSI: Export MSI mode using attributes, not kobjects

Harro Haan (1):
      PCI: designware: Fix missing MSI IRQs

Jason Gunthorpe (3):
      PCI: mvebu: Drop writes to bridge Secondary Status register
      PCI: mvebu: Obey bridge PCI_COMMAND_MEM and PCI_COMMAND_IO bits
      PCI: mvebu: Support a bridge with no IO port window

Jingoo Han (2):
      PCI: mvebu: Use max_t() instead of max(resource_size_t,)
      PCI: designware: Fix indent code style

Joe Perches (1):
      PCI/checkpatch: Deprecate DEFINE_PCI_DEVICE_TABLE

Levente Kurusa (2):
      EISA: Call put_device() if device_register() fails
      PCI/portdrv: Add put_device() after device_register() failure

Marek Vasut (5):
      PCI: imx6: Make reset-gpio optional
      PCI: imx6: Report "link up" only after link training completes
      PCI: imx6: Factor out PHY reset
      PCI: imx6: Factor out link up wait loop
      PCI: imx6: Start link in Gen1 before negotiating for Gen2 mode

Pratyush Anand (2):
      PCI: designware: Add dw_pcie prefix before cfg_read/write
      PCI: designware: Fix I/O transfers by using CPU (not realio) address

Rafael J. Wysocki (11):
      PCI: Move device_del() from pci_stop_dev() to pci_destroy_dev()
      PCI: Add global pci_lock_rescan_remove()
      ACPI / PCI: Use global PCI rescan-remove locking in PCI root hotplug
      ACPI / hotplug / PCI: Use global PCI rescan-remove locking
      pcmcia: Use global PCI rescan-remove locking
      PCI: hotplug: Use global PCI rescan-remove locking
      platform / x86: Use global PCI rescan-remove locking
      MPT / PCI: Use pci_stop_and_remove_bus_device_locked()
      powerpc/eeh: Use global PCI rescan-remove locking
      xen/pcifront: Use global PCI rescan-remove locking
      PCI: Check parent kobject in pci_destroy_dev()

Richard Zhu (1):
      PCI: imx6: Fix bugs in PCIe startup code

Sachin Kamat (1):
      PCI: mvebu: Remove redundant of_match_ptr

Stephen Hemminger (9):
      PCI: Removed unused parts of Page Request Interface support
      PCI: Remove unused Latency Tolerance Reporting support
      PCI: Remove unused Optimized Buffer Flush/Fill support
      PCI: Remove unused ID-Based Ordering support
      PCI: Remove unused pci_vpd_truncate()
      PCI: Remove unused pcie_aspm_enabled()
      PCI: Remove unused pci_renumber_slot()
      PCI: Remove unused alloc_pci_dev()
      PCI: Make local functions static

Thomas Petazzoni (1):
      PCI: mvebu: Call pci_ioremap_io() at startup instead of dynamically

Valentine Barshak (1):
      PCI: rcar: Add runtime PM support

Wei Yongjun (1):
      PCI: rcar: Fix rcar_pci_probe() return value check

Yijing Wang (8):
      PCI: Use dev_is_pci() to identify PCI devices
      x86/PCI: Use dev_is_pci() to identify PCI devices
      ia64/PCI: Use dev_is_pci() to identify PCI devices
      sparc/PCI: Use dev_is_pci() to identify PCI devices
      parisc/PCI: Use dev_is_pci() to identify PCI devices
      arm/PCI: Use dev_is_pci() to identify PCI devices
      arm/PCI: Use dev_is_pci() to identify PCI devices
      alpha/PCI: Use dev_is_pci() to identify PCI devices

Yinghai Lu (8):
      PCI: Use device_release_driver() in pci_stop_root_bus()
      PCI: Move pci_proc_attach_device() to pci_bus_add_device()
      PCI: Remove from bus_list and release resources in pci_release_dev()
      PCI: Convert pcibios_resource_to_bus() to take a pci_bus, not a pci_dev
      PCI: Convert ioapic to be builtin only, not modular
      agp/intel: Support 64-bit GMADR
      PCI: Enforce bus address limits in resource allocation
      PCI: Allocate 64-bit BARs above 4G when possible

ethan.zhao (1):
      PCI: Clear NumVFs when disabling SR-IOV in sriov_init()

 Documentation/ABI/testing/sysfs-bus-pci            |  11 +-
 Documentation/PCI/00-INDEX                         |   4 +-
 Documentation/PCI/MSI-HOWTO.txt                    | 308 ++++++++----
 Documentation/PCI/pci.txt                          |   6 +-
 .../devicetree/bindings/pci/designware-pcie.txt    |   2 +
 arch/alpha/kernel/pci-sysfs.c                      |   4 +-
 arch/alpha/kernel/pci_iommu.c                      |   2 +-
 arch/arm/common/it8152.c                           |   4 +-
 arch/arm/mach-ixp4xx/common-pci.c                  |   6 +-
 arch/ia64/hp/common/sba_iommu.c                    |   2 +-
 arch/ia64/sn/pci/pci_dma.c                         |  24 +-
 arch/parisc/kernel/drivers.c                       |  22 +-
 arch/powerpc/kernel/eeh_driver.c                   |  19 +-
 arch/powerpc/kernel/pci-common.c                   |   4 +-
 arch/powerpc/kernel/pci_of_scan.c                  |   4 +-
 arch/s390/pci/pci.c                                |   4 +-
 arch/sparc/kernel/iommu.c                          |   2 +-
 arch/sparc/kernel/ioport.c                         |   5 +-
 arch/sparc/kernel/pci.c                            |   6 +-
 arch/x86/include/asm/pci.h                         |   3 +-
 arch/x86/include/asm/x86_init.h                    |   2 +-
 arch/x86/kernel/acpi/boot.c                        |   4 +-
 arch/x86/kernel/x86_init.c                         |   4 +-
 arch/x86/pci/xen.c                                 |   2 +-
 drivers/acpi/pci_root.c                            |   6 +
 drivers/ata/ahci.c                                 |  56 ++-
 drivers/char/agp/agp.h                             |   1 +
 drivers/char/agp/ali-agp.c                         |   4 +-
 drivers/char/agp/amd-k7-agp.c                      |  12 +-
 drivers/char/agp/amd64-agp.c                       |   5 +-
 drivers/char/agp/ati-agp.c                         |  21 +-
 drivers/char/agp/efficeon-agp.c                    |   5 +-
 drivers/char/agp/generic.c                         |   4 +-
 drivers/char/agp/intel-agp.c                       |  48 +-
 drivers/char/agp/intel-agp.h                       |  10 +-
 drivers/char/agp/intel-gtt.c                       |  47 +-
 drivers/char/agp/nvidia-agp.c                      |   9 +-
 drivers/char/agp/sis-agp.c                         |   5 +-
 drivers/char/agp/via-agp.c                         |  13 +-
 drivers/eisa/eisa-bus.c                            |  31 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   6 +-
 drivers/message/fusion/mptbase.c                   |   2 +-
 drivers/pci/Kconfig                                |   3 +-
 drivers/pci/Makefile                               |   2 +-
 drivers/pci/access.c                               |  24 -
 drivers/pci/ats.c                                  |  82 ----
 drivers/pci/bus.c                                  | 133 +++--
 drivers/pci/host-bridge.c                          |  19 +-
 drivers/pci/host/pci-exynos.c                      |   5 +-
 drivers/pci/host/pci-imx6.c                        | 225 ++++++---
 drivers/pci/host/pci-mvebu.c                       |  99 ++--
 drivers/pci/host/pci-rcar-gen2.c                   |  12 +-
 drivers/pci/host/pci-tegra.c                       |   2 +-
 drivers/pci/host/pcie-designware.c                 |  91 ++--
 drivers/pci/host/pcie-designware.h                 |   4 +-
 drivers/pci/hotplug/acpiphp.h                      |   5 +-
 drivers/pci/hotplug/acpiphp_core.c                 |   2 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |  43 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c             |  14 +-
 drivers/pci/hotplug/cpqphp_pci.c                   |   8 +-
 drivers/pci/hotplug/ibmphp_core.c                  |  13 +-
 drivers/pci/hotplug/pciehp.h                       |  15 +-
 drivers/pci/hotplug/pciehp_core.c                  |  17 +-
 drivers/pci/hotplug/pciehp_ctrl.c                  |  90 ++--
 drivers/pci/hotplug/pciehp_hpc.c                   | 380 +++++---------
 drivers/pci/hotplug/pciehp_pci.c                   |  23 +-
 drivers/pci/hotplug/rpadlpar_core.c                |  19 +-
 drivers/pci/hotplug/rpaphp_core.c                  |   4 +
 drivers/pci/hotplug/s390_pci_hpc.c                 |   4 +-
 drivers/pci/hotplug/sgi_hotplug.c                  |   5 +
 drivers/pci/hotplug/shpchp_pci.c                   |  18 +-
 drivers/pci/ioapic.c                               |   6 +-
 drivers/pci/iov.c                                  |   2 +
 drivers/pci/msi.c                                  | 348 ++++++++-----
 drivers/pci/pci-acpi.c                             |   2 +-
 drivers/pci/pci-label.c                            |  57 +--
 drivers/pci/pci-sysfs.c                            |  19 +-
 drivers/pci/pci.c                                  | 545 ++++++++++-----------
 drivers/pci/pci.h                                  |   2 -
 drivers/pci/pcie/aer/aerdrv_acpi.c                 |  56 ++-
 drivers/pci/pcie/aer/aerdrv_errprint.c             |  95 ++--
 drivers/pci/pcie/aspm.c                            |  12 -
 drivers/pci/pcie/portdrv_core.c                    |  36 +-
 drivers/pci/probe.c                                | 176 ++++---
 drivers/pci/quirks.c                               |   2 +-
 drivers/pci/remove.c                               |  34 +-
 drivers/pci/rom.c                                  |   2 +-
 drivers/pci/setup-bus.c                            |  32 +-
 drivers/pci/setup-res.c                            |   2 +-
 drivers/pci/slot.c                                 |  26 -
 drivers/pci/vc.c                                   | 434 ++++++++++++++++
 drivers/pci/xen-pcifront.c                         |   8 +
 drivers/pcmcia/cardbus.c                           |   7 +
 drivers/pcmcia/i82092.c                            |   2 +-
 drivers/pcmcia/yenta_socket.c                      |   6 +-
 drivers/platform/x86/asus-wmi.c                    |   2 +
 drivers/platform/x86/eeepc-laptop.c                |   2 +
 drivers/scsi/mpt2sas/mpt2sas_base.c                |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |   5 +-
 drivers/vfio/pci/vfio_pci.c                        |  29 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  12 +-
 drivers/video/arkfb.c                              |   2 +-
 drivers/video/s3fb.c                               |   2 +-
 drivers/video/vt8623fb.c                           |   2 +-
 include/acpi/actbl1.h                              |  10 +-
 include/linux/msi.h                                |   4 +-
 include/linux/pci-ats.h                            |  17 -
 include/linux/pci.h                                | 352 ++++---------
 include/uapi/linux/pci_regs.h                      |  37 +-
 scripts/checkpatch.pl                              |  11 +-
 111 files changed, 2513 insertions(+), 1989 deletions(-)
 create mode 100644 drivers/pci/vc.c
