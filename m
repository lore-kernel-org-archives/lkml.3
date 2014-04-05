Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaDETES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:04:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:63369 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaDETER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:04:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 2/8] ARM: SoC: cleanups for 3.15
Date: Sat, 5 Apr 2014 20:03:45 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201404052101.19381.arnd@arndb.de>
In-Reply-To: <201404052101.19381.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201404052103.46349.arnd@arndb.de>
X-Provags-ID: V02:K0:/pHDP9Ixm7tSsarIJS1U7dChImqoRmF/d1pdWJd8RD7
 hvW23qtCzvh/AFLw5nMxwYDuNnKo5+NYLBw7E86sZDPNA/QXOb
 ND3JoWIAfYwXtfeSXzcCGGUz+MrM7wUq1q4fSkQ7lpaPRsxgEJ
 j8OoERAMdjxwbH31v4P2Wx8gyO3iAGZkMhuaADoIqJPHm2NCxa
 e0wdv9puh/6s2QdOKXscJ56DoO8mDUNtOQmDL94G3JYLxya1bF
 pYo3YbzLlNvggdjPukwWAgzp/Fgm7k7EKryvejUG3WzV+4cQ5N
 z+tUrOL37PNMP5T8iHszh7qFInwZb1A1j8Db1SNnv1WjJwVfaB
 qFGdJGuiJb0QAo+B6ybnfseTGzllUXFH55XVwQj5a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-3.15

for you to fetch changes up to 8f881c67368f82d0e20e1072b50b21132cc2440d:

  ARM: hisi: select HAVE_ARM_SCU only for SMP (2014-03-21 18:31:34 +0100)

----------------------------------------------------------------
ARM: SoC: cleanups for 3.15

These cleanup patches are mainly move stuff around and should all
be harmless. They are mainly split out so that other branches can
be based on top to avoid conflicts.

Notable changes are:

* We finally remove all mach/timex.h, after CLOCK_TICK_RATE is no
  longer used. (Uwe Kleine-König)
* The Qualcomm MSM platform is split out into legacy mach-msm and
  new-style mach-qcom, to allow easier maintainance of the new
  hardware support without regressions. (Kumar Gala)
* A rework of some of the Kconfig logic to simplify multiplatform
  support (Rob Herring)
* Samsung Exynos gets closer to supporting multiplatform (Sachin
  Kamat and others)
* mach-bcm3528 gets merged into mach-bcm (Stephen Warren)
* at91 gains some common clock framework support (Alexandre Belloni,
  Jean-Jacques Hiblot and other French people)

Conflicts are all with the Kconfig cleanup:
* The omap Kconfig now selects ARCH_HAS_OPP for SOC_AM43XX
  and , while some redundant options got removed.
* Tegra Kconfig lost two redundant 'select' statements: SPARSE_IRQ
  and USB_ARCH_HAS_EHCI
* Zynq now needs ARCH_HAS_CPUFREQ and ARCH_HAS_OPP, but not
  COMMON_CLK, CPU_V7 and GENERIC_CLOCKEVENTS
* The clocksource Kconfig gained new options on both sides

----------------------------------------------------------------
Alex Elder (1):
      ARM: bcm281xx: symbol cleanup

Alexander Shiyan (2):
      ARM: clps711x: Remove EP72XX_ROM_BOOT option
      ARM: clps711x: Update defconfig

Alexandre Belloni (11):
      ARM: at91/defconfig: refresh at91sam9rl_defconfig
      ARM: at91/defconfig: remove useless configuration in at91sam9260_9g20_defconfig
      ARM: at91/defconfig: refresh at91sam9260_9g20_defconfig
      ARM: at91: prepare at91sam9rl DT transition
      ARM: at91: Add at91sam9rl DT SoC support
      ARM: at91/defconfig: Add the sam9rl to the list of DT-enabled SOCs
      ARM: at91: dt: sam9rl: Device Tree for the at91sam9rlek
      ARM: at91: prepare common clk transition for sam9rl SoCs
      ARM: at91/dt: define at91sam9rl clocks
      ARM: at91/dt: define main clk frequency of at91sam9rlek
      ARM: at91: switch sam9rl to common clock framework

Arnd Bergmann (6):
      Merge tag 'efm32-next' of git://git.pengutronix.de/git/ukl/linux into next/cleanup
      Merge tag 'kconfig-cleanup-for-3.15' of git://git.kernel.org/.../robh/linux into next/cleanup
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      ARM: prima2: build reset code standalone
      ARM: efm32: allow uncompress debug output
      ARM: hisi: select HAVE_ARM_SCU only for SMP

Barry Song (6):
      ARM: prima2: l2x0: fix checkpatch issues
      ARM: prima2: platsmp: fix checkpatch issues
      ARM: prima2: common: fix checkpatch issues
      ARM: prima2: rtciobrg: fix the typo about license
      ARM: prima2: staticize sirfsoc_init_late function
      ARM: prima2: move to generic reset controller driver framework

Bo Shen (1):
      ARM: at91: add PWM clock

Boris BREZILLON (1):
      ARM: at91: prepare sam9 dt boards transition to common clk

Geert Uytterhoeven (1):
      ARM: shmobile: Remove duplicate shmobile_invalidate_start() declaration

Gregory CLEMENT (1):
      ARM: mvebu: Makefile clean-up

Heiko Stuebner (2):
      ARM: SAMSUNG: remove obsolete tick.h
      ARM: SAMSUNG: remove unneeded s3c24xx_init_cpu()

Jean-Jacques Hiblot (6):
      ARM: at91: dt: Add at91sam9261 dt SoC support
      ARM: at91: dt: defconfig: Added the sam9261 to the list of DT-enabled SOCs
      ARM: at91: dt: sam9261: Device Tree support for the at91sam9261ek
      ARM: at91: updated the at91_dt_defconfig with support for the ADS7846
      ARM: at91: prepare common clk transition for sam9261 SoC
      ARM: at91: move sam9261 SoC to common clk

Josh Cartwright (1):
      ARM: mvebu: make use of of_find_matching_node_and_match

Kumar Gala (6):
      ARM: dts: msm: split out msm8660 and msm8960 soc into dts include
      ARM: msm: kill off hotplug.c
      clocksource: qcom: Move clocksource code out of mach-msm
      ARM: qcom: Split Qualcomm support into legacy and multiplatform
      clocksource: qcom: split building of legacy vs multiplatform support
      ARM: qcom: Rename various msm prefixed functions to qcom

Linus Walleij (1):
      ARM/serial: at91: switch atmel serial to use gpiolib

Markus Mayer (5):
      ARM: bcm2835: Move to mach-bcm directory
      ARM: bcm281xx: Move kona_l2_cache_init() so it can be shared
      ARM: bcm281xx: Consolidate reboot code
      ARM: bcm281xx: Re-order hearder files
      ARM: bcm281xx: Rename board_init() function

Neil Zhang (1):
      irqchip: mmp: avoid use head file in a specific arch

Olof Johansson (10):
      Merge tag 'dropmachtimexh-v2' of git://git.pengutronix.de/git/ukl/linux into next/cleanup
      Merge tag 'renesas-cleanup-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'qcom-cleanup-for-3.15' of git://git.kernel.org/.../galak/linux-qcom into next/cleanup
      Merge tag 'mvebu-soc-3.15' of git://git.infradead.org/linux-mvebu into next/cleanup
      Merge tag 'samsung-drivers' of http://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'samsung-cleanup' of http://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'irq-mmp' of https://git.kernel.org/.../hzhuang1/linux into next/cleanup
      Merge tag 'sirf-soc-for-3.15' of git://git.kernel.org/.../baohua/linux into next/cleanup
      Merge tag 'armsoc/for-3.15/cleanup' of git://github.com/broadcom/mach-bcm into next/cleanup
      Merge tag 'bcm2835-for-3.15-soc' of git://git.kernel.org/.../swarren/linux-rpi into next/cleanup

Pankaj Dubey (2):
      clocksource: exynos_mct: remove unwanted header file inclusion
      irqchip: exynos-combiner: call handle_bad_irq directly

Paul Bolle (1):
      ARM: S3C24XX: get rid of unneeded selects

Rob Herring (9):
      ARM: centralize common multi-platform kconfig options
      ARM: select HAVE_SMP for V7 multi-platform
      ARM: select MIGHT_HAVE_CACHE_L2X0 for V6 and V7 multi-platform
      ARM: Select V6K instead of V6 by default for multi-platform
      ARM: bcm2835: enable V6K instead of plain V6
      ARM: cns3xxx: enable V6K instead of plain V6
      ARM: vt8500: enable V6K instead of plain V6
      ARM: virt: make mach-virt just a kconfig option
      ARM: virt: select ARM_AMBA

Rohit Vaswani (1):
      ARM: msm: Remove pen_release usage

Sachin Kamat (4):
      ARM: SAMSUNG: Remove platform dependency from samsung.S
      ARM: S3C24XX: Move rtc-core.h from plat to mach
      ARM: debug: Use generic uncompress.h for exynos
      ARM: EXYNOS: Remove uncompress.h

Simon Horman (2):
      ARM: shmobile: r8a7779: Remove unused clock constants
      ARM: shmobile: emev2: Use __initconst for const init definition

Thomas Petazzoni (1):
      ARM: mvebu: remove unneeded ->map_io field for Armada 370/XP

Tushar Behera (4):
      ARM: SAMSUNG: Replace inclusion of plat/regs-serial.h header file
      ARM: SAMSUNG: Delete unused plat/regs-serial.h header file
      ARM: SAMSUNG: Remove Exynos specific code from devs, s5p-pm-irq and pm-gpio.c
      ARM: EXYNOS: Remove unused header file from pm_domains.c

Uwe Kleine-König (17):
      rtc: at91sam9: include <mach/hardware.h> explicitly
      rtc: pxa: drop unused #define TIMER_FREQ
      clocksource: sirf/marco+prima2: drop usage of CLOCK_TICK_RATE
      ARM: sa1100: stop using mach/timex.h
      ARM: netx: stop using mach/timex.h
      ARM: mmp: stop using mach/timex.h
      ARM: ep93xx: stop using mach/timex.h
      ARM: at91: don't use <mach/timex.h>
      input: ixp4xx-beeper: don't use symbols from <mach/timex.h>
      ARM: ixp4xx: stop using <mach/timex.h>
      ARM: rpc: stop using <mach/timex.h>
      ARM: drop <mach/timex.h> for !ARCH_MULTIPLATFORM, too
      ARM: ixp4xx: fix timer latch calculation
      ARM: efm32: drop unused file entry-macro.S
      ARM: efm32: drop selecting CLKSRC_MMIO
      Merge tag 'dropmachtimexh-v2' of git://git.pengutronix.de/git/ukl/linux
      ARM: efm32: drop unused file <mach/timex.h>

 .../devicetree/bindings/reset/sirf,rstc.txt        |  42 ++
 .../devicetree/bindings/serial/atmel-usart.txt     |   3 +
 MAINTAINERS                                        |  10 +-
 arch/arm/Kconfig                                   |  27 +-
 arch/arm/Kconfig.debug                             |   7 +-
 arch/arm/Makefile                                  |   3 +-
 arch/arm/boot/dts/Makefile                         |  10 +-
 arch/arm/boot/dts/at91sam9261.dtsi                 | 735 +++++++++++++++++++
 arch/arm/boot/dts/at91sam9261ek.dts                | 211 ++++++
 arch/arm/boot/dts/at91sam9rl.dtsi                  | 802 +++++++++++++++++++++
 arch/arm/boot/dts/at91sam9rlek.dts                 | 157 ++++
 arch/arm/boot/dts/atlas6.dtsi                      |   3 +-
 arch/arm/boot/dts/marco.dtsi                       |   3 +-
 arch/arm/boot/dts/prima2.dtsi                      |   3 +-
 arch/arm/boot/dts/qcom-msm8660-surf.dts            |  59 +-
 arch/arm/boot/dts/qcom-msm8660.dtsi                |  63 ++
 arch/arm/boot/dts/qcom-msm8960-cdp.dts             |  66 +-
 arch/arm/boot/dts/qcom-msm8960.dtsi                |  70 ++
 arch/arm/configs/at91_dt_defconfig                 |   3 +
 arch/arm/configs/at91sam9260_9g20_defconfig        |   9 +-
 arch/arm/configs/at91sam9rl_defconfig              |  10 +-
 arch/arm/configs/bcm2835_defconfig                 |   1 +
 arch/arm/configs/clps711x_defconfig                |   3 +-
 arch/arm/include/asm/timex.h                       |   6 -
 arch/arm/include/debug/samsung.S                   |   2 +-
 arch/arm/mach-at91/Kconfig                         |   2 -
 arch/arm/mach-at91/at91rm9200.c                    |   1 +
 arch/arm/mach-at91/at91rm9200_devices.c            |  11 +-
 arch/arm/mach-at91/at91rm9200_time.c               |   1 +
 arch/arm/mach-at91/at91sam9260.c                   |   1 +
 arch/arm/mach-at91/at91sam9260_devices.c           |   8 +
 arch/arm/mach-at91/at91sam9261.c                   |  26 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |   5 +
 arch/arm/mach-at91/at91sam9263.c                   |   2 +
 arch/arm/mach-at91/at91sam9263_devices.c           |   5 +
 arch/arm/mach-at91/at91sam926x_time.c              |   1 +
 arch/arm/mach-at91/at91sam9g45.c                   |   2 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |   6 +
 arch/arm/mach-at91/at91sam9n12.c                   |   1 +
 arch/arm/mach-at91/at91sam9rl.c                    |  25 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |   6 +
 arch/arm/mach-at91/at91sam9x5.c                    |   1 +
 arch/arm/mach-at91/at91x40.c                       |   2 +-
 arch/arm/mach-at91/at91x40_time.c                  |   1 +
 arch/arm/mach-at91/board-dt-sam9.c                 |  11 +-
 arch/arm/mach-at91/board-gsia18s.c                 |   1 +
 arch/arm/mach-at91/board-pcontrol-g20.c            |   1 +
 arch/arm/mach-at91/board-stamp9g20.c               |   1 +
 arch/arm/mach-at91/include/mach/at91x40.h          |   2 +
 arch/arm/mach-at91/include/mach/timex.h            |  37 -
 arch/arm/mach-at91/pm.c                            |   1 +
 arch/arm/mach-bcm/Kconfig                          |  21 +-
 arch/arm/mach-bcm/Makefile                         |   2 +
 arch/arm/mach-bcm/board_bcm281xx.c                 |  83 +--
 .../bcm2835.c => mach-bcm/board_bcm2835.c}         |   0
 arch/arm/mach-bcm/kona.c                           |  64 +-
 arch/arm/mach-bcm/kona.h                           |   7 +-
 arch/arm/mach-bcm2835/Kconfig                      |  15 -
 arch/arm/mach-bcm2835/Makefile                     |   1 -
 arch/arm/mach-berlin/Kconfig                       |   4 -
 arch/arm/mach-clps711x/Kconfig                     |  14 -
 arch/arm/mach-clps711x/include/mach/hardware.h     |  17 -
 arch/arm/mach-clps711x/include/mach/timex.h        |   2 -
 arch/arm/mach-cns3xxx/Kconfig                      |   3 -
 arch/arm/mach-davinci/include/mach/timex.h         |  22 -
 arch/arm/mach-dove/include/mach/timex.h            |   9 -
 arch/arm/mach-ebsa110/include/mach/timex.h         |  19 -
 arch/arm/mach-efm32/include/mach/entry-macro.S     |   4 -
 arch/arm/mach-efm32/include/mach/timex.h           |   3 -
 arch/arm/mach-ep93xx/core.c                        |   2 +-
 arch/arm/mach-ep93xx/include/mach/timex.h          |   5 -
 arch/arm/mach-exynos/common.c                      |   2 +-
 arch/arm/mach-exynos/include/mach/timex.h          |  29 -
 arch/arm/mach-exynos/include/mach/uncompress.h     |  48 --
 arch/arm/mach-exynos/pm_domains.c                  |   2 -
 arch/arm/mach-footbridge/include/mach/timex.h      |  18 -
 arch/arm/mach-gemini/include/mach/timex.h          |  13 -
 arch/arm/mach-highbank/Kconfig                     |   7 -
 arch/arm/mach-hisi/Kconfig                         |   6 +-
 arch/arm/mach-imx/Kconfig                          |  14 -
 arch/arm/mach-integrator/include/mach/timex.h      |  26 -
 arch/arm/mach-iop13xx/include/mach/timex.h         |   1 -
 arch/arm/mach-iop32x/include/mach/timex.h          |   6 -
 arch/arm/mach-iop33x/include/mach/timex.h          |   6 -
 arch/arm/mach-ixp4xx/common.c                      |  14 +-
 arch/arm/mach-ixp4xx/include/mach/timex.h          |  16 -
 arch/arm/mach-keystone/Kconfig                     |   4 -
 arch/arm/mach-kirkwood/include/mach/timex.h        |  10 -
 arch/arm/mach-ks8695/include/mach/timex.h          |  21 -
 arch/arm/mach-lpc32xx/include/mach/timex.h         |  28 -
 arch/arm/mach-mmp/include/mach/timex.h             |  13 -
 arch/arm/mach-mmp/time.c                           |  12 +-
 arch/arm/mach-moxart/Kconfig                       |   5 -
 arch/arm/mach-msm/Kconfig                          |  54 +-
 arch/arm/mach-msm/Makefile                         |   8 -
 arch/arm/mach-msm/common.h                         |   1 -
 arch/arm/mach-msm/headsmp.S                        |  39 -
 arch/arm/mach-msm/hotplug.c                        |  74 --
 arch/arm/mach-msm/include/mach/timex.h             |  21 -
 arch/arm/mach-mv78xx0/include/mach/timex.h         |   9 -
 arch/arm/mach-mvebu/Kconfig                        |   6 -
 arch/arm/mach-mvebu/Makefile                       |   3 +-
 arch/arm/mach-mvebu/armada-370-xp.c                |   6 -
 arch/arm/mach-mvebu/system-controller.c            |   9 +-
 arch/arm/mach-mxs/Kconfig                          |   4 -
 arch/arm/mach-netx/include/mach/timex.h            |  20 -
 arch/arm/mach-netx/time.c                          |  11 +-
 arch/arm/mach-nomadik/Kconfig                      |   5 -
 arch/arm/mach-nspire/Kconfig                       |   5 -
 arch/arm/mach-omap1/include/mach/timex.h           |   5 -
 arch/arm/mach-omap2/Kconfig                        |  17 -
 arch/arm/mach-omap2/include/mach/timex.h           |   5 -
 arch/arm/mach-orion5x/include/mach/timex.h         |  11 -
 arch/arm/mach-picoxcell/Kconfig                    |   5 -
 arch/arm/mach-prima2/Kconfig                       |   7 +-
 arch/arm/mach-prima2/common.c                      |  11 +-
 arch/arm/mach-prima2/common.h                      |   1 -
 arch/arm/mach-prima2/l2x0.c                        |   9 +-
 arch/arm/mach-prima2/platsmp.c                     |   6 +-
 arch/arm/mach-prima2/rstc.c                        |  99 ++-
 arch/arm/mach-prima2/rtciobrg.c                    |   2 +-
 arch/arm/mach-pxa/include/mach/timex.h             |  34 -
 arch/arm/mach-qcom/Kconfig                         |  33 +
 arch/arm/mach-qcom/Makefile                        |   5 +
 .../arm/{mach-msm/board-dt.c => mach-qcom/board.c} |  15 +-
 arch/arm/{mach-msm => mach-qcom}/platsmp.c         |  66 +-
 arch/arm/{mach-msm => mach-qcom}/scm-boot.c        |   0
 arch/arm/{mach-msm => mach-qcom}/scm-boot.h        |   0
 arch/arm/{mach-msm => mach-qcom}/scm.c             |   0
 arch/arm/{mach-msm => mach-qcom}/scm.h             |   0
 arch/arm/mach-realview/include/mach/timex.h        |  23 -
 arch/arm/mach-rockchip/Kconfig                     |   3 -
 arch/arm/mach-rpc/include/mach/timex.h             |  17 -
 arch/arm/mach-rpc/time.c                           |  15 +-
 arch/arm/mach-s3c24xx/Kconfig                      |   2 -
 arch/arm/mach-s3c24xx/clock-s3c2410.c              |   3 +-
 arch/arm/mach-s3c24xx/clock-s3c2412.c              |   3 +-
 arch/arm/mach-s3c24xx/clock-s3c2440.c              |   2 +-
 arch/arm/mach-s3c24xx/common.c                     |   3 +-
 arch/arm/mach-s3c24xx/dma-s3c2410.c                |   2 +-
 arch/arm/mach-s3c24xx/dma-s3c2412.c                |   2 +-
 arch/arm/mach-s3c24xx/dma-s3c2440.c                |   2 +-
 arch/arm/mach-s3c24xx/dma-s3c2443.c                |   2 +-
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S   |   2 +-
 .../plat => mach-s3c24xx/include/mach}/rtc-core.h  |  13 +-
 arch/arm/mach-s3c24xx/include/mach/tick.h          |  15 -
 arch/arm/mach-s3c24xx/include/mach/timex.h         |  24 -
 arch/arm/mach-s3c24xx/mach-amlm5900.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-anubis.c                |   2 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |   2 +-
 arch/arm/mach-s3c24xx/mach-bast.c                  |   2 +-
 arch/arm/mach-s3c24xx/mach-gta02.c                 |   2 +-
 arch/arm/mach-s3c24xx/mach-h1940.c                 |   2 +-
 arch/arm/mach-s3c24xx/mach-jive.c                  |   2 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-n30.c                   |   2 +-
 arch/arm/mach-s3c24xx/mach-nexcoder.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-osiris.c                |   2 +-
 arch/arm/mach-s3c24xx/mach-otom.c                  |   2 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c                |   2 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   2 +-
 arch/arm/mach-s3c24xx/mach-rx3715.c                |   2 +-
 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c            |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2440.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c            |   2 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c                |   2 +-
 arch/arm/mach-s3c24xx/mach-vstms.c                 |   2 +-
 arch/arm/mach-s3c24xx/pm.c                         |   2 +-
 arch/arm/mach-s3c24xx/s3c2410.c                    |   2 +-
 arch/arm/mach-s3c24xx/s3c2412.c                    |   2 +-
 arch/arm/mach-s3c24xx/s3c2416.c                    |   2 +-
 arch/arm/mach-s3c24xx/s3c2443.c                    |   2 +-
 arch/arm/mach-s3c24xx/s3c244x.c                    |   2 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S              |   2 +-
 arch/arm/mach-s3c24xx/sleep.S                      |   2 +-
 arch/arm/mach-s3c64xx/common.c                     |   2 +-
 arch/arm/mach-s3c64xx/include/mach/debug-macro.S   |   2 +-
 arch/arm/mach-s3c64xx/include/mach/tick.h          |  31 -
 arch/arm/mach-s3c64xx/include/mach/timex.h         |  24 -
 arch/arm/mach-s3c64xx/irq-pm.c                     |   2 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c               |   2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |   2 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |   2 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c              |   2 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                   |   2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |   2 +-
 arch/arm/mach-s3c64xx/mach-smartq.c                |   2 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |   3 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |   2 +-
 arch/arm/mach-s3c64xx/s3c6400.c                    |   2 +-
 arch/arm/mach-s3c64xx/s3c6410.c                    |   2 +-
 arch/arm/mach-s5p64x0/common.c                     |   2 +-
 arch/arm/mach-s5p64x0/include/mach/debug-macro.S   |   3 +-
 arch/arm/mach-s5p64x0/include/mach/timex.h         |  27 -
 arch/arm/mach-s5p64x0/irq-pm.c                     |   2 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |   2 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |   2 +-
 arch/arm/mach-s5pc100/common.c                     |   2 +-
 arch/arm/mach-s5pc100/include/mach/debug-macro.S   |   2 +-
 arch/arm/mach-s5pc100/include/mach/tick.h          |  31 -
 arch/arm/mach-s5pc100/include/mach/timex.h         |  24 -
 arch/arm/mach-s5pc100/mach-smdkc100.c              |   2 +-
 arch/arm/mach-s5pv210/common.c                     |   2 +-
 arch/arm/mach-s5pv210/include/mach/debug-macro.S   |   2 +-
 arch/arm/mach-s5pv210/include/mach/timex.h         |  29 -
 arch/arm/mach-s5pv210/mach-aquila.c                |   2 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |   2 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c              |   2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   2 +-
 arch/arm/mach-s5pv210/mach-torbreck.c              |   2 +-
 arch/arm/mach-sa1100/include/mach/timex.h          |  12 -
 arch/arm/mach-sa1100/time.c                        |   8 +-
 arch/arm/mach-shmobile/Kconfig                     |   5 -
 arch/arm/mach-shmobile/clock-r8a7779.c             |   7 -
 arch/arm/mach-shmobile/include/mach/common.h       |   1 -
 arch/arm/mach-shmobile/include/mach/timex.h        |   6 -
 arch/arm/mach-shmobile/setup-emev2.c               |   2 +-
 arch/arm/mach-socfpga/Kconfig                      |   7 -
 arch/arm/mach-spear/Kconfig                        |  10 -
 arch/arm/mach-spear/include/mach/timex.h           |  19 -
 arch/arm/mach-sti/Kconfig                          |   4 -
 arch/arm/mach-sunxi/Kconfig                        |   5 -
 arch/arm/mach-tegra/Kconfig                        |   8 -
 arch/arm/mach-u300/Kconfig                         |   6 -
 arch/arm/mach-ux500/Kconfig                        |   6 -
 arch/arm/mach-versatile/include/mach/timex.h       |  23 -
 arch/arm/mach-vexpress/Kconfig                     |   5 -
 arch/arm/mach-virt/Kconfig                         |  10 -
 arch/arm/mach-virt/Makefile                        |   5 -
 arch/arm/mach-virt/virt.c                          |  41 --
 arch/arm/mach-vt8500/Kconfig                       |   4 -
 arch/arm/mach-w90x900/include/mach/timex.h         |  25 -
 arch/arm/mach-zynq/Kconfig                         |   7 -
 arch/arm/plat-omap/include/plat/timex.h            |  33 -
 arch/arm/plat-samsung/clock.c                      |   2 +-
 arch/arm/plat-samsung/cpu.c                        |   7 -
 arch/arm/plat-samsung/devs.c                       |  12 +-
 arch/arm/plat-samsung/include/plat/cpu.h           |   1 -
 arch/arm/plat-samsung/include/plat/regs-serial.h   |   1 -
 arch/arm/plat-samsung/include/plat/uncompress.h    |   2 +-
 arch/arm/plat-samsung/init.c                       |   3 +-
 arch/arm/plat-samsung/pm-gpio.c                    |   5 +-
 arch/arm/plat-samsung/pm.c                         |   3 +-
 arch/arm/plat-samsung/s5p-irq-pm.c                 |  13 -
 drivers/clocksource/Kconfig                        |   3 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/exynos_mct.c                   |   2 -
 .../timer.c => drivers/clocksource/qcom-timer.c    |  29 +-
 drivers/clocksource/timer-marco.c                  |  13 +-
 drivers/clocksource/timer-prima2.c                 |  16 +-
 drivers/input/misc/ixp4xx-beeper.c                 |   2 +-
 drivers/irqchip/exynos-combiner.c                  |   3 +-
 drivers/irqchip/irq-mmp.c                          |   2 +-
 drivers/rtc/rtc-at91sam9.c                         |   2 +-
 drivers/rtc/rtc-pxa.c                              |   1 -
 drivers/tty/serial/atmel_serial.c                  |  49 +-
 include/linux/platform_data/atmel.h                |   1 +
 261 files changed, 2696 insertions(+), 1832 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/reset/sirf,rstc.txt
 create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9rl.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9rlek.dts
 create mode 100644 arch/arm/boot/dts/qcom-msm8660.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-msm8960.dtsi
 delete mode 100644 arch/arm/mach-at91/include/mach/timex.h
 rename arch/arm/{mach-bcm2835/bcm2835.c => mach-bcm/board_bcm2835.c} (100%)
 delete mode 100644 arch/arm/mach-bcm2835/Kconfig
 delete mode 100644 arch/arm/mach-bcm2835/Makefile
 delete mode 100644 arch/arm/mach-clps711x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/timex.h
 delete mode 100644 arch/arm/mach-dove/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/timex.h
 delete mode 100644 arch/arm/mach-efm32/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-efm32/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/timex.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-footbridge/include/mach/timex.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/timex.h
 delete mode 100644 arch/arm/mach-integrator/include/mach/timex.h
 delete mode 100644 arch/arm/mach-iop13xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-iop32x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-iop33x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ks8695/include/mach/timex.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/timex.h
 delete mode 100644 arch/arm/mach-msm/headsmp.S
 delete mode 100644 arch/arm/mach-msm/hotplug.c
 delete mode 100644 arch/arm/mach-msm/include/mach/timex.h
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/timex.h
 delete mode 100644 arch/arm/mach-netx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/timex.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/timex.h
 delete mode 100644 arch/arm/mach-orion5x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/timex.h
 create mode 100644 arch/arm/mach-qcom/Kconfig
 create mode 100644 arch/arm/mach-qcom/Makefile
 rename arch/arm/{mach-msm/board-dt.c => mach-qcom/board.c} (68%)
 rename arch/arm/{mach-msm => mach-qcom}/platsmp.c (65%)
 rename arch/arm/{mach-msm => mach-qcom}/scm-boot.c (100%)
 rename arch/arm/{mach-msm => mach-qcom}/scm-boot.h (100%)
 rename arch/arm/{mach-msm => mach-qcom}/scm.c (100%)
 rename arch/arm/{mach-msm => mach-qcom}/scm.h (100%)
 delete mode 100644 arch/arm/mach-realview/include/mach/timex.h
 delete mode 100644 arch/arm/mach-rpc/include/mach/timex.h
 rename arch/arm/{plat-samsung/include/plat => mach-s3c24xx/include/mach}/rtc-core.h (69%)
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/tick.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/tick.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/tick.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/timex.h
 delete mode 100644 arch/arm/mach-sa1100/include/mach/timex.h
 delete mode 100644 arch/arm/mach-shmobile/include/mach/timex.h
 delete mode 100644 arch/arm/mach-spear/include/mach/timex.h
 delete mode 100644 arch/arm/mach-versatile/include/mach/timex.h
 delete mode 100644 arch/arm/mach-virt/Kconfig
 delete mode 100644 arch/arm/mach-virt/Makefile
 delete mode 100644 arch/arm/mach-virt/virt.c
 delete mode 100644 arch/arm/mach-w90x900/include/mach/timex.h
 delete mode 100644 arch/arm/plat-omap/include/plat/timex.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-serial.h
 rename arch/arm/mach-msm/timer.c => drivers/clocksource/qcom-timer.c (98%)
