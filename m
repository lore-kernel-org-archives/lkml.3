Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaDETGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:06:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:56196 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaDETGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:06:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 6/8] ARM: SoC: driver changes
Date: Sat, 5 Apr 2014 20:06:06 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201404052101.19381.arnd@arndb.de>
In-Reply-To: <201404052101.19381.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404052106.07135.arnd@arndb.de>
X-Provags-ID: V02:K0:UWa1rYfZjr8S5uKXtfag+S65zm/MmwMD61h5Jo+RxlT
 Gj0WUbnLcwQ14Jeh1D40YY63gkv/6LsOclfQ1fg2aqCVX5mkV0
 Z68stjW/MSw9ou4DZGmmsX3gTQk+W0oSFxRGy4V5c1P2J3m7ey
 6RejyAfnbqKEjX5zxxZ1jHiHffNOSw6ZGfNABJohHppncaW5Z7
 w5os33vESVqa8CPgoDYzYsXr/9qb6aklD0JYvU4cT3QScUsFQw
 NEgOidUHym3b/ycL668GU1/9XczYW7tnHKGPGFe18/X0+RzwKX
 GhpdT61fpH3v3Rb5rOcmOhkLi7twJntfgWFkKnFZsj3Wkpx4D2
 ctnJgfLA1B+GC1wuAEHPVB5r0EZwtw9l07SwLmVte
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e063735f9155826ee96a9bbc5407a1ead192f295:

  ARM: STi: STIH416: Add IR support. (2014-03-11 10:04:38 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers-3.15

for you to fetch changes up to f1d7d8c86bc8ca41c88acf10ce383c5104cf4920:

  Merge tag 'samsung-pm-1' of http://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/drivers (2014-03-29 01:47:15 +0100)

----------------------------------------------------------------

ARM: SoC: driver changes

These changes are mostly for ARM specific device drivers that either
don't have an upstream maintainer, or that had the maintainer ask
us to pick up the changes to avoid conflicts. A large chunk of this
are clock drivers (bcm281xx, exynos, versatile, shmobile), aside from
that, reset controllers for STi as well as a large rework of the
Marvell Orion/EBU watchdog driver are notable.

Conflicts are all in Kconfig, because of the move of kirkwood
and dove to mvebu being slightly less coordinated than it should
have been:
* PHY_MVEBU_SATA now needs to depend on any of
  ARCH_KIRKWOOD || ARCH_DOVE || MACH_KIRKWOOD || MACH_DOVE
  Long story, will get better in 3.16 when ARCH_KIRKWOOD and
  ARCH_DOVE are ready to be removed.
* ORION_WATCHDOG just needs to depend on
  ARCH_ORION5X || ARCH_KIRKWOOD || ARCH_DOVE || ARCH_MVEBU, as the latter
  now includes support for MACH_KIRKWOOD and MACH_DOVE.
* Same for SND_KIRKWOOD_SOC, which should now depend on
  ARCH_KIRKWOOD || ARCH_DOVE || ARCH_MVEBU || COMPILE_TEST

----------------------------------------------------------------
Alex Elder (2):
      clk: bcm281xx: add initial clock framework support
      clk: bcm281xx: don't disable unused peripheral clocks

Andrew Lunn (2):
      drivers: Enable building of Kirkwood drivers for mach-mvebu
      Power: Reset: Generalize qnap-poweroff to work on Synology devices.

Arnd Bergmann (16):
      Merge tag 'davinci-for-v3.15/nand' of git://git.kernel.org/.../nsekhar/linux-davinci into next/drivers
      Merge tag 'irqchip-mvebu-fixes-3.14' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge tag 'mvebu-watchdog-3.15' of git://git.infradead.org/linux-mvebu into next/drivers
      irqchip: VIC: export vic_init_cascaded
      Merge branch 'qcom/cleanup' into next/drivers
      Merge tag 'qcom-drivers-for-3.15' of git://git.kernel.org/.../galak/linux-qcom into next/drivers
      Merge tag 'armsoc/for-3.15/drivers' of git://github.com/broadcom/mach-bcm into next/drivers
      Merge tag 'socfpga_updates_for_3.15_v2' of git://git.rocketboards.org/linux-socfpga-next into next/drivers
      Merge tag 'mvebu-drivers-3.15-2' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge branch 'sti/dt' into next/drivers
      Merge tag 'sti-reset-for-v3.15' of git://git.stlinux.com/devel/kernel/linux-sti into next/drivers
      Merge branch 'cleanup/kconfig' into next/drivers
      Revert "net: stmmac: Add SOCFPGA glue driver"
      Revert "dts: socfpga: Add DTS entry for adding the stmmac glue layer for stmmac."
      Merge branch 'reset/for_v3.15' of git://git.pengutronix.de/git/pza/linux into next/drivers
      Merge tag 'samsung-pm-1' of http://git.kernel.org/.../kgene/linux-samsung into next/drivers

Dinh Nguyen (6):
      net: stmmac: Add SOCFPGA glue driver
      dts: socfpga: Add DTS entry for adding the stmmac glue layer for stmmac.
      ARM: socfpga: Update socfpga_defconfig
      dts: socfpga: Update clock entry to support multiple parents
      dts: socfpga: Add support for SD/MMC on the SOCFPGA platform
      dts: socfpga: Add sysmgr node so the gmac can use to reference

Ezequiel Garcia (13):
      watchdog: orion: Add clock error handling
      watchdog: orion: Use atomic access for shared registers
      watchdog: orion: Remove unused macros
      watchdog: orion: Make sure the watchdog is initially stopped
      watchdog: orion: Handle the interrupt so it's properly acked
      watchdog: orion: Make RSTOUT register a separate resource
      watchdog: orion: Remove unneeded BRIDGE_CAUSE clear
      watchdog: orion: Introduce an orion_watchdog device structure
      watchdog: orion: Introduce per-compatible of_device_id data
      watchdog: orion: Add per-compatible clock initialization
      watchdog: orion: Add per-compatible watchdog start implementation
      watchdog: orion: Add support for Armada 370 and Armada XP SoC
      watchdog: orion: Enable the build on ARCH_MVEBU

Fabio Estevam (1):
      watchdog: orion_wdt: Use %pa to print 'phys_addr_t'

Fengguang Wu (1):
      rtc: isl12057: use PTR_ERR_OR_ZERO to fix coccinelle warnings

Geert Uytterhoeven (4):
      ARM: shmobile: r7s72100 clock: Add RSPI clocks
      ARM: shmobile: r7s72100 clock: Add RSPI clocks for DT
      ARM: shmobile: r8a7791 clock: add QSPI clocks
      ARM: shmobile: r8a7791: Fix SCIFA3-5 clocks

Guennadi Liakhovetski (1):
      ARM: shmobile: wait for MSTP clock status to toggle, when enabling it

Ivan Khoronzhuk (1):
      ARM: davinci: aemif: get rid of davinci-nand driver dependency on aemif

Josh Cartwright (1):
      bus: mvebu-mbus: make use of of_find_matching_node_and_match

Kumar Gala (5):
      tty: serial: msm: Enable building msm_serial for ARCH_QCOM
      drm/msm: drop ARCH_MSM Kconfig depend
      power: reset: msm - switch Kconfig to ARCH_QCOM depends
      hwrng: msm: switch Kconfig to ARCH_QCOM depends
      gpio: msm: switch Kconfig to ARCH_QCOM depends

Kuninori Morimoto (5):
      ARM: shmobile: r8a7790: add Audio DMAC clock
      ARM: shmobile: r8a7790: add Audio DMAC support
      ARM: shmobile: r8a7778: add audio clock in new style
      ARM: shmobile: r8a7790: add audio clock
      ARM: shmobile: r8a7790: add sound SCU clock support

Laurent Pinchart (2):
      ARM: shmobile: r8a7779: Wait for status on selected MSTP clocks
      ARM: shmobile: r8a7791: Remove legacy clock aliases for DT devices

Linus Walleij (10):
      ARM: integrator: define clocks in the device trees
      ARM: SP804: make Integrator/CP timer pick clock from DT
      ARM: integrator: switch to fetch clocks from device tree
      clk: versatile: pass a parent to the ICST clock
      clk: versatile: respect parent rate in ICST clock
      irqchip: vic: update the base IRQ member correctly
      irqchip: support cascaded VICs
      ARM: integrator: use managed resources for the IM-PD1
      ARM: integrator: register the IM-PD1 VIC
      ARM: integrator: select GPIO block

Magnus Damm (2):
      ARM: shmobile: Add r8a7791 legacy SDHI clocks
      ARM: shmobile: Remove legacy r8a7790 DT clocks

Maxime Ripard (1):
      reset: Add of_reset_control_get

Olof Johansson (9):
      Merge tag 'renesas-soc-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'integrator-for-v3.15-1' of git://git.kernel.org/.../linusw/linux-integrator into next/drivers
      Merge tag 'mvebu-watchdog-3.15-2' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge tag 'omap-for-v3.15/crossbar-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'renesas-clock-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-clock2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-clock3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-clock4-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'tegra-for-3.15-drivers' of git://git.kernel.org/.../tegra/linux into next/drivers

Philipp Zabel (2):
      reset: allow drivers to request probe deferral
      reset: Add optional resets and stubs

Punit Agrawal (2):
      drivers: cci: Extend support to CCI revisions > r1p2
      drivers: cci: Export CCI PMU revision

Rashika Kheria (1):
      reset: Mark function as static and remove unused function in core.c

Shinya Kuribayashi (2):
      ARM: shmobile: r8a7790: Wait for status on all MSTP clocks
      ARM: shmobile: r8a7791: Wait for status on all MSTP clocks

Simon Horman (2):
      ARM: shmobile: r7s72100: Add clock for r7s72100-ether
      ARM: shmobile: r8a7790: Correct SYS DMAC clock defines

Sricharan R (4):
      DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
      DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP
      ARM: OMAP4+: Correct Wakeup-gen code to use physical irq number
      ARM: DRA: Enable Crossbar IP support for DRA7XX

Srinivas Kandagatla (2):
      drivers: reset: stih415: add softreset controller
      drivers: reset: stih416: add softreset controller

Stephen Gallimore (4):
      drivers: reset: STi SoC system configuration reset controller support
      drivers: reset: Reset controller driver for STiH415
      drivers: reset: Reset controller driver for STiH416
      ARM: STi: Add reset controller support to mach-sti Kconfig

Thomas Petazzoni (1):
      rtc: mv: reset date if after year 2038

Tomasz Figa (9):
      clk: exynos4: Remove remnants of non-DT support
      clk: samsung: Provide common helpers for register save/restore
      clk: samsung: exynos4: Move suspend/resume handling to SoC driver
      clk: samsung: exynos5250: Move suspend/resume handling to SoC driver
      clk: samsung: exynos5420: Move suspend/resume handling to SoC driver
      clk: samsung: s3c64xx: Move suspend/resume handling to SoC driver
      clk: samsung: Drop old suspend/resume code
      clk: samsung: exynos4: Add remaining suspend/resume handling
      ARM: EXYNOS: Drop legacy Exynos4 clock suspend/resume code

Tony Lindgren (1):
      Merge branch 'crossbar_3.14_rc1' of git://github.com/Sricharanti/sricharan into omap-for-v3.15/crossbar

Valentine Barshak (7):
      ARM: shmobile: r8a7791: Add I2C clocks
      ARM: shmobile: r8a7791: Add VIN clocks
      ARM: shmobile: r8a7790: Add VIN clock support
      ARM: shmobile: r8a7790: Add SATA clocks
      ARM: shmobile: r8a7791: Add ZS clock
      ARM: shmobile: r8a7791: Add SATA clocks
      ARM: shmobile: r8a7790: Add PCI USB host clock support

Wolfram Sang (3):
      ARM: shmobile: r7s72100: really add i2c clocks
      drivers/amba: don't check resource with devm_ioremap_resource
      ARM: shmobile: r7s72100: fix bus clock calculation


 Documentation/devicetree/bindings/arm/gic.txt      |    6 +
 .../devicetree/bindings/arm/omap/crossbar.txt      |   27 +
 .../devicetree/bindings/clock/arm-integrator.txt   |   34 +
 .../devicetree/bindings/mmc/socfpga-dw-mshc.txt    |   23 +
 .../bindings/power_supply/qnap-poweroff.txt        |    5 +-
 .../devicetree/bindings/watchdog/marvel.txt        |   11 +-
 arch/arm/boot/dts/integratorap.dts                 |   35 +
 arch/arm/boot/dts/integratorcp.dts                 |  102 +-
 arch/arm/boot/dts/r8a7790.dtsi                     |   23 +
 arch/arm/boot/dts/socfpga.dtsi                     |   38 +-
 arch/arm/boot/dts/socfpga_arria5.dtsi              |   11 +
 arch/arm/boot/dts/socfpga_cyclone5.dtsi            |   11 +
 arch/arm/boot/dts/socfpga_vt.dts                   |   11 +
 arch/arm/common/timer-sp.c                         |    8 +-
 arch/arm/configs/socfpga_defconfig                 |    6 +
 arch/arm/mach-davinci/aemif.c                      |  107 +-
 arch/arm/mach-davinci/board-da830-evm.c            |    3 +
 arch/arm/mach-davinci/board-da850-evm.c            |    3 +
 arch/arm/mach-davinci/board-dm644x-evm.c           |    5 +
 arch/arm/mach-davinci/board-dm646x-evm.c           |    3 +
 arch/arm/mach-davinci/board-mityomapl138.c         |    4 +
 arch/arm/mach-dove/include/mach/bridge-regs.h      |    1 +
 arch/arm/mach-exynos/pm.c                          |  148 +--
 arch/arm/mach-integrator/Kconfig                   |    3 +
 arch/arm/mach-integrator/impd1.c                   |   81 +-
 arch/arm/mach-integrator/integrator_ap.c           |   19 +-
 arch/arm/mach-integrator/integrator_cp.c           |    6 -
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h  |    1 +
 arch/arm/mach-mv78xx0/include/mach/bridge-regs.h   |    1 +
 arch/arm/mach-omap2/Kconfig                        |    1 +
 arch/arm/mach-omap2/omap-wakeupgen.c               |    4 +-
 arch/arm/mach-omap2/omap4-common.c                 |    4 +
 arch/arm/mach-orion5x/include/mach/bridge-regs.h   |    1 +
 arch/arm/mach-shmobile/clock-r7s72100.c            |   36 +-
 arch/arm/mach-shmobile/clock-r8a7778.c             |    4 +
 arch/arm/mach-shmobile/clock-r8a7779.c             |   20 +-
 arch/arm/mach-shmobile/clock-r8a7790.c             |  196 ++--
 arch/arm/mach-shmobile/clock-r8a7791.c             |  153 ++-
 arch/arm/mach-shmobile/include/mach/r8a7790.h      |   25 +
 arch/arm/mach-shmobile/setup-r8a7790.c             |   90 ++
 arch/arm/mach-sti/Kconfig                          |    3 +
 arch/arm/mach-versatile/core.c                     |    2 +-
 arch/arm/plat-orion/common.c                       |   10 +-
 drivers/amba/tegra-ahb.c                           |    2 -
 drivers/bus/arm-cci.c                              |   24 +-
 drivers/bus/mvebu-mbus.c                           |    3 +-
 drivers/char/hw_random/Kconfig                     |    6 +-
 drivers/clk/Kconfig                                |    1 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/bcm/Kconfig                            |    9 +
 drivers/clk/bcm/Makefile                           |    3 +
 drivers/clk/bcm/clk-bcm281xx.c                     |  416 ++++++++
 drivers/clk/bcm/clk-kona-setup.c                   |  769 +++++++++++++++
 drivers/clk/bcm/clk-kona.c                         | 1033 ++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h                         |  410 ++++++++
 drivers/clk/samsung/clk-exynos4.c                  |  172 +++-
 drivers/clk/samsung/clk-exynos5250.c               |   49 +-
 drivers/clk/samsung/clk-exynos5420.c               |   49 +-
 drivers/clk/samsung/clk-exynos5440.c               |    2 +-
 drivers/clk/samsung/clk-s3c64xx.c                  |   79 +-
 drivers/clk/samsung/clk.c                          |   71 +-
 drivers/clk/samsung/clk.h                          |   14 +-
 drivers/clk/versatile/clk-icst.c                   |   21 +-
 drivers/clk/versatile/clk-icst.h                   |    1 +
 drivers/clk/versatile/clk-impd1.c                  |    6 +-
 drivers/clk/versatile/clk-integrator.c             |   83 +-
 drivers/clk/versatile/clk-realview.c               |    4 +-
 drivers/cpufreq/Kconfig.arm                        |    2 +-
 drivers/cpuidle/Kconfig.arm                        |    2 +-
 drivers/gpio/Kconfig                               |    2 +-
 drivers/gpu/drm/msm/Kconfig                        |    2 +-
 drivers/irqchip/Kconfig                            |    8 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-crossbar.c                     |  208 ++++
 drivers/irqchip/irq-gic.c                          |   82 +-
 drivers/irqchip/irq-vic.c                          |   60 +-
 drivers/leds/Kconfig                               |    4 +-
 drivers/mtd/nand/davinci_nand.c                    |   22 -
 drivers/phy/Kconfig                                |    2 +-
 drivers/power/reset/Kconfig                        |    2 +-
 drivers/power/reset/qnap-poweroff.c                |   49 +-
 drivers/reset/Kconfig                              |    2 +
 drivers/reset/Makefile                             |    1 +
 drivers/reset/core.c                               |   71 +-
 drivers/reset/sti/Kconfig                          |   15 +
 drivers/reset/sti/Makefile                         |    4 +
 drivers/reset/sti/reset-stih415.c                  |  112 +++
 drivers/reset/sti/reset-stih416.c                  |  143 +++
 drivers/reset/sti/reset-syscfg.c                   |  186 ++++
 drivers/reset/sti/reset-syscfg.h                   |   69 ++
 drivers/rtc/rtc-isl12057.c                         |    5 +-
 drivers/rtc/rtc-mv.c                               |   12 +
 drivers/sh/clk/cpg.c                               |   38 +
 drivers/thermal/Kconfig                            |    2 +-
 drivers/tty/serial/Kconfig                         |    2 +-
 drivers/watchdog/Kconfig                           |    2 +-
 drivers/watchdog/orion_wdt.c                       |  381 ++++++--
 include/dt-bindings/clock/bcm281xx.h               |   65 ++
 include/dt-bindings/clock/r8a7790-clock.h          |    4 +-
 include/linux/irqchip/arm-gic.h                    |    7 +-
 include/linux/irqchip/arm-vic.h                    |    6 +-
 include/linux/irqchip/irq-crossbar.h               |   11 +
 include/linux/platform_data/clk-integrator.h       |    1 -
 include/linux/platform_data/mtd-davinci-aemif.h    |    5 +-
 include/linux/reset.h                              |   65 +-
 include/linux/sh_clk.h                             |   19 +-
 106 files changed, 5489 insertions(+), 698 deletions(-)
