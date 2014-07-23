Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbaGWAN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:13:28 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:32923 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbaGWAN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:13:26 -0400
Date: Tue, 22 Jul 2014 18:13:22 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [GIT PULL] PCI changes for v3.17
Message-ID: <20140723001322.GA29769@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are for the v3.17 merge window, not for v3.16.

I'll be on vacation until Aug 11, and I suspect the merge window will open
before then, so I'm sending this to you early.  There are more things I'd
like to get into v3.17, so I hope to send another pull request soon after
I return.

The most notable pieces here are:

  - Support BARs up to 128GB (up from 8GB)
  - Fix SR-IOV resource assignment when we fail to expand a resource
  - Rework pciehp to handle a common hardware erratum
  - Cleanup MSI
  - Fix NIC renaming issue
  - Fix VGA default device issue on EFI systems
  - Fix ASPM configuration (previously we didn't enable it as expected)

Alex Williamson has graciously agreed to take care of any major issues with
this if you take it before I return.


The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.17-changes

for you to fetch changes up to 792688fde431b4fdb2cf10a6f7589a8176b6b14a:

  Merge branches 'pci/host-generic', 'pci/host-mvebu', 'pci/host-rcar', 'pci/host-tegra', 'pci/msi', 'pci/misc', 'pci/resource' and 'pci/virtualization' into next (2014-07-16 17:09:47 -0600)

----------------------------------------------------------------
PCI changes for the v3.17 merge window:

  Resource management
    - Support BAR sizes up to 128GB (Yinghai Lu)
    - Keep original resource if we fail to expand it (Guo Chao)
    - Return conventional error values from pci_revert_fw_address() (Bjorn Helgaas)
    - Tidy resource assignment messages (Bjorn Helgaas)
    - Don't exclude low BIOS area for non-PCI cards (Christoph Schulz)

  PCI device hotplug
    - Prevent NULL dereference during pciehp probe (Andreas Noever)
    - Make pciehp pcie_wait_cmd() self-contained (Bjorn Helgaas)
    - Wait for pciehp hotplug command completion lazily (Bjorn Helgaas)
    - Compute pciehp timeout from hotplug command start time (Bjorn Helgaas)
    - Remove pciehp assumptions about which commands cause completion events (Bjorn Helgaas)
    - Clear pciehp Data Link Layer State Changed during init (Myron Stowe)
    - Remove pciehp struct controller.no_cmd_complete (Rajat Jain)
    - Remove cpqphp unnecessary null test (Fabian Frederick)
    - Remove "invalid IRQ" warning for hot-added PCIe ports (Jiang Liu)

  IOMMU
    - Add DMA alias quirk for Intel 82801 bridge (Alex Williamson)

  MSI
    - Add internal msix_clear_and_set_ctrl() (Yijing Wang)
    - Remove unused msi_enabled_mask() (Yijing Wang)
    - Cache Multiple Message Capable in struct msi_desc (Yijing Wang)
    - Add msi_setup_entry() to clean up initialization (Yijing Wang)
    - Remove unused msi_remove_pci_irq_vectors() (Yijing Wang)
    - Retrieve first MSI IRQ from msi_desc rather than pci_dev (Yijing Wang)
    - Remove unused list access in __pci_restore_msix_state() (Yijing Wang)
    - Use irq_get_msi_desc() to simplify code (Yijing Wang)

  Generic host bridge driver
    - Fix GPL v2 license string typo (Bjorn Helgaas)

  Marvell MVEBU
    - Fix GPL v2 license string typo (Thierry Reding)

  NVIDIA Tegra
    - Use correct initial HW settings (Phil Edworthy)
    - Remove rcar_pcie_setup_window() resource argument (Phil Edworthy)
    - Fix GPL v2 license string typo (Thierry Reding)

  Renesas R-Car
    - Remove redundant config accessor register checks (Sergei Shtylyov)
    - Fix GPL v2 license string typo (Bjorn Helgaas)

  Virtualization
    - Factor secondary bus reset logic (Gavin Shan)
    - Remove duplicate powerpc reset logic (Gavin Shan)

  Miscellaneous
    - Rework default VGA detection for EFI (Bruno Prémont)
    - Fix sysfs "acpi_index" and "label" errors for NIC renaming (Simone Gotti)
    - Configure ASPM at pci_enable_device()-time (Vidya Sagar)
    - Add include/linux/pci_ids.h include guard (Rasmus Villemoes)

----------------------------------------------------------------
Alex Williamson (1):
      PCI: Add bridge DMA alias quirk for Intel 82801 bridge

Andreas Noever (1):
      PCI: Prevent NULL dereference during pciehp probe

Bjorn Helgaas (11):
      PCI: pciehp: Make pcie_wait_cmd() self-contained
      PCI: pciehp: Wait for hotplug command completion lazily
      PCI: pciehp: Compute timeout from hotplug command start time
      PCI: pciehp: Remove assumptions about which commands cause completion events
      PCI: Cleanup control flow
      PCI: Return conventional error values from pci_revert_fw_address()
      PCI: Tidy resource assignment messages
      Merge branches 'pci/host-rcar', 'pci/hotplug', 'pci/iommu', 'pci/misc' and 'pci/msi' into next
      PCI: rcar: Fix GPL v2 license string typo
      PCI: generic: Fix GPL v2 license string typo
      Merge branches 'pci/host-generic', 'pci/host-mvebu', 'pci/host-rcar', 'pci/host-tegra', 'pci/msi', 'pci/misc', 'pci/resource' and 'pci/virtualization' into next

Bruno Prémont (1):
      x86, ia64: Move EFI_FB vga_default_device() initialization to pci_vga_fixup()

Christoph Schulz (1):
      x86: don't exclude low BIOS area when allocating address space for non-PCI cards

Fabian Frederick (1):
      PCI: cpqphp: Remove unnecessary null test before debugfs_remove()

Gavin Shan (2):
      PCI: Make resetting secondary bus logic common
      powerpc/pci: Remove duplicate logic

Guo Chao (1):
      PCI: Keep original resource if we fail to expand it

Jiang Liu (1):
      PCI/portdrv: Remove warning about invalid IRQ for hot-added PCIe ports

Myron Stowe (1):
      PCI: pciehp: Clear Data Link Layer State Changed during init

Phil Edworthy (3):
      PCI: rcar: Use correct initial HW settings
      PCI: rcar: Cleanup style and formatting
      PCI: rcar: Remove rcar_pcie_setup_window() resource argument

Rajat Jain (1):
      PCI: pciehp: Remove struct controller.no_cmd_complete

Rasmus Villemoes (1):
      PCI: Add include guard to include/linux/pci_ids.h

Sergei Shtylyov (1):
      PCI: rcar: Remove redundant config accessor register number checks

Simone Gotti (1):
      ACPI / PCI: Fix sysfs acpi_index and label errors

Thierry Reding (2):
      PCI: mvebu: Fix GPL v2 license string typo
      PCI: tegra: Fix GPL v2 license string typo

Vidya Sagar (1):
      PCI: Configure ASPM when enabling device

Yijing Wang (8):
      PCI/MSI: Add internal msix_clear_and_set_ctrl() function
      PCI/MSI: Remove unused msi_enabled_mask()
      PCI/MSI: Cache Multiple Message Capable in struct msi_desc
      PCI/MSI: Add msi_setup_entry() to clean up MSI initialization
      PCI/MSI: Remove unused function msi_remove_pci_irq_vectors()
      PCI/MSI: Retrieve first MSI IRQ from msi_desc rather than pci_dev
      PCI/MSI: Remove unused list access in __pci_restore_msix_state()
      PCI/MSI: Use irq_get_msi_desc() to simplify code

Yinghai Lu (1):
      PCI: Support BAR sizes up to 128GB

 arch/ia64/pci/fixup.c               |  22 +++++
 arch/powerpc/kernel/pci-common.c    |  11 +--
 arch/x86/include/asm/vga.h          |   6 --
 arch/x86/kernel/resource.c          |   8 +-
 arch/x86/pci/fixup.c                |  21 +++++
 arch/x86/pci/i386.c                 |   4 +
 drivers/pci/host/pci-host-generic.c |   2 +-
 drivers/pci/host/pci-mvebu.c        |   2 +-
 drivers/pci/host/pci-tegra.c        |   2 +-
 drivers/pci/host/pcie-rcar.c        | 158 ++++++++++++++++--------------------
 drivers/pci/hotplug/cpqphp_sysfs.c  |   3 +-
 drivers/pci/hotplug/pciehp.h        |   3 +-
 drivers/pci/hotplug/pciehp_core.c   |   7 ++
 drivers/pci/hotplug/pciehp_hpc.c    | 101 ++++++++++-------------
 drivers/pci/msi.c                   | 141 ++++++++++++++------------------
 drivers/pci/pci-label.c             |  18 ++--
 drivers/pci/pci.c                   |  19 +++--
 drivers/pci/pcie/portdrv_pci.c      |   4 -
 drivers/pci/quirks.c                |   2 +
 drivers/pci/setup-bus.c             |   2 +-
 drivers/pci/setup-res.c             |  75 ++++++++---------
 drivers/video/fbdev/efifb.c         |  39 ---------
 include/linux/msi.h                 |   3 +-
 include/linux/pci.h                 |   4 +-
 include/linux/pci_ids.h             |   4 +
 25 files changed, 313 insertions(+), 348 deletions(-)
