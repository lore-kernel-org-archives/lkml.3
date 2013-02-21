Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3BUVPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:15:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3BUVMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:12:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 02/09] arm-soc: cleanups
Date: Thu, 21 Feb 2013 21:12:22 +0000
Message-Id: <1361481149-27559-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:bap9zE3jVpbiSRIDUIjsTr6oIV52oqt38PGWL/KVYeE
 tWZgia8bGd//hvhIojZkqsxzuLmu7OSHjTVhvH2tUkcyhUEsMd
 tWG+4TGDcVjbhFgkUE7mc4PIqqPv6zJFGI8WHc1AnHXz1AjnxV
 XzMs7LVI/W5+uju6QFJBFYPyN/Cj/f+RnCfLFZHrGi7jqMFl3E
 LTrID8r5dWp0FiaM42z5EU/VrJ4QhNbKNhibXWr6R5aMup/ZN1
 JHqpzdh3Bn5tviyvWE5JvBKKaGIA/MqpOgWTdOkdJXiSMg3lb5
 JIUsqFOLy59UpLE8BdMU4T9A11n6IoBKaIDkDtY1sFk1cridXP
 p/Oh0w+trL69qorsVHusbdqSKgDZM3iOPb+EQQFmV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup

for you to fetch changes up to 3b1209e7994c4d31ff9932a7f566ae1c96b3c443:

  Merge tag 'cleanup_for_v3.9_round3' of git://git.infradead.org/users/jcooper/linux into next/cleanup (2013-02-19 18:06:53 +0100)

----------------------------------------------------------------

arm-soc: cleanups

A large number of cleanups, all over the platforms. This is dominated
largely by the Samsung platforms (s3c, s5p, exynos) and a few of the
others moving code out of arch/arm into more appropriate subsystems.
The clocksource and irqchip drivers are now abstracted to the point
where platforms that are already cleaned up do not need to even specify
the driver they use, it can all get configured from the device tree
as we do for normal device drivers. The clocksource changes basically
touch every single platform in the process.

We further clean up the use of platform specific header files here,
with the goal of turning more of the platforms over to being
"multiplatform" enabled, which implies that they cannot expose
their headers to architecture independent code any more.

It is expected that no functional changes are part of the cleanup.
The overall reduction in total code lines is mostly the result of
removing broken and obsolete code.

----------------------------------------------------------------

Andrew Lunn (1):
      ARM: Kirkwood: Cleanup unneeded include files

Arnd Bergmann (3):
      ARM: kirkwood: add missing include for nsa310
      Merge tag 'cleanup_for_v3.9_round3' of git://git.infradead.org/users/jcooper/linux into next/cleanup

Fabio Estevam (3):
      ARM: mach-imx: Kconfig: Do not select Babbage for MACH_IMX51_DT
      ARM: imx: Remove mach-mx51_3ds board
      ARM: imx: Remove mx508 support

Heiko Stuebner (9):
      ARM: S3C24XX: transform irq handling into a declarative form
      ARM: S3C24XX: Move irq syscore-ops to irq-pm
      ARM: S3C24XX: Modify s3c_irq_wake to use the hwirq property
      ARM: S3C24XX: move s3c2416 irq init to common irq code
      ARM: S3C24XX: modify s3c2416 irq init to initialize all irqs
      ARM: S3C24XX: transform s3c2416 irqs into new structure
      ARM: S3C24XX: move s3c2443 irq code to irq.c
      ARM: S3C24XX: modify s3c2443 irq init to initialize all irqs
      ARM: S3C24XX: transform s3c2443 subirqs into new structure

Hiroshi Doyu (2):
      clocksource: tegra: cosmetic: Fix error message
      ARM: tegra: Make variables static

Jason Cooper (3):
      ARM: kirkwood: nsa310: cleanup includes and unneeded code
      ARM: kirkwood: nsa310: cleanup includes and unneeded code
      ARM: mvebu: correct gated clock documentation

Joachim Eastwood (1):
      ARM: at91: fix board-rm9200-dt after sys_timer conversion

Joseph Lo (7):
      ARM: tegra30: fix power up sequence for boot_secondary
      ARM: tegra: update the cache maintenance order for CPU shutdown
      ARM: tegra: moving the clock gating procedure to tegra_cpu_kill
      ARM: tegra: clean up the CPUINIT section
      ARM: tegra: make device can run on UP
      ARM: tegra30: make the wait time of CPU power up to proportional to HZ
      ARM: tegra: fix compile error when disable CPU_IDLE

Kukjin Kim (35):
      cpufreq: exynos: cleanup exynos-cpufreq header
      ARM: S5P64X0: remove gpiolib.c file in mach-s5p64x0
      ARM: S5P64X0: move i2c.h into local directory
      ARM: S5P64X0: move s5p64x0-clock.h into local directory
      ARM: S5PV210: move regs-sys.h into setup-usb-phy.c file
      ARM: EXYNOS: move mach/pmu.h file into common.h
      ARM: SAMSUNG: cleanup mach/regs-audss.h file
      ARM: SAMSUNG: cleanup mach/gpio-fns.h gpio-track.h and gpio-nrs.h
      ARM: S3C24XX: make anubis-cpld, anubis-irq and anubis-map local
      ARM: S3C24XX: make bast-cpld.h, bast-irq.h and bast-map.h local
      ARM: S3C24XX: make gta02.h local
      ARM: S3C24XX: make h1940.h and h1940-latch.h local
      ARM: S3C24XX: make osiris-cpld.h and osiris-map.h local
      ARM: S3C24XX: make otom-map.h local
      ARM: S3C24XX: make vr1000-cpld.h, vr1000-irq.h and vr1000-map.h local
      ARM: S3C2416: remove regs-s3c2416-mem.h and regs-s3c2416.h
      ARM: S3C2412: cleanup regs-s3c2412.h
      ARM: S3C24XX: remove idle.h
      ARM: S3C24XX: remove dsc.c and make regs-dsc.h local
      ARM: S3C64XX: make crag6410.h local
      ARM: S3C64XX: make regs-gpio-memport.h local
      ARM: S3C64XX: make regs-modem.h local
      ARM: S3C64XX: make regs-srom.h local
      ARM: S3C64XX: make regs-sys.h local
      ARM: S3C64XX: make regs-syscon-power.h local
      ARM: S3C24XX: Move mach-s3c2410/ cpufreq into mach-s3c24xx/
      ARM: S3C24XX: Move mach-s3c2410/ pll into mach-s3c24xx/
      ARM: S3C2412: Remove useless codes mach-s3c2412/gpio.c
      ARM: S3C24XX: Move mach-s3c2412/ cpufreq driver into mach-s3c24xx/
      ARM: S3C24XX: Move mach-s3c2440/ cpufreq driver into mach-s3c24xx/
      ARM: S3C24XX: Move mach-s3c2440/ pll into mach-s3c24xx/
      ARM: S3C24XX: Remove plat-s3c24xx directory in arch/arm/
      ARM: S3C24XX: header mach/regs-s3c2412-mem.h local
      ARM: S3C24XX: header mach/regs-power.h local
      ARM: S3C24XX: header mach/regs-mem.h local

Linus Walleij (4):
      mfd: prcmu: delete pin control helpers
      ARM: ux500: de-globalize <mach/id.h>
      drivers/db8500-cpufreq: delete dangling include
      mfd: db8500-prcmu: update resource passing

Maxime Coquelin (1):
      ARM: ux500: Introduce cpu_is_u8580()

Maxime Ripard (1):
      sunxi: Cleanup the reset code and add meaningful registers defines

Michal Simek (2):
      arm: zynq: Add missing irqchip.h to common.c
      arm: zynq: Add missing irqchip.h to common.c

Nicolas Ferre (1):
      ARM: at91: remove NEOCORE 926 board

Olof Johansson (25):
      Merge tag 'swarren-for-3.9-arm-timer-rework' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge branch 'timer/cleanup' into next/cleanup
      Merge branch 'timer/cleanup' into next/cleanup
      Merge branch 'clocksource/cleanup' into next/cleanup
      Merge tag 'vt8500/timer' of git://server.prisktech.co.nz/git/linuxwmt into next/cleanup
      Merge tag 'gic-vic-to-irqchip' of git://sources.calxeda.com/kernel/linux into next/cleanup
      Merge branch 'vt8500/timer' into next/cleanup
      Merge tag 'cleanup_for_v3.9' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'v3.8-rc5' into next/cleanup
      Merge branch 'armsoc/fix' of git://github.com/hzhuang1/linux into next/cleanup
      Merge tag 'imx-cleanup-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/cleanup
      Merge tag 'bcm2835-for-3.9-cleanup' of git://git.kernel.org/.../swarren/linux-rpi into next/cleanup
      Merge tag 'cleanup_for_v3.9_round2' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'ux500-no-idh' of git://git.kernel.org/.../linusw/linux-stericsson into next/cleanup
      Merge branch 'zynq/timer' of git://git.xilinx.com/linux-xlnx into next/cleanup
      Merge branch 'next/cleanup-header' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'cleanup_for_v3.9_round2' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'cleanup-decompwdog-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/cleanup
      Merge tag 'tegra-for-3.9-cleanup' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge branch 'next/cleanup-s3c24xx' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge branch 'next/irq-s3c24xx' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge branch 'next/cleanup-s3c24xx-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'v3.8-rc6' into next/cleanup
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge tag 'for-arm-soc-cleanup' of git://git.kernel.org/.../linusw/linux-stericsson into next/cleanup

Richard Zhao (1):
      ARM: tegra: cpufreq: move clk_get/put out of function tegra_cpu_init/exit

Rob Herring (17):
      ARM: GIC: remove assembly ifdefs from gic.h
      ARM: GIC: remove direct use of gic_raise_softirq
      ARM: GIC: set handle_arch_irq in GIC initialization
      ARM: remove mach .handle_irq for GIC users
      irqchip: Move ARM GIC to drivers/irqchip
      ARM: use common irqchip_init for GIC init
      irqchip: Move ARM gic.h to include/linux/irqchip/arm-gic.h
      ARM: VIC: shrink down vic.h
      ARM: VIC: set handle_arch_irq in VIC initialization
      ARM: remove mach .handle_irq for VIC users
      ARM: remove unneeded vic.h includes
      ARM: samsung: remove unused tick.h
      irqchip: Move ARM VIC to drivers/irqchip
      ARM: spear: use common irqchip_init function
      ARM: picoxcell: use common irqchip_init function
      irqchip: Move ARM vic.h to include/linux/irqchip/arm-vic.h
      ARM: exynos: move exynos4210-combiner to drivers/irqchip

Sebastian Hesselbarth (2):
      ARM: dove: cleanup includes
      ARM: dove: cleanup includes

Shawn Guo (9):
      ARM: decompress: remove unused ARCH_HAS_DECOMP_WDOG
      ARM: remove unused arch_decomp_wdog()
      ARM: samsung: remove unused arch_decomp_wdog() code
      clockevents: export clockevents_config_and_register for module use
      ARM: use clockevents_config_and_register() where possible
      clocksource: use clockevents_config_and_register() where possible
      ARM: remove redundant 'select GENERIC_GPIO'
      ARM: imx: remove unused imx6q_clock_map_io()
      ARM: imx: use debug_ll_io_init() for imx6q

Soren Brinkmann (7):
      arm: zynq: timer: Replace PSS through PS
      arm: zynq: timer: Remove unnecessary register write
      arm: zynq: timer: Remove unused #defines
      arm: zynq: timer: Align columns
      arm: zynq: timer: Remove redundant #includes
      arm: zynq: timer: Fix comment style
      arm: zynq: timer: Set clock_event cpumask

Srinidhi Kasagar (1):
      ARM: mach-ux500: use SGI0 to wake up the other core

Stephen Warren (20):
      cris: move usec/nsec conversion to do_slow_gettimeoffset
      time: convert arch_gettimeoffset to a pointer
      m68k: set arch_gettimeoffset directly
      ARM: set arch_gettimeoffset directly
      ARM: at91: convert timer suspend/resume to clock_event_device
      ARM: pxa: convert timer suspend/resume to clock_event_device
      ARM: sa1100: convert timer suspend/resume to clock_event_device
      ARM: ux500: convert timer suspend/resume to clock_event_device
      ARM: samsung: register syscore_ops for timer resume directly
      ARM: remove struct sys_timer suspend and resume fields
      ARM: delete struct sys_timer
      clocksource: add common of_clksrc_init() function
      ARM: sunxi: fix struct sys_timer removal
      Merge remote-tracking branch 'korg_arm-soc/timer/cleanup' into cleanup
      ARM: bcm2835: make use of CLKSRC_OF
      Merge remote-tracking branch 'korg_arm-soc/timer/cleanup' into for-3.9/cleanup
      ARM: tegra: move timer.c to drivers/clocksource/
      ARM: tegra: fix Kconfig warnings when !SMP
      ARM: imx: fix imx31-dt.c time-related warning
      clocksource: always define CLOCKSOURCE_OF_DECLARE

Thomas Petazzoni (4):
      arm: kirkwood: dockstar: remove useless include of SDIO header
      irqchip: add to the directories part of the IRQ subsystem in MAINTAINERS
      irqchip: add basic infrastructure
      arm: add set_handle_irq() to register the parent IRQ controller handler function

Tomasz Figa (1):
      ARM: S3C64XX: Fix missing header error with CONFIG_CPU_IDLE enabled

Tony Prisk (2):
      timer: vt8500: Move timer code to drivers/clocksource
      timer: vt8500: Convert vt8500 to use CLKSRC_OF

 .../bindings/clock/mvebu-gated-clock.txt           |   2 +-
 MAINTAINERS                                        |   1 +
 arch/arm/Kconfig                                   |  16 +-
 arch/arm/Kconfig.debug                             |  10 +-
 arch/arm/Makefile                                  |   4 +-
 arch/arm/arm-soc-for-next-contents.txt             |  19 +
 arch/arm/boot/compressed/decompress.c              |   2 -
 arch/arm/common/Kconfig                            |  23 -
 arch/arm/common/Makefile                           |   2 -
 arch/arm/configs/at91sam9263_defconfig             |   1 -
 arch/arm/configs/imx_v6_v7_defconfig               |   1 -
 arch/arm/include/asm/mach/arch.h                   |   3 +-
 arch/arm/include/asm/mach/irq.h                    |   1 +
 arch/arm/include/asm/mach/time.h                   |  30 -
 arch/arm/include/debug/imx.S                       |   2 +-
 arch/arm/kernel/irq.c                              |  10 +
 arch/arm/kernel/smp.c                              |   3 +-
 arch/arm/kernel/smp_twd.c                          |   1 -
 arch/arm/kernel/time.c                             |  53 +-
 arch/arm/mach-at91/Kconfig                         |   6 -
 arch/arm/mach-at91/Makefile                        |   1 -
 arch/arm/mach-at91/at91rm9200_time.c               |  12 +-
 arch/arm/mach-at91/at91sam926x_time.c              |  53 +-
 arch/arm/mach-at91/at91x40_time.c                  |  13 +-
 arch/arm/mach-at91/board-1arm.c                    |   2 +-
 arch/arm/mach-at91/board-afeb-9260v1.c             |   2 +-
 arch/arm/mach-at91/board-cam60.c                   |   2 +-
 arch/arm/mach-at91/board-carmeva.c                 |   2 +-
 arch/arm/mach-at91/board-cpu9krea.c                |   2 +-
 arch/arm/mach-at91/board-cpuat91.c                 |   2 +-
 arch/arm/mach-at91/board-csb337.c                  |   2 +-
 arch/arm/mach-at91/board-csb637.c                  |   2 +-
 arch/arm/mach-at91/board-dt.c                      |   2 +-
 arch/arm/mach-at91/board-eb01.c                    |   2 +-
 arch/arm/mach-at91/board-eb9200.c                  |   2 +-
 arch/arm/mach-at91/board-ecbat91.c                 |   2 +-
 arch/arm/mach-at91/board-eco920.c                  |   2 +-
 arch/arm/mach-at91/board-flexibity.c               |   2 +-
 arch/arm/mach-at91/board-foxg20.c                  |   2 +-
 arch/arm/mach-at91/board-gsia18s.c                 |   2 +-
 arch/arm/mach-at91/board-kafa.c                    |   2 +-
 arch/arm/mach-at91/board-kb9202.c                  |   2 +-
 arch/arm/mach-at91/board-neocore926.c              | 387 --------
 arch/arm/mach-at91/board-pcontrol-g20.c            |   2 +-
 arch/arm/mach-at91/board-picotux200.c              |   2 +-
 arch/arm/mach-at91/board-qil-a9260.c               |   2 +-
 arch/arm/mach-at91/board-rm9200-dt.c               |   2 +-
 arch/arm/mach-at91/board-rm9200dk.c                |   2 +-
 arch/arm/mach-at91/board-rm9200ek.c                |   2 +-
 arch/arm/mach-at91/board-rsi-ews.c                 |   2 +-
 arch/arm/mach-at91/board-sam9-l9260.c              |   2 +-
 arch/arm/mach-at91/board-sam9260ek.c               |   2 +-
 arch/arm/mach-at91/board-sam9261ek.c               |   2 +-
 arch/arm/mach-at91/board-sam9263ek.c               |   2 +-
 arch/arm/mach-at91/board-sam9g20ek.c               |   4 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c            |   2 +-
 arch/arm/mach-at91/board-sam9rlek.c                |   2 +-
 arch/arm/mach-at91/board-snapper9260.c             |   2 +-
 arch/arm/mach-at91/board-stamp9g20.c               |   4 +-
 arch/arm/mach-at91/board-usb-a926x.c               |   6 +-
 arch/arm/mach-at91/board-yl-9200.c                 |   2 +-
 arch/arm/mach-at91/generic.h                       |   7 +-
 arch/arm/mach-at91/include/mach/uncompress.h       |   2 -
 arch/arm/mach-bcm/Kconfig                          |   1 -
 arch/arm/mach-bcm/board_bcm.c                      |  22 +-
 arch/arm/mach-bcm2835/bcm2835.c                    |   4 +-
 arch/arm/mach-bcm2835/include/mach/uncompress.h    |   1 -
 arch/arm/mach-clps711x/board-autcpu12.c            |   2 +-
 arch/arm/mach-clps711x/board-cdb89712.c            |   2 +-
 arch/arm/mach-clps711x/board-clep7312.c            |   2 +-
 arch/arm/mach-clps711x/board-edb7211.c             |   2 +-
 arch/arm/mach-clps711x/board-fortunet.c            |   2 +-
 arch/arm/mach-clps711x/board-p720t.c               |   2 +-
 arch/arm/mach-clps711x/common.c                    |   6 +-
 arch/arm/mach-clps711x/common.h                    |   4 +-
 arch/arm/mach-clps711x/include/mach/uncompress.h   |   2 -
 arch/arm/mach-cns3xxx/cns3420vb.c                  |   4 +-
 arch/arm/mach-cns3xxx/core.c                       |  21 +-
 arch/arm/mach-cns3xxx/core.h                       |   2 +-
 arch/arm/mach-cns3xxx/include/mach/uncompress.h    |   1 -
 arch/arm/mach-davinci/board-da830-evm.c            |   2 +-
 arch/arm/mach-davinci/board-da850-evm.c            |   2 +-
 arch/arm/mach-davinci/board-dm355-evm.c            |   2 +-
 arch/arm/mach-davinci/board-dm355-leopard.c        |   2 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |   2 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |   2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |   4 +-
 arch/arm/mach-davinci/board-mityomapl138.c         |   2 +-
 arch/arm/mach-davinci/board-neuros-osd2.c          |   2 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c        |   2 +-
 arch/arm/mach-davinci/board-sffsdr.c               |   2 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |   2 +-
 arch/arm/mach-davinci/da8xx-dt.c                   |   2 +-
 arch/arm/mach-davinci/include/mach/common.h        |   4 +-
 arch/arm/mach-davinci/include/mach/uncompress.h    |   1 -
 arch/arm/mach-davinci/time.c                       |   7 +-
 arch/arm/mach-dove/cm-a510.c                       |   2 +-
 arch/arm/mach-dove/common.c                        |  37 +-
 arch/arm/mach-dove/common.h                        |   2 +-
 arch/arm/mach-dove/dove-db-setup.c                 |   2 +-
 arch/arm/mach-dove/include/mach/uncompress.h       |   1 -
 arch/arm/mach-ebsa110/core.c                       |  15 +-
 arch/arm/mach-ebsa110/include/mach/uncompress.h    |   1 -
 arch/arm/mach-ep93xx/adssphere.c                   |   4 +-
 arch/arm/mach-ep93xx/core.c                        |  38 +-
 arch/arm/mach-ep93xx/edb93xx.c                     |  25 +-
 arch/arm/mach-ep93xx/gesbc9312.c                   |   4 +-
 arch/arm/mach-ep93xx/include/mach/platform.h       |   2 +-
 arch/arm/mach-ep93xx/include/mach/uncompress.h     |   2 -
 arch/arm/mach-ep93xx/micro9.c                      |  13 +-
 arch/arm/mach-ep93xx/simone.c                      |   4 +-
 arch/arm/mach-ep93xx/snappercl15.c                 |   4 +-
 arch/arm/mach-ep93xx/ts72xx.c                      |   4 +-
 arch/arm/mach-ep93xx/vision_ep9307.c               |   4 +-
 arch/arm/mach-exynos/common.c                      | 223 +----
 arch/arm/mach-exynos/common.h                      |  25 +-
 arch/arm/mach-exynos/cpuidle.c                     |   3 +-
 arch/arm/mach-exynos/dev-audio.c                   |   3 +-
 arch/arm/mach-exynos/include/mach/pmu.h            |  34 -
 arch/arm/mach-exynos/include/mach/regs-audss.h     |  18 -
 arch/arm/mach-exynos/include/mach/regs-irq.h       |   2 +-
 arch/arm/mach-exynos/mach-armlex4210.c             |   4 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   4 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   4 +-
 arch/arm/mach-exynos/mach-nuri.c                   |   4 +-
 arch/arm/mach-exynos/mach-origen.c                 |   4 +-
 arch/arm/mach-exynos/mach-smdk4x12.c               |   7 +-
 arch/arm/mach-exynos/mach-smdkv310.c               |   7 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |   4 +-
 arch/arm/mach-exynos/mct.c                         |  25 +-
 arch/arm/mach-exynos/platsmp.c                     |   6 +-
 arch/arm/mach-exynos/pm.c                          |   3 +-
 arch/arm/mach-exynos/pmu.c                         |   3 +-
 arch/arm/mach-footbridge/cats-hw.c                 |   2 +-
 arch/arm/mach-footbridge/common.h                  |   4 +-
 arch/arm/mach-footbridge/dc21285-timer.c           |  12 +-
 arch/arm/mach-footbridge/ebsa285.c                 |   2 +-
 arch/arm/mach-footbridge/include/mach/uncompress.h |   1 -
 arch/arm/mach-footbridge/isa-timer.c               |   6 +-
 arch/arm/mach-footbridge/netwinder-hw.c            |   2 +-
 arch/arm/mach-footbridge/personal.c                |   2 +-
 arch/arm/mach-gemini/board-nas4220b.c              |   6 +-
 arch/arm/mach-gemini/board-rut1xx.c                |   6 +-
 arch/arm/mach-gemini/board-wbd111.c                |   6 +-
 arch/arm/mach-gemini/board-wbd222.c                |   6 +-
 arch/arm/mach-gemini/include/mach/uncompress.h     |   2 -
 arch/arm/mach-h720x/common.c                       |   6 +-
 arch/arm/mach-h720x/common.h                       |   6 +-
 arch/arm/mach-h720x/cpu-h7201.c                    |   9 +-
 arch/arm/mach-h720x/cpu-h7202.c                    |   9 +-
 arch/arm/mach-h720x/h7201-eval.c                   |   2 +-
 arch/arm/mach-h720x/h7202-eval.c                   |   2 +-
 arch/arm/mach-h720x/include/mach/uncompress.h      |   1 -
 arch/arm/mach-highbank/highbank.c                  |  17 +-
 arch/arm/mach-highbank/platsmp.c                   |   6 +-
 arch/arm/mach-imx/Kconfig                          |  36 -
 arch/arm/mach-imx/Makefile                         |   3 -
 arch/arm/mach-imx/Makefile.boot                    |   4 -
 arch/arm/mach-imx/clk-imx6q.c                      |   2 -
 arch/arm/mach-imx/common.h                         |  12 -
 arch/arm/mach-imx/cpu-imx5.c                       |  39 -
 arch/arm/mach-imx/devices-imx50.h                  |  33 -
 arch/arm/mach-imx/devices/Kconfig                  |   2 +-
 arch/arm/mach-imx/devices/platform-fec.c           |   6 -
 arch/arm/mach-imx/devices/platform-imx-i2c.c       |  10 -
 arch/arm/mach-imx/devices/platform-imx-uart.c      |  12 -
 arch/arm/mach-imx/epit.c                           |  15 +-
 arch/arm/mach-imx/gpc.c                            |   2 +-
 arch/arm/mach-imx/hardware.h                       |   6 -
 arch/arm/mach-imx/imx25-dt.c                       |  11 +-
 arch/arm/mach-imx/imx27-dt.c                       |  16 +-
 arch/arm/mach-imx/imx31-dt.c                       |  16 +-
 arch/arm/mach-imx/imx51-dt.c                       |  16 +-
 arch/arm/mach-imx/iomux-mx50.h                     | 977 ---------------------
 arch/arm/mach-imx/lluart.c                         |  47 -
 arch/arm/mach-imx/mach-apf9328.c                   |   6 +-
 arch/arm/mach-imx/mach-armadillo5x0.c              |   6 +-
 arch/arm/mach-imx/mach-bug.c                       |   6 +-
 arch/arm/mach-imx/mach-cpuimx27.c                  |   6 +-
 arch/arm/mach-imx/mach-cpuimx35.c                  |   6 +-
 arch/arm/mach-imx/mach-cpuimx51sd.c                |   6 +-
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c           |   6 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |   6 +-
 arch/arm/mach-imx/mach-imx27ipcam.c                |   6 +-
 arch/arm/mach-imx/mach-imx27lite.c                 |   6 +-
 arch/arm/mach-imx/mach-imx53.c                     |  16 +-
 arch/arm/mach-imx/mach-imx6q.c                     |  20 +-
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |   6 +-
 arch/arm/mach-imx/mach-mx1ads.c                    |   8 +-
 arch/arm/mach-imx/mach-mx21ads.c                   |   6 +-
 arch/arm/mach-imx/mach-mx25_3ds.c                  |   6 +-
 arch/arm/mach-imx/mach-mx27_3ds.c                  |   6 +-
 arch/arm/mach-imx/mach-mx27ads.c                   |   6 +-
 arch/arm/mach-imx/mach-mx31_3ds.c                  |   6 +-
 arch/arm/mach-imx/mach-mx31ads.c                   |   6 +-
 arch/arm/mach-imx/mach-mx31lilly.c                 |   6 +-
 arch/arm/mach-imx/mach-mx31lite.c                  |   6 +-
 arch/arm/mach-imx/mach-mx31moboard.c               |   6 +-
 arch/arm/mach-imx/mach-mx35_3ds.c                  |   6 +-
 arch/arm/mach-imx/mach-mx50_rdp.c                  | 225 -----
 arch/arm/mach-imx/mach-mx51_3ds.c                  | 178 ----
 arch/arm/mach-imx/mach-mx51_babbage.c              |   6 +-
 arch/arm/mach-imx/mach-mxt_td60.c                  |   6 +-
 arch/arm/mach-imx/mach-pca100.c                    |   6 +-
 arch/arm/mach-imx/mach-pcm037.c                    |   6 +-
 arch/arm/mach-imx/mach-pcm038.c                    |   6 +-
 arch/arm/mach-imx/mach-pcm043.c                    |   6 +-
 arch/arm/mach-imx/mach-qong.c                      |   6 +-
 arch/arm/mach-imx/mach-scb9328.c                   |   6 +-
 arch/arm/mach-imx/mach-vpr200.c                    |   6 +-
 arch/arm/mach-imx/mm-imx5.c                        |  48 -
 arch/arm/mach-imx/mx50.h                           | 290 ------
 arch/arm/mach-imx/mxc.h                            |  13 -
 arch/arm/mach-imx/platsmp.c                        |   4 +-
 arch/arm/mach-imx/pm-imx5.c                        |   7 +-
 arch/arm/mach-imx/time.c                           |  15 +-
 arch/arm/mach-integrator/include/mach/uncompress.h |   2 -
 arch/arm/mach-integrator/integrator_ap.c           |  16 +-
 arch/arm/mach-integrator/integrator_cp.c           |  16 +-
 arch/arm/mach-iop13xx/include/mach/uncompress.h    |   1 -
 arch/arm/mach-iop13xx/iq81340mc.c                  |   6 +-
 arch/arm/mach-iop13xx/iq81340sc.c                  |   6 +-
 arch/arm/mach-iop32x/em7210.c                      |   6 +-
 arch/arm/mach-iop32x/glantank.c                    |   6 +-
 arch/arm/mach-iop32x/include/mach/uncompress.h     |   1 -
 arch/arm/mach-iop32x/iq31244.c                     |   8 +-
 arch/arm/mach-iop32x/iq80321.c                     |   6 +-
 arch/arm/mach-iop32x/n2100.c                       |   6 +-
 arch/arm/mach-iop33x/include/mach/uncompress.h     |   1 -
 arch/arm/mach-iop33x/iq80331.c                     |   6 +-
 arch/arm/mach-iop33x/iq80332.c                     |   6 +-
 arch/arm/mach-ixp4xx/avila-setup.c                 |   4 +-
 arch/arm/mach-ixp4xx/common.c                      |  15 +-
 arch/arm/mach-ixp4xx/coyote-setup.c                |   4 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c               |   6 +-
 arch/arm/mach-ixp4xx/fsg-setup.c                   |   2 +-
 arch/arm/mach-ixp4xx/gateway7001-setup.c           |   2 +-
 arch/arm/mach-ixp4xx/goramo_mlr.c                  |   2 +-
 arch/arm/mach-ixp4xx/gtwx5715-setup.c              |   2 +-
 arch/arm/mach-ixp4xx/include/mach/platform.h       |   3 -
 arch/arm/mach-ixp4xx/include/mach/uncompress.h     |   2 -
 arch/arm/mach-ixp4xx/ixdp425-setup.c               |   8 +-
 arch/arm/mach-ixp4xx/nas100d-setup.c               |   2 +-
 arch/arm/mach-ixp4xx/nslu2-setup.c                 |   6 +-
 arch/arm/mach-ixp4xx/omixp-setup.c                 |   6 +-
 arch/arm/mach-ixp4xx/vulcan-setup.c                |   2 +-
 arch/arm/mach-ixp4xx/wg302v2-setup.c               |   2 +-
 arch/arm/mach-kirkwood/board-dt.c                  |   2 +-
 arch/arm/mach-kirkwood/board-ib62x0.c              |   1 -
 arch/arm/mach-kirkwood/board-mplcec4.c             |   1 -
 arch/arm/mach-kirkwood/board-nsa310.c              |  10 +-
 arch/arm/mach-kirkwood/common.c                    |   6 +-
 arch/arm/mach-kirkwood/common.h                    |   2 +-
 arch/arm/mach-kirkwood/d2net_v2-setup.c            |   2 +-
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c        |   2 +-
 arch/arm/mach-kirkwood/dockstar-setup.c            |   3 +-
 arch/arm/mach-kirkwood/guruplug-setup.c            |   2 +-
 arch/arm/mach-kirkwood/include/mach/uncompress.h   |   1 -
 arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c     |   2 +-
 arch/arm/mach-kirkwood/netspace_v2-setup.c         |   6 +-
 arch/arm/mach-kirkwood/netxbig_v2-setup.c          |   4 +-
 arch/arm/mach-kirkwood/openrd-setup.c              |   6 +-
 arch/arm/mach-kirkwood/rd88f6192-nas-setup.c       |   2 +-
 arch/arm/mach-kirkwood/rd88f6281-setup.c           |   2 +-
 arch/arm/mach-kirkwood/sheevaplug-setup.c          |   4 +-
 arch/arm/mach-kirkwood/t5325-setup.c               |   2 +-
 arch/arm/mach-kirkwood/ts219-setup.c               |   2 +-
 arch/arm/mach-kirkwood/ts41x-setup.c               |   2 +-
 arch/arm/mach-ks8695/board-acs5k.c                 |   2 +-
 arch/arm/mach-ks8695/board-dsm320.c                |   2 +-
 arch/arm/mach-ks8695/board-micrel.c                |   2 +-
 arch/arm/mach-ks8695/board-og.c                    |  10 +-
 arch/arm/mach-ks8695/board-sg.c                    |   6 +-
 arch/arm/mach-ks8695/generic.h                     |   2 +-
 arch/arm/mach-ks8695/include/mach/uncompress.h     |   1 -
 arch/arm/mach-ks8695/time.c                        |   6 +-
 arch/arm/mach-lpc32xx/common.h                     |   2 +-
 arch/arm/mach-lpc32xx/include/mach/uncompress.h    |   1 -
 arch/arm/mach-lpc32xx/phy3250.c                    |   2 +-
 arch/arm/mach-lpc32xx/timer.c                      |  16 +-
 arch/arm/mach-mmp/aspenite.c                       |   4 +-
 arch/arm/mach-mmp/avengers_lite.c                  |   2 +-
 arch/arm/mach-mmp/brownstone.c                     |   2 +-
 arch/arm/mach-mmp/common.h                         |   2 -
 arch/arm/mach-mmp/flint.c                          |   2 +-
 arch/arm/mach-mmp/gplugd.c                         |   2 +-
 arch/arm/mach-mmp/include/mach/mmp2.h              |   4 +-
 arch/arm/mach-mmp/include/mach/pxa168.h            |   4 +-
 arch/arm/mach-mmp/include/mach/pxa910.h            |   4 +-
 arch/arm/mach-mmp/include/mach/uncompress.h        |   6 -
 arch/arm/mach-mmp/jasper.c                         |   2 +-
 arch/arm/mach-mmp/mmp-dt.c                         |   8 +-
 arch/arm/mach-mmp/mmp2-dt.c                        |   6 +-
 arch/arm/mach-mmp/mmp2.c                           |   6 +-
 arch/arm/mach-mmp/pxa168.c                         |   6 +-
 arch/arm/mach-mmp/pxa910.c                         |   6 +-
 arch/arm/mach-mmp/tavorevb.c                       |   2 +-
 arch/arm/mach-mmp/teton_bga.c                      |   2 +-
 arch/arm/mach-mmp/time.c                           |   7 +-
 arch/arm/mach-mmp/ttc_dkb.c                        |   2 +-
 arch/arm/mach-msm/board-dt-8660.c                  |  18 +-
 arch/arm/mach-msm/board-dt-8960.c                  |  18 +-
 arch/arm/mach-msm/board-halibut.c                  |   2 +-
 arch/arm/mach-msm/board-mahimahi.c                 |   4 +-
 arch/arm/mach-msm/board-msm7x30.c                  |   6 +-
 arch/arm/mach-msm/board-qsd8x50.c                  |   4 +-
 arch/arm/mach-msm/board-sapphire.c                 |   4 +-
 arch/arm/mach-msm/board-trout.c                    |   2 +-
 arch/arm/mach-msm/common.h                         |   8 +-
 arch/arm/mach-msm/include/mach/uncompress.h        |   4 -
 arch/arm/mach-msm/platsmp.c                        |   6 +-
 arch/arm/mach-msm/timer.c                          |  31 +-
 arch/arm/mach-mv78xx0/buffalo-wxl-setup.c          |   2 +-
 arch/arm/mach-mv78xx0/common.c                     |   6 +-
 arch/arm/mach-mv78xx0/common.h                     |   2 +-
 arch/arm/mach-mv78xx0/db78x00-bp-setup.c           |   2 +-
 arch/arm/mach-mv78xx0/include/mach/uncompress.h    |   1 -
 arch/arm/mach-mv78xx0/rd78x00-masa-setup.c         |   2 +-
 arch/arm/mach-mvebu/armada-370-xp.c                |   6 +-
 arch/arm/mach-mxs/include/mach/uncompress.h        |   1 -
 arch/arm/mach-mxs/mach-mxs.c                       |  12 +-
 arch/arm/mach-mxs/timer.c                          |  24 +-
 arch/arm/mach-netx/generic.c                       |   2 +-
 arch/arm/mach-netx/generic.h                       |   3 +-
 arch/arm/mach-netx/include/mach/uncompress.h       |   1 -
 arch/arm/mach-netx/nxdb500.c                       |   4 +-
 arch/arm/mach-netx/nxdkn.c                         |   4 +-
 arch/arm/mach-netx/nxeb500hmi.c                    |   4 +-
 arch/arm/mach-netx/time.c                          |  16 +-
 arch/arm/mach-nomadik/board-nhk8815.c              |   8 +-
 arch/arm/mach-nomadik/cpu-8815.c                   |   2 +-
 arch/arm/mach-nomadik/include/mach/uncompress.h    |   2 -
 arch/arm/mach-omap1/board-ams-delta.c              |   2 +-
 arch/arm/mach-omap1/board-fsample.c                |   2 +-
 arch/arm/mach-omap1/board-generic.c                |   2 +-
 arch/arm/mach-omap1/board-h2.c                     |   2 +-
 arch/arm/mach-omap1/board-h3.c                     |   2 +-
 arch/arm/mach-omap1/board-htcherald.c              |   2 +-
 arch/arm/mach-omap1/board-innovator.c              |   2 +-
 arch/arm/mach-omap1/board-nokia770.c               |   2 +-
 arch/arm/mach-omap1/board-osk.c                    |   2 +-
 arch/arm/mach-omap1/board-palmte.c                 |   2 +-
 arch/arm/mach-omap1/board-palmtt.c                 |   2 +-
 arch/arm/mach-omap1/board-palmz71.c                |   2 +-
 arch/arm/mach-omap1/board-perseus2.c               |   2 +-
 arch/arm/mach-omap1/board-sx1.c                    |   2 +-
 arch/arm/mach-omap1/board-voiceblue.c              |   2 +-
 arch/arm/mach-omap1/common.h                       |   2 +-
 arch/arm/mach-omap1/include/mach/uncompress.h      |   5 -
 arch/arm/mach-omap1/time.c                         |  17 +-
 arch/arm/mach-omap1/timer32k.c                     |  12 +-
 arch/arm/mach-omap2/board-2430sdp.c                |   2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   2 +-
 arch/arm/mach-omap2/board-3630sdp.c                |   2 +-
 arch/arm/mach-omap2/board-4430sdp.c                |   5 +-
 arch/arm/mach-omap2/board-am3517crane.c            |   2 +-
 arch/arm/mach-omap2/board-am3517evm.c              |   2 +-
 arch/arm/mach-omap2/board-apollon.c                |   2 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   4 +-
 arch/arm/mach-omap2/board-cm-t3517.c               |   2 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   2 +-
 arch/arm/mach-omap2/board-generic.c                |  17 +-
 arch/arm/mach-omap2/board-h4.c                     |   2 +-
 arch/arm/mach-omap2/board-igep0020.c               |   4 +-
 arch/arm/mach-omap2/board-ldp.c                    |   2 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   6 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   2 +-
 arch/arm/mach-omap2/board-omap3evm.c               |   2 +-
 arch/arm/mach-omap2/board-omap3logic.c             |   4 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |   2 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |   2 +-
 arch/arm/mach-omap2/board-omap4panda.c             |   5 +-
 arch/arm/mach-omap2/board-overo.c                  |   2 +-
 arch/arm/mach-omap2/board-rm680.c                  |   4 +-
 arch/arm/mach-omap2/board-rx51.c                   |   2 +-
 arch/arm/mach-omap2/board-ti8168evm.c              |   4 +-
 arch/arm/mach-omap2/board-zoom.c                   |   4 +-
 arch/arm/mach-omap2/common.h                       |  14 +-
 arch/arm/mach-omap2/include/mach/uncompress.h      |   5 -
 arch/arm/mach-omap2/omap-smp.c                     |   6 +-
 arch/arm/mach-omap2/omap-wakeupgen.c               |   3 +-
 arch/arm/mach-omap2/omap4-common.c                 |  11 +-
 arch/arm/mach-omap2/timer.c                        |  35 +-
 arch/arm/mach-orion5x/board-dt.c                   |   2 +-
 arch/arm/mach-orion5x/common.c                     |   6 +-
 arch/arm/mach-orion5x/common.h                     |   2 +-
 arch/arm/mach-orion5x/d2net-setup.c                |   4 +-
 arch/arm/mach-orion5x/db88f5281-setup.c            |   2 +-
 arch/arm/mach-orion5x/dns323-setup.c               |   2 +-
 arch/arm/mach-orion5x/include/mach/uncompress.h    |   1 -
 arch/arm/mach-orion5x/kurobox_pro-setup.c          |   4 +-
 arch/arm/mach-orion5x/ls-chl-setup.c               |   2 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c               |   2 +-
 arch/arm/mach-orion5x/lsmini-setup.c               |   2 +-
 arch/arm/mach-orion5x/mss2-setup.c                 |   2 +-
 arch/arm/mach-orion5x/mv2120-setup.c               |   2 +-
 arch/arm/mach-orion5x/net2big-setup.c              |   2 +-
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c       |   2 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c        |   2 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c            |   2 +-
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c       |   2 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c     |   2 +-
 arch/arm/mach-orion5x/ts209-setup.c                |   2 +-
 arch/arm/mach-orion5x/ts409-setup.c                |   2 +-
 arch/arm/mach-orion5x/ts78xx-setup.c               |   2 +-
 arch/arm/mach-orion5x/wnr854t-setup.c              |   2 +-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c           |   2 +-
 arch/arm/mach-picoxcell/Kconfig                    |   1 -
 arch/arm/mach-picoxcell/common.c                   |  17 +-
 arch/arm/mach-picoxcell/common.h                   |   2 +-
 arch/arm/mach-prima2/common.c                      |   2 +-
 arch/arm/mach-prima2/common.h                      |   2 +-
 arch/arm/mach-prima2/include/mach/uncompress.h     |   2 -
 arch/arm/mach-prima2/timer.c                       |  18 +-
 arch/arm/mach-pxa/balloon3.c                       |   2 +-
 arch/arm/mach-pxa/capc7117.c                       |   2 +-
 arch/arm/mach-pxa/cm-x2xx.c                        |   2 +-
 arch/arm/mach-pxa/cm-x300.c                        |   2 +-
 arch/arm/mach-pxa/colibri-pxa270.c                 |   4 +-
 arch/arm/mach-pxa/colibri-pxa300.c                 |   2 +-
 arch/arm/mach-pxa/colibri-pxa320.c                 |   2 +-
 arch/arm/mach-pxa/corgi.c                          |   6 +-
 arch/arm/mach-pxa/csb726.c                         |   2 +-
 arch/arm/mach-pxa/em-x270.c                        |   4 +-
 arch/arm/mach-pxa/eseries.c                        |  12 +-
 arch/arm/mach-pxa/ezx.c                            |  12 +-
 arch/arm/mach-pxa/generic.h                        |   3 +-
 arch/arm/mach-pxa/gumstix.c                        |   2 +-
 arch/arm/mach-pxa/h5000.c                          |   2 +-
 arch/arm/mach-pxa/himalaya.c                       |   2 +-
 arch/arm/mach-pxa/hx4700.c                         |   2 +-
 arch/arm/mach-pxa/icontrol.c                       |   2 +-
 arch/arm/mach-pxa/idp.c                            |   2 +-
 arch/arm/mach-pxa/include/mach/uncompress.h        |   5 -
 arch/arm/mach-pxa/littleton.c                      |   2 +-
 arch/arm/mach-pxa/lpd270.c                         |   2 +-
 arch/arm/mach-pxa/lubbock.c                        |   2 +-
 arch/arm/mach-pxa/magician.c                       |   2 +-
 arch/arm/mach-pxa/mainstone.c                      |   2 +-
 arch/arm/mach-pxa/mioa701.c                        |   2 +-
 arch/arm/mach-pxa/mp900.c                          |   2 +-
 arch/arm/mach-pxa/palmld.c                         |   2 +-
 arch/arm/mach-pxa/palmt5.c                         |   2 +-
 arch/arm/mach-pxa/palmtc.c                         |   2 +-
 arch/arm/mach-pxa/palmte2.c                        |   2 +-
 arch/arm/mach-pxa/palmtreo.c                       |   4 +-
 arch/arm/mach-pxa/palmtx.c                         |   2 +-
 arch/arm/mach-pxa/palmz72.c                        |   2 +-
 arch/arm/mach-pxa/pcm027.c                         |   2 +-
 arch/arm/mach-pxa/poodle.c                         |   2 +-
 arch/arm/mach-pxa/pxa-dt.c                         |   2 +-
 arch/arm/mach-pxa/raumfeld.c                       |   6 +-
 arch/arm/mach-pxa/saar.c                           |   2 +-
 arch/arm/mach-pxa/spitz.c                          |   6 +-
 arch/arm/mach-pxa/stargate2.c                      |   4 +-
 arch/arm/mach-pxa/tavorevb.c                       |   2 +-
 arch/arm/mach-pxa/time.c                           |  76 +-
 arch/arm/mach-pxa/tosa.c                           |   2 +-
 arch/arm/mach-pxa/trizeps4.c                       |   4 +-
 arch/arm/mach-pxa/viper.c                          |   2 +-
 arch/arm/mach-pxa/vpac270.c                        |   2 +-
 arch/arm/mach-pxa/xcep.c                           |   2 +-
 arch/arm/mach-pxa/z2.c                             |   2 +-
 arch/arm/mach-pxa/zeus.c                           |   2 +-
 arch/arm/mach-pxa/zylonite.c                       |   2 +-
 arch/arm/mach-realview/core.c                      |   1 -
 arch/arm/mach-realview/include/mach/uncompress.h   |   1 -
 arch/arm/mach-realview/platsmp.c                   |   3 -
 arch/arm/mach-realview/realview_eb.c               |   9 +-
 arch/arm/mach-realview/realview_pb1176.c           |   9 +-
 arch/arm/mach-realview/realview_pb11mp.c           |   9 +-
 arch/arm/mach-realview/realview_pba8.c             |   9 +-
 arch/arm/mach-realview/realview_pbx.c              |   9 +-
 arch/arm/mach-rpc/include/mach/uncompress.h        |   5 -
 arch/arm/mach-rpc/riscpc.c                         |   4 +-
 arch/arm/mach-rpc/time.c                           |  13 +-
 arch/arm/mach-s3c2410/Kconfig                      |  20 -
 arch/arm/mach-s3c2410/Makefile                     |  14 -
 arch/arm/mach-s3c2412/Kconfig                      |  13 -
 arch/arm/mach-s3c2412/Makefile                     |  12 -
 arch/arm/mach-s3c2412/gpio.c                       |  62 --
 arch/arm/mach-s3c2440/Kconfig                      |  37 -
 arch/arm/mach-s3c2440/Makefile                     |  17 -
 arch/arm/mach-s3c2440/dsc.c                        |  54 --
 arch/arm/mach-s3c24xx/Kconfig                      | 160 ++++
 arch/arm/mach-s3c24xx/Makefile                     |  24 +-
 arch/arm/mach-s3c24xx/anubis.h                     |  53 ++
 arch/arm/mach-s3c24xx/bast-ide.c                   |  18 +-
 arch/arm/mach-s3c24xx/bast-irq.c                   |  19 +-
 arch/arm/mach-s3c24xx/bast.h                       | 197 +++++
 .../{plat-s3c24xx => mach-s3c24xx}/clock-dclk.c    |   3 +-
 .../clock-s3c2410.c}                               |   3 +-
 arch/arm/mach-s3c24xx/common.h                     |   2 +
 .../cpufreq-debugfs.c}                             |   3 +-
 .../cpu-freq.c => mach-s3c24xx/cpufreq-s3c2410.c}  |   7 +-
 .../cpu-freq.c => mach-s3c24xx/cpufreq-s3c2412.c}  |   9 +-
 .../cpufreq-s3c2440.c}                             |   4 +-
 .../cpufreq-utils.c}                               |   6 +-
 .../cpu-freq.c => mach-s3c24xx/cpufreq.c}          |   3 +-
 arch/arm/mach-s3c24xx/dma-s3c2410.c                |   1 -
 arch/arm/mach-s3c24xx/dma-s3c2412.c                |   1 -
 arch/arm/mach-s3c24xx/dma-s3c2440.c                |   1 -
 arch/arm/mach-s3c24xx/dma-s3c2443.c                |   1 -
 arch/arm/{plat-s3c24xx => mach-s3c24xx}/dma.c      |   3 +-
 arch/arm/mach-s3c24xx/{include/mach => }/gta02.h   |  14 +-
 arch/arm/mach-s3c24xx/h1940-bluetooth.c            |   6 +-
 .../{include/mach/h1940-latch.h => h1940.h}        |  22 +-
 arch/arm/mach-s3c24xx/include/mach/anubis-cpld.h   |  25 -
 arch/arm/mach-s3c24xx/include/mach/anubis-irq.h    |  21 -
 arch/arm/mach-s3c24xx/include/mach/anubis-map.h    |  38 -
 arch/arm/mach-s3c24xx/include/mach/bast-cpld.h     |  53 --
 arch/arm/mach-s3c24xx/include/mach/bast-irq.h      |  29 -
 arch/arm/mach-s3c24xx/include/mach/bast-map.h      | 146 ---
 arch/arm/mach-s3c24xx/include/mach/gpio-fns.h      |   1 -
 arch/arm/mach-s3c24xx/include/mach/gpio-nrs.h      |  97 --
 arch/arm/mach-s3c24xx/include/mach/gpio-track.h    |  33 -
 arch/arm/mach-s3c24xx/include/mach/gpio.h          |  87 +-
 arch/arm/mach-s3c24xx/include/mach/h1940.h         |  24 -
 arch/arm/mach-s3c24xx/include/mach/hardware.h      |   6 -
 arch/arm/mach-s3c24xx/include/mach/idle.h          |  24 -
 arch/arm/mach-s3c24xx/include/mach/osiris-cpld.h   |  30 -
 arch/arm/mach-s3c24xx/include/mach/regs-gpio.h     |   2 -
 arch/arm/mach-s3c24xx/include/mach/regs-mem.h      | 202 -----
 arch/arm/mach-s3c24xx/include/mach/regs-power.h    |  40 -
 .../mach-s3c24xx/include/mach/regs-s3c2412-mem.h   |  48 -
 arch/arm/mach-s3c24xx/include/mach/regs-s3c2412.h  |  23 -
 .../mach-s3c24xx/include/mach/regs-s3c2416-mem.h   |  30 -
 arch/arm/mach-s3c24xx/include/mach/regs-s3c2416.h  |  24 -
 arch/arm/mach-s3c24xx/include/mach/vr1000-cpld.h   |  18 -
 arch/arm/mach-s3c24xx/include/mach/vr1000-irq.h    |  26 -
 arch/arm/mach-s3c24xx/include/mach/vr1000-map.h    | 110 ---
 .../iotiming-s3c2410.c}                            |   6 +-
 .../iotiming-s3c2412.c}                            |   7 +-
 arch/arm/mach-s3c24xx/irq-pm.c                     |  41 +-
 arch/arm/mach-s3c24xx/irq-s3c2412.c                |   3 +-
 arch/arm/mach-s3c24xx/irq-s3c2416.c                | 348 --------
 arch/arm/mach-s3c24xx/irq-s3c2443.c                | 281 ------
 arch/arm/mach-s3c24xx/irq.c                        | 822 +++++++++++++++++
 arch/arm/mach-s3c24xx/mach-amlm5900.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-anubis.c                |  16 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |   4 +-
 arch/arm/mach-s3c24xx/mach-bast.c                  |  53 +-
 arch/arm/mach-s3c24xx/mach-gta02.c                 |  60 +-
 arch/arm/mach-s3c24xx/mach-h1940.c                 |  39 +-
 arch/arm/mach-s3c24xx/mach-jive.c                  |   6 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   3 +-
 arch/arm/mach-s3c24xx/mach-n30.c                   |   4 +-
 arch/arm/mach-s3c24xx/mach-nexcoder.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-osiris.c                |  29 +-
 arch/arm/mach-s3c24xx/mach-otom.c                  |  22 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c                |   2 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c                |  33 +-
 arch/arm/mach-s3c24xx/mach-rx3715.c                |  18 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c              |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |   7 +-
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |   5 +-
 arch/arm/mach-s3c24xx/mach-smdk2440.c              |   3 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |   5 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c            |   2 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c                |  39 +-
 arch/arm/mach-s3c24xx/mach-vstms.c                 |   3 +-
 .../{include/mach/osiris-map.h => osiris.h}        |  23 +-
 .../{include/mach/otom-map.h => otom.h}            |  20 +-
 .../pll.c => mach-s3c24xx/pll-s3c2410.c}           |   5 +-
 .../pll-s3c2440-12000000.c}                        |   5 +-
 .../pll-s3c2440-16934400.c}                        |   5 +-
 arch/arm/mach-s3c24xx/pm-s3c2410.c                 |   6 +-
 arch/arm/mach-s3c24xx/pm-s3c2412.c                 |   8 +-
 arch/arm/mach-s3c24xx/pm-s3c2416.c                 |   3 +-
 arch/arm/mach-s3c24xx/pm.c                         |   3 +-
 .../arm/mach-s3c24xx/{include/mach => }/regs-dsc.h |   0
 arch/arm/mach-s3c24xx/regs-mem.h                   |  54 ++
 arch/arm/mach-s3c24xx/s3c2410.c                    |   4 +-
 arch/arm/mach-s3c24xx/s3c2412-power.h              |  37 +
 arch/arm/mach-s3c24xx/s3c2412.c                    |  32 +-
 arch/arm/mach-s3c24xx/s3c2412.h                    |  26 +
 arch/arm/mach-s3c24xx/s3c2416.c                    |   4 +-
 arch/arm/mach-s3c24xx/s3c2440.c                    |   4 +-
 arch/arm/mach-s3c24xx/s3c2442.c                    |   4 +-
 arch/arm/mach-s3c24xx/s3c244x.c                    |   3 +-
 arch/arm/mach-s3c24xx/simtec-audio.c               |   5 +-
 arch/arm/mach-s3c24xx/simtec-nor.c                 |   3 +-
 arch/arm/mach-s3c24xx/simtec-pm.c                  |   3 +-
 arch/arm/mach-s3c24xx/simtec-usb.c                 |   8 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S              |   3 +-
 arch/arm/mach-s3c24xx/sleep.S                      |   1 -
 arch/arm/mach-s3c24xx/vr1000.h                     | 118 +++
 arch/arm/mach-s3c64xx/clock.c                      |   3 +-
 arch/arm/mach-s3c64xx/common.c                     |   2 +-
 arch/arm/mach-s3c64xx/cpuidle.c                    |   4 +-
 .../arm/mach-s3c64xx/{include/mach => }/crag6410.h |   0
 arch/arm/mach-s3c64xx/dma.c                        |   4 +-
 arch/arm/mach-s3c64xx/include/mach/regs-irq.h      |   1 -
 arch/arm/mach-s3c64xx/include/mach/regs-sys.h      |  31 -
 arch/arm/mach-s3c64xx/include/mach/tick.h          |   2 +
 arch/arm/mach-s3c64xx/mach-anw6410.c               |   6 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |   2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |  13 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |   4 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c              |   8 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                   |   4 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |   8 +-
 arch/arm/mach-s3c64xx/mach-smartq.c                |   2 +-
 arch/arm/mach-s3c64xx/mach-smartq5.c               |   4 +-
 arch/arm/mach-s3c64xx/mach-smartq7.c               |   4 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |   4 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |  10 +-
 arch/arm/mach-s3c64xx/pm.c                         |   9 +-
 .../{include/mach => }/regs-gpio-memport.h         |   9 +-
 .../mach-s3c64xx/{include/mach => }/regs-modem.h   |  11 +-
 .../mach-s3c64xx/{include/mach => }/regs-srom.h    |  11 +-
 arch/arm/mach-s3c64xx/regs-sys.h                   |  30 +
 .../{include/mach => }/regs-syscon-power.h         |   9 +-
 arch/arm/mach-s3c64xx/setup-usb-phy.c              |   3 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |   2 +-
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |   2 +-
 .../{include/mach/s5p64x0-clock.h => clock.h}      |   9 +-
 arch/arm/mach-s5p64x0/gpiolib.c                    | 508 -----------
 arch/arm/mach-s5p64x0/{include/mach => }/i2c.h     |   3 +-
 arch/arm/mach-s5p64x0/include/mach/regs-irq.h      |   1 -
 arch/arm/mach-s5p64x0/include/mach/tick.h          |  29 -
 arch/arm/mach-s5p64x0/include/mach/uncompress.h    |  28 -
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |   6 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |   6 +-
 arch/arm/mach-s5p64x0/setup-i2c0.c                 |   2 +-
 arch/arm/mach-s5p64x0/setup-i2c1.c                 |   2 +-
 arch/arm/mach-s5pc100/include/mach/regs-irq.h      |   1 -
 arch/arm/mach-s5pc100/include/mach/tick.h          |   2 +
 arch/arm/mach-s5pc100/mach-smdkc100.c              |   4 +-
 arch/arm/mach-s5pv210/dev-audio.c                  |   3 +-
 arch/arm/mach-s5pv210/include/mach/regs-audss.h    |  18 -
 arch/arm/mach-s5pv210/include/mach/regs-irq.h      |   1 -
 arch/arm/mach-s5pv210/include/mach/regs-sys.h      |  15 -
 arch/arm/mach-s5pv210/include/mach/tick.h          |  26 -
 arch/arm/mach-s5pv210/mach-aquila.c                |   4 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |   4 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c              |   4 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   4 +-
 arch/arm/mach-s5pv210/mach-torbreck.c              |   4 +-
 arch/arm/mach-s5pv210/setup-usb-phy.c              |   7 +-
 arch/arm/mach-sa1100/assabet.c                     |   2 +-
 arch/arm/mach-sa1100/badge4.c                      |   2 +-
 arch/arm/mach-sa1100/cerf.c                        |   2 +-
 arch/arm/mach-sa1100/collie.c                      |   2 +-
 arch/arm/mach-sa1100/generic.h                     |   4 +-
 arch/arm/mach-sa1100/h3100.c                       |   2 +-
 arch/arm/mach-sa1100/h3600.c                       |   2 +-
 arch/arm/mach-sa1100/hackkit.c                     |   2 +-
 arch/arm/mach-sa1100/include/mach/uncompress.h     |   1 -
 arch/arm/mach-sa1100/jornada720.c                  |   2 +-
 arch/arm/mach-sa1100/lart.c                        |   2 +-
 arch/arm/mach-sa1100/nanoengine.c                  |   2 +-
 arch/arm/mach-sa1100/pleb.c                        |   2 +-
 arch/arm/mach-sa1100/shannon.c                     |   2 +-
 arch/arm/mach-sa1100/simpad.c                      |   2 +-
 arch/arm/mach-sa1100/time.c                        |  72 +-
 arch/arm/mach-shark/core.c                         |   6 +-
 arch/arm/mach-shark/include/mach/uncompress.h      |   1 -
 arch/arm/mach-shmobile/board-ag5evm.c              |   5 +-
 arch/arm/mach-shmobile/board-ap4evb.c              |   2 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |   5 +-
 arch/arm/mach-shmobile/board-bonito.c              |   5 +-
 arch/arm/mach-shmobile/board-kota2.c               |   5 +-
 arch/arm/mach-shmobile/board-kzm9d.c               |   4 +-
 arch/arm/mach-shmobile/board-kzm9g.c               |   5 +-
 arch/arm/mach-shmobile/board-mackerel.c            |   2 +-
 arch/arm/mach-shmobile/board-marzen.c              |   4 +-
 arch/arm/mach-shmobile/include/mach/common.h       |   5 +-
 arch/arm/mach-shmobile/include/mach/uncompress.h   |   2 -
 arch/arm/mach-shmobile/intc-r8a7779.c              |   2 +-
 arch/arm/mach-shmobile/intc-sh73a0.c               |   2 +-
 arch/arm/mach-shmobile/platsmp.c                   |   3 -
 arch/arm/mach-shmobile/setup-emev2.c               |  19 +-
 arch/arm/mach-shmobile/setup-r8a7740.c             |  11 +-
 arch/arm/mach-shmobile/setup-r8a7779.c             |   5 +-
 arch/arm/mach-shmobile/setup-sh7372.c              |   7 +-
 arch/arm/mach-shmobile/setup-sh73a0.c              |   5 +-
 arch/arm/mach-shmobile/smp-emev2.c                 |   4 +-
 arch/arm/mach-shmobile/smp-r8a7779.c               |   2 +-
 arch/arm/mach-shmobile/smp-sh73a0.c                |   2 +-
 arch/arm/mach-shmobile/timer.c                     |   6 +-
 arch/arm/mach-socfpga/platsmp.c                    |   4 +-
 arch/arm/mach-socfpga/socfpga.c                    |  16 +-
 arch/arm/mach-spear13xx/include/mach/generic.h     |   3 +-
 arch/arm/mach-spear13xx/platsmp.c                  |   4 +-
 arch/arm/mach-spear13xx/spear1310.c                |   7 +-
 arch/arm/mach-spear13xx/spear1340.c                |   7 +-
 arch/arm/mach-spear13xx/spear13xx.c                |  19 +-
 arch/arm/mach-spear3xx/include/mach/generic.h      |   3 +-
 arch/arm/mach-spear3xx/spear300.c                  |   7 +-
 arch/arm/mach-spear3xx/spear310.c                  |   7 +-
 arch/arm/mach-spear3xx/spear320.c                  |   7 +-
 arch/arm/mach-spear3xx/spear3xx.c                  |  22 +-
 arch/arm/mach-spear6xx/spear6xx.c                  |  24 +-
 arch/arm/mach-sunxi/sunxi.c                        |  23 +-
 arch/arm/mach-tegra/Kconfig                        |   4 +-
 arch/arm/mach-tegra/Makefile                       |   6 +-
 arch/arm/mach-tegra/apbio.c                        |   2 +-
 arch/arm/mach-tegra/board-dt-tegra20.c             |  16 +-
 arch/arm/mach-tegra/board-dt-tegra30.c             |   7 +-
 arch/arm/mach-tegra/board.h                        |   1 -
 arch/arm/mach-tegra/common.c                       |  13 +-
 arch/arm/mach-tegra/common.h                       |   1 +
 arch/arm/mach-tegra/cpu-tegra.c                    |  40 +-
 arch/arm/mach-tegra/cpuidle-tegra30.c              |   6 +-
 arch/arm/mach-tegra/flowctrl.c                     |   4 +-
 arch/arm/mach-tegra/headsmp.S                      | 221 -----
 arch/arm/mach-tegra/hotplug.c                      |  21 +-
 arch/arm/mach-tegra/include/mach/uncompress.h      |   4 -
 arch/arm/mach-tegra/irq.c                          |   3 +-
 arch/arm/mach-tegra/platsmp.c                      |  47 +-
 arch/arm/mach-tegra/pm.c                           |   4 +-
 arch/arm/mach-tegra/reset-handler.S                | 239 +++++
 arch/arm/mach-tegra/reset.c                        |   2 +-
 arch/arm/mach-tegra/sleep-tegra20.S                |   3 -
 arch/arm/mach-tegra/sleep-tegra30.S                |   3 -
 arch/arm/mach-tegra/sleep.S                        |   4 +-
 arch/arm/mach-tegra/sleep.h                        |   1 +
 arch/arm/mach-tegra/tegra30_clocks_data.c          |   6 +-
 arch/arm/mach-u300/core.c                          |   5 +-
 arch/arm/mach-u300/include/mach/uncompress.h       |   1 -
 arch/arm/mach-u300/timer.c                         |  10 +-
 arch/arm/mach-u300/timer.h                         |   2 +-
 arch/arm/mach-ux500/board-mop500-uib.c             |   1 +
 arch/arm/mach-ux500/board-mop500.c                 |  18 +-
 arch/arm/mach-ux500/cache-l2x0.c                   |   3 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |  13 +-
 arch/arm/mach-ux500/cpu.c                          |  11 +-
 arch/arm/mach-ux500/devices-db8500.c               |  44 +
 arch/arm/mach-ux500/devices-db8500.h               |   5 +
 arch/arm/mach-ux500/id.c                           |   2 +
 arch/arm/mach-ux500/{include/mach => }/id.h        |  21 +-
 arch/arm/mach-ux500/include/mach/hardware.h        |   1 -
 arch/arm/mach-ux500/include/mach/setup.h           |   3 +-
 arch/arm/mach-ux500/include/mach/uncompress.h      |   2 -
 arch/arm/mach-ux500/platsmp.c                      |   9 +-
 arch/arm/mach-ux500/timer.c                        |  15 +-
 arch/arm/mach-versatile/core.c                     |   9 +-
 arch/arm/mach-versatile/core.h                     |   2 +-
 arch/arm/mach-versatile/include/mach/uncompress.h  |   1 -
 arch/arm/mach-versatile/versatile_ab.c             |   4 +-
 arch/arm/mach-versatile/versatile_dt.c             |   4 +-
 arch/arm/mach-versatile/versatile_pb.c             |   4 +-
 arch/arm/mach-vexpress/ct-ca9x4.c                  |   4 +-
 arch/arm/mach-vexpress/platsmp.c                   |   3 -
 arch/arm/mach-vexpress/v2m.c                       |  28 +-
 arch/arm/mach-vt8500/Kconfig                       |   3 +-
 arch/arm/mach-vt8500/Makefile                      |   2 +-
 arch/arm/mach-vt8500/common.h                      |   1 -
 arch/arm/mach-vt8500/include/mach/uncompress.h     |   1 -
 arch/arm/mach-vt8500/vt8500.c                      |   7 +-
 arch/arm/mach-w90x900/include/mach/uncompress.h    |   2 -
 arch/arm/mach-w90x900/mach-nuc910evb.c             |   2 +-
 arch/arm/mach-w90x900/mach-nuc950evb.c             |   2 +-
 arch/arm/mach-w90x900/mach-nuc960evb.c             |   2 +-
 arch/arm/mach-w90x900/nuc9xx.h                     |   3 +-
 arch/arm/mach-w90x900/time.c                       |  16 +-
 arch/arm/mach-zynq/common.c                        |  29 +-
 arch/arm/mach-zynq/common.h                        |   2 +-
 arch/arm/mach-zynq/timer.c                         | 150 ++--
 arch/arm/plat-iop/time.c                           |   9 +-
 arch/arm/plat-orion/time.c                         |   6 +-
 arch/arm/plat-s3c24xx/Kconfig                      | 116 ---
 arch/arm/plat-s3c24xx/Makefile                     |  27 -
 arch/arm/plat-s3c24xx/irq.c                        | 676 --------------
 arch/arm/plat-samsung/include/plat/cpu.h           |   3 +-
 arch/arm/plat-samsung/include/plat/gpio-core.h     |  13 +-
 arch/arm/plat-samsung/include/plat/gpio-fns.h      |   1 -
 arch/arm/plat-samsung/include/plat/pm.h            |   6 -
 arch/arm/plat-samsung/include/plat/s3c2416.h       |   1 +
 arch/arm/plat-samsung/include/plat/s3c2443.h       |   2 +
 arch/arm/plat-samsung/include/plat/s5p-time.h      |   2 +-
 arch/arm/plat-samsung/include/plat/uncompress.h    |  28 -
 arch/arm/plat-samsung/s5p-irq-eint.c               |   3 +-
 arch/arm/plat-samsung/s5p-irq.c                    |   3 +-
 arch/arm/plat-samsung/s5p-time.c                   |  15 +-
 arch/arm/plat-samsung/time.c                       |  20 +-
 arch/arm/plat-spear/include/plat/uncompress.h      |   1 -
 arch/arm/plat-spear/time.c                         |   8 +-
 arch/arm/plat-versatile/platsmp.c                  |   4 +-
 arch/blackfin/kernel/time.c                        |   6 +-
 arch/cris/arch-v10/kernel/time.c                   |  10 +-
 arch/cris/kernel/time.c                            |  11 -
 arch/m32r/kernel/time.c                            |   4 +-
 arch/m68k/amiga/config.c                           |  10 +-
 arch/m68k/apollo/config.c                          |   9 +-
 arch/m68k/atari/config.c                           |   4 +-
 arch/m68k/atari/time.c                             |   6 +-
 arch/m68k/bvme6000/config.c                        |  10 +-
 arch/m68k/hp300/config.c                           |   2 +-
 arch/m68k/hp300/time.c                             |   4 +-
 arch/m68k/hp300/time.h                             |   2 +-
 arch/m68k/include/asm/machdep.h                    |   2 +-
 arch/m68k/kernel/setup_mm.c                        |   1 -
 arch/m68k/kernel/time.c                            |  15 +-
 arch/m68k/mac/config.c                             |   4 +-
 arch/m68k/mac/via.c                                |   4 +-
 arch/m68k/mvme147/config.c                         |   8 +-
 arch/m68k/mvme16x/config.c                         |   8 +-
 arch/m68k/q40/config.c                             |   8 +-
 arch/m68k/sun3/config.c                            |   4 +-
 arch/m68k/sun3/intersil.c                          |   4 +-
 arch/m68k/sun3x/config.c                           |   2 +-
 arch/m68k/sun3x/time.c                             |   2 +-
 arch/m68k/sun3x/time.h                             |   2 +-
 drivers/clocksource/Kconfig                        |   6 +
 drivers/clocksource/Makefile                       |   3 +
 drivers/clocksource/bcm2835_timer.c                |   9 +-
 drivers/clocksource/clksrc-of.c                    |  35 +
 drivers/clocksource/cs5535-clockevt.c              |  11 +-
 drivers/clocksource/dw_apb_timer_of.c              |   6 +-
 drivers/clocksource/nomadik-mtu.c                  |  33 +-
 drivers/clocksource/sunxi_timer.c                  |  17 +-
 drivers/clocksource/tcb_clksrc.c                   |   7 +-
 .../timer.c => drivers/clocksource/tegra20_timer.c |  21 +-
 .../timer.c => drivers/clocksource/vt8500_timer.c  |  12 +-
 drivers/cpufreq/db8500-cpufreq.c                   |   4 -
 drivers/cpufreq/exynos-cpufreq.c                   |   4 +-
 .../cpufreq.h => drivers/cpufreq/exynos-cpufreq.h  |   3 +-
 drivers/cpufreq/exynos4210-cpufreq.c               |   3 +-
 drivers/cpufreq/exynos4x12-cpufreq.c               |   3 +-
 drivers/cpufreq/exynos5250-cpufreq.c               |   3 +-
 drivers/gpio/gpio-samsung.c                        |   1 -
 drivers/irqchip/Kconfig                            |  27 +
 drivers/irqchip/Makefile                           |   7 +-
 drivers/irqchip/exynos-combiner.c                  | 230 +++++
 arch/arm/common/gic.c => drivers/irqchip/irq-gic.c |  59 +-
 arch/arm/common/vic.c => drivers/irqchip/irq-vic.c |  95 +-
 drivers/irqchip/irqchip.c                          |  30 +
 drivers/irqchip/irqchip.h                          |  29 +
 drivers/irqchip/spear-shirq.c                      |   5 +
 drivers/mfd/db8500-prcmu.c                         | 139 +--
 include/asm-generic/vmlinux.lds.h                  |  22 +-
 include/linux/bcm2835_timer.h                      |  22 -
 include/linux/clocksource.h                        |  11 +
 include/linux/dw_apb_timer.h                       |   2 +-
 include/linux/irqchip.h                            |  16 +
 .../gic.h => include/linux/irqchip/arm-gic.h       |  15 +-
 .../vic.h => include/linux/irqchip/arm-vic.h       |  25 +-
 include/linux/mfd/db8500-prcmu.h                   |  20 -
 include/linux/mfd/dbx500-prcmu.h                   | 127 +--
 include/linux/sunxi_timer.h                        |   2 +-
 include/linux/time.h                               |   4 +-
 kernel/time/clockevents.c                          |   1 +
 kernel/time/timekeeping.c                          |  26 +-
 sound/soc/samsung/h1940_uda1380.c                  |  13 +-
 sound/soc/samsung/neo1973_wm8753.c                 |   8 +-
 848 files changed, 4322 insertions(+), 9420 deletions(-)
