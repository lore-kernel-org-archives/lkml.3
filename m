Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaJHRUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:20:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44362 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaJHRUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:20:34 -0400
Date: Wed, 8 Oct 2014 11:20:29 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.18
Message-ID: <20141008172029.GA8854@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The interesting things here are:

  - Turn on Config Request Retry Status Software Visibility.  This caused
    hangs last time, but we included a fix this time.
  - Rework PCI device configuration to use _HPP/_HPX more aggressively
  - Allow PCI devices to be put into D3cold during system suspend
  - Add arm64 PCI support
  - Add APM X-Gene host bridge driver
  - Add TI Keystone host bridge driver
  - Add Xilinx AXI host bridge driver

Bjorn


The following changes since commit 6a73336bde293741026614135419e9b76afb9145:

  PCI: Remove "no hotplug settings from platform" warning (2014-09-12 08:50:10 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.18-changes

for you to fetch changes up to f92d9ee3ab39841d1f29f2d1aa96ff7c74b36ee1:

  Merge branch 'pci/host-xgene' into next (2014-10-06 09:59:15 -0600)

----------------------------------------------------------------
PCI changes for the v3.18 merge window:

  Enumeration
    - Check Vendor ID only for Config Request Retry Status (Rajat Jain)
    - Enable Config Request Retry Status when supported (Rajat Jain)
    - Add generic domain handling (Catalin Marinas)
    - Generate uppercase hex for modalias interface class (Ricardo Ribalda Delgado)

  Resource management
    - Add missing MEM_64 mask in pci_assign_unassigned_bridge_resources() (Yinghai Lu)
    - Increase IBM ipr SAS Crocodile BARs to at least system page size (Douglas Lehr)

  PCI device hotplug
    - Prevent NULL dereference during pciehp probe (Andreas Noever)
    - Move _HPP & _HPX handling into core (Bjorn Helgaas)
    - Apply _HPP to PCIe devices as well as PCI (Bjorn Helgaas)
    - Apply _HPP/_HPX to display devices (Bjorn Helgaas)
    - Preserve SERR & PARITY settings when applying _HPP/_HPX (Bjorn Helgaas)
    - Preserve MPS and MRRS settings when applying _HPP/_HPX (Bjorn Helgaas)
    - Apply _HPP/_HPX to all devices, not just hot-added ones (Bjorn Helgaas)
    - Fix wait time in pciehp timeout message (Yinghai Lu)
    - Add more pciehp Slot Control debug output (Yinghai Lu)
    - Stop disabling pciehp notifications during init (Yinghai Lu)

  MSI
    - Remove arch_msi_check_device() (Alexander Gordeev)
    - Rename pci_msi_check_device() to pci_msi_supported() (Alexander Gordeev)
    - Move D0 check into pci_msi_check_device() (Alexander Gordeev)
    - Remove unused kobject from struct msi_desc (Yijing Wang)
    - Remove "pos" from the struct msi_desc msi_attrib (Yijing Wang)
    - Add "msi_bus" sysfs MSI/MSI-X control for endpoints (Yijing Wang)
    - Use __get_cached_msi_msg() instead of get_cached_msi_msg() (Yijing Wang)
    - Use __read_msi_msg() instead of read_msi_msg() (Yijing Wang)
    - Use __write_msi_msg() instead of write_msi_msg() (Yijing Wang)

  Power management
    - Drop unused runtime PM support code for PCIe ports (Rafael J.  Wysocki)
    - Allow PCI devices to be put into D3cold during system suspend (Rafael J. Wysocki)

  AER
    - Add additional AER error strings (Gong Chen)
    - Make <linux/aer.h> standalone includable (Thierry Reding)

  Virtualization
    - Add ACS quirk for Solarflare SFC9120 & SFC9140 (Alex Williamson)
    - Add ACS quirk for Intel 10G NICs (Alex Williamson)
    - Add ACS quirk for AMD A88X southbridge (Marti Raudsepp)
    - Remove unused pci_find_upstream_pcie_bridge(), pci_get_dma_source() (Alex Williamson)
    - Add device flag helpers (Ethan Zhao)
    - Assume all Mellanox devices have broken INTx masking (Gavin Shan)

  Generic host bridge driver
    - Fix ioport_map() for !CONFIG_GENERIC_IOMAP (Liviu Dudau)
    - Add pci_register_io_range() and pci_pio_to_address() (Liviu Dudau)
    - Define PCI_IOBASE as the base of virtual PCI IO space (Liviu Dudau)
    - Fix the conversion of IO ranges into IO resources (Liviu Dudau)
    - Add pci_get_new_domain_nr() and of_get_pci_domain_nr() (Liviu Dudau)
    - Add support for parsing PCI host bridge resources from DT (Liviu Dudau)
    - Add pci_remap_iospace() to map bus I/O resources (Liviu Dudau)
    - Add arm64 architectural support for PCI (Liviu Dudau)

  APM X-Gene
    - Add APM X-Gene PCIe driver (Tanmay Inamdar)
    - Add arm64 DT APM X-Gene PCIe device tree nodes (Tanmay Inamdar)

  Freescale i.MX6
    - Probe in module_init(), not fs_initcall() (Lucas Stach)
    - Delay enabling reference clock for SS until it stabilizes (Tim Harvey)

  Marvell MVEBU
    - Fix uninitialized variable in mvebu_get_tgt_attr() (Thomas Petazzoni)

  NVIDIA Tegra
    - Make sure the PCIe PLL is really reset (Eric Yuen)
    - Add error path tegra_msi_teardown_irq() cleanup (Jisheng Zhang)
    - Fix extended configuration space mapping (Peter Daifuku)
    - Implement resource hierarchy (Thierry Reding)
    - Clear CLKREQ# enable on port disable (Thierry Reding)
    - Add Tegra124 support (Thierry Reding)

  ST Microelectronics SPEAr13xx
    - Pass config resource through reg property (Pratyush Anand)

  Synopsys DesignWare
    - Use NULL instead of false (Fabio Estevam)
    - Parse bus-range property from devicetree (Lucas Stach)
    - Use pci_create_root_bus() instead of pci_scan_root_bus() (Lucas Stach)
    - Remove pci_assign_unassigned_resources() (Lucas Stach)
    - Check private_data validity in single place (Lucas Stach)
    - Setup and clear exactly one MSI at a time (Lucas Stach)
    - Remove open-coded bitmap operations (Lucas Stach)
    - Fix configuration base address when using 'reg' (Minghuan Lian)
    - Fix IO resource end address calculation (Minghuan Lian)
    - Rename get_msi_data() to get_msi_addr() (Minghuan Lian)
    - Add get_msi_data() to pcie_host_ops (Minghuan Lian)
    - Add support for v3.65 hardware (Murali Karicheri)
    - Fold struct pcie_port_info into struct pcie_port (Pratyush Anand)

  TI Keystone
    - Add TI Keystone PCIe driver (Murali Karicheri)
    - Limit MRSS for all downstream devices (Murali Karicheri)
    - Assume controller is already in RC mode (Murali Karicheri)
    - Set device ID based on SoC to support multiple ports (Murali Karicheri)

  Xilinx AXI
    - Add Xilinx AXI PCIe driver (Srikanth Thokala)
    - Fix xilinx_pcie_assign_msi() return value test (Dan Carpenter)

  Miscellaneous
    - Clean up whitespace (Quentin Lambert)
    - Remove assignments from "if" conditions (Quentin Lambert)
    - Move PCI_VENDOR_ID_VMWARE to pci_ids.h (Francesco Ruggeri)
    - x86: Mark DMI tables as initialization data (Mathias Krause)
    - x86: Move __init annotation to the correct place (Mathias Krause)
    - x86: Mark constants of pci_mmcfg_nvidia_mcp55() as __initconst (Mathias Krause)
    - x86: Constify pci_mmcfg_probes[] array (Mathias Krause)
    - x86: Mark PCI BIOS initialization code as such (Mathias Krause)
    - Parenthesize PCI_DEVID and PCI_VPD_LRDT_ID parameters (Megan Kamiya)
    - Remove unnecessary variable in pci_add_dynid() (Tobias Klauser)

----------------------------------------------------------------
Alex Williamson (4):
      PCI: Remove unused pci_find_upstream_pcie_bridge()
      PCI: Remove unused pci_get_dma_source()
      PCI: Add ACS quirk for Solarflare SFC9120 & SFC9140
      PCI: Add ACS quirk for Intel 10G NICs

Alexander Gordeev (5):
      PCI/MSI/PPC: Remove arch_msi_check_device()
      irqchip: armada-370-xp: Remove arch_msi_check_device()
      PCI/MSI: Remove arch_msi_check_device()
      PCI/MSI: Move D0 check into pci_msi_check_device()
      PCI/MSI: Rename pci_msi_check_device() to pci_msi_supported()

Andreas Noever (1):
      PCI: pciehp: Prevent NULL dereference during probe

Bjorn Helgaas (33):
      Merge branch 'pci/host-designware' into pci/host-imx6
      Merge branches 'pci/misc', 'pci/pm', 'pci/host-designware', 'pci/host-imx6', 'pci/host-keystone', 'pci/host-tegra' and 'pci/host-xilinx' into next
      PCI: pciehp: Configure hot-added display devices
      PCI: Move pci_get_hp_params() to drivers/pci/pci-acpi.c
      PCI: Whitespace cleanup in pci-acpi.c
      PCI: Shuffle pci-acpi.c functions to group them logically
      PCI: Move pci_configure_slot() to drivers/pci/probe.c
      PCI: Add pci_configure_device() during enumeration
      PCI: pciehp: Remove pci_configure_slot() usage
      PCI: shpchp: Remove pci_configure_slot() usage
      ACPI / hotplug / PCI: Remove pci_configure_slot() usage
      PCI: Remove unused pci_configure_slot()
      PCI: Apply _HPP settings to PCIe devices as well as PCI and PCI-X
      PCI: Preserve BIOS PCI_COMMAND_SERR and PCI_COMMAND_PARITY settings
      PCI: Apply _HPP settings to all hot-added PCI devices
      PCI: Preserve MPS and MRRS when applying _HPX settings
      PCI: Configure *all* devices, not just hot-added ones
      PCI: pciehp: Reduce PCIe slot_ctrl to 16 bits
      Merge branches 'pci/enumeration', 'pci/misc' and 'pci/virtualization' into next
      Merge branches 'pci/host-designware', 'pci/host-imx6', 'pci/host-keystone', 'pci/host-tegra' and 'pci/host-xilinx' into next
      Merge branch 'pci/hotplug' into next
      Merge branches 'pci/hotplug', 'pci/initdata' and 'pci/misc' into next
      Merge branches 'pci/host-mvebu' and 'pci/host-spear' into next
      Merge branches 'pci/enumeration', 'pci/virtualization' and 'pci/cleanup' into next
      Merge branch 'pci/host-designware' into next
      PCI/MSI: Remove unnecessary temporary variable
      Merge branches 'pci/aer' and 'pci/virtualization' into next
      Merge branch 'pci/host-generic' into next
      Merge branch 'pci/msi' into next
      Merge branch 'pci/resource' into next
      Merge branch 'pci/host-designware' into next
      Merge branch 'pci/virtualization' into next
      Merge branch 'pci/host-xgene' into next

Catalin Marinas (1):
      PCI: Add generic domain handling

Chen, Gong (4):
      trace, RAS: Replace bare numbers with #defines for PCIe AER error strings
      trace, RAS: Add additional PCIe AER error strings
      PCI/AER: Add additional PCIe AER error strings
      PCI/AER: Rename PCI_ERR_UNC_TRAIN to PCI_ERR_UNC_UND

Dan Carpenter (1):
      PCI: xilinx: Fix xilinx_pcie_assign_msi() return value test

Douglas Lehr (1):
      PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size

Eric Yuen (1):
      PCI: tegra: Make sure the PCIe PLL is really reset

Ethan Zhao (4):
      PCI: Add device flag helper functions
      KVM: Use PCI device flag helper functions
      xen/pciback: Use PCI device flag helper functions
      PCI: Use device flag helper functions

Fabio Estevam (1):
      PCI: designware: Use NULL instead of false

Francesco Ruggeri (1):
      PCI: Move PCI_VENDOR_ID_VMWARE to pci_ids.h

Gavin Shan (1):
      PCI: Assume all Mellanox devices have broken INTx masking

Jisheng Zhang (1):
      PCI: tegra: Add missing cleanup in error path and tegra_msi_teardown_irq()

Liviu Dudau (9):
      asm-generic/io.h: Fix ioport_map() for !CONFIG_GENERIC_IOMAP
      of/pci: Add pci_register_io_range() and pci_pio_to_address()
      ARM: Define PCI_IOBASE as the base of virtual PCI IO space
      of/pci: Move of_pci_range_to_resource() to of/address.c
      of/pci: Fix the conversion of IO ranges into IO resources
      of/pci: Add pci_get_new_domain_nr() and of_get_pci_domain_nr()
      of/pci: Add support for parsing PCI host bridge resources from DT
      PCI: Add pci_remap_iospace() to map bus I/O resources
      arm64: Add architectural support for PCI

Lucas Stach (7):
      PCI: designware: Parse bus-range property from devicetree
      PCI: designware: Use pci_create_root_bus() instead of pci_scan_root_bus()
      PCI: designware: Remove pci_assign_unassigned_resources() from dw_pcie_host_init()
      PCI: imx6: Probe in module_init(), not fs_initcall()
      PCI: designware: Check private_data validity in single place
      PCI: designware: Setup and clear exactly one MSI at a time
      PCI: designware: Remove open-coded bitmap operations

Marti Raudsepp (1):
      PCI: Add ACS quirk for AMD A88X southbridge devices

Mathias Krause (5):
      x86/PCI: Mark DMI tables as initialization data
      x86/PCI: Move __init annotation to the correct place
      x86/PCI: Mark constants of pci_mmcfg_nvidia_mcp55() as __initconst
      x86/PCI: Constify pci_mmcfg_probes[] array
      x86/PCI: Mark PCI BIOS initialization code as such

Megan Kamiya (1):
      PCI: Parenthesize PCI_DEVID and PCI_VPD_LRDT_ID parameters

Minghuan Lian (4):
      PCI: designware: Fix configuration base address when using 'reg'
      PCI: designware: Fix IO resource end address calculation
      PCI: designware: Rename get_msi_data() to get_msi_addr()
      PCI: designware: Add get_msi_data() to pcie_host_ops

Murali Karicheri (5):
      PCI: designware: Add support for v3.65 hardware
      PCI: keystone: Add TI Keystone PCIe driver
      PCI: keystone: Limit MRSS for all downstream devices
      PCI: keystone: Assume controller is already in RC mode
      PCI: keystone: Set device ID based on SoC to support multiple ports

Peter Daifuku (1):
      PCI: tegra: Fix extended configuration space mapping

Pratyush Anand (2):
      PCI: designware: Fold struct pcie_port_info into struct pcie_port
      PCI: spear: Pass config resource through reg property

Quentin Lambert (4):
      PCI: Add space before open parenthesis
      PCI: Remove unnecessary curly braces
      PCI: Remove assignment from "if" conditions
      PCI: Remove assignment from complicated "if" conditions

Rafael J. Wysocki (2):
      PCI/PM: Drop unused runtime PM support code for PCIe ports
      PCI/PM: Allow PCI devices to be put into D3cold during system suspend

Rajat Jain (2):
      PCI: Check only the Vendor ID to identify Configuration Request Retry
      PCI: Enable CRS Software Visibility for root port if it is supported

Ricardo Ribalda Delgado (1):
      PCI: Generate uppercase hex for modalias interface class

Srikanth Thokala (1):
      PCI: xilinx: Add Xilinx AXI PCIe Host Bridge IP driver

Tanmay Inamdar (2):
      PCI: xgene: Add APM X-Gene PCIe driver
      arm64: dts: Add APM X-Gene PCIe device tree nodes

Thierry Reding (6):
      resources: Add device-managed request/release_resource()
      PCI: tegra: Implement a proper resource hierarchy
      PCI/AER: Make <linux/aer.h> standalone includable
      PCI/AER: Make <linux/aer.h> standalone includable
      PCI: tegra: Clear CLKREQ# enable on port disable
      PCI: tegra: Add Tegra124 support

Thomas Petazzoni (1):
      PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()

Tim Harvey (1):
      PCI: imx6: Delay enabling reference clock for SS until it stabilizes

Tobias Klauser (1):
      PCI: Remove unnecessary variable in pci_add_dynid()

Yijing Wang (6):
      PCI/MSI: Remove unused kobject from struct msi_desc
      PCI/MSI: Remove "pos" from the struct msi_desc msi_attrib
      PCI/MSI: Add "msi_bus" sysfs MSI/MSI-X control for endpoints
      PCI/MSI: Use __get_cached_msi_msg() instead of get_cached_msi_msg()
      MSI/powerpc: Use __read_msi_msg() instead of read_msi_msg()
      PCI/MSI: Use __write_msi_msg() instead of write_msi_msg()

Yinghai Lu (4):
      PCI: pciehp: Fix wait time in timeout message
      PCI: pciehp: Add more Slot Control debug output
      PCI: pciehp: Stop disabling notifications during init
      PCI: Add missing MEM_64 mask in pci_assign_unassigned_bridge_resources()

 Documentation/ABI/testing/sysfs-bus-pci            |  10 +
 .../devicetree/bindings/pci/designware-pcie.txt    |   3 +
 .../bindings/pci/nvidia,tegra20-pcie.txt           |  25 +-
 .../devicetree/bindings/pci/pci-keystone.txt       |  63 ++
 .../devicetree/bindings/pci/xgene-pci.txt          |  57 ++
 .../devicetree/bindings/pci/xilinx-pcie.txt        |  62 ++
 Documentation/driver-model/devres.txt              |   2 +
 MAINTAINERS                                        |  17 +-
 arch/arm/boot/dts/spear1310.dtsi                   |  18 +-
 arch/arm/boot/dts/spear1340.dtsi                   |   6 +-
 arch/arm/include/asm/io.h                          |   1 +
 arch/arm/mach-integrator/pci_v3.c                  |  23 +-
 arch/arm64/Kconfig                                 |  22 +-
 arch/arm64/boot/dts/apm-mustang.dts                |   8 +
 arch/arm64/boot/dts/apm-storm.dtsi                 | 165 ++++
 arch/arm64/include/asm/Kbuild                      |   1 +
 arch/arm64/include/asm/io.h                        |   3 +-
 arch/arm64/include/asm/pci.h                       |  37 +
 arch/arm64/include/asm/pgtable.h                   |   2 +
 arch/arm64/kernel/Makefile                         |   1 +
 arch/arm64/kernel/pci.c                            |  70 ++
 arch/ia64/kernel/msi_ia64.c                        |   2 +-
 arch/ia64/sn/kernel/msi_sn.c                       |   4 +-
 arch/mips/pci/msi-octeon.c                         |   6 +-
 arch/powerpc/include/asm/machdep.h                 |   2 -
 arch/powerpc/kernel/msi.c                          |  12 +-
 arch/powerpc/platforms/cell/axon_msi.c             |   9 -
 arch/powerpc/platforms/powernv/pci.c               |  19 +-
 arch/powerpc/platforms/pseries/msi.c               |  44 +-
 arch/powerpc/sysdev/fsl_msi.c                      |  12 +-
 arch/powerpc/sysdev/mpic_pasemi_msi.c              |  11 +-
 arch/powerpc/sysdev/mpic_u3msi.c                   |  28 +-
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c              |  18 +-
 arch/powerpc/sysdev/ppc4xx_msi.c                   |  19 +-
 arch/x86/pci/common.c                              |  20 +-
 arch/x86/pci/mmconfig-shared.c                     |  40 +-
 arch/x86/pci/pcbios.c                              |   8 +-
 drivers/gpu/drm/vmwgfx/svga_reg.h                  |   1 -
 drivers/irqchip/irq-armada-370-xp.c                |  14 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |   1 -
 drivers/net/vmxnet3/vmxnet3_int.h                  |   1 -
 drivers/of/address.c                               | 154 ++++
 drivers/of/of_pci.c                                | 142 +++
 drivers/pci/host/Kconfig                           |  28 +
 drivers/pci/host/Makefile                          |   3 +
 drivers/pci/host/pci-imx6.c                        |  51 +-
 drivers/pci/host/pci-keystone-dw.c                 | 516 +++++++++++
 drivers/pci/host/pci-keystone.c                    | 415 +++++++++
 drivers/pci/host/pci-keystone.h                    |  58 ++
 drivers/pci/host/pci-mvebu.c                       |   6 +-
 drivers/pci/host/pci-tegra.c                       | 277 +++++-
 drivers/pci/host/pci-xgene.c                       | 659 ++++++++++++++
 drivers/pci/host/pcie-designware.c                 | 268 +++---
 drivers/pci/host/pcie-designware.h                 |  22 +-
 drivers/pci/host/pcie-rcar.c                       |  21 +-
 drivers/pci/host/pcie-spear13xx.c                  |   2 +-
 drivers/pci/host/pcie-xilinx.c                     | 970 +++++++++++++++++++++
 drivers/pci/hotplug/Makefile                       |   2 +-
 drivers/pci/hotplug/acpi_pcihp.c                   | 254 +-----
 drivers/pci/hotplug/acpiphp_glue.c                 |  11 +-
 drivers/pci/hotplug/acpiphp_ibm.c                  |   2 +-
 drivers/pci/hotplug/cpci_hotplug_core.c            |  13 +-
 drivers/pci/hotplug/cpcihp_generic.c               |  28 +-
 drivers/pci/hotplug/cpcihp_zt5550.c                |  44 +-
 drivers/pci/hotplug/cpqphp.h                       |   2 +-
 drivers/pci/hotplug/cpqphp_core.c                  |   3 +-
 drivers/pci/hotplug/cpqphp_ctrl.c                  |  19 +-
 drivers/pci/hotplug/cpqphp_nvram.c                 |  13 +-
 drivers/pci/hotplug/ibmphp_core.c                  |  19 +-
 drivers/pci/hotplug/ibmphp_ebda.c                  |   3 +-
 drivers/pci/hotplug/ibmphp_hpc.c                   |   3 +-
 drivers/pci/hotplug/ibmphp_pci.c                   |   6 +-
 drivers/pci/hotplug/ibmphp_res.c                   |  45 +-
 drivers/pci/hotplug/pciehp.h                       |   2 +-
 drivers/pci/hotplug/pciehp_core.c                  |   7 +
 drivers/pci/hotplug/pciehp_hpc.c                   |  17 +-
 drivers/pci/hotplug/pciehp_pci.c                   |   9 +-
 drivers/pci/hotplug/pcihp_slot.c                   | 176 ----
 drivers/pci/hotplug/shpchp_ctrl.c                  |  14 +-
 drivers/pci/hotplug/shpchp_hpc.c                   |   5 +-
 drivers/pci/hotplug/shpchp_pci.c                   |   8 +-
 drivers/pci/iov.c                                  |   2 +-
 drivers/pci/msi.c                                  |  75 +-
 drivers/pci/pci-acpi.c                             | 276 +++++-
 drivers/pci/pci-driver.c                           |   5 +-
 drivers/pci/pci-sysfs.c                            |  41 +-
 drivers/pci/pci.c                                  |  57 +-
 drivers/pci/pcie/aer/aerdrv_errprint.c             |  11 +-
 drivers/pci/pcie/portdrv_pci.c                     |  74 --
 drivers/pci/probe.c                                | 167 +++-
 drivers/pci/quirks.c                               | 119 +--
 drivers/pci/search.c                               |  34 -
 drivers/pci/setup-bus.c                            |   2 +-
 drivers/scsi/vmw_pvscsi.h                          |   1 -
 drivers/vfio/pci/vfio_pci_config.c                 |   2 +-
 drivers/xen/xen-pciback/pci_stub.c                 |   4 +-
 include/asm-generic/io.h                           |   2 +-
 include/asm-generic/pgtable.h                      |   4 +
 include/linux/aer.h                                |   2 +
 include/linux/ioport.h                             |   5 +
 include/linux/msi.h                                |   6 -
 include/linux/of_address.h                         |  27 +-
 include/linux/of_pci.h                             |  13 +
 include/linux/pci.h                                |  60 +-
 include/linux/pci_hotplug.h                        |   2 -
 include/linux/pci_ids.h                            |   2 +
 include/ras/ras_event.h                            |  48 +-
 include/uapi/linux/pci_regs.h                      |   3 +-
 kernel/resource.c                                  |  70 ++
 virt/kvm/assigned-dev.c                            |   2 +-
 virt/kvm/iommu.c                                   |   4 +-
 111 files changed, 4950 insertions(+), 1334 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
 create mode 100644 Documentation/devicetree/bindings/pci/xgene-pci.txt
 create mode 100644 Documentation/devicetree/bindings/pci/xilinx-pcie.txt
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/pci.c
 create mode 100644 drivers/pci/host/pci-keystone-dw.c
 create mode 100644 drivers/pci/host/pci-keystone.c
 create mode 100644 drivers/pci/host/pci-keystone.h
 create mode 100644 drivers/pci/host/pci-xgene.c
 create mode 100644 drivers/pci/host/pcie-xilinx.c
 delete mode 100644 drivers/pci/hotplug/pcihp_slot.c
