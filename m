Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab3BWVVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 16:21:24 -0500
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62104 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3BWVVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 16:21:21 -0500
Date: Sat, 23 Feb 2013 14:21:20 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] PCI changes for v3.9
Message-ID: <20130223212120.GA4593@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.9-changes

for you to fetch changes up to 018ba0a6efada61b9bc17500101d81c3d35807c2:

  Merge branch 'pci/yinghai-root-bus-hotplug' into next (2013-02-19 11:42:17 -0700)

----------------------------------------------------------------

PCI changes for the v3.9 merge window:

  Host bridge hotplug
    - Major overhaul of ACPI host bridge add/start (Rafael Wysocki, Yinghai Lu)
    - Major overhaul of PCI/ACPI binding (Rafael Wysocki, Yinghai Lu)
    - Split out ACPI host bridge and ACPI PCI device hotplug (Yinghai Lu)
    - Stop caching _PRT and make independent of bus numbers (Yinghai Lu)

  PCI device hotplug
    - Clean up cpqphp dead code (Sasha Levin)
    - Disable ARI unless device and upstream bridge support it (Yijing Wang)
    - Initialize all hot-added devices (not functions 0-7) (Yijing Wang)

  Power management
    - Don't touch ASPM if disabled (Joe Lawrence)
    - Fix ASPM link state management (Myron Stowe)

  Miscellaneous
    - Fix PCI_EXP_FLAGS accessor (Alex Williamson)
    - Disable Bus Master in pci_device_shutdown (Konstantin Khlebnikov)
    - Document hotplug resource and MPS parameters (Yijing Wang)
    - Add accessor for PCIe capabilities (Myron Stowe)
    - Drop pciehp suspend/resume messages (Paul Bolle)
    - Make pci_slot built-in only (not a module) (Jiang Liu)
    - Remove unused PCI/ACPI bind ops (Jiang Liu)
    - Removed used pci_root_bus (Bjorn Helgaas)

----------------------------------------------------------------
Alex Williamson (1):
      PCI: Fix PCI Express Capability accessors for PCI_EXP_FLAGS

Bjorn Helgaas (23):
      ACPI: Remove unused struct acpi_pci_root.id member
      x86/PCI: Remove unused pci_root_bus
      frv/PCI: Remove unused pci_root_bus
      mn10300/PCI: Remove unused pci_root_bus
      PCI: Use "unsigned long" for __pci_enable_device_flags to match ioport.h
      PCI: Drop "__" prefix on __pci_enable_device_flags()
      Merge branch 'pci/misc' into next
      Merge branch 'pci/yinghai-survey-resources' into next
      Merge branch 'acpi-scan' of git://git.kernel.org/.../rafael/linux-pm into pci/yinghai-survey-resources+acpi-scan
      Merge branch 'pci/yinghai-survey-resources+acpi-scan' into next
      Merge branch 'pci/rafael-set-root-bridge-handle' into next
      Merge branch 'acpi-scan' of git://git.kernel.org/.../rafael/linux-pm into pci/acpi-scan2
      Merge branch 'pci/yijing-ari' into next
      Merge branch 'pci/acpi-scan2' into next
      Merge branch 'pci/yinghai-root-bus-hotplug' into next
      Merge branch 'pci/yinghai-root-bus-hotplug' into next
      Merge branch 'pci/joe-aspm' into next
      Merge branch 'pci/misc' into next
      PCI: Use atomic_inc_return() rather than atomic_add_return()
      Merge branch 'pci/konstantin-runtime-pm' into next
      Merge branch 'pci/jiang-pci_slot-kconfig' into next
      Merge branch 'pci/misc' into next
      Merge branch 'pci/yinghai-root-bus-hotplug' into next

Jiang Liu (6):
      ACPI: remove unused acpi_op_bind and acpi_op_unbind
      PCI: Fix reference count leak in pci_dev_present()
      PCI: Make device create/destroy logic symmetric
      PCI: acpiphp: Create companion ACPI devices before creating PCI devices
      PCI: acpiphp: Remove dead code for PCI host bridge hotplug
      ACPI / PCI: Make pci_slot built-in only, not a module

Joe Lawrence (1):
      PCI/ASPM: Don't touch ASPM if forcibly disabled

Konstantin Khlebnikov (2):
      PCI: Disable Bus Master unconditionally in pci_device_shutdown()
      PCI: Catch attempts to disable already-disabled devices

Mika Westerberg (1):
      ACPI / scan: Fix check of device_attach() return value.

Myron Stowe (3):
      PCI: Introduce accessor to retrieve PCIe Capabilities Register
      PCI: Use PCI Express Capability accessor
      PCI/ASPM: Deallocate upstream link state even if device is not PCIe

Paul Bolle (1):
      PCI: pciehp: Drop suspend/resume ENTRY messages

Rafael J. Wysocki (25):
      ACPI: Separate adding ACPI device objects from probing ACPI drivers
      ACPI: Change the ordering of PCI root bridge driver registrarion
      ACPI: Make acpi_bus_add() and acpi_bus_start() visibly different
      ACPI: Reduce the usage of struct acpi_bus_ops
      ACPI: Replace struct acpi_bus_ops with enum type
      ACPI: Change the ordering of acpi_bus_check_add()
      ACPI / PCI: Fold acpi_pci_root_start() into acpi_pci_root_add()
      ACPI: Remove acpi_start_single_object() and acpi_bus_start()
      ACPI: Remove the arguments of acpi_bus_add() that are not used
      ACPI: Drop the second argument of acpi_bus_scan()
      ACPI: Replace ACPI device add_type field with a match_driver flag
      ACPI: Make acpi_bus_scan() and acpi_bus_add() take only one argument
      ACPI: Add .setup() and .cleanup() callbacks to struct acpi_bus_type
      ACPI / PCI: Rework the setup and cleanup of device wakeup
      ACPI / PCI: Move the _PRT setup and cleanup code to pci-acpi.c
      ACPI: Drop ACPI device .bind() and .unbind() callbacks
      ACPI / scan: Treat power resources in a special way
      ACPI / PCI: Set root bridge ACPI handle in advance
      ACPI: Remove the ops field from struct acpi_device
      ACPI / scan: Drop the second argument of acpi_device_unregister()
      ACPI / scan: Drop the second argument of acpi_bus_trim()
      ACPI / scan: Change the implementation of acpi_bus_trim()
      ACPI / scan: Add second pass to acpi_bus_trim()
      ACPI / scan: Drop acpi_bus_add() and use acpi_bus_scan() instead
      PCI/PM: Clear state_saved during suspend

Sasha Levin (1):
      PCI: cpqphp: Cleanup and remove unreachable paths

Tang Chen (1):
      PCI/ACPI: Print info if host bridge notify handler installation fails

Yijing Wang (10):
      PCI: Enable ARI if dev and upstream bridge support it; disable otherwise
      PCI: Rename pci_enable_ari() to pci_configure_ari()
      PCI: Consolidate "next-function" functions
      PCI: pciehp: Iterate over all devices in slot, not functions 0-7
      PCI: cpcihp: Iterate over all devices in slot, not functions 0-7
      PCI: sgihp: Iterate over all devices in slot, not functions 0-7
      PCI: shpchp: Iterate over all devices in slot, not functions 0-7
      PCI: Document hpiosize= and hpmemsize= resource reservation parameters
      PCI: Document MPS parameters pci=pcie_bus_safe, pci=pcie_bus_perf, etc
      PCI: Remove unused "rc" in virtfn_add_bus()

Yinghai Lu (19):
      x86/PCI: Factor out pcibios_allocate_bridge_resources()
      x86/PCI: Factor out pcibios_allocate_dev_resources()
      x86/PCI: Allocate resources on a per-bus basis for hot-adding root buses
      x86/PCI: Factor out pcibios_allocate_dev_rom_resource()
      x86/PCI: Don't track firmware-assigned BAR values for hot-added devices
      x86/PCI: Keep resource allocation functions after boot
      PCI/ACPI: Reserve firmware-allocated resources for hot-added root buses
      x86/PCI: Implement pcibios_resource_survey_bus()
      ACPI: update ej_event interface to take acpi_device
      PCI: Kill pci_is_reassigndev()
      PCI: acpiphp: Add is_hotplug_bridge detection
      PCI: Add root bus children dev's res to fail list
      PCI: Set pci_dev dev_node early so IOAPIC irq_descs are allocated locally
      PCI/ACPI: acpiphp: Rename alloc_acpiphp_hp_work() to alloc_acpi_hp_work()
      PCI: acpiphp: Move host bridge hotplug to pci_root.c
      PCI: acpiphp: Keep driver loaded even if no slots found
      PCI: Skip attaching driver in device_add()
      PCI: Put pci_dev in device tree as early as possible
      PCI/ACPI: Don't cache _PRT, and don't associate them with bus numbers

 Documentation/kernel-parameters.txt     |  21 ++
 arch/frv/mb93090-mb00/pci-frv.h         |   1 -
 arch/frv/mb93090-mb00/pci-vdk.c         |   4 +-
 arch/ia64/pci/pci.c                     |   8 +
 arch/mn10300/unit-asb2305/pci-asb2305.h |   1 -
 arch/mn10300/unit-asb2305/pci.c         |   4 +-
 arch/x86/include/asm/pci.h              |   3 +
 arch/x86/include/asm/pci_x86.h          |   1 -
 arch/x86/pci/acpi.c                     |   9 +
 arch/x86/pci/common.c                   |   1 -
 arch/x86/pci/i386.c                     | 185 +++++++++++-------
 arch/x86/pci/legacy.c                   |   2 +-
 arch/x86/pci/numaq_32.c                 |   2 +-
 drivers/acpi/Kconfig                    |   5 +-
 drivers/acpi/Makefile                   |   2 +-
 drivers/acpi/acpi_memhotplug.c          |  26 +--
 drivers/acpi/container.c                |  31 +--
 drivers/acpi/device_pm.c                |   2 +-
 drivers/acpi/dock.c                     |  17 +-
 drivers/acpi/glue.c                     |  50 +++--
 drivers/acpi/internal.h                 |   7 +
 drivers/acpi/osl.c                      |  24 ++-
 drivers/acpi/pci_bind.c                 | 122 ------------
 drivers/acpi/pci_irq.c                  | 102 ++++------
 drivers/acpi/pci_root.c                 | 233 +++++++++++++---------
 drivers/acpi/pci_slot.c                 |  13 +-
 drivers/acpi/processor_driver.c         |  32 +---
 drivers/acpi/scan.c                     | 330 ++++++++++++--------------------
 drivers/pci/access.c                    |   6 +-
 drivers/pci/bus.c                       |  81 ++------
 drivers/pci/hotplug/acpiphp.h           |  14 +-
 drivers/pci/hotplug/acpiphp_core.c      |  23 +--
 drivers/pci/hotplug/acpiphp_glue.c      | 292 ++++++----------------------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |  29 ++-
 drivers/pci/hotplug/cpqphp_ctrl.c       |  57 ++----
 drivers/pci/hotplug/pciehp_core.c       |   2 -
 drivers/pci/hotplug/pciehp_pci.c        |  44 ++---
 drivers/pci/hotplug/sgi_hotplug.c       |  73 ++++---
 drivers/pci/hotplug/shpchp_pci.c        |  36 ++--
 drivers/pci/iov.c                       |  10 +-
 drivers/pci/pci-acpi.c                  |  45 +++--
 drivers/pci/pci-driver.c                |  12 +-
 drivers/pci/pci.c                       |  80 +++-----
 drivers/pci/pci.h                       |   9 +-
 drivers/pci/pcie/aspm.c                 |   8 +-
 drivers/pci/pcie/portdrv_core.c         |   2 +-
 drivers/pci/probe.c                     | 104 ++++++----
 drivers/pci/remove.c                    |   4 +-
 drivers/pci/search.c                    |  10 +-
 drivers/pci/setup-bus.c                 |   2 +-
 include/acpi/acpi_bus.h                 |  35 ++--
 include/acpi/acpi_drivers.h             |   5 -
 include/acpi/acpiosxf.h                 |   2 -
 include/linux/acpi.h                    |   5 +
 include/linux/pci.h                     |  15 +-
 55 files changed, 919 insertions(+), 1324 deletions(-)
 delete mode 100644 drivers/acpi/pci_bind.c
