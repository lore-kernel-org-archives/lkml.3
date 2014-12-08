Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaLHWuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:50:22 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:57532 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaLHWuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:50:20 -0500
Date: Mon, 8 Dec 2014 15:50:16 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.19
Message-ID: <20141208225016.GA13583@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the PCI changes intended for v3.19.  I don't think there's
anything very exciting here, but there's a lot of MSI-related stuff coming
via Thomas.

Bjorn


The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.19-changes

for you to fetch changes up to 149792795d2bab33954bc025fcf145a8009683f6:

  Merge branch 'pci/msi' into next (2014-11-21 10:11:33 -0700)

----------------------------------------------------------------
PCI changes for the v3.19 merge window:

  NUMA
    - Allow numa_node override via sysfs (Prarit Bhargava)

  Resource management
    - Restore detection of read-only BARs (Myron Stowe)
    - Shrink decoding-disabled window while sizing BARs (Myron Stowe)
    - Add informational printk for invalid BARs (Myron Stowe)
    - Remove fixed parameter in pci_iov_resource_bar() (Myron Stowe)

  MSI
    - Add pci_msi_ignore_mask to prevent writes to MSI/MSI-X Mask Bits (Yijing Wang)
    - Revert "PCI: Add x86_msi.msi_mask_irq() and msix_mask_irq()" (Yijing Wang)
    - s390/MSI: Use __msi_mask_irq() instead of default_msi_mask_irq() (Yijing Wang)

  Virtualization
    - xen: Process failure for pcifront_(re)scan_root() (Chen Gang)
    - Make FLR and AF FLR reset warning messages different (Gavin Shan)

  Generic host bridge driver
    - Allocate config space windows after limiting bus number range (Lorenzo Pieralisi)
    - Convert to DT resource parsing API (Lorenzo Pieralisi)

  Freescale Layerscape
    - Add Freescale Layerscape PCIe driver (Minghuan Lian)

  NVIDIA Tegra
    - Do not build on 64-bit ARM (Thierry Reding)
    - Add Kconfig help text (Thierry Reding)

  Renesas R-Car
    - Make rcar_pci static (Jingoo Han)

  Samsung Exynos
    - Add exynos prefix to add_pcie_port(), pcie_init() (Jingoo Han)

  ST Microelectronics SPEAr13xx
    - Add spear prefix to add_pcie_port(), pcie_init() (Jingoo Han)
    - Make spear13xx_add_pcie_port() __init (Jingoo Han)
    - Remove unnecessary OOM message (Jingoo Han)

  TI DRA7xx
    - Add dra7xx prefix to add_pcie_port() (Jingoo Han)
    - Make dra7xx_add_pcie_port() __init (Jingoo Han)

  TI Keystone
    - Make ks_dw_pcie_msi_domain_ops static (Jingoo Han)
    - Remove unnecessary OOM message (Jingoo Han)

  Miscellaneous
    - Delete unnecessary NULL pointer checks (Markus Elfring)
    - Remove unused to_hotplug_slot() (Gavin Shan)
    - Whitespace cleanup (Jingoo Han)
    - Simplify if-return sequences (Quentin Lambert)

----------------------------------------------------------------
Bjorn Helgaas (3):
      Merge branches 'pci/host-designware', 'pci/host-dra7xx', 'pci/host-exynos', 'pci/host-generic', 'pci/host-imx6', 'pci/host-keystone', 'pci/host-layerscape', 'pci/host-mvebu', 'pci/host-rcar', 'pci/host-spear' and 'pci/host-tegra' into next
      Merge branches 'pci/enumeration', 'pci/hotplug', 'pci/misc', 'pci/numa' and 'pci/virtualization' into next
      Merge branch 'pci/msi' into next

Chen Gang (1):
      xen/pcifront: Process failure for pcifront_(re)scan_root()

Gavin Shan (2):
      PCI: Make FLR and AF FLR reset warning messages different
      PCI: Remove unused and broken to_hotplug_slot()

Jingoo Han (13):
      PCI: exynos: Add exynos prefix to add_pcie_port()/pcie_init()
      PCI: keystone: Make ks_dw_pcie_msi_domain_ops static
      PCI: rcar: Make rcar_pci static
      PCI: dra7xx: Rename add_pcie_port() to dra7xx_add_pcie_port()
      PCI: spear: Rename add_pcie_port(), pcie_init() to spear13xx_add_pcie_port(), etc.
      PCI: spear: Add __init annotation to spear13xx_add_pcie_port()
      PCI: dra7xx: Add __init annotation to dra7xx_add_pcie_port()
      PCI: keystone: Remove unnecessary OOM message
      PCI: imx6: Use tabs for indentation
      PCI: exynos: Remove unnecessary return statement
      PCI: designware: Add a blank line after declarations
      PCI: mvebu: Add a blank line after declarations
      PCI: spear: Remove unnecessary OOM message

Lorenzo Pieralisi (2):
      PCI: generic: Allocate config space windows after limiting bus number range
      PCI: generic: Convert to DT resource parsing API

Markus Elfring (1):
      PCI: Delete unnecessary NULL pointer checks

Minghuan Lian (1):
      PCI: layerscape: Add Freescale Layerscape PCIe driver

Myron Stowe (4):
      PCI: Restore detection of read-only BARs
      PCI: Shrink decoding-disabled window while sizing BARs
      PCI: Add informational printk for invalid BARs
      PCI: Remove fixed parameter in pci_iov_resource_bar()

Prarit Bhargava (1):
      PCI: Allow numa_node override via sysfs

Quentin Lambert (1):
      PCI: Simplify if-return sequences

Thierry Reding (2):
      PCI: tegra: Do not build on 64-bit ARM
      PCI: tegra: Add Kconfig help text

Yijing Wang (3):
      PCI/MSI: Add pci_msi_ignore_mask to prevent writes to MSI/MSI-X Mask Bits
      Revert "PCI: Add x86_msi.msi_mask_irq() and msix_mask_irq()"
      s390/MSI: Use __msi_mask_irq() instead of default_msi_mask_irq()

 Documentation/ABI/testing/sysfs-bus-pci            |  13 ++
 .../devicetree/bindings/pci/layerscape-pci.txt     |  42 +++++
 MAINTAINERS                                        |  10 ++
 arch/s390/pci/pci.c                                |   4 +-
 arch/x86/include/asm/x86_init.h                    |   3 -
 arch/x86/kernel/x86_init.c                         |  10 --
 arch/x86/pci/xen.c                                 |  15 +-
 drivers/pci/host/Kconfig                           |  13 +-
 drivers/pci/host/Makefile                          |   1 +
 drivers/pci/host/pci-dra7xx.c                      |   6 +-
 drivers/pci/host/pci-exynos.c                      |  18 +--
 drivers/pci/host/pci-host-generic.c                | 126 ++++-----------
 drivers/pci/host/pci-imx6.c                        |   4 +-
 drivers/pci/host/pci-keystone-dw.c                 |   2 +-
 drivers/pci/host/pci-keystone.c                    |   5 +-
 drivers/pci/host/pci-layerscape.c                  | 179 +++++++++++++++++++++
 drivers/pci/host/pci-mvebu.c                       |   2 +
 drivers/pci/host/pcie-designware.c                 |   1 +
 drivers/pci/host/pcie-rcar.c                       |   2 +-
 drivers/pci/host/pcie-spear13xx.c                  |  13 +-
 drivers/pci/hotplug/ibmphp_res.c                   |   5 +-
 drivers/pci/iov.c                                  |  11 +-
 drivers/pci/msi.c                                  |  29 ++--
 drivers/pci/pci-acpi.c                             |   3 +-
 drivers/pci/pci-sysfs.c                            |  27 +++-
 drivers/pci/pci.c                                  |  21 +--
 drivers/pci/pci.h                                  |   6 +-
 drivers/pci/probe.c                                |  80 ++++-----
 drivers/pci/search.c                               |   3 +-
 drivers/pci/xen-pcifront.c                         |  13 +-
 include/linux/msi.h                                |   5 +-
 include/linux/pci_hotplug.h                        |   1 -
 32 files changed, 416 insertions(+), 257 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/layerscape-pci.txt
 create mode 100644 drivers/pci/host/pci-layerscape.c
