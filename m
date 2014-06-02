Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbaFBVjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:39:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41499 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaFBViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:38:04 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=202/7=5D=20ARM=3A=20SoC=20cleanups=20for=203=2E16?=
Date: Mon,  2 Jun 2014 14:04:05 -0700
Message-Id: <1401743050-7379-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401743050-7379-1-git-send-email-olof@lixom.net>
References: <1401743050-7379-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanups for 3.16. Among these are:

- A bunch of misc cleanups for Broadcom platforms, mostly housekeeping
- Enabling Common Clock Framework on the older s3c24xx Samsung chipsets
- Cleanup of the Versatile Express system controller code, moving it to syscon
- Power management cleanups for OMAP platforms

+ a handful of other cleanups across the place

----------------------------------------------------------------

The following changes since commit 0ff1a200b4f6b06066f675b0ef5ab595bc24692b:

  Merge tag 'fixes-for-3.16' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-3.16

for you to fetch changes up to 08d38bebb4dcd6414944f8277ea5ea30010664fe:

  ARM: kconfig: allow PCI support to be selected with ARCH_MULTIPLATFORM

----------------------------------------------------------------

Alex Elder (11):
      ARM: bcm: clean up config and build targets
      ARM: bcm: use memory accessors for ioremapped area
      ARM: bcm: err, don't BUG() on SMC init failures
      ARM: bcm: clean up SMC code
      ARM: bcm: have bcm_kona_smc() return request result
      ARM: bcm: don't special-case CPU 0 in bcm_kona_smc()
      ARM: bcm: config option for l2 cache support
      ARM: bcm: tidy up a few includes
      ARM: bcm: use inline assembly for "smc" request
      ARM: bcm: rewrite commentary for bcm_kona_do_smc()
      ARM: bcm: rename "kona.h" and "kona.c"

Arnd Bergmann (3):
      leds: Fix build for LEDS_CLASS=m on versatile
      Merge tag 'for-3.16/bcm-cleanup' of git://github.com/broadcom/mach-bcm into next/cleanup
      ARM: vexpress: refine dependencies for new code

Bin Shi (2):
      clocksource: prima2: fix some minor checkpatch issues
      irqchip: sirf: fix one minor checkpatch issue

Geert Uytterhoeven (4):
      ARM: shmobile: armadillo800eva: Spelling and grammar
      ARM: shmobile: r8a7740: Remove unused r8a7740_add_early_devices_dt()
      ARM: shmobile: sh7372: Call sh7372_add_early_devices() instead of open coding
      ARM: shmobile: r8a7740: Make r8a7740_meram_workaround() __init

Heiko Stuebner (26):
      clk: samsung: add pll_6552 variant for s3c2416
      clk: samsung: add plls used by the s3c2443
      dt-bindings: add binding for clock-controller of s3c2443 and following
      clk: samsung: add clock-driver for s3c2416, s3c2443 and s3c2450
      ARM: S3C24XX: prevent conflicts between ccf and non-ccf s3c24xx-socs
      ARM: dts: add clock data for s3c2416
      ARM: S3C24XX: Convert s3c2416 and s3c2443 to common clock framework
      ARM: S3C24XX: only store clock registers when old clock code is active
      clk: samsung: add plls used by the early s3c24xx cpus
      dt-bindings: add documentation for s3c2412 clock controller
      clk: samsung: add clock controller driver for s3c2412
      ARM: S3C24XX: convert s3c2412 to common clock framework
      ARM: S3C24XX: cpufreq-utils: don't write raw values to MPLLCON when using ccf
      clk: samsung: add clock driver for external clock outputs
      ARM: S3C24XX: enable usage of common dclk if common clock framework is enabled
      dt-bindings: add documentation for s3c2410 clock controller
      clk: samsung: add clock controller driver for s3c2410, s3c2440 and s3c2442
      ARM: S3C24XX: add platform code for conversion to the common clock framework
      ARM: S3C24XX: convert s3c2440 and s3c2442 to common clock framework
      ARM: S3C24XX: convert s3c2410 to common clock framework
      ARM: S3C24XX: remove legacy clock code
      ARM: S3C24XX: remove SAMSUNG_CLOCK remnants after ccf conversion
      ARM: compressed/head.S: remove s3c24xx special case
      ARM: S3C24XX: trim down debug uart handling
      ARM: S3C24XX: use generic DEBUG_UART_PHY/_VIRT in debug macro
      ARM: S3C24XX: move debug-macro.S into the common space

Heiko Stübner (1):
      clk: samsung: clk-s3c2410-dlck: do not use PNAME macro as it declares __initdata

Jonghwan Choi (1):
      cpufreq: exynos: Fix the compile error

Kukjin Kim (2):
      ARM: S3C24XX: fix merge conflict
      Merge branch 'v3.16-next/clk-s3c24xx-3' into v3.16-next/cleanup-samsung

Leela Krishna Amudala (1):
      ARM: EXYNOS: use v7_exit_coherency_flush macro for cache disabling

Linus Walleij (3):
      ARM: plat-versatile: convert LEDs to platform device
      ARM/leds: move ARM Versatile LED driver to leds subsystem
      ARM: plat-versatile: update defconfigs for Versatile LEDs

Olof Johansson (9):
      Merge tag 'versatile-leds' of git://git.kernel.org/.../linusw/linux-integrator into next/cleanup
      Merge tag 'kconfig-cleanups' of git://git.kernel.org/.../robh/linux into next/cleanup
      Merge tag 'renesas-cleanup-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'sirf-soc-for-3.16' of git://git.kernel.org/.../baohua/linux into next/cleanup
      Merge tag 'vexpress/updates-for-3.16' of git://git.linaro.org/people/pawel.moll/linux into next/cleanup
      Merge tag 's3c24xx-clk' of http://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'omap-for-v3.16/prcm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      clk: samsung: fix build error
      Merge tag 'samsung-cleanup' of http://git.kernel.org/.../kgene/linux-samsung into next/cleanup

Pawel Moll (8):
      of: Keep track of populated platform devices
      mfd: vexpress: Convert custom func API to regmap
      mfd: syscon: Add platform data with a regmap config name
      mfd: vexpress: Define the device as MFD cells
      clk: versatile: Split config options for sp810 and vexpress_osc
      clocksource: Sched clock source for Versatile Express
      ARM: vexpress: Simplify SMP operations for DT-powered system
      ARM: vexpress: move HBI check to sysreg driver

Rob Herring (3):
      ARM: mvebu: clean-up unneeded kconfig selects
      ARM: bcm: clean-up unneeded kconfig selects
      ARM: qcom: clean-up unneeded kconfig selects

Russell King (1):
      ARM: plat-versatile: LEDs initialise to off state

Sachin Kamat (4):
      ARM: EXYNOS: Remove duplicate lines in Makefile
      ARM: EXYNOS: Remove exynos_subsys registration
      ARM: EXYNOS: Migrate Exynos specific macros from plat to mach
      ARM: EXYNOS: Remove unnecessary inclusion of cpu.h

Sudeep KarkadaNagesha (1):
      ARM: vexpress: remove redundant vexpress_dt_cpus_num to get cpu count

Tero Kristo (10):
      ARM: OMAP3: CM: remove a few OMAP34XX_CM_REGADDR defines
      ARM: OMAP2+: prcm: add omap_test_timeout to prcm-common.h
      ARM: OMAP2/3: CM: remove some external dependencies
      ARM: OMAP4: CM: use cm_base* in register address calculations
      ARM: OMAP2+: PRCM: cleanup some header includes
      ARM: OMAP2+: PRM: remove unnecessary cpu_is_XXX calls from prm_init / exit
      ARM: OMAP3/4: PRM: provide io chain reconfig function through irq setup
      ARM: OMAP3/OMAP4: PRM: add prm_features flags and add IO wakeup under it
      ARM: OMAP3/4: PRM: add support of late_init call to prm_ll_ops
      ARM: OMAP4: PRCM: remove references to cm-regbits-44xx.h from PRCM core files

Tony Lindgren (1):
      Merge tag 'for-v3.16/prcm-cleanup-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.16/prcm

Victor Kamensky (4):
      ARM: OMAP2+: raw read and write endian fix
      ARM: OMAP: dmtimer: raw read and write endian fix
      ARM: OMAP: counter-32k: raw read and write endian fix
      ARM: OMAP: debug-leds: raw read and write endian fix

Will Deacon (1):
      ARM: kconfig: allow PCI support to be selected with ARCH_MULTIPLATFORM

Xianglong Du (1):
      ARM: prima2: rstc: fix some minor checkpatch issues

Zhiwu Song (1):
      clocksource:sirf: remove the hardcode for the clk of timers


 .../devicetree/bindings/arm/vexpress-sysreg.txt |  79 +-
 .../devicetree/bindings/arm/vexpress.txt        |  15 +-
 .../bindings/clock/samsung,s3c2410-clock.txt    |  50 ++
 .../bindings/clock/samsung,s3c2412-clock.txt    |  50 ++
 .../bindings/clock/samsung,s3c2443-clock.txt    |  56 ++
 arch/arm/Kconfig                                |   1 +
 arch/arm/Kconfig.debug                          |  54 +-
 arch/arm/boot/compressed/head.S                 |   5 -
 arch/arm/boot/dts/atlas6.dtsi                   |   1 +
 arch/arm/boot/dts/prima2.dtsi                   |   1 +
 arch/arm/boot/dts/s3c2416-smdk2416.dts          |  13 +
 arch/arm/boot/dts/s3c2416.dtsi                  |  42 +
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi         |  76 +-
 arch/arm/boot/dts/vexpress-v2m.dtsi             |  76 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts      |   5 +-
 arch/arm/configs/realview-smp_defconfig         |   2 +
 arch/arm/configs/realview_defconfig             |   2 +
 arch/arm/configs/versatile_defconfig            |   3 +
 arch/arm/include/debug/s3c24xx.S                |  46 ++
 arch/arm/mach-bcm/Kconfig                       |  49 +-
 arch/arm/mach-bcm/Makefile                      |  21 +-
 arch/arm/mach-bcm/bcm_kona_smc.c                | 136 +++-
 arch/arm/mach-bcm/bcm_kona_smc.h                |  52 +-
 arch/arm/mach-bcm/bcm_kona_smc_asm.S            |  41 -
 arch/arm/mach-bcm/board_bcm21664.c              |   5 +-
 arch/arm/mach-bcm/board_bcm281xx.c              |   2 +-
 arch/arm/mach-bcm/{kona.c => kona_l2_cache.c}   |  16 +-
 arch/arm/mach-bcm/{kona.h => kona_l2_cache.h}   |   6 +-
 arch/arm/mach-cns3xxx/Kconfig                   |   1 -
 arch/arm/mach-exynos/Makefile                   |   7 +-
 arch/arm/mach-exynos/common.h                   |  72 ++
 arch/arm/mach-exynos/cpuidle.c                  |   1 -
 arch/arm/mach-exynos/exynos.c                   |  13 -
 arch/arm/mach-exynos/firmware.c                 |   3 +-
 arch/arm/mach-exynos/hotplug.c                  |  65 +-
 arch/arm/mach-exynos/platsmp.c                  |   2 -
 arch/arm/mach-exynos/pm.c                       |   1 -
 arch/arm/mach-exynos/pmu.c                      |   2 -
 arch/arm/mach-imx/Kconfig                       |   1 -
 arch/arm/mach-mvebu/Kconfig                     |   7 -
 arch/arm/mach-omap2/board-flash.c               |   4 +-
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c         |   2 +-
 arch/arm/mach-omap2/clkt2xxx_osc.c              |   8 +-
 arch/arm/mach-omap2/clkt2xxx_sys.c              |   2 +-
 arch/arm/mach-omap2/clockdomain.h               |   3 +-
 arch/arm/mach-omap2/cm2xxx.c                    |  15 +-
 arch/arm/mach-omap2/cm2xxx_3xxx.h               |   4 +-
 arch/arm/mach-omap2/cm33xx.c                    |   4 +-
 arch/arm/mach-omap2/cm33xx.h                    |   3 -
 arch/arm/mach-omap2/cm3xxx.c                    |  25 +-
 arch/arm/mach-omap2/cm3xxx.h                    |   5 +-
 arch/arm/mach-omap2/cm44xx.c                    |  11 +-
 arch/arm/mach-omap2/cm_common.c                 |   2 +-
 arch/arm/mach-omap2/cminst44xx.c                |  14 +-
 arch/arm/mach-omap2/control.c                   |  20 +-
 arch/arm/mach-omap2/dma.c                       |   4 +-
 arch/arm/mach-omap2/gpmc.c                      |   8 +-
 arch/arm/mach-omap2/id.c                        |   2 +-
 arch/arm/mach-omap2/irq.c                       |   4 +-
 arch/arm/mach-omap2/mux.c                       |   8 +-
 arch/arm/mach-omap2/omap-hotplug.c              |   4 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c       |  18 +-
 arch/arm/mach-omap2/omap-smp.c                  |   6 +-
 arch/arm/mach-omap2/omap-wakeupgen.c            |  42 +-
 arch/arm/mach-omap2/omap4-common.c              |  18 +-
 arch/arm/mach-omap2/omap_hwmod.c                |  10 +-
 .../omap_hwmod_33xx_43xx_ipblock_data.c         |   1 +
 arch/arm/mach-omap2/omap_phy_internal.c         |   6 +-
 arch/arm/mach-omap2/powerdomain-common.c        |   1 -
 arch/arm/mach-omap2/powerdomain.c               |   1 +
 arch/arm/mach-omap2/powerdomain.h               |   3 +-
 arch/arm/mach-omap2/prcm-common.h               |  24 +
 arch/arm/mach-omap2/prcm_mpu44xx.c              |   4 +-
 arch/arm/mach-omap2/prcm_mpu44xx.h              |   1 -
 arch/arm/mach-omap2/prm.h                       |  10 +
 arch/arm/mach-omap2/prm2xxx.c                   |  13 +-
 arch/arm/mach-omap2/prm2xxx.h                   |   2 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c              |   1 -
 arch/arm/mach-omap2/prm2xxx_3xxx.h              |   4 +-
 arch/arm/mach-omap2/prm33xx.c                   |   5 +-
 arch/arm/mach-omap2/prm3xxx.c                   |  22 +-
 arch/arm/mach-omap2/prm3xxx.h                   |   2 +-
 arch/arm/mach-omap2/prm44xx.c                   |  24 +-
 arch/arm/mach-omap2/prm_common.c                |  17 +-
 arch/arm/mach-omap2/prminst44xx.c               |   4 +-
 arch/arm/mach-omap2/sdrc.h                      |   8 +-
 arch/arm/mach-omap2/sdrc2xxx.c                  |   4 +-
 arch/arm/mach-omap2/sr_device.c                 |   2 +-
 arch/arm/mach-omap2/sram.c                      |  16 +-
 arch/arm/mach-omap2/timer.c                     |   8 +-
 arch/arm/mach-omap2/vc.c                        |   4 +-
 arch/arm/mach-omap2/wd_timer.c                  |   8 +-
 arch/arm/mach-prima2/rstc.c                     |  34 +-
 arch/arm/mach-qcom/Kconfig                      |   2 -
 arch/arm/mach-realview/core.c                   |  15 +
 arch/arm/mach-realview/core.h                   |   1 +
 arch/arm/mach-realview/realview_eb.c            |   1 +
 arch/arm/mach-realview/realview_pb1176.c        |   1 +
 arch/arm/mach-realview/realview_pb11mp.c        |   1 +
 arch/arm/mach-realview/realview_pba8.c          |   1 +
 arch/arm/mach-realview/realview_pbx.c           |   1 +
 arch/arm/mach-s3c24xx/Kconfig                   |  91 +--
 arch/arm/mach-s3c24xx/Makefile                  |  13 +-
 arch/arm/mach-s3c24xx/clock-dclk.c              | 195 -----
 arch/arm/mach-s3c24xx/clock-s3c2410.c           | 284 -------
 arch/arm/mach-s3c24xx/clock-s3c2412.c           | 760 -------------------
 arch/arm/mach-s3c24xx/clock-s3c2416.c           | 171 -----
 arch/arm/mach-s3c24xx/clock-s3c2440.c           | 217 ------
 arch/arm/mach-s3c24xx/clock-s3c2443.c           | 212 ------
 arch/arm/mach-s3c24xx/clock-s3c244x.c           | 141 ----
 arch/arm/mach-s3c24xx/common-s3c2443.c          | 675 ----------------
 arch/arm/mach-s3c24xx/common.c                  |  85 ++-
 arch/arm/mach-s3c24xx/common.h                  |  21 +-
 arch/arm/mach-s3c24xx/cpufreq-utils.c           |   4 +-
 .../arm/mach-s3c24xx/include/mach/debug-macro.S | 101 ---
 arch/arm/mach-s3c24xx/include/mach/regs-clock.h |  18 -
 arch/arm/mach-s3c24xx/include/mach/regs-gpio.h  |   3 -
 arch/arm/mach-s3c24xx/mach-amlm5900.c           |   9 +-
 arch/arm/mach-s3c24xx/mach-anubis.c             |  34 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c          |  10 +-
 arch/arm/mach-s3c24xx/mach-bast.c               |  34 +-
 arch/arm/mach-s3c24xx/mach-gta02.c              |   8 +-
 arch/arm/mach-s3c24xx/mach-h1940.c              |  10 +-
 arch/arm/mach-s3c24xx/mach-jive.c               |   9 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c           |  10 +-
 arch/arm/mach-s3c24xx/mach-n30.c                |  12 +-
 arch/arm/mach-s3c24xx/mach-nexcoder.c           |  10 +-
 arch/arm/mach-s3c24xx/mach-osiris.c             |  34 +-
 arch/arm/mach-s3c24xx/mach-otom.c               |  10 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c             |   9 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c             |  21 +-
 arch/arm/mach-s3c24xx/mach-rx3715.c             |  10 +-
 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c         |  38 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c           |   9 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c           |   9 +-
 arch/arm/mach-s3c24xx/mach-smdk2416.c           |   9 +-
 arch/arm/mach-s3c24xx/mach-smdk2440.c           |  10 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c           |   9 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c         |   9 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c             |  34 +-
 arch/arm/mach-s3c24xx/mach-vstms.c              |   9 +-
 arch/arm/mach-s3c24xx/pm.c                      |  17 -
 arch/arm/mach-s3c24xx/s3c2410.c                 |  56 --
 arch/arm/mach-s3c24xx/s3c2412.c                 |  43 --
 arch/arm/mach-s3c24xx/s3c2442.c                 | 111 ---
 arch/arm/mach-s3c24xx/s3c244x.c                 |  59 +-
 arch/arm/mach-shmobile/Kconfig                  |   5 +-
 arch/arm/mach-shmobile/setup-r8a7740.c          |  13 +-
 arch/arm/mach-shmobile/setup-sh7372.c           |   6 +-
 arch/arm/mach-tegra/Kconfig                     |   1 -
 arch/arm/mach-versatile/core.c                  |  16 +
 arch/arm/mach-vexpress/Kconfig                  |   2 +
 arch/arm/mach-vexpress/core.h                   |   3 +-
 arch/arm/mach-vexpress/ct-ca9x4.c               |  10 +-
 arch/arm/mach-vexpress/platsmp.c                | 187 +----
 arch/arm/mach-vexpress/v2m.c                    |  82 +-
 arch/arm/plat-omap/counter_32k.c                |   6 +-
 arch/arm/plat-omap/debug-leds.c                 |  14 +-
 arch/arm/plat-omap/dmtimer.c                    |   8 +-
 arch/arm/plat-omap/include/plat/dmtimer.h       |  16 +-
 .../plat-samsung/include/plat/cpu-freq-core.h   |   1 +
 arch/arm/plat-samsung/include/plat/cpu.h        |  61 --
 arch/arm/plat-versatile/Kconfig                 |   6 -
 arch/arm/plat-versatile/Makefile                |   1 -
 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi    |   2 +-
 drivers/bus/Kconfig                             |  10 +
 drivers/bus/Makefile                            |   2 +
 drivers/bus/vexpress-config.c                   | 202 +++++
 drivers/clk/Kconfig                             |   9 +-
 drivers/clk/samsung/Makefile                    |   4 +
 drivers/clk/samsung/clk-pll.c                   | 266 ++++++-
 drivers/clk/samsung/clk-pll.h                   |   6 +
 drivers/clk/samsung/clk-s3c2410-dclk.c          | 440 +++++++++++
 drivers/clk/samsung/clk-s3c2410.c               | 477 ++++++++++++
 drivers/clk/samsung/clk-s3c2412.c               | 269 +++++++
 drivers/clk/samsung/clk-s3c2443.c               | 462 +++++++++++
 drivers/clk/versatile/Kconfig                   |  26 +
 drivers/clk/versatile/Makefile                  |   5 +-
 drivers/clk/versatile/clk-vexpress-osc.c        |  96 +--
 drivers/clocksource/Kconfig                     |  11 +
 drivers/clocksource/Makefile                    |   1 +
 drivers/clocksource/timer-marco.c               |   8 +-
 drivers/clocksource/timer-prima2.c              |  47 +-
 drivers/clocksource/versatile.c                 |  40 +
 drivers/cpufreq/exynos-cpufreq.c                |  19 +-
 drivers/cpufreq/exynos-cpufreq.h                |   8 +
 drivers/cpufreq/exynos4x12-cpufreq.c            |  11 +-
 drivers/cpufreq/s3c24xx-cpufreq.c               |   1 +
 drivers/hwmon/vexpress.c                        |  17 +-
 drivers/irqchip/irq-sirfsoc.c                   |   3 +-
 drivers/leds/Kconfig                            |   8 +
 drivers/leds/Makefile                           |   1 +
 .../leds.c => drivers/leds/leds-versatile.c     |  51 +-
 drivers/mfd/Kconfig                             |  15 +-
 drivers/mfd/Makefile                            |   2 +-
 drivers/mfd/syscon.c                            |   4 +
 drivers/mfd/vexpress-config.c                   | 287 -------
 drivers/mfd/vexpress-sysreg.c                   | 554 ++++----------
 drivers/misc/Kconfig                            |   9 +
 drivers/misc/Makefile                           |   1 +
 drivers/misc/vexpress-syscfg.c                  | 324 ++++++++
 drivers/of/platform.c                           |  74 +-
 drivers/power/reset/vexpress-poweroff.c         |  16 +-
 drivers/regulator/vexpress.c                    |  50 +-
 include/dt-bindings/clock/s3c2410.h             |  62 ++
 include/dt-bindings/clock/s3c2412.h             |  73 ++
 include/dt-bindings/clock/s3c2443.h             |  92 +++
 include/linux/of.h                              |   7 +
 include/linux/of_platform.h                     |   5 +
 include/linux/platform_data/syscon.h            |   8 +
 include/linux/vexpress.h                        |  94 +--
 211 files changed, 4666 insertions(+), 5172 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s3c2410-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s3c2412-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s3c2443-clock.txt
 create mode 100644 arch/arm/include/debug/s3c24xx.S
 delete mode 100644 arch/arm/mach-bcm/bcm_kona_smc_asm.S
 rename arch/arm/mach-bcm/{kona.c => kona_l2_cache.c} (80%)
 rename arch/arm/mach-bcm/{kona.h => kona_l2_cache.h} (80%)
 delete mode 100644 arch/arm/mach-s3c24xx/clock-dclk.c
 delete mode 100644 arch/arm/mach-s3c24xx/clock-s3c2410.c
 delete mode 100644 arch/arm/mach-s3c24xx/clock-s3c2412.c
 delete mode 100644 arch/arm/mach-s3c24xx/clock-s3c2416.c
 delete mode 100644 arch/arm/mach-s3c24xx/clock-s3c2440.c
 delete mode 100644 arch/arm/mach-s3c24xx/clock-s3c2443.c
 delete mode 100644 arch/arm/mach-s3c24xx/clock-s3c244x.c
 delete mode 100644 arch/arm/mach-s3c24xx/common-s3c2443.c
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/debug-macro.S
 create mode 100644 drivers/bus/vexpress-config.c
 create mode 100644 drivers/clk/samsung/clk-s3c2410-dclk.c
 create mode 100644 drivers/clk/samsung/clk-s3c2410.c
 create mode 100644 drivers/clk/samsung/clk-s3c2412.c
 create mode 100644 drivers/clk/samsung/clk-s3c2443.c
 create mode 100644 drivers/clk/versatile/Kconfig
 create mode 100644 drivers/clocksource/versatile.c
 rename arch/arm/plat-versatile/leds.c => drivers/leds/leds-versatile.c (68%)
 delete mode 100644 drivers/mfd/vexpress-config.c
 create mode 100644 drivers/misc/vexpress-syscfg.c
 create mode 100644 include/dt-bindings/clock/s3c2410.h
 create mode 100644 include/dt-bindings/clock/s3c2412.h
 create mode 100644 include/dt-bindings/clock/s3c2443.h
 create mode 100644 include/linux/platform_data/syscon.h
