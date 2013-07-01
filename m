Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3GARS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:18:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3GARSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:18:25 -0400
Date: Mon, 1 Jul 2013 10:18:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 3.11-rc1
Message-ID: <20130701171824.GA25801@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.11-rc1

for you to fetch changes up to bfd63cd24df69120585c22e09fda78723772ee2a:

  driver core: device.h: fix doc compilation warnings (2013-06-25 21:20:41 -0700)

----------------------------------------------------------------
Driver core patches for 3.11-rc1

Here's the big driver core merge for 3.11-rc1

Lots of little things, and larger firmware subsystem updates, all
described in the shortlog.  Nice thing here is that we finally get rid
of CONFIG_HOTPLUG, after 10+ years, thanks to Stephen Rohtwell (it had
been always on for a number of kernel releases, now it's just removed.)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ben Minerds (1):
      Documentation: Updated broken link in HOWTO

Daniel Mack (1):
      firmware: move EXPORT_SYMBOL annotations

Federico Vaga (1):
      base/core.c: improve comment of the function device_find_child()

Greg Kroah-Hartman (4):
      Merge 3.10-rc3 into driver-core-next
      Merge 3.10-rc6 into driver-core-next
      Merge branch 'driver-core-linus' into driver-core-next
      Merge 3.10-rc7 into driver-core-next

Igor Mammedov (2):
      cpu: fix "crash_notes" and "crash_notes_size" leaks in register_cpu()
      cpu: make sure that cpu/online file created before KOBJ_ADD is emitted

Jiri Slaby (1):
      build some drivers only when compile-testing

Kees Cook (1):
      kobject: sanitize argument for format string

Libo Chen (1):
      platform_device: use a macro instead of platform_driver_register

Mathias Krause (1):
      debugfs: write_file_bool() - ensure strtobool() operates on valid data

Michael Opdenacker (1):
      driver core: device.h: fix doc compilation warnings

Ming Lei (8):
      driver core: firmware loader: don't cache FW_ACTION_NOHOTPLUG firmware
      driver core: firmware loader: kill FW_ACTION_NOHOTPLUG requests before suspend
      firmware loader: fix build failure with !CONFIG_FW_LOADER_USER_HELPER
      firmware loader: fix compile warning
      firmware loader: don't export cache_firmware and uncache_firmware
      firmware loader: simplify holding module for request_firmware
      firmware loader: fix compile warning with PM_SLEEP set
      firmware loader: fix another compile warning with PM_SLEEP unset

Nathan Fontenot (1):
      drivers/base: Use attribute groups to create sysfs memory files

Nick Dyer (1):
      sysfs_notify is only possible on file attributes

Rami Rosen (1):
      sysfs: kill sysfs_sb declaration in fs/sysfs/inode.c.

Robert P. J. Day (1):
      Documentation: Tidy up some drivers/base/core.c kerneldoc content.

Seth Jennings (1):
      debugfs: add get/set for atomic types

Stephen Rothwell (1):
      Finally eradicate CONFIG_HOTPLUG

Takashi Iwai (2):
      dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
      firmware: Avoid deadlock of usermodehelper lock at shutdown

Warner Wang (1):
      sysfs: sysfs_link_sibling(): fix typo in comment

 Documentation/ABI/testing/sysfs-bus-pci |   5 +-
 Documentation/HOWTO                     |   2 +-
 Documentation/SubmitChecklist           |   2 +-
 Documentation/cpu-hotplug.txt           |   2 +-
 Documentation/hwmon/submitting-patches  |   3 +-
 Documentation/kbuild/kconfig.txt        |   2 +-
 Documentation/usb/hotplug.txt           |   6 +-
 arch/arm/Kconfig                        |   2 +-
 arch/arm/kernel/module.c                |   8 --
 arch/arm/kernel/vmlinux.lds.S           |   4 -
 arch/arm/mach-ixp4xx/Kconfig            |   1 -
 arch/blackfin/Kconfig                   |   2 +-
 arch/cris/arch-v32/drivers/Kconfig      |   1 -
 arch/ia64/Kconfig                       |   1 -
 arch/mips/Kconfig                       |   2 +-
 arch/parisc/Kconfig                     |   1 -
 arch/powerpc/Kconfig                    |   2 +-
 arch/powerpc/mm/tlb_hash64.c            |   4 +-
 arch/s390/Kconfig                       |   1 -
 arch/sh/Kconfig                         |   2 +-
 arch/sparc/Kconfig                      |   1 -
 arch/x86/Kconfig                        |   2 +-
 drivers/base/Kconfig                    |   2 -
 drivers/base/core.c                     |  16 ++--
 drivers/base/cpu.c                      |  59 ++++++++-----
 drivers/base/firmware_class.c           | 132 +++++++++++++++++++++--------
 drivers/base/memory.c                   | 143 ++++++++++++++------------------
 drivers/base/platform.c                 |   8 +-
 drivers/char/pcmcia/Kconfig             |   2 +-
 drivers/edac/Kconfig                    |   2 +-
 drivers/firmware/Kconfig                |   1 +
 drivers/misc/Kconfig                    |   2 +-
 drivers/pci/Kconfig                     |   2 -
 drivers/pci/hotplug/Kconfig             |   2 +-
 drivers/pcmcia/Kconfig                  |   1 -
 drivers/ptp/Kconfig                     |   1 +
 drivers/staging/media/go7007/go7007.txt |   1 -
 drivers/video/geode/Kconfig             |   2 +-
 fs/debugfs/file.c                       |  43 ++++++++++
 fs/gfs2/Kconfig                         |   5 +-
 fs/sysfs/dir.c                          |   2 +-
 fs/sysfs/file.c                         |  10 ++-
 fs/sysfs/inode.c                        |   2 -
 include/asm-generic/vmlinux.lds.h       |  20 -----
 include/linux/debugfs.h                 |   2 +
 include/linux/device.h                  |   3 +
 include/linux/firmware.h                |  11 ---
 include/linux/platform_device.h         |   8 +-
 init/Kconfig                            |  17 +++-
 kernel/power/Kconfig                    |   1 -
 lib/fault-inject.c                      |  21 -----
 lib/kobject.c                           |   2 +-
 mm/Kconfig                              |   2 +-
 53 files changed, 316 insertions(+), 265 deletions(-)
