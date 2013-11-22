Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab3KVX1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:27:38 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39822 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3KVX1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:27:35 -0500
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 0/4] ACPI: Cleanup header inclusions.
Date: Sat, 23 Nov 2013 07:26:31 +0800
Message-Id: <cover.1385094640.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

ACPICA header files are lacking in stub protections.  This makes all ACPICA
header files could only be included for CONFIG_ACPI=y environment.  This
infects new ACPI prototypes, if such prototypes referenced ACPICA defined
types, they must be incldued only in the CONFIG_ACPI=y environment.  The
<acpi/acpi_bus.h> and <acpi/acpi_drivers.h> are the monstrosity infants
born under this background, directly including them in the CONFIG_ACPI=n
environment is not safe.  The infection spreads to whole kernel source tree
that we can see "#ifdef CONFIG_ACPI" here and there.

This patchset tries to enforces <linux/acpi.h> inclusions instead of
<acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> inclusions.

Lv Zheng (4):
  ACPICA: Linux: Cleanup wrong ACPICA inclusions.
  ACPI: Cleanup <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> inclusions.
  ACPICA: Cleanup <acpi/acpi.h> inclusions.
  ACPI: Add support to force header inclusion rules for <linux/acpi.h>.

 arch/ia64/hp/common/aml_nfw.c                        |    3 +--
 arch/x86/kernel/apic/apic_flat_64.c                  |    4 +---
 arch/x86/kernel/apic/io_apic.c                       |    3 ---
 arch/x86/pci/mmconfig_32.c                           |    1 -
 arch/x86/platform/olpc/olpc-xo15-sci.c               |    3 +--
 drivers/acpi/ac.c                                    |    3 +--
 drivers/acpi/acpi_extlog.c                           |    1 -
 drivers/acpi/acpi_pad.c                              |    3 +--
 drivers/acpi/acpica/Makefile                         |    2 +-
 drivers/acpi/apei/einj.c                             |    1 -
 drivers/acpi/battery.c                               |    3 +--
 drivers/acpi/blacklist.c                             |    1 -
 drivers/acpi/bus.c                                   |    2 --
 drivers/acpi/button.c                                |    3 +--
 drivers/acpi/custom_method.c                         |    2 +-
 drivers/acpi/debugfs.c                               |    2 +-
 drivers/acpi/dock.c                                  |    2 --
 drivers/acpi/ec.c                                    |    3 +--
 drivers/acpi/event.c                                 |    2 +-
 drivers/acpi/fan.c                                   |    3 +--
 drivers/acpi/hed.c                                   |    2 --
 drivers/acpi/numa.c                                  |    1 -
 drivers/acpi/nvs.c                                   |    1 -
 drivers/acpi/osl.c                                   |    2 --
 drivers/acpi/pci_irq.c                               |    2 --
 drivers/acpi/pci_link.c                              |    3 +--
 drivers/acpi/pci_root.c                              |    2 --
 drivers/acpi/power.c                                 |    3 +--
 drivers/acpi/proc.c                                  |    3 +--
 drivers/acpi/processor_core.c                        |    2 +-
 drivers/acpi/processor_idle.c                        |    1 -
 drivers/acpi/processor_perflib.c                     |    3 +--
 drivers/acpi/processor_thermal.c                     |    3 +--
 drivers/acpi/processor_throttling.c                  |    3 +--
 drivers/acpi/sbshc.c                                 |    3 +--
 drivers/acpi/scan.c                                  |    1 -
 drivers/acpi/sleep.c                                 |    2 --
 drivers/acpi/sysfs.c                                 |    2 +-
 drivers/acpi/thermal.c                               |    3 +--
 drivers/acpi/utils.c                                 |    2 --
 drivers/acpi/video.c                                 |    3 +--
 drivers/acpi/wakeup.c                                |    1 -
 drivers/ata/libata-acpi.c                            |    1 -
 drivers/ata/pata_acpi.c                              |    2 +-
 drivers/char/hpet.c                                  |    1 -
 drivers/char/tpm/tpm_acpi.c                          |    2 +-
 drivers/char/tpm/tpm_ppi.c                           |    1 -
 drivers/gpu/drm/i915/intel_acpi.c                    |    1 -
 drivers/gpu/drm/nouveau/nouveau_acpi.c               |    3 ---
 drivers/gpu/drm/radeon/radeon_acpi.c                 |    2 --
 drivers/hv/vmbus_drv.c                               |    1 -
 drivers/hwmon/acpi_power_meter.c                     |    3 +--
 drivers/hwmon/asus_atk0110.c                         |    5 +----
 drivers/ide/ide-acpi.c                               |    1 -
 drivers/input/misc/atlas_btns.c                      |    2 +-
 drivers/iommu/amd_iommu_init.c                       |    1 -
 drivers/iommu/intel_irq_remapping.c                  |    2 +-
 drivers/pci/hotplug/acpiphp_ibm.c                    |    1 -
 drivers/pci/hotplug/pciehp.h                         |    2 --
 drivers/pci/ioapic.c                                 |    1 -
 drivers/pci/pci-acpi.c                               |    2 --
 drivers/pci/pci-label.c                              |    1 -
 drivers/platform/x86/acer-wmi.c                      |    1 -
 drivers/platform/x86/asus-laptop.c                   |    3 +--
 drivers/platform/x86/asus-wmi.c                      |    3 +--
 drivers/platform/x86/classmate-laptop.c              |    2 +-
 drivers/platform/x86/dell-wmi-aio.c                  |    1 -
 drivers/platform/x86/dell-wmi.c                      |    1 -
 drivers/platform/x86/eeepc-laptop.c                  |    3 +--
 drivers/platform/x86/eeepc-wmi.c                     |    2 +-
 drivers/platform/x86/hp_accel.c                      |    2 +-
 drivers/platform/x86/ideapad-laptop.c                |    3 +--
 drivers/platform/x86/intel-rst.c                     |    2 +-
 drivers/platform/x86/intel-smartconnect.c            |    2 +-
 drivers/platform/x86/intel_menlow.c                  |    3 +--
 drivers/platform/x86/intel_oaktrail.c                |    2 --
 drivers/platform/x86/mxm-wmi.c                       |    3 +--
 drivers/platform/x86/panasonic-laptop.c              |    3 +--
 drivers/platform/x86/pvpanic.c                       |    3 +--
 drivers/platform/x86/samsung-q10.c                   |    2 +-
 drivers/platform/x86/sony-laptop.c                   |    2 --
 drivers/platform/x86/tc1100-wmi.c                    |    4 +---
 drivers/platform/x86/thinkpad_acpi.c                 |    2 +-
 drivers/platform/x86/toshiba_acpi.c                  |    2 +-
 drivers/platform/x86/toshiba_bluetooth.c             |    3 +--
 drivers/platform/x86/wmi.c                           |    2 --
 drivers/platform/x86/xo15-ebook.c                    |    3 +--
 drivers/pnp/pnpacpi/core.c                           |    1 -
 drivers/pnp/pnpacpi/pnpacpi.h                        |    1 -
 drivers/sfi/sfi_acpi.c                               |    2 +-
 drivers/staging/quickstart/quickstart.c              |    2 +-
 drivers/usb/core/usb-acpi.c                          |    1 -
 drivers/xen/xen-acpi-cpuhotplug.c                    |    2 --
 drivers/xen/xen-acpi-memhotplug.c                    |    1 -
 drivers/xen/xen-acpi-pad.c                           |    3 +--
 drivers/xen/xen-acpi-processor.c                     |    3 +--
 include/acpi/acpi_bus.h                              |    6 +++++-
 include/acpi/acpi_drivers.h                          |    7 +++++--
 include/acpi/platform/aclinux.h                      |    6 ++++++
 include/linux/acpi_io.h                              |    2 +-
 include/linux/ide.h                                  |    3 ---
 include/linux/iscsi_ibft.h                           |    2 +-
 include/linux/pci_hotplug.h                          |    3 +--
 include/linux/sfi_acpi.h                             |    2 +-
 include/linux/tboot.h                                |    2 +-
 tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c |    3 +--
 106 files changed, 75 insertions(+), 166 deletions(-)

-- 
1.7.10

