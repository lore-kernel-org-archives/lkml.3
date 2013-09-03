Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253Ab3ICRy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:54:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56312 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3ICRyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:54:55 -0400
Date: Tue, 3 Sep 2013 11:54:51 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.12
Message-ID: <20130903175451.GA22414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.12-changes

for you to fetch changes up to e89c33168aad32436da842ddda307dcc31c0c4e2:

  Merge branch 'pci/misc' into next (2013-08-29 17:23:33 -0600)

----------------------------------------------------------------

PCI changes for the v3.12 merge window:

  PCI device hotplug
    - Use PCIe native hotplug, not ACPI hotplug, when possible (Neil Horman)
    - Assign resources on per-host bridge basis (Yinghai Lu)

  MPS (Max Payload Size)
    - Allow larger MPS settings below hotplug-capable Root Port (Yijing Wang)
    - Add warnings about unsafe MPS settings (Yijing Wang)
    - Simplify interface and messages (Bjorn Helgaas)

  SR-IOV
    - Return -ENOSYS on non-SR-IOV devices (Stefan Assmann)
    - Update NumVFs register when disabling SR-IOV (Yijing Wang)

  Virtualization
    - Add bus and slot reset support (Alex Williamson)
    - Fix ACS (Access Control Services) issues (Alex Williamson)

  Miscellaneous
    - Simplify PCIe Capability accessors (Bjorn Helgaas)
    - Add pcibios_pm_ops for arch-specific hibernate stuff (Sebastian Ott)
    - Disable decoding during BAR sizing only when necessary (Zoltan Kiss)
    - Delay enabling bridges until they're needed (Yinghai Lu)
    - Split Designware support into Synopsys and Exynos parts (Jingoo Han)
    - Convert class code to use dev_groups (Greg Kroah-Hartman)
    - Cleanup Designware and Exynos I/O access wrappers (Seungwon Jeon)
    - Fix bridge I/O window alignment (Bjorn Helgaas)
    - Add pci_wait_for_pending_transaction() (Casey Leedom)
    - Use devm_ioremap_resource() in Marvell driver (Tushar Behera)

----------------------------------------------------------------
Alex Williamson (13):
      PCI: Check all ACS features for multifunction downstream ports
      PCI: Differentiate ACS controllable from enabled
      PCI: Claim ACS support for AMD southbridge devices
      PCI: Add pci_reset_bridge_secondary_bus()
      PCI: Add hotplug_slot_ops.reset_slot()
      PCI: pciehp: Add reset_slot() method
      PCI: Add slot reset option to pci_dev_reset()
      PCI: Split out pci_dev lock/unlock and save/restore
      PCI: Add pci_reset_slot() and pci_reset_bus()
      PCI: Wake-up devices before saving config space for reset
      PCI: Tune secondary bus reset timing
      PCI: Remove aer_do_secondary_bus_reset()
      PCI: Add pci_probe_reset_slot() and pci_probe_reset_bus()

Bjorn Helgaas (25):
      frv/PCI: Mark pcibios_fixup_bus() as non-init
      Merge branch 'pci/aw-acs-fixes-v2' into next
      Merge branch 'pci/misc' into next
      PCI: Align bridge I/O windows as required by downstream devices & bridges
      Merge branch 'pci/wei-resource-cleanups' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/vipul-chelsio-reset-v2' into next
      Merge branch 'pci/aw-reset-v5' into next
      PCI: Drop "PCI-E" prefix from Max Payload Size message
      PCI: Simplify pcie_bus_configure_settings() interface
      PCI: Simplify MPS test for Downstream Port
      PCI: Add comment about needing pci_msi_off() even when CONFIG_PCI_MSI=n
      Merge branch 'pci/yinghai-assign-unassigned-v6' into next
      Merge branch 'pci/yijing-mps-v8' into next
      PCI: Rename PCIe capability definitions to follow convention
      PCI: Clarify PCI_EXP_TYPE_PCI_BRIDGE comment
      PCI: Remove obsolete comment reference to pci_pcie_cap2()
      PCI: Tidy bitmasks and spacing of PCIe capability definitions
      PCI: Add offsets of PCIe capability registers
      PCI: Allow PCIe Capability link-related register access for switches
      PCI: Remove PCIe Capability version checks
      PCI: Support PCIe Capability Slot registers only for ports with slots
      PCI: Remove pcie_cap_has_devctl()
      Merge branch 'pci/misc' into next
      Merge branch 'pci/misc' into next

Casey Leedom (4):
      PCI: Add pci_wait_for_pending_transaction()
      PCI: Chelsio quirk: Enable Bus Master during Function-Level Reset
      bnx2x: Use pci_wait_for_pending_transaction() instead of for loop
      PCI: Use pci_wait_for_pending_transaction() instead of for loop

Ezequiel Garcia (1):
      PCI: Rename "PCI Express support" kconfig title

Greg Kroah-Hartman (1):
      PCI: Convert class code to use dev_groups

Jingoo Han (1):
      PCI: exynos: Split into Synopsys part and Exynos part

Jon Mason (1):
      PCI: Fix MPS peer-to-peer DMA comment syntax

Jonghwan Choi (1):
      PCI: Fix comment typo in iov.c

Neil Horman (1):
      PCI/ACPI: Fix _OSC ordering to allow PCIe hotplug use when available

Sebastian Ott (1):
      PCI: Add pcibios_pm_ops for optional arch-specific hibernate functionality

Seungwon Jeon (2):
      PCI: designware: Drop "addr" arg from dw_pcie_readl_rc()/dw_pcie_writel_rc()
      PCI: exynos: Add I/O access wrappers

Stefan Assmann (1):
      PCI: Return -ENOSYS for SR-IOV operations on non-SR-IOV devices

Thomas Petazzoni (1):
      PCI: mvebu: Make Marvell PCIe driver depend on OF

Tushar Behera (1):
      PCI: mvebu: Convert to use devm_ioremap_resource

Valentina Manea (1):
      x86/pci/mrst: Cleanup checkpatch.pl warnings

Wei Yang (3):
      PCI: Enumerate subordinate buses, not devices, in pci_bus_get_depth()
      PCI: Add comments for pbus_size_mem() parameters
      PCI: Fix types in pbus_size_io()

Yijing Wang (5):
      PCI: Update NumVFs register when disabling SR-IOV
      PCI: Fix comment typo for pci_add_cap_save_buffer()
      PCI: Remove unnecessary check for pcie_get_mps() failure
      PCI: Don't restrict MPS for slots below Root Ports
      PCI: Warn if unsafe MPS settings detected

Yinghai Lu (8):
      PCI: Drop temporary variable in pci_assign_unassigned_resources()
      PCI: Look for unassigned resources on per-bus basis
      PCI: Turn on reallocation for unassigned resources with host bridge offset
      PCI: Enable unassigned resource reallocation on per-bus basis
      PCI: Assign resources on a per-bus basis
      PCI: Delay enabling bridges until they're needed
      PCI: Move resource reallocation code to non-__init
      PCI: Assign resources for hot-added host bridge more aggressively

Zoltan Kiss (1):
      PCI: Disable decoding for BAR sizing only when it was actually enabled

ethan.zhao (1):
      x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at address zero

 .../devicetree/bindings/pci/designware-pcie.txt    |    3 +
 arch/arm/boot/dts/exynos5440.dtsi                  |    2 +
 arch/arm/kernel/bios32.c                           |    5 -
 arch/frv/mb93090-mb00/pci-vdk.c                    |    2 +-
 arch/m68k/platform/coldfire/pci.c                  |    1 -
 arch/mips/pci/pci.c                                |    1 -
 arch/powerpc/kernel/pci-common.c                   |    8 +-
 arch/sh/drivers/pci/pci.c                          |    1 -
 arch/tile/kernel/pci_gx.c                          |    9 +-
 arch/x86/pci/acpi.c                                |    9 +-
 arch/x86/pci/mmconfig-shared.c                     |    7 +-
 arch/x86/pci/mrst.c                                |   41 +-
 drivers/acpi/pci_root.c                            |   67 +-
 drivers/mfd/rts5227.c                              |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   18 +-
 drivers/parisc/lba_pci.c                           |    1 -
 drivers/pci/access.c                               |   26 +-
 drivers/pci/bus.c                                  |   19 -
 drivers/pci/host/Kconfig                           |    1 +
 drivers/pci/host/Makefile                          |    3 +-
 drivers/pci/host/pci-exynos.c                      |  552 +++++++++++
 drivers/pci/host/pci-mvebu.c                       |    7 +-
 drivers/pci/host/pcie-designware.c                 | 1044 ++++++--------------
 drivers/pci/host/pcie-designware.h                 |   65 ++
 drivers/pci/hotplug/acpiphp_glue.c                 |    1 -
 drivers/pci/hotplug/pciehp.h                       |    1 +
 drivers/pci/hotplug/pciehp_core.c                  |   12 +
 drivers/pci/hotplug/pciehp_hpc.c                   |   31 +
 drivers/pci/hotplug/pcihp_slot.c                   |    5 +-
 drivers/pci/iov.c                                  |   23 +-
 drivers/pci/pci-driver.c                           |   43 +
 drivers/pci/pci-sysfs.c                            |   32 +-
 drivers/pci/pci.c                                  |  573 +++++++++--
 drivers/pci/pci.h                                  |    2 +-
 drivers/pci/pcie/Kconfig                           |    2 +-
 drivers/pci/pcie/aer/aerdrv.c                      |    2 +-
 drivers/pci/pcie/aer/aerdrv.h                      |    1 -
 drivers/pci/pcie/aer/aerdrv_core.c                 |   35 +-
 drivers/pci/probe.c                                |   80 +-
 drivers/pci/quirks.c                               |  147 ++-
 drivers/pci/setup-bus.c                            |  176 ++--
 drivers/pcmcia/cardbus.c                           |    1 -
 include/linux/pci.h                                |   14 +-
 include/linux/pci_hotplug.h                        |    4 +
 include/uapi/linux/pci_regs.h                      |  113 ++-
 45 files changed, 1960 insertions(+), 1232 deletions(-)
 create mode 100644 drivers/pci/host/pci-exynos.c
 create mode 100644 drivers/pci/host/pcie-designware.h
