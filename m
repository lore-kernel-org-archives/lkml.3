Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbaAWStI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:49:08 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56259 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaAWSrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:47:18 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 3/6] ARM: SoC platform changes for 3.14
Date: Thu, 23 Jan 2014 10:36:25 -0800
Message-Id: <1390502188-16896-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1390502188-16896-1-git-send-email-olof@lixom.net>
References: <1390502188-16896-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New core SoC-specific changes.

New platforms:
* Introduction of a vendor, Hisilicon, and one of their SoCs with some
random numerical product name.
* Introduction of EFM32, embedded platform from Silicon Labs (ARMv7m, i.e. !MMU).
* Marvell Berlin series of SoCs, which include the one in Chromecast.
* MOXA platform support, ARM9-based platform used mostly in industrial products
* Support for Freescale's i.MX50 SoC.

Other work:
* Renesas work for new platforms and drivers, and conversion over to
more multiplatform-friendly device registration schemes.
* SMP support for Allwinner sunxi platforms.
* ... plus a bunch of other stuff across various platforms.


Conflicts:

arch/arm/mach-u300/timer.c:
Keep ticks_per_jiffy calculation and the sched_clock_register() call,
ditch setup_sched_clock().

----------------------------------------------------------------

The following changes since commit fa4409f1f575945e7dee3a52fb4842b215c7581d:

  Merge branch 'next/cleanup' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-linus

for you to fetch changes up to 6373bb71875b3f9f73f375952f92e68140b75657:

  Merge tag 'davinci-for-v3.14/soc' of git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci into next/soc

----------------------------------------------------------------

Alexander Shiyan (2):
      ARM: i.MX5x: Add SAHARA clock for i.MX5x CPUs
      ARM: imx: pllv1: Fix PLL calculation for i.MX27

Alexandre Courbot (1):
      ARM: tegra: switch FUSE clock on before usage

Anson Huang (4):
      ARM: imx: clk: correct arm clock usecount
      ARM: imx: add necessary interface for pfd
      ARM: imx: improve status check of clock gate
      ARM: imx: improve the comment of CCM lpm SW workaround

Baruch Siach (1):
      dt-bindings: fix example of allwinner interrupt controller

Ben Dooks (2):
      ARM: rcar-gen2: Do not setup timer in non-secure mode
      ARM: shmobile: Add select MIGHT_HAVE_PCI for PCI-AHB bridge code

Christian Daudt (1):
      rename ARCH_BCM to ARCH_BCM_MOBILE (clocksource)

Denis Carikli (3):
      ARM: imx_v4_v5_defconfig: Enable gpio regulator and gpio button/keyboard.
      ARM: imx_v6_v7_defconfig: Enable tsc2007 support.
      ARM i.MX25: build in pinctrl support.

Fabio Estevam (3):
      ARM: imx_v6_v7_defconfig: Select CONFIG_HIGHMEM
      ARM: imx_v6_v7_defconfig: Select MX35 and MX50 device tree support
      ARM: imx_v6_v7_defconfig: Select CONFIG_REGULATOR_PFUZE100

Greg Ungerer (4):
      ARM: imx: add debug uart support for IMX50 SoC
      ARM: imx: add clocking support code for the IMX50 SoC
      ARM: imx: allow configuration of the IMX50 SoC
      ARM: imx: add support code for IMX50 based machines

H Hartley Sweeten (1):
      ARM: ep93xx: use soc bus

Haojian Zhuang (8):
      ARM: hi3xxx: add board support with device tree
      ARM: dts: enable hi4511 with device tree
      ARM: config: enable hi3xxx in multi_v7_defconfig
      ARM: config: add defconfig for Hi3xxx
      ARM: dts: enable clock binding on Hi3620
      ARM: hisi: rename hi3xxx to hisi
      ARM: hisi: remove init_time
      ARM: dts: rename hi4511 dts file

Hiep Cao Minh (1):
      ARM: shmobile: r8a7790: add QSPI support

Jingchang Lu (1):
      ARM: imx: Add DMAMUX clock for Vybrid vf610 SoC

John Tobias (1):
      ARM: imx: Add cpu frequency scaling support

Jonas Jensen (1):
      ARM: moxart: add MOXA ART SoC platform files

Josh Wu (1):
      ARM: at91: sama5d3: add support for sama5d36 chip

Kevin Hilman (12):
      Merge branch 'soc/sched_clock' into next/soc
      ARM: hi3xxx: add smp support
      Merge branch 'berlin/soc' into next/soc
      Merge branch 'efm32/soc' into next/soc
      Merge branch 'keystone/soc' into next/soc
      Merge tag 'renesas-soc-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge branch 'hisi/soc' into next/soc
      Merge branch 'qcom/soc2' into next/soc
      Merge tag 'renesas-soc-fixes-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'sunxi-core-for-3.14-2' of https://github.com/mripard/linux into next/soc
      Merge tag 'versatile-for-v3.14' of git://git.kernel.org/.../linusw/linux-integrator into next/soc
      Merge tag 'davinci-for-v3.14/soc' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc

Kuninori Morimoto (19):
      ARM: shmobile: r8a7778: add I2C clock for DT
      ARM: shmobile: r8a7779: add I2C clock for DT
      ARM: shmobile: r8a73a4: don't use named irq for DMAEngine
      ARM: shmobile: r8a7778: add MMCIF clock support for DT
      ARM: shmobile: r8a7778: add SDHI clock support for DT
      ARM: shmobile: r8a7779: add SDHI clock support for DT
      ARM: shmobile: r8a7778: add HSPI clock support for DT
      ARM: shmobile: r8a7790: care EXTAL divider settings
      ARM: shmobile: r8a7790: fixup I2C clock source
      ARM: shmobile: r8a7790: tidyup clock table order
      ARM: shmobile: r8a7778: add HPBIFx DMAEngine support
      ARM: shmobile: r8a7790: add SSI MSTP clocks
      ARM: shmobile: r8a7740: add FSI clock support for DT
      ARM: shmobile: r8a7778: add SSIx DMAEngine support
      ARM: shmobile: r8a7790: add I2C support
      ARM: shmobile: sh73a0: add FSI clock support for DT
      ARM: shmobile: r8a7778: camera-rcar header cleanup
      ARM: shmobile: r8a7778: add USB Func DMAEngine support
      ARM: shmobile: r8a7778: add sound SCU clock support

Laurent Pinchart (32):
      ARM: shmobile: r8a7791: Add DU and LVDS clocks
      ARM: Rename ARCH_SHMOBILE to ARCH_SHMOBILE_LEGACY
      ARM: shmobile: r8a7790: Add clock index macros for DT sources
      ARM: shmobile: r8a7791: Add clock index macros for DT sources
      ARM: shmobile: rcar-gen2: Initialize CCF before clock sources
      ARM: shmobile: sh7372: Use macros to declare SCIF devices
      ARM: shmobile: sh73a0: Use macros to declare SCIF devices
      ARM: shmobile: r8a7740: Use macros to declare SCIF devices
      ARM: shmobile: r8a7779: Use macros to declare SCIF devices
      ARM: shmobile: r8a73a4: Don't define SCIF platform data in an array
      ARM: shmobile: r7s72100: Don't define SCIF platform data in an array
      ARM: shmobile: r8a7778: Don't define SCIF platform data in an array
      ARM: shmobile: r8a7791: Don't define SCIF platform data in an array
      ARM: shmobile: r8a7790: Don't define SCIF platform data in an array
      ARM: shmobile: sh7372: Declare SCIF register base and IRQ as resources
      ARM: shmobile: sh73a0: Declare SCIF register base and IRQ as resources
      ARM: shmobile: r7s72100: Declare SCIF register base and IRQ as resources
      ARM: shmobile: r8a73a4: Declare SCIF register base and IRQ as resources
      ARM: shmobile: r8a7740: Declare SCIF register base and IRQ as resources
      ARM: shmobile: r8a7779: Declare SCIF register base and IRQ as resources
      ARM: shmobile: sh7372: Don't set plat_sci_port scbrr_algo_id field
      ARM: shmobile: r8a7778: Declare SCIF register base and IRQ as resources
      ARM: shmobile: r8a7791: Declare SCIF register base and IRQ as resources
      ARM: shmobile: r8a7790: Declare SCIF register base and IRQ as resources
      ARM: shmobile: sh73a0: Don't set plat_sci_port scbrr_algo_id field
      ARM: shmobile: r7s72100: Don't set plat_sci_port scbrr_algo_id field
      ARM: shmobile: r8a7778: Don't set plat_sci_port scbrr_algo_id field
      ARM: shmobile: r8a73a4: Don't set plat_sci_port scbrr_algo_id field
      ARM: shmobile: r8a7740: Don't set plat_sci_port scbrr_algo_id field
      ARM: shmobile: r8a7790: Don't set plat_sci_port scbrr_algo_id field
      ARM: shmobile: r8a7779: Don't set plat_sci_port scbrr_algo_id field
      ARM: shmobile: r8a7791: Don't set plat_sci_port scbrr_algo_id field

Laxman Dewangan (1):
      ARM: tegra: select PINCTRL_TEGRA124 for Tegra124 SoC

Linus Walleij (5):
      ARM: versatile: move GPIO2 and GPIO3 to core
      ARM: versatile: update defconfig
      ARM: versatile: enable GPIOLIB and PL061 by default
      ARM: versatile: build using EABI
      ARM: versatile: enable LEDs by default

Lothar Waßmann (1):
      ARM i.MX5: fix obvious typo in ldb_di0_gate clk definition

Lucas Stach (1):
      ARM: imx5: introduce DT includes for clock provider

Magnus Damm (14):
      ARM: shmobile: Select IRQC in case of the r8a7791 SoC
      ARM: shmobile: r8a7791 PFC platform device support
      ARM: shmobile: Select GPIO in case of the r8a7791 SoC
      ARM: shmobile: r8a7791 GPIO platform device support
      ARM: shmobile: Select GPIO in case of the r7s72100 SoC
      ARM: shmobile: Enable MTU2 on r7s72100
      ARM: shmobile: Add shared EMEV2 code for ->init_machine()
      ARM: shmobile: Use ->init_late() in shared EMEV2 case
      ARM: shmobile: Remove legacy KZM9D board code
      ARM: shmobile: Remove legacy platform devices from EMEV2 SoC code
      ARM: shmobile: Select USE_OF on EMEV2
      ARM: shmobile: Add r8a7790 clocks for thermal devices
      ARM: shmobile: Add r8a7791 thermal platform device
      ARM: shmobile: Add r8a7791 clocks for thermal devices

Marc Kleine-Budde (2):
      ARM i.MX5: fix "shift" value for lp_apm_sel on i.MX50 and i.MX53
      ARM i.MX5: set CAN peripheral clock to 24 MHz parent

Marek Vasut (2):
      ARM: imx_v6_v7_defconfig: Enable STMPE touchscreen
      ARM: imx: imx53: Add SATA PHY clock

Markus Pargmann (1):
      ARM: imx27: enable pinctrl

Mateusz Krawczuk (1):
      ARM: SAMSUNG: if detected device tree skip irq init for S5P

Maxime Ripard (7):
      reset: Add Allwinner SoCs Reset Controller Driver
      Merge branch 'sunxi/drivers-for-3.14' into sunxi/core-for-3.14
      ARM: sunxi: Select ARCH_HAS_RESET_CONTROLLER
      ARM: sunxi: Register the A31 reset IP in init_time
      ARM: sun6i: Add SMP support for the Allwinner A31
      ARM: sunxi: Select RESET_CONTROLLER
      MAINTAINERS: Update Allwinner sunXi maintainer files

Michael Opdenacker (1):
      ARM: ep93xx: remove deprecated IRQF_DISABLED

Nicolin Chen (3):
      ARM: imx6: Derive spdif clock from pll3_pfd3_454m
      ARM: imx6sl: Add missing pll4_audio_div to the clock tree
      ARM: imx6sl: Add missing spba clock to clock tree

Olof Johansson (12):
      Merge tag 'samsung-dev' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge branch 'tegra/dma-reset-rework' into next/soc
      Merge tag 'tegra-for-3.14-powergate' of git://git.kernel.org/.../tegra/linux into next/soc
      Merge tag 'tegra-for-3.14-soc' of git://git.kernel.org/.../tegra/linux into next/soc
      Merge tag 'renesas-soc2-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge branch 'qcom/soc' into next/soc
      Merge tag 'renesas-soc3-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'imx-soc-3.14' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      ARM: ux500: turn on PRINTK_TIME in u8500_defconfig
      Merge tag 'bcm-for-3.14-soc' of git://github.com/broadcom/bcm11351 into next/soc
      Merge tag 'ux500-core-v3.14' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc
      Merge branch 'qcom/soc2' into next/soc

Paul Walmsley (1):
      ARM: davinci: clock: return 0 upon error from clk_round_rate()

Rohit Vaswani (1):
      ARM: msm: Add support for MSM8974 SoC

Russell King (1):
      ARM: imx: update imx_v6_v7_defconfig

Santosh Shilimkar (3):
      ARM: keystone: enable DMA zone for LPAE
      ARM: keystone: Make PM bus ready before populating platform devices
      ARM: keystone: Avoid calling of_clk_init() twice

Sebastian Hesselbarth (8):
      irqchip: add DesignWare APB ICTL interrupt controller
      MAINTAINERS: add ARM Marvell Berlin SoC
      ARM: add Marvell Berlin SoC familiy to Marvell doc
      ARM: add Marvell Berlin SoCs to multi_v7_defconfig
      ARM: add Marvell Berlin UART0 lowlevel debug
      ARM: add Armada 1500 and Sony NSZ-GS7 device tree files
      ARM: add Armada 1500-mini and Chromecast device tree files
      ARM: add initial support for Marvell Berlin SoCs

Sergei Shtylyov (1):
      ARM: shmobile: r8a7791: add Ether clock

Shawn Guo (4):
      ARM: imx: remove mxc_iomux_v3_init() call from imx53_init_early()
      ARM: imx: select PINCTRL at sub-architecure level
      ARM: imx: rename IMX6SL_CLK_CLK_END to IMX6SL_CLK_END
      ARM: imx: use __initconst for const init definition

Simon Horman (4):
      ARM: shmobile: Select AUTO_ZRELADDR for EMEV2
      ARM: shmobile: r8a7779: add HSPI clock support for DT
      ARM: shmobile: koelsch: Conditionally select MICREL_PHY
      Merge branch 'sh-sci' into soc3-base

Steffen Trumtrar (1):
      ARM i.MX35: Add devicetree support.

Stephen Boyd (22):
      ARM: timer-sp: Switch to sched_clock_register()
      ARM: clps711x: Switch to sched_clock_register()
      ARM: davinci: Switch to sched_clock_register()
      ARM: imx: Switch to sched_clock_register()
      ARM: integrator: Switch to sched_clock_register()
      ARM: IXP4xx: Switch to sched_clock_register()
      ARM: mmp: Switch to sched_clock_register()
      ARM: msm: Switch to sched_clock_register()
      ARM: OMAP1: Switch to sched_clock_register()
      ARM: OMAP2+: Switch to sched_clock_register()
      ARM: pxa: Switch to sched_clock_register()
      ARM: sa1100: Switch to sched_clock_register()
      ARM: u300: Switch to sched_clock_register()
      ARM: iop: Switch to sched_clock_register()
      ARM: OMAP: Switch to sched_clock_register()
      ARM: orion: Switch to sched_clock_register()
      ARM: versatile: Switch to sched_clock_register()
      ARM: msm: Simplify ARCH_MSM_DT config
      ARM: msm: Only build clock.c on proc_comm based platforms
      ARM: msm: Only build timer.c if required
      ARM: msm: Move MSM's DT based hardware to multi-platform support
      ARM: msm_defconfig: Update for multi-platform

Stephen Warren (4):
      ARM: tegra: fix DEBUG_LL combined with LPAE
      ARM: tegra: don't hard-code DEBUG_LL baud rate
      ARM: tegra: use section-sized static mappings for LPAE too
      ARM: tegra: fix tegra_powergate_sequence_power_up() inline

Taras Kondratiuk (1):
      ARM: keystone: enable big endian support

Thierry Reding (7):
      ARM: tegra: Fix some whitespace oddities
      ARM: tegra: Rename cpu0 powergate to crail
      ARM: tegra: Export tegra_powergate_power_off()
      ARM: tegra: Export tegra_powergate_remove_clamping()
      ARM: tegra: Add Tegra124 powergate support
      ARM: tegra: Special-case the 3D clamps on Tegra124
      ARM: tegra: Add IO rail support

Tim Harvey (1):
      ARM: imx: add PCI fixup for PEX860X on Gateworks board

Tim Kryger (3):
      ARM: bcm_defconfig: CONFIG_OABI_COMPAT default off
      ARM: bcm_defconfig: Do not expect appended DTB
      ARM: bcm_defconfig: Unset CONFIG_CRYPTO_ANSI_CPRNG

Tomasz Figa (1):
      ARM: S3C64XX: Select CPU_V6K instead of CPU_V6

Ulf Hansson (1):
      ARM: ux500: Enable system suspend with WFI support

Uwe Kleine-König (4):
      ARM: imx: drop support for irq priorisation
      ARM: new platform for Energy Micro's EFM32 Cortex-M3 SoCs
      ARM: device trees for Energy Micro's EFM32 Cortex-M3 SoCs
      MAINTAINERS: take maintainership for Energy Micro efm32 SoCs

Valentine Barshak (2):
      ARM: shmobile: r8a7790: Add USBHS clock support
      ARM: shmobile: r8a7790: Fix I2C controller names

Wei Yongjun (1):
      ARM i.MX53: remove duplicated include from clk-imx51-imx53.c

WingMan Kwok (1):
      ARM: keystone: defconfig: enable USB support

Wolfram Sang (2):
      arm: shmobile: clks: remove duplicated clock from r7s72100
      arm: shmobile: r7s72100: add i2c clocks

Zalan Blenessy (1):
      ARM: sunxi: select ARM_PSCI

Zhangfei Gao (1):
      ARM: hi3xxx: add hotplug support


 Documentation/arm/Marvell/README                |  24 +
 .../bindings/arm/hisilicon/hisilicon.txt        |  32 +
 .../devicetree/bindings/arm/marvell,berlin.txt  |  24 +
 .../devicetree/bindings/clock/imx35-clock.txt   | 113 +++
 .../devicetree/bindings/clock/imx5-clock.txt    | 195 +----
 .../interrupt-controller/allwinner,sun4i-ic.txt |   2 +-
 .../interrupt-controller/snps,dw-apb-ictl.txt   |  32 +
 MAINTAINERS                                     |  19 +-
 arch/arm/Kconfig                                |  48 +-
 arch/arm/Kconfig.debug                          |  19 +
 arch/arm/Makefile                               |   5 +-
 arch/arm/boot/compressed/Makefile               |   2 +-
 arch/arm/boot/dts/Makefile                      |   7 +-
 arch/arm/boot/dts/armv7-m.dtsi                  |  18 +
 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts      |  29 +
 arch/arm/boot/dts/berlin2.dtsi                  | 227 ++++++
 .../boot/dts/berlin2cd-google-chromecast.dts    |  29 +
 arch/arm/boot/dts/berlin2cd.dtsi                | 210 +++++
 arch/arm/boot/dts/efm32gg-dk3750.dts            |  86 ++
 arch/arm/boot/dts/efm32gg.dtsi                  | 172 ++++
 arch/arm/boot/dts/hi3620-hi4511.dts             | 649 +++++++++++++++
 arch/arm/boot/dts/hi3620.dtsi                   | 565 +++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi             |  33 +
 arch/arm/common/timer-sp.c                      |   4 +-
 arch/arm/configs/ape6evm_defconfig              |   2 +-
 arch/arm/configs/armadillo800eva_defconfig      |   2 +-
 arch/arm/configs/bcm_defconfig                  |   3 +-
 arch/arm/configs/bockw_defconfig                |   2 +-
 arch/arm/configs/efm32_defconfig                | 102 +++
 arch/arm/configs/hi3xxx_defconfig               |  56 ++
 arch/arm/configs/imx_v4_v5_defconfig            |   2 +
 arch/arm/configs/imx_v6_v7_defconfig            |  13 +-
 arch/arm/configs/keystone_defconfig             |  20 +-
 arch/arm/configs/koelsch_defconfig              |   2 +-
 arch/arm/configs/kzm9d_defconfig                |   2 +-
 arch/arm/configs/kzm9g_defconfig                |   2 +-
 arch/arm/configs/lager_defconfig                |   2 +-
 arch/arm/configs/mackerel_defconfig             |   2 +-
 arch/arm/configs/marzen_defconfig               |   2 +-
 arch/arm/configs/moxart_defconfig               | 149 ++++
 arch/arm/configs/msm_defconfig                  |  11 +-
 arch/arm/configs/multi_v7_defconfig             |   4 +
 arch/arm/configs/u8500_defconfig                |   1 +
 arch/arm/configs/versatile_defconfig            |  26 +-
 arch/arm/include/debug/imx-uart.h               |  10 +
 arch/arm/include/debug/tegra.S                  |  34 +-
 arch/arm/mach-at91/Kconfig                      |   2 +-
 arch/arm/mach-at91/include/mach/cpu.h           |   3 +-
 arch/arm/mach-at91/setup.c                      |   4 +
 arch/arm/mach-berlin/Kconfig                    |  29 +
 arch/arm/mach-berlin/Makefile                   |   1 +
 arch/arm/mach-berlin/berlin.c                   |  39 +
 arch/arm/mach-clps711x/common.c                 |   4 +-
 arch/arm/mach-davinci/clock.c                   |   2 +-
 arch/arm/mach-davinci/time.c                    |   4 +-
 arch/arm/mach-efm32/Makefile                    |   1 +
 arch/arm/mach-efm32/Makefile.boot               |   3 +
 arch/arm/mach-efm32/dtmachine.c                 |  15 +
 arch/arm/mach-efm32/include/mach/entry-macro.S  |   4 +
 arch/arm/mach-efm32/include/mach/timex.h        |   3 +
 arch/arm/mach-ep93xx/Kconfig                    |   1 +
 arch/arm/mach-ep93xx/core.c                     | 110 ++-
 arch/arm/mach-ep93xx/include/mach/platform.h    |   3 +-
 arch/arm/mach-hisi/Kconfig                      |  17 +
 arch/arm/mach-hisi/Makefile                     |   7 +
 arch/arm/mach-hisi/core.h                       |  15 +
 arch/arm/mach-hisi/hisilicon.c                  |  90 +++
 arch/arm/mach-hisi/hotplug.c                    | 200 +++++
 arch/arm/mach-hisi/platsmp.c                    |  89 ++
 arch/arm/mach-imx/Kconfig                       |  35 +-
 arch/arm/mach-imx/Makefile                      |   2 +
 arch/arm/mach-imx/avic.c                        |  25 -
 arch/arm/mach-imx/clk-gate2.c                   |   2 +-
 arch/arm/mach-imx/clk-imx35.c                   |  14 +
 arch/arm/mach-imx/clk-imx51-imx53.c             | 804 ++++++++++---------
 arch/arm/mach-imx/clk-imx6q.c                   |   5 +-
 arch/arm/mach-imx/clk-imx6sl.c                  |  11 +-
 arch/arm/mach-imx/clk-pfd.c                     |  11 +
 arch/arm/mach-imx/clk-pllv1.c                   |  23 +-
 arch/arm/mach-imx/clk-vf610.c                   |   5 +
 arch/arm/mach-imx/common.h                      |   1 +
 arch/arm/mach-imx/imx31-dt.c                    |   2 +-
 arch/arm/mach-imx/imx35-dt.c                    |  50 ++
 arch/arm/mach-imx/imx51-dt.c                    |   2 +-
 arch/arm/mach-imx/irq-common.h                  |   1 -
 arch/arm/mach-imx/mach-imx50.c                  |  38 +
 arch/arm/mach-imx/mach-imx53.c                  |   2 +-
 arch/arm/mach-imx/mach-imx6q.c                  |  32 +-
 arch/arm/mach-imx/mach-imx6sl.c                 |  10 +-
 arch/arm/mach-imx/mach-vf610.c                  |   2 +-
 arch/arm/mach-imx/mm-imx5.c                     |   8 -
 arch/arm/mach-imx/pm-imx6q.c                    |  16 +-
 arch/arm/mach-imx/time.c                        |   4 +-
 arch/arm/mach-integrator/integrator_ap.c        |   4 +-
 arch/arm/mach-ixp4xx/common.c                   |   4 +-
 arch/arm/mach-keystone/Kconfig                  |   2 +
 arch/arm/mach-keystone/keystone.c               |   4 +
 arch/arm/mach-keystone/keystone.h               |   1 +
 arch/arm/mach-keystone/pm_domain.c              |   2 -
 arch/arm/mach-mmp/time.c                        |   4 +-
 arch/arm/mach-moxart/Kconfig                    |  31 +
 arch/arm/mach-moxart/Makefile                   |   3 +
 arch/arm/mach-moxart/moxart.c                   |  15 +
 arch/arm/mach-msm/Kconfig                       |  74 +-
 arch/arm/mach-msm/Makefile                      |   4 +-
 arch/arm/mach-msm/timer.c                       |   4 +-
 arch/arm/mach-omap1/time.c                      |   4 +-
 arch/arm/mach-omap2/timer.c                     |   4 +-
 arch/arm/mach-pxa/time.c                        |   4 +-
 arch/arm/mach-sa1100/time.c                     |   4 +-
 arch/arm/mach-shmobile/Kconfig                  |  24 +-
 arch/arm/mach-shmobile/Makefile                 |   1 -
 arch/arm/mach-shmobile/Makefile.boot            |   1 -
 arch/arm/mach-shmobile/board-bockw.c            |   1 +
 arch/arm/mach-shmobile/board-kzm9d.c            |  92 ---
 arch/arm/mach-shmobile/clock-r7s72100.c         |   8 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |   1 +
 arch/arm/mach-shmobile/clock-r8a7778.c          |  31 +
 arch/arm/mach-shmobile/clock-r8a7779.c          |  11 +
 arch/arm/mach-shmobile/clock-r8a7790.c          |  62 +-
 arch/arm/mach-shmobile/clock-r8a7791.c          |  17 +-
 arch/arm/mach-shmobile/clock-sh73a0.c           |   1 +
 arch/arm/mach-shmobile/include/mach/emev2.h     |   5 -
 arch/arm/mach-shmobile/include/mach/r8a7778.h   |  39 +-
 arch/arm/mach-shmobile/include/mach/r8a7791.h   |   1 +
 arch/arm/mach-shmobile/setup-emev2.c            | 163 +---
 arch/arm/mach-shmobile/setup-r7s72100.c         |  82 +-
 arch/arm/mach-shmobile/setup-r8a73a4.c          |  68 +-
 arch/arm/mach-shmobile/setup-r8a7740.c          | 195 +----
 arch/arm/mach-shmobile/setup-r8a7778.c          | 166 +++-
 arch/arm/mach-shmobile/setup-r8a7779.c          | 128 +--
 arch/arm/mach-shmobile/setup-r8a7790.c          | 141 ++--
 arch/arm/mach-shmobile/setup-r8a7791.c          | 188 +++--
 arch/arm/mach-shmobile/setup-rcar-gen2.c        |  29 +-
 arch/arm/mach-shmobile/setup-sh7372.c           | 160 +---
 arch/arm/mach-shmobile/setup-sh73a0.c           | 191 +----
 arch/arm/mach-sunxi/Kconfig                     |   3 +
 arch/arm/mach-sunxi/Makefile                    |   1 +
 arch/arm/mach-sunxi/common.h                    |  19 +
 arch/arm/mach-sunxi/headsmp.S                   |   9 +
 arch/arm/mach-sunxi/platsmp.c                   | 124 +++
 arch/arm/mach-sunxi/sunxi.c                     |  14 +
 arch/arm/mach-tegra/Kconfig                     |   1 +
 arch/arm/mach-tegra/fuse.c                      |  41 +-
 arch/arm/mach-tegra/iomap.h                     |  14 +-
 arch/arm/mach-tegra/powergate.c                 | 195 ++++-
 arch/arm/mach-tegra/tegra.c                     |   4 +-
 arch/arm/mach-u300/timer.c                      |   4 +-
 arch/arm/mach-ux500/pm.c                        |  27 +
 arch/arm/mach-versatile/core.c                  |  16 +
 arch/arm/mach-versatile/versatile_pb.c          |  21 -
 arch/arm/plat-iop/time.c                        |   4 +-
 arch/arm/plat-omap/counter_32k.c                |   4 +-
 arch/arm/plat-orion/time.c                      |   4 +-
 arch/arm/plat-samsung/s5p-irq-eint.c            |   4 +
 arch/arm/plat-versatile/sched-clock.c           |   4 +-
 drivers/Makefile                                |   2 +-
 drivers/clocksource/Makefile                    |   2 +-
 drivers/irqchip/Kconfig                         |   4 +
 drivers/irqchip/Makefile                        |   1 +
 drivers/irqchip/irq-dw-apb-ictl.c               | 150 ++++
 drivers/reset/Makefile                          |   1 +
 drivers/reset/reset-sunxi.c                     | 175 ++++
 include/dt-bindings/clock/imx5-clock.h          | 203 +++++
 include/dt-bindings/clock/imx6sl-clock.h        |   4 +-
 include/dt-bindings/clock/r8a7790-clock.h       | 100 +++
 include/dt-bindings/clock/r8a7791-clock.h       | 105 +++
 include/dt-bindings/clock/vf610-clock.h         |   6 +-
 include/linux/tegra-powergate.h                 |  50 +-
 169 files changed, 6147 insertions(+), 1887 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/hisilicon/hisilicon.txt
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,berlin.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx35-clock.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
 create mode 100644 arch/arm/boot/dts/armv7-m.dtsi
 create mode 100644 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts
 create mode 100644 arch/arm/boot/dts/berlin2.dtsi
 create mode 100644 arch/arm/boot/dts/berlin2cd-google-chromecast.dts
 create mode 100644 arch/arm/boot/dts/berlin2cd.dtsi
 create mode 100644 arch/arm/boot/dts/efm32gg-dk3750.dts
 create mode 100644 arch/arm/boot/dts/efm32gg.dtsi
 create mode 100644 arch/arm/boot/dts/hi3620-hi4511.dts
 create mode 100644 arch/arm/boot/dts/hi3620.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-msm8974.dtsi
 create mode 100644 arch/arm/configs/efm32_defconfig
 create mode 100644 arch/arm/configs/hi3xxx_defconfig
 create mode 100644 arch/arm/configs/moxart_defconfig
 create mode 100644 arch/arm/mach-berlin/Kconfig
 create mode 100644 arch/arm/mach-berlin/Makefile
 create mode 100644 arch/arm/mach-berlin/berlin.c
 create mode 100644 arch/arm/mach-efm32/Makefile
 create mode 100644 arch/arm/mach-efm32/Makefile.boot
 create mode 100644 arch/arm/mach-efm32/dtmachine.c
 create mode 100644 arch/arm/mach-efm32/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-efm32/include/mach/timex.h
 create mode 100644 arch/arm/mach-hisi/Kconfig
 create mode 100644 arch/arm/mach-hisi/Makefile
 create mode 100644 arch/arm/mach-hisi/core.h
 create mode 100644 arch/arm/mach-hisi/hisilicon.c
 create mode 100644 arch/arm/mach-hisi/hotplug.c
 create mode 100644 arch/arm/mach-hisi/platsmp.c
 create mode 100644 arch/arm/mach-imx/imx35-dt.c
 create mode 100644 arch/arm/mach-imx/mach-imx50.c
 create mode 100644 arch/arm/mach-moxart/Kconfig
 create mode 100644 arch/arm/mach-moxart/Makefile
 create mode 100644 arch/arm/mach-moxart/moxart.c
 delete mode 100644 arch/arm/mach-shmobile/board-kzm9d.c
 create mode 100644 arch/arm/mach-sunxi/common.h
 create mode 100644 arch/arm/mach-sunxi/headsmp.S
 create mode 100644 arch/arm/mach-sunxi/platsmp.c
 create mode 100644 drivers/irqchip/irq-dw-apb-ictl.c
 create mode 100644 drivers/reset/reset-sunxi.c
 create mode 100644 include/dt-bindings/clock/imx5-clock.h
 create mode 100644 include/dt-bindings/clock/r8a7790-clock.h
 create mode 100644 include/dt-bindings/clock/r8a7791-clock.h
