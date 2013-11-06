Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3KFW6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:58:30 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41402 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3KFW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:57:19 -0500
Date: Wed, 6 Nov 2013 14:51:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 3.13-rc1
Message-ID: <20131106225139.GA8393@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.13-rc1

for you to fetch changes up to 0cae60f91494e34a0c5391f1455f825d5849b05f:

  sysfs: rename sysfs_assoc_lock and explain what it's about (2013-11-01 12:13:37 -0700)

----------------------------------------------------------------
Driver Core / sysfs patches for 3.13-rc1

Here's the big driver core / sysfs update for 3.13-rc1.

There's lots of dev_groups updates for different subsystems, as they all
get slowly migrated over to the safe versions of the attribute groups
(removing userspace races with the creation of the sysfs files.)  Also
in here are some kobject updates, devres expansions, and the first round
of Tejun's sysfs reworking to enable it to be used by other subsystems
as a backend for an in-kernel filesystem.

All of these have been in linux-next for a while with no reported
issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Benjamin Herrenschmidt (1):
      sysfs/bin: Fix size handling overflow for bin_attribute

Bjorn Helgaas (1):
      device: Make dev_WARN/dev_WARN_ONCE print device as well as driver name

Fengguang Wu (1):
      kobject: show debug info on delayed kobject release

Greg Kroah-Hartman (33):
      rapidio: convert bus code to use bus_groups
      PPC: ibmebus: convert bus code to use bus_groups
      PPC: VIO: convert bus code to use bus_groups
      SCSI: fcoe: convert bus code to use bus_groups
      pmu_bus: convert bus code to use dev_groups
      PCI: convert bus code to use bus_groups
      PCI: convert bus code to use drv_groups
      scsi: fcoe: fix build error
      driver-core: remove struct bus_type.bus_attrs
      driver-core: remove struct bus_type.drv_attrs
      Merge 3.12-rc3 into driver-core-next
      driver core: remove dev_attrs from struct class
      driver core: remove dev_bin_attrs from struct class
      PNP: convert bus code to use dev_groups
      MMC: convert bus code to use dev_groups
      uwb: convert bus code to use dev_groups
      bcma: convert bus code to use dev_groups
      pcmcia: convert bus code to use dev_groups
      rapidio: convert bus code to use dev_groups
      ssb: convert bus code to use dev_groups
      xenbus: convert bus code to use dev_groups
      hsi: convert bus code to use dev_groups
      ide: convert bus code to use dev_groups
      ipack: convert bus code to use dev_groups
      virtio: convert bus code to use dev_groups
      tifm: convert bus code to use dev_groups
      memstick: convert bus code to use dev_groups
      i2o: convert bus code to use dev_groups
      Merge 3.12-rc6 into driver-core-next
      input: serio: use DEVICE_ATTR_RO()
      input: serio: remove bus usage of dev_attrs
      input: gameport: convert bus code to use dev_groups
      mdio_bus: convert bus code to use dev_groups

Jeff Mahoney (1):
      kobject: introduce kobj_completion

Joe Perches (1):
      devres: add kernel standard devm_k.alloc functions

Johan Hovold (7):
      driver core: prevent deferred probe with platform_driver_probe
      mmc: mvsdio: fix deferred probe from __init
      mtd: atmel_nand: fix deferred probe from __init
      pcmcia: at91_cf: fix deferred probe from __init
      usb: gadget: pxa25x_udc: fix deferred probe from __init
      usb: phy: gpio-vbus: fix deferred probe from __init
      backlight: atmel-pwm-bl: fix deferred probe from __init

Kevin Hilman (1):
      devres: restore zeroing behavior of devres_alloc()

Ming Lei (1):
      sysfs: fix sysfs_write_file for bin file

Neil Horman (1):
      firmware: Be a bit more verbose about direct firmware loading failure

Tejun Heo (34):
      sysfs: drop semicolon from to_sysfs_dirent() definition
      sysfs: make attr namespace interface less convoluted
      sysfs: remove ktype->namespace() invocations in directory code
      sysfs: remove ktype->namespace() invocations in symlink code
      sysfs: drop kobj_ns_type handling
      sysfs: clean up sysfs_get_dirent()
      sysfs: @name comes before @ns
      sysfs: remove sysfs_addrm_cxt->parent_sd
      kobject: grab an extra reference on kobject->sd to allow duplicate deletes
      sysfs: make __sysfs_remove_dir() recursive
      sysfs: introduce [__]sysfs_remove()
      sysfs: remove unused sysfs_buffer->pos
      sysfs: remove sysfs_buffer->needs_read_fill
      sysfs: remove sysfs_buffer->ops
      sysfs: add sysfs_open_file_mutex
      sysfs: rename sysfs_buffer to sysfs_open_file
      sysfs: add sysfs_open_file->sd and ->file
      sysfs: use transient write buffer
      sysfs: use seq_file when reading regular files
      sysfs: skip bin_buffer->buffer while reading
      sysfs: collapse fs/sysfs/bin.c::fill_read() into read()
      sysfs: prepare path write for unified regular / bin file handling
      sysfs: add sysfs_bin_read()
      sysfs: copy bin mmap support from fs/sysfs/bin.c to fs/sysfs/file.c
      sysfs: prepare open path for unified regular / bin file handling
      sysfs: merge regular and bin file handling
      sysfs: make sysfs_file_ops() follow ignore_lockdep flag
      sysfs: merge sysfs_elem_bin_attr into sysfs_elem_attr
      sysfs: honor bin_attr.attr.ignore_lockdep
      sysfs: remove unused sysfs_get_dentry() prototype
      sysfs: move sysfs_hash_and_remove() to fs/sysfs/dir.c
      sysfs: separate out dup filename warning into a separate function
      sysfs: use generic_file_llseek() for sysfs_file_operations
      sysfs: rename sysfs_assoc_lock and explain what it's about

Vladimir Zapolskiy (1):
      sysfs: return correct error code on unimplemented mmap()

Weijie Yang (1):
      fs/debugfs: add declaration for no CONFIG_DEBUG_FS

ethan.zhao (1):
      drivers/base/core.c: output device renaming messages with dev_dbg().

 Documentation/DocBook/filesystems.tmpl     |   1 -
 arch/powerpc/kernel/ibmebus.c              |  14 +-
 arch/powerpc/kernel/vio.c                  |  66 ++-
 drivers/base/bus.c                         |  82 +--
 drivers/base/class.c                       |  29 +-
 drivers/base/core.c                        |  88 +--
 drivers/base/devres.c                      |  31 +-
 drivers/base/firmware_class.c              |  38 +-
 drivers/base/platform.c                    |  17 +-
 drivers/bcma/main.c                        |  23 +-
 drivers/gpio/gpiolib.c                     |   2 +-
 drivers/hsi/hsi.c                          |  10 +-
 drivers/ide/ide-sysfs.c                    |  35 +-
 drivers/ide/ide.c                          |   2 +-
 drivers/input/gameport/gameport.c          |  17 +-
 drivers/input/serio/serio.c                |  70 ++-
 drivers/ipack/ipack.c                      |  22 +-
 drivers/md/bitmap.c                        |   4 +-
 drivers/md/md.c                            |   2 +-
 drivers/md/md.h                            |   2 +-
 drivers/memstick/core/memstick.c           |  18 +-
 drivers/message/i2o/core.h                 |   2 +-
 drivers/message/i2o/device.c               |  32 +-
 drivers/message/i2o/driver.c               |   2 +-
 drivers/misc/tifm_core.c                   |  10 +-
 drivers/mmc/core/bus.c                     |  12 +-
 drivers/mmc/core/sdio_bus.c                |  21 +-
 drivers/mmc/host/mvsdio.c                  |  11 +-
 drivers/mtd/nand/atmel_nand.c              |  13 +-
 drivers/net/bonding/bond_sysfs.c           |  14 +-
 drivers/net/phy/mdio_bus.c                 |  10 +-
 drivers/pci/pci-driver.c                   |  15 +-
 drivers/pci/pci-sysfs.c                    |  16 +-
 drivers/pci/pci.h                          |   2 +-
 drivers/pcmcia/at91_cf.c                   |  11 +-
 drivers/pcmcia/ds.c                        |  65 ++-
 drivers/pnp/base.h                         |   2 +-
 drivers/pnp/driver.c                       |   2 +-
 drivers/pnp/interface.c                    |  43 +-
 drivers/rapidio/rio-driver.c               |   4 +-
 drivers/rapidio/rio-sysfs.c                |  54 +-
 drivers/rapidio/rio.h                      |   4 +-
 drivers/scsi/fcoe/fcoe_sysfs.c             |  14 +-
 drivers/ssb/main.c                         |  25 +-
 drivers/uwb/umc-bus.c                      |  13 +-
 drivers/video/backlight/atmel-pwm-bl.c     |   9 +-
 drivers/virtio/virtio.c                    |  27 +-
 drivers/xen/xenbus/xenbus_probe.c          |  24 +-
 drivers/xen/xenbus/xenbus_probe.h          |   2 +-
 drivers/xen/xenbus/xenbus_probe_backend.c  |   2 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c |   2 +-
 fs/sysfs/Makefile                          |   3 +-
 fs/sysfs/bin.c                             | 502 -----------------
 fs/sysfs/dir.c                             | 424 ++++++++------
 fs/sysfs/file.c                            | 872 +++++++++++++++++++----------
 fs/sysfs/group.c                           |  33 +-
 fs/sysfs/inode.c                           |  30 +-
 fs/sysfs/mount.c                           |  24 +-
 fs/sysfs/symlink.c                         |  71 +--
 fs/sysfs/sysfs.h                           |  96 ++--
 include/linux/debugfs.h                    |  12 +
 include/linux/device.h                     |  64 ++-
 include/linux/ide.h                        |   2 +-
 include/linux/kobj_completion.h            |  18 +
 include/linux/kobject.h                    |   1 +
 include/linux/netdevice.h                  |  16 +-
 include/linux/platform_device.h            |   1 +
 include/linux/sysfs.h                      |  88 ++-
 kernel/events/core.c                       |  13 +-
 lib/kobject.c                              |  93 ++-
 net/core/net-sysfs.c                       |  14 +-
 71 files changed, 1711 insertions(+), 1702 deletions(-)
 delete mode 100644 fs/sysfs/bin.c
 create mode 100644 include/linux/kobj_completion.h
