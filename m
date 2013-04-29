Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab3D2GpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 02:45:01 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62433 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3D2Go7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 02:44:59 -0400
Date: Mon, 29 Apr 2013 00:44:55 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.10
Message-ID: <20130429064455.GA14050@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.10-changes

for you to fetch changes up to d4f09c5d7fbabd1389a5f03f5c9329d790f544e3:

  Merge branch 'pci/gavin-msi-cleanup' into next (2013-04-24 11:37:49 -0600)

----------------------------------------------------------------

PCI changes for the v3.10 merge window:

  PCI device hotplug
    - Remove ACPI PCI subdrivers (Jiang Liu, Myron Stowe)
    - Make acpiphp builtin only, not modular (Jiang Liu)
    - Add acpiphp mutual exclusion (Jiang Liu)

  Power management
    - Skip "PME enabled/disabled" messages when not supported (Rafael Wysocki)
    - Fix fallback to PCI_D0 (Rafael Wysocki)

  Miscellaneous
    - Factor quirk_io_region (Yinghai Lu)
    - Cache MSI capability offsets & cleanup (Gavin Shan, Bjorn Helgaas)
    - Clean up EISA resource initialization and logging (Bjorn Helgaas)
    - Fix prototype warnings (Andy Shevchenko, Bjorn Helgaas)
    - MIPS: Initialize of_node before scanning bus (Gabor Juhos)
    - Fix pcibios_get_phb_of_node() declaration "weak" annotation (Gabor Juhos)
    - Add MSI INTX_DISABLE quirks for AR8161/AR8162/etc (Xiong Huang)
    - Fix aer_inject return values (Prarit Bhargava)
    - Remove PME/ACPI dependency (Andrew Murray)
    - Use shared PCI_BUS_NUM() and PCI_DEVID() (Shuah Khan)

----------------------------------------------------------------
Andy Shevchenko (1):
      PCI: Fix missing prototype for pcie_port_acpi_setup()

Bjorn Helgaas (36):
      Merge branch 'pci/shuah-defines' into next
      PCI: Remove __weak annotation from pcibios_get_phb_of_node decl
      PCI: Make local functions/structs static
      PCI: Move cpci_hotplug_init() proto to header file
      PCI: Remove unused variables
      Merge branch 'pci/gabor-get-of-node' into next
      PCI: Remove unnecessary dependencies between PME and ACPI
      PCI: Use PCI_EXP_SLTCAP_PSN mask when extracting slot number
      EISA: Use dev_printk() when possible
      EISA: Mark vendor ID resource as I/O port space
      EISA: Initialize device before its resources
      EISA: Log device resources in dmesg
      Merge branch 'pci/bjorn-eisa' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/jiang-subdrivers' into next
      PCI: Remove __must_check from definitions
      PCI: Warn about failures instead of "must_check" functions
      PCI: Remove "extern" from function declarations
      Merge branch 'pci/cleanup' into next
      Merge branch 'pci/rafael-pm' into next
      [SCSI] megaraid_sas: Use correct #define for MSI-X capability
      PCI: Use u8, not int, for PM capability offset
      PCI: Clean up MSI/MSI-X capability #defines
      PCI: Use cached MSI/MSI-X offsets from dev, not from msi_desc
      PCI: Drop msi_control_reg() macro and use PCI_MSI_FLAGS directly
      PCI: Drop msi_lower_address_reg() and msi_upper_address_reg() macros
      PCI: Drop msi_data_reg() macro
      PCI: Drop is_64bit_address() and is_mask_bit_support() macros
      PCI: Drop msix_table_offset_reg() and msix_pba_offset_reg() macros
      PCI: Use msix_table_size() directly, drop multi_msix_capable()
      PCI: Drop msi_mask_reg() and remove drivers/pci/msi.h
      PCI: Use PCI_MSIX_TABLE_BIR, not PCI_MSIX_FLAGS_BIRMASK
      PCI: Remove "extern" from function declarations
      vfio-pci: Use PCI_MSIX_TABLE_BIR, not PCI_MSIX_FLAGS_BIRMASK
      vfio-pci: Use cached MSI/MSI-X capabilities
      Merge branch 'pci/gavin-msi-cleanup' into next

Gabor Juhos (1):
      MIPS/PCI: Implement pcibios_get_phb_of_node

Gavin Shan (4):
      PCI: Cache MSI/MSI-X capability offsets in struct pci_dev
      PCI: Remove MSI/MSI-X cap check in pci_msi_check_device()
      PCI: Use cached MSI cap while enabling MSI interrupts
      PCI: Use cached MSI-X cap while enabling MSI-X

Jiang Liu (12):
      PCI: When removing bus, always remove legacy files & unregister
      PCI: Clean up usages of pci_bus->is_added
      PCI: acpiphp: Remove all functions even if function 0 doesn't exist
      PCI: acpiphp: Replace local macros with standard ACPI macros
      PCI: Add pcibios hooks for adding and removing PCI buses
      PCI/ACPI: Prepare stub functions to handle ACPI PCI (hotplug) slots
      ia64/PCI: Implement pcibios_{add|remove}_bus() hooks
      x86/PCI: Implement pcibios_{add|remove}_bus() hooks
      PCI/ACPI: Handle PCI slot devices when creating/destroying PCI buses
      PCI: acpiphp: Convert acpiphp to be builtin only, not modular
      PCI: acpiphp: Do not use ACPI PCI subdriver mechanism
      PCI: acpiphp: Protect acpiphp data structures from concurrent updates

Libin (1):
      PCI: Use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT

Myron Stowe (4):
      ahci: Use PCI_VENDOR_ID_MARVELL_EXT for 0x1b4b
      [SCSI] mvsas: Use PCI_VENDOR_ID_MARVELL_EXT for 0x1b4b
      [SCSI] mvumi: Use PCI_VENDOR_ID_MARVELL_EXT for 0x1b4b
      PCI/ACPI: Remove support of ACPI PCI subdrivers

Prarit Bhargava (1):
      PCI: aer_inject: Fix return values when device not found

Rafael J. Wysocki (2):
      PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()
      PCI/PM: Make pci_pme_active() ignore devices without PME support

Shuah Khan (4):
      PCI: Add PCI_BUS_NUM() and PCI_DEVID() interfaces
      PCI/AER: Remove local PCI_BUS() define and use PCI_BUS_NUM() from PCI
      iommu/amd: Remove local PCI_BUS() define and use PCI_BUS_NUM() from PCI
      iommu/amd: Remove calc_devid() and use PCI_DEVID() from PCI

Xiangliang Yu (1):
      PCI: Define macro for Marvell vendor ID

Xiong Huang (1):
      PCI: Add MSI INTX_DISABLE quirks for AR8161/AR8162/AR8171/AR8172/E210X

Yijing Wang (2):
      PCI: acpiphp: Use list_for_each_entry_safe() in acpiphp_sanitize_bus()
      PCI: acpiphp: Use normal list to simplify implementation

Yinghai Lu (1):
      PCI: Clean up quirk_io_region

 arch/ia64/pci/pci.c                       |  11 +
 arch/mips/pci/pci.c                       |   8 +-
 arch/x86/pci/common.c                     |  11 +
 drivers/acpi/pci_root.c                   |  48 +---
 drivers/acpi/pci_slot.c                   | 170 ++----------
 drivers/acpi/scan.c                       |   1 -
 drivers/ata/ahci.c                        |  10 +-
 drivers/eisa/eisa-bus.c                   |  82 +++---
 drivers/eisa/pci_eisa.c                   |   5 +-
 drivers/iommu/amd_iommu.c                 |  14 +-
 drivers/iommu/amd_iommu_init.c            |  40 +--
 drivers/iommu/amd_iommu_types.h           |  11 +-
 drivers/pci/bus.c                         |  14 +-
 drivers/pci/hotplug/Kconfig               |   7 +-
 drivers/pci/hotplug/acpiphp.h             |  35 ++-
 drivers/pci/hotplug/acpiphp_core.c        |  30 +--
 drivers/pci/hotplug/acpiphp_glue.c        | 415 ++++++++++--------------------
 drivers/pci/hotplug/cpci_hotplug.h        |  44 ++--
 drivers/pci/hotplug/cpqphp.h              |  70 +++--
 drivers/pci/hotplug/cpqphp_nvram.h        |  12 +-
 drivers/pci/hotplug/ibmphp.h              |  66 ++---
 drivers/pci/hotplug/pci_hotplug_core.c    |  15 +-
 drivers/pci/hotplug/pciehp.h              |  22 +-
 drivers/pci/hotplug/pciehp_acpi.c         |   2 +-
 drivers/pci/hotplug/rpadlpar.h            |   8 +-
 drivers/pci/hotplug/rpaphp.h              |  16 +-
 drivers/pci/hotplug/shpchp.h              |  26 +-
 drivers/pci/hotplug/shpchp_sysfs.c        |   2 +-
 drivers/pci/msi.c                         | 180 ++++++-------
 drivers/pci/msi.h                         |  24 --
 drivers/pci/pci-acpi.c                    |  30 +++
 drivers/pci/pci-sysfs.c                   |   2 +-
 drivers/pci/pci.c                         |  25 +-
 drivers/pci/pci.h                         |  89 ++++---
 drivers/pci/pcie/Kconfig                  |   2 +-
 drivers/pci/pcie/aer/aer_inject.c         |  10 +-
 drivers/pci/pcie/aer/aerdrv.h             |  14 +-
 drivers/pci/pcie/aer/aerdrv_core.c        |   4 +-
 drivers/pci/pcie/pme.c                    |   2 -
 drivers/pci/pcie/portdrv.h                |  18 +-
 drivers/pci/pcie/portdrv_acpi.c           |   1 +
 drivers/pci/pcie/portdrv_pci.c            |  17 +-
 drivers/pci/probe.c                       |  15 +-
 drivers/pci/quirks.c                      | 148 +++++------
 drivers/pci/remove.c                      |   4 +-
 drivers/pci/setup-bus.c                   |   4 +-
 drivers/pci/setup-res.c                   |   2 -
 drivers/pci/slot.c                        |   7 +-
 drivers/scsi/megaraid/megaraid_sas.h      |   3 -
 drivers/scsi/megaraid/megaraid_sas_base.c |   4 +-
 drivers/scsi/mvsas/mv_init.c              |   6 +-
 drivers/scsi/mvumi.c                      |   4 +-
 drivers/scsi/mvumi.h                      |   1 -
 drivers/vfio/pci/vfio_pci.c               |  10 +-
 include/linux/acpi.h                      |   9 -
 include/linux/msi.h                       |  23 +-
 include/linux/pci-acpi.h                  |  29 +++
 include/linux/pci-aspm.h                  |  20 +-
 include/linux/pci-ats.h                   |  26 +-
 include/linux/pci.h                       | 117 +++++----
 include/linux/pci_hotplug.h               |  12 +-
 include/linux/pci_ids.h                   |   1 +
 include/linux/pcieport_if.h               |   4 +-
 include/uapi/linux/pci_regs.h             |  30 ++-
 64 files changed, 884 insertions(+), 1208 deletions(-)
 delete mode 100644 drivers/pci/msi.h
