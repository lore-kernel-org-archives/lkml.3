Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaHDTHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:07:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaHDTHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:07:39 -0400
Date: Mon, 4 Aug 2014 12:07:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core patches for 3.17-rc1
Message-ID: <20140804190738.GA27196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.17-rc1

for you to fetch changes up to 4e3a25b0274b8474f5ad46215a270785dd18265e:

  ARM: imx: Remove references to platform_bus in mxc code (2014-08-01 16:03:00 -0700)

----------------------------------------------------------------
Driver core patches for 3.17-rc1

Here's the big driver-core pull request for 3.17-rc1.

Largest thing in here is the dma-buf rework and fence code, that touched
many different subsystems so it was agreed it should go through this
tree to handle merge issues.  There's also some firmware loading
updates, as well as tests added, and a few other tiny changes, the
changelog has the details.

All have been in linux-next for a long time.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Daniel Thompson (1):
      Documentation: devres: Add devm_kmalloc() et al

Dave Chiluk (1):
      stable_kernel_rules: Add pointer to netdev-FAQ for network patches

Dmitry Kasatkin (1):
      firmware: read firmware size using i_size_read()

Fabian Frederick (2):
      firmware: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
      kernfs: kernel-doc warning fix

Geert Uytterhoeven (1):
      Documentation: devres: Sort managed interfaces

Greg Kroah-Hartman (4):
      Merge branch 'component-for-driver' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into driver-core-next
      Merge 3.16-rc4 into driver-core-next
      Merge branch 'component-for-driver' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into work-next
      Merge 3.16-rc6 into driver-core-next

Jingoo Han (1):
      devres: remove devm_request_and_ioremap()

Kees Cook (2):
      doc: fix minor typos in firmware_class README
      test: add firmware_class loader test

Kim Phillips (1):
      driver core: platform: add device binding path 'driver_override'

Luis R. Rodriguez (1):
      firmware loader: inform direct failure when udev loader is disabled

Maarten Lankhorst (9):
      dma-buf: move to drivers/dma-buf
      fence: dma-buf cross-device synchronization (v18)
      seqno-fence: Hardware dma-buf implementation of fencing (v6)
      dma-buf: use reservation objects
      android: convert sync to fence api, v6
      reservation: add support for fences to enable cross-device synchronisation
      dma-buf: add poll support, v3
      reservation: update api and add some helpers
      reservation: add suppport for read-only access using rcu

Pawel Moll (2):
      platform: Remove most references to platform_bus device
      ARM: imx: Remove references to platform_bus in mxc code

Peter Senna Tschudin (1):
      staging: android: Cleanup style issues

Rahul Bedarkar (1):
      fs: debugfs: remove trailing whitespace

Russell King (4):
      component: fix missed cleanup in case of devres failure
      component: ignore multiple additions of the same component
      component: add support for component match array
      component: fix bug with legacy API

Shuah Khan (1):
      firmware loader: Fix _request_firmware_load() return val for fw load abort

Steven Rostedt (1):
      debugfs: Fix corrupted loop in debugfs_remove_recursive

Takashi Iwai (1):
      firmware loader: allow disabling of udev as firmware loader

Yann Droneaud (1):
      driver core/platform: remove unused implicit padding in platform_object

 Documentation/ABI/testing/sysfs-bus-platform       |  20 +
 Documentation/DocBook/device-drivers.tmpl          |   8 +-
 Documentation/driver-model/devres.txt              | 112 +--
 Documentation/firmware_class/README                |   6 +-
 Documentation/stable_kernel_rules.txt              |   3 +
 MAINTAINERS                                        |   4 +-
 arch/arm/mach-bcm/board_bcm21664.c                 |   3 +-
 arch/arm/mach-bcm/board_bcm281xx.c                 |   3 +-
 arch/arm/mach-clps711x/board-edb7211.c             |   6 +-
 arch/arm/mach-clps711x/board-p720t.c               |   6 +-
 arch/arm/mach-imx/devices/devices.c                |   2 -
 arch/arm/mach-imx/mach-mx27ads.c                   |   2 +-
 arch/arm/mach-shmobile/board-ape6evm.c             |  14 +-
 arch/arm/mach-shmobile/board-bockw.c               |  19 +-
 arch/arm/mach-shmobile/board-genmai.c              |   5 +-
 arch/arm/mach-shmobile/board-koelsch.c             |  26 +-
 arch/arm/mach-shmobile/board-lager.c               |  34 +-
 arch/arm/mach-shmobile/board-marzen.c              |   1 -
 arch/arm/mach-shmobile/setup-r7s72100.c            |   2 +-
 arch/arm/mach-shmobile/setup-r8a73a4.c             |   8 +-
 arch/arm/mach-shmobile/setup-r8a7778.c             |  13 +-
 arch/arm/mach-shmobile/setup-r8a7779.c             |   6 +-
 arch/arm/mach-shmobile/setup-r8a7790.c             |  10 +-
 arch/arm/mach-shmobile/setup-r8a7791.c             |   8 +-
 arch/unicore32/kernel/puv3-core.c                  |   2 +-
 arch/unicore32/kernel/puv3-nb0916.c                |   6 +-
 drivers/Makefile                                   |   1 +
 drivers/base/Kconfig                               |  19 +-
 drivers/base/Makefile                              |   1 -
 drivers/base/component.c                           | 192 ++++-
 drivers/base/firmware_class.c                      |  47 +-
 drivers/base/platform.c                            |  51 +-
 drivers/base/reservation.c                         |  39 -
 drivers/bus/brcmstb_gisb.c                         |   6 +-
 drivers/dma-buf/Makefile                           |   1 +
 drivers/{base => dma-buf}/dma-buf.c                | 168 +++-
 drivers/dma-buf/fence.c                            | 431 ++++++++++
 drivers/dma-buf/reservation.c                      | 477 +++++++++++
 drivers/dma-buf/seqno-fence.c                      |  73 ++
 drivers/gpu/drm/armada/armada_crtc.c               |   8 +-
 drivers/gpu/drm/armada/armada_gem.c                |   2 +-
 drivers/gpu/drm/drm_prime.c                        |   8 +-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c         |   2 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |   3 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   1 +
 drivers/gpu/drm/nouveau/nouveau_gem.h              |   1 +
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   7 +
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |   2 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   2 +
 drivers/gpu/drm/radeon/radeon_prime.c              |   8 +
 drivers/gpu/drm/tegra/gem.c                        |   2 +-
 drivers/gpu/drm/ttm/ttm_object.c                   |   2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |   2 +-
 drivers/staging/android/Kconfig                    |   1 +
 drivers/staging/android/Makefile                   |   2 +-
 drivers/staging/android/ion/ion.c                  |   3 +-
 drivers/staging/android/sw_sync.c                  |   6 +-
 drivers/staging/android/sync.c                     | 913 +++++++--------------
 drivers/staging/android/sync.h                     |  79 +-
 drivers/staging/android/sync_debug.c               | 252 ++++++
 drivers/staging/android/trace/sync.h               |  12 +-
 fs/debugfs/file.c                                  |   2 +-
 fs/debugfs/inode.c                                 |  39 +-
 fs/kernfs/file.c                                   |   2 +-
 include/drm/drmP.h                                 |   3 +
 include/linux/component.h                          |   7 +
 include/linux/device.h                             |   2 -
 include/linux/dma-buf.h                            |  21 +-
 include/linux/fence.h                              | 360 ++++++++
 include/linux/firmware.h                           |  15 +-
 include/linux/platform_device.h                    |   1 +
 include/linux/reservation.h                        |  82 +-
 include/linux/seqno-fence.h                        | 116 +++
 include/trace/events/fence.h                       | 128 +++
 lib/Kconfig.debug                                  |  13 +
 lib/Makefile                                       |   1 +
 lib/devres.c                                       |  28 -
 lib/test_firmware.c                                | 117 +++
 scripts/coccinelle/api/devm_ioremap_resource.cocci |  90 --
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/firmware/Makefile          |  27 +
 tools/testing/selftests/firmware/fw_filesystem.sh  |  62 ++
 tools/testing/selftests/firmware/fw_userhelper.sh  |  89 ++
 83 files changed, 3283 insertions(+), 1076 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-platform
 delete mode 100644 drivers/base/reservation.c
 create mode 100644 drivers/dma-buf/Makefile
 rename drivers/{base => dma-buf}/dma-buf.c (81%)
 create mode 100644 drivers/dma-buf/fence.c
 create mode 100644 drivers/dma-buf/reservation.c
 create mode 100644 drivers/dma-buf/seqno-fence.c
 create mode 100644 drivers/staging/android/sync_debug.c
 create mode 100644 include/linux/fence.h
 create mode 100644 include/linux/seqno-fence.h
 create mode 100644 include/trace/events/fence.h
 create mode 100644 lib/test_firmware.c
 delete mode 100644 scripts/coccinelle/api/devm_ioremap_resource.cocci
 create mode 100644 tools/testing/selftests/firmware/Makefile
 create mode 100644 tools/testing/selftests/firmware/fw_filesystem.sh
 create mode 100644 tools/testing/selftests/firmware/fw_userhelper.sh
