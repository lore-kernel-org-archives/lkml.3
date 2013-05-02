Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3EBHFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:05:20 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36689 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3EBHFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:05:14 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 5/5] ARM: arm-soc multiplatform updates for 3.10
Date: Wed,  1 May 2013 23:58:36 -0700
Message-Id: <1367477916-28399-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1367477916-28399-1-git-send-email-olof@lixom.net>
References: <1367477916-28399-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More multiplatform enablement for ARM platforms. The ones converted in
this branch are:
- bcm2835
- cns3xxx
- sirf
- nomadik
- msx
- spear
- tegra
- ux500

We're getting close to having most of them converted!

One of the larger platforms remaining is Samsung Exynos, and there are
a bunch of supporting patches in this merge window for it. There was a
patch in this branch to a early version of multiplatform conversion,
but it ended up being reverted due to need of more bake time. The
revert commit is part of the branch since it would have required
rebasing multiple dependent branches and they were stable by then.


Conflicts:

arch/arm/mach-ux500/cpuidle.c: Remove variables, keep comment indented
with tabs.

drivers/clocksource/Makefile: Add/change conflict. Keep SUN4I and
PRIMA2, ditch SUNXI.

----------------------------------------------------------------

The following changes since commit 00b4fd6087edf3b73cba84a6218ff9e68cf61359:

  Merge branch 'next/soc' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/multiplatform-for-linus

for you to fetch changes up to 2fdfe1c26fb9f24cfdf124384abb35396ca2cd3f:

  mmc: sdhci-s3c: Fix operation on non-single image Samsung platforms

----------------------------------------------------------------

Arnd Bergmann (59):
      ARM: spear13xx: make mach/dma.h local
      ARM: spear: unify mach/generic.h and mach/irqs.h
      ARM: spear: move identical headers to plat-spear/include/mach
      ARM: spear: make spear3xx/6xx mach/spear.h files identical
      ARM: spear: merge Kconfig files
      ARM: spear: move spear.h and misc_regs.h into plat-spear
      ARM: spear: move all files to mach-spear
      ARM: spear: move generic.h and pl080.h into private dir
      ARM: spear: make clock driver independent of headers
      ARM: spear: rename duplicate pl080_plat_data
      ARM: spear: use multiplatform configuration options.
      ARM: spear: fix build error in restart.c
      ARM: spear: enable spear13xx in multi_v7_defconfig
      ARM: cns3xxx: make mach header files local
      ARM: cns3xxx: enable sparse IRQ support
      ARM: cns3xxx: move debug_ll code to include/debug/
      ARM: cns3xxx: enable multiplatform support
      ARM: cns3xxx: initial DT support
      Merge tag 'nomadik-multiplatform' of git://git.kernel.org/.../linusw/linux-nomadik into next/multiplatform
      Merge branch 'cns3xxx/multiplatform' into next/multiplatform
      Merge branch 'spear/multiplatform' into next/multiplatform
      ARM: nomadik: hide MACH_NOMADIK_8815NHK in Kconfig
      ARM: spear: build hotplug.o for armv7-a
      clocksource: make CLOCKSOURCE_OF_DECLARE type safe
      Merge branches 'prima2/soc' and 'clksrc/cleanup' into prima2/multiplatform
      pinctrl: sirf: convert to linear irq domain
      ARM: sirf: fix prima2 interrupt lookup
      ARM: sirf: move irq driver to drivers/irqchip
      ARM: sirf: enable sparse IRQ
      ARM: sirf: move debug-macro.S to include/debug/sirf.S
      ARM: sirf: use clocksource_of infrastructure
      ARM: sirf: enable multiplatform support
      ARM: sirf: enable support in multi_v7_defconfig
      Merge branch 'prima2/multiplatform' into next/multiplatform
      ARM: ux500: split out prcmu initialization
      ARM: ux500: move mach/msp.h to <linux/platform_data/*>
      staging: ste_rmi4: kill platform_data hack
      ARM: ux500: make irqs.h local to platform
      ARM: ux500: make remaining headers local
      ARM: ux500: move to multiplatform
      ARM: ux500: build hotplug.o for ARMv7-a
      Merge tag 'bcm2835-for-3.10-multiplatform' of git://git.kernel.org/.../swarren/linux-rpi into next/multiplatform
      Merge tag 'v3.9-rc3' into next/multiplatform
      Merge tag 'ux500-multiplatform-asoc' of git://git.kernel.org/.../linusw/linux-stericsson into next/multiplatform
      Merge branch 'mxs/cleanup' into next/multiplatform
      Merge tag 'mxs-multiplatform-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/multiplatform
      Merge branch 'tegra/soc' into next/multiplatform
      Merge tag 'tegra-for-3.10-multiplatform' of git://git.kernel.org/.../swarren/linux-tegra into next/multiplatform
      ARM: tegra: build assembly files with -march=armv7-a
      ARM: exynos: introduce EXYNOS_ATAGS symbol
      ARM: exynos: prepare for sparse IRQ
      ARM: exynos: move debug-macro.S to include/debug/
      ARM: samsung: move mfc device definition to s5p-dev-mfc.c
      mmc: sdhci-s3c: remove platform dependencies
      thermal/exynos: remove unnecessary header inclusions
      mtd: onenand/samsung: make regs-onenand.h file local
      rtc: s3c: make header file local
      ARM: exynos: enable multiplatform support
      Merge branch 'samsung/exynos-multiplatform' into next/multiplatform

Linus Walleij (13):
      ARM: nomadik: delete IRQ header
      ARM: nomadik: move debugmacro to debug includes
      ARM: nomadik: convert to multiplatform
      ARM: nomadik: delete remnant include files
      mfd: prcmu: pass a base and size with the early initcall
      mfd: db8500-prcmu: get base address from resource
      ARM: ux500: move PM-related PRCMU functions to machine
      mfd: db8500-prcmu: drop unused includes
      ARM: ux500: move debugmacro to debug includes
      ARM: ux500: make debug macro stand-alone
      clk: ux500: pass clock base adresses in init call
      ARM: ux500: get rid of <mach/[hardware|db8500-regs].h>
      clocksource: nomadik-mtu: fix up clocksource/timer

Mark Brown (1):
      mmc: sdhci-s3c: Fix operation on non-single image Samsung platforms

Olof Johansson (3):
      Revert "ARM: exynos: enable multiplatform support"
      Merge branch 'samsung/exynos-multiplatform' into next/multiplatform
      Merge branch 'clksrc/cleanup' into next/multiplatform

Paul Bolle (1):
      ARM: SPEAr13xx: Fix typo "ARCH_HAVE_CPUFREQ"

Shawn Guo (3):
      ARM: mxs: call mxs_pm_init() as a machine_desc hook
      ARM: mxs: rename debug-macro.S for multiplatform build
      ARM: mxs: enable multiplatform build

Stephen Boyd (1):
      ARM: Push selects for TWD/SCU into machine entries

Stephen Warren (3):
      ARM: bcm2835: convert to multi-platform
      ARM: tegra: move <mach/powergate.h> to <linux/tegra-powergate.h>
      ARM: tegra: convert to multi-platform

Tony Prisk (1):
      arm: vt8500: Add wm8850 config options to multi_v7_defconfig


 arch/arm/Kconfig                                | 135 +-------
 arch/arm/Kconfig.debug                          |  39 +++
 arch/arm/Makefile                               |   5 +-
 arch/arm/configs/bcm2835_defconfig              |   2 +
 arch/arm/configs/cns3420vb_defconfig            |   3 +
 arch/arm/configs/multi_v7_defconfig             |  23 ++
 arch/arm/configs/mxs_defconfig                  |   2 +-
 arch/arm/configs/nhk8815_defconfig              |  42 ++-
 arch/arm/configs/spear3xx_defconfig             |   2 +
 arch/arm/configs/spear6xx_defconfig             |   1 +
 .../debug-macro.S => include/debug/bcm2835.S}   |   3 +-
 .../debug-macro.S => include/debug/cns3xxx.S}   |   0
 .../debug-macro.S => include/debug/exynos.S}    |  12 +-
 .../mach/debug-macro.S => include/debug/mxs.S}  |   0
 .../debug-macro.S => include/debug/nomadik.S}   |   0
 .../debug-macro.S => include/debug/samsung.S}   |   0
 .../mach/uart.h => include/debug/sirf.S}        |  29 +-
 arch/arm/include/debug/ux500.S                  |  48 +++
 arch/arm/mach-bcm2835/Kconfig                   |  15 +
 arch/arm/mach-bcm2835/Makefile.boot             |   1 -
 arch/arm/mach-bcm2835/bcm2835.c                 |   6 +-
 .../arm/mach-bcm2835/include/mach/bcm2835_soc.h |  29 --
 arch/arm/mach-bcm2835/include/mach/gpio.h       |   1 -
 arch/arm/mach-bcm2835/include/mach/timex.h      |  26 --
 arch/arm/mach-bcm2835/include/mach/uncompress.h |  44 ---
 arch/arm/mach-cns3xxx/Kconfig                   |  12 +
 arch/arm/mach-cns3xxx/Makefile                  |   8 +-
 arch/arm/mach-cns3xxx/cns3420vb.c               |   6 +-
 .../mach-cns3xxx/{include/mach => }/cns3xxx.h   |   7 +-
 arch/arm/mach-cns3xxx/core.c                    | 121 ++++++-
 arch/arm/mach-cns3xxx/devices.c                 |   5 +-
 arch/arm/mach-cns3xxx/include/mach/irqs.h       |  24 --
 arch/arm/mach-cns3xxx/include/mach/timex.h      |  12 -
 arch/arm/mach-cns3xxx/include/mach/uncompress.h |  53 ----
 arch/arm/mach-cns3xxx/pcie.c                    |   2 +-
 arch/arm/mach-cns3xxx/pm.c                      |   4 +-
 arch/arm/mach-cns3xxx/{include/mach => }/pm.h   |   0
 arch/arm/mach-exynos/Kconfig                    |  17 +
 arch/arm/mach-exynos/dev-uart.c                 |   1 +
 arch/arm/mach-exynos/include/mach/irqs.h        |   5 +-
 arch/arm/mach-exynos/mach-armlex4210.c          |   1 +
 arch/arm/mach-exynos/mach-nuri.c                |   1 +
 arch/arm/mach-exynos/mach-origen.c              |   1 +
 arch/arm/mach-exynos/mach-smdk4x12.c            |   1 +
 arch/arm/mach-exynos/mach-smdkv310.c            |   1 +
 arch/arm/mach-exynos/setup-sdhci-gpio.c         |   2 +-
 arch/arm/mach-highbank/Kconfig                  |   1 +
 arch/arm/mach-imx/Kconfig                       |   3 +-
 arch/arm/mach-msm/Kconfig                       |   7 +-
 arch/arm/mach-mxs/Kconfig                       |  22 +-
 arch/arm/mach-mxs/Makefile                      |   2 +-
 arch/arm/mach-mxs/Makefile.boot                 |   1 -
 arch/arm/mach-mxs/include/mach/timex.h          |  21 --
 arch/arm/mach-mxs/include/mach/uncompress.h     |  76 -----
 arch/arm/mach-mxs/mach-mxs.c                    |   3 +
 arch/arm/mach-mxs/pm.c                          |   4 +-
 arch/arm/mach-mxs/pm.h                          |  14 +
 arch/arm/mach-nomadik/Kconfig                   |  25 +-
 arch/arm/mach-nomadik/Makefile.boot             |   4 -
 arch/arm/mach-nomadik/cpu-8815.c                |   1 -
 arch/arm/mach-nomadik/include/mach/irqs.h       |  79 -----
 arch/arm/mach-nomadik/include/mach/timex.h      |   6 -
 arch/arm/mach-nomadik/include/mach/uncompress.h |  60 ----
 arch/arm/mach-omap2/Kconfig                     |   2 +
 arch/arm/mach-prima2/Kconfig                    |  13 +
 arch/arm/mach-prima2/Makefile                   |   5 +-
 arch/arm/mach-prima2/common.c                   |  26 +-
 arch/arm/mach-prima2/common.h                   |   4 +-
 arch/arm/mach-prima2/include/mach/clkdev.h      |  15 -
 arch/arm/mach-prima2/include/mach/debug-macro.S |  29 --
 arch/arm/mach-prima2/include/mach/entry-macro.S |  22 --
 arch/arm/mach-prima2/include/mach/hardware.h    |  15 -
 arch/arm/mach-prima2/include/mach/irqs.h        |  17 -
 arch/arm/mach-prima2/include/mach/map.h         |  18 --
 arch/arm/mach-prima2/include/mach/timex.h       |  14 -
 arch/arm/mach-prima2/include/mach/uncompress.h  |  41 ---
 arch/arm/mach-prima2/irq.c                      | 129 --------
 arch/arm/mach-prima2/lluart.c                   |  14 +-
 arch/arm/mach-prima2/platsmp.c                  |   1 -
 arch/arm/mach-realview/Kconfig                  |   8 +
 .../arm/mach-s3c24xx/include/mach/debug-macro.S |   2 +-
 .../arm/mach-s3c64xx/include/mach/debug-macro.S |   2 +-
 .../arm/mach-s5p64x0/include/mach/debug-macro.S |   2 +-
 .../arm/mach-s5pc100/include/mach/debug-macro.S |   2 +-
 arch/arm/mach-s5pc100/setup-sdhci-gpio.c        |   1 -
 .../arm/mach-s5pv210/include/mach/debug-macro.S |   2 +-
 arch/arm/mach-s5pv210/setup-sdhci-gpio.c        |   1 -
 arch/arm/mach-spear/Kconfig                     | 105 ++++++
 arch/arm/mach-spear/Makefile                    |  26 ++
 .../Makefile.boot                               |   0
 .../include/mach => mach-spear}/generic.h       |  30 +-
 .../{mach-spear13xx => mach-spear}/headsmp.S    |   0
 .../{mach-spear13xx => mach-spear}/hotplug.c    |   0
 .../include/mach}/debug-macro.S                 |   0
 .../include/mach/irqs.h                         |  22 +-
 .../include/mach/misc_regs.h                    |   2 +-
 arch/arm/mach-spear/include/mach/spear.h        |  95 ++++++
 .../plat => mach-spear/include/mach}/timex.h    |   0
 .../include/mach}/uncompress.h                  |   0
 arch/arm/{plat-spear => mach-spear}/pl080.c     |   0
 .../include/plat => mach-spear}/pl080.h         |   0
 .../{mach-spear13xx => mach-spear}/platsmp.c    |   2 +-
 arch/arm/{plat-spear => mach-spear}/restart.c   |   5 +-
 .../{mach-spear13xx => mach-spear}/spear1310.c  |   4 +-
 .../{mach-spear13xx => mach-spear}/spear1340.c  |   5 +-
 .../mach/dma.h => mach-spear/spear13xx-dma.h}   |   0
 .../{mach-spear13xx => mach-spear}/spear13xx.c  |   9 +-
 .../{mach-spear3xx => mach-spear}/spear300.c    |   4 +-
 .../{mach-spear3xx => mach-spear}/spear310.c    |   4 +-
 .../{mach-spear3xx => mach-spear}/spear320.c    |   7 +-
 .../{mach-spear3xx => mach-spear}/spear3xx.c    |  17 +-
 .../{mach-spear6xx => mach-spear}/spear6xx.c    |  25 +-
 arch/arm/{plat-spear => mach-spear}/time.c      |   2 +-
 arch/arm/mach-spear13xx/Kconfig                 |  20 --
 arch/arm/mach-spear13xx/Makefile                |  10 -
 .../mach-spear13xx/include/mach/debug-macro.S   |  14 -
 arch/arm/mach-spear13xx/include/mach/hardware.h |   1 -
 arch/arm/mach-spear13xx/include/mach/irqs.h     |  20 --
 arch/arm/mach-spear13xx/include/mach/spear.h    |  54 ----
 arch/arm/mach-spear13xx/include/mach/timex.h    |  19 --
 .../mach-spear13xx/include/mach/uncompress.h    |  19 --
 arch/arm/mach-spear3xx/Kconfig                  |  26 --
 arch/arm/mach-spear3xx/Makefile                 |  15 -
 arch/arm/mach-spear3xx/Makefile.boot            |   3 -
 .../mach-spear3xx/include/mach/debug-macro.S    |  14 -
 arch/arm/mach-spear3xx/include/mach/generic.h   |  36 ---
 arch/arm/mach-spear3xx/include/mach/hardware.h  |   1 -
 arch/arm/mach-spear3xx/include/mach/irqs.h      |  19 --
 arch/arm/mach-spear3xx/include/mach/spear.h     |  60 ----
 arch/arm/mach-spear3xx/include/mach/timex.h     |  19 --
 .../arm/mach-spear3xx/include/mach/uncompress.h |  19 --
 arch/arm/mach-spear6xx/Kconfig                  |  10 -
 arch/arm/mach-spear6xx/Makefile                 |   6 -
 arch/arm/mach-spear6xx/Makefile.boot            |   3 -
 .../mach-spear6xx/include/mach/debug-macro.S    |  14 -
 arch/arm/mach-spear6xx/include/mach/generic.h   |  23 --
 arch/arm/mach-spear6xx/include/mach/hardware.h  |   1 -
 arch/arm/mach-spear6xx/include/mach/misc_regs.h |  22 --
 arch/arm/mach-spear6xx/include/mach/spear.h     |  46 ---
 arch/arm/mach-spear6xx/include/mach/timex.h     |  19 --
 .../arm/mach-spear6xx/include/mach/uncompress.h |  19 --
 arch/arm/mach-tegra/Kconfig                     |  29 +-
 arch/arm/mach-tegra/Makefile                    |   2 +
 arch/arm/mach-tegra/Makefile.boot               |   3 -
 arch/arm/mach-tegra/board.h                     |   1 +
 arch/arm/mach-tegra/common.c                    |   2 -
 arch/arm/mach-tegra/include/mach/timex.h        |  26 --
 arch/arm/mach-tegra/include/mach/uncompress.h   | 175 ----------
 arch/arm/mach-tegra/pcie.c                      |   3 +-
 arch/arm/mach-tegra/powergate.c                 |   3 +-
 arch/arm/mach-ux500/Kconfig                     |  16 +
 arch/arm/mach-ux500/Makefile                    |   4 +-
 arch/arm/mach-ux500/board-mop500-audio.c        |   7 +-
 arch/arm/mach-ux500/board-mop500-pins.c         |   2 -
 arch/arm/mach-ux500/board-mop500-sdi.c          |   4 +-
 arch/arm/mach-ux500/board-mop500-u8500uib.c     |   9 +-
 arch/arm/mach-ux500/board-mop500-uib.c          |   1 -
 arch/arm/mach-ux500/board-mop500.c              |  66 +---
 arch/arm/mach-ux500/board-mop500.h              |   4 +-
 arch/arm/mach-ux500/cache-l2x0.c                |   2 +-
 arch/arm/mach-ux500/cpu-db8500.c                |  12 +-
 arch/arm/mach-ux500/cpu.c                       |  33 +-
 arch/arm/mach-ux500/cpuidle.c                   |   5 +-
 .../mach-ux500/{include/mach => }/db8500-regs.h |  28 ++
 arch/arm/mach-ux500/devices-common.c            |   3 +-
 arch/arm/mach-ux500/devices-db8500.c            |   8 +-
 arch/arm/mach-ux500/devices-db8500.h            |   3 +-
 arch/arm/mach-ux500/devices.c                   |   5 +-
 .../arm/mach-ux500/{include/mach => }/devices.h |   0
 arch/arm/mach-ux500/hotplug.c                   |   2 +-
 arch/arm/mach-ux500/id.c                        |   4 +-
 arch/arm/mach-ux500/include/mach/debug-macro.S  |  39 ---
 arch/arm/mach-ux500/include/mach/hardware.h     |  47 ---
 arch/arm/mach-ux500/include/mach/timex.h        |   6 -
 arch/arm/mach-ux500/include/mach/uncompress.h   |  57 ----
 .../{include/mach => }/irqs-board-mop500.h      |   0
 .../mach-ux500/{include/mach => }/irqs-db8500.h |  25 --
 arch/arm/mach-ux500/{include/mach => }/irqs.h   |   6 +-
 arch/arm/mach-ux500/platsmp.c                   |   4 +-
 arch/arm/mach-ux500/pm.c                        | 167 ++++++++++
 arch/arm/mach-ux500/{include/mach => }/setup.h  |   0
 arch/arm/mach-ux500/timer.c                     |   6 +-
 arch/arm/mach-ux500/usb.c                       |   2 +-
 arch/arm/mach-vexpress/Kconfig                  |   2 +
 arch/arm/mach-zynq/Kconfig                      |   2 +
 arch/arm/plat-samsung/devs.c                    |  45 ---
 arch/arm/plat-samsung/include/plat/sdhci.h      |  56 +---
 arch/arm/plat-samsung/irq-vic-timer.c           |   1 +
 arch/arm/plat-samsung/pm.c                      |   1 +
 arch/arm/plat-samsung/s5p-dev-mfc.c             |  42 ++-
 arch/arm/plat-samsung/s5p-irq.c                 |   1 +
 arch/arm/plat-spear/Kconfig                     |  47 ---
 arch/arm/plat-spear/Makefile                    |   9 -
 drivers/clk/spear/spear1310_clock.c             |  64 ++--
 drivers/clk/spear/spear1340_clock.c             |  63 ++--
 drivers/clk/spear/spear3xx_clock.c              |  60 ++--
 drivers/clk/spear/spear6xx_clock.c              |  31 +-
 drivers/clk/tegra/clk-tegra30.c                 |   3 +-
 drivers/clk/ux500/clk-prcc.c                    |   1 -
 drivers/clk/ux500/u8500_clk.c                   | 142 ++++-----
 drivers/clocksource/Makefile                    |   2 +
 drivers/clocksource/clksrc-dbx500-prcmu.c       |   3 -
 drivers/clocksource/nomadik-mtu.c               |   4 +-
 .../clocksource}/timer-marco.c                  |  25 +-
 .../clocksource}/timer-prima2.c                 |  42 +--
 drivers/crypto/ux500/cryp/cryp.c                |   2 -
 drivers/crypto/ux500/cryp/cryp_core.c           |   1 -
 drivers/crypto/ux500/hash/hash_core.c           |   1 -
 drivers/irqchip/Makefile                        |   1 +
 drivers/irqchip/irq-sirfsoc.c                   | 126 ++++++++
 drivers/mfd/db8500-prcmu.c                      | 316 +++++++++----------
 drivers/mfd/dbx500-prcmu-regs.h                 | 204 ++++++------
 drivers/mmc/host/sdhci-cns3xxx.c                |   1 -
 .../mmc/host/sdhci-s3c-regs.h                   |   0
 drivers/mmc/host/sdhci-s3c.c                    |   5 +-
 drivers/mtd/onenand/samsung.c                   |   4 +-
 .../mtd/onenand/samsung.h                       |   2 -
 drivers/pinctrl/pinctrl-sirf.c                  |  12 +-
 drivers/rtc/rtc-s3c.c                           |   3 +-
 .../plat/regs-rtc.h => drivers/rtc/rtc-s3c.h    |   3 +-
 drivers/staging/ste_rmi4/Makefile               |   1 -
 .../ste_rmi4/board-mop500-u8500uib-rmi4.c       |  31 --
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c   |  31 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h   |   1 -
 drivers/thermal/exynos_thermal.c                |   2 -
 include/linux/mfd/db8500-prcmu.h                |  10 +-
 include/linux/mfd/dbx500-prcmu.h                |  38 +--
 include/linux/platform_data/arm-ux500-pm.h      |  21 ++
 .../linux/platform_data/asoc-ux500-msp.h        |   0
 include/linux/platform_data/clk-ux500.h         |   3 +-
 include/linux/platform_data/mmc-sdhci-s3c.h     |  56 ++++
 .../linux/tegra-powergate.h                     |   5 -
 sound/soc/ux500/mop500_ab8500.c                 |   2 -
 sound/soc/ux500/ux500_msp_dai.c                 |   4 +-
 sound/soc/ux500/ux500_msp_i2s.c                 |   4 +-
 sound/soc/ux500/ux500_msp_i2s.h                 |   2 -
 236 files changed, 1834 insertions(+), 2887 deletions(-)
 rename arch/arm/{mach-bcm2835/include/mach/debug-macro.S => include/debug/bcm2835.S} (86%)
 rename arch/arm/{mach-cns3xxx/include/mach/debug-macro.S => include/debug/cns3xxx.S} (100%)
 rename arch/arm/{mach-exynos/include/mach/debug-macro.S => include/debug/exynos.S} (84%)
 rename arch/arm/{mach-mxs/include/mach/debug-macro.S => include/debug/mxs.S} (100%)
 rename arch/arm/{mach-nomadik/include/mach/debug-macro.S => include/debug/nomadik.S} (100%)
 rename arch/arm/{plat-samsung/include/plat/debug-macro.S => include/debug/samsung.S} (100%)
 rename arch/arm/{mach-prima2/include/mach/uart.h => include/debug/sirf.S} (55%)
 create mode 100644 arch/arm/include/debug/ux500.S
 create mode 100644 arch/arm/mach-bcm2835/Kconfig
 delete mode 100644 arch/arm/mach-bcm2835/Makefile.boot
 delete mode 100644 arch/arm/mach-bcm2835/include/mach/bcm2835_soc.h
 delete mode 100644 arch/arm/mach-bcm2835/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-bcm2835/include/mach/timex.h
 delete mode 100644 arch/arm/mach-bcm2835/include/mach/uncompress.h
 rename arch/arm/mach-cns3xxx/{include/mach => }/cns3xxx.h (99%)
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/uncompress.h
 rename arch/arm/mach-cns3xxx/{include/mach => }/pm.h (100%)
 delete mode 100644 arch/arm/mach-mxs/Makefile.boot
 delete mode 100644 arch/arm/mach-mxs/include/mach/timex.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-mxs/pm.h
 delete mode 100644 arch/arm/mach-nomadik/Makefile.boot
 delete mode 100644 arch/arm/mach-nomadik/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-nomadik/include/mach/timex.h
 delete mode 100644 arch/arm/mach-nomadik/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-prima2/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-prima2/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/map.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/timex.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-prima2/irq.c
 create mode 100644 arch/arm/mach-spear/Kconfig
 create mode 100644 arch/arm/mach-spear/Makefile
 rename arch/arm/{mach-spear13xx => mach-spear}/Makefile.boot (100%)
 rename arch/arm/{mach-spear13xx/include/mach => mach-spear}/generic.h (57%)
 rename arch/arm/{mach-spear13xx => mach-spear}/headsmp.S (100%)
 rename arch/arm/{mach-spear13xx => mach-spear}/hotplug.c (100%)
 rename arch/arm/{plat-spear/include/plat => mach-spear/include/mach}/debug-macro.S (100%)
 rename arch/arm/{mach-spear6xx => mach-spear}/include/mach/irqs.h (51%)
 rename arch/arm/{mach-spear3xx => mach-spear}/include/mach/misc_regs.h (90%)
 create mode 100644 arch/arm/mach-spear/include/mach/spear.h
 rename arch/arm/{plat-spear/include/plat => mach-spear/include/mach}/timex.h (100%)
 rename arch/arm/{plat-spear/include/plat => mach-spear/include/mach}/uncompress.h (100%)
 rename arch/arm/{plat-spear => mach-spear}/pl080.c (100%)
 rename arch/arm/{plat-spear/include/plat => mach-spear}/pl080.h (100%)
 rename arch/arm/{mach-spear13xx => mach-spear}/platsmp.c (99%)
 rename arch/arm/{plat-spear => mach-spear}/restart.c (90%)
 rename arch/arm/{mach-spear13xx => mach-spear}/spear1310.c (95%)
 rename arch/arm/{mach-spear13xx => mach-spear}/spear1340.c (99%)
 rename arch/arm/{mach-spear13xx/include/mach/dma.h => mach-spear/spear13xx-dma.h} (100%)
 rename arch/arm/{mach-spear13xx => mach-spear}/spear13xx.c (96%)
 rename arch/arm/{mach-spear3xx => mach-spear}/spear300.c (98%)
 rename arch/arm/{mach-spear3xx => mach-spear}/spear310.c (98%)
 rename arch/arm/{mach-spear3xx => mach-spear}/spear320.c (97%)
 rename arch/arm/{mach-spear3xx => mach-spear}/spear3xx.c (88%)
 rename arch/arm/{mach-spear6xx => mach-spear}/spear6xx.c (93%)
 rename arch/arm/{plat-spear => mach-spear}/time.c (99%)
 delete mode 100644 arch/arm/mach-spear13xx/Kconfig
 delete mode 100644 arch/arm/mach-spear13xx/Makefile
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/spear.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-spear3xx/Kconfig
 delete mode 100644 arch/arm/mach-spear3xx/Makefile
 delete mode 100644 arch/arm/mach-spear3xx/Makefile.boot
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/generic.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/spear.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-spear6xx/Kconfig
 delete mode 100644 arch/arm/mach-spear6xx/Makefile
 delete mode 100644 arch/arm/mach-spear6xx/Makefile.boot
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/generic.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/misc_regs.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/spear.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-tegra/Makefile.boot
 delete mode 100644 arch/arm/mach-tegra/include/mach/timex.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/uncompress.h
 rename arch/arm/mach-ux500/{include/mach => }/db8500-regs.h (88%)
 rename arch/arm/mach-ux500/{include/mach => }/devices.h (100%)
 delete mode 100644 arch/arm/mach-ux500/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-ux500/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/uncompress.h
 rename arch/arm/mach-ux500/{include/mach => }/irqs-board-mop500.h (100%)
 rename arch/arm/mach-ux500/{include/mach => }/irqs-db8500.h (83%)
 rename arch/arm/mach-ux500/{include/mach => }/irqs.h (93%)
 create mode 100644 arch/arm/mach-ux500/pm.c
 rename arch/arm/mach-ux500/{include/mach => }/setup.h (100%)
 delete mode 100644 arch/arm/plat-spear/Kconfig
 delete mode 100644 arch/arm/plat-spear/Makefile
 rename {arch/arm/mach-prima2 => drivers/clocksource}/timer-marco.c (94%)
 rename {arch/arm/mach-prima2 => drivers/clocksource}/timer-prima2.c (90%)
 create mode 100644 drivers/irqchip/irq-sirfsoc.c
 rename arch/arm/plat-samsung/include/plat/regs-sdhci.h => drivers/mmc/host/sdhci-s3c-regs.h (100%)
 rename arch/arm/plat-samsung/include/plat/regs-onenand.h => drivers/mtd/onenand/samsung.h (98%)
 rename arch/arm/plat-samsung/include/plat/regs-rtc.h => drivers/rtc/rtc-s3c.h (97%)
 delete mode 100644 drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c
 create mode 100644 include/linux/platform_data/arm-ux500-pm.h
 rename arch/arm/mach-ux500/include/mach/msp.h => include/linux/platform_data/asoc-ux500-msp.h (100%)
 create mode 100644 include/linux/platform_data/mmc-sdhci-s3c.h
 rename arch/arm/mach-tegra/include/mach/powergate.h => include/linux/tegra-powergate.h (92%)
