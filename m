Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3KTNTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:19:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53449 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752633Ab3KTNTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:19:09 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] More ACPI and power management updates for v3.13-rc1
Date: Wed, 20 Nov 2013 14:31:47 +0100
Message-ID: <6443152.L15yMEV5my@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-2-3.13-rc1

to receive more ACPI and power management updates for v3.13-rc1
with top-most commit ed6a82546d2e8f6b5902269541733814d4adacc2

  Merge branch 'acpi-hotplug'

on top of commit 2f466d33f5f60542d3d82c0477de5863b22c94b9

  Merge tag 'pci-v3.13-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci

These commits were produced after I had sent my previous pull request.
A couple of them fix bugs introduced in that pull request, some fix issues
that have been present for a longer time, some add support for new hardware
and there is a series changing the way in which ACPI companion device objects
are associated with struct device things representing actual devices.

Specifics:

- ACPI-based device hotplug fixes for issues introduced recently and
  a fix for an older error code path bug in the ACPI PCI host bridge
  driver.

- Fix for recently broken OMAP cpufreq build from Viresh Kumar.

- Fix for a recent hibernation regression related to s2disk.

- Fix for a locking-related regression in the ACPI EC driver from
  Puneet Kumar.

- System suspend error code path fix related to runtime PM and
  runtime PM documentation update from Ulf Hansson.

- cpufreq's conservative governor fix from Xiaoguang Chen.

- New processor IDs for intel_idle and turbostat and removal of
  an obsolete Kconfig option from Len Brown.

- New device IDs for the ACPI LPSS (Low-Power Subsystem) driver and
  ACPI-based PCI hotplug (ACPIPHP) cleanup from Mika Westerberg.

- Removal of several ACPI video DMI blacklist entries that are not
  necessary any more from Aaron Lu.

- Rework of the ACPI companion representation in struct device and
  code cleanup related to that change from Rafael J Wysocki,
  Lan Tianyu and Jarkko Nikula.

- Fixes for assigning names to ACPI-enumerated I2C and SPI devices
  from Jarkko Nikula.

Thanks!


---------------

Aaron Lu (1):
      ACPI / video: clean up DMI table for initial black screen problem

Jarkko Nikula (3):
      ACPI: Provide acpi_dev_name accessor for struct acpi_device device name
      i2c: Use stable dev_name for ACPI enumerated I2C slaves
      spi: Use stable dev_name for ACPI enumerated SPI slaves

Lan Tianyu (2):
      ACPI / AC: Remove struct acpi_device pointer from struct acpi_ac
      cpufreq: governor: Remove fossil comment in the cpufreq_governor_dbs()

Len Brown (3):
      ACPI: delete CONFIG_ACPI_BLACKLIST_YEAR
      intel_idle: Support Intel Atom Processor C2000 Product Family
      tools / power turbostat: Support Silvermont

Mika Westerberg (2):
      ACPI / LPSS: add ACPI IDs for newer Intel PCHs
      PCI / hotplug / ACPI: Drop unused acpiphp_debug declaration

Puneet Kumar (1):
      ACPI / EC: Ensure lock is acquired before accessing ec struct members

Rafael J. Wysocki (8):
      ACPI / driver core: Store an ACPI device pointer in struct acpi_dev_node
      ACPI: Eliminate the DEVICE_ACPI_HANDLE() macro
      ACPI / bind: Use (put|get)_device() on ACPI device objects too
      PM / Hibernate: Do not crash kernel in free_basic_memory_bitmaps()
      ACPI / hotplug: Fix acpi_bus_get_device() return value check
      ACPI / hotplug: Fix PCI host bridge hot removal
      ACPI / PCI root: Clear driver_data before failing enumeration
      ACPI / scan: Set flags.match_driver in acpi_bus_scan_fixed()

Ulf Hansson (2):
      PM / Runtime: Update documentation around probe|remove|suspend
      PM / Runtime: Fix error path for prepare

Xiaoguang Chen (1):
      cpufreq: conservative: set requested_freq to policy max when it is over policy max

Viresh Kumar (1):
      cpufreq: OMAP: Fix compilation error 'r & ret undeclared'

---------------

 Documentation/power/runtime_pm.txt             |   14 +-
 arch/ia64/hp/common/sba_iommu.c                |    2 +-
 arch/ia64/include/asm/pci.h                    |    2 +-
 arch/ia64/pci/pci.c                            |    6 +-
 arch/ia64/sn/kernel/io_acpi_init.c             |    4 +-
 arch/x86/include/asm/pci.h                     |    2 +-
 arch/x86/include/uapi/asm/msr-index.h          |    2 +
 arch/x86/pci/acpi.c                            |    4 +-
 drivers/acpi/Kconfig                           |   11 --
 drivers/acpi/ac.c                              |   15 +-
 drivers/acpi/acpi_lpss.c                       |    9 ++
 drivers/acpi/acpi_platform.c                   |    2 +-
 drivers/acpi/blacklist.c                       |   35 -----
 drivers/acpi/device_pm.c                       |   14 +-
 drivers/acpi/ec.c                              |    3 +-
 drivers/acpi/glue.c                            |   53 ++++---
 drivers/acpi/pci_root.c                        |    1 +
 drivers/acpi/scan.c                            |   14 +-
 drivers/acpi/video.c                           |   87 ++---------
 drivers/ata/libata-acpi.c                      |    4 +-
 drivers/base/platform.c                        |    4 +-
 drivers/base/power/main.c                      |    3 +
 drivers/cpufreq/cpufreq_conservative.c         |    3 +
 drivers/cpufreq/cpufreq_governor.c             |    4 -
 drivers/cpufreq/omap-cpufreq.c                 |    1 +
 drivers/gpio/gpiolib.c                         |    1 +
 drivers/gpu/drm/i915/intel_acpi.c              |    2 +-
 drivers/gpu/drm/i915/intel_opregion.c          |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |    6 +-
 drivers/gpu/drm/radeon/radeon_acpi.c           |    8 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c   |    7 +-
 drivers/gpu/drm/radeon/radeon_bios.c           |    2 +-
 drivers/hid/i2c-hid/i2c-hid.c                  |    2 +-
 drivers/i2c/i2c-core.c                         |   25 ++-
 drivers/ide/ide-acpi.c                         |    5 +-
 drivers/idle/intel_idle.c                      |   24 ++-
 drivers/mmc/core/sdio_bus.c                    |    3 +-
 drivers/pci/hotplug/acpi_pcihp.c               |    2 +-
 drivers/pci/hotplug/acpiphp.h                  |    1 -
 drivers/pci/hotplug/pciehp_acpi.c              |    4 +-
 drivers/pci/hotplug/sgi_hotplug.c              |    8 +-
 drivers/pci/ioapic.c                           |    2 +-
 drivers/pci/pci-acpi.c                         |    6 +-
 drivers/pci/pci-label.c                        |    6 +-
 drivers/platform/x86/apple-gmux.c              |    2 +-
 drivers/pnp/pnpacpi/core.c                     |   10 +-
 drivers/spi/spi.c                              |   19 ++-
 drivers/usb/core/hub.c                         |    2 +-
 drivers/usb/core/usb-acpi.c                    |    4 +-
 drivers/xen/pci.c                              |    6 +-
 include/acpi/acpi_bus.h                        |    2 +-
 include/linux/acpi.h                           |   23 +++
 include/linux/device.h                         |   12 +-
 include/linux/pci-acpi.h                       |    4 +-
 kernel/power/snapshot.c                        |    3 +-
 kernel/power/user.c                            |    1 +
 tools/power/x86/turbostat/turbostat.c          |  197 +++++++++++++++++-------
 58 files changed, 374 insertions(+), 328 deletions(-)

