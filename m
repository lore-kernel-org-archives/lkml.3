Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbaHHQru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:47:50 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56953 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbaHHQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:47:44 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/7] ARM: SoC cleanups for 3.17
Date: Fri,  8 Aug 2014 09:47:53 -0700
Message-Id: <1407516479-1251-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 2.0.1.473.gc4d58ca
In-Reply-To: <1407516479-1251-1-git-send-email-olof@lixom.net>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This merge window brings a good size of cleanups on various
platforms. Among the bigger ones:

* Removal of Samsung s5pc100 and s5p64xx platforms. Both of these have
  lacked active support for quite a while, and after asking around nobody
  showed interest in keeping them around. If needed, they could be
  resurrected in the future but it's more likely that we would prefer
  reintroduction of them as DT and multiplatform-enabled platforms
  instead.
* OMAP4 controller code register define diet. They defined a lot of registers
  that were never actually used, etc.
* Move of some of the Tegra platform code (PMC, APBIO, fuse, powergate)
  to drivers/soc so it can be shared with 64-bit code. This also converts them
  over to traditional driver models where possible.
* Removal of legacy gpio-samsung driver, since the last users have been
  removed (moved to pinctrl)

Plus a bunch of smaller changes for various platforms that sort of
dissapear in the diffstat for the above. clps711x cleanups, shmobile
header file refactoring/moves for multiplatform friendliness, some misc
cleanups, etc.



Conflicts:

arch/arm/mach-s5pv210/include/mach/memory.h:
        Change/remove: Just git rm the file.

----------------------------------------------------------------

The following changes since commit 66bb0aa077978dbb76e6283531eb3cc7a878de38:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-3.17

for you to fetch changes up to c4846a7823bfd34ecb2dc56b025e19285432d08d:

  Merge branch 'next/fixes-non-critical' into next/cleanup

----------------------------------------------------------------

Alexander Shiyan (5):
      ARM: clps711x: Remove IO_ADDRESS() macro
      ARM: clps711x: Move debug include into arch/arm/include/debug/
      ARM: clps711x: Switch CLPS711X subarch to use cpuidle driver
      ARM: clps711x: clep7312: Add common devices initialization
      ARM: clps711x: edb7211: Remove excess layer to calling clps711x_devices_init()

Andrew Lunn (1):
      MAINTAINERS: Remove Kirkwood

Andrew Ruder (2):
      ARM: pxa: correct errata number for PXA270
      ARM: pxa: call debug_ll_io_init for earlyprintk

Andrii.Tseglytskyi (1):
      ARM: dts: OMAP5: Add device nodes for ABB

Arnd Bergmann (2):
      video: fix up versatile CLCD helper move
      Merge tag 'omap-for-v3.17/fixes-not-urgent-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical

Dan Carpenter (1):
      ARM: mmp: remove duplicate SM_SCLK_SM_SCLK define

Ezequiel Garcia (1):
      ARM: pxa: Move iotable mapping inside vmalloc region

Geert Uytterhoeven (7):
      ARM: shmobile: Move r7s72100.h
      ARM: shmobile: Move r8a73a4.h
      ARM: shmobile: Move r8a7740.h
      ARM: shmobile: Move r8a7778.h
      ARM: shmobile: Move r8a7790.h
      ARM: shmobile: Move sh73a0.h
      ARM: shmobile: Move sh7372.h

Himangi Saraogi (1):
      drivers: CCI: Correct use of ! and &

Joachim Eastwood (1):
      ARM: OMAP4: Ctrl module register define diet

Krzysztof Kozlowski (1):
      ARM: EXYNOS: Fix build breakge with PM_SLEEP=n

Kukjin Kim (9):
      ARM: S5P64X0: no more support S5P6440 and S5P6450 SoCs
      gpio: samsung: remove s5p64x0 related gpio codes
      spi: s3c64xx: remove s5p64x0 related spi codes
      video: fbdev: s3c-fb: remove s5p64x0 related fimd codes
      ARM: S5PC100: no more support S5PC100 SoC
      gpio: samsung: remov s5pc100 related gpio codes
      spi: s3c64xx: remove s5pc100 related spi codes
      mtd: onenand: remove s5pc100 related onenand codes
      video: fbdev: s3c-fb: remove s5pc100 related fimd and fb codes

Laurent Pinchart (3):
      ARM: pxa: Don't hardcode addresses and size in map_desc tables
      ARM: pxa: Move UNCACHED_PHYS_0 mapping from generic.c to pxa2[57]x.c
      ARM: pxa: pxa27x: Don't map IMEMC region statically

Linus Walleij (7):
      ARM: integrator: get rid of <mach/memory.h>
      video: move Versatile CLCD helpers
      ARM: s5p: cut the custom ARCH_NR_GPIOS definition
      ARM: mach-s5p: get rid of all <mach/gpio.h> headers
      ARM: kill CONFIG_NEED_MACH_GPIO_H
      ARM: delete old reference to ARM_GPIOLIB_COMPLEX
      ARM: ux500: remove pointless cache setup complexity

Magnus Damm (17):
      ARM: shmobile: Move intc.h, cleanup sh_intc.h usage
      ARM: shmobile: Move dma-register.h
      ARM: shmobile: Move clock.h
      ARM: shmobile: Move most of irqs.h, keep some for pinctl
      ARM: shmobile: Move common.h
      ARM: shmobile: Move pm-rmobile.h, cleanup sh73xx.h
      ARM: shmobile: Move pm-rcar.h, cleanup r8a7779 case
      ARM: shmobile: Move rcar-gen2.h, cleanup r8a7790 case
      ARM: shmobile: Update EMEV2 DTS to include CPU frequency
      ARM: shmobile: Use shmobile_init_delay() on EMEV2
      ARM: shmobile: Get rid of redundant EMEV2 mach callbacks
      ARM: shmobile: Update r7s72100 DTS to include CPU frequency
      ARM: shmobile: Use shmobile_init_delay() on Genmai boards
      ARM: shmobile: Use shmobile_init_delay() on r7s72100
      ARM: shmobile: Use r8a7790 DT CPU Frequency in common case
      ARM: shmobile: Use r8a7790 DT CPU Frequency for Lager
      ARM: shmobile: Remove unused r8a7790_init_early()

Mark Brown (1):
      video: clcd-versatile: Depend on ARM

Nicholas Krause (1):
      omap16xx: Removes fixme no longer needed in ocpi_enable()

Olof Johansson (15):
      Merge tag 'renesas-header-cleanup-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-soc-cleanup-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'versatile-1' of git://git.kernel.org/.../linusw/linux-integrator into next/cleanup
      Merge tag 'renesas-soc-cleanup2-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'mmp-for-v3.17' of https://git.kernel.org/.../hzhuang1/linux into next/cleanup
      Merge tag 'pxa-for-v3.17-2' of https://git.kernel.org/.../hzhuang1/linux into next/cleanup
      Merge tag 's5p-cleanup-v2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'ux500-core-for-v3.17-1' of git://git.kernel.org/.../linusw/linux-stericsson into next/cleanup
      Merge tag 'gpio-h-purge' of git://git.kernel.org/.../linusw/linux-gpio into next/cleanup
      Merge tag 'tegra-for-3.17-fuse-move' of git://git.kernel.org/.../tegra/linux into next/cleanup
      Merge tag 'tegra-for-3.17-soc' of git://git.kernel.org/.../tegra/linux into next/cleanup
      Merge tag 'v3.16-rc5' into next/fixes-non-critical
      Merge tag 'samsung-cleanup' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'omap-for-v3.17/soc-cleanup' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'next/fixes-non-critical' into next/cleanup

Pankaj Dubey (6):
      ARM: EXYNOS: Make exynos machine_ops as static
      ARM: EXYNOS: Move SYSREG definition into sys-reg specific file
      ARM: EXYNOS: Remove file path from comment section
      ARM: EXYNOS: Remove regs-pmu.h header dependency from pm_domain
      ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
      ARM: EXYNOS: Add support for mapping PMU base address via DT

Paul Bolle (1):
      ARM: pxa: fix typo 'CONFIG_SPI_PXA2XX_MASTER'

Peter De Schrijver (5):
      ARM: tegra: export apb dma readl/writel
      ARM: tegra: move fuse exports to soc/tegra/fuse.h
      soc/tegra: Add efuse driver for Tegra
      soc/tegra: Add efuse and apbmisc bindings
      soc/tegra: fuse: move APB DMA into Tegra20 fuse driver

Peter Griffin (1):
      MAINTAINERS: Add sdhci-st file to ARCH/STI architecture

Rickard Strandqvist (1):
      ARM: omap2+: usb-tusb6010.c: Cleaning up variable is set more than once

Rostislav Lisovy (1):
      ARM: omap2+: gpmc-nand: Use dynamic platform_device_alloc()

Sachin Kamat (9):
      ARM: sti: Staticize local variables
      ARM: vt8500: Staticize local symbols
      ARM: spear: Staticize spear13xx_io_desc
      ARM: spear: Staticize spear1310_io_desc in spear1310.c
      ARM: spear: Staticize local symbols in spear1340.c
      ARM: ux500: Staticize local symbols in cpu-db8500.c
      ARM: ux500: Staticize ab8505_regulators
      ARM: debug: Update Samsung UART config options
      ARM: EXYNOS: Remove unused code in common.h

Stephen Warren (1):
      soc/tegra: fuse: fix dummy functions

Tero Kristo (22):
      ARM: OMAP3: PRM: move prcm wakeup helper to prm driver
      ARM: OMAP3: PRM: move iva reset to PRM driver
      ARM: OMAP3: PRM: move modem reset to PRM driver
      ARM: OMAP3: PRM: add API for checking and clearing cold reset status
      ARM: OMAP3: PRM: add API for saving PRM scratchpad contents
      ARM: OMAP24xx: PRM: add API for clearing wakeup status bits
      ARM: OMAP3: PRM: move PRM init code from PM core to the driver
      ARM: OMAP3: control: add API for setting up the modem pads
      ARM: OMAP3: PRM: move modem reset and iva2 idle to PRM driver
      ARM: OMAP3: control: isolate control module init to its own function
      ARM: OMAP4+: clock: remove DEFINE_CLK_OMAP_HSDIVIDER macro
      ARM: OMAP4+: dpll: remove cpu_is_omap44xx checks
      ARM: OMAP4+: dpll44xx: remove cm-regbits-44xx.h and clock44xx.h includes
      ARM: OMAP2+: clock: introduce ti_clk_features flags
      ARM: OMAP2+: clock: add fint values to the ti_clk_features struct
      ARM: OMAP2+: clock/dpll: add private API for checking if DPLL is in bypass
      ARM: OMAP2+: clock/dpll: convert bypass check to use clk_features
      ARM: OMAP2+: clock/dpll: add jitter correction behind clk_features
      ARM: OMAP2+: clock/interface: add a clk_features definition for idlest value
      ARM: OMAP2+: clock/dpll: remove unused header includes from clkt_dpll.c
      ARM: OMAP2+: clock/dpll: remove unused header includes from dpll3xxx.c
      ARM: OMAP2+: clock/interface: remove some headers from clkt_iclk.c file

Thierry Reding (10):
      ARM: ux500: Staticise ux500_soc_attr
      ARM: tegra: Move includes to include/soc/tegra
      ARM: tegra: Sort includes alphabetically
      ARM: tegra: Use a function to get the chip ID
      Merge branch 'for-3.17/fuse-move' into for-3.17/soc
      soc/tegra: Implement runtime check for Tegra SoCs
      ARM: tegra: Setup CPU hotplug in a pure initcall
      ARM: tegra: Always lock the CPU reset vector
      soc/tegra: fuse: Set up in early initcall
      ARM: tegra: Convert PMC to a driver

Tobias Klauser (1):
      ARM: ux500: storage class should be before const qualifier

Tony Lindgren (3):
      Merge remote-tracking branch 'roger/for-v3.17/gpmc-omap' into omap-for-v3.17/fixes-not-urgent
      Merge branch 'for-v3.17/cm-prm-cleanup' of https://github.com/t-kristo/linux-pm into omap-for-v3.17/soc
      Merge tag 'for-v3.17/omap-clock-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.17/soc


 .../ABI/testing/sysfs-driver-tegra-fuse         |   11 +
 Documentation/arm/Samsung/Overview.txt          |   11 -
 .../arm/Samsung/clksrc-change-registers.awk     |    1 -
 .../bindings/fuse/nvidia,tegra20-fuse.txt       |   40 +
 .../bindings/misc/nvidia,tegra20-apbmisc.txt    |   13 +
 .../devicetree/bindings/spi/spi-samsung.txt     |    1 -
 .../devicetree/bindings/video/samsung-fimd.txt  |    2 -
 MAINTAINERS                                     |    4 +-
 arch/arm/Kconfig                                |   54 +-
 arch/arm/Kconfig.debug                          |   21 +-
 arch/arm/Makefile                               |    2 -
 arch/arm/boot/dts/emev2.dtsi                    |    2 +
 arch/arm/boot/dts/integratorap.dts              |    1 +
 arch/arm/boot/dts/omap5.dtsi                    |   60 +
 arch/arm/boot/dts/r7s72100.dtsi                 |    1 +
 arch/arm/boot/dts/tegra114.dtsi                 |   15 +
 arch/arm/boot/dts/tegra124.dtsi                 |   15 +
 arch/arm/boot/dts/tegra20.dtsi                  |   15 +
 arch/arm/boot/dts/tegra30.dtsi                  |   15 +
 arch/arm/configs/s5p64x0_defconfig              |   68 -
 arch/arm/configs/s5pc100_defconfig              |   49 -
 arch/arm/include/asm/gpio.h                     |    7 -
 arch/arm/include/debug/clps711x.S               |   38 +
 arch/arm/mach-clps711x/board-autcpu12.c         |    1 -
 arch/arm/mach-clps711x/board-cdb89712.c         |    1 -
 arch/arm/mach-clps711x/board-clep7312.c         |    3 +-
 arch/arm/mach-clps711x/board-edb7211.c          |    8 +-
 arch/arm/mach-clps711x/board-p720t.c            |    1 -
 arch/arm/mach-clps711x/common.c                 |   12 -
 arch/arm/mach-clps711x/common.h                 |    1 -
 arch/arm/mach-clps711x/devices.c                |   10 +
 .../mach-clps711x/include/mach/debug-macro.S    |   38 -
 arch/arm/mach-clps711x/include/mach/hardware.h  |    5 +-
 arch/arm/mach-exynos/common.h                   |   13 +-
 arch/arm/mach-exynos/exynos.c                   |   44 +-
 arch/arm/mach-exynos/headsmp.S                  |    1 -
 arch/arm/mach-exynos/hotplug.c                  |    3 +-
 arch/arm/mach-exynos/include/mach/map.h         |    3 +-
 arch/arm/mach-exynos/include/mach/memory.h      |    3 +-
 arch/arm/mach-exynos/platsmp.c                  |   69 +-
 arch/arm/mach-exynos/pm.c                       |   67 +-
 arch/arm/mach-exynos/pm_domains.c               |    9 +-
 arch/arm/mach-exynos/pmu.c                      |    1 -
 arch/arm/mach-exynos/regs-pmu.h                 |    4 -
 arch/arm/mach-exynos/regs-sys.h                 |   22 +
 arch/arm/mach-integrator/Kconfig                |    1 -
 arch/arm/mach-integrator/include/mach/memory.h  |   29 -
 arch/arm/mach-integrator/integrator_cp.c        |    3 +-
 arch/arm/mach-mmp/include/mach/mfp-pxa910.h     |    1 -
 arch/arm/mach-omap1/ocpi.c                      |    1 -
 arch/arm/mach-omap2/clkt_dpll.c                 |   98 +-
 arch/arm/mach-omap2/clkt_iclk.c                 |    8 +-
 arch/arm/mach-omap2/clock.c                     |   76 +-
 arch/arm/mach-omap2/clock.h                     |   44 +-
 arch/arm/mach-omap2/control.c                   |   60 +-
 arch/arm/mach-omap2/control.h                   |   40 +-
 arch/arm/mach-omap2/ctrl_module_core_44xx.h     |  392 -----
 arch/arm/mach-omap2/ctrl_module_pad_core_44xx.h | 1409 ------------------
 arch/arm/mach-omap2/ctrl_module_pad_wkup_44xx.h |  236 ---
 arch/arm/mach-omap2/dpll3xxx.c                  |    7 +-
 arch/arm/mach-omap2/dpll44xx.c                  |   19 +-
 arch/arm/mach-omap2/gpmc-nand.c                 |   79 +-
 arch/arm/mach-omap2/io.c                        |    2 +
 arch/arm/mach-omap2/pm24xx.c                    |   31 +-
 arch/arm/mach-omap2/pm34xx.c                    |  218 +--
 arch/arm/mach-omap2/prm2xxx.c                   |   18 +
 arch/arm/mach-omap2/prm2xxx.h                   |    1 +
 arch/arm/mach-omap2/prm3xxx.c                   |  233 +++
 arch/arm/mach-omap2/prm3xxx.h                   |    6 +
 arch/arm/mach-omap2/usb-tusb6010.c              |    1 -
 arch/arm/mach-pxa/corgi.c                       |    2 +-
 arch/arm/mach-pxa/generic.c                     |   12 +-
 arch/arm/mach-pxa/include/mach/hardware.h       |    4 +-
 arch/arm/mach-pxa/pxa25x.c                      |    7 +-
 arch/arm/mach-pxa/pxa27x.c                      |   10 +-
 arch/arm/mach-pxa/pxa3xx.c                      |    2 +-
 arch/arm/mach-pxa/sleep.S                       |    2 +-
 arch/arm/mach-realview/core.c                   |    2 +-
 arch/arm/mach-s5p64x0/Kconfig                   |  102 --
 arch/arm/mach-s5p64x0/Makefile                  |   36 -
 arch/arm/mach-s5p64x0/Makefile.boot             |    2 -
 arch/arm/mach-s5p64x0/clock-s5p6440.c           |  632 --------
 arch/arm/mach-s5p64x0/clock-s5p6450.c           |  701 ---------
 arch/arm/mach-s5p64x0/clock.c                   |  236 ---
 arch/arm/mach-s5p64x0/clock.h                   |   38 -
 arch/arm/mach-s5p64x0/common.c                  |  490 ------
 arch/arm/mach-s5p64x0/common.h                  |   56 -
 arch/arm/mach-s5p64x0/dev-audio.c               |  176 ---
 arch/arm/mach-s5p64x0/dma.c                     |  128 --
 arch/arm/mach-s5p64x0/i2c.h                     |   16 -
 .../arm/mach-s5p64x0/include/mach/debug-macro.S |   32 -
 arch/arm/mach-s5p64x0/include/mach/dma.h        |   26 -
 arch/arm/mach-s5p64x0/include/mach/gpio.h       |  132 --
 arch/arm/mach-s5p64x0/include/mach/hardware.h   |   18 -
 arch/arm/mach-s5p64x0/include/mach/irqs.h       |  148 --
 arch/arm/mach-s5p64x0/include/mach/map.h        |   96 --
 arch/arm/mach-s5p64x0/include/mach/pm-core.h    |  119 --
 arch/arm/mach-s5p64x0/include/mach/regs-clock.h |   98 --
 arch/arm/mach-s5p64x0/include/mach/regs-gpio.h  |   68 -
 arch/arm/mach-s5p64x0/include/mach/regs-irq.h   |   18 -
 arch/arm/mach-s5p64x0/irq-pm.c                  |   98 --
 arch/arm/mach-s5p64x0/mach-smdk6440.c           |  280 ----
 arch/arm/mach-s5p64x0/mach-smdk6450.c           |  299 ----
 arch/arm/mach-s5p64x0/pm.c                      |  202 ---
 arch/arm/mach-s5p64x0/setup-fb-24bpp.c          |   29 -
 arch/arm/mach-s5p64x0/setup-i2c0.c              |   38 -
 arch/arm/mach-s5p64x0/setup-i2c1.c              |   38 -
 arch/arm/mach-s5p64x0/setup-sdhci-gpio.c        |  104 --
 arch/arm/mach-s5p64x0/setup-spi.c               |   38 -
 arch/arm/mach-s5pc100/Kconfig                   |   81 -
 arch/arm/mach-s5pc100/Makefile                  |   32 -
 arch/arm/mach-s5pc100/Makefile.boot             |    2 -
 arch/arm/mach-s5pc100/clock.c                   | 1361 -----------------
 arch/arm/mach-s5pc100/common.c                  |  255 ----
 arch/arm/mach-s5pc100/common.h                  |   30 -
 arch/arm/mach-s5pc100/dev-audio.c               |  239 ---
 arch/arm/mach-s5pc100/dma.c                     |  130 --
 .../arm/mach-s5pc100/include/mach/debug-macro.S |   39 -
 arch/arm/mach-s5pc100/include/mach/dma.h        |   26 -
 .../arm/mach-s5pc100/include/mach/entry-macro.S |   19 -
 arch/arm/mach-s5pc100/include/mach/gpio.h       |  144 --
 arch/arm/mach-s5pc100/include/mach/hardware.h   |   14 -
 arch/arm/mach-s5pc100/include/mach/irqs.h       |  115 --
 arch/arm/mach-s5pc100/include/mach/map.h        |  137 --
 arch/arm/mach-s5pc100/include/mach/regs-clock.h |   80 -
 arch/arm/mach-s5pc100/include/mach/regs-gpio.h  |   38 -
 arch/arm/mach-s5pc100/include/mach/regs-irq.h   |   18 -
 arch/arm/mach-s5pc100/mach-smdkc100.c           |  264 ----
 arch/arm/mach-s5pc100/setup-fb-24bpp.c          |   35 -
 arch/arm/mach-s5pc100/setup-i2c0.c              |   28 -
 arch/arm/mach-s5pc100/setup-i2c1.c              |   28 -
 arch/arm/mach-s5pc100/setup-ide.c               |   57 -
 arch/arm/mach-s5pc100/setup-keypad.c            |   23 -
 arch/arm/mach-s5pc100/setup-sdhci-gpio.c        |   70 -
 arch/arm/mach-s5pc100/setup-spi.c               |   41 -
 arch/arm/mach-s5pv210/dev-audio.c               |    2 +-
 .../include/mach/{gpio.h => gpio-samsung.h}     |    7 +-
 arch/arm/mach-s5pv210/mach-aquila.c             |    1 +
 arch/arm/mach-s5pv210/mach-goni.c               |    1 +
 arch/arm/mach-s5pv210/mach-smdkv210.c           |    1 +
 arch/arm/mach-s5pv210/setup-fb-24bpp.c          |    2 +-
 arch/arm/mach-s5pv210/setup-fimc.c              |    3 +-
 arch/arm/mach-s5pv210/setup-i2c0.c              |    2 +-
 arch/arm/mach-s5pv210/setup-i2c1.c              |    2 +-
 arch/arm/mach-s5pv210/setup-i2c2.c              |    2 +-
 arch/arm/mach-s5pv210/setup-ide.c               |    2 +-
 arch/arm/mach-s5pv210/setup-keypad.c            |    2 +-
 arch/arm/mach-s5pv210/setup-sdhci-gpio.c        |    2 +-
 arch/arm/mach-s5pv210/setup-spi.c               |    2 +-
 .../arm/mach-shmobile/board-ape6evm-reference.c |    6 +-
 arch/arm/mach-shmobile/board-ape6evm.c          |    8 +-
 .../board-armadillo800eva-reference.c           |    6 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c  |    8 +-
 arch/arm/mach-shmobile/board-bockw-reference.c  |    6 +-
 arch/arm/mach-shmobile/board-bockw.c            |    8 +-
 arch/arm/mach-shmobile/board-genmai-reference.c |   10 +-
 arch/arm/mach-shmobile/board-genmai.c           |   10 +-
 .../arm/mach-shmobile/board-koelsch-reference.c |    8 +-
 arch/arm/mach-shmobile/board-koelsch.c          |    6 +-
 arch/arm/mach-shmobile/board-kzm9g-reference.c  |    6 +-
 arch/arm/mach-shmobile/board-kzm9g.c            |    8 +-
 arch/arm/mach-shmobile/board-lager-reference.c  |   14 +-
 arch/arm/mach-shmobile/board-lager.c            |   21 +-
 arch/arm/mach-shmobile/board-mackerel.c         |   12 +-
 arch/arm/mach-shmobile/board-marzen-reference.c |    4 +-
 arch/arm/mach-shmobile/board-marzen.c           |    4 +-
 arch/arm/mach-shmobile/clock-r7s72100.c         |    5 +-
 arch/arm/mach-shmobile/clock-r8a73a4.c          |    4 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |    7 +-
 arch/arm/mach-shmobile/clock-r8a7778.c          |    4 +-
 arch/arm/mach-shmobile/clock-r8a7779.c          |    4 +-
 arch/arm/mach-shmobile/clock-r8a7790.c          |    8 +-
 arch/arm/mach-shmobile/clock-r8a7791.c          |    6 +-
 arch/arm/mach-shmobile/clock-sh7372.c           |    4 +-
 arch/arm/mach-shmobile/clock-sh73a0.c           |    4 +-
 arch/arm/mach-shmobile/clock.c                  |    6 +-
 .../mach-shmobile/{include/mach => }/clock.h    |    0
 .../mach-shmobile/{include/mach => }/common.h   |    0
 arch/arm/mach-shmobile/console.c                |    2 +-
 .../{include/mach => }/dma-register.h           |    0
 arch/arm/mach-shmobile/include/mach/irqs.h      |   16 +-
 arch/arm/mach-shmobile/include/mach/r8a7779.h   |   12 -
 arch/arm/mach-shmobile/intc-sh7372.c            |    5 +-
 arch/arm/mach-shmobile/intc-sh73a0.c            |    9 +-
 .../arm/mach-shmobile/{include/mach => }/intc.h |    0
 arch/arm/mach-shmobile/irqs.h                   |   21 +
 arch/arm/mach-shmobile/platsmp-apmu.c           |    2 +-
 arch/arm/mach-shmobile/platsmp-scu.c            |    2 +-
 arch/arm/mach-shmobile/platsmp.c                |    2 +-
 arch/arm/mach-shmobile/pm-r8a7740.c             |    4 +-
 arch/arm/mach-shmobile/pm-r8a7779.c             |   15 +-
 arch/arm/mach-shmobile/pm-r8a7790.c             |    6 +-
 arch/arm/mach-shmobile/pm-rcar.c                |    2 +-
 .../mach-shmobile/{include/mach => }/pm-rcar.h  |    0
 arch/arm/mach-shmobile/pm-rmobile.c             |    2 +-
 .../{include/mach => }/pm-rmobile.h             |    0
 arch/arm/mach-shmobile/pm-sh7372.c              |    8 +-
 arch/arm/mach-shmobile/pm-sh73a0.c              |    2 +-
 .../mach-shmobile/{include/mach => }/r7s72100.h |    1 -
 .../mach-shmobile/{include/mach => }/r8a73a4.h  |    0
 .../mach-shmobile/{include/mach => }/r8a7740.h  |    2 -
 .../mach-shmobile/{include/mach => }/r8a7778.h  |    0
 .../mach-shmobile/{include/mach => }/r8a7790.h  |    3 -
 .../{include/mach => }/rcar-gen2.h              |    0
 arch/arm/mach-shmobile/setup-emev2.c            |   19 +-
 arch/arm/mach-shmobile/setup-r7s72100.c         |   15 +-
 arch/arm/mach-shmobile/setup-r8a73a4.c          |   10 +-
 arch/arm/mach-shmobile/setup-r8a7740.c          |   12 +-
 arch/arm/mach-shmobile/setup-r8a7778.c          |    8 +-
 arch/arm/mach-shmobile/setup-r8a7779.c          |    4 +-
 arch/arm/mach-shmobile/setup-r8a7790.c          |   20 +-
 arch/arm/mach-shmobile/setup-r8a7791.c          |    6 +-
 arch/arm/mach-shmobile/setup-rcar-gen2.c        |    4 +-
 arch/arm/mach-shmobile/setup-sh7372.c           |   12 +-
 arch/arm/mach-shmobile/setup-sh73a0.c           |   11 +-
 .../mach-shmobile/{include/mach => }/sh7372.h   |    4 -
 .../mach-shmobile/{include/mach => }/sh73a0.h   |    0
 arch/arm/mach-shmobile/smp-emev2.c              |    2 +-
 arch/arm/mach-shmobile/smp-r8a7779.c            |    4 +-
 arch/arm/mach-shmobile/smp-r8a7790.c            |    8 +-
 arch/arm/mach-shmobile/smp-r8a7791.c            |    4 +-
 arch/arm/mach-shmobile/smp-sh73a0.c             |    6 +-
 arch/arm/mach-spear/spear1310.c                 |    2 +-
 arch/arm/mach-spear/spear1340.c                 |    6 +-
 arch/arm/mach-spear/spear13xx.c                 |    2 +-
 arch/arm/mach-sti/platsmp.c                     |    6 +-
 arch/arm/mach-tegra/Makefile                    |    7 -
 arch/arm/mach-tegra/apbio.c                     |  206 ---
 arch/arm/mach-tegra/apbio.h                     |   22 -
 arch/arm/mach-tegra/board-paz00.c               |    3 +-
 arch/arm/mach-tegra/board.h                     |    7 -
 arch/arm/mach-tegra/cpuidle-tegra114.c          |   10 +-
 arch/arm/mach-tegra/cpuidle-tegra20.c           |   16 +-
 arch/arm/mach-tegra/cpuidle-tegra30.c           |   10 +-
 arch/arm/mach-tegra/cpuidle.c                   |    7 +-
 arch/arm/mach-tegra/flowctrl.c                  |   11 +-
 arch/arm/mach-tegra/fuse.c                      |  252 ----
 arch/arm/mach-tegra/fuse.h                      |   79 -
 arch/arm/mach-tegra/hotplug.c                   |   30 +-
 arch/arm/mach-tegra/io.c                        |    8 +-
 arch/arm/mach-tegra/irq.c                       |    8 +-
 arch/arm/mach-tegra/platsmp.c                   |   29 +-
 arch/arm/mach-tegra/pm-tegra20.c                |    1 +
 arch/arm/mach-tegra/pm-tegra30.c                |    1 +
 arch/arm/mach-tegra/pm.c                        |   63 +-
 arch/arm/mach-tegra/pm.h                        |   10 +-
 arch/arm/mach-tegra/pmc.c                       |  413 -----
 arch/arm/mach-tegra/pmc.h                       |   49 -
 arch/arm/mach-tegra/powergate.c                 |  515 -------
 arch/arm/mach-tegra/reset-handler.S             |    7 +-
 arch/arm/mach-tegra/reset.c                     |   19 +-
 arch/arm/mach-tegra/sleep-tegra30.S             |    7 +-
 arch/arm/mach-tegra/sleep.h                     |    3 -
 arch/arm/mach-tegra/tegra.c                     |   37 +-
 arch/arm/mach-ux500/board-mop500-regulators.c   |    2 +-
 arch/arm/mach-ux500/cache-l2x0.c                |   18 +-
 arch/arm/mach-ux500/cpu-db8500.c                |    8 +-
 arch/arm/mach-ux500/cpu.c                       |    2 +-
 arch/arm/mach-ux500/timer.c                     |    2 +-
 arch/arm/mach-versatile/core.c                  |    2 +-
 arch/arm/mach-vexpress/Kconfig                  |    1 -
 arch/arm/mach-vexpress/ct-ca9x4.c               |    3 +-
 arch/arm/mach-vt8500/vt8500.c                   |    6 +-
 arch/arm/plat-samsung/Kconfig                   |   30 +-
 arch/arm/plat-samsung/adc.c                     |    2 +-
 arch/arm/plat-samsung/include/plat/cpu.h        |   29 -
 arch/arm/plat-samsung/include/plat/devs.h       |   17 -
 arch/arm/plat-samsung/include/plat/fb.h         |   14 -
 arch/arm/plat-samsung/include/plat/gpio-core.h  |    3 +
 arch/arm/plat-samsung/include/plat/s5p-clock.h  |    2 +-
 arch/arm/plat-samsung/include/plat/sdhci.h      |   77 -
 arch/arm/plat-samsung/pm-gpio.c                 |    2 -
 arch/arm/plat-samsung/s5p-irq-eint.c            |    2 +-
 arch/arm/plat-versatile/Kconfig                 |    3 -
 arch/arm/plat-versatile/Makefile                |    1 -
 arch/arm/plat-versatile/include/plat/clcd.h     |    9 -
 drivers/amba/tegra-ahb.c                        |    3 +-
 drivers/bus/arm-cci.c                           |    3 +-
 drivers/clk/tegra/clk-periph-gate.c             |    3 +-
 drivers/clk/tegra/clk-tegra30.c                 |    5 +-
 drivers/clk/tegra/clk.c                         |    3 +-
 drivers/gpio/gpio-samsung.c                     |  725 ---------
 drivers/gpu/drm/tegra/gr3d.c                    |    3 +-
 drivers/gpu/drm/tegra/sor.c                     |    3 +-
 drivers/iommu/tegra-smmu.c                      |    3 +-
 drivers/irqchip/Kconfig                         |    1 -
 drivers/misc/fuse/Makefile                      |    1 +
 drivers/mtd/onenand/Kconfig                     |    4 +-
 drivers/mtd/onenand/samsung.c                   |   25 +-
 drivers/pci/host/pci-tegra.c                    |    5 +-
 drivers/soc/Makefile                            |    1 +
 drivers/soc/tegra/Makefile                      |    4 +
 drivers/soc/tegra/common.c                      |   30 +
 drivers/soc/tegra/fuse/Makefile                 |    8 +
 drivers/soc/tegra/fuse/fuse-tegra.c             |  163 ++
 drivers/soc/tegra/fuse/fuse-tegra20.c           |  215 +++
 drivers/soc/tegra/fuse/fuse-tegra30.c           |  224 +++
 drivers/soc/tegra/fuse/fuse.h                   |   71 +
 .../soc/tegra/fuse/speedo-tegra114.c            |   56 +-
 drivers/soc/tegra/fuse/speedo-tegra124.c        |  168 +++
 .../soc/tegra/fuse/speedo-tegra20.c             |   45 +-
 .../soc/tegra/fuse/speedo-tegra30.c             |  176 ++-
 drivers/soc/tegra/fuse/tegra-apbmisc.c          |  115 ++
 drivers/soc/tegra/pmc.c                         |  957 ++++++++++++
 drivers/spi/spi-s3c64xx.c                       |   22 -
 drivers/video/fbdev/Kconfig                     |   10 +-
 drivers/video/fbdev/Makefile                    |    1 +
 .../video/fbdev/amba-clcd-versatile.c           |    2 +-
 drivers/video/fbdev/s3c-fb.c                    |   65 -
 .../linux/platform_data/video-clcd-versatile.h  |   27 +
 include/linux/tegra-soc.h                       |   22 -
 include/{linux/tegra-ahb.h => soc/tegra/ahb.h}  |    6 +-
 include/soc/tegra/common.h                      |   14 +
 .../tegra-cpuidle.h => soc/tegra/cpuidle.h}     |    6 +-
 include/soc/tegra/fuse.h                        |   65 +
 include/soc/tegra/pm.h                          |   38 +
 .../tegra-powergate.h => soc/tegra/pmc.h}       |   31 +-
 include/video/samsung_fimd.h                    |    2 +-
 sound/soc/samsung/goni_wm8994.c                 |    2 +-
 319 files changed, 3715 insertions(+), 13811 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-tegra-fuse
 create mode 100644 Documentation/devicetree/bindings/fuse/nvidia,tegra20-fuse.txt
 create mode 100644 Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
 delete mode 100644 arch/arm/configs/s5p64x0_defconfig
 delete mode 100644 arch/arm/configs/s5pc100_defconfig
 create mode 100644 arch/arm/include/debug/clps711x.S
 delete mode 100644 arch/arm/mach-clps711x/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-exynos/regs-sys.h
 delete mode 100644 arch/arm/mach-integrator/include/mach/memory.h
 delete mode 100644 arch/arm/mach-omap2/ctrl_module_core_44xx.h
 delete mode 100644 arch/arm/mach-omap2/ctrl_module_pad_core_44xx.h
 delete mode 100644 arch/arm/mach-omap2/ctrl_module_pad_wkup_44xx.h
 delete mode 100644 arch/arm/mach-s5p64x0/Kconfig
 delete mode 100644 arch/arm/mach-s5p64x0/Makefile
 delete mode 100644 arch/arm/mach-s5p64x0/Makefile.boot
 delete mode 100644 arch/arm/mach-s5p64x0/clock-s5p6440.c
 delete mode 100644 arch/arm/mach-s5p64x0/clock-s5p6450.c
 delete mode 100644 arch/arm/mach-s5p64x0/clock.c
 delete mode 100644 arch/arm/mach-s5p64x0/clock.h
 delete mode 100644 arch/arm/mach-s5p64x0/common.c
 delete mode 100644 arch/arm/mach-s5p64x0/common.h
 delete mode 100644 arch/arm/mach-s5p64x0/dev-audio.c
 delete mode 100644 arch/arm/mach-s5p64x0/dma.c
 delete mode 100644 arch/arm/mach-s5p64x0/i2c.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/dma.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/map.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/pm-core.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s5p64x0/irq-pm.c
 delete mode 100644 arch/arm/mach-s5p64x0/mach-smdk6440.c
 delete mode 100644 arch/arm/mach-s5p64x0/mach-smdk6450.c
 delete mode 100644 arch/arm/mach-s5p64x0/pm.c
 delete mode 100644 arch/arm/mach-s5p64x0/setup-fb-24bpp.c
 delete mode 100644 arch/arm/mach-s5p64x0/setup-i2c0.c
 delete mode 100644 arch/arm/mach-s5p64x0/setup-i2c1.c
 delete mode 100644 arch/arm/mach-s5p64x0/setup-sdhci-gpio.c
 delete mode 100644 arch/arm/mach-s5p64x0/setup-spi.c
 delete mode 100644 arch/arm/mach-s5pc100/Kconfig
 delete mode 100644 arch/arm/mach-s5pc100/Makefile
 delete mode 100644 arch/arm/mach-s5pc100/Makefile.boot
 delete mode 100644 arch/arm/mach-s5pc100/clock.c
 delete mode 100644 arch/arm/mach-s5pc100/common.c
 delete mode 100644 arch/arm/mach-s5pc100/common.h
 delete mode 100644 arch/arm/mach-s5pc100/dev-audio.c
 delete mode 100644 arch/arm/mach-s5pc100/dma.c
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/dma.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/map.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s5pc100/mach-smdkc100.c
 delete mode 100644 arch/arm/mach-s5pc100/setup-fb-24bpp.c
 delete mode 100644 arch/arm/mach-s5pc100/setup-i2c0.c
 delete mode 100644 arch/arm/mach-s5pc100/setup-i2c1.c
 delete mode 100644 arch/arm/mach-s5pc100/setup-ide.c
 delete mode 100644 arch/arm/mach-s5pc100/setup-keypad.c
 delete mode 100644 arch/arm/mach-s5pc100/setup-sdhci-gpio.c
 delete mode 100644 arch/arm/mach-s5pc100/setup-spi.c
 rename arch/arm/mach-s5pv210/include/mach/{gpio.h => gpio-samsung.h} (96%)
 rename arch/arm/mach-shmobile/{include/mach => }/clock.h (100%)
 rename arch/arm/mach-shmobile/{include/mach => }/common.h (100%)
 rename arch/arm/mach-shmobile/{include/mach => }/dma-register.h (100%)
 rename arch/arm/mach-shmobile/{include/mach => }/intc.h (100%)
 create mode 100644 arch/arm/mach-shmobile/irqs.h
 rename arch/arm/mach-shmobile/{include/mach => }/pm-rcar.h (100%)
 rename arch/arm/mach-shmobile/{include/mach => }/pm-rmobile.h (100%)
 rename arch/arm/mach-shmobile/{include/mach => }/r7s72100.h (82%)
 rename arch/arm/mach-shmobile/{include/mach => }/r8a73a4.h (100%)
 rename arch/arm/mach-shmobile/{include/mach => }/r8a7740.h (98%)
 rename arch/arm/mach-shmobile/{include/mach => }/r8a7778.h (100%)
 rename arch/arm/mach-shmobile/{include/mach => }/r8a7790.h (93%)
 rename arch/arm/mach-shmobile/{include/mach => }/rcar-gen2.h (100%)
 rename arch/arm/mach-shmobile/{include/mach => }/sh7372.h (96%)
 rename arch/arm/mach-shmobile/{include/mach => }/sh73a0.h (100%)
 delete mode 100644 arch/arm/mach-tegra/apbio.c
 delete mode 100644 arch/arm/mach-tegra/apbio.h
 delete mode 100644 arch/arm/mach-tegra/fuse.c
 delete mode 100644 arch/arm/mach-tegra/fuse.h
 delete mode 100644 arch/arm/mach-tegra/pmc.c
 delete mode 100644 arch/arm/mach-tegra/pmc.h
 delete mode 100644 arch/arm/mach-tegra/powergate.c
 delete mode 100644 arch/arm/plat-versatile/include/plat/clcd.h
 create mode 100644 drivers/misc/fuse/Makefile
 create mode 100644 drivers/soc/tegra/Makefile
 create mode 100644 drivers/soc/tegra/common.c
 create mode 100644 drivers/soc/tegra/fuse/Makefile
 create mode 100644 drivers/soc/tegra/fuse/fuse-tegra.c
 create mode 100644 drivers/soc/tegra/fuse/fuse-tegra20.c
 create mode 100644 drivers/soc/tegra/fuse/fuse-tegra30.c
 create mode 100644 drivers/soc/tegra/fuse/fuse.h
 rename arch/arm/mach-tegra/tegra114_speedo.c => drivers/soc/tegra/fuse/speedo-tegra114.c (55%)
 create mode 100644 drivers/soc/tegra/fuse/speedo-tegra124.c
 rename arch/arm/mach-tegra/tegra20_speedo.c => drivers/soc/tegra/fuse/speedo-tegra20.c (67%)
 rename arch/arm/mach-tegra/tegra30_speedo.c => drivers/soc/tegra/fuse/speedo-tegra30.c (52%)
 create mode 100644 drivers/soc/tegra/fuse/tegra-apbmisc.c
 create mode 100644 drivers/soc/tegra/pmc.c
 rename arch/arm/plat-versatile/clcd.c => drivers/video/fbdev/amba-clcd-versatile.c (98%)
 create mode 100644 include/linux/platform_data/video-clcd-versatile.h
 delete mode 100644 include/linux/tegra-soc.h
 rename include/{linux/tegra-ahb.h => soc/tegra/ahb.h} (86%)
 create mode 100644 include/soc/tegra/common.h
 rename include/{linux/tegra-cpuidle.h => soc/tegra/cpuidle.h} (86%)
 create mode 100644 include/soc/tegra/fuse.h
 create mode 100644 include/soc/tegra/pm.h
 rename include/{linux/tegra-powergate.h => soc/tegra/pmc.h} (82%)
