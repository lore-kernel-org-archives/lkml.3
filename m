Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab3GATlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:41:06 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55015 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3GATlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:41:04 -0400
Date: Mon, 1 Jul 2013 13:40:58 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.11
Message-ID: <20130701194058.GA10966@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.11-changes

for you to fetch changes up to a0f75f9d495b3905b4c658c1d813a127f558a350:

  Merge branch 'pci/misc' into next (2013-06-26 15:55:52 -0600)

----------------------------------------------------------------

PCI changes for the v3.11 merge window:

  PCI device hotplug
    - Add pci_alloc_dev() interface (Gu Zheng)
    - Add pci_bus_get()/put() for reference counting (Jiang Liu)
    - Fix SR-IOV reference count issues (Jiang Liu)
    - Remove unused acpi_pci_roots list (Jiang Liu)

  MSI
    - Conserve interrupt resources on x86 (Alexander Gordeev)

  AER
    - Force fatal severity when component has been reset (Betty Dall)
    - Reset link below Root Port as well as Downstream Port (Betty Dall)
    - Fix "Firmware first" flag setting (Bjorn Helgaas)
    - Don't parse HEST for non-PCIe devices (Bjorn Helgaas)

  ASPM
    - Warn when we can't disable ASPM as driver requests (Bjorn Helgaas)

  Miscellaneous
    - Add CircuitCo PCI IDs (Darren Hart)
    - Add AMD CZ SATA and SMBus PCI IDs (Shane Huang)
    - Work around Ivytown NTB BAR size issue (Jon Mason)
    - Detect invalid initial BAR values (Kevin Hao)
    - Add pcibios_release_device() (Sebastian Ott)
    - Fix powerpc & sparc PCI_UNKNOWN power state usage (Bjorn Helgaas)

----------------------------------------------------------------
Alexander Gordeev (3):
      PCI: Allocate only as many MSI vectors as requested by driver
      x86/MSI: Conserve interrupt resources when using multiple-MSIs
      x86/MSI: Conserve interrupt resources when using multiple-MSIs

Betty Dall (4):
      PCI/AER: Move AER severity defines to aer.h
      PCI/AER: Remove "extern" from function declarations
      ACPI / APEI: Force fatal AER severity when component has been reset
      PCI/AER: Reset link for devices below Root Port or Downstream Port

Bjorn Helgaas (21):
      PCI/ACPI: Check acpi_resource_to_address64() return value
      powerpc/PCI: Use PCI_UNKNOWN for unknown power state
      sparc/PCI: Use PCI_UNKNOWN for unknown power state
      PCI/ASPM: Warn when driver asks to disable ASPM, but we can't do it
      Merge branch 'pci/misc' into next
      Merge branch 'pci/kevin-bus-to-resource' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/jiang-remove-global-list' into next
      Merge branch 'pci/shane-amd-ahci-i2c' into next
      Merge branch 'pci/alexander-msi' into next
      Merge branch 'pci/jiang-iov-fixes' into next
      PCI/AER: Don't parse HEST table for non-PCIe devices
      PCI/AER: Factor out HEST device type matching
      PCI/AER: Set dev->__aer_firmware_first only for matching devices
      Merge branch 'pci/betty-aer-v3' into next
      Merge branch 'pci/misc' into next
      PCI: Return early on allocation failures to unindent mainline code
      Merge branch 'pci/jiang-bus-lock-v3' into next
      Merge branch 'pci/alexander-msi' into next
      MAINTAINERS: Add ACPI folks for ACPI-related things under drivers/pci
      Merge branch 'pci/misc' into next

Darren Hart (1):
      PCI: Add CircuitCo vendor ID and subsystem ID

Gu Zheng (2):
      PCI: Introduce pci_alloc_dev(struct pci_bus*) to replace alloc_pci_dev()
      PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)

Jiang Liu (13):
      PCI: Introduce pci_bus_{get|put}() to manage PCI bus reference count
      PCI/ACPI: Combine duplicate adjacent "if" tests
      PCI/ACPI: Introduce "handle" local for economy of expression
      PCI/ACPI: Remove unused global list acpi_pci_roots
      PCI/ACPI: Use dev_printk(), acpi_handle_print(), pr_xxx() when possible
      PCI: Hide remove and rescan sysfs interfaces for SR-IOV virtual functions
      ia64/PCI: Clean up pci_scan_root_bus() usage
      PCI: Fix refcount issue in pci_create_root_bus() error recovery path
      PCI: Rename pci_release_bus_bridge_dev() to pci_release_host_bridge_dev()
      m68k/PCI: Remove redundant call of pci_bus_add_devices()
      unicore32/PCI: Remove redundant call of pci_bus_add_devices()
      PCI: Drop redundant setting of bus->is_added in virtfn_add_bus()
      PCI: Simplify IOV implementation and fix reference count races

Jingoo Han (1):
      PCI: Replace strict_strtoul() with kstrtoul()

Jon Mason (1):
      PCI: Work around Ivytown NTB BAR size issue

Kevin Hao (3):
      PCI: Add 0x prefix to BAR register position in __pci_read_base()
      PCI: Consolidate calls to pcibios_bus_to_resource() in __pci_read_base()
      PCI: Unset resource if initial BAR value is invalid

Libo Chen (1):
      PCI: Convert ioapic.c to module_pci_driver

Rafael J. Wysocki (1):
      PCI / ACPI / PM: Use correct power state strings in messages

Sebastian Ott (1):
      PCI: Add pcibios_release_device()

Shane Huang (3):
      PCI: Put Hudson-2 device IDs together
      ahci: Add AMD CZ SATA device ID
      i2c-piix4: Add AMD CZ SMBus device ID

Wang Sheng-Hui (1):
      PCI: Fix INTC comment typo for pci_swizzle_interrupt_pin()

Xudong Hao (1):
      PCI: Finish SR-IOV VF setup before adding the device

Yijing Wang (6):
      x86/PCI: Increase info->res_num before checking pci_use_crs
      PCI: Fix kerneldoc for pci_disable_link_state()
      PCI: Replace printks with appropriate pr_*()
      PCI: Fix comment typo for PCI_EXP_LNKCAP_CLKPM
      PCI: Fix comment typo for pcie_pme_remove()
      PCI: Use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)

 Documentation/i2c/busses/i2c-piix4 |   2 +-
 MAINTAINERS                        |   3 +
 arch/ia64/sn/kernel/io_init.c      |  11 +---
 arch/m68k/platform/coldfire/pci.c  |   1 -
 arch/powerpc/kernel/pci_of_scan.c  |   5 +-
 arch/sparc/kernel/pci.c            |   5 +-
 arch/unicore32/kernel/pci.c        |   5 --
 arch/x86/pci/acpi.c                |   7 +--
 drivers/acpi/apei/ghes.c           |  10 ++++
 drivers/acpi/pci_root.c            | 101 +++++++++++++-------------------
 drivers/ata/ahci.c                 |   1 +
 drivers/char/agp/alpha-agp.c       |   2 +-
 drivers/char/agp/parisc-agp.c      |   2 +-
 drivers/i2c/busses/Kconfig         |   1 +
 drivers/i2c/busses/i2c-piix4.c     |   3 +-
 drivers/iommu/irq_remapping.c      |  12 ++--
 drivers/pci/bus.c                  |  15 +++++
 drivers/pci/ioapic.c               |  13 +----
 drivers/pci/iov.c                  |  65 +++++++++------------
 drivers/pci/msi.c                  |  10 +++-
 drivers/pci/pci-acpi.c             |  10 ++--
 drivers/pci/pci-sysfs.c            |  48 ++++++++++++----
 drivers/pci/pci.c                  |  14 ++++-
 drivers/pci/pcie/aer/aerdrv.h      |   4 --
 drivers/pci/pcie/aer/aerdrv_acpi.c |  47 +++++++--------
 drivers/pci/pcie/aer/aerdrv_core.c |  17 +++---
 drivers/pci/pcie/aspm.c            |  29 +++++++---
 drivers/pci/pcie/pme.c             |   2 +-
 drivers/pci/probe.c                | 115 +++++++++++++++++++++++--------------
 drivers/pci/quirks.c               |  33 +++++++++--
 drivers/scsi/megaraid.c            |   2 +-
 include/acpi/acpi_bus.h            |   1 -
 include/linux/aer.h                |  20 ++++---
 include/linux/msi.h                |   1 +
 include/linux/pci.h                |   6 +-
 include/linux/pci_ids.h            |   7 ++-
 include/uapi/linux/pci_regs.h      |   2 +-
 37 files changed, 361 insertions(+), 271 deletions(-)
