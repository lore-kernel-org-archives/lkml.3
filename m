Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3IFTNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:13:52 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33651 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3IFTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:13:03 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/5] ARM: SoC platform changes for 3.12
Date: Fri,  6 Sep 2013 12:10:04 -0700
Message-Id: <1378494605-14990-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1378494605-14990-1-git-send-email-olof@lixom.net>
References: <1378494605-14990-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains mostly additions and changes to platform enablement
and SoC-level drivers. Since there's sometimes a dependency on device-tree
changes, there's also a fair amount of those in this branch.

Pieces worth mentioning are:

- Mbus driver for Marvell platforms, allowing kernel configuration
and resource allocation of on-chip peripherals.
- Enablement of the mbus infrastructure from Marvell PCI-e drivers.
- Preparation of MSI support for Marvell platforms.
- Addition of new PCI-e host controller driver for Tegra platforms
- Some churn caused by sharing of macro names between i.MX 6Q and 6DL
platforms in the device tree sources and header files.
- Various suspend/PM updates for Tegra, including LP1 support.
- Versatile Express support for MCPM, part of big little support.
- Allwinner platform support for A20 and A31 SoCs (dual and quad Cortex-A7)
- OMAP2+ support for DRA7, a new Cortex-A15-based SoC.


Conflicts:

- Add/add conflicts with mvebu SMP cleanups and PCI host controller
  additions. Keep both sides from both conflicts.

----------------------------------------------------------------

The following changes since commit 3e881584d044648ebe1d2236ee99f1994fb99f8e:

  Merge tag 'dt-for-linus' into test-merge

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-linus

for you to fetch changes up to f97c43bbdf8a1ea42477b1a804a48e7e368cb13c:

  tegra-cpuidle: provide stub when !CONFIG_CPU_IDLE

----------------------------------------------------------------

Alexander Shiyan (30):
      drivers: bus: imx-weim: Remove private driver data
      drivers: bus: imx-weim: Simplify error path
      drivers: bus: imx-weim: use module_platform_driver_probe()
      drivers: bus: imx-weim: Add missing platform_driver.owner field
      drivers: bus: imx-weim: Add support for i.MX1/21/25/27/31/35/50/51/53
      ARM: dts: imx27: Add SAHARA2 devicetree node
      ARM: dts: imx27: Add AUDMUX devicetree node
      ARM: dts: imx27: Rename PWM devicetree node
      ARM: dts: imx27: Sort entries by address
      ARM: dts: imx27-phytec-phycore-som: Define minimal memory layout
      ARM: dts: imx27: Add kpp devicetree node
      ARM: dts: i.MX27: Move IIM node under AIPI2 bus
      ARM: dts: i.MX27: Add WEIM node
      ARM: dts: imx27-phytec-phycore-som: Add WEIM node
      ARM: dts: imx27-phytec-phycore-som: Add SRAM node
      ARM: dts: imx27-phytec-phycore-rdk: Add CAN node
      ARM: dts: imx27-phytec-phycore-som: Using labels for reusing UART, I2C and FEC
      ARM: dts: i.MX51: Add WEIM node
      ARM: dts: imx27: Add core voltages
      ARM: dts: i.MX27: Using "wdog_ipg_gate" clock source for watchdog
      ARM: dts: i.MX27: Remove optional "ptp" clock source for FEC
      ARM: dts: i.MX27: Add label to CPU node
      ARM: dts: i.MX27: Increase "clock-latency" value
      ARM: dts: i.MX27: Remove clock name from CPU node
      ARM: dts: imx27-phytec-phycore-som: Fix regulator settings
      ARM: i.MX5 clocks: Remove optional clock setup (CKIH1) from i.MX51 template
      ARM: dts: i.MX27: Disable AUDMUX in the template
      ARM: dts: imx27-phytec-phycore-som: Enable AUDMUX
      ARM: dts: i.MX51: Move pins configuration under "iomuxc" label
      ARM: dts: i.MX51: Add one more I2C2 pinmux entry

Alexandre Belloni (1):
      ARM: mxs: Simplify detection of CrystalFontz boards

Andrew Lunn (1):
      ARM: Kirkwood: Add support for another ZyXEL NSA310 variant

Arnaud Ebalard (2):
      arm: kirkwood: readynas duo v2: Add GMT G762 Fan Controller
      ARM: mvebu: Add Netgear ReadyNAS 102 board

Barry Song (1):
      ARM: prima2: pm: drop redundant postcore_initcall

Dinh Nguyen (1):
      phy: micrel: Add definitions for common Micrel PHY registers

Ezequiel Garcia (23):
      memory: mvebu-devbus: Remove address decoding window workaround
      bus: mvebu-mbus: Factor out initialization details
      bus: mvebu-mbus: Introduce device tree binding
      bus: mvebu-mbus: Add static window allocation to the DT binding
      bus: mvebu-mbus: Add new API for the PCIe memory and IO aperture
      PCI: mvebu: Check valid base address before port setup
      ARM: mvebu: Remove the harcoded BootROM window allocation
      ARM: mvebu: Initialize MBus using the DT binding
      ARM: mvebu: Use the preprocessor on Armada 370/XP device tree files
      ARM: mvebu: Add MBus to Armada 370/XP device tree
      ARM: mvebu: Add BootROM to Armada 370/XP device tree
      ARM: mvebu: Relocate Armada 370/XP DeviceBus device tree nodes
      ARM: mvebu: Relocate Armada 370/XP PCIe device tree nodes
      ARM: kirkwood: Split DT and legacy MBus initialization
      ARM: kirkwood: Use the preprocessor on device tree files
      ARM: kirkwood: Introduce MBus DT node
      ARM: kirkwood: Introduce MBUS_ID
      ARM: kirkwood: Relocate PCIe device tree nodes
      bus: mvebu-mbus: Add devicetree binding
      ARM: mvebu: Fix AXP-WiFi-AP DT for MBUS DT binding
      ARM: mvebu: Relocate PCIe node in Armada 370 RD board
      memory: mvebu-devbus: Remove unused variable
      ARM: mvebu: Fix the Armada 370/XP timer compatible strings

Fabio Baltieri (2):
      ARM: ux500: add restart support via prcmu
      ARM: ux500: set coherent_dma_mask for dma40

Fabio Estevam (30):
      ARM: imx_v6_v7_defconfig: Select CONFIG_NOP_USB_XCEIV by default
      ARM: imx_v6_v7_defconfig: Enable FSL_LPUART support
      ARM: imx_v6_v7_defconfig: Enable LVDS Display Bridge
      ARM: imx_v6_v7_defconfig: Enable VPU driver
      ARM: imx_v4_v5_defconfig: Select CONFIG_MACH_IMX25_DT
      ARM: imx: Select MIGHT_HAVE_CACHE_L2X0
      ARM: mxs_defconfig: Cleanup mxs_defconfig
      ARM: mach-mxs: Remove "TO" string from revision field
      ARM: mxs: pm: Include "pm.h"
      ARM: imx_v6_v7_defconfig: Select CONFIG_TOUCHSCREEN_EGALAX
      ARM: mach-imx: Select ARM_CPU_SUSPEND at ARCH_MXC level
      ARM: mx53: Allow suspend/resume
      ARM: imx_v6_v7_defconfig: Cleanup imx_v6_v7_defconfig
      ARM: imx_v6_v7_defconfig: Add SATA support
      ARM: imx_v4_v5_defconfig: Cleanup imx_v4_v5_defconfig
      ARM: imx_v6_v7_defconfig: Enable wireless support
      ARM: imx: Re-select CONFIG_SND_SOC_IMX_MC13783 option
      ARM: imx27: Use 'AITC' for the interrupt controller name
      ARM: dts: mx53qsb: Enable VPU support
      ARM: dts: imx6dl-wandboard: Add audio support
      ARM: dts: imx: Add the missing cpus node
      ARM: dts: imx6qdl.dtsi: Add usdhc1 pin groups
      ARM: dts: imx6qdl.dtsi: Add another uart3 pin group
      ARM: dts: imx6dl-wandboard: Add SDHC1 and SDHC2 ports
      ARM: dts: imx6dl-wandboard: Add support for UART3
      ARM: dts: imx6: Add support for imx6q wandboard
      ARM: dts: imx6q-wandboard: Add sata support
      ARM: dts: imx6qdl-sabresd: Allow buttons to wake-up the system
      ARM: dts: imx6qdl-sabresd: Add touchscreen support
      ARM: dts: imx53-qsb: Make USBH1 functional

Guennadi Liakhovetski (6):
      ARM: shmobile: r8a73a4: wait for completion when kicking the clock
      ARM: shmobile: r8a73a4: implement CPU clock scaling for CPUFreq
      ARM: shmobile: r8a73a4: safeguard against wrong clk_set_rate() uses
      ARM: shmobile: r8a73a4: add Z2 clock support
      ARM: shmobile: r8a73a4: add clocks for I2C controllers
      ARM: shmobile: r8a7740: add MMCIF DMA definitions

Hebbar Gururaja (1):
      ARM: davinci: da8xx: remove hard coding of rtc device wakeup

Huang Shijie (11):
      ARM: imx_v6_v7_defconfig: enable WEIM driver
      ARM: dts: imx6dl: add a new pinctrl for ecspi1
      ARM: dts: imx6q: add a new pinctrl for ecspi1
      ARM: dts: imx6qdl-sabresd: enable the SPI NOR
      ARM: dts: imx: add #dma-cells property for sdma
      ARM: dts: imx6sl: add "fsl,imx6q-uart" for uart compatible
      ARM: dts: imx6q{dl}: add DTE pads for uart
      ARM: dts: imx6q{dl}: add a DTE uart pinctrl for uart2
      ARM: dts: enable the uart2 for imx6q-arm2
      ARM: dts: imx6qdl: add a new pinctrl for uart3
      ARM: dts: imx6qdl/imx6sl: add the dma property for uart

Jason Cooper (3):
      ARM: mvebu: use dts pre-processor for mv78230
      ARM: kirkwood: use dts pre-processor for nsa310 boards
      ARM: mvebu: use dts pre-processor for readynas 102

Jay Agarwal (1):
      PCI: tegra: Add Tegra 30 PCIe support

Jingchang Lu (1):
      ARM: dts: vf610-twr: enable i2c0 device

Joseph Lo (21):
      ARM: tegra: enable Cortex-A15 erratum 798181
      Revert "ARM: tegra: add cpu_disable for hotplug"
      ARM: tegra114: Reprogram GIC CPU interface to bypass IRQ on CPU PM entry
      ARM: tegra114: add low level support for CPU idle powered-down mode
      ARM: tegra114: cpuidle: add powered-down state
      ARM: tegra: do v7_invalidate_l1 only when CPU is Cortex-A9
      ARM: tegra: add a flag for tegra_disable_clean_inv_dcache to do LoUIS or ALL
      ARM: tegra: set up the correct L2 data RAM latency for Cortex-A15
      ARM: tegra: add low level code for Tegra114 cluster power down
      ARM: tegra: shut off the CPU rail when the last CPU in suspend
      ARM: tegra: hook tegra_tear_down_cpu function
      ARM: tegra: flowctrl: add support for cpu_suspend_enter/exit
      clk: tegra: add suspend/resume function for tegra_cpu_car_ops
      ARM: tegra: remove the limitation that Tegra114 can't support suspend
      ARM: tegra: add common resume handling code for LP1 resuming
      ARM: tegra: config the polarity of the request of sys clock
      clk: tegra114: add LP1 suspend/resume support
      ARM: tegra: add common LP1 suspend support
      ARM: tegra: add LP1 suspend support for Tegra30
      ARM: tegra: add LP1 suspend support for Tegra20
      ARM: tegra: add LP1 suspend support for Tegra114

Julia Lawall (1):
      PCI: tegra: replace devm_request_and_ioremap by devm_ioremap_resource

Kevin Hilman (11):
      Merge tag 'omap-for-v3.12/dra7xx' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'tegra-for-3.12-soc' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'sunxi-core-for-3.12' of https://github.com/mripard/linux into next/soc
      Merge tag 'sunxi-core-for-3.12-2' of https://github.com/mripard/linux into next/soc
      Merge tag 'ux500-core-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc
      Merge tag 'davinci-for-v3.12/soc' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge tag 'davinci-for-v3.12/dt' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge tag 'imx-weim-3.12' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge tag 'imx-soc-3.12' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge tag 'imx-dt-3.12' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge tag 'mxs-soc-3.12' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc

Kyle McMartin (1):
      tegra-cpuidle: provide stub when !CONFIG_CPU_IDLE

Lad, Prabhakar (5):
      ARM: davinci: fix clock lookup for mdio device
      ARM: davinci: da850: add DT node for mdio device
      ARM: davinci: da850: add OF_DEV_AUXDATA entry for mdio.
      ARM: davinci: da850: add OF_DEV_AUXDATA entry for davinci_emac
      ARM: davinci: da850: add DT node for ethernet

Laurent Pinchart (1):
      ARM: shmobile: r8a7740: Add TPU clock entry for DT platforms

Liu Ying (3):
      ARM: imx: add common clock support for fixup div
      ARM: imx: add common clock support for fixup mux
      ARM: imx6: change some clocks to fixup clocks

Lorenzo Pieralisi (1):
      ARM: vexpress/TC2: add Serial Power Controller (SPC) support

Lothar Waßmann (2):
      ARM: mxs: Allow DT clock providers
      ARM: mxs: Fix BUG() when invoking mxs_restart() from interrupt context

Magnus Damm (8):
      ARM: shmobile: Sort r8a7790 MSTP entries
      ARM: shmobile: Add r8a7790 CMT00 clock event
      ARM: shmobile: Make r8a7790 Arch timer optional
      ARM: shmobile: Add r8a73a4 CMT10 clock event
      ARM: shmobile: Make r8a73a4 Arch timer optional
      ARM: shmobile: Disconnect EMEV2 SMP code from clocks
      ARM: shmobile: Introduce r8a7790_read_mode_pins()
      ARM: shmobile: Setup r8a7790 arch timer based on MD pins

Manjunathappa, Prakash (5):
      ARM: davinci: uart: move to devid based clk_get
      ARM: davinci: da8xx: remove da8xx_uart_clk_enable
      ARM: davinci: serial: get rid of davinci_uart_config
      ARM: davinci: serial: remove davinci_serial_setup_clk()
      ARM: davinci: da850: do not specify clock_frequency for UART DT node

Markus Pargmann (8):
      ARM: dts: imx27: Add imx framebuffer device
      ARM: dts: imx27: Add 1-wire
      ARM: dts: imx27 cpufreq-cpu0 frequencies
      ARM: dts: Add device tree support for phycard pca100
      ARM: dts: imx27 phyCARD-S remove wrong I2C RTC
      ARM: dts: imx27 phyCARD-S SOM remove wrong i2c sensor
      ARM: dts: imx27 phyCARD-S, move i2c1 and owire to rdk
      ARM: dts: imx27 phyCARD-S, i2c ADC device node

Matthias Weisser (1):
      ARM: dts: imx25: Make lcdc compatible to imx21 fb

Maxime Ripard (4):
      ARM: sunxi: Remove Makefile.boot file
      ARM: sunxi: Add the Allwinner A31 compatible to the machine definition
      ARM: sun6i: Add restart code for the A31
      ARM: sunxi: Introduce Allwinner A20 support

Nicolas Pitre (4):
      ARM: vexpress/dcscb: fix cache disabling sequences
      ARM: vexpress/TC2: basic PM support
      ARM: vexpress/TC2: implement PM suspend method
      ARM: vexpress/MCPM: fix cache disable sequence when CONFIG_FRAME_POINTER=y

Olof Johansson (5):
      Merge tag 'tc2-pm' of git://git.linaro.org/people/pawelmoll/linux into next/soc
      Merge tag 'renesas-soc-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc2-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'drivers-3.12' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'dt-3.12' of git://git.infradead.org/linux-mvebu into next/soc

Pawel Moll (1):
      ARM: vexpress: Add SCC to V2P-CA15_A7's device tree

Peter Chen (4):
      ARM: imx: clk-pllv3: improve the timeout waiting method
      ARM: imx: Move anatop related from board file to anatop driver
      ARM: dtsi: imx6qdl-sabresd: Add USB host 1 VBUS regulator
      ARM: dtsi: imx6qdl-sabresd: Add USB OTG vbus pin to pinctrl_hog

Philipp Zabel (6):
      ARM i.MX6Q: Use ENET_CLK_SEL defines in imx6q_1588_init
      ARM i.MX6DL: parent LDB DI clocks to PLL5 on i.MX6S/DL
      ARM: dts: add sram for imx53 and imx6q
      ARM i.MX6DL: dts: add clock and mux configuration for LDB
      ARM i.MX6Q: dts: Enable SPI NOR flash on Phytec phyFLEX-i.MX6 Ouad module
      ARM i.MX6Q: dts: Enable I2C1 with EEPROM and PMIC on Phytec phyFLEX-i.MX6 Ouad module

Philippe Reynes (1):
      ARM: apf27dev: add rtc ds1374 to the device tree

R Sricharan (7):
      ARM: DRA7: Reuse all of PRCM and MPUSS SMP infra
      ARM: DRA7: Reuse io tables and add a new .init_early
      ARM: DRA7: Resue the clocksource, clockevent support
      ARM: DRA7: board-generic: Add basic DT support
      ARM: DRA7: Kconfig: Make ARCH_NR_GPIO default to 512
      ARM: DRA7: id: Add cpu detection support for DRA7xx based SoCs'
      ARM: DRA7: Add the build support in omap2plus

Rajendra Nayak (1):
      ARM: DRA7: hwmod: Reuse the soc_ops used for OMAP4/5

Richard Zhu (1):
      ARM: dtsi: enable ahci sata on imx6q platforms

Sascha Hauer (19):
      ARM: i.MX6: call ksz9021 phy fixup for all i.MX6 boards
      ARM: i.MX6: add ethernet phy fixup for AR8031
      ARM: i.MX6: add ethernet phy fixup for KSZ9031
      ARM: dts: i.MX6: sync imx6q and imx6dl pinmux entries
      ARM: dts: i.MX6qdl: Add compatible and clock to flexcan nodes
      ARM: dts: i.MX6qdl: Add i.MX31 compatible to gpt node
      ARM: dts: i.MX27: Add iim node
      ARM: dts: i.MX31: Add iim node
      ARM: dts: i.MX25: Add iim node
      ARM: dts: i.MX51: Add iim node
      ARM: dts: i.MX53: Add iim node
      ARM: dts: i.MX25: Add i2c and spi aliases
      ARM: dts: i.MX27: Add i2c aliases
      ARM: dts: i.MX51: Add i2c and spi aliases
      ARM: dts: i.MX53: Add i2c and spi aliases
      ARM: dts: i.MX6: Add i2c and spi aliases
      ARM: dts: i.MX51: move kpp pinmux entry
      ARM: dts: i.MX51 babbage: Add spi-cs-high property to pmic
      ARM: dts: i.MX51: Add USB host1/2 pinmux entries

Shawn Guo (16):
      ARM: imx: let L2 initialization be a common function
      ARM: imx: use imx specific L2 init function on imx6sl
      ARM: imx6q: add spdif gate clock
      ARM: imx6q: add cko2 clocks
      ARM: imx6q: add the missing cko output selection
      ARM: imx6q: add vdoa gate clock
      Merge tag 'imx-soc-3.12' into imx/dt
      ARM: dts: imx: share pad macro names between imx6q and imx6dl
      ARM: dts: add more imx6q/dl pin groups
      ARM: dts: imx: remove old DMA binding data from gpmi node
      ARM: dts: imx: add tempmon node for imx6q thermal support
      ARM: dts: imx: add LVDS panel for imx6qdl-sabresd
      ARM: dts: imx: use generic DMA bindings for SSI nodes
      ARM: imx6q: remove board specific CLKO setup
      ARM: dts: imx: ocram size is different between imx6q and imx6dl
      ARM: imx: add ocram clock for imx53

Simon Horman (4):
      ARM: shmobile: r8a7790: add clocks for thermal
      ARM: shmobile: r8a7790: add thermal driver support
      Merge tag 'renesas-fixes-for-v3.12' into soc2-base
      ARM: shmobile: r8a7790: clocks for Ether support

Srinivas Kandagatla (1):
      ARM: ux500: remove u8500_secondary_startup from INIT section.

Stephen Warren (4):
      ARM: tegra: unify Tegra's Kconfig a bit more
      Merge tag 'msi-3.12-2' into for-3.12/soc
      PCI: tegra: set up PADS_REFCLK_CFG1
      ARM: tegra: disable LP2 cpuidle state if PCIe is enabled

Thierry Reding (4):
      PCI: Introduce new MSI chip infrastructure
      PCI: tegra: Move PCIe driver to drivers/pci/host
      MAINTAINERS: Add myself as Tegra PCIe maintainer
      ARM: tegra: Drop ARCH_SUPPORTS_MSI and sort list

Thomas Petazzoni (18):
      bus: mvebu-mbus: Add new API for window creation
      ARM: kirkwood: Move to ID based MBus window creation
      ARM: mv78xx0: Move to ID based window creation
      ARM: orion5x: Move to ID based window creation
      ARM: dove: Move to ID based window creation
      PCI: mvebu: Adapt to the new device tree layout
      bus: mvebu-mbus: Remove the no longer used name-based API
      bus: mvebu-mbus: Remove name -> target, attribute mapping tables
      bus: mvebu-mbus: Update main description
      bus: mvebu-mbus: Factorize Armada 370/XP data structures
      PCI: mvebu: Adapt to the new device tree layout
      ARM: mvebu: add support for the AXP WiFi AP board
      PCI: use weak functions for MSI arch-specific functions
      PCI: remove ARCH_SUPPORTS_MSI kconfig option
      of: pci: add registry of MSI chips
      ARM: pci: add ->add_bus() and ->remove_bus() hooks to hw_pci
      PCI: msi: add default MSI operations for !HAVE_GENERIC_HARDIRQS platforms
      ARM: mvebu: use correct #interrupt-cells instead of #interrupts-cells

Tony Lindgren (1):
      Merge tag 'dra7-core-support-minus-dt' of git://github.com/rrnayak/linux into omap-for-v3.12/soc

Tony Prisk (1):
      ARM: dts: wandboard: Add support for SDIO bcm4329

Vincent Stehlé (1):
      ARM: imx: fix imx_init_l2cache storage class

Xianglong Du (1):
      ARM: prima2: pm: enable rtc alarm0 and alarm1 as wakeup source


 .../devicetree/bindings/arm/omap/omap.txt       |    3 +
 .../devicetree/bindings/arm/vexpress-scc.txt    |   33 +
 .../devicetree/bindings/bus/imx-weim.txt        |   17 +-
 .../devicetree/bindings/bus/mvebu-mbus.txt      |  276 +++
 .../devicetree/bindings/clock/imx5-clock.txt    |    1 +
 .../devicetree/bindings/clock/imx6q-clock.txt   |    6 +
 .../devicetree/bindings/pci/mvebu-pci.txt       |  145 +-
 .../bindings/pci/nvidia,tegra20-pcie.txt        |  163 ++
 .../watchdog/{sun4i-wdt.txt => sunxi-wdt.txt}   |    5 +-
 MAINTAINERS                                     |    7 +
 arch/arm/Kconfig                                |    3 +-
 arch/arm/boot/dts/Makefile                      |    6 +
 arch/arm/boot/dts/armada-370-db.dts             |    5 +-
 arch/arm/boot/dts/armada-370-mirabox.dts        |   37 +-
 arch/arm/boot/dts/armada-370-netgear-rn102.dts  |  179 ++
 arch/arm/boot/dts/armada-370-rd.dts             |   37 +-
 arch/arm/boot/dts/armada-370-xp.dtsi            |  113 +-
 arch/arm/boot/dts/armada-370.dtsi               |  123 +-
 arch/arm/boot/dts/armada-xp-axpwifiap.dts       |  164 ++
 arch/arm/boot/dts/armada-xp-db.dts              |  131 +-
 arch/arm/boot/dts/armada-xp-gp.dts              |  107 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi        |  228 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi        |  269 +--
 arch/arm/boot/dts/armada-xp-mv78460.dtsi        |  417 ++--
 .../arm/boot/dts/armada-xp-openblocks-ax3-4.dts |   88 +-
 arch/arm/boot/dts/armada-xp.dtsi                |   11 +-
 arch/arm/boot/dts/da850-evm.dts                 |   11 +
 arch/arm/boot/dts/da850.dtsi                    |   46 +-
 arch/arm/boot/dts/imx25.dtsi                    |   35 +-
 arch/arm/boot/dts/imx27-apf27dev.dts            |    5 +
 .../arm/boot/dts/imx27-phytec-phycard-s-rdk.dts |   93 +
 .../arm/boot/dts/imx27-phytec-phycard-s-som.dts |   44 +
 arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts  |   13 +
 arch/arm/boot/dts/imx27-phytec-phycore-som.dts  |  125 +-
 arch/arm/boot/dts/imx27.dtsi                    |  120 +-
 arch/arm/boot/dts/imx31.dtsi                    |   17 +
 arch/arm/boot/dts/imx51-apf51.dts               |    4 -
 arch/arm/boot/dts/imx51-babbage.dts             |    5 +
 arch/arm/boot/dts/imx51.dtsi                    |  632 +++---
 arch/arm/boot/dts/imx53-qsb.dts                 |   18 +-
 arch/arm/boot/dts/imx53.dtsi                    |   56 +-
 arch/arm/boot/dts/imx6dl-pinfunc.h              | 2138 +++++++++---------
 arch/arm/boot/dts/imx6dl-sabreauto.dts          |   22 -
 arch/arm/boot/dts/imx6dl-sabresd.dts            |   19 -
 arch/arm/boot/dts/imx6dl-wandboard.dts          |   24 +-
 arch/arm/boot/dts/imx6dl.dtsi                   |  254 +--
 arch/arm/boot/dts/imx6q-arm2.dts                |   14 +-
 arch/arm/boot/dts/imx6q-phytec-pfla02.dtsi      |  112 +-
 arch/arm/boot/dts/imx6q-pinfunc.h               | 2050 ++++++++---------
 arch/arm/boot/dts/imx6q-sabreauto.dts           |   22 +-
 arch/arm/boot/dts/imx6q-sabrelite.dts           |   22 +-
 arch/arm/boot/dts/imx6q-sabresd.dts             |   19 +-
 arch/arm/boot/dts/imx6q-wandboard.dts           |   26 +
 arch/arm/boot/dts/imx6q.dtsi                    |  393 +---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi        |   22 +
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi          |   92 +-
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi        |  137 ++
 arch/arm/boot/dts/imx6qdl.dtsi                  |  770 ++++++-
 arch/arm/boot/dts/imx6sl.dtsi                   |   35 +-
 arch/arm/boot/dts/kirkwood-6281.dtsi            |   66 +-
 arch/arm/boot/dts/kirkwood-6282.dtsi            |  102 +-
 arch/arm/boot/dts/kirkwood-cloudbox.dts         |    4 +-
 arch/arm/boot/dts/kirkwood-db-88f6281.dts       |    7 +-
 arch/arm/boot/dts/kirkwood-db-88f6282.dts       |    7 +-
 arch/arm/boot/dts/kirkwood-db.dtsi              |   10 +-
 arch/arm/boot/dts/kirkwood-dns320.dts           |    2 +-
 arch/arm/boot/dts/kirkwood-dns325.dts           |    2 +-
 arch/arm/boot/dts/kirkwood-dnskw.dtsi           |    4 +-
 arch/arm/boot/dts/kirkwood-dockstar.dts         |    4 +-
 arch/arm/boot/dts/kirkwood-dreamplug.dts        |    4 +-
 arch/arm/boot/dts/kirkwood-goflexnet.dts        |    4 +-
 .../boot/dts/kirkwood-guruplug-server-plus.dts  |    4 +-
 arch/arm/boot/dts/kirkwood-ib62x0.dts           |    4 +-
 arch/arm/boot/dts/kirkwood-iconnect.dts         |   23 +-
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts   |    4 +-
 arch/arm/boot/dts/kirkwood-is2.dts              |    2 +-
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts      |    4 +-
 arch/arm/boot/dts/kirkwood-lschlv2.dts          |    2 +-
 arch/arm/boot/dts/kirkwood-lsxhl.dts            |    2 +-
 arch/arm/boot/dts/kirkwood-lsxl.dtsi            |    4 +-
 arch/arm/boot/dts/kirkwood-mplcec4.dts          |   23 +-
 .../dts/kirkwood-netgear_readynas_duo_v2.dts    |   43 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi      |    4 +-
 arch/arm/boot/dts/kirkwood-ns2.dts              |    2 +-
 arch/arm/boot/dts/kirkwood-ns2lite.dts          |    2 +-
 arch/arm/boot/dts/kirkwood-ns2max.dts           |    2 +-
 arch/arm/boot/dts/kirkwood-ns2mini.dts          |    2 +-
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi   |  107 +
 arch/arm/boot/dts/kirkwood-nsa310.dts           |  111 +-
 arch/arm/boot/dts/kirkwood-nsa310a.dts          |  165 ++
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts    |    4 +-
 .../boot/dts/kirkwood-sheevaplug-common.dtsi    |    4 +-
 arch/arm/boot/dts/kirkwood-sheevaplug-esata.dts |    2 +-
 arch/arm/boot/dts/kirkwood-sheevaplug.dts       |    2 +-
 arch/arm/boot/dts/kirkwood-topkick.dts          |    4 +-
 arch/arm/boot/dts/kirkwood-ts219-6281.dts       |    6 +-
 arch/arm/boot/dts/kirkwood-ts219-6282.dts       |   25 +-
 arch/arm/boot/dts/kirkwood-ts219.dtsi           |   17 +-
 arch/arm/boot/dts/kirkwood.dtsi                 |   17 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts      |    6 +
 arch/arm/boot/dts/vf610-twr.dts                 |    7 +
 arch/arm/configs/imx_v4_v5_defconfig            |   19 +-
 arch/arm/configs/imx_v6_v7_defconfig            |   51 +-
 arch/arm/configs/mxs_defconfig                  |   19 +-
 arch/arm/configs/omap2plus_defconfig            |    1 +
 arch/arm/include/asm/mach/pci.h                 |    4 +
 arch/arm/kernel/bios32.c                        |   16 +
 arch/arm/mach-at91/board-dt-sama5.c             |   17 +-
 arch/arm/mach-davinci/board-da830-evm.c         |    6 +-
 arch/arm/mach-davinci/board-da850-evm.c         |    6 +-
 arch/arm/mach-davinci/board-dm355-evm.c         |    6 +-
 arch/arm/mach-davinci/board-dm355-leopard.c     |    6 +-
 arch/arm/mach-davinci/board-dm365-evm.c         |    6 +-
 arch/arm/mach-davinci/board-dm644x-evm.c        |    6 +-
 arch/arm/mach-davinci/board-dm646x-evm.c        |    6 +-
 arch/arm/mach-davinci/board-mityomapl138.c      |    6 +-
 arch/arm/mach-davinci/board-neuros-osd2.c       |    6 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c     |    6 +-
 arch/arm/mach-davinci/board-sffsdr.c            |    6 +-
 arch/arm/mach-davinci/da830.c                   |    8 +-
 arch/arm/mach-davinci/da850.c                   |    8 +-
 arch/arm/mach-davinci/da8xx-dt.c                |   14 +-
 arch/arm/mach-davinci/davinci.h                 |    5 +
 arch/arm/mach-davinci/devices-da8xx.c           |   59 +-
 arch/arm/mach-davinci/devices-tnetv107x.c       |   39 +-
 arch/arm/mach-davinci/dm355.c                   |   51 +-
 arch/arm/mach-davinci/dm365.c                   |   40 +-
 arch/arm/mach-davinci/dm644x.c                  |   54 +-
 arch/arm/mach-davinci/dm646x.c                  |   54 +-
 arch/arm/mach-davinci/include/mach/common.h     |    1 -
 arch/arm/mach-davinci/include/mach/da8xx.h      |    2 +-
 arch/arm/mach-davinci/include/mach/serial.h     |   10 +-
 arch/arm/mach-davinci/include/mach/tnetv107x.h  |    3 +-
 arch/arm/mach-davinci/serial.c                  |   54 +-
 arch/arm/mach-davinci/tnetv107x.c               |    8 +-
 arch/arm/mach-dove/common.c                     |   68 +-
 arch/arm/mach-imx/Kconfig                       |    3 +-
 arch/arm/mach-imx/Makefile                      |    3 +-
 arch/arm/mach-imx/anatop.c                      |    4 +-
 arch/arm/mach-imx/clk-fixup-div.c               |  129 ++
 arch/arm/mach-imx/clk-fixup-mux.c               |  107 +
 arch/arm/mach-imx/clk-imx51-imx53.c             |    3 +-
 arch/arm/mach-imx/clk-imx6q.c                   |   57 +-
 arch/arm/mach-imx/clk-imx6sl.c                  |   20 +-
 arch/arm/mach-imx/clk-pllv3.c                   |   15 +-
 arch/arm/mach-imx/clk.c                         |   26 +
 arch/arm/mach-imx/clk.h                         |   10 +
 arch/arm/mach-imx/common.h                      |   13 +-
 arch/arm/mach-imx/mach-imx6q.c                  |  171 +-
 arch/arm/mach-imx/mach-imx6sl.c                 |    3 +-
 arch/arm/mach-imx/mm-imx5.c                     |    4 +-
 arch/arm/mach-imx/pm-imx5.c                     |    7 +-
 arch/arm/mach-imx/system.c                      |   33 +
 arch/arm/mach-kirkwood/board-dt.c               |    1 +
 arch/arm/mach-kirkwood/common.c                 |   26 +-
 arch/arm/mach-kirkwood/pcie.c                   |   40 +-
 arch/arm/mach-mv78xx0/pcie.c                    |   23 +-
 arch/arm/mach-mvebu/armada-370-xp.c             |   34 +-
 arch/arm/mach-mvebu/platsmp.c                   |   25 +-
 arch/arm/mach-mxs/mach-mxs.c                    |   62 +-
 arch/arm/mach-mxs/pm.c                          |    1 +
 arch/arm/mach-omap1/include/mach/soc.h          |    1 +
 arch/arm/mach-omap2/Kconfig                     |   12 +-
 arch/arm/mach-omap2/Makefile                    |    6 +
 arch/arm/mach-omap2/board-generic.c             |   18 +
 arch/arm/mach-omap2/common.h                    |    1 +
 arch/arm/mach-omap2/id.c                        |    4 +-
 arch/arm/mach-omap2/io.c                        |   20 +-
 arch/arm/mach-omap2/omap54xx.h                  |    4 +
 arch/arm/mach-omap2/omap_hwmod.c                |    2 +-
 arch/arm/mach-omap2/soc.h                       |   17 +
 arch/arm/mach-omap2/timer.c                     |    3 +-
 arch/arm/mach-orion5x/common.c                  |   36 +-
 arch/arm/mach-orion5x/common.h                  |   17 +
 arch/arm/mach-orion5x/d2net-setup.c             |    6 +-
 arch/arm/mach-orion5x/db88f5281-setup.c         |   24 +-
 arch/arm/mach-orion5x/dns323-setup.c            |    6 +-
 arch/arm/mach-orion5x/edmini_v2-setup.c         |    6 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c       |   12 +-
 arch/arm/mach-orion5x/ls-chl-setup.c            |    6 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c            |    6 +-
 arch/arm/mach-orion5x/lsmini-setup.c            |    6 +-
 arch/arm/mach-orion5x/mss2-setup.c              |    6 +-
 arch/arm/mach-orion5x/mv2120-setup.c            |    6 +-
 arch/arm/mach-orion5x/net2big-setup.c           |    6 +-
 arch/arm/mach-orion5x/pci.c                     |    9 +-
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c    |    6 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c     |    6 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c         |   13 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c  |    6 +-
 arch/arm/mach-orion5x/ts209-setup.c             |    6 +-
 arch/arm/mach-orion5x/ts409-setup.c             |    6 +-
 arch/arm/mach-orion5x/wnr854t-setup.c           |    6 +-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c        |    6 +-
 arch/arm/mach-prima2/pm.c                       |   21 +-
 arch/arm/mach-shmobile/Kconfig                  |    4 +-
 arch/arm/mach-shmobile/board-ape6evm.c          |    1 +
 arch/arm/mach-shmobile/board-lager.c            |    1 +
 arch/arm/mach-shmobile/clock-emev2.c            |   18 -
 arch/arm/mach-shmobile/clock-r8a73a4.c          |  199 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |    1 +
 arch/arm/mach-shmobile/clock-r8a7790.c          |   27 +-
 arch/arm/mach-shmobile/include/mach/emev2.h     |    1 -
 arch/arm/mach-shmobile/include/mach/r8a73a4.h   |    1 +
 arch/arm/mach-shmobile/include/mach/r8a7740.h   |    2 +
 arch/arm/mach-shmobile/include/mach/r8a7790.h   |    4 +
 arch/arm/mach-shmobile/setup-r8a73a4.c          |   30 +
 arch/arm/mach-shmobile/setup-r8a7740.c          |   10 +
 arch/arm/mach-shmobile/setup-r8a7790.c          |  106 +-
 arch/arm/mach-shmobile/smp-emev2.c              |   11 +-
 arch/arm/mach-sunxi/Kconfig                     |    2 +
 arch/arm/mach-sunxi/Makefile.boot               |    1 -
 arch/arm/mach-sunxi/sunxi.c                     |   45 +-
 arch/arm/mach-tegra/Kconfig                     |   28 +-
 arch/arm/mach-tegra/Makefile                    |    6 +-
 arch/arm/mach-tegra/board-harmony-pcie.c        |   89 -
 arch/arm/mach-tegra/board.h                     |    8 -
 arch/arm/mach-tegra/common.h                    |    1 -
 arch/arm/mach-tegra/cpuidle-tegra114.c          |   51 +-
 arch/arm/mach-tegra/cpuidle-tegra20.c           |   12 +
 arch/arm/mach-tegra/cpuidle.c                   |   10 +
 arch/arm/mach-tegra/cpuidle.h                   |    1 +
 arch/arm/mach-tegra/flowctrl.c                  |    2 +
 arch/arm/mach-tegra/flowctrl.h                  |    9 +
 arch/arm/mach-tegra/headsmp.S                   |    3 +-
 arch/arm/mach-tegra/hotplug.c                   |   13 +-
 arch/arm/mach-tegra/iomap.h                     |   11 +-
 arch/arm/mach-tegra/irq.c                       |   40 +
 arch/arm/mach-tegra/pcie.c                      |  886 --------
 arch/arm/mach-tegra/platsmp.c                   |    1 -
 arch/arm/mach-tegra/pm-tegra20.c                |   34 +
 arch/arm/mach-tegra/pm-tegra30.c                |   34 +
 arch/arm/mach-tegra/pm.c                        |  148 +-
 arch/arm/mach-tegra/pm.h                        |   12 +
 arch/arm/mach-tegra/pmc.c                       |   53 +-
 arch/arm/mach-tegra/pmc.h                       |    3 +
 arch/arm/mach-tegra/reset-handler.S             |   21 +-
 arch/arm/mach-tegra/reset.c                     |    2 +
 arch/arm/mach-tegra/reset.h                     |    4 +
 arch/arm/mach-tegra/sleep-tegra20.S             |  297 +++
 arch/arm/mach-tegra/sleep-tegra30.S             |  616 ++++-
 arch/arm/mach-tegra/sleep.S                     |   37 +-
 arch/arm/mach-tegra/sleep.h                     |   14 +-
 arch/arm/mach-tegra/tegra.c                     |   24 -
 arch/arm/mach-ux500/board-mop500.c              |    5 +-
 arch/arm/mach-ux500/cpu-db8500.c                |    2 +-
 arch/arm/mach-ux500/cpu.c                       |    8 +
 arch/arm/mach-ux500/devices-db8500.c            |    1 +
 arch/arm/mach-ux500/headsmp.S                   |    2 -
 arch/arm/mach-ux500/setup.h                     |    3 +
 arch/arm/mach-vexpress/Kconfig                  |    8 +
 arch/arm/mach-vexpress/Makefile                 |    1 +
 arch/arm/mach-vexpress/dcscb.c                  |   66 +-
 arch/arm/mach-vexpress/spc.c                    |  180 ++
 arch/arm/mach-vexpress/spc.h                    |   24 +
 arch/arm/mach-vexpress/tc2_pm.c                 |  352 +++
 arch/arm/plat-omap/Kconfig                      |    2 +-
 arch/ia64/Kconfig                               |    1 -
 arch/mips/Kconfig                               |    2 -
 arch/mips/include/asm/pci.h                     |    5 -
 arch/powerpc/Kconfig                            |    1 -
 arch/powerpc/include/asm/pci.h                  |    5 -
 arch/s390/Kconfig                               |    1 -
 arch/s390/include/asm/pci.h                     |    4 -
 arch/sparc/Kconfig                              |    1 -
 arch/tile/Kconfig                               |    1 -
 arch/x86/Kconfig                                |    1 -
 arch/x86/include/asm/pci.h                      |   30 -
 arch/x86/kernel/x86_init.c                      |   24 +
 drivers/bus/Kconfig                             |    3 +-
 drivers/bus/imx-weim.c                          |  129 +-
 drivers/bus/mvebu-mbus.c                        |  441 ++--
 drivers/clk/tegra/clk-tegra114.c                |   38 +
 drivers/memory/mvebu-devbus.c                   |   72 +-
 drivers/of/of_pci.c                             |   45 +
 drivers/pci/Kconfig                             |    4 -
 drivers/pci/host/Kconfig                        |    4 +
 drivers/pci/host/Makefile                       |    1 +
 drivers/pci/host/pci-mvebu.c                    |  115 +-
 drivers/pci/host/pci-tegra.c                    | 1691 ++++++++++++++
 drivers/pci/msi.c                               |   85 +-
 drivers/pci/probe.c                             |    1 +
 include/linux/mbus.h                            |   16 +-
 include/linux/micrel_phy.h                      |    6 +
 include/linux/msi.h                             |   21 +-
 include/linux/of_pci.h                          |   12 +
 include/linux/pci.h                             |    1 +
 include/linux/tegra-cpuidle.h                   |   25 +
 288 files changed, 12546 insertions(+), 6424 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/vexpress-scc.txt
 create mode 100644 Documentation/devicetree/bindings/bus/mvebu-mbus.txt
 create mode 100644 Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
 rename Documentation/devicetree/bindings/watchdog/{sun4i-wdt.txt => sunxi-wdt.txt} (56%)
 create mode 100644 arch/arm/boot/dts/armada-370-netgear-rn102.dts
 create mode 100644 arch/arm/boot/dts/armada-xp-axpwifiap.dts
 create mode 100644 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
 create mode 100644 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dts
 create mode 100644 arch/arm/boot/dts/imx6q-wandboard.dts
 create mode 100644 arch/arm/boot/dts/imx6qdl-wandboard.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-nsa310a.dts
 create mode 100644 arch/arm/mach-imx/clk-fixup-div.c
 create mode 100644 arch/arm/mach-imx/clk-fixup-mux.c
 delete mode 100644 arch/arm/mach-sunxi/Makefile.boot
 delete mode 100644 arch/arm/mach-tegra/board-harmony-pcie.c
 delete mode 100644 arch/arm/mach-tegra/pcie.c
 create mode 100644 arch/arm/mach-tegra/pm-tegra20.c
 create mode 100644 arch/arm/mach-tegra/pm-tegra30.c
 create mode 100644 arch/arm/mach-vexpress/spc.c
 create mode 100644 arch/arm/mach-vexpress/spc.h
 create mode 100644 arch/arm/mach-vexpress/tc2_pm.c
 create mode 100644 drivers/pci/host/pci-tegra.c
 create mode 100644 include/linux/tegra-cpuidle.h
