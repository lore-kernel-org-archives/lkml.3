Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3KKFdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:33:40 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33970 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3KKFc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:32:58 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 2/6] ARM: SoC cleanups for 3.13
Date: Sun, 10 Nov 2013 21:29:32 -0800
Message-Id: <1384147776-18735-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1384147776-18735-1-git-send-email-olof@lixom.net>
References: <1384147776-18735-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains code cleanups, moves and removals for 3.13.

Qualcomm msm targets had a bunch of code removal for legacy non-DT
platforms. Nomadik saw more device tree conversions and cleanup of old
code. Tegra has some code refactoring, etc.

One longish patch series from Sebastian Hasselbarth changes the init_time
hooks and tries to use a generic implementation for most platforms,
since they were all doing more or less the same things.

Finally the "shark" platform is removed in this release. It's been
abandoned for a while and nobody seems to care enough to keep it
around. If someone comes along and wants to resurrect it, the removal
can easily be reverted and code brought back.

Beyond this, mostly a bunch of removals of stale content across the
board, etc.


Conflicts:
* MAINTAINERS:
  Add/remove: Keep rockchip, remove Shark
* drivers/clk/clk-nomadik:
  Remove the HEAD-side of the conflict, keep the CLK_OF_DECLARE(). A patch
  was applied doubly (once as a base for our clock cleanup, and once as a fix
  in the clk tree) so it causes conflicts.

----------------------------------------------------------------

The following changes since commit 1dd43029ab3124bd136eadd4169e73f339194a2e:

  Merge branch 'fixes-non-critical' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-linus

for you to fetch changes up to f3372c01816ec9e974e449cf7233408a31647dd3:

  ARM: gemini: convert to GENERIC_CLOCKEVENTS

----------------------------------------------------------------

Bartlomiej Zolnierkiewicz (3):
      ARM: at91: cam60: fix incorrect placement of __initdata tag
      ARM: shmobile: ape6evm: fix incorrect placement of __initdata tag
      ARM: EXYNOS: remove CONFIG_MACH_EXYNOS[4, 5]_DT config options

Boris BREZILLON (2):
      ARM: at91/dt: split sam9x5 peripheral definitions
      ARM: at91/dt: split sama5d3 peripheral definitions

Jingoo Han (1):
      ARM: EXYNOS: remove unnecessary header inclusions from exynos4/5 dt machine file

Kevin Hilman (4):
      Merge tag 'renesas-cleanup2-for-v3.13' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'msm-cleanup-for-3.13' of git://git.kernel.org/.../davidb/linux-msm into next/cleanup
      Merge tag 'tegra-for-3.13-cleanup' of git://git.kernel.org/.../tegra/linux into next/cleanup
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup

Kumar Gala (1):
      ARM: msm: Rename msm devicetrees to have standard 'qcom' prefix

Kuninori Morimoto (3):
      ARM: shmobile: r8a7778: cleanup registration of vin
      ARM: shmobile: r8a7778: cleanup registration of sh_eth
      ARM: shmobile: r8a7778: r8a7778_register_hspi() become static

Laurent Pinchart (2):
      ARM: shmobile: r8a7790: Constify platform data and resources
      ARM: shmobile: lager: Constify platform data and resources

Linus Walleij (11):
      ARM: delete mach-shark
      MAINTAINERS: delete Shark machine entry
      clk: nomadik: set all timers to use 2.4 MHz TIMCLK
      ARM: nomadik: register VMMC regulator
      ARM: nomadik: delete MMCI platform data
      ARM: nomadik: delete FSMC platform data
      block: drop dependency on ARCH_SHARK
      ide: drop dependency on ARCH_SHARK
      input: i8042: drop dependency on ARCH_SHARK
      video: drop code for ARCH_SHARK in cyber2000fb
      ARM: gemini: convert to GENERIC_CLOCKEVENTS

Magnus Damm (2):
      ARM: shmobile: Rename to r8a73a4_init_early()
      ARM: shmobile: Rename to r8a7790_init_early()

Mark Brown (2):
      MAINTAINERS: Add DTS files to patterns for Samsung platform
      MAINTAINERS: Add patterns for DTS files for AT91

Matt Porter (1):
      ARM: bcm: provide common arch init for DT clocks

Nicolas Ferre (1):
      ARM: at91: remove init_machine() as default is suitable

Olof Johansson (8):
      Merge tag 'for-arm-soc' of git://git.kernel.org/.../linusw/linux-nomadik into next/cleanup
      Merge tag 'del-shark-for-v3.13' of git://git.kernel.org/.../linusw/linux-stericsson into next/cleanup
      Merge branch 'clk-of-init-v2_for-3.13' of https://github.com/shesselba/linux-dove into next/cleanup
      Merge tag 'renesas-fixes5-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-cleanup-for-v3.13' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'samsung-cleanup' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'samsung-maintainer' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'omap-for-v3.13/cm-scm-cleanup-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup

Rohit Vaswani (1):
      ARM: msm: Create a common board-dt and config ARCH_MSM_DT

Sebastian Hesselbarth (28):
      Merge tag 'tegra-for-3.13-deps-for-arm-init-time-cleanup' of git://git.kernel.org/.../swarren/linux-tegra into clk-of-init-v2_for-3.13
      ARM: nomadik: remove mtu initalization from .init_time
      clk: nomadik: move src init out of nomadik_clk_init
      clk: nomadik: declare OF clock provider
      clk: prima2: declare OF clock provider
      ARM: socfgpa: prepare for arch-wide .init_time callback
      clk: sunxi: declare OF clock provider
      clk: vt8500: parse pmc_base from clock driver
      ARM: vt8500: prepare for arch-wide .init_time callback
      ARM: call of_clk_init from default time_init handler
      ARM: bcm2835: remove custom .init_time hook
      ARM: dove: remove custom .init_time hook
      ARM: exynos: remove custom .init_time hook
      ARM: highbank: remove custom .init_time hook
      ARM: imx: remove custom .init_time hook
      ARM: kirkwood: remove custom .init_time hook
      ARM: mxs: remove custom .init_time hook
      ARM: nomadik: remove custom .init_time hook
      ARM: nspire: remove custom .init_time hook
      ARM: prima2: remove custom .init_time hook
      ARM: rockchip: remove custom .init_time hook
      ARM: socfpga: remove custom .init_time hook
      ARM: sti: remove custom .init_time hook
      ARM: sunxi: remove custom .init_time hook
      ARM: tegra: remove custom .init_time hook
      ARM: vexpress: remove custom .init_time hook
      ARM: vt8500: remove custom .init_time hook
      clk: nomadik: fix missing __init on nomadik_src_init

Stephen Boyd (3):
      ARM: msm: Remove irqs-*.h files for DT based targets
      ARM: clps711x: Use linux/sched_clock.h
      ARM: Remove temporary sched_clock.h header

Stephen Warren (8):
      ARM: tegra: split tegra_pmc_init() in two
      ARM: tegra: remove common.c
      ARM: tegra: delete stale header content
      ARM: tegra: delete gpio-names.h
      ARM: tegra: move resume vector define to irammap.h
      ARM: tegra: remove much of iomap.h
      ARM: tegra: make tegra_init_fuse() __init
      ARM: tegra: fix ARCH_TEGRA_114_SOC select sort order

Tero Kristo (5):
      ARM: OMAP2: CM/PM: remove direct register accesses outside CM code
      ARM: OMAP3: clock: add API to enable/disable autoidle for a single clock
      ARM: OMAP3: McBSP: do not access CM register directly
      ARM: OMAP3: CM/control: move CM scratchpad save to CM driver
      ARM: OMAP3: control: add API for setting IVA bootmode

Tomasz Figa (5):
      ARM: S3C64XX: Move if ARCH_S3C64XX statement into mach-s3c64xx
      gpio: samsung: Use CONFIG_ARCH_S3C64XX to check for S3C64XX support
      s3c-camif: Use CONFIG_ARCH_S3C64XX to check for S3C64XX support
      ASoC: samsung: Use CONFIG_ARCH_S3C64XX to check for S3C64XX support
      ARM: S3C64XX: Kill CONFIG_PLAT_S3C64XX

Tony Lindgren (1):
      Merge tag 'for-v3.13/cm-scm-cleanup-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.13/cm-scm-cleanup

Uwe Kleine-König (1):
      ARM: drop explicit selection of HAVE_CLK and CLKDEV_LOOKUP


 MAINTAINERS                                     |  11 +-
 arch/arm/Kconfig                                |  39 +--
 arch/arm/Makefile                               |   1 -
 arch/arm/boot/compressed/Makefile               |   4 -
 arch/arm/boot/compressed/head-shark.S           | 140 ----------
 arch/arm/boot/compressed/ofw-shark.c            | 260 -----------------
 arch/arm/boot/dts/Makefile                      |   4 +-
 arch/arm/boot/dts/at91sam9g25.dtsi              |   2 +
 arch/arm/boot/dts/at91sam9g35.dtsi              |   1 +
 arch/arm/boot/dts/at91sam9x25.dtsi              |  24 +-
 arch/arm/boot/dts/at91sam9x35.dtsi              |   1 +
 arch/arm/boot/dts/at91sam9x5.dtsi               |  67 -----
 arch/arm/boot/dts/at91sam9x5_macb0.dtsi         |  56 ++++
 arch/arm/boot/dts/at91sam9x5_macb1.dtsi         |  44 +++
 arch/arm/boot/dts/at91sam9x5_usart3.dtsi        |  51 ++++
 .../{msm8660-surf.dts => qcom-msm8660-surf.dts} |   0
 .../{msm8960-cdp.dts => qcom-msm8960-cdp.dts}   |   0
 arch/arm/boot/dts/sama5d3.dtsi                  | 203 --------------
 arch/arm/boot/dts/sama5d31.dtsi                 |  16 ++
 arch/arm/boot/dts/sama5d31ek.dts                |   3 +-
 arch/arm/boot/dts/sama5d33.dtsi                 |  14 +
 arch/arm/boot/dts/sama5d33ek.dts                |   3 +-
 arch/arm/boot/dts/sama5d34.dtsi                 |  16 ++
 arch/arm/boot/dts/sama5d34ek.dts                |   3 +-
 arch/arm/boot/dts/sama5d35.dtsi                 |  18 ++
 arch/arm/boot/dts/sama5d35ek.dts                |   3 +-
 arch/arm/boot/dts/sama5d3_can.dtsi              |  54 ++++
 arch/arm/boot/dts/sama5d3_emac.dtsi             |  44 +++
 arch/arm/boot/dts/sama5d3_gmac.dtsi             |  77 ++++++
 arch/arm/boot/dts/sama5d3_lcd.dtsi              |  55 ++++
 arch/arm/boot/dts/sama5d3_mci2.dtsi             |  47 ++++
 arch/arm/boot/dts/sama5d3_tcb1.dtsi             |  27 ++
 arch/arm/boot/dts/sama5d3_uart.dtsi             |  53 ++++
 arch/arm/boot/dts/sama5d3xcm.dtsi               |   1 -
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi      |  12 +-
 arch/arm/common/Makefile                        |   1 -
 arch/arm/common/via82c505.c                     |  83 ------
 arch/arm/configs/shark_defconfig                |  80 ------
 arch/arm/include/asm/mach/pci.h                 |   4 -
 arch/arm/include/asm/sched_clock.h              |   4 -
 arch/arm/kernel/time.c                          |  29 +-
 arch/arm/lib/Makefile                           |   1 -
 arch/arm/lib/io-shark.c                         |  13 -
 arch/arm/mach-at91/board-cam60.c                |   2 +-
 arch/arm/mach-at91/board-dt-rm9200.c            |   7 -
 arch/arm/mach-at91/board-dt-sam9.c              |   7 -
 arch/arm/mach-bcm/board_bcm281xx.c              |   1 -
 arch/arm/mach-bcm2835/bcm2835.c                 |   2 -
 arch/arm/mach-clps711x/common.c                 |   2 +-
 arch/arm/mach-dove/board-dt.c                   |  11 -
 arch/arm/mach-exynos/Kconfig                    |  38 +--
 arch/arm/mach-exynos/Makefile                   |   4 +-
 arch/arm/mach-exynos/common.c                   |   8 -
 arch/arm/mach-exynos/common.h                   |   1 -
 arch/arm/mach-exynos/mach-exynos4-dt.c          |   5 -
 arch/arm/mach-exynos/mach-exynos5-dt.c          |   5 -
 arch/arm/mach-gemini/time.c                     |  97 ++++++-
 arch/arm/mach-highbank/Kconfig                  |   1 -
 arch/arm/mach-highbank/highbank.c               |  23 +-
 arch/arm/mach-imx/Kconfig                       |  10 +-
 arch/arm/mach-imx/clk-imx51-imx53.c             |  29 +-
 arch/arm/mach-imx/common.h                      |   4 -
 arch/arm/mach-imx/imx51-dt.c                    |   6 -
 arch/arm/mach-imx/mach-imx53.c                  |   6 -
 arch/arm/mach-imx/mach-imx6q.c                  |  14 +-
 arch/arm/mach-imx/mach-imx6sl.c                 |   7 -
 arch/arm/mach-imx/mach-vf610.c                  |   9 -
 arch/arm/mach-kirkwood/board-dt.c               |   8 -
 arch/arm/mach-msm/Kconfig                       |  13 +-
 arch/arm/mach-msm/Makefile                      |   3 +-
 arch/arm/mach-msm/board-dt-8660.c               |  48 ----
 .../mach-msm/{board-dt-8960.c => board-dt.c}    |  17 +-
 arch/arm/mach-msm/include/mach/irqs-8960.h      | 277 -------------------
 arch/arm/mach-msm/include/mach/irqs-8x60.h      | 258 -----------------
 arch/arm/mach-msm/include/mach/irqs.h           |   5 -
 arch/arm/mach-mxs/mach-mxs.c                    |  13 -
 arch/arm/mach-nomadik/cpu-8815.c                |  71 +----
 arch/arm/mach-nspire/nspire.c                   |   9 -
 arch/arm/mach-omap2/Kconfig                     |   9 +-
 arch/arm/mach-omap2/clkt2xxx_apll.c             |   4 +-
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c         |  11 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c    |  24 +-
 arch/arm/mach-omap2/clock.c                     |  38 +++
 arch/arm/mach-omap2/clock.h                     |   2 +
 arch/arm/mach-omap2/cm2xxx.c                    |  67 +++++
 arch/arm/mach-omap2/cm2xxx.h                    |   8 +
 arch/arm/mach-omap2/cm3xxx.c                    |  22 ++
 arch/arm/mach-omap2/cm3xxx.h                    |   1 +
 arch/arm/mach-omap2/control.c                   |  54 +---
 arch/arm/mach-omap2/control.h                   |   1 +
 arch/arm/mach-omap2/mcbsp.c                     |  16 +-
 arch/arm/mach-omap2/pm24xx.c                    |  24 +-
 arch/arm/mach-omap2/pm34xx.c                    |   3 +-
 arch/arm/mach-prima2/common.c                   |  11 -
 arch/arm/mach-prima2/common.h                   |   1 -
 arch/arm/mach-rockchip/rockchip.c               |   9 -
 arch/arm/mach-s3c64xx/Kconfig                   |  13 +-
 arch/arm/mach-shark/Makefile                    |  10 -
 arch/arm/mach-shark/Makefile.boot               |   2 -
 arch/arm/mach-shark/core.c                      | 146 ----------
 arch/arm/mach-shark/dma.c                       |  23 --
 arch/arm/mach-shark/include/mach/debug-macro.S  |  34 ---
 arch/arm/mach-shark/include/mach/entry-macro.S  |  36 ---
 arch/arm/mach-shark/include/mach/framebuffer.h  |  16 --
 arch/arm/mach-shark/include/mach/hardware.h     |  16 --
 arch/arm/mach-shark/include/mach/irqs.h         |  13 -
 arch/arm/mach-shark/include/mach/isa-dma.h      |  13 -
 arch/arm/mach-shark/include/mach/memory.h       |  26 --
 arch/arm/mach-shark/include/mach/timex.h        |   7 -
 arch/arm/mach-shark/include/mach/uncompress.h   |  50 ----
 arch/arm/mach-shark/irq.c                       | 108 --------
 arch/arm/mach-shark/leds.c                      | 117 --------
 arch/arm/mach-shark/pci.c                       |  57 ----
 .../arm/mach-shmobile/board-ape6evm-reference.c |   2 +-
 arch/arm/mach-shmobile/board-ape6evm.c          |   4 +-
 arch/arm/mach-shmobile/board-bockw.c            |  46 ++-
 arch/arm/mach-shmobile/board-lager-reference.c  |   2 +-
 arch/arm/mach-shmobile/board-lager.c            |  16 +-
 arch/arm/mach-shmobile/include/mach/r8a73a4.h   |   2 +-
 arch/arm/mach-shmobile/include/mach/r8a7778.h   |   3 -
 arch/arm/mach-shmobile/include/mach/r8a7790.h   |   2 +-
 arch/arm/mach-shmobile/setup-r8a73a4.c          |   4 +-
 arch/arm/mach-shmobile/setup-r8a7778.c          |  50 +---
 arch/arm/mach-shmobile/setup-r8a7790.c          |  25 +-
 arch/arm/mach-socfpga/Kconfig                   |   1 -
 arch/arm/mach-socfpga/socfpga.c                 |   2 -
 arch/arm/mach-spear/Kconfig                     |   2 -
 arch/arm/mach-sti/board-dt.c                    |  10 +-
 arch/arm/mach-sunxi/sunxi.c                     |  10 -
 arch/arm/mach-tegra/Kconfig                     |   4 +-
 arch/arm/mach-tegra/Makefile                    |   1 -
 arch/arm/mach-tegra/board-paz00.c               |   5 +-
 arch/arm/mach-tegra/board-paz00.h               |  25 --
 arch/arm/mach-tegra/board.h                     |  12 -
 arch/arm/mach-tegra/common.c                    | 115 --------
 arch/arm/mach-tegra/fuse.c                      |   2 +-
 arch/arm/mach-tegra/gpio-names.h                | 247 -----------------
 arch/arm/mach-tegra/iomap.h                     | 152 ----------
 arch/arm/mach-tegra/irammap.h                   |   6 +
 arch/arm/mach-tegra/pm.c                        |   8 +-
 arch/arm/mach-tegra/pm.h                        |   3 -
 arch/arm/mach-tegra/pmc.c                       |  50 ++--
 arch/arm/mach-tegra/pmc.h                       |   5 +
 arch/arm/mach-tegra/reset.c                     |   2 +-
 arch/arm/mach-tegra/sleep-tegra20.S             |   5 +-
 arch/arm/mach-tegra/sleep-tegra30.S             |   5 +-
 arch/arm/mach-tegra/tegra.c                     |  72 ++++-
 arch/arm/mach-u300/Kconfig                      |   1 -
 arch/arm/mach-ux500/Kconfig                     |  29 +-
 arch/arm/mach-vexpress/Kconfig                  |   2 -
 arch/arm/mach-vexpress/v2m.c                    |  14 +-
 arch/arm/mach-vt8500/Kconfig                    |   1 -
 arch/arm/mach-vt8500/common.h                   |  24 --
 arch/arm/mach-vt8500/vt8500.c                   |   6 -
 drivers/block/Kconfig                           |   2 +-
 drivers/clk/clk-bcm2835.c                       |   8 -
 drivers/clk/clk-highbank.c                      |  10 +-
 drivers/clk/clk-nomadik.c                       | 187 ++++++-------
 drivers/clk/clk-prima2.c                        |  29 +-
 drivers/clk/clk-vt8500.c                        |  34 ++-
 drivers/clk/mxs/clk-imx23.c                     |  15 +-
 drivers/clk/mxs/clk-imx28.c                     |  16 +-
 drivers/clk/sunxi/clk-sunxi.c                   |  11 +-
 drivers/gpio/gpio-samsung.c                     |   8 +-
 drivers/ide/Kconfig                             |   4 +-
 drivers/input/serio/Kconfig                     |   2 +-
 drivers/media/platform/Kconfig                  |   2 +-
 drivers/video/cyber2000fb.c                     |  70 -----
 include/linux/clk/mxs.h                         |   2 -
 include/linux/clk/sunxi.h                       |  22 --
 include/linux/platform_data/clk-nomadik.h       |   2 -
 sound/soc/samsung/s3c-i2s-v2.c                  |   6 +-
 172 files changed, 1317 insertions(+), 3672 deletions(-)
 delete mode 100644 arch/arm/boot/compressed/head-shark.S
 delete mode 100644 arch/arm/boot/compressed/ofw-shark.c
 create mode 100644 arch/arm/boot/dts/at91sam9x5_macb0.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_macb1.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_usart3.dtsi
 rename arch/arm/boot/dts/{msm8660-surf.dts => qcom-msm8660-surf.dts} (100%)
 rename arch/arm/boot/dts/{msm8960-cdp.dts => qcom-msm8960-cdp.dts} (100%)
 create mode 100644 arch/arm/boot/dts/sama5d31.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d33.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d34.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d35.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_can.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_emac.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_gmac.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_lcd.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_mci2.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_tcb1.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_uart.dtsi
 delete mode 100644 arch/arm/common/via82c505.c
 delete mode 100644 arch/arm/configs/shark_defconfig
 delete mode 100644 arch/arm/include/asm/sched_clock.h
 delete mode 100644 arch/arm/lib/io-shark.c
 delete mode 100644 arch/arm/mach-msm/board-dt-8660.c
 rename arch/arm/mach-msm/{board-dt-8960.c => board-dt.c} (64%)
 delete mode 100644 arch/arm/mach-msm/include/mach/irqs-8960.h
 delete mode 100644 arch/arm/mach-msm/include/mach/irqs-8x60.h
 delete mode 100644 arch/arm/mach-shark/Makefile
 delete mode 100644 arch/arm/mach-shark/Makefile.boot
 delete mode 100644 arch/arm/mach-shark/core.c
 delete mode 100644 arch/arm/mach-shark/dma.c
 delete mode 100644 arch/arm/mach-shark/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-shark/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-shark/include/mach/framebuffer.h
 delete mode 100644 arch/arm/mach-shark/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-shark/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-shark/include/mach/isa-dma.h
 delete mode 100644 arch/arm/mach-shark/include/mach/memory.h
 delete mode 100644 arch/arm/mach-shark/include/mach/timex.h
 delete mode 100644 arch/arm/mach-shark/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-shark/irq.c
 delete mode 100644 arch/arm/mach-shark/leds.c
 delete mode 100644 arch/arm/mach-shark/pci.c
 delete mode 100644 arch/arm/mach-tegra/board-paz00.h
 delete mode 100644 arch/arm/mach-tegra/common.c
 delete mode 100644 arch/arm/mach-tegra/gpio-names.h
 delete mode 100644 arch/arm/mach-vt8500/common.h
 delete mode 100644 include/linux/clk/sunxi.h
 delete mode 100644 include/linux/platform_data/clk-nomadik.h
