Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaDASpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:45:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDASpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:45:20 -0400
Date: Tue, 1 Apr 2014 11:47:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core / sysfs patches for 3.15-rc1
Message-ID: <20140401184736.GA21807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.15-rc1

for you to fetch changes up to 72099304eeb316c4b00df3ae83efe4375729bd78:

  Revert "sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()" (2014-03-25 20:54:57 -0700)

----------------------------------------------------------------
Driver core / sysfs patches for 3.15-rc1

Here's the big driver core / sysfs update for 3.15-rc1.

Lots of kernfs updates to make it useful for other subsystems, and a few
other tiny driver core patches.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ard Biesheuvel (2):
      cpu: add generic support for CPU feature based module autoloading
      x86: align x86 arch with generic CPU modalias handling

Cody P Schafer (1):
      sysfs: create bin_attributes under the requested group

Colin Cross (1):
      dma-buf: avoid using IS_ERR_OR_NULL

Greg Kroah-Hartman (3):
      Merge 3.14-rc3 into driver-core-next
      Merge 3.14-rc5 into driver-core-next
      Revert "sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()"

Jiang Liu (1):
      driver core: unexport static function create_syslog_header

Josh Cartwright (1):
      ACPI / platform: drop redundant ACPI_HANDLE check

Li Zefan (1):
      kernfs: fix kernfs_node_from_dentry()

Michel Lespinasse (2):
      firmware: fix google/gsmi duplicate efivars_sysfs_init()
      firmware: google memconsole driver fixes

Paul Gortmaker (1):
      drivers/base: delete non-required instances of include <linux/init.h>

Richard Cochran (1):
      kernfs: fix off by one error.

Roland Dreier (1):
      Revert "driver core: synchronize device shutdown"

Shaibal Dutta (1):
      firmware: use power efficient workqueue for unloading and aborting fw load

Tejun Heo (27):
      kernfs: make kernfs_deactivate() honor KERNFS_LOCKDEP flag
      kernfs: replace kernfs_node->u.completion with kernfs_root->deactivate_waitq
      kernfs: restructure removal path to fix possible premature return
      kernfs: invoke kernfs_unmap_bin_file() directly from kernfs_deactivate()
      kernfs: remove kernfs_addrm_cxt
      kernfs: remove KERNFS_ACTIVE_REF and add kernfs_lockdep()
      kernfs: remove KERNFS_REMOVED
      kernfs, sysfs, driver-core: implement kernfs_remove_self() and its wrappers
      pci: use device_remove_file_self() instead of device_schedule_callback()
      scsi: use device_remove_file_self() instead of device_schedule_callback()
      s390: use device_remove_file_self() instead of device_schedule_callback()
      sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()
      kernfs: invoke dir_ops while holding active ref of the target node
      kernfs: rename kernfs_dir_ops to kernfs_syscall_ops
      kernfs: implement kernfs_syscall_ops->remount_fs() and ->show_options()
      kernfs: add missing kernfs_active() checks in directory operations
      kernfs: allow nodes to be created in the deactivated state
      kernfs: implement kernfs_ops->atomic_write_len
      kernfs: add kernfs_open_file->priv
      kernfs: implement kernfs_node_from_dentry(), kernfs_root_from_sb() and kernfs_rename()
      kernfs: implement kernfs_get_parent(), kernfs_name/path() and friends
      sysfs, kobject: add sysfs wrapper for kernfs_enable_ns()
      kernfs: add CONFIG_KERNFS
      kernfs: fix hash calculation in kernfs_rename_ns()
      Merge branch 'master' into driver-core-next-test-merge-rc2
      kernfs: remove duplicate dir.c at the top dir
      kernfs: cache atomic_write_len in kernfs_open_file

Xishi Qiu (1):
      numa: fix NULL pointer access and memory leak in unregister_one_node()

zhang jun (1):
      firmware: give a protection when map page failed

 arch/s390/include/asm/ccwgroup.h               |   1 +
 arch/s390/pci/pci_sysfs.c                      |  18 +-
 arch/x86/Kconfig                               |   4 +-
 arch/x86/include/asm/cpufeature.h              |   7 +
 arch/x86/kernel/cpu/match.c                    |  42 --
 drivers/base/Kconfig                           |   3 +
 drivers/base/attribute_container.c             |   1 -
 drivers/base/core.c                            |  20 +-
 drivers/base/cpu.c                             |  46 +-
 drivers/base/dma-buf.c                         |  18 +-
 drivers/base/firmware_class.c                  |  13 +-
 drivers/base/node.c                            |   4 +
 drivers/base/platform.c                        |  11 +-
 drivers/base/power/clock_ops.c                 |   1 -
 drivers/base/power/common.c                    |   1 -
 drivers/base/power/domain.c                    |   1 -
 drivers/base/power/domain_governor.c           |   1 -
 drivers/base/power/opp.c                       |   1 -
 drivers/base/regmap/regmap-i2c.c               |   1 -
 drivers/base/regmap/regmap-mmio.c              |   1 -
 drivers/base/regmap/regmap-spi.c               |   1 -
 drivers/base/topology.c                        |   1 -
 drivers/firmware/google/gsmi.c                 |   7 -
 drivers/firmware/google/memconsole.c           |  47 +-
 drivers/gpu/drm/drm_prime.c                    |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     |   2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c |   2 +-
 drivers/pci/pci-sysfs.c                        |  17 +-
 drivers/s390/block/dcssblk.c                   |  14 +-
 drivers/s390/cio/ccwgroup.c                    |  26 +-
 drivers/scsi/scsi_sysfs.c                      |  15 +-
 fs/Kconfig                                     |   1 +
 fs/Makefile                                    |   3 +-
 fs/kernfs/Kconfig                              |   7 +
 fs/kernfs/dir.c                                | 752 ++++++++++++++++++-------
 fs/kernfs/file.c                               |  22 +-
 fs/kernfs/kernfs-internal.h                    |  15 +-
 fs/kernfs/mount.c                              |  39 +-
 fs/kernfs/symlink.c                            |   6 +-
 fs/sysfs/Kconfig                               |   1 +
 fs/sysfs/dir.c                                 |  44 +-
 fs/sysfs/file.c                                |  23 +
 fs/sysfs/group.c                               |   7 +-
 fs/sysfs/mount.c                               |   2 +-
 include/linux/cpu.h                            |   7 -
 include/linux/cpufeature.h                     |  60 ++
 include/linux/device.h                         |   2 +
 include/linux/kernfs.h                         | 109 +++-
 include/linux/mod_devicetable.h                |   9 +
 include/linux/sysfs.h                          |  16 +
 lib/kobject.c                                  |   2 +-
 scripts/mod/devicetable-offsets.c              |   3 +
 scripts/mod/file2alias.c                       |  20 +-
 53 files changed, 1018 insertions(+), 461 deletions(-)
 create mode 100644 fs/kernfs/Kconfig
 create mode 100644 include/linux/cpufeature.h
