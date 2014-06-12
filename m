Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaFLT2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:28:05 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61745 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaFLT2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:28:02 -0400
Date: Thu, 12 Jun 2014 13:27:59 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.16 (part 2)
Message-ID: <20140612192759.GA25090@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some more things I'd like to see in v3.16-rc1:

  - DMA alias iterator, part of some work to fix IOMMU issues
  - MVEBU, Tegra, DesignWare changes that I forgot to include before
  - Some whitespace code cleanup

Thanks!


The following changes since commit 617b4157a5c82ab3e9509aa388bfd3d47e0e623a:

  Merge branches 'pci/host-exynos', 'pci/host-imx6', 'pci/resource' and 'pci/misc' into next (2014-05-30 11:41:17 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.16-changes-2

for you to fetch changes up to 38a6148248e199a4a960bbaa6b8eb14f138b73e1:

  Merge branches 'pci/msi', 'pci/iommu' and 'pci/cleanup' into next (2014-06-11 14:38:25 -0600)

----------------------------------------------------------------
PCI changes for the v3.16 merge window (part 2):

  IOMMU
    - Add DMA alias iterator (Alex Williamson)
    - Add DMA alias quirks for ASMedia, ITE, Tundra bridges (Alex Williamson)
    - Add DMA alias quirks for Marvell, Ricoh devices (Alex Williamson)
    - Add DMA alias quirk for HighPoint devices (Jérôme Carretero)

  MSI
    - Fix leak in free_msi_irqs() (Alexei Starovoitov)

  Marvell MVEBU
    - Remove unnecessary use of 'conf_lock' spinlock (Andrew Murray)
    - Avoid setting an undefined window size (Jason Gunthorpe)
    - Allow several windows with the same target/attribute (Thomas Petazzoni)
    - Split PCIe BARs into multiple MBus windows when needed (Thomas Petazzoni)
    - Fix off-by-one in the computed size of the mbus windows (Willy Tarreau)

  NVIDIA Tegra
    - Use new OF interrupt mapping when possible (Lucas Stach)

  Synopsys DesignWare
    - Remove unnecessary use of 'conf_lock' spinlock (Andrew Murray)
    - Use new OF interrupt mapping when possible (Lucas Stach)
    - Split Exynos and i.MX bindings (Lucas Stach)
    - Fix comment for setting number of lanes (Mohit Kumar)
    - Fix iATU programming for cfg1, io and mem viewport (Mohit Kumar)

  Miscellaneous
    - EXPORT_SYMBOL cleanup (Ryan Desfosses)
    - Whitespace cleanup (Ryan Desfosses)
    - Merge multi-line quoted strings (Ryan Desfosses)

----------------------------------------------------------------
Alex Williamson (8):
      PCI: Add DMA alias iterator
      PCI: Convert pci_dev_flags definitions to bit shifts
      PCI: Add support for DMA alias quirks
      PCI: Add function 0 DMA alias quirk for Ricoh devices
      PCI: Add function 1 DMA alias quirk for Marvell devices
      PCI: Add support for PCIe-to-PCI bridge DMA alias quirks
      PCI: Add bridge DMA alias quirk for ASMedia and Tundra bridges
      PCI: Add bridge DMA alias quirk for ITE bridge

Alexei Starovoitov (1):
      PCI/MSI: Fix memory leak in free_msi_irqs()

Andrew Murray (2):
      PCI: designware: Remove unnecessary use of 'conf_lock' spinlock
      PCI: mvebu: Remove unnecessary use of 'conf_lock' spinlock

Bjorn Helgaas (4):
      Merge tag 'tags/mvebu-mbus_pci-fixes-3.15' into pci/host-mvebu
      Merge branch 'pci/iommu' into next
      Merge branches 'pci/host-designware', 'pci/host-imx6', 'pci/host-mvebu' and 'pci/host-tegra' into next
      Merge branches 'pci/msi', 'pci/iommu' and 'pci/cleanup' into next

Fabio Estevam (1):
      PCI: mvebu: Use '%pa' for printing 'phys_addr_t' type

Jason Gunthorpe (1):
      bus: mvebu-mbus: Avoid setting an undefined window size

Jérôme Carretero (1):
      PCI: Add function 1 DMA alias quirk for HighPoint RocketRaid 642L

Lucas Stach (3):
      PCI: tegra: Use new OF interrupt mapping when possible
      PCI: designware: Use new OF interrupt mapping when possible
      PCI: designware: Split Exynos and i.MX bindings

Mohit Kumar (2):
      PCI: designware: Fix comment for setting number of lanes
      PCI: designware: Fix iATU programming for cfg1, io and mem viewport

Ryan Desfosses (3):
      PCI: Move EXPORT_SYMBOL so it immediately follows function/variable
      PCI: Whitespace cleanup
      PCI: Merge multi-line quoted strings

Thomas Petazzoni (2):
      bus: mvebu-mbus: allow several windows with the same target/attribute
      PCI: mvebu: split PCIe BARs into multiple MBus windows when needed

Willy Tarreau (1):
      PCI: mvebu: fix off-by-one in the computed size of the mbus windows

 .../devicetree/bindings/pci/designware-pcie.txt    |  74 +----
 .../devicetree/bindings/pci/fsl,imx6q-pcie.txt     |  38 +++
 .../bindings/pci/samsung,exynos5440-pcie.txt       |  65 +++++
 drivers/bus/mvebu-mbus.c                           |  22 +-
 drivers/pci/access.c                               |   5 +-
 drivers/pci/bus.c                                  |   6 +-
 drivers/pci/host/pci-exynos.c                      |   1 -
 drivers/pci/host/pci-imx6.c                        |   1 -
 drivers/pci/host/pci-mvebu.c                       | 119 +++++---
 drivers/pci/host/pci-tegra.c                       |   7 +-
 drivers/pci/host/pcie-designware.c                 |  26 +-
 drivers/pci/host/pcie-designware.h                 |   1 -
 drivers/pci/host/pcie-rcar.c                       |  10 +-
 drivers/pci/hotplug/acpiphp_core.c                 |   6 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |   6 +-
 drivers/pci/hotplug/cpci_hotplug.h                 |  18 +-
 drivers/pci/hotplug/cpci_hotplug_core.c            |  31 ++-
 drivers/pci/hotplug/cpci_hotplug_pci.c             |  18 +-
 drivers/pci/hotplug/cpcihp_generic.c               |   8 +-
 drivers/pci/hotplug/cpcihp_zt5550.c                |   2 +-
 drivers/pci/hotplug/cpqphp.h                       |   4 +-
 drivers/pci/hotplug/cpqphp_core.c                  |  12 +-
 drivers/pci/hotplug/cpqphp_ctrl.c                  |  26 +-
 drivers/pci/hotplug/cpqphp_nvram.c                 |  32 +--
 drivers/pci/hotplug/cpqphp_pci.c                   |  26 +-
 drivers/pci/hotplug/cpqphp_sysfs.c                 |   2 +-
 drivers/pci/hotplug/ibmphp_core.c                  |  44 ++-
 drivers/pci/hotplug/ibmphp_ebda.c                  |  10 +-
 drivers/pci/hotplug/ibmphp_hpc.c                   |   6 +-
 drivers/pci/hotplug/ibmphp_pci.c                   |  36 +--
 drivers/pci/hotplug/ibmphp_res.c                   |  15 +-
 drivers/pci/hotplug/pci_hotplug_core.c             | 106 ++++----
 drivers/pci/hotplug/pciehp_acpi.c                  |   4 +-
 drivers/pci/hotplug/pciehp_core.c                  |   7 +-
 drivers/pci/hotplug/pciehp_ctrl.c                  |  16 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |  52 ++--
 drivers/pci/hotplug/pciehp_pci.c                   |   5 +-
 drivers/pci/hotplug/pcihp_skeleton.c               |  38 +--
 drivers/pci/hotplug/rpaphp_core.c                  |  13 +-
 drivers/pci/hotplug/sgi_hotplug.c                  |  35 +--
 drivers/pci/hotplug/shpchp.h                       |   4 +-
 drivers/pci/hotplug/shpchp_core.c                  |   3 +-
 drivers/pci/hotplug/shpchp_ctrl.c                  |  36 ++-
 drivers/pci/hotplug/shpchp_hpc.c                   |  29 +-
 drivers/pci/hotplug/shpchp_pci.c                   |   6 +-
 drivers/pci/hotplug/shpchp_sysfs.c                 |   2 +-
 drivers/pci/htirq.c                                |   7 +-
 drivers/pci/msi.c                                  |   5 +-
 drivers/pci/pci-driver.c                           |  69 +++--
 drivers/pci/pci-label.c                            |  65 ++---
 drivers/pci/pci-stub.c                             |   2 +-
 drivers/pci/pci-sysfs.c                            | 299 ++++++++++-----------
 drivers/pci/pci.c                                  | 201 ++++++--------
 drivers/pci/pcie/aer/aer_inject.c                  |   9 +-
 drivers/pci/pcie/aer/aerdrv_core.c                 |   3 +-
 drivers/pci/pcie/aer/aerdrv_errprint.c             |  10 +-
 drivers/pci/pcie/pme.c                             |   3 +-
 drivers/pci/pcie/portdrv_pci.c                     |   6 +-
 drivers/pci/probe.c                                |  60 ++---
 drivers/pci/proc.c                                 |  16 +-
 drivers/pci/quirks.c                               | 232 ++++++++++------
 drivers/pci/rom.c                                  |  13 +-
 drivers/pci/search.c                               | 118 ++++++--
 drivers/pci/setup-bus.c                            |  51 ++--
 drivers/pci/setup-irq.c                            |  13 +-
 drivers/pci/setup-res.c                            |  13 +-
 drivers/pci/syscall.c                              |   2 +-
 include/linux/pci.h                                |  17 +-
 68 files changed, 1177 insertions(+), 1070 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.txt
 create mode 100644 Documentation/devicetree/bindings/pci/samsung,exynos5440-pcie.txt
