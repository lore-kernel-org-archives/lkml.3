Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaAWSrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:47:24 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57487 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaAWSrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:47:18 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 2/6] ARM: SoC cleanups for 3.14
Date: Thu, 23 Jan 2014 10:36:24 -0800
Message-Id: <1390502188-16896-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1390502188-16896-1-git-send-email-olof@lixom.net>
References: <1390502188-16896-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the branch where we usually queue up cleanup efforts, moving
drivers out of the architecture directory, header file restructuring,
etc. Sometimes they tangle with new development so it's hard to keep it
strictly to cleanups.

Some of the things included in this branch are:

* Atmel SAMA5 conversion to common clock
* Reset framework conversion for tegra platforms
- Some of this depends on tegra clock driver reworks that are shared with Mike
Turquette's clk tree.
* Tegra DMA refactoring, which are shared branches with the DMA tree.
* Removal of some header files on exynos to prepare for multiplatform

----------------------------------------------------------------

The following changes since commit 2efe1a5937f3d7d9f7baeaca34fc9082e747a41e:

  Merge branch 'next/fixes-non-critical' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-linus

for you to fetch changes up to 273c2279ca502267fac40bcaecb35942380c429c:

  Merge tag 'at91-cleanup2' of git://github.com/at91linux/linux-at91 into next/cleanup

----------------------------------------------------------------

Alexandre Courbot (1):
      clk: tegra: add FUSE clock device

Andrew Chew (1):
      clk: tegra: Set the clk parent of host1x to pll_p

Andrew Lunn (3):
      ARM: Orion: Add missing includes
      ARM: Orion5x: Fix warnings when using C=1.
      ARM: Dove: Fix compiler warnings with C=1 builds

Arnaud Patard (1):
      ARM: kirkwood: stop printk TCLK value at boot for DT boards

Boris BREZILLON (23):
      ARM: at91: move at91_pmc.h to include/linux/clk/at91_pmc.h
      ARM: at91: add Kconfig options for common clk support
      clk: at91: add PMC base support
      clk: at91: add PMC macro file for dt definitions
      clk: at91: add PMC main clock
      clk: at91: add PMC pll clocks
      clk: at91: add PMC master clock
      clk: at91: add PMC system clocks
      clk: at91: add PMC peripheral clocks
      clk: at91: add PMC programmable clocks
      clk: at91: add PMC utmi clock
      clk: at91: add PMC usb clock
      clk: at91: add PMC smd clock
      dt: binding: add at91 clks dt bindings documentation
      ARM: at91: move pit timer to common clk framework
      ARM: at91: add new compatible strings for pmc driver
      ARM: at91: prepare sama5 dt boards transition to common clk
      ARM: at91: prepare common clk transition for sama5d3 SoC
      ARM: at91/dt: define sama5d3 clocks
      ARM: at91/dt: define sama5d3xek's main clk frequency
      ARM: at91: move sama5d3 SoC to common clk
      ARM: at91/dt: remove old clk material
      clk: at91: fix pmc_clk_ids data type attriubte

Dan Carpenter (1):
      spi: tegra: checking for ERR_PTR instead of NULL

Daniel Kurtz (3):
      ARM: EXYNOS: Constify data tables for pmu
      ARM: SAMSUNG: Let s3c_pm_do_restore_*() take const sleep_save
      ARM: EXYNOS: Constify clksrc immutable register restore tables

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: switch Calao QIL-A9260 board to DT

Jisheng Zhang (1):
      ARM: mvebu: fix some sparse warnings

Joseph Lo (2):
      clk: tegra124: add wait_for_reset and disable_clock for tegra_cpu_car_ops
      clk: tegra124: add suspend/resume function for tegra_cpu_car_ops

Kevin Hilman (1):
      Merge tag 'at91-cleanup2' of git://github.com/at91linux/linux-at91 into next/cleanup

Kukjin Kim (11):
      ARM: EXYNOS: cleanup <mach/regs-pmu.h>
      ARM: EXYNOS: remove inclusion <mach/regs-pmu.h> into another headers
      ARM: EXYNOS: local regs-pmu.h header file
      ARM: EXYNOS: cleanup <mach/regs-irq.h>
      ARM: EXYNOS: cleanup <mach/regs-clock.h>
      PM / devfreq: move definitions for exynos4_bus into drivers/devfreq
      ARM: EXYNOS: local definitions for pm.c into mach-exynos dir
      cpufreq: exynos: move definitions for exynos-cpufreq into drivers/cpufreq/
      ARM: EXYNOS: local definitions for cpuidle.c into mach-exynos dir
      ARM: EXYNOS: remove <mach/regs-clock.h> for exynos
      PM / devfreq: use inclusion <mach/map.h> instead of <plat/map-s5p.h>

Kuninori Morimoto (14):
      ARM: shmobile: ape6evm: don't use named resource for MMCIF
      ARM: shmobile: ape6evm: don't use named resource for SDHI
      ARM: shmobile: lager: don't use named resource for MMCIF
      ARM: shmobile: sh73a0: don't use named resource for TMU
      ARM: shmobile: sh73a0: don't use named resource for I2C
      ARM: shmobile: sh73a0: don't use named resource for IPMMU
      ARM: shmobile: bockw: header cleanup
      ARM: shmobile: r8a7779: cleanup registration of VIN
      ARM: shmobile: r8a7779: camera-rcar header cleanup
      ARM: shmobile: r8a7779: cleanup registration of sh_eth
      ARM: shmobile: sh73a0: tidyup clock table order
      ARM: shmobile: r7s72100: tidyup clock table order
      ARM: shmobile: sh7372: tidyup clock table order
      ARM: shmobile: remove unnecessary platform_device as header cleanup

Laurent Pinchart (14):
      serial: sh-sci: Fix warnings due to improper casts and printk formats
      serial: sh-sci: Don't enable/disable port from within break timer
      serial: sh-sci: Convert to clk_prepare/unprepare
      serial: sh-sci: Sort headers alphabetically
      serial: sh-sci: Remove baud rate calculation algorithm 5
      serial: sh-sci: Simplify baud rate calculation algorithms
      serial: sh-sci: Remove duplicate interrupt check in verify port op
      serial: sh-sci: Set the UPF_FIXED_PORT flag
      serial: sh-sci: Don't check IRQ in verify port operation
      serial: sh-sci: Support resources passed through platform resources
      serial: sh-sci: Move overrun_bit and error_mask fields out of pdata
      serial: sh-sci: Remove unused GPIO request code
      serial: sh-sci: Compute overrun_bit without using baud rate algo
      serial: sh-sci: Rework baud rate calculation

Magnus Damm (2):
      ARM: shmobile: Cosmetic update of Lager DT Reference
      ARM: shmobile: Add r8a7790_register_pfc() function

Mark Zhang (3):
      clk: tegra: Correct sbc mux width & parent
      clk: tegra: Fix vde/2d/3d clock src offset
      clk: tegra: Set the clock parent of gr2d/gr3d to pll_c2

Michael Opdenacker (4):
      arm: plat-orion: remove deprecated IRQF_DISABLED
      ARM: SAMSUNG: remove unused SAMSUNG_GPIOLIB_4BIT Kconfig parameter
      ARM: SAMSUNG: remove IRQF_DISABLED
      ARM: pxa: remove IRQF_DISABLED

Michal Simek (1):
      arm: zynq: Add support for zynq_cpu_kill function

Mikko Perttunen (1):
      clk: tegra114: Initialize clocks needed for HDMI

Nicolas Ferre (1):
      ARM: at91: remove AT91_PROGRAMMABLE_CLOCKS configuration option

Nicolas Pitre (1):
      ARM: clean up cache handling in platform code

Olof Johansson (14):
      Merge tag 'renesas-cleanup-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'mvebu-soc-3.14' of git://git.infradead.org/linux-mvebu into next/cleanup
      Merge commit 'fixes' into next/cleanup
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge tag 'zynq-cleanup-for-3.14' of git://git.xilinx.com/linux-xlnx into next/cleanup
      Merge tag 'samsung-cleanup' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'v3.13-rc4' into next/cleanup
      Merge branches 'depends/asoc-dma', 'depends/dma-of' and 'depends/tegra-clk' into next/cleanup
      Merge tag 'tegra-for-3.14-dmas-resets-rework' of git://git.kernel.org/.../tegra/linux into next/cleanup
      Merge tag 'samsung-cleanup-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'renesas-cleanup2-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-sh-sci-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-sh-sci2-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'mvebu-soc-3.14-2' of git://git.infradead.org/linux-mvebu into next/cleanup

Peter De Schrijver (27):
      ARM: tegra114: add missing clocks to binding
      clk: tegra: replace enum tegra114_clk by binding header
      clk: tegra: add TEGRA_DIVIDER_ROUND_UP for periph clks
      clk: tegra: PLLE spread spectrum control
      ARM: tegra30: add missing CLK IDs
      clk: tegra: simplify periph clock data
      clk: tegra: common periph_clk_enb_refcnt and clks
      clk: tegra: Add TEGRA_PERIPH_NO_DIV flag
      clk: tegra: move some PLLC and PLLXC init to clk-pll.c
      clk: tegra: use pll_ref as the pll_e parent
      clk: tegra: move fields to tegra_clk_pll_params
      clk: tegra: add header for common tegra clock IDs
      clk: tegra: add common infra for DT clocks
      clk: tegra: add clkdev registration infra
      clk: tegra: move audio clk to common file
      clk: tegra: move periph clocks to common file
      clk: tegra: move PMC, fixed clocks to common files
      clk: tegra: introduce common gen4 super clock
      clk: tegra: move tegra30 to common infra
      clk: tegra: move tegra20 to common infra
      clk: tegra: Add support for PLLSS
      clk: tegra: Add periph regs bank X
      clk: tegra: add locking to periph clks
      clk: tegra: add TEGRA_PERIPH_NO_GATE
      clk: tegra124: Add common clk IDs to clk-id.h
      clk: tegra124: Add new peripheral clocks
      clk: tegra124: Add support for Tegra124 clocks

Qiao Zhou (1):
      ARM: mmp: build sram driver alone

Sebastian Hesselbarth (1):
      ARM: kirkwood: remove lagacy clk workarounds

Simon Horman (1):
      ARM: shmobile: r8a7790: Correct typo in clocks

Soren Brinkmann (4):
      arm: zynq: platsmp: Remove CPU presence check
      arm: zynq: Invalidate L1 in secondary boot
      arm: zynq: Use of_platform_populate instead of bus_probe
      arm: zynq: Set proper GIC flags

Stephen Warren (34):
      dma: add dma_get_any_slave_channel(), for use in of_xlate()
      Merge branch 'for-3.14/deps-from-dma-defer_probe' into for-3.14/dmas-resets-rework
      Merge branch 'for-3.14/deps-from-dma-of' into for-3.14/dmas-resets-rework
      Merge tag 'asoc-dma-v3.14' into for-3.14/dmas-resets-rework
      Merge tag 'clk-tegra-for-3.14' into for-3.14/dmas-resets-rework
      ARM: tegra: add missing clock documentation to DT bindings
      ARM: tegra: document reset properties in DT bindings
      ARM: tegra: document use of standard DMA DT bindings
      ARM: tegra: update DT files to add reset properties
      ARM: tegra: update DT files to add DMA properties
      ARM: tegra: select the reset framework
      clk: tegra: implement a reset driver
      pci: tegra: use reset framework
      drm/tegra: use reset framework
      ARM: tegra: pass reset to tegra_powergate_sequence_power_up()
      dma: tegra: use reset framework
      dma: tegra: register as an OF DMA controller
      ASoC: tegra: use reset framework
      ASoC: tegra: call pm_runtime APIs around register accesses
      ASoC: tegra: allocate AHUB FIFO during probe() not startup()
      ASoC: tegra: convert to standard DMA DT bindings
      i2c: tegra: use reset framework
      staging: nvec: use reset framework
      spi: tegra: use reset framework
      spi: tegra: convert to standard DMA DT bindings
      serial: tegra: use reset framework
      serial: tegra: convert to standard DMA DT bindings
      Input: tegra-kbc - use reset framework
      USB: EHCI: tegra: use reset framework
      ARM: tegra: remove legacy clock entries from DT
      ARM: tegra: remove legacy DMA entries from DT
      clk: tegra: remove legacy reset APIs
      clk: tegra: remove bogus PCIE_XCLK
      ASoC: tegra: update module reset list for Tegra124

Sudeep KarkadaNagesha (1):
      ARM: zynq: remove unnecessary setting of cpu_present_mask

Sylwester Nawrocki (2):
      ARM: EXYNOS: Consolidate selection of PM_GENERIC_DOMAINS for Exynos4
      ARM: EXYNOS: Kill exynos_pm_late_initcall()

Thierry Reding (7):
      clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d
      clk: tegra: Fix clock rate computation
      clk: tegra: Initialize secondary gr3d clock on Tegra30
      clk: tegra: Properly setup PWM clock on Tegra30
      clk: tegra: Initialize DSI low-power clocks
      clk: tegra: Do not print errors for clk_round_rate()
      ARM: pxa: Remove unused variables

Thomas Petazzoni (3):
      ARM: mvebu: move ARMADA_XP_MAX_CPUS to armada-370-xp.h
      ARM: mvebu: remove prototypes of non-existing functions from common.h
      ARM: mvebu: move Armada 370/XP specific definitions to armada-370-xp.h

Uwe Kleine-König (1):
      ARM: orion5x: drop unused include from common.c

Wei Yongjun (1):
      clk: tegra: fix __clk_lookup() return value checks

Yanis Moreno (1):
      ARM: at91: remove redundant dependency


 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt   |    1 +
 .../devicetree/bindings/clock/at91-clock.txt    |  339 ++++
 .../bindings/clock/nvidia,tegra114-car.txt      |    4 +
 .../bindings/clock/nvidia,tegra124-car.txt      |   63 +
 .../bindings/clock/nvidia,tegra20-car.txt       |    4 +
 .../bindings/clock/nvidia,tegra30-car.txt       |    4 +
 .../devicetree/bindings/dma/tegra20-apbdma.txt  |   14 +
 .../bindings/gpu/nvidia,tegra20-host1x.txt      |  122 ++
 .../bindings/i2c/nvidia,tegra20-i2c.txt         |   27 +-
 .../bindings/input/nvidia,tegra20-kbc.txt       |    9 +
 .../bindings/mmc/nvidia,tegra20-sdhci.txt       |    9 +
 .../devicetree/bindings/nvec/nvidia,nvec.txt    |   12 +
 .../bindings/pci/nvidia,tegra20-pcie.txt        |   26 +-
 .../bindings/pwm/nvidia,tegra20-pwm.txt         |    9 +
 .../bindings/rtc/nvidia,tegra20-rtc.txt         |    3 +
 .../bindings/serial/nvidia,tegra20-hsuart.txt   |   19 +-
 .../sound/nvidia,tegra-audio-alc5632.txt        |    7 +-
 .../sound/nvidia,tegra-audio-rt5640.txt         |    7 +-
 .../sound/nvidia,tegra-audio-wm8753.txt         |    7 +-
 .../sound/nvidia,tegra-audio-wm8903.txt         |    7 +-
 .../sound/nvidia,tegra-audio-wm9712.txt         |    7 +-
 .../bindings/sound/nvidia,tegra20-ac97.txt      |   20 +-
 .../bindings/sound/nvidia,tegra20-i2s.txt       |   19 +-
 .../bindings/sound/nvidia,tegra30-ahub.txt      |   63 +-
 .../bindings/sound/nvidia,tegra30-i2s.txt       |   11 +-
 .../bindings/spi/nvidia,tegra114-spi.txt        |   24 +-
 .../bindings/spi/nvidia,tegra20-sflash.txt      |   20 +-
 .../bindings/spi/nvidia,tegra20-slink.txt       |   20 +-
 .../bindings/timer/nvidia,tegra20-timer.txt     |    3 +
 .../bindings/timer/nvidia,tegra30-timer.txt     |    3 +
 .../bindings/usb/nvidia,tegra20-ehci.txt        |    7 +-
 arch/arm/Kconfig                                |    1 -
 arch/arm/boot/dts/Makefile                      |    1 +
 arch/arm/boot/dts/at91-qil_a9260.dts            |  185 ++
 arch/arm/boot/dts/sama5d3.dtsi                  |  379 +++-
 arch/arm/boot/dts/sama5d3_can.dtsi              |   20 +
 arch/arm/boot/dts/sama5d3_emac.dtsi             |   11 +
 arch/arm/boot/dts/sama5d3_gmac.dtsi             |   11 +
 arch/arm/boot/dts/sama5d3_lcd.dtsi              |   17 +
 arch/arm/boot/dts/sama5d3_mci2.dtsi             |   12 +
 arch/arm/boot/dts/sama5d3_tcb1.dtsi             |   12 +
 arch/arm/boot/dts/sama5d3_uart.dtsi             |   21 +
 arch/arm/boot/dts/sama5d3xcm.dtsi               |   17 +-
 arch/arm/boot/dts/tegra114.dtsi                 |  157 +-
 arch/arm/boot/dts/tegra20-paz00.dts             |    2 +
 arch/arm/boot/dts/tegra20.dtsi                  |  136 +-
 arch/arm/boot/dts/tegra30.dtsi                  |  175 +-
 arch/arm/configs/at91_dt_defconfig              |    1 -
 arch/arm/configs/at91rm9200_defconfig           |    1 -
 arch/arm/configs/at91sam9260_9g20_defconfig     |    2 -
 arch/arm/configs/at91sam9261_9g10_defconfig     |    1 -
 arch/arm/configs/at91sam9g45_defconfig          |    1 -
 arch/arm/configs/at91sam9rl_defconfig           |    1 -
 arch/arm/configs/sama5_defconfig                |    1 -
 arch/arm/mach-at91/Kconfig                      |   50 +-
 arch/arm/mach-at91/Kconfig.non_dt               |   12 +-
 arch/arm/mach-at91/Makefile                     |    3 +-
 arch/arm/mach-at91/at91rm9200.c                 |    2 +-
 arch/arm/mach-at91/at91sam9260.c                |    2 +-
 arch/arm/mach-at91/at91sam9261.c                |    2 +-
 arch/arm/mach-at91/at91sam9263.c                |    2 +-
 arch/arm/mach-at91/at91sam926x_time.c           |   14 +-
 arch/arm/mach-at91/at91sam9g45.c                |    2 +-
 arch/arm/mach-at91/at91sam9n12.c                |    2 +-
 arch/arm/mach-at91/at91sam9rl.c                 |    2 +-
 arch/arm/mach-at91/at91sam9x5.c                 |    2 +-
 arch/arm/mach-at91/board-dt-sama5.c             |   10 +-
 arch/arm/mach-at91/board-qil-a9260.c            |  266 ---
 arch/arm/mach-at91/clock.c                      |   13 +-
 arch/arm/mach-at91/generic.h                    |    3 +-
 arch/arm/mach-at91/pm.c                         |    5 +-
 arch/arm/mach-at91/pm_slowclock.S               |    2 +-
 arch/arm/mach-at91/sama5d3.c                    |  344 +---
 arch/arm/mach-at91/setup.c                      |    8 +-
 arch/arm/mach-dove/common.c                     |   15 +-
 arch/arm/mach-exynos/Kconfig                    |    4 +-
 arch/arm/mach-exynos/common.c                   |    8 +-
 arch/arm/mach-exynos/common.h                   |    6 -
 arch/arm/mach-exynos/cpuidle.c                  |   25 +-
 arch/arm/mach-exynos/hotplug.c                  |    2 +-
 arch/arm/mach-exynos/include/mach/pm-core.h     |    5 +-
 arch/arm/mach-exynos/include/mach/regs-clock.h  |  372 ----
 arch/arm/mach-exynos/include/mach/regs-irq.h    |   19 -
 arch/arm/mach-exynos/mach-exynos5-dt.c          |    2 +-
 arch/arm/mach-exynos/platsmp.c                  |    6 +-
 arch/arm/mach-exynos/pm.c                       |   33 +-
 arch/arm/mach-exynos/pm_domains.c               |    9 +-
 arch/arm/mach-exynos/pmu.c                      |   17 +-
 .../mach-exynos/{include/mach => }/regs-pmu.h   |   53 -
 arch/arm/mach-imx/platsmp.c                     |    3 +-
 arch/arm/mach-kirkwood/board-dt.c               |   40 +-
 arch/arm/mach-mmp/Kconfig                       |    3 +
 arch/arm/mach-mmp/Makefile                      |    3 +-
 arch/arm/mach-msm/platsmp.c                     |    3 +-
 arch/arm/mach-mvebu/armada-370-xp.h             |    4 +
 arch/arm/mach-mvebu/coherency.c                 |    1 +
 arch/arm/mach-mvebu/coherency.h                 |    4 +-
 arch/arm/mach-mvebu/common.h                    |   10 +-
 arch/arm/mach-mvebu/hotplug.c                   |    1 +
 arch/arm/mach-mvebu/platsmp.c                   |    4 +-
 arch/arm/mach-mvebu/pmsu.c                      |    3 +-
 arch/arm/mach-mvebu/system-controller.c         |    5 +-
 arch/arm/mach-orion5x/board-dt.c                |    2 +-
 arch/arm/mach-orion5x/common.c                  |    7 +-
 arch/arm/mach-orion5x/db88f5281-setup.c         |    2 +-
 arch/arm/mach-orion5x/irq.c                     |    1 +
 arch/arm/mach-orion5x/pci.c                     |    4 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c         |    2 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c  |    2 +-
 arch/arm/mach-orion5x/ts209-setup.c             |    2 +-
 arch/arm/mach-orion5x/ts78xx-setup.c            |    2 +-
 arch/arm/mach-prima2/platsmp.c                  |    3 +-
 arch/arm/mach-pxa/am200epd.c                    |    3 +-
 arch/arm/mach-pxa/am300epd.c                    |    3 +-
 arch/arm/mach-pxa/em-x270.c                     |    3 +-
 arch/arm/mach-pxa/irq.c                         |    4 -
 arch/arm/mach-pxa/magician.c                    |    2 +-
 arch/arm/mach-pxa/mainstone.c                   |    2 +-
 arch/arm/mach-pxa/pcm990-baseboard.c            |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c                  |    8 +-
 arch/arm/mach-pxa/time.c                        |    2 +-
 arch/arm/mach-pxa/trizeps4.c                    |    3 +-
 arch/arm/mach-s3c24xx/dma.c                     |    2 +-
 arch/arm/mach-s3c24xx/simtec-usb.c              |    3 +-
 arch/arm/mach-s3c64xx/mach-smartq.c             |    2 +-
 arch/arm/mach-shmobile/board-ape6evm.c          |    6 +-
 arch/arm/mach-shmobile/board-bockw-reference.c  |    1 -
 arch/arm/mach-shmobile/board-lager-reference.c  |    5 +-
 arch/arm/mach-shmobile/board-lager.c            |    2 +-
 arch/arm/mach-shmobile/board-marzen.c           |   25 +-
 arch/arm/mach-shmobile/clock-r7s72100.c         |    3 +
 arch/arm/mach-shmobile/clock-r8a7790.c          |    2 +-
 arch/arm/mach-shmobile/clock-sh7372.c           |    9 +-
 arch/arm/mach-shmobile/clock-sh73a0.c           |   14 +-
 arch/arm/mach-shmobile/include/mach/r8a7779.h   |    7 -
 arch/arm/mach-shmobile/setup-r8a7779.c          |   57 -
 arch/arm/mach-shmobile/setup-r8a7790.c          |    7 +-
 arch/arm/mach-shmobile/setup-sh73a0.c           |   16 +-
 arch/arm/mach-sti/platsmp.c                     |    3 +-
 arch/arm/mach-tegra/Kconfig                     |    2 +
 arch/arm/mach-tegra/powergate.c                 |    8 +-
 arch/arm/mach-ux500/platsmp.c                   |    3 +-
 arch/arm/mach-zynq/common.c                     |   16 +-
 arch/arm/mach-zynq/common.h                     |    2 +
 arch/arm/mach-zynq/headsmp.S                    |    6 +-
 arch/arm/mach-zynq/platsmp.c                    |   25 +-
 arch/arm/plat-orion/common.c                    |    9 +-
 arch/arm/plat-orion/time.c                      |    3 +-
 arch/arm/plat-pxa/dma.c                         |    2 +-
 arch/arm/plat-samsung/Kconfig                   |    8 -
 arch/arm/plat-samsung/include/plat/pm.h         |    4 +-
 arch/arm/plat-samsung/pm.c                      |    6 +-
 arch/arm/plat-samsung/s5p-irq-pm.c              |    3 +
 arch/arm/plat-versatile/platsmp.c               |    3 +-
 drivers/clk/Makefile                            |    1 +
 drivers/clk/at91/Makefile                       |   11 +
 drivers/clk/at91/clk-main.c                     |  187 ++
 drivers/clk/at91/clk-master.c                   |  270 +++
 drivers/clk/at91/clk-peripheral.c               |  410 +++++
 drivers/clk/at91/clk-pll.c                      |  531 ++++++
 drivers/clk/at91/clk-plldiv.c                   |  135 ++
 drivers/clk/at91/clk-programmable.c             |  366 ++++
 drivers/clk/at91/clk-smd.c                      |  171 ++
 drivers/clk/at91/clk-system.c                   |  135 ++
 drivers/clk/at91/clk-usb.c                      |  398 +++++
 drivers/clk/at91/clk-utmi.c                     |  159 ++
 drivers/clk/at91/pmc.c                          |  395 ++++
 drivers/clk/at91/pmc.h                          |  114 ++
 drivers/clk/tegra/Makefile                      |    7 +-
 drivers/clk/tegra/clk-id.h                      |  235 +++
 drivers/clk/tegra/clk-periph-gate.c             |   30 +-
 drivers/clk/tegra/clk-periph.c                  |   72 +-
 drivers/clk/tegra/clk-pll.c                     |  407 ++++-
 drivers/clk/tegra/clk-tegra-audio.c             |  215 +++
 drivers/clk/tegra/clk-tegra-fixed.c             |  111 ++
 drivers/clk/tegra/clk-tegra-periph.c            |  674 +++++++
 drivers/clk/tegra/clk-tegra-pmc.c               |  132 ++
 drivers/clk/tegra/clk-tegra-super-gen4.c        |  149 ++
 drivers/clk/tegra/clk-tegra114.c                | 1688 ++++--------------
 drivers/clk/tegra/clk-tegra124.c                | 1424 +++++++++++++++
 drivers/clk/tegra/clk-tegra20.c                 |  817 ++++-----
 drivers/clk/tegra/clk-tegra30.c                 | 1504 +++++-----------
 drivers/clk/tegra/clk.c                         |  214 +++
 drivers/clk/tegra/clk.h                         |  116 +-
 drivers/cpufreq/exynos-cpufreq.h                |   22 +
 drivers/cpufreq/exynos4210-cpufreq.c            |    2 -
 drivers/cpufreq/exynos4x12-cpufreq.c            |    2 -
 drivers/cpufreq/exynos5250-cpufreq.c            |    1 -
 drivers/devfreq/exynos/exynos4_bus.c            |    4 +-
 drivers/devfreq/exynos/exynos4_bus.h            |  110 ++
 drivers/dma/Kconfig                             |    2 +
 drivers/dma/dmaengine.c                         |   28 +
 drivers/dma/mmp_pdma.c                          |   30 +-
 drivers/dma/tegra20-apb-dma.c                   |   52 +-
 drivers/gpu/drm/tegra/Kconfig                   |    1 +
 drivers/gpu/drm/tegra/dc.c                      |   10 +-
 drivers/gpu/drm/tegra/drm.h                     |    3 +
 drivers/gpu/drm/tegra/gr3d.c                    |   22 +-
 drivers/gpu/drm/tegra/hdmi.c                    |   15 +-
 drivers/i2c/busses/i2c-tegra.c                  |   13 +-
 drivers/input/keyboard/tegra-kbc.c              |   13 +-
 drivers/pci/host/pci-tegra.c                    |   53 +-
 drivers/spi/Kconfig                             |    3 +
 drivers/spi/spi-tegra114.c                      |   66 +-
 drivers/spi/spi-tegra20-sflash.c                |   18 +-
 drivers/spi/spi-tegra20-slink.c                 |   66 +-
 drivers/staging/nvec/nvec.c                     |   11 +-
 drivers/staging/nvec/nvec.h                     |    5 +-
 drivers/tty/serial/serial-tegra.c               |   38 +-
 drivers/tty/serial/sh-sci.c                     |  320 ++--
 drivers/tty/serial/sh-sci.h                     |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c             |    2 +-
 drivers/usb/host/ehci-tegra.c                   |   14 +-
 include/dt-bindings/clk/at91.h                  |   22 +
 include/dt-bindings/clock/tegra114-car.h        |    8 +-
 include/dt-bindings/clock/tegra124-car.h        |  341 ++++
 include/dt-bindings/clock/tegra20-car.h         |    2 +-
 include/dt-bindings/clock/tegra30-car.h         |   12 +-
 .../mach => include/linux/clk}/at91_pmc.h       |    4 +-
 include/linux/clk/tegra.h                       |    7 -
 include/linux/dmaengine.h                       |    1 +
 include/linux/serial_sci.h                      |   34 +-
 include/linux/tegra-powergate.h                 |    7 +-
 sound/soc/atmel/Kconfig                         |    2 +-
 sound/soc/tegra/Kconfig                         |    2 +
 sound/soc/tegra/tegra20_ac97.c                  |   11 -
 sound/soc/tegra/tegra20_i2s.c                   |   20 +-
 sound/soc/tegra/tegra30_ahub.c                  |  138 +-
 sound/soc/tegra/tegra30_ahub.h                  |   11 +-
 sound/soc/tegra/tegra30_i2s.c                   |   97 +-
 sound/soc/tegra/tegra30_i2s.h                   |    3 +
 sound/soc/tegra/tegra_pcm.c                     |   17 +-
 sound/soc/tegra/tegra_pcm.h                     |    5 +
 233 files changed, 11389 insertions(+), 5145 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/at91-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
 create mode 100644 arch/arm/boot/dts/at91-qil_a9260.dts
 delete mode 100644 arch/arm/mach-at91/board-qil-a9260.c
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-irq.h
 rename arch/arm/mach-exynos/{include/mach => }/regs-pmu.h (88%)
 create mode 100644 drivers/clk/at91/Makefile
 create mode 100644 drivers/clk/at91/clk-main.c
 create mode 100644 drivers/clk/at91/clk-master.c
 create mode 100644 drivers/clk/at91/clk-peripheral.c
 create mode 100644 drivers/clk/at91/clk-pll.c
 create mode 100644 drivers/clk/at91/clk-plldiv.c
 create mode 100644 drivers/clk/at91/clk-programmable.c
 create mode 100644 drivers/clk/at91/clk-smd.c
 create mode 100644 drivers/clk/at91/clk-system.c
 create mode 100644 drivers/clk/at91/clk-usb.c
 create mode 100644 drivers/clk/at91/clk-utmi.c
 create mode 100644 drivers/clk/at91/pmc.c
 create mode 100644 drivers/clk/at91/pmc.h
 create mode 100644 drivers/clk/tegra/clk-id.h
 create mode 100644 drivers/clk/tegra/clk-tegra-audio.c
 create mode 100644 drivers/clk/tegra/clk-tegra-fixed.c
 create mode 100644 drivers/clk/tegra/clk-tegra-periph.c
 create mode 100644 drivers/clk/tegra/clk-tegra-pmc.c
 create mode 100644 drivers/clk/tegra/clk-tegra-super-gen4.c
 create mode 100644 drivers/clk/tegra/clk-tegra124.c
 create mode 100644 drivers/devfreq/exynos/exynos4_bus.h
 create mode 100644 include/dt-bindings/clk/at91.h
 create mode 100644 include/dt-bindings/clock/tegra124-car.h
 rename {arch/arm/mach-at91/include/mach => include/linux/clk}/at91_pmc.h (98%)
