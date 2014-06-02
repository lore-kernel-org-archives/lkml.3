Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaFBTHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:07:35 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33804 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaFBTHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:07:32 -0400
Date: Mon, 2 Jun 2014 13:07:28 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.16
Message-ID: <20140602190728.GA2436@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The most notable pieces here are

  - Supporting BARs up to 8GB for Xeon Phi, etc
  - Restricting 64-bit prefetchable bridge windows to 64-bit resources to
    make SR-IOV devices with large MMIO requirements work
  - More control over driver binding for virtualization
  - New generic DT and R-Car PCIe host bridge drivers
  - Updates to i.MX6, R-Car, Exynos, DesignWare host bridge drivers


The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci-v3.16-changes

for you to fetch changes up to 617b4157a5c82ab3e9509aa388bfd3d47e0e623a:

  Merge branches 'pci/host-exynos', 'pci/host-imx6', 'pci/resource' and 'pci/misc' into next (2014-05-30 11:41:17 -0600)

----------------------------------------------------------------

PCI changes for the v3.16 merge window:

  Enumeration
    - Notify driver before and after device reset (Keith Busch)
    - Use reset notification in NVMe (Keith Busch)

  NUMA
    - Warn if we have to guess host bridge node information (Myron Stowe)
    - Work around AMD Fam15h BIOSes that fail to provide _PXM (Suravee Suthikulpanit)
    - Clean up and mark early_root_info_init() as deprecated (Suravee Suthikulpanit)

  Driver binding
    - Add "driver_override" for force specific binding (Alex Williamson)
    - Fail "new_id" addition for devices we already know about (Bandan Das)

  Resource management
    - Support BAR sizes up to 8GB (Nikhil Rao, Alan Cox)
    - Don't move IORESOURCE_PCI_FIXED resources (Bjorn Helgaas)
    - Mark SBx00 HPET BAR as IORESOURCE_PCI_FIXED (Bjorn Helgaas)
    - Fail safely if we can't handle BARs larger than 4GB (Bjorn Helgaas)
    - Reject BAR above 4GB if dma_addr_t is too small (Bjorn Helgaas)
    - Don't convert BAR address to resource if dma_addr_t is too small (Bjorn Helgaas)
    - Don't set BAR to zero if dma_addr_t is too small (Bjorn Helgaas)
    - Don't print anything while decoding is disabled (Bjorn Helgaas)
    - Don't add disabled subtractive decode bus resources (Bjorn Helgaas)
    - Add resource allocation comments (Bjorn Helgaas)
    - Restrict 64-bit prefetchable bridge windows to 64-bit resources (Yinghai Lu)
    - Assign i82875p_edac PCI resources before adding device (Yinghai Lu)

  PCI device hotplug
    - Remove unnecessary "dev->bus" test (Bjorn Helgaas)
    - Use PCI_EXP_SLTCAP_PSN define (Bjorn Helgaas)
    - Fix rphahp endianess issues (Laurent Dufour)
    - Acknowledge spurious "cmd completed" event (Rajat Jain)
    - Allow hotplug service drivers to operate in polling mode (Rajat Jain)
    - Fix cpqphp possible NULL dereference (Rickard Strandqvist)

  MSI
    - Replace pci_enable_msi_block() by pci_enable_msi_exact() (Alexander Gordeev)
    - Replace pci_enable_msix() by pci_enable_msix_exact() (Alexander Gordeev)
    - Simplify populate_msi_sysfs() (Jan Beulich)

  Virtualization
    - Add Intel Patsburg (X79) root port ACS quirk (Alex Williamson)
    - Mark RTL8110SC INTx masking as broken (Alex Williamson)

  Generic host bridge driver
    - Add generic PCI host controller driver (Will Deacon)

  Freescale i.MX6
    - Use new clock names (Lucas Stach)
    - Drop old IRQ mapping (Lucas Stach)
    - Remove optional (and unused) IRQs (Lucas Stach)
    - Add support for MSI (Lucas Stach)
    - Fix imx6_add_pcie_port() section mismatch warning (Sachin Kamat)

  Renesas R-Car
    - Add gen2 device tree support (Ben Dooks)
    - Use new OF interrupt mapping when possible (Lucas Stach)
    - Add PCIe driver (Phil Edworthy)
    - Add PCIe MSI support (Phil Edworthy)
    - Add PCIe device tree bindings (Phil Edworthy)

  Samsung Exynos
    - Remove unnecessary OOM messages (Jingoo Han)
    - Fix add_pcie_port() section mismatch warning (Sachin Kamat)

  Synopsys DesignWare
    - Make MSI ISR shared IRQ aware (Lucas Stach)

  Miscellaneous
    - Check for broken config space aliasing (Alex Williamson)
    - Update email address (Ben Hutchings)
    - Fix Broadcom CNB20LE unintended sign extension (Bjorn Helgaas)
    - Fix incorrect vgaarb conditional in WARN_ON() (Bjorn Helgaas)
    - Remove unnecessary __ref annotations (Bjorn Helgaas)
    - Add arch/x86/kernel/quirks.c to MAINTAINERS PCI file patterns (Bjorn Helgaas)
    - Fix use of uninitialized MPS value (Bjorn Helgaas)
    - Tidy x86/gart messages (Bjorn Helgaas)
    - Fix return value from pci_user_{read,write}_config_*() (Gavin Shan)
    - Turn pcibios_penalize_isa_irq() into a weak function (Hanjun Guo)
    - Remove unused serial device IDs (Jean Delvare)
    - Use designated initialization in PCI_VDEVICE (Mark Rustad)
    - Fix powerpc NULL dereference in pci_root_buses traversal (Mike Qiu)
    - Configure MPS on ARM (Murali Karicheri)
    - Remove unnecessary includes of <linux/init.h> (Paul Gortmaker)
    - Move Open Firmware devspec attribute to PCI common code (Sebastian Ott)
    - Use pdev->dev.groups for attribute creation on s390 (Sebastian Ott)
    - Remove pcibios_add_platform_entries() (Sebastian Ott)
    - Add new ID for Intel GPU "spurious interrupt" quirk (Thomas Jarosch)
    - Rename pci_is_bridge() to pci_has_subordinate() (Yijing Wang)
    - Add and use new pci_is_bridge() interface (Yijing Wang)
    - Make pci_bus_add_device() void (Yijing Wang)

  DMA API
    - Clarify physical/bus address distinction in docs (Bjorn Helgaas)
    - Fix typos in docs (Emilio López)
    - Update dma_pool_create ()and dma_pool_alloc() descriptions (Gioh Kim)
    - Change dma_declare_coherent_memory() CPU address to phys_addr_t (Bjorn Helgaas)
    - Pass GAPSPCI_DMA_BASE CPU & bus address to dma_declare_coherent_memory() (Bjorn Helgaas)

----------------------------------------------------------------
Alan (1):
      PCI: Support BAR sizes up to 8GB

Alex Williamson (4):
      PCI: Add Patsburg (X79) to Intel PCH root port ACS quirk
      PCI: Mark RTL8110SC INTx masking as broken
      PCI: Test for std config alias when testing extended config space
      PCI: Introduce new device binding path using pci_dev.driver_override

Alexander Gordeev (3):
      PCI/portdrv: Use pci_enable_msix_exact() instead of pci_enable_msix()
      GenWQE: Use pci_enable_msi_exact() instead of pci_enable_msi_block()
      PCI/MSI: Remove pci_enable_msi_block()

Bandan Das (1):
      PCI: Fail new_id for vendor/device values already built into driver

Ben Dooks (1):
      PCI: rcar: Add gen2 device tree support

Ben Hutchings (1):
      PCI: Update my email address

Bjorn Helgaas (35):
      PCI: hotplug: Remove unnecessary "dev->bus" test
      PCI: pciehp: Use PCI_EXP_SLTCAP_PSN define
      x86/PCI: Fix Broadcom CNB20LE unintended sign extension
      x86/PCI: Don't try to move IORESOURCE_PCI_FIXED resources
      x86/PCI: Mark ATI SBx00 HPET BAR as IORESOURCE_PCI_FIXED
      PCI: Fix incorrect vgaarb conditional in WARN_ON()
      PCI: Remove unnecessary __ref annotations
      MAINTAINERS: Add arch/x86/kernel/quirks.c to PCI file patterns
      PCI: Remove dead code
      PCI: Fix use of uninitialized MPS value
      Merge branches 'pci/hotplug', 'pci/msi', 'pci/virtualization' and 'pci/misc' into next
      DMA-API: Clarify physical/bus address distinction
      DMA-API: Change dma_declare_coherent_memory() CPU address to phys_addr_t
      sh/PCI: Pass GAPSPCI_DMA_BASE CPU & bus address to dma_declare_coherent_memory()
      x86/PCI: Move pcibios_assign_resources() annotation to definition
      x86/gart: Replace printk() with pr_info()
      x86/gart: Tidy messages and add bridge device info
      PCI: Fail safely if we can't handle BARs larger than 4GB
      PCI: Reject BAR above 4GB if dma_addr_t is too small
      PCI: Don't convert BAR address to resource if dma_addr_t is too small
      PCI: Don't set BAR to zero if dma_addr_t is too small
      PCI: Don't print anything while decoding is disabled
      PCI: Don't add disabled subtractive decode bus resources
      resources: Clarify sanity check message
      PCI: Change pbus_size_mem() return values to be more conventional
      PCI: Simplify __pci_assign_resource() coding style
      PCI: Add resource allocation comments
      DMA-API: Capitalize "CPU" consistently
      iommu/exynos: Remove unnecessary "&" from function pointers
      Merge branches 'dma-api', 'pci/virtualization', 'pci/msi', 'pci/misc' and 'pci/resource' into next
      Merge branches 'pci/host-exynos', 'pci/host-rcar' and 'pci/amd-numa' into next
      Merge branches 'pci/hotplug', 'pci/pci_is_bridge' and 'pci/virtualization' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/host-generic' into next
      Merge branches 'pci/host-exynos', 'pci/host-imx6', 'pci/resource' and 'pci/misc' into next

Emilio López (1):
      DMA-API: Fix duplicated word in DMA-API-HOWTO.txt

Gavin Shan (1):
      PCI: Fix return value from pci_user_{read,write}_config_*()

Gioh Kim (1):
      DMA-API: Update dma_pool_create ()and dma_pool_alloc() descriptions

Hanjun Guo (1):
      PCI: Turn pcibios_penalize_isa_irq() into a weak function

Jan Beulich (1):
      PCI/MSI: Simplify populate_msi_sysfs()

Jean Delvare (1):
      PCI: Remove old serial device IDs

Jingoo Han (1):
      PCI: exynos: Remove unnecessary OOM messages

Keith Busch (2):
      PCI: Notify driver before and after device reset
      NVMe: Implement PCIe reset notification callback

Laurent Dufour (1):
      PCI: rphahp: Fix endianess issues

Lucas Stach (6):
      PCI: rcar: Use new OF interrupt mapping when possible
      PCI: imx6: Use new clock names
      PCI: imx6: Drop old IRQ mapping
      PCI: imx6: Remove optional (and unused) IRQs
      PCI: designware: Make MSI ISR shared IRQ aware
      PCI: imx6: Add support for MSI

Mark Rustad (1):
      PCI: Use designated initialization in PCI_VDEVICE

Mike Qiu (1):
      powerpc/PCI: Fix NULL dereference in sys_pciconfig_iobase() list traversal

Murali Karicheri (1):
      ARM/PCI: Call pcie_bus_configure_settings() to set MPS

Myron Stowe (1):
      x86/PCI: Warn if we have to "guess" host bridge node information

Paul Gortmaker (1):
      PCI: Remove unnecessary includes of <linux/init.h>

Phil Edworthy (3):
      PCI: rcar: Add Renesas R-Car PCIe driver
      PCI: rcar: Add MSI support for PCIe
      PCI: rcar: Add R-Car PCIe device tree bindings

Rajat Jain (2):
      PCI: pciehp: Acknowledge spurious "cmd completed" event
      PCI: Allow hotplug service drivers to operate in polling mode

Rickard Strandqvist (1):
      PCI: cpqphp: Fix possible null pointer dereference

Sachin Kamat (2):
      PCI: exynos: Fix add_pcie_port() section mismatch warning
      PCI: imx6: Fix imx6_add_pcie_port() section mismatch warning

Sebastian Ott (3):
      PCI: Move Open Firmware devspec attribute to PCI common code
      s390/pci: use pdev->dev.groups for attribute creation
      PCI: Remove pcibios_add_platform_entries()

Suravee Suthikulpanit (2):
      x86/PCI: Work around AMD Fam15h BIOSes that fail to provide _PXM
      x86/PCI: Clean up and mark early_root_info_init() as deprecated

Thomas Jarosch (1):
      PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Will Deacon (2):
      PCI: generic: Add generic PCI host controller driver
      MAINTAINERS: Add generic PCI host controller driver

Yijing Wang (14):
      PCI: Rename pci_is_bridge() to pci_has_subordinate()
      PCI: Add new pci_is_bridge() interface
      PCI: Use pci_is_bridge() to simplify code
      x86/PCI: Use pci_is_bridge() to simplify code
      ia64/PCI: Use pci_is_bridge() to simplify code
      powerpc/PCI: Use pci_is_bridge() to simplify code
      sparc/PCI: Use pci_is_bridge() to simplify code
      PCI: rpaphp: Use pci_is_bridge() to simplify code
      PCI: shpchp: Use pci_is_bridge() to simplify code
      PCI: cpcihp: Use pci_is_bridge() to simplify code
      PCI: acpiphp: Use pci_is_bridge() to simplify code
      PCI: pciehp: Use pci_is_bridge() to simplify code
      pcmcia: Use pci_is_bridge() to simplify code
      PCI: Make pci_bus_add_device() void

Yinghai Lu (2):
      PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources
      i82875p_edac: Assign PCI resources before adding device

 Documentation/ABI/testing/sysfs-bus-pci            |   23 +-
 Documentation/DMA-API-HOWTO.txt                    |  210 ++--
 Documentation/DMA-API.txt                          |  150 +--
 Documentation/DMA-ISA-LPC.txt                      |    4 +-
 .../devicetree/bindings/pci/host-generic-pci.txt   |  100 ++
 .../devicetree/bindings/pci/pci-rcar-gen2.txt      |   66 ++
 Documentation/devicetree/bindings/pci/rcar-pci.txt |   47 +
 MAINTAINERS                                        |    9 +
 arch/alpha/include/asm/pci.h                       |    5 -
 arch/arm/include/asm/pci.h                         |    5 -
 arch/arm/kernel/bios32.c                           |   12 +
 arch/blackfin/include/asm/pci.h                    |    5 -
 arch/cris/include/asm/pci.h                        |    1 -
 arch/frv/include/asm/pci.h                         |    2 -
 arch/frv/mb93090-mb00/pci-irq.c                    |    4 -
 arch/ia64/include/asm/pci.h                        |    6 -
 arch/ia64/pci/fixup.c                              |    4 +-
 arch/microblaze/include/asm/pci.h                  |    5 -
 arch/microblaze/pci/pci-common.c                   |   20 -
 arch/mips/include/asm/pci.h                        |    5 -
 arch/mn10300/include/asm/pci.h                     |    1 -
 arch/mn10300/unit-asb2305/pci-irq.c                |    4 -
 arch/parisc/include/asm/pci.h                      |    5 -
 arch/powerpc/include/asm/pci.h                     |    5 -
 arch/powerpc/kernel/pci-common.c                   |   20 -
 arch/powerpc/kernel/pci-hotplug.c                  |    3 +-
 arch/powerpc/kernel/pci_64.c                       |   10 +-
 arch/powerpc/kernel/pci_of_scan.c                  |    3 +-
 arch/s390/include/asm/pci.h                        |    6 +-
 arch/s390/pci/pci.c                                |    6 +-
 arch/s390/pci/pci_sysfs.c                          |   44 +-
 arch/sh/drivers/pci/fixups-dreamcast.c             |   18 +-
 arch/sh/include/asm/pci.h                          |    5 -
 arch/sparc/include/asm/pci_32.h                    |    5 -
 arch/sparc/include/asm/pci_64.h                    |    5 -
 arch/sparc/kernel/pci.c                            |    3 +-
 arch/unicore32/include/asm/pci.h                   |    5 -
 arch/x86/include/asm/pci.h                         |    1 -
 arch/x86/kernel/aperture_64.c                      |   59 +-
 arch/x86/pci/acpi.c                                |    6 +-
 arch/x86/pci/amd_bus.c                             |   83 +-
 arch/x86/pci/broadcom_bus.c                        |    4 +-
 arch/x86/pci/fixup.c                               |   18 +-
 arch/x86/pci/i386.c                                |   27 +-
 arch/xtensa/include/asm/pci.h                      |    5 -
 drivers/base/dma-coherent.c                        |   10 +-
 drivers/base/dma-mapping.c                         |    6 +-
 drivers/block/nvme-core.c                          |   11 +
 drivers/edac/i82875p_edac.c                        |    8 +-
 drivers/iommu/exynos-iommu.c                       |   14 +-
 drivers/misc/genwqe/card_utils.c                   |    2 +-
 drivers/pci/access.c                               |   12 +-
 drivers/pci/bus.c                                  |   11 +-
 drivers/pci/host-bridge.c                          |    1 -
 drivers/pci/host/Kconfig                           |   13 +
 drivers/pci/host/Makefile                          |    2 +
 drivers/pci/host/pci-exynos.c                      |   11 +-
 drivers/pci/host/pci-host-generic.c                |  388 ++++++++
 drivers/pci/host/pci-imx6.c                        |  147 ++-
 drivers/pci/host/pci-rcar-gen2.c                   |   39 +-
 drivers/pci/host/pcie-designware.c                 |    6 +-
 drivers/pci/host/pcie-designware.h                 |    2 +-
 drivers/pci/host/pcie-rcar.c                       | 1008 ++++++++++++++++++++
 drivers/pci/hotplug-pci.c                          |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |    6 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c             |    5 +-
 drivers/pci/hotplug/cpqphp_ctrl.c                  |    3 +-
 drivers/pci/hotplug/cpqphp_nvram.c                 |    1 -
 drivers/pci/hotplug/pciehp.h                       |    2 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |    2 +
 drivers/pci/hotplug/pciehp_pci.c                   |    3 +-
 drivers/pci/hotplug/pcihp_slot.c                   |    3 +-
 drivers/pci/hotplug/rpadlpar_core.c                |    3 +-
 drivers/pci/hotplug/rpaphp_core.c                  |   15 +-
 drivers/pci/hotplug/s390_pci_hpc.c                 |    1 -
 drivers/pci/hotplug/shpchp_pci.c                   |    5 +-
 drivers/pci/iov.c                                  |    2 +-
 drivers/pci/msi.c                                  |   96 +-
 drivers/pci/pci-acpi.c                             |    8 +-
 drivers/pci/pci-driver.c                           |   58 +-
 drivers/pci/pci-sysfs.c                            |   68 +-
 drivers/pci/pci.c                                  |   34 +-
 drivers/pci/pci.h                                  |   10 +-
 drivers/pci/pcie/portdrv_core.c                    |    9 +-
 drivers/pci/probe.c                                |  101 +-
 drivers/pci/quirks.c                               |   11 +
 drivers/pci/search.c                               |    1 -
 drivers/pci/setup-bus.c                            |  251 +++--
 drivers/pci/setup-irq.c                            |    1 -
 drivers/pci/setup-res.c                            |   42 +-
 drivers/pcmcia/cardbus.c                           |    3 +-
 drivers/platform/x86/asus-wmi.c                    |    3 +-
 drivers/platform/x86/eeepc-laptop.c                |    3 +-
 include/asm-generic/dma-coherent.h                 |   13 +-
 include/linux/dma-mapping.h                        |   13 +-
 include/linux/pci.h                                |   40 +-
 include/linux/pci_ids.h                            |    3 -
 include/linux/types.h                              |    1 +
 kernel/resource.c                                  |    7 +-
 99 files changed, 2724 insertions(+), 830 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/host-generic-pci.txt
 create mode 100644 Documentation/devicetree/bindings/pci/pci-rcar-gen2.txt
 create mode 100644 Documentation/devicetree/bindings/pci/rcar-pci.txt
 create mode 100644 drivers/pci/host/pci-host-generic.c
 create mode 100644 drivers/pci/host/pcie-rcar.c
