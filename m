Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3BUVOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:14:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59579 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab3BUVNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:13:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 05/09] arm-soc: multiplatform support
Date: Thu, 21 Feb 2013 21:12:25 +0000
Message-Id: <1361481149-27559-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:FQTWbCW3nWWig+5Wd+eRQX/tReW5JC80pYmbTzysvQd
 rtD73016QEMBgojUh/bcnRDbeuCq3OFuglGPLUieBuWeCLzlgC
 dq2oNnL0KQnhRfk0rkdZ3oEcHg4KPjUIxXtCrPQwg7sRjtwXh1
 0BIQ7vOwiwMYiuIw84c1852mUTUBzzK3DKkof4UL0ij+h4O+8h
 yPyKGZzOkN1JIVRIoj4yLBUnG34sIEONZ4xJLkEb/6/IF+cGWx
 M/kpGONoRZ7pU1tvTf8XD3j3mSKXDbfjnUHxx7czSfIXBTyKJM
 xCkWLLOiTuVi3X/OYmXYpDsHTBpNkfuZkXHQPerKaYBEdq1FdO
 6rQjq442IVj6UNQUwGQP1IO92c+uvWqEEtyy2qLrZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/multiplatform

for you to fetch changes up to acb7452369e4f8749dd32d48dbda98936035a87c:

  Merge branch 'omap/multiplatform-fixes', tag 'v3.8-rc5' into next/multiplatform (2013-02-15 13:31:52 +0100)

----------------------------------------------------------------

arm-soc: multiplatform support

Converting more ARM platforms to multiplatform support. This time, OMAP
gets converted, which is a major step since this is by far the largest
platform in terms of code size. The same thing happens to the vt8500
platform.

Conflicts include:
* Two mach/uncompress.h files are removed, the changes made to them
  elsewhere can be discarded now.
* Moving the OMAP4 irq_match array has context clashes with turning
  omap4_sar_ram_init into an omap_early_initcall()

----------------------------------------------------------------
André Hentschel (1):
      ARM: OMAP2+: Include soc.h to drm.c to fix compiling

Arnd Bergmann (5):
      [media] davinci: do not include mach/hardware.h
      remoteproc: omap: depend on OMAP_MBOX_FWK
      net: cwdavinci_cpdma: export symbols for cpsw
      Merge branch 'omap/multiplatform-fixes', tag 'v3.8-rc5' into next/multiplatform

Josh Cartwright (2):
      ARM: multi_v7_defconfig: remove unnecessary CONFIG_GPIOLIB
      ARM: multi_v7_defconfig: add ARCH_ZYNQ

Olof Johansson (2):
      Merge tag 'omap-for-v3.9/multiplatform-enable-signed-v2' of git://git.kernel.org/.../tmlind/linux-omap into next/multiplatform
      Merge tag 'vt8500-multiplatform-3.9' of git://server.prisktech.co.nz/git/linuxwmt into next/multiplatform

Tony Lindgren (11):
      ARM: OMAP2+: Limit omap initcalls to omap only on multiplatform kernels
      ARM: OMAP2+: Use omap initcalls
      ARM: OMAP: Fix i2c cmdline initcall for multiplatform
      ARM: OMAP: Fix dmaengine init for multiplatform
      ARM: OMAP2+: Add multiplatform debug_ll support
      ARM: OMAP2+: Disable code that currently does not work with multiplaform
      ARM: OMAP2+: Enable ARCH_MULTIPLATFORM support
      ARM: OMAP2+: Add minimal support for booting vexpress
      ARM: OMAP2+: Remove now obsolete uncompress.h and debug-macro.S
      ARM: OMAP2+: Fix warning for hwspinlock omap_postcore_initcall
      ARM: OMAP2+: Make sure files with omap initcalls include soc.h

Tony Prisk (3):
      arm: vt8500: Remove single platform Kconfig options
      arm: vt8500: Convert debug-macro.S to be multiplatform friendly
      arm: vt8500: Remove remaining mach includes

 arch/arm/Kconfig                                |  28 ++--
 arch/arm/Kconfig.debug                          |  64 ++++++++
 arch/arm/arm-soc-for-next-contents.txt          |  13 ++
 arch/arm/configs/multi_v7_defconfig             |   2 +-
 arch/arm/configs/omap2plus_defconfig            |   6 +-
 arch/arm/include/debug/omap2plus.S              | 190 ++++++++++++++++++++++++
 arch/arm/include/debug/vt8500.S                 |  37 +++++
 arch/arm/mach-omap1/dma.c                       |  18 ++-
 arch/arm/mach-omap1/i2c.c                       |   6 +
 arch/arm/mach-omap2/Kconfig                     |  25 +++-
 arch/arm/mach-omap2/Makefile                    |   3 +
 arch/arm/mach-omap2/board-omap3beagle.c         |   2 +-
 arch/arm/mach-omap2/board-rx51-video.c          |   3 +-
 arch/arm/mach-omap2/clock2xxx.c                 |   2 +-
 arch/arm/mach-omap2/clock3xxx.c                 |   2 +-
 arch/arm/mach-omap2/devices.c                   |   6 +-
 arch/arm/mach-omap2/dma.c                       |  23 ++-
 arch/arm/mach-omap2/drm.c                       |   2 +-
 arch/arm/mach-omap2/emu.c                       |   2 +-
 arch/arm/mach-omap2/fb.c                        |   4 +-
 arch/arm/mach-omap2/gpio.c                      |   5 +-
 arch/arm/mach-omap2/gpmc.c                      |   4 +-
 arch/arm/mach-omap2/hdq1w.c                     |   3 +-
 arch/arm/mach-omap2/hwspinlock.c                |   3 +-
 arch/arm/mach-omap2/i2c.c                       |   5 +
 arch/arm/mach-omap2/include/mach/debug-macro.S  | 165 --------------------
 arch/arm/mach-omap2/include/mach/serial.h       |  37 -----
 arch/arm/mach-omap2/include/mach/uncompress.h   | 171 ---------------------
 arch/arm/mach-omap2/mcbsp.c                     |   3 +-
 arch/arm/mach-omap2/omap-iommu.c                |   3 +-
 arch/arm/mach-omap2/omap2-restart.c             |   3 +-
 arch/arm/mach-omap2/omap4-common.c              |   4 +-
 arch/arm/mach-omap2/omap_device.c               |   5 +-
 arch/arm/mach-omap2/omap_hwmod.c                |   2 +-
 arch/arm/mach-omap2/omap_phy_internal.c         |   2 +-
 arch/arm/mach-omap2/opp3xxx_data.c              |   2 +-
 arch/arm/mach-omap2/opp4xxx_data.c              |   2 +-
 arch/arm/mach-omap2/pm-debug.c                  |   2 +-
 arch/arm/mach-omap2/pm.c                        |   2 +-
 arch/arm/mach-omap2/pmu.c                       |   2 +-
 arch/arm/mach-omap2/prm3xxx.c                   |   2 +-
 arch/arm/mach-omap2/prm44xx.c                   |   2 +-
 arch/arm/mach-omap2/serial.c                    |   2 +-
 arch/arm/mach-omap2/smartreflex-class3.c        |   3 +-
 arch/arm/mach-omap2/soc.h                       |  29 ++++
 arch/arm/mach-omap2/timer.c                     |   2 +-
 arch/arm/mach-omap2/wd_timer.c                  |   2 +-
 arch/arm/mach-vt8500/Kconfig                    |  11 +-
 arch/arm/mach-vt8500/include/mach/debug-macro.S |  31 ----
 arch/arm/mach-vt8500/include/mach/timex.h       |  26 ----
 arch/arm/mach-vt8500/include/mach/uncompress.h  |  36 -----
 arch/arm/plat-omap/Kconfig                      |  32 +---
 arch/arm/plat-omap/Makefile                     |   2 +
 arch/arm/plat-omap/i2c.c                        |   3 +-
 arch/arm/plat-omap/include/plat/i2c.h           |   6 +
 drivers/crypto/omap-sham.c                      |   3 +
 drivers/dma/omap-dma.c                          |  20 +--
 drivers/media/platform/davinci/vpss.c           |   1 -
 drivers/media/rc/Kconfig                        |   2 +-
 drivers/net/ethernet/ti/davinci_cpdma.c         |   3 +
 drivers/remoteproc/Kconfig                      |   2 +-
 drivers/staging/tidspbridge/Kconfig             |   2 +-
 62 files changed, 497 insertions(+), 588 deletions(-)
