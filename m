Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3HMGdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab3HMGdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/60] 3.10.7-stable review
Date: Mon, 12 Aug 2013 23:33:27 -0700
Message-Id: <20130813063331.950321483@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.7 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Aug 15 06:33:14 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.7-rc1

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: Expose missing pci_io{map,unmap} declarations

Arnd Bergmann <arnd@arndb.de>
    mtd: omap2: allow bulding as a module

Arnd Bergmann <arnd@arndb.de>
    SCSI: nsp32: use mdelay instead of large udelay constants

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: always program the MC on startup

Christian König <christian.koenig@amd.com>
    drm/radeon: only save UVD bo when we have open handles

Christian König <christian.koenig@amd.com>
    drm/radeon: fix halting UVD

Jani Nikula <jani.nikula@linux.intel.com>
    drm/i915: initialize gt_lock early with other spin locks

Al Viro <viro@zeniv.linux.org.uk>
    reiserfs: fix deadlock in umount

Oleg Nesterov <oleg@redhat.com>
    debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)

Julius Werner <jwerner@chromium.org>
    usb: core: don't try to reset_device() a port that got just disconnected

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    zram: allow request end to coincide with disksize

Jeff Layton <jlayton@redhat.com>
    cifs: don't instantiate new dentries in readdir for inodes that need to be revalidated immediately

Chen Gang <gang.chen@asianux.com>
    cifs: extend the buffer length enought for sprintf() using

Theodore Ts'o <tytso@mit.edu>
    ext4: flush the extent status cache during EXT4_IOC_SWAP_BOOT

Piotr Sarna <p.sarna@partner.samsung.com>
    ext4: fix mount/remount error messages for incompatible mount options

Theodore Ts'o <tytso@mit.edu>
    ext4: allow the mount options nodelalloc and data=journal

Christian König <christian.koenig@amd.com>
    drm/radeon: stop sending invalid UVD destroy msg

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: select audio dto based on encoder id for DCE3

Michel Dänzer <michel.daenzer@amd.com>
    drm: Don't pass negative delta to ktime_sub_ns()

Dave Airlie <airlied@redhat.com>
    drm/ast: invalidate page tables when pinning a BO

Egbert Eich <eich@suse.com>
    drm/mgag200: Invalidate page tables when pinning a BO

Michal Srb <msrb@suse.com>
    drm/cirrus: Invalidate page tables when pinning a BO

Amit Shah <amit.shah@redhat.com>
    virtio: console: return -ENODEV on all read operations after unplug

Amit Shah <amit.shah@redhat.com>
    virtio: console: fix raising SIGIO after port unplug

Amit Shah <amit.shah@redhat.com>
    virtio: console: clean up port data immediately at time of unplug

Amit Shah <amit.shah@redhat.com>
    virtio: console: fix race in port_fops_open() and port unplug

Amit Shah <amit.shah@redhat.com>
    virtio: console: fix race with port unplug and open/close

Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
    virtio/console: Add pipe_lock/unlock for splice_write

Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
    virtio/console: Quit from splice_write if pipe->nrbufs is 0

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: If the rpcbind channel is disconnected, fail the call to unregister

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Don't auto-disconnect from the local rpcbind socket

Trond Myklebust <Trond.Myklebust@netapp.com>
    LOCKD: Don't call utsname()->nodename from nlmclnt_setlockargs

Josef Bacik <jbacik@fusionio.com>
    Btrfs: release both paths before logging dir/changed extents

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    ALSA: 6fire: fix DMA issues with URB transfer_buffer usage

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: do not trust too-big wMaxPacketSize values

Alexander Z Lam <azl@google.com>
    tracing: Fix reset of time stamps during trace_clock changes

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Use flag buffer_disabled for irqsoff tracer

Alexander Z Lam <azl@google.com>
    tracing: Make TRACE_ITER_STOP_ON_FREE stop the correct buffer

Andrew Vagin <avagin@openvz.org>
    tracing: Fix fields of struct trace_iterator that are zeroed by mistake

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Walk physical_node_list under physical_node_lock

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: rename ignore_nice as ignore_nice_load

Aaro Koskinen <aaro.koskinen@iki.fi>
    cpufreq: loongson2: fix regression related to clock management

Fabio Estevam <fabio.estevam@freescale.com>
    i2c: i2c-mxs: Use DMA mode even for small transfers

Alban Browaeys <alban.browaeys@gmail.com>
    media: em28xx: fix assignment of the eeprom data

Piotr Sarna <p.sarna@partner.samsung.com>
    staging: zcache: fix "zcache=" kernel parameter

Curt Brune <curt@cumulusnetworks.com>
    hwmon: (adt7470) Fix incorrect return code check

Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
    regmap: Add missing header for !CONFIG_REGMAP stubs

Lars-Peter Clausen <lars@metafoo.de>
    regmap: cache: Make sure to sync the last register in a block

Theodore Ts'o <tytso@mit.edu>
    ext4: fix retry handling in ext4_ext_truncate()

Theodore Ts'o <tytso@mit.edu>
    ext4: make sure group number is bumped after a inode allocation race

Eric Sandeen <sandeen@redhat.com>
    ext4: destroy ext4_es_cachep on module unload

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix context switching TAR, PPR and DSCR SPRs

Michael Neuling <mikey@neuling.org>
    powerpc: Save the TAR register earlier

Michael Neuling <mikey@neuling.org>
    powerpc: Fix context switch DSCR on POWER8

Michael Neuling <mikey@neuling.org>
    powerpc: Rework setting up H/FSCR bit definitions

Michael Neuling <mikey@neuling.org>
    powerpc: Fix hypervisor facility unavaliable vector number

Anton Blanchard <anton@samba.org>
    powerpc: On POWERNV enable PPC_DENORMALISATION by default

Asias He <asias@redhat.com>
    virtio-scsi: Fix virtqueue affinity setup

Sumit.Saxena@lsi.com <Sumit.Saxena@lsi.com>
    SCSI: megaraid_sas: megaraid_sas driver init fails in kdump kernel

Martin K. Petersen <martin.petersen@oracle.com>
    SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_pages is set


-------------

Diffstat:

 Makefile                                  |   4 +-
 arch/mips/Kconfig                         |   2 +-
 arch/mips/include/asm/io.h                |   5 ++
 arch/powerpc/Kconfig                      |   2 +-
 arch/powerpc/include/asm/processor.h      |   4 +
 arch/powerpc/include/asm/reg.h            |  31 +++++---
 arch/powerpc/include/asm/switch_to.h      |   9 +++
 arch/powerpc/kernel/asm-offsets.c         |   3 +
 arch/powerpc/kernel/entry_64.S            |  36 ++++++---
 arch/powerpc/kernel/exceptions-64s.S      |   5 +-
 arch/powerpc/kernel/process.c             |  10 +++
 arch/powerpc/kernel/tm.S                  |  20 +++++
 arch/powerpc/kernel/traps.c               |  58 ++++++++------
 drivers/acpi/proc.c                       |   8 ++
 drivers/base/regmap/regcache.c            |   3 +-
 drivers/char/virtio_console.c             |  70 +++++++++++-----
 drivers/cpufreq/cpufreq_conservative.c    |  20 ++---
 drivers/cpufreq/cpufreq_governor.c        |   8 +-
 drivers/cpufreq/cpufreq_governor.h        |   4 +-
 drivers/cpufreq/cpufreq_ondemand.c        |  20 ++---
 drivers/cpufreq/loongson2_cpufreq.c       |  11 +--
 drivers/gpu/drm/ast/ast_ttm.c             |   1 +
 drivers/gpu/drm/cirrus/cirrus_ttm.c       |   1 +
 drivers/gpu/drm/drm_irq.c                 |   5 +-
 drivers/gpu/drm/i915/i915_dma.c           |   1 +
 drivers/gpu/drm/i915/intel_pm.c           |   2 -
 drivers/gpu/drm/mgag200/mgag200_ttm.c     |   1 +
 drivers/gpu/drm/radeon/evergreen.c        |   6 +-
 drivers/gpu/drm/radeon/ni.c               |   6 +-
 drivers/gpu/drm/radeon/r600.c             |  31 ++++++--
 drivers/gpu/drm/radeon/r600_hdmi.c        |  12 ++-
 drivers/gpu/drm/radeon/radeon.h           |   2 +-
 drivers/gpu/drm/radeon/radeon_asic.h      |   2 +-
 drivers/gpu/drm/radeon/radeon_fence.c     |   2 +-
 drivers/gpu/drm/radeon/radeon_uvd.c       |  50 ++++++++----
 drivers/gpu/drm/radeon/rv770.c            |   7 +-
 drivers/gpu/drm/radeon/si.c               |   9 ++-
 drivers/hwmon/adt7470.c                   |   2 +-
 drivers/i2c/busses/i2c-mxs.c              |   2 +-
 drivers/media/usb/em28xx/em28xx-i2c.c     |   2 +-
 drivers/mtd/nand/Kconfig                  |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  20 +++--
 drivers/scsi/nsp32.c                      |   2 +-
 drivers/scsi/scsi.c                       |   3 +
 drivers/scsi/virtio_scsi.c                |   2 +-
 drivers/staging/zcache/zcache-main.c      |   6 +-
 drivers/staging/zram/zram_drv.c           |   2 +-
 drivers/usb/core/hub.c                    |   5 +-
 fs/btrfs/tree-log.c                       |   5 +-
 fs/cifs/cifsencrypt.c                     |   2 +-
 fs/cifs/cifsglob.h                        |   1 +
 fs/cifs/connect.c                         |   7 +-
 fs/cifs/readdir.c                         |   8 ++
 fs/cifs/sess.c                            |   6 +-
 fs/debugfs/inode.c                        |  69 +++++-----------
 fs/ext4/extents.c                         |   2 +-
 fs/ext4/ialloc.c                          |  10 +--
 fs/ext4/ioctl.c                           |   6 +-
 fs/ext4/super.c                           |  20 ++++-
 fs/lockd/clntlock.c                       |  13 ++-
 fs/lockd/clntproc.c                       |   5 +-
 fs/reiserfs/procfs.c                      |  99 +++++------------------
 fs/reiserfs/super.c                       |   3 +-
 include/linux/ftrace_event.h              |  10 ++-
 include/linux/regmap.h                    |   1 +
 include/linux/sunrpc/sched.h              |   1 +
 kernel/trace/trace.c                      | 128 ++++++++++++++++++++----------
 kernel/trace/trace_irqsoff.c              |   4 +-
 net/sunrpc/clnt.c                         |   4 +
 net/sunrpc/netns.h                        |   1 +
 net/sunrpc/rpcb_clnt.c                    |  48 ++++++++---
 sound/usb/6fire/comm.c                    |  38 +++++++--
 sound/usb/6fire/comm.h                    |   2 +-
 sound/usb/endpoint.c                      |  13 ++-
 74 files changed, 634 insertions(+), 391 deletions(-)


