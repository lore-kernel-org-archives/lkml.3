Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaFBVjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:39:25 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38878 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaFBViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:38:05 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=203/7=5D=20ARM=3A=20SoC=20updates=20for=203=2E16=20=28part=201=29?=
Date: Mon,  2 Jun 2014 14:04:06 -0700
Message-Id: <1401743050-7379-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401743050-7379-1-git-send-email-olof@lixom.net>
References: <1401743050-7379-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quite large set of SoC updates this cycle. In no particular order:

- Multi-cluster power management for Samsung Exynos, adding support for
big.LITTLE CPU switching on EXYNOS5
- SMP support for Marvell Armada 375 and 38x
- SMP rework on Allwinner A31
- Xilinx Zynq support for SOC_BUS, big endian
- Marvell orion5x platform cleanup, modernizing the implementation and
  moving to DT.
- _Finally_ moving Samsung Exynos over to support MULTIPLATFORM, so
  that their platform can be enabled in the same kernel binary as most
  of the other v7 platforms in the tree. \o/ The work isn't quite complete,
  there's some driver fixes still needed, but the basics now work.

New SoC support added:
- Freescale i.MX6SX
- LSI Axxia AXM55xx SoCs
- Samsung EXYNOS 3250, 5260, 5410, 5420 and 5800
- STi STIH407

Plus a large set of various smaller updates for different platforms. I'm
probably missing some important one here.

----------------------------------------------------------------

The following changes since commit d34c691d03e34d471ea9c456cc7faecfa80af3eb:

  Merge tag 'cleanup-for-3.16' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-3.16

for you to fetch changes up to b5b9324a6296bd0176fe1f8e06a1220207bd1bd3:

  ARM: exynos: don't run exynos4 l2x0 setup on other platforms

----------------------------------------------------------------

Abhilash Kesavan (4):
      ARM: EXYNOS: Add generic cluster power control functions
      ARM: EXYNOS: Add MCPM call-back functions
      ARM: EXYNOS: Enable mcpm for dual-cluster exynos5800 SoC
      ARM: exynos: Fix "allmodconfig" build errors in mcpm and hotplug

Alexander Shiyan (11):
      ARM: bcm: Restrict ARCH_BCM selection to ARCH_MULTI_V6_V7
      ARM: i.MX: mx21ads: Replace direct handling of peripheral bits with GPIOs
      ARM: i.MX: mx21ads: Use fixed voltage regulator for LCD power
      ARM: i.MX: mx21ads: Cleanup board
      ARM: i.MX: Remove #ifdef CONFIG_OF
      ARM: i.MX27 clk: Add missing clocks for MSHC and RTIC
      ARM: i.MX27 clk: Remove clk_register_clkdev() for unused clocks
      ARM: i.MX: Fix eMMa PrP resource size
      ARM: i.MX: Setup IRQ handler from IRQ driver
      ARM: i.MX1 clk: Add missing clocks
      ARM: i.MX1 clk: Remove clk_register_clkdev() for unused clocks

Alexandre Belloni (16):
      ARM: at91: sam9g45: remove unused platform_data
      ARM: at91: sam9260: remove unused platform_data
      iio: adc: at91: cleanup platform_data
      iio: adc: at91_adc: Add support for touchscreens without TSMR
      ARM: at91: sam9m10g45ek: Add touchscreen support through at91_adc
      iio: adc: at91: remove unused include from include/mach
      iio: adc: at91: add sam9rl support
      ARM: at91: sam9rl: add at91_adc to support adc and touchscreen
      ARM: at91: sam9rlek add touchscreen support through at91_adc
      ARM: at91: sam9g45: switch from atmel_tsadcc to at91_adc
      ARM: at91: sam9rl: switch from atmel_tsadcc to at91_adc
      ARM: at91: remove atmel_tsadcc from sama5_defconfig
      Input: atmel_tsadcc: remove driver
      ARM: at91: remove atmel_tsadcc platform_data
      ARM: at91/dt: at91-cosino_mega2560 remove useless tsadcc node
      ARM: berlin: add MACH_BERLIN_BG2Q symbol

Alim Akhtar (1):
      clk: exynos5420: Add 5800 specific clocks

Anders Berg (5):
      ARM: Add platform support for LSI AXM55xx SoC
      ARM: dts: Device tree for AXM55xx.
      ARM: axxia: Adding defconfig for AXM55xx
      power: reset: Add Axxia system reset driver
      ARM: dts: axxia: Add reset controller

Andrew Bresticker (1):
      ARM: dts: add CCI node for exynos5420

Andrew Lunn (3):
      ARM: mvebu: Add a SOC bus device entry
      ARM: Kirkwood: Remove platform driver for codec
      ARM: Kirkwood: t5325: Remove platform device to instantiate audio

Andy Gross (1):
      ARM: qcom: Select PINCTRL by default for ARCH_QCOM

Anson Huang (1):
      ARM: imx: add clock driver for imx6sx

Antoine Tenart (3):
      ARM: berlin: add Marvell Armada 1500 pro to Marvell doc
      ARM: berlin: add the LIBGPIO as a dependency for the BG2Q
      ARM: berlin: add the pinctrl dependency for the Marvell Berlin SoCs

Archit Taneja (1):
      ARM: OMAP2+: hwmod: OMAP5 DSS hwmod data

Arnd Bergmann (8):
      Merge branch 'axxia/soc' into next/soc
      Merge tag 'mvebu-soc-3.16-2' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'qcom-soc-for-3.16' of git://git.kernel.org/.../galak/linux-qcom into next/soc
      Merge tag 'sunxi-core-for-3.16-2' of https://github.com/mripard/linux into next/soc
      Merge branch 'bcm/cleanup' into next/soc
      Merge tag 'for-3.16/bcm-soc' of git://github.com/broadcom/mach-bcm into next/soc
      ARM: sunxi: allow building without reset controller
      ARM: EXYNOS: Enable multi-platform build support

Arun Kumar K (6):
      ARM: dts: Add pwmX_out pinctrl nodes to exynos5420
      ARM: dts: Add node labels to exynos5420
      ARM: dts: Add exynos5420 peach-pit board support
      clk: samsung: exynos5250: Add clocks for G3D
      clk: samsung: exynos5420: Add clock IDs needed by GPU
      ARM: EXYNOS: Add 5800 SoC support

Boris BREZILLON (12):
      clk: at91: rework main clk implementation
      clk: at91: update main clk documentation
      clk: at91: add slow clks driver
      clk: at91: add slow clk documentation
      ARM: at91/dt: move sama5d3 SoC to the new main/slow clk model
      ARM: at91/dt: add xtal frequencies to sama5d3xcm boards
      ARM: at91/dt: add xtal frequencies to sama5d3 xplained board
      ARM: at91/dt: move at91sam9261 SoC to the new main clock model
      ARM: at91/dt: define main xtal frequency of the at91sam9261ek board
      ARM: at91/dt: move at91sam9rl SoC to the new slow/main clock models
      ARM: at91/dt: define sam9rlek crystal frequencies
      ARM: sunxi: select MFD_SUN6I_PRCM when sun6i arch support is enabled

Brian Norris (1):
      ARM: imx/mxs defconfigs: add MTD_SPI_NOR (new dependency for M25P80)

Chanwoo Choi (3):
      dt-bindings: add documentation for Exynos3250 clock controller
      ARM: EXYNOS: Add Exynos3250 SoC ID
      ARM: EXYNOS: Support secondary CPU boot of Exynos3250

Cho KyongHo (1):
      clk: exynos5250: Add missing sysmmu clocks for DISP and ISP blocks

Dave Gerlach (1):
      ARM: OMAP2+: Remove suspend_set_ops from common pm late init

Denis Carikli (2):
      ARM: imx_v4_v5_defconfig: Enable drivers for i.MX25/i.MX35 USB support.
      ARM: imx_v6_v7_defconfig: Add more drm drivers.

Ezequiel Garcia (2):
      ARM: mvebu: Select HAVE_ARM_TWD only if SMP is enabled
      ARM: mvebu: Add thermal quirk for the Armada 375 DB board

Fabio Estevam (4):
      ARM: imx: Remove mx51_babbage board file
      ARM: mxs_defconfig: Select CONFIG_CRYPTO_DEV_MXS_DCP
      ARM: mx51: Remove mach-cpuimx51sd board file
      ARM: mx25: Add CLKO support

Geert Uytterhoeven (5):
      ARM: shmobile: rcar-gen2: Cache Mode Monitor Register Value
      ARM: shmobile: r8a7778/bockw: Move "select RENESAS_INTC_IRQPIN" under SoC
      ARM: shmobile: r8a7791: Use rcar_gen2_read_mode_pins() helper
      ARM: shmobile: r8a7740: Correct name of DT Ethernet clock
      ARM: shmobile: r8a7791: Correct SYS-DMAC clock defines

Georgi Djakov (1):
      ARM: debug: qcom: add UART addresses to Kconfig help for APQ8084

Gilles Chanteperdrix (1):
      ARM: imx: factor device tree timer initialization

Gregory CLEMENT (17):
      ARM: mvebu: extend the PMSU registers
      ARM: mvebu: use a separate function to set the boot address of CPUs
      ARM: mvebu: add function to set the resume boot address for Armada 375
      ARM: mvebu: add SMP support for Armada 375 and Armada 38x
      ARM: mvebu: add workaround for SMP support for Armada 375 stepping Z1
      ARM: mvebu: remove the address parameter for ll_set_cpu_coherent
      ARM: mvebu: ll_set_cpu_coherent always uses the current CPU
      ARM: mvebu: Remove the unused argument of set_cpu_coherent()
      ARM: mvebu: Split low level functions to manipulate HW coherency
      ARM: mvebu: Low level function to disable HW coherency support
      ARM: mvebu: Allow to power down L2 cache controller in idle mode
      ARM: mvebu: Add the PMSU related part of the cpu idle functions
      ARM: mvebu: Register notifier callback for the cpuidle transition
      cpuidle: mvebu: Add initial CPU idle support for Armada 370/XP SoC
      ARM: mvebu: register the cpuidle driver for the Armada XP SoCs
      ARM: mvebu: remove unnecessary ifdef around l2x0_of_init
      ARM: mvebu: fix the name of the parameter used in mvebu_get_soc_id

Heiko Stübner (1):
      ARM: rockchip: convert smp bringup to CPU_METHOD_OF_DECLARE

Iain Paton (1):
      ARM: imx6: clk: i.MX6 DualLite/Solo i2c4 clock

Ivan T. Ivanov (1):
      ARM: debug: qcom: make UART address selection configuration option

Jason Cooper (2):
      Merge branch 'mvebu/soc-pmsu' into mvebu/soc
      Merge branch 'mvebu/irqchip' into mvebu/soc

Juan Solano (1):
      ARM: i.MX27 pca100: remove deprecated IRQF_DISABLED

Kukjin Kim (6):
      Merge branch 'for_3.16/exynos5260' of git://git.kernel.org/.../tfiga/samsung-clk into v3.16-next/clk-samsung
      Merge branch 'for_3.16/clk_fixes_non_critical' of git://git.kernel.org/.../tfiga/samsung-clk into v3.16-next/clk-samsung
      Merge branch 'for_3.16/clk_cleanup' of git://git.kernel.org/.../tfiga/samsung-clk into v3.16-next/clk-samsung
      Merge branch 'for_3.16/exynos3250' of git://git.kernel.org/.../tfiga/samsung-clk into v3.16-next/clk-samsung
      Merge branch 'v3.16-next/cleanup-samsung' into v3.16-next/platform-exynos
      ARM: EXYNOS: mcpm rename the power_down_finish

Kuninori Morimoto (2):
      ARM: shmobile: r8a7778: remove old style audio clock
      ARM: shmobile: r8a7790: remove old style audio clock

Laurent Pinchart (4):
      ARM: shmobile: r8a7790: Fix the I2C clocks parents in legacy code
      ARM: shmobile: r8a7791: Fix the I2C clocks parents in legacy code
      ARM: shmobile: r8a7790: Rename VSP1_(SY|RT) clocks to VSP1_(S|R)
      ARM: shmobile: r8a7791: Rename VSP1_SY clocks to VSP1_S

Leela Krishna Amudala (2):
      ARM: EXYNOS: Add generic cpu power control functions for exynos SoCs
      ARM: EXYNOS: use generic exynos cpu power control functions

Linus Walleij (1):
      ARM: at91: localize GPIO header

Magnus Damm (15):
      ARM: shmobile: Update r8a7791 CPU freq to 1500MHz in C
      ARM: shmobile: Add shared shmobile_init_delay()
      ARM: shmobile: Remove legacy EMEV2 SoC support
      ARM: shmobile: Remove EMEV2 header file
      ARM: shmobile: Make use of r8a7790_add_standard_devices()
      ARM: shmobile: Check r8a7791 MD21 at SMP boot
      ARM: shmobile: Introduce shmobile_clk_workaround()
      ARM: shmobile: Add r8a7740 Maximum CPU Frequency to DTS
      ARM: shmobile: Use r8a7740 DT CPU Frequency in common case
      ARM: shmobile: Use r8a7740 DT CPU Frequency for Armadillo DT Ref
      ARM: shmobile: Remove unused r8a7740_init_delay()
      ARM: shmobile: Use r8a7791 DT CPU Frequency in common case
      ARM: shmobile: Use r8a7791 DT CPU Frequency for Koelsch
      ARM: shmobile: Remove unused r8a7791_init_early()
      ARM: shmobile: Use shmobile_init_late() on r8a7740

Maxime Coquelin (1):
      ARM: STi: Add STiH407 SoC support

Maxime Ripard (7):
      ARM: sunxi: Split the various SoCs support in Kconfig
      Documentation: dt: bindings: Document ARM PSCI enable method
      ARM: sun6i: Use CPU_METHOD_OF_DECLARE
      Documentation: dt: bindings: Document Allwinner A31 enable method
      ARM: sun6i: Retire the smp field in A31 machine
      ARM: sunxi: Remove reset code from the platform
      ARM: sunxi: Remove init_machine callback

Michal Simek (5):
      ARM: zynq: Add support for SOC_BUS
      ARM: zynq: Sort Kconfig options
      clocksource: cadence_ttc: Use readl/writel_relaxed instead of __raw
      ARM: zynq: Fix uart0 early console virtual address
      ARM: zynq: Enable big-endian

Naveen Krishna Chatradhi (1):
      clk: samsung: exynos5250/5420: Add gate clock for SSS module

Nicolas Ferre (1):
      ASoC: sam9g20_wm8731: remove useless mach/gpio.h

Nishanth Menon (1):
      ARM: DRA752: add detection of SoC information

Olof Johansson (26):
      Merge tag 'renesas-soc-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-clock-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc2-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/soc
      Merge tag 'mvebu-soc-orion5x-3.16' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'mvebu-soc-3.16' of git://git.infradead.org/linux-mvebu into next/soc
      Merge branch 'cleanup/kconfig' into next/soc
      Merge tag 'renesas-clock2-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc-cleanup-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'sti-soc-for-v3.16' of git://git.stlinux.com/devel/kernel/linux-sti into next/soc
      Merge tag 'sunxi-core-for-3.16' of https://github.com/mripard/linux into next/soc
      Merge tag 'imx-soc-3.16' of git://git.kernel.org/.../shawnguo/linux into next/soc
      Merge tag 'tegra-for-3.16-soc' of git://git.kernel.org/.../tegra/linux into next/soc
      Documentation: devicetree: arm: sort enable-method entries
      Merge tag 'omap-for-v3.16/soc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-for-v3.16/pm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'berlin-soc-3.16' of https://github.com/shesselba/linux-berlin into next/soc
      Merge tag 'zynq-cleanup-for-3.16' of git://git.xilinx.com/linux-xlnx into next/soc
      Merge tag 'exynos-mcpm' of http://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'samsung-clk' of http://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'samsung-clk-2' of http://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'qcom-soc-for-3.16-2' of git://git.kernel.org/.../galak/linux-qcom into next/soc
      Merge tag 'samsung-clk-3' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'samsung-exynos' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'exynos-mcpm-2' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      ARM: exynos: don't run exynos4 l2x0 setup on other platforms

Pankaj Dubey (7):
      clk/samsung: add support for pll2550xx
      clk: samsung: fixed compiler warning [-Wpointer-to-int-cast]
      clk: samsung: add new Kconfig for Samsung common clock option
      ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and ARCH_S3C64XX
      ARM: S3C24XX: move S3C24XX clock Kconfig options to Samsung clock Kconfig file
      drivers: clk: use COMMON_CLK_SAMSUNG for Samsung clock support
      ARM: EXYNOS: initial board support for exynos5260 SoC

Peter Ujfalusi (1):
      ARM: omap4: hwmod_data: Clean up audio related structures (remove/merge them)

Philipp Zabel (1):
      ARM: i.MX5: Remove outdated VPU clock lookups

Rahul Sharma (4):
      clk/samsung: add support for multiple clock providers
      clk/samsung: add support for pll2650xx
      clk/exynos5260: add macros and documentation for exynos5260
      clk/exynos5260: add clock file for exynos5260

Sachin Kamat (4):
      clk: samsung: exynos5420: Fix VPLL lock offset
      ARM: EXYNOS: Map SYSRAM through generic DT bindings
      devicetree: bindings: document SYSRAM binding
      ARM: EXYNOS: Consolidate Kconfig entries

Scott Branden (1):
      ARM: mach-bcm: add ARM_ERRATA_775420

Sebastian Hesselbarth (1):
      irqchip: orion: Reverse irq handling priority

Shaik Ameer Basha (15):
      clk: samsung: exynos5420: Rename mux parent arrays
      clk: samsung: exynos5420: add clocks for ISP block
      clk: samsung: exynos5420: update clocks for GSCL and MSCL blocks
      clk: samsung: exynos5420: fix parent clocks for mscl sysmmu
      clk: samsung: exynos5420: update clocks for G2D and G3D blocks
      clk: samsung: exynos5420: update clocks for DISP1 block
      clk: samsung: exynos5420: update clocks for PERIC block
      clk: samsung: exynos5420: update clocks for PERIS and GEN blocks
      clk: samsung: exynos5420: update clocks for WCORE block
      clk: samsung: exynos5420: update clocks for FSYS and FSYS2 blocks
      clk: samsung: exynos5420: correct sysmmu-mfc parent clocks
      clk: samsung: exynos5420: fix register offset for sclk_bpll
      clk: samsung: exynos5420: update clocks for MAU Block
      clk: samsung: exynos5420: add misc clocks
      clk: samsung: exynos5420: add more registers to restore list

Shawn Guo (10):
      ARM: imx_v6_v7_defconfig: enable cpufreq and CMA support
      ARM: imx: drop CONFIG_MMC_UNSAFE_RESUME from defconfig
      ARM: imx_v6_v7_defconfig: enable option CONFIG_LOCALVERSION_AUTO
      ARM: imx: define struct clk_gate2 on our own
      ARM: imx: lock is always valid for clk_gate2
      ARM: imx: add shared gate clock support
      ARM: imx6q: add the missing esai_ahb clock
      ARM: imx_v4_v5_defconfig: drop CONFIG_COMMON_CLK_DEBUG option
      ARM: imx: add low-level debug support for imx6sx
      ARM: imx: add basic imx6sx SoC support

Simon Horman (1):
      ARM: shmobile: Set clock frequency in HZ from OF nodes

Srinivas Kandagatla (1):
      ARM: qcom: Enable ARM_AMBA option for Qualcomm SOCs.

Stefan Agner (1):
      ARM: vf610: add UART choice for low-level debug

Sylwester Nawrocki (3):
      ARM: dts: Update camera nodes for exynos4 and exynos4412-trats2
      ARM: dts: Add rear camera nodes for exynos4412-trats2
      clk: samsung: exynos4: Use single clock ID for CLK_MDMA gate clocks

Tarek Dakhran (2):
      clk: exynos5410: register clocks using common clock framework
      ARM: EXYNOS: Add support for EXYNOS5410 SoC

Thierry Reding (1):
      ARM: tegra: Support reboot modes

Thomas Petazzoni (58):
      ARM: mvebu: prepare coherency code to support more SOCs
      ARM: mvebu: add a coherency_available() call
      bus: mvebu: pass the coherency availability information at init time
      ARM: mvebu: ARM: mvebu: use of_find_matching_node_and_match() in coherency.c
      ARM: mvebu: enable the ARM SCU on Armada 375 and Armada 38x
      ARM: mvebu: add Armada 375 support to the coherency code
      ARM: mvebu: implement Armada 375 coherency workaround
      ARM: mvebu: add Armada 38x support to the coherency code
      ARM: mvebu: introduce CPU reset code
      ARM: mvebu: start using the CPU reset driver
      ARM: mvebu: improve PMSU driver to request its resource
      ARM: orion5x: move interrupt controller node into ocp
      ARM: orion5x: switch to preprocessor includes in DT
      ARM: orion5x: use existing dt-bindings include for Device Tree files
      ARM: orion5x: convert DT to use the mvebu-mbus driver
      ARM: orion5x: add node labels in Orion5x SoC Device Tree file
      ARM: orion5x: use gpio-keys and gpio-leds instead of gpio_keys/gpio_leds in edmini_v2
      ARM: orion5x: add linux,stdout-path to edmini_v2
      ARM: orion5x: use node labels for UART and SATA on edmini_v2
      ARM: orion5x: rename XOR node to dma-controller@<address>
      ARM: orion5x: add interrupt for Ethernet in Device Tree
      ARM: orion5x: switch to use the clock driver for DT platforms
      ARM: orion5x: convert to use 'clocks' property for UART controllers
      ARM: orion: switch to a per-platform handle_irq() function
      ARM: orion5x: switch to DT interrupts and timer
      ARM: orion5x: enable pinctrl driver at SoC level
      ARM: orion5x: update I2C description at SoC level
      ARM: orion5x: add Device Bus description at SoC level
      ARM: orion5x: add standard pinctrl configs for sata0 and sata1
      ARM: orion5x: convert edmini_v2 to DT pinctrl
      ARM: orion5x: use DT to describe I2C devices on edmini_v2
      ARM: orion5x: use DT to describe EHCI on edmini_v2
      ARM: orion5x: use DT to describe NOR on edmini_v2
      ARM: orion5x: keep TODO list in edmini_v2 DT
      ARM: orion5x: remove unneeded code for edmini_v2
      ARM: orion5x: convert RD-88F5182 to Device Tree
      ARM: orion5x: convert d2net to Device Tree
      ARM: orion5x: convert Maxtor Shared Storage II to the Device Tree
      ARM: orion: remove no longer needed DT IRQ code
      ARM: orion: remove no longer needed gpio DT code
      irqchip: irq-armada-370-xp: Do the set_smp_cross_call() in the driver
      irqchip: irq-armada-370-xp: Use cpu notifier to initialize secondary CPUs
      ARM: mvebu: move Armada XP specific SMP initialization to platsmp.c
      ARM: mvebu: use CPU_METHOD_OF_DECLARE for SMP on Armada XP
      ARM: mvebu: add Armada 38x compatible string to pmsu
      ARM: mvebu: refine which files are build in mach-mvebu
      ARM: mvebu: fix thermal quirk SoC revision check
      ARM: mvebu: initialize mvebu-soc-id earlier
      ARM: mvebu: add Armada 375 A0 revision definition
      ARM: mvebu: conditionalize Armada 375 SMP workaround
      ARM: mvebu: conditionalize Armada 375 coherency workaround
      ARM: mvebu: use hardware I/O coherency also for PCI devices
      ARM: mvebu: implement L2/PCIe deadlock workaround
      ARM: mvebu: coherency: fix registration of PCI bus notifier when !PCI
      ARM: mvebu: fix big endian booting after coherency code rework
      ARM: mvebu: fix indentation of assembly instructions in coherency_ll.S
      ARM: mvebu: improve comments in coherency_ll.S
      ARM: mvebu: returns ll_get_cpuid() to ll_get_coherency_cpumask()

Tim Kryger (1):
      ARM: bcm_defconfig: Enable PWM and Backlight

Tomasz Figa (3):
      clk: samsung: Initialize clock table with error pointers
      ARM: S3C24XX: Remove omitted Kconfig selects and conditionals
      clk: samsung: exynos3250: Add clocks using common clock framework

Tomasz Stanislawski (3):
      ARM: dts: add missing pinctrls for I2C of exynos4
      ARM: dts: rename alias for i2c_ak8975 label for exynos4412-trats2
      clk: samsung: exynos4: export sclk_hdmiphy clock

Tony Lindgren (11):
      mfd: twl-core: Fix idle mode signaling for omaps when booted with device tree
      Merge tag 'ib-mfd-omap-3.16' of git://git.kernel.org/.../lee/mfd into omap-for-v3.16/pm
      ARM: dts: Fix omap serial wake-up when booted with device tree
      ARM: OMAP3: Fix idle mode signaling for sys_clkreq and sys_off_mode
      ARM: OMAP3: Disable broken omap3_set_off_timings function
      ARM: OMAP3: Fix voltage control for deeper idle states
      ARM: dts: Configure omap3 twl4030 I2C4 pins by default
      ARM: OMAP2+: Fix voltage scaling init for device tree
      ARM: dts: Enable N900 keyboard sleep leds by default
      ARM: OMAP2+: Enable CPUidle in omap2plus_defconfig
      Merge tag 'for-v3.16/hwmod-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.16/soc

Ulf Hansson (1):
      ARM: shmobile: Ignore callbacks for subsys generic_pm_domain_data

Vincent Stehlé (1):
      ARM: mvebu: Fix pmsu compilation when ARMv6 is selected


 Documentation/arm/Marvell/README                |    5 +
 Documentation/arm/sti/stih407-overview.txt      |   18 +
 .../bindings/arm/armada-370-xp-pmsu.txt         |   19 +-
 .../bindings/arm/armada-cpu-reset.txt           |   14 +
 Documentation/devicetree/bindings/arm/axxia.txt |   12 +
 .../bindings/arm/coherency-fabric.txt           |   32 +-
 Documentation/devicetree/bindings/arm/cpus.txt  |    8 +-
 .../bindings/arm/exynos/smp-sysram.txt          |   38 +
 Documentation/devicetree/bindings/arm/sti.txt   |   15 +
 .../devicetree/bindings/clock/at91-clock.txt    |  128 +-
 .../bindings/clock/exynos3250-clock.txt         |   41 +
 .../bindings/clock/exynos5260-clock.txt         |  190 ++
 .../bindings/clock/exynos5410-clock.txt         |   45 +
 .../bindings/clock/exynos5420-clock.txt         |    3 +-
 .../devicetree/bindings/clock/imx25-clock.txt   |    3 +
 .../devicetree/bindings/clock/imx27-clock.txt   |    7 +-
 .../devicetree/bindings/clock/imx6q-clock.txt   |    1 +
 .../devicetree/bindings/clock/imx6sx-clock.txt  |   13 +
 .../bindings/clock/samsung,s3c2410-clock.txt    |    2 +-
 .../bindings/power_supply/axxia-reset.txt       |   20 +
 MAINTAINERS                                     |    6 -
 arch/arm/Kconfig                                |   24 +-
 arch/arm/Kconfig.debug                          |  104 +-
 arch/arm/Makefile                               |    2 +
 arch/arm/boot/dts/Makefile                      |   10 +-
 arch/arm/boot/dts/at91-cosino_mega2560.dts      |    5 -
 arch/arm/boot/dts/at91-sama5d3_xplained.dts     |    8 +
 arch/arm/boot/dts/at91sam9261.dtsi              |   23 +-
 arch/arm/boot/dts/at91sam9261ek.dts             |    4 +
 arch/arm/boot/dts/at91sam9rl.dtsi               |   46 +-
 arch/arm/boot/dts/at91sam9rlek.dts              |    9 +
 arch/arm/boot/dts/axm5516-amarillo.dts          |   51 +
 arch/arm/boot/dts/axm5516-cpus.dtsi             |  204 ++
 arch/arm/boot/dts/axm55xx.dtsi                  |  204 ++
 arch/arm/boot/dts/exynos4.dtsi                  |   18 +-
 arch/arm/boot/dts/exynos4210-universal_c210.dts |   15 +
 arch/arm/boot/dts/exynos4210.dtsi               |   18 +
 arch/arm/boot/dts/exynos4412-trats2.dts         |   79 +-
 arch/arm/boot/dts/exynos4x12.dtsi               |   18 +
 arch/arm/boot/dts/exynos5250.dtsi               |   18 +
 arch/arm/boot/dts/exynos5420-peach-pit.dts      |  147 ++
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi       |   28 +
 arch/arm/boot/dts/exynos5420.dtsi               |   85 +-
 arch/arm/boot/dts/omap3-evm-37xx.dts            |    9 +
 arch/arm/boot/dts/omap3-ldp.dts                 |    4 +
 arch/arm/boot/dts/omap3-n900.dts                |   19 +
 arch/arm/boot/dts/omap3.dtsi                    |    6 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi       |   15 +
 arch/arm/boot/dts/omap4-sdp.dts                 |    6 +
 arch/arm/boot/dts/omap4.dtsi                    |    6 +-
 arch/arm/boot/dts/orion5x-lacie-d2-network.dts  |  236 +++
 .../dts/orion5x-lacie-ethernet-disk-mini-v2.dts |  141 +-
 .../dts/orion5x-maxtor-shared-storage-2.dts     |  178 ++
 arch/arm/boot/dts/orion5x-mv88f5182.dtsi        |   45 +
 arch/arm/boot/dts/orion5x-rd88f5182-nas.dts     |  177 ++
 arch/arm/boot/dts/orion5x.dtsi                  |  289 ++-
 arch/arm/boot/dts/r8a7740.dtsi                  |    1 +
 arch/arm/boot/dts/r8a7790.dtsi                  |    2 +-
 arch/arm/boot/dts/r8a7791.dtsi                  |    2 +-
 arch/arm/boot/dts/rk3066a.dtsi                  |    1 +
 arch/arm/boot/dts/rk3188.dtsi                   |    1 +
 arch/arm/boot/dts/sama5d3.dtsi                  |   61 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi               |    8 +
 arch/arm/boot/dts/twl4030_omap3.dtsi            |   19 +-
 arch/arm/boot/dts/zynq-7000.dtsi                |    5 +
 arch/arm/configs/at91sam9g45_defconfig          |    3 +-
 arch/arm/configs/at91sam9rl_defconfig           |    3 +-
 arch/arm/configs/axm55xx_defconfig              |  248 +++
 arch/arm/configs/bcm_defconfig                  |    3 +
 arch/arm/configs/imx_v4_v5_defconfig            |    8 +-
 arch/arm/configs/imx_v6_v7_defconfig            |   12 +-
 arch/arm/configs/mxs_defconfig                  |    7 +-
 arch/arm/configs/omap2plus_defconfig            |    8 +
 arch/arm/configs/sama5_defconfig                |    1 -
 arch/arm/include/debug/imx-uart.h               |   11 +
 arch/arm/include/debug/msm.S                    |   46 +-
 arch/arm/include/debug/vf.S                     |   15 +-
 arch/arm/include/debug/zynq.S                   |   10 +-
 arch/arm/mach-at91/at91rm9200_devices.c         |    1 +
 arch/arm/mach-at91/at91sam9260_devices.c        |   12 +-
 arch/arm/mach-at91/at91sam9261_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c        |    1 +
 arch/arm/mach-at91/at91sam9g45.c                |    2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c        |   64 +-
 arch/arm/mach-at91/at91sam9rl.c                 |    7 +
 arch/arm/mach-at91/at91sam9rl_devices.c         |   84 +-
 arch/arm/mach-at91/board-1arm.c                 |    2 +-
 arch/arm/mach-at91/board-afeb-9260v1.c          |    1 +
 arch/arm/mach-at91/board-cam60.c                |    1 +
 arch/arm/mach-at91/board-carmeva.c              |    1 +
 arch/arm/mach-at91/board-cpu9krea.c             |    1 +
 arch/arm/mach-at91/board-cpuat91.c              |    2 +
 arch/arm/mach-at91/board-csb337.c               |    2 +-
 arch/arm/mach-at91/board-csb637.c               |    1 +
 arch/arm/mach-at91/board-eb9200.c               |    1 +
 arch/arm/mach-at91/board-ecbat91.c              |    1 +
 arch/arm/mach-at91/board-eco920.c               |    2 +
 arch/arm/mach-at91/board-flexibity.c            |    1 +
 arch/arm/mach-at91/board-foxg20.c               |    1 +
 arch/arm/mach-at91/board-gsia18s.c              |    1 +
 arch/arm/mach-at91/board-kafa.c                 |    1 +
 arch/arm/mach-at91/board-kb9202.c               |    1 +
 arch/arm/mach-at91/board-pcontrol-g20.c         |    1 +
 arch/arm/mach-at91/board-picotux200.c           |    1 +
 arch/arm/mach-at91/board-rm9200ek.c             |    1 +
 arch/arm/mach-at91/board-rsi-ews.c              |    1 +
 arch/arm/mach-at91/board-sam9-l9260.c           |    1 +
 arch/arm/mach-at91/board-sam9260ek.c            |    1 +
 arch/arm/mach-at91/board-sam9261ek.c            |    1 +
 arch/arm/mach-at91/board-sam9263ek.c            |    1 +
 arch/arm/mach-at91/board-sam9g20ek.c            |    1 +
 arch/arm/mach-at91/board-sam9m10g45ek.c         |   17 +-
 arch/arm/mach-at91/board-sam9rlek.c             |   17 +-
 arch/arm/mach-at91/board-snapper9260.c          |    1 +
 arch/arm/mach-at91/board-stamp9g20.c            |    1 +
 arch/arm/mach-at91/board-yl-9200.c              |    1 +
 arch/arm/mach-at91/board.h                      |    3 -
 arch/arm/mach-at91/gpio.c                       |    1 +
 arch/arm/mach-at91/{include/mach => }/gpio.h    |    8 -
 arch/arm/mach-at91/include/mach/at91_adc.h      |  107 -
 arch/arm/mach-at91/include/mach/hardware.h      |   15 +
 arch/arm/mach-at91/leds.c                       |    1 +
 arch/arm/mach-at91/pm.c                         |    1 +
 arch/arm/mach-axxia/Kconfig                     |   16 +
 arch/arm/mach-axxia/Makefile                    |    2 +
 arch/arm/mach-axxia/axxia.c                     |   28 +
 arch/arm/mach-axxia/platsmp.c                   |   89 +
 arch/arm/mach-bcm/Kconfig                       |   12 +-
 arch/arm/mach-berlin/Kconfig                    |   10 +
 arch/arm/mach-dove/irq.c                        |   36 +
 arch/arm/mach-exynos/Kconfig                    |  100 +-
 arch/arm/mach-exynos/Makefile                   |    6 +
 arch/arm/mach-exynos/common.h                   |   36 +-
 arch/arm/mach-exynos/exynos.c                   |   70 +-
 arch/arm/mach-exynos/firmware.c                 |   16 +-
 arch/arm/mach-exynos/hotplug.c                  |    2 +-
 arch/arm/mach-exynos/include/mach/map.h         |    7 -
 arch/arm/mach-exynos/mcpm-exynos.c              |  357 ++++
 arch/arm/mach-exynos/platsmp.c                  |   67 +-
 arch/arm/mach-exynos/pm.c                       |   66 +
 arch/arm/mach-exynos/regs-pmu.h                 |   16 +-
 arch/arm/mach-imx/Kconfig                       |   69 +-
 arch/arm/mach-imx/Makefile                      |    6 +-
 arch/arm/mach-imx/avic.c                        |    4 +-
 arch/arm/mach-imx/clk-gate2.c                   |   47 +-
 arch/arm/mach-imx/clk-imx1.c                    |   41 +-
 arch/arm/mach-imx/clk-imx25.c                   |   24 +-
 arch/arm/mach-imx/clk-imx27.c                   |   27 +-
 arch/arm/mach-imx/clk-imx31.c                   |    2 -
 arch/arm/mach-imx/clk-imx51-imx53.c             |   20 +-
 arch/arm/mach-imx/clk-imx6q.c                   |   21 +-
 arch/arm/mach-imx/clk-imx6sl.c                  |    6 +-
 arch/arm/mach-imx/clk-imx6sx.c                  |  524 +++++
 arch/arm/mach-imx/clk.h                         |   13 +-
 arch/arm/mach-imx/common.h                      |   15 +-
 arch/arm/mach-imx/cpu.c                         |    3 +
 arch/arm/mach-imx/devices/platform-mx2-emma.c   |    2 +-
 arch/arm/mach-imx/eukrea_mbimxsd51-baseboard.c  |  231 --
 arch/arm/mach-imx/imx25-dt.c                    |    1 -
 arch/arm/mach-imx/imx27-dt.c                    |    1 -
 arch/arm/mach-imx/imx31-dt.c                    |    1 -
 arch/arm/mach-imx/imx35-dt.c                    |    1 -
 arch/arm/mach-imx/imx51-dt.c                    |    1 -
 arch/arm/mach-imx/mach-apf9328.c                |    1 -
 arch/arm/mach-imx/mach-armadillo5x0.c           |    1 -
 arch/arm/mach-imx/mach-bug.c                    |    1 -
 arch/arm/mach-imx/mach-cpuimx27.c               |    1 -
 arch/arm/mach-imx/mach-cpuimx35.c               |    1 -
 arch/arm/mach-imx/mach-cpuimx51sd.c             |  364 ----
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c        |    1 -
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |    1 -
 arch/arm/mach-imx/mach-imx27ipcam.c             |    1 -
 arch/arm/mach-imx/mach-imx27lite.c              |    1 -
 arch/arm/mach-imx/mach-imx50.c                  |    1 -
 arch/arm/mach-imx/mach-imx53.c                  |    1 -
 arch/arm/mach-imx/mach-imx6sx.c                 |   51 +
 arch/arm/mach-imx/mach-kzm_arm11_01.c           |    1 -
 arch/arm/mach-imx/mach-mx1ads.c                 |    2 -
 arch/arm/mach-imx/mach-mx21ads.c                |  174 +-
 arch/arm/mach-imx/mach-mx25_3ds.c               |    1 -
 arch/arm/mach-imx/mach-mx27_3ds.c               |    1 -
 arch/arm/mach-imx/mach-mx27ads.c                |    1 -
 arch/arm/mach-imx/mach-mx31_3ds.c               |    1 -
 arch/arm/mach-imx/mach-mx31ads.c                |    1 -
 arch/arm/mach-imx/mach-mx31lilly.c              |    1 -
 arch/arm/mach-imx/mach-mx31lite.c               |    1 -
 arch/arm/mach-imx/mach-mx31moboard.c            |    1 -
 arch/arm/mach-imx/mach-mx35_3ds.c               |    1 -
 arch/arm/mach-imx/mach-mx51_babbage.c           |  428 ----
 arch/arm/mach-imx/mach-mxt_td60.c               |    1 -
 arch/arm/mach-imx/mach-pca100.c                 |    4 +-
 arch/arm/mach-imx/mach-pcm037.c                 |    1 -
 arch/arm/mach-imx/mach-pcm038.c                 |    1 -
 arch/arm/mach-imx/mach-pcm043.c                 |    1 -
 arch/arm/mach-imx/mach-qong.c                   |    1 -
 arch/arm/mach-imx/mach-scb9328.c                |    1 -
 arch/arm/mach-imx/mach-vpr200.c                 |    1 -
 arch/arm/mach-imx/mxc.h                         |    6 +
 arch/arm/mach-imx/time.c                        |   15 +
 arch/arm/mach-imx/tzic.c                        |    4 +-
 arch/arm/mach-kirkwood/board-dt.c               |    2 +-
 arch/arm/mach-kirkwood/irq.c                    |   37 +
 arch/arm/mach-msm/Kconfig                       |    3 -
 arch/arm/mach-mvebu/Kconfig                     |   14 +-
 arch/arm/mach-mvebu/Makefile                    |   13 +-
 arch/arm/mach-mvebu/armada-370-xp.h             |    2 -
 arch/arm/mach-mvebu/board-t5325.c               |   41 -
 arch/arm/mach-mvebu/board-v7.c                  |   82 +-
 arch/arm/mach-mvebu/board.h                     |    6 -
 arch/arm/mach-mvebu/coherency.c                 |  340 ++-
 arch/arm/mach-mvebu/coherency.h                 |    3 +-
 arch/arm/mach-mvebu/coherency_ll.S              |  143 +-
 arch/arm/mach-mvebu/common.h                    |    3 +
 arch/arm/mach-mvebu/cpu-reset.c                 |  103 +
 arch/arm/mach-mvebu/dove.c                      |    2 +-
 arch/arm/mach-mvebu/headsmp-a9.S                |   34 +
 arch/arm/mach-mvebu/headsmp.S                   |   15 +-
 arch/arm/mach-mvebu/kirkwood.c                  |    5 +-
 arch/arm/mach-mvebu/mvebu-soc-id.c              |   32 +-
 arch/arm/mach-mvebu/mvebu-soc-id.h              |    4 +
 arch/arm/mach-mvebu/platsmp-a9.c                |  102 +
 arch/arm/mach-mvebu/platsmp.c                   |   23 +-
 arch/arm/mach-mvebu/pmsu.c                      |  273 ++-
 arch/arm/mach-mvebu/system-controller.c         |   15 +-
 arch/arm/mach-omap2/id.c                        |   37 +
 arch/arm/mach-omap2/io.c                        |    1 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      |   99 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c      |  283 +++
 arch/arm/mach-omap2/omap_twl.c                  |   60 -
 arch/arm/mach-omap2/pm.c                        |   45 +-
 arch/arm/mach-omap2/pm.h                        |    8 +-
 arch/arm/mach-omap2/pm24xx.c                    |    4 +-
 arch/arm/mach-omap2/pm34xx.c                    |   11 +-
 arch/arm/mach-omap2/pm44xx.c                    |    6 +-
 arch/arm/mach-omap2/prm-regbits-34xx.h          |   11 +-
 arch/arm/mach-omap2/soc.h                       |    5 +
 arch/arm/mach-omap2/vc.c                        |  232 +-
 arch/arm/mach-omap2/vc.h                        |    3 +
 arch/arm/mach-orion5x/Kconfig                   |   37 +-
 arch/arm/mach-orion5x/Makefile                  |    7 +-
 arch/arm/mach-orion5x/board-d2net.c             |  109 +
 arch/arm/mach-orion5x/board-dt.c                |   18 +-
 arch/arm/mach-orion5x/board-mss2.c              |   90 +
 arch/arm/mach-orion5x/board-rd88f5182.c         |  116 +
 arch/arm/mach-orion5x/common.h                  |   13 +-
 arch/arm/mach-orion5x/d2net-setup.c             |  365 ----
 arch/arm/mach-orion5x/edmini_v2-setup.c         |  169 --
 arch/arm/mach-orion5x/irq.c                     |   28 +
 arch/arm/mach-orion5x/mss2-setup.c              |  274 ---
 arch/arm/mach-qcom/Kconfig                      |    2 +
 arch/arm/mach-rockchip/core.h                   |    2 -
 arch/arm/mach-rockchip/platsmp.c                |    3 +-
 arch/arm/mach-rockchip/rockchip.c               |    1 -
 arch/arm/mach-s3c24xx/Kconfig                   |   37 +-
 arch/arm/mach-shmobile/Kconfig                  |   13 +-
 arch/arm/mach-shmobile/Makefile                 |    3 +-
 .../board-armadillo800eva-reference.c           |    2 +-
 .../arm/mach-shmobile/board-koelsch-reference.c |    2 +-
 arch/arm/mach-shmobile/board-koelsch.c          |    2 +-
 arch/arm/mach-shmobile/clock-emev2.c            |  231 --
 arch/arm/mach-shmobile/clock-r8a7740.c          |    2 +-
 arch/arm/mach-shmobile/clock-r8a7778.c          |   22 +-
 arch/arm/mach-shmobile/clock-r8a7790.c          |   32 +-
 arch/arm/mach-shmobile/clock-r8a7791.c          |   23 +-
 arch/arm/mach-shmobile/clock.c                  |   28 +
 arch/arm/mach-shmobile/include/mach/clock.h     |   16 +
 arch/arm/mach-shmobile/include/mach/common.h    |    1 +
 arch/arm/mach-shmobile/include/mach/emev2.h     |    9 -
 arch/arm/mach-shmobile/include/mach/r8a7740.h   |    1 -
 arch/arm/mach-shmobile/include/mach/r8a7791.h   |    1 -
 arch/arm/mach-shmobile/pm-rmobile.c             |   38 +-
 arch/arm/mach-shmobile/setup-emev2.c            |   11 +-
 arch/arm/mach-shmobile/setup-r8a7740.c          |    8 +-
 arch/arm/mach-shmobile/setup-r8a7790.c          |   12 +-
 arch/arm/mach-shmobile/setup-r8a7791.c          |    9 +-
 arch/arm/mach-shmobile/setup-rcar-gen2.c        |   16 +-
 arch/arm/mach-shmobile/smp-emev2.c              |    1 -
 arch/arm/mach-shmobile/smp-r8a7791.c            |   15 +-
 arch/arm/mach-shmobile/timer.c                  |   45 +
 arch/arm/mach-sti/board-dt.c                    |    1 +
 arch/arm/mach-sunxi/Kconfig                     |   38 +-
 arch/arm/mach-sunxi/common.h                    |   19 -
 arch/arm/mach-sunxi/platsmp.c                   |    3 +-
 arch/arm/mach-sunxi/sunxi.c                     |  113 +-
 arch/arm/mach-tegra/pmc.c                       |   24 +
 arch/arm/mach-zynq/Kconfig                      |   10 +-
 arch/arm/mach-zynq/common.c                     |   71 +-
 arch/arm/mach-zynq/common.h                     |    1 +
 arch/arm/mach-zynq/headsmp.S                    |    5 +-
 arch/arm/mach-zynq/slcr.c                       |   19 +
 arch/arm/plat-orion/gpio.c                      |   48 -
 arch/arm/plat-orion/include/plat/irq.h          |    1 -
 arch/arm/plat-orion/include/plat/orion-gpio.h   |    1 -
 arch/arm/plat-orion/irq.c                       |   77 -
 arch/arm/plat-samsung/Makefile                  |    3 +
 drivers/bus/mvebu-mbus.c                        |   11 +-
 drivers/clk/Kconfig                             |    2 +
 drivers/clk/Makefile                            |    2 +-
 drivers/clk/at91/Makefile                       |    4 +-
 drivers/clk/at91/clk-main.c                     |  577 ++++-
 drivers/clk/at91/clk-slow.c                     |  467 +++++
 drivers/clk/at91/pmc.c                          |   17 +
 drivers/clk/at91/pmc.h                          |    9 +
 drivers/clk/at91/sckc.c                         |   57 +
 drivers/clk/at91/sckc.h                         |   22 +
 drivers/clk/samsung/Kconfig                     |   26 +
 drivers/clk/samsung/Makefile                    |    3 +
 drivers/clk/samsung/clk-exynos3250.c            |  780 +++++++
 drivers/clk/samsung/clk-exynos4.c               |   51 +-
 drivers/clk/samsung/clk-exynos5250.c            |   76 +-
 drivers/clk/samsung/clk-exynos5260.c            | 1980 ++++++++++++++++++
 drivers/clk/samsung/clk-exynos5260.h            |  459 ++++
 drivers/clk/samsung/clk-exynos5410.c            |  209 ++
 drivers/clk/samsung/clk-exynos5420.c            | 1127 +++++++---
 drivers/clk/samsung/clk-exynos5440.c            |   18 +-
 drivers/clk/samsung/clk-pll.c                   |  223 +-
 drivers/clk/samsung/clk-pll.h                   |    2 +
 drivers/clk/samsung/clk-s3c2410.c               |   51 +-
 drivers/clk/samsung/clk-s3c2412.c               |   29 +-
 drivers/clk/samsung/clk-s3c2443.c               |   46 +-
 drivers/clk/samsung/clk-s3c64xx.c               |   44 +-
 drivers/clk/samsung/clk.c                       |  123 +-
 drivers/clk/samsung/clk.h                       |   72 +-
 drivers/clocksource/cadence_ttc_timer.c         |   54 +-
 drivers/cpuidle/Kconfig.arm                     |    5 +
 drivers/cpuidle/Makefile                        |    1 +
 drivers/cpuidle/cpuidle-armada-370-xp.c         |   93 +
 drivers/iio/adc/at91_adc.c                      |  340 ++-
 drivers/input/touchscreen/Kconfig               |   12 -
 drivers/input/touchscreen/Makefile              |    1 -
 drivers/input/touchscreen/atmel_tsadcc.c        |  358 ----
 drivers/irqchip/irq-armada-370-xp.c             |   24 +-
 drivers/irqchip/irq-orion.c                     |    4 +-
 drivers/mfd/twl-core.c                          |   15 +
 drivers/power/reset/Kconfig                     |    8 +
 drivers/power/reset/Makefile                    |    1 +
 drivers/power/reset/axxia-reset.c               |   88 +
 include/dt-bindings/clock/exynos3250.h          |  258 +++
 include/dt-bindings/clock/exynos4.h             |    2 +-
 include/dt-bindings/clock/exynos5250.h          |   21 +-
 include/dt-bindings/clock/exynos5260-clk.h      |  469 +++++
 include/dt-bindings/clock/exynos5410.h          |   33 +
 include/dt-bindings/clock/exynos5420.h          |   43 +-
 include/dt-bindings/clock/imx6sx-clock.h        |  256 +++
 include/dt-bindings/clock/lsi,axm5516-clks.h    |   36 +
 include/dt-bindings/clock/r8a7790-clock.h       |    4 +-
 include/dt-bindings/clock/r8a7791-clock.h       |    5 +-
 include/dt-bindings/pinctrl/omap.h              |   12 +
 include/linux/clk/at91_pmc.h                    |    1 +
 include/linux/mbus.h                            |    2 +-
 include/linux/platform_data/at91_adc.h          |   27 +-
 include/linux/platform_data/atmel.h             |    7 -
 sound/soc/atmel/sam9g20_wm8731.c                |    1 -
 353 files changed, 14662 insertions(+), 5149 deletions(-)
 create mode 100644 Documentation/arm/sti/stih407-overview.txt
 create mode 100644 Documentation/devicetree/bindings/arm/armada-cpu-reset.txt
 create mode 100644 Documentation/devicetree/bindings/arm/axxia.txt
 create mode 100644 Documentation/devicetree/bindings/arm/exynos/smp-sysram.txt
 create mode 100644 Documentation/devicetree/bindings/arm/sti.txt
 create mode 100644 Documentation/devicetree/bindings/clock/exynos3250-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5260-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx6sx-clock.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/axxia-reset.txt
 create mode 100644 arch/arm/boot/dts/axm5516-amarillo.dts
 create mode 100644 arch/arm/boot/dts/axm5516-cpus.dtsi
 create mode 100644 arch/arm/boot/dts/axm55xx.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5420-peach-pit.dts
 create mode 100644 arch/arm/boot/dts/orion5x-lacie-d2-network.dts
 create mode 100644 arch/arm/boot/dts/orion5x-maxtor-shared-storage-2.dts
 create mode 100644 arch/arm/boot/dts/orion5x-mv88f5182.dtsi
 create mode 100644 arch/arm/boot/dts/orion5x-rd88f5182-nas.dts
 create mode 100644 arch/arm/configs/axm55xx_defconfig
 rename arch/arm/mach-at91/{include/mach => }/gpio.h (96%)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_adc.h
 create mode 100644 arch/arm/mach-axxia/Kconfig
 create mode 100644 arch/arm/mach-axxia/Makefile
 create mode 100644 arch/arm/mach-axxia/axxia.c
 create mode 100644 arch/arm/mach-axxia/platsmp.c
 create mode 100644 arch/arm/mach-exynos/mcpm-exynos.c
 create mode 100644 arch/arm/mach-imx/clk-imx6sx.c
 delete mode 100644 arch/arm/mach-imx/eukrea_mbimxsd51-baseboard.c
 delete mode 100644 arch/arm/mach-imx/mach-cpuimx51sd.c
 create mode 100644 arch/arm/mach-imx/mach-imx6sx.c
 delete mode 100644 arch/arm/mach-imx/mach-mx51_babbage.c
 delete mode 100644 arch/arm/mach-mvebu/board-t5325.c
 create mode 100644 arch/arm/mach-mvebu/cpu-reset.c
 create mode 100644 arch/arm/mach-mvebu/headsmp-a9.S
 create mode 100644 arch/arm/mach-mvebu/platsmp-a9.c
 create mode 100644 arch/arm/mach-orion5x/board-d2net.c
 create mode 100644 arch/arm/mach-orion5x/board-mss2.c
 create mode 100644 arch/arm/mach-orion5x/board-rd88f5182.c
 delete mode 100644 arch/arm/mach-orion5x/d2net-setup.c
 delete mode 100644 arch/arm/mach-orion5x/edmini_v2-setup.c
 delete mode 100644 arch/arm/mach-orion5x/mss2-setup.c
 delete mode 100644 arch/arm/mach-shmobile/clock-emev2.c
 delete mode 100644 arch/arm/mach-shmobile/include/mach/emev2.h
 delete mode 100644 arch/arm/mach-sunxi/common.h
 create mode 100644 drivers/clk/at91/clk-slow.c
 create mode 100644 drivers/clk/at91/sckc.c
 create mode 100644 drivers/clk/at91/sckc.h
 create mode 100644 drivers/clk/samsung/Kconfig
 create mode 100644 drivers/clk/samsung/clk-exynos3250.c
 create mode 100644 drivers/clk/samsung/clk-exynos5260.c
 create mode 100644 drivers/clk/samsung/clk-exynos5260.h
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 drivers/cpuidle/cpuidle-armada-370-xp.c
 delete mode 100644 drivers/input/touchscreen/atmel_tsadcc.c
 create mode 100644 drivers/power/reset/axxia-reset.c
 create mode 100644 include/dt-bindings/clock/exynos3250.h
 create mode 100644 include/dt-bindings/clock/exynos5260-clk.h
 create mode 100644 include/dt-bindings/clock/exynos5410.h
 create mode 100644 include/dt-bindings/clock/imx6sx-clock.h
 create mode 100644 include/dt-bindings/clock/lsi,axm5516-clks.h
