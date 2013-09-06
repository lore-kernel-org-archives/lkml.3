Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3IFTOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:14:12 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55523 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3IFTM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:12:58 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 2/5] ARM: SoC cleanups for 3.12
Date: Fri,  6 Sep 2013 12:10:02 -0700
Message-Id: <1378494605-14990-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1378494605-14990-1-git-send-email-olof@lixom.net>
References: <1378494605-14990-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains code cleanups, moves and removals for 3.12.

There's a large number of various cleanups, and a nice net removal of
13500 lines of code.

Highlights worth mentioning are:

- A series of patches from Stephen Boyd removing the ARM local timer API.
- Move of Qualcomm MSM IOMMU code to drivers/iommu.
- Samsung PWM driver cleanups from Tomasz Figa, removing legacy PWM driver
and switching over to the drivers/pwm one.
- Removal of some unusued auto-generated headers for OMAP2+ (PRM/CM).

There's also a move of a header file out of include/linux/i2c/ to
platform_data, where it really belongs. It touches mostly ARM platform
code for include changes so we took it through our tree.

Conflicts:

Kconfig.debug: Keep the new debug/msm.S file from branch, the rest have
been moved or deleted in rmk's cleanup that you already merged.

----------------------------------------------------------------

The following changes since commit ba99e38939eb3fcd1c889af53d9db19674d3ef58:

  Merge tag 'fixes-nc-for-linus' into test-merge

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-linus

for you to fetch changes up to 7323f219533e01cc075ba45a76f3e5b214adb23f:

  ARM: OMAP2+: Add back the define for AM33XX_RST_GLOBAL_WARM_SW_MASK

----------------------------------------------------------------

Bartlomiej Zolnierkiewicz (1):
      ARM: exynos4_defconfig: remove obsolete exynos4_defconfig

Guennadi Liakhovetski (1):
      ARM: shmobile: armadillo800eva: remove left-overs

Jingoo Han (1):
      ARM: SAMSUNG: Remove unnecessary exynos4_default_sdhci*()

Julia Lawall (1):
      tegra: simplify use of devm_ioremap_resource

Kevin Hilman (5):
      Merge branch 'msm/cleanup' into next/cleanup
      Merge tag 'omap-for-v3.12/usb-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'zynq-cleanup-for-3.12' of git://git.xilinx.com/linux-xlnx into next/cleanup
      Merge tag 'tegra-for-3.12-cleanup' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge tag 'samsung-cleanup-1' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup

Kukjin Kim (1):
      irqchip: exynos: cleanup non-DT stuff in exynos-combiner

Kuninori Morimoto (2):
      ARM: shmobile: r8a7778: add __initdata on resource and device data
      ARM: shmobile: r8a7778: remove r8a7778_init_irq()

Lee Jones (5):
      ARM: dts: Remove '0x's from Exynos4210 DTSI file
      ARM: dts: Remove '0x's from Exynos4x12 DTSI file
      ARM: dts: Remove '0x's from Exynos5250 DTS file
      ARM: dts: Remove '0x's from Exynos5420 DTS file
      ARM: dts: Remove '0x's from Exynos5440 DTS file

Magnus Damm (15):
      ARM: shmobile: sh73a0 pinmux platform device cleanup
      ARM: shmobile: ape6evm: Remove init_irq declaration in machine description
      ARM: shmobile: lager: Remove init_irq declaration in machine description
      ARM: shmobile: kzm9g: Remove init_irq declaration in machine description
      ARM: shmobile: Remove unused EMEV2 auxdata and callback
      ARM: shmobile: Remove unused r8a7740 auxdata table
      ARM: shmobile: Remove unused r8a7778 auxdata and callback
      ARM: shmobile: Remove unused r8a7779 auxdata table
      ARM: shmobile: Remove unused sh7372 auxdata table
      ARM: shmobile: Remove unused sh73a0 auxdata table
      ARM: shmobile: Remove redundant r8a7790 callback
      ARM: shmobile: Remove unused EMEV2/KZM9D early console
      ARM: shmobile: Make EMEV2 platform devices more compact
      ARM: shmobile: Fix EMEV2 clock comment typo
      ARM: shmobile: Remove unused mach/dma.h

Maxime Ripard (4):
      ARM: shmobile: emev2: Remove init_irq declaration in machine description
      ARM: shmobile: r8a73a4: Remove init_irq declaration in machine description
      ARM: shmobile: r8a7790: Remove init_irq declaration in machine description
      ARM: shmobile: sh73a0: Remove init_irq declaration in machine description

Olof Johansson (7):
      Merge tag 'remove-local-timers' of git://git.kernel.org/.../davidb/linux-msm into next/cleanup
      ARM: imx: fix mismerge of localtimer code
      Merge tag 'renesas-cleanup-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'omap-for-v3.12/cleanup-unused-defines' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'v3.12-pwm-cleanup-for-olof' of git://github.com/tom3q/linux into next/cleanup
      Merge tag 'soc-3.12' of git://git.infradead.org/linux-mvebu into next/cleanup
      Merge tag 'samsung-defconfig-v2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup

Rajendra Nayak (4):
      ARM: OMAP2: PRM/CM: Cleanup unused header
      ARM: OMAP3: PRM/CM: Cleanup unused header
      ARM: OMAP4: PRM/CM: Cleanup unused header
      ARM: OMAP5: PRM/CM: Cleanup unused header

Rohit Vaswani (1):
      ARM: msm: Remove unused and unmapped MSM_TLMM_BASE for 8x60

Sachin Kamat (1):
      ARM: EXYNOS: Cleanup common.h file

Soren Brinkmann (4):
      arm: zynq: slcr: Remove redundant header #includes
      arm: zynq: slcr: Clean up #defines
      arm: zynq: slcr: Use read-modify-write for register writes
      arm: zynq: hotplug: Remove unreachable code

Stephen Boyd (19):
      Merge branch 'timers/core' of git://git.kernel.org/.../tip/tip into remove-local-timers
      ARM: smp: Remove duplicate dummy timer implementation
      ARM: smp_twd: Divorce smp_twd from local timer API
      ARM: OMAP2+: Divorce from local timer API
      ARM: EXYNOS4: Divorce mct from local timer API
      ARM: PRIMA2: Divorce timer-marco from local timer API
      ARM: msm: Divorce msm_timer from local timer API
      clocksource: time-armada-370-xp: Fix sparse warning
      clocksource: time-armada-370-xp: Divorce from local timer API
      ARM: smp: Remove local timer API
      ARM: msm: Don't compile __msm_ioremap_caller() unless used
      ARM: OMAP2+: Fix fallout from localtimer divorce and SMP=n
      ARM: msm: Move debug-macro.S to include/debug
      ARM: msm: Remove TMR and TMR0 static mappings
      ARM: msm: Migrate msm_timer to CLOCKSOURCE_OF_DECLARE
      ARM: msm: Move mach/board.h contents to common.h
      ARM: msm: Remove devices-iommu.c
      iommu/msm: Move mach includes to iommu directory
      ARM: msm: Only compile io.c on platforms that use it

Sudeep KarkadaNagesha (1):
      ARM: mach-mvebu: remove redundant DT parsing and validation

Tomasz Figa (20):
      clocksource: samsung_pwm_timer: Do not request PWM mem region
      clocksource: samsung_pwm_timer: Correct definition of AUTORELOAD bit
      clocksource: samsung_pwm_timer: Cache clocksource register address
      clocksource: samsung_pwm_timer: Do not use clocksource_mmio
      clocksource: samsung_pwm_timer: Handle suspend/resume correctly
      ARM: SAMSUNG: Unify base address definitions of timer block
      ARM: SAMSUNG: Add new PWM platform device
      ARM: SAMSUNG: Set PWM platform data
      ARM: SAMSUNG: Move all platforms to new clocksource driver
      ARM: SAMSUNG: Remove old samsung-time driver
      ARM: SAMSUNG: Remove unused PWM timer IRQ chip code
      pwm: samsung: Rename to pwm-samsung-legacy
      pwm: Add new pwm-samsung driver
      ARM: SAMSUNG: Rework private data handling in dev-backlight
      ARM: SAMSUNG: Modify board files to use new PWM platform device
      pwm: Remove superseded pwm-samsung-legacy driver
      ARM: SAMSUNG: Remove old PWM timer platform devices
      ARM: SAMSUNG: Remove pwm-clock infrastructure
      ARM: SAMSUNG: Remove remaining uses of plat/regs-timer.h header
      ARM: SAMSUNG: Remove plat/regs-timer.h header

Tony Lindgren (2):
      Merge tag 'for-v3.11-rc/omap-fixes-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.12/cleanup
      ARM: OMAP2+: Add back the define for AM33XX_RST_GLOBAL_WARM_SW_MASK

Vivien Didelot (1):
      gpio: (gpio-pca953x) move header to linux/platform_data/


 arch/arm/Kconfig                                |   24 +-
 arch/arm/Kconfig.debug                          |    9 +-
 arch/arm/boot/dts/exynos4210.dtsi               |    2 +-
 arch/arm/boot/dts/exynos4x12.dtsi               |    2 +-
 arch/arm/boot/dts/exynos5250.dtsi               |   14 +-
 arch/arm/boot/dts/exynos5420.dtsi               |    2 +-
 arch/arm/boot/dts/exynos5440.dtsi               |    2 +-
 arch/arm/configs/exynos4_defconfig              |   68 -
 arch/arm/include/asm/localtimer.h               |   34 -
 .../mach/debug-macro.S => include/debug/msm.S}  |   32 +-
 arch/arm/kernel/smp.c                           |   87 -
 arch/arm/kernel/smp_twd.c                       |   64 +-
 arch/arm/mach-at91/board-snapper9260.c          |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c         |    2 +-
 arch/arm/mach-ep93xx/vision_ep9307.c            |    2 +-
 arch/arm/mach-exynos/common.h                   |   43 -
 arch/arm/mach-highbank/Kconfig                  |    2 +-
 arch/arm/mach-imx/Kconfig                       |    2 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |    2 +-
 arch/arm/mach-imx/mach-mxt_td60.c               |    2 +-
 arch/arm/mach-ks8695/board-acs5k.c              |    2 +-
 arch/arm/mach-mmp/ttc_dkb.c                     |    2 +-
 arch/arm/mach-msm/Makefile                      |    9 +-
 arch/arm/mach-msm/board-dt-8660.c               |    4 +-
 arch/arm/mach-msm/board-dt-8960.c               |    3 +-
 arch/arm/mach-msm/board-halibut.c               |    1 -
 arch/arm/mach-msm/board-mahimahi.c              |    2 +-
 arch/arm/mach-msm/board-msm7x30.c               |    1 -
 arch/arm/mach-msm/board-qsd8x50.c               |    1 -
 arch/arm/mach-msm/board-sapphire.c              |    2 +-
 arch/arm/mach-msm/board-trout.c                 |    1 -
 arch/arm/mach-msm/board-trout.h                 |    2 +-
 arch/arm/mach-msm/common.h                      |   18 +-
 arch/arm/mach-msm/devices-iommu.c               |  912 ------
 arch/arm/mach-msm/devices-msm7x30.c             |    2 +-
 arch/arm/mach-msm/devices-qsd8x50.c             |    2 +-
 arch/arm/mach-msm/include/mach/board.h          |   38 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |   46 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |   53 -
 arch/arm/mach-msm/include/mach/msm_iomap.h      |   17 -
 arch/arm/mach-msm/include/mach/uncompress.h     |   63 -
 arch/arm/mach-msm/io.c                          |   67 +-
 arch/arm/mach-msm/timer.c                       |  141 +-
 arch/arm/mach-mvebu/platsmp.c                   |   19 +-
 arch/arm/mach-omap2/Kconfig                     |    3 +-
 arch/arm/mach-omap2/board-am3517evm.c           |    2 +-
 arch/arm/mach-omap2/cm-regbits-24xx.h           |  318 ---
 arch/arm/mach-omap2/cm-regbits-33xx.h           |  749 -----
 arch/arm/mach-omap2/cm-regbits-34xx.h           |  632 ----
 arch/arm/mach-omap2/cm-regbits-44xx.h           | 1558 ----------
 arch/arm/mach-omap2/cm-regbits-54xx.h           | 1633 -----------
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c      |    1 -
 arch/arm/mach-omap2/powerdomains54xx_data.c     |    1 -
 arch/arm/mach-omap2/prm-regbits-24xx.h          |  247 --
 arch/arm/mach-omap2/prm-regbits-33xx.h          |  307 +-
 arch/arm/mach-omap2/prm-regbits-34xx.h          |  481 ----
 arch/arm/mach-omap2/prm-regbits-44xx.h          | 2226 ---------------
 arch/arm/mach-omap2/prm-regbits-54xx.h          | 2701 ------------------
 arch/arm/mach-omap2/timer.c                     |    6 +-
 arch/arm/mach-pxa/cm-x300.c                     |    2 +-
 arch/arm/mach-pxa/em-x270.c                     |    2 +-
 arch/arm/mach-pxa/pcm990-baseboard.c            |    2 +-
 arch/arm/mach-pxa/spitz.c                       |    2 +-
 arch/arm/mach-pxa/zeus.c                        |    2 +-
 arch/arm/mach-pxa/zylonite_pxa300.c             |    2 +-
 arch/arm/mach-realview/Kconfig                  |    8 +-
 arch/arm/mach-s3c24xx/Kconfig                   |    6 -
 arch/arm/mach-s3c24xx/clock-s3c2410.c           |    1 -
 arch/arm/mach-s3c24xx/clock-s3c2412.c           |    1 -
 arch/arm/mach-s3c24xx/clock-s3c2416.c           |    2 -
 arch/arm/mach-s3c24xx/clock-s3c2443.c           |    2 -
 arch/arm/mach-s3c24xx/common.c                  |   27 +
 arch/arm/mach-s3c24xx/include/mach/map.h        |    2 +
 arch/arm/mach-s3c24xx/mach-h1940.c              |    4 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c             |    5 +-
 arch/arm/mach-s3c64xx/Kconfig                   |    2 -
 arch/arm/mach-s3c64xx/clock.c                   |    2 -
 arch/arm/mach-s3c64xx/common.c                  |   32 +-
 arch/arm/mach-s3c64xx/include/mach/irqs.h       |    8 -
 arch/arm/mach-s3c64xx/include/mach/map.h        |    1 +
 arch/arm/mach-s3c64xx/irq-pm.c                  |    2 -
 arch/arm/mach-s3c64xx/mach-crag6410.c           |    6 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                |    4 +-
 arch/arm/mach-s3c64xx/mach-smartq.c             |    4 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c           |    5 +-
 arch/arm/mach-s5p64x0/Kconfig                   |    2 -
 arch/arm/mach-s5p64x0/clock-s5p6440.c           |    2 -
 arch/arm/mach-s5p64x0/clock-s5p6450.c           |    2 -
 arch/arm/mach-s5p64x0/common.c                  |   27 +
 arch/arm/mach-s5p64x0/include/mach/irqs.h       |    2 -
 arch/arm/mach-s5p64x0/include/mach/map.h        |    1 +
 arch/arm/mach-s5p64x0/mach-smdk6440.c           |    5 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c           |    5 +-
 arch/arm/mach-s5p64x0/pm.c                      |    3 -
 arch/arm/mach-s5pc100/Kconfig                   |    1 -
 arch/arm/mach-s5pc100/clock.c                   |    2 -
 arch/arm/mach-s5pc100/common.c                  |   28 +
 arch/arm/mach-s5pc100/include/mach/irqs.h       |    2 -
 arch/arm/mach-s5pc100/include/mach/map.h        |    1 +
 arch/arm/mach-s5pc100/mach-smdkc100.c           |    5 +-
 arch/arm/mach-s5pv210/Kconfig                   |    1 -
 arch/arm/mach-s5pv210/clock.c                   |    1 -
 arch/arm/mach-s5pv210/common.c                  |   28 +
 arch/arm/mach-s5pv210/include/mach/irqs.h       |    2 -
 arch/arm/mach-s5pv210/include/mach/map.h        |    1 +
 arch/arm/mach-s5pv210/mach-smdkv210.c           |    5 +-
 arch/arm/mach-s5pv210/pm.c                      |   10 -
 arch/arm/mach-shmobile/board-ape6evm.c          |    2 -
 arch/arm/mach-shmobile/board-armadillo800eva.c  |    9 -
 arch/arm/mach-shmobile/board-kzm9d.c            |    2 +-
 arch/arm/mach-shmobile/board-kzm9g-reference.c  |    2 -
 arch/arm/mach-shmobile/board-lager.c            |    2 -
 arch/arm/mach-shmobile/clock-emev2.c            |    2 +-
 arch/arm/mach-shmobile/include/mach/dma.h       |    1 -
 arch/arm/mach-shmobile/include/mach/emev2.h     |    2 +-
 arch/arm/mach-shmobile/include/mach/r8a7778.h   |    1 -
 arch/arm/mach-shmobile/setup-emev2.c            |  353 +--
 arch/arm/mach-shmobile/setup-r8a73a4.c          |    2 -
 arch/arm/mach-shmobile/setup-r8a7740.c          |   16 +-
 arch/arm/mach-shmobile/setup-r8a7778.c          |   72 +-
 arch/arm/mach-shmobile/setup-r8a7779.c          |    7 +-
 arch/arm/mach-shmobile/setup-r8a7790.c          |    7 -
 arch/arm/mach-shmobile/setup-sh7372.c           |    7 +-
 arch/arm/mach-shmobile/setup-sh73a0.c           |   34 +-
 arch/arm/mach-spear/Kconfig                     |    2 +-
 arch/arm/mach-tegra/Kconfig                     |    2 +-
 arch/arm/mach-ux500/Kconfig                     |    2 +-
 arch/arm/mach-vexpress/Kconfig                  |    2 +-
 arch/arm/mach-zynq/Kconfig                      |    2 +-
 arch/arm/mach-zynq/hotplug.c                    |   55 +-
 arch/arm/mach-zynq/slcr.c                       |   45 +-
 arch/arm/plat-samsung/Kconfig                   |   14 -
 arch/arm/plat-samsung/Makefile                  |    3 -
 arch/arm/plat-samsung/dev-backlight.c           |   61 +-
 arch/arm/plat-samsung/devs.c                    |   42 +-
 arch/arm/plat-samsung/include/plat/clock.h      |    4 -
 arch/arm/plat-samsung/include/plat/devs.h       |    1 +
 .../plat-samsung/include/plat/irq-vic-timer.h   |   13 -
 arch/arm/plat-samsung/include/plat/irqs.h       |    9 -
 arch/arm/plat-samsung/include/plat/pwm-clock.h  |   81 -
 arch/arm/plat-samsung/include/plat/pwm-core.h   |   22 +
 arch/arm/plat-samsung/include/plat/regs-timer.h |  124 -
 .../plat-samsung/include/plat/samsung-time.h    |   23 -
 arch/arm/plat-samsung/include/plat/sdhci.h      |   38 -
 arch/arm/plat-samsung/irq-vic-timer.c           |   98 -
 arch/arm/plat-samsung/pwm-clock.c               |  474 ---
 arch/arm/plat-samsung/s5p-irq.c                 |    4 -
 arch/arm/plat-samsung/samsung-time.c            |  394 ---
 arch/x86/platform/mrst/mrst.c                   |    2 +-
 drivers/clocksource/Kconfig                     |    1 -
 drivers/clocksource/exynos_mct.c                |   58 +-
 drivers/clocksource/samsung_pwm_timer.c         |  108 +-
 drivers/clocksource/time-armada-370-xp.c        |   92 +-
 drivers/clocksource/timer-marco.c               |   98 +-
 drivers/gpio/gpio-pca953x.c                     |    2 +-
 drivers/iommu/msm_iommu.c                       |    4 +-
 .../mach/iommu.h => drivers/iommu/msm_iommu.h   |    0
 drivers/iommu/msm_iommu_dev.c                   |    4 +-
 .../iommu/msm_iommu_hw-8xxx.h                   |    0
 drivers/iommu/tegra-smmu.c                      |    2 -
 drivers/irqchip/exynos-combiner.c               |   44 +-
 drivers/memory/tegra20-mc.c                     |    2 -
 drivers/memory/tegra30-mc.c                     |    2 -
 drivers/pwm/pwm-samsung.c                       |  709 +++--
 drivers/video/msm/msm_fb.c                      |    1 -
 include/clocksource/samsung_pwm.h               |    7 +
 include/linux/{i2c => platform_data}/pca953x.h  |    0
 include/linux/time-armada-370-xp.h              |    4 +-
 168 files changed, 1312 insertions(+), 14806 deletions(-)
 delete mode 100644 arch/arm/configs/exynos4_defconfig
 delete mode 100644 arch/arm/include/asm/localtimer.h
 rename arch/arm/{mach-msm/include/mach/debug-macro.S => include/debug/msm.S} (61%)
 delete mode 100644 arch/arm/mach-msm/devices-iommu.c
 delete mode 100644 arch/arm/mach-msm/include/mach/board.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8960.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
 delete mode 100644 arch/arm/mach-msm/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-omap2/prm-regbits-54xx.h
 delete mode 100644 arch/arm/mach-shmobile/include/mach/dma.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/irq-vic-timer.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/pwm-clock.h
 create mode 100644 arch/arm/plat-samsung/include/plat/pwm-core.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-timer.h
 delete mode 100644 arch/arm/plat-samsung/irq-vic-timer.c
 delete mode 100644 arch/arm/plat-samsung/pwm-clock.c
 delete mode 100644 arch/arm/plat-samsung/samsung-time.c
 rename arch/arm/mach-msm/include/mach/iommu.h => drivers/iommu/msm_iommu.h (100%)
 rename arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h => drivers/iommu/msm_iommu_hw-8xxx.h (100%)
 rename include/linux/{i2c => platform_data}/pca953x.h (100%)
