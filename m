Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab3IBXzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 19:55:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab3IBXzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 19:55:49 -0400
Date: Mon, 2 Sep 2013 16:58:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 3.12-rc1
Message-ID: <20130902235823.GC4544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.12-rc1

for you to fetch changes up to 1eeeef153c02f5856ec109fa532eb5f31c39f85c:

  firmware loader: fix pending_fw_head list corruption (2013-08-30 12:04:27 -0700)

----------------------------------------------------------------
Driver core patches for 3.12-rc1

Here's the big driver core pull request for 3.12-rc1.

Lots of tiny changes here fixing up the way sysfs attributes are
created, to try to make drivers simpler, and fix a whole class race
conditions with creations of device attributes after the device was
announced to userspace.

All the various pieces are acked by the different subsystem maintainers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
David Graham White (1):
      drivers:base:core: Moved sym export macros to respective functions

Geert Uytterhoeven (1):
      Kconfig: Remove hotplug enable hints in CONFIG_KEXEC help texts

Greg KH (2):
      ACPI: bgrt: take advantage of binary sysfs groups
      firmware: dcdbas: use binary attribute groups

Greg Kroah-Hartman (92):
      misc: c2port: use dev_bin_attrs instead of hand-coding it
      bsr: convert bsr_class to use dev_groups
      tile: srom: convert srom_class to use dev_groups
      c2port: convert class code to use dev_groups
      enclosure: convert class code to use dev_groups
      UIO: convert class code to use dev_groups
      staging: comedi: convert class code to use dev_groups
      c2port: convert class code to use bin_attrs in groups
      char: tile-srom: fix build error
      dma: convert dma_devclass to use dev_groups
      extcon: convert extcon_class to use dev_groups
      SCSI: OSD: convert class code to use dev_groups
      video: backlight: convert class code to use dev_groups
      video: backlight: lcd: convert class code to use dev_groups
      net: wireless: convert class code to use dev_groups
      net: rfkill: convert class code to use dev_groups
      ISDN: convert class code to use dev_groups
      leds: convert class code to use dev_groups
      PTP: convert class code to use dev_groups
      cuse: convert class code to use dev_groups
      net: core: convert class code to use dev_groups
      net: ieee802154: convert class code to use dev_groups
      Merge 3.11-rc3 into driver-core-next
      rtc: convert class code to use dev_groups
      driver core: bus_type: add dev_groups
      driver core: bus_type: add drv_groups
      driver core: bus_type: add bus_groups
      mips: convert vpe_class to use dev_groups
      devfreq: convert devfreq_class to use dev_groups
      HID: roccat: convert class code to use dev_groups
      v4l2: convert class code to use dev_groups
      x86: wmi: convert class code to use dev_groups
      PPS: convert class code to use dev_groups
      backing-dev: convert class code to use dev_groups
      hid: roccat-arvo: convert class code to use bin_attrs in groups
      hid: roccat-isku: convert class code to use bin_attrs in groups
      hid: roccat-kone: convert class code to use bin_attrs in groups
      hid: roccat-savu: convert class code to use bin_attrs in groups
      hid: roccat-koneplus: convert class code to use bin_attrs in groups
      hid: roccat-konepure: convert class code to use bin_attrs in groups
      hid: roccat-kovaplus: convert class code to use bin_attrs in groups
      hid: roccat-kone: fix off-by-one bug in attributes
      sysfs.h: fix __BIN_ATTR_RW()
      hid: roccat-pyra: convert class code to use bin_attrs in groups
      sysfs: add sysfs_create/remove_groups()
      sysfs: group.c: move EXPORT_SYMBOL_GPL() to the proper location
      sysfs: group.c: fix trailing whitespace
      sysfs: group.c: fix up some * coding style issues
      sysfs: group.c: fix up broken string coding style
      sysfs: group.c: add kerneldoc for sysfs_remove_group
      sysfs: group: update copyright to add myself and the LF
      sysfs: fix placement of EXPORT_SYMBOL()
      sysfs: remove trailing whitespace
      sysfs: fix up space coding style issues
      sysfs: fix up 80 column coding style issues
      sysfs: fix up uaccess.h coding style warnings
      sysfs: dir.c: fix up odd do/while indentation
      sysfs: file.c: fix up broken string warnings
      sysfs: sysfs.h: fix coding style issues
      sysfs: fix up minor coding style issues in sysfs.h
      acpi: bgrt: fix build error due to attribute change
      sysfs: group.c: fix up kerneldoc
      sysfs.h: remove attr_name() macro
      w1: remove race with sysfs file creation
      w1: use default attribute groups for w1 slave devices
      w1: add attribute groups to struct w1_family_ops
      w1: slaves: w1_therm: convert to use w1_family_ops.groups
      w1: slaves: w1_ds2408: convert to use w1_family_ops.groups
      w1: slaves: w1_ds2413.c: convert to use w1_family_ops.groups
      w1: slaves: w1_ds2423: convert to use w1_family_ops.groups
      w1: slaves: w1_ds2431: convert to use w1_family_ops.groups
      w1: slaves: w1_ds2433: convert to use w1_family_ops.groups
      w1: slaves: w1_ds28e04: convert to use w1_family_ops.groups
      w1: slaves: w1_ds2780: convert to use w1_family_ops.groups
      w1: slaves: w1_ds2760: convert to use w1_family_ops.groups
      w1: slaves: w1_ds2781: convert to use w1_family_ops.groups
      USB: serial: convert bus code to use drv_groups
      MEI: convert bus code to use dev_groups
      workqueue: convert bus code to use dev_groups
      driver-core: platform: convert bus code to use dev_groups
      sysfs: create __ATTR_WO()
      driver core: create write-only attribute macros for devices and drivers
      driver core: bus: use DRIVER_ATTR_WO()
      driver core: core: use DEVICE_ATTR_RO
      driver core: firmware: use __ATTR_RW()
      Input: gameport: convert bus code to use drv_groups
      Input: serio: convert bus code to use drv_groups
      HID: convert bus code to use dev_groups
      driver core: add #include <linux/sysfs.h> to core files.
      sysfs: add sysfs_create/remove_groups for when SYSFS is not enabled
      rbd: convert bus code to use bus_groups
      sysfs: sysfs_create_groups returns a value.

Gu Zheng (1):
      drivers/base/memory.c: introduce help macro to_memory_block

Hanjun Guo (6):
      cpu topology: remove stale arch_provides_topology_pointers and define_siblings_show_map/list()
      x86 / cpu topology: remove the stale macro arch_provides_topology_pointers
      tile / cpu topology: remove stale Macro arch_provides_topology_pointers
      drivers / base: Fix sysfs_deprecated_setup() __init attribute location
      drivers / platform: Fix __init attribute location
      drivers / dma-contiguous: Fix __init attribute location

Jingoo Han (1):
      driver core: replace strict_strto*() with kstrto*()

Johannes Berg (1):
      debugfs: provide debugfs_create_x64() when disabled

Lee, Jae-Hong (3):
      Type fix on HOWTO in ko_KR
      Type fix on stable_api_nonsense.txt
      Correct unfaithful translation on HOWTO in ko_KR

Maxime Bizon (1):
      firmware loader: fix pending_fw_head list corruption

Rafael J. Wysocki (1):
      driver core / cpu: Check if NUMA node is valid before bringing CPU up

Russell King (1):
      kobject: delayed kobject release: help find buggy drivers

Seth Jennings (8):
      drivers: base: move mutex lock out of add_memory_section()
      drivers: base: remove unneeded variable
      drivers: base: use device get/put functions
      drivers: base: unshare add_memory_section() from hotplug
      drivers: base: reduce add_memory_section() for boot-time only
      drivers: base: remove improper get/put in add_memory_section()
      drivers: base: refactor add_memory_section() to add_memory_block()
      drivers: base: use standard device online/offline for state change

jbaron@akamai.com (1):
      dynamic debug: line queries failing due to uninitialized local variable

 Documentation/ko_KR/HOWTO                   |  25 +--
 Documentation/ko_KR/stable_api_nonsense.txt |   6 +-
 arch/arm/Kconfig                            |   3 +-
 arch/ia64/Kconfig                           |   6 +-
 arch/mips/Kconfig                           |   6 +-
 arch/mips/kernel/vpe.c                      |  17 +-
 arch/powerpc/Kconfig                        |   6 +-
 arch/sh/Kconfig                             |   6 +-
 arch/tile/include/asm/topology.h            |   3 -
 arch/x86/Kconfig                            |   6 +-
 arch/x86/include/asm/topology.h             |   3 -
 drivers/acpi/bgrt.c                         |  27 ++-
 drivers/base/base.h                         |  10 ++
 drivers/base/bus.c                          |  60 +++++--
 drivers/base/class.c                        |   4 +-
 drivers/base/core.c                         | 107 +++++-------
 drivers/base/cpu.c                          |   6 +-
 drivers/base/dma-contiguous.c               |   4 +-
 drivers/base/driver.c                       |  31 +---
 drivers/base/firmware_class.c               |  24 +--
 drivers/base/memory.c                       | 258 +++++++++++++---------------
 drivers/base/platform.c                     |  14 +-
 drivers/base/power/sysfs.c                  |   2 +-
 drivers/base/regmap/regmap-debugfs.c        |   2 +-
 drivers/base/topology.c                     |  20 ---
 drivers/block/rbd.c                         |  14 +-
 drivers/char/bsr.c                          |  18 +-
 drivers/char/tile-srom.c                    |  28 +--
 drivers/devfreq/devfreq.c                   |  78 +++++----
 drivers/dma/dmaengine.c                     |  26 +--
 drivers/extcon/extcon-class.c               |  13 +-
 drivers/firmware/dcdbas.c                   |  19 +-
 drivers/hid/hid-core.c                      |  10 +-
 drivers/hid/hid-roccat-arvo.c               |  53 +++---
 drivers/hid/hid-roccat-isku.c               |  98 ++++++-----
 drivers/hid/hid-roccat-kone.c               | 106 ++++++------
 drivers/hid/hid-roccat-koneplus.c           | 175 +++++++++----------
 drivers/hid/hid-roccat-konepure.c           |  67 +++++---
 drivers/hid/hid-roccat-kovaplus.c           | 166 ++++++++----------
 drivers/hid/hid-roccat-pyra.c               | 158 ++++++++---------
 drivers/hid/hid-roccat-savu.c               |  58 ++++---
 drivers/input/gameport/gameport.c           |  12 +-
 drivers/input/serio/serio.c                 |  21 +--
 drivers/isdn/mISDN/core.c                   |  64 ++++---
 drivers/leds/led-class.c                    |  38 +++-
 drivers/media/v4l2-core/v4l2-dev.c          |  30 ++--
 drivers/misc/c2port/core.c                  |  83 +++++----
 drivers/misc/enclosure.c                    |  29 ++--
 drivers/misc/mei/bus.c                      |  10 +-
 drivers/net/ethernet/sun/niu.c              |   2 +-
 drivers/platform/x86/wmi.c                  |  10 +-
 drivers/pps/pps.c                           |   2 +-
 drivers/pps/sysfs.c                         |  55 +++---
 drivers/ptp/ptp_clock.c                     |   2 +-
 drivers/ptp/ptp_private.h                   |   2 +-
 drivers/ptp/ptp_sysfs.c                     |  51 +++---
 drivers/rtc/rtc-sysfs.c                     |  48 +++---
 drivers/scsi/osd/osd_uld.c                  |  13 +-
 drivers/staging/comedi/comedi_fops.c        |  39 +++--
 drivers/uio/uio.c                           |  22 ++-
 drivers/usb/serial/bus.c                    |  14 +-
 drivers/video/backlight/backlight.c         |  44 ++---
 drivers/video/backlight/lcd.c               |  26 +--
 drivers/w1/slaves/w1_ds2408.c               | 174 ++++++-------------
 drivers/w1/slaves/w1_ds2413.c               |  72 +++-----
 drivers/w1/slaves/w1_ds2423.c               |  27 +--
 drivers/w1/slaves/w1_ds2431.c               |  43 ++---
 drivers/w1/slaves/w1_ds2433.c               |  47 +++--
 drivers/w1/slaves/w1_ds2760.c               |  35 ++--
 drivers/w1/slaves/w1_ds2780.c               |  36 ++--
 drivers/w1/slaves/w1_ds2781.c               |  36 ++--
 drivers/w1/slaves/w1_ds28e04.c              | 112 +++++-------
 drivers/w1/slaves/w1_therm.c                |  24 +--
 drivers/w1/w1.c                             | 164 ++++++++++--------
 drivers/w1/w1_family.h                      |   1 +
 fs/fuse/cuse.c                              |  13 +-
 fs/sysfs/bin.c                              |  13 +-
 fs/sysfs/dir.c                              |  41 +++--
 fs/sysfs/file.c                             |  82 ++++-----
 fs/sysfs/group.c                            |  92 ++++++++--
 fs/sysfs/inode.c                            |  21 ++-
 fs/sysfs/mount.c                            |   2 +-
 fs/sysfs/symlink.c                          |  18 +-
 fs/sysfs/sysfs.h                            |  18 +-
 include/linux/debugfs.h                     |   7 +
 include/linux/device.h                      |  16 +-
 include/linux/kobject.h                     |   4 +
 include/linux/memory.h                      |  14 +-
 include/linux/pps_kernel.h                  |   2 +-
 include/linux/sysfs.h                       |  36 +++-
 kernel/workqueue.c                          |  27 +--
 lib/Kconfig.debug                           |  19 ++
 lib/dynamic_debug.c                         |   2 +-
 lib/kobject.c                               |  22 ++-
 mm/backing-dev.c                            |  19 +-
 net/core/net-sysfs.c                        | 136 ++++++++-------
 net/ieee802154/wpan-class.c                 |  23 +--
 net/rfkill/core.c                           |  90 +++++-----
 net/wireless/sysfs.c                        |  25 +--
 99 files changed, 1958 insertions(+), 1915 deletions(-)
