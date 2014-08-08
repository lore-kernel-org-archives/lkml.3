Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbaHHQtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:49:33 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41015 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028AbaHHQrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:47:46 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 2/7] ARM: SoC platform changes for 3.17
Date: Fri,  8 Aug 2014 09:47:54 -0700
Message-Id: <1407516479-1251-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 2.0.1.473.gc4d58ca
In-Reply-To: <1407516479-1251-1-git-send-email-olof@lixom.net>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the bulk of new SoC enablement and other platform changes for 3.17:

* Samsung S5PV210 has been converted to DT and multiplatform
* Clock drivers and bindings for some of the lower-end i.MX 1/2 platforms
* Kirkwood, one of the popular Marvell platforms, is folded into the
  mvebu platform code, removing mach-kirkwood.
* Hwmod data for TI AM43xx and DRA7 platforms.
* More additions of Renesas shmobile platform support
* Removal of plat-samsung contents that can be removed with S5PV210 being
  multiplatform/DT-enabled and the other two old platforms being removed.

New platforms (most with only basic support right now):

* Hisilicon X5HD2 settop box chipset is introduced
* Mediatek MT6589 (mobile chipset) is introduced
* Broadcom BCM7xxx settop box chipset is introduced

+ as usual a lot other pieces all over the platform code.



Conflicts:

Documentation/devicetree/bindings/phy/samsung-phy.txt:
        Add/add: Keep both. s5pv210 should be at the bottom of the list 
        (sorted alphabetically). That would have avoided the conflict
        in the first place. :(

arch/arm/Kconfig:
        Remove/change: Remove ARCH_S5PV210 config entry.

arch/arm/mach-mvebu/headsmp-a9.S:
        Remove/change: Remove the conflicting chunk (mov pc,r1 -> ret 
        r1 conversion conflicted with the removal).

arch/arm/mach-shmobile/headsmp.S:
        Change/change: Keep both sides, sort the result with asm below linux.

drivers/cpuidle/Kconfig.arm:
        Add/change: Keep MPCM dependency and the TC2+EXYNOS line.

drivers/phy/phy-samsung-usb2.c:
        Add/add: Like the Doc above, keep both but sort the result. Could have
        been avoided by original patches doing it. :(
        Careful to not miss the #endif and closing },

drivers/phy/phy-samsung-usb2.h:
        Add/add: Keep both, sort.

arch/arm/mach-s5pv210/include/mach/memory.h:
        Change/remove: Just git rm the file.

----------------------------------------------------------------

The following changes since commit ea7558cd522323330d670a849c6154f73a6e08b7:

  Merge branch 'next/cleanup' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-3.17

for you to fetch changes up to c2fff85e21818952aa0ee5778926beee6c03e579:

  ARM: hisi: remove smp from machine descriptor

----------------------------------------------------------------

Abhilash Kesavan (1):
      ARM: EXYNOS: Support cluster power off on exynos5420/5800

Alex Elder (2):
      ARM: add SMP support for Broadcom mobile SoCs
      ARM: configs: enable SMP in bcm_defconfig

Alexander Shiyan (22):
      ARM: i.MX: Select HAVE_IMX_SRC for i.MX5 globally
      ARM: i.MX1 clk: Add devicetree support
      ARM: i.MX: Remove registration helper for i.MX1 USB UDC
      ARM: i.MX: Use of_clk_get_by_name() for timer clocks for DT case.
      ARM: i.MX: Remove excess variable
      ARM: i.MX27 clk: Separate DT and non-DT init procedure
      ARM: i.MX27 clk: Use of_clk_init() for DT case
      ARM: i.MX clk: Move clock check function in common location
      ARM: i.MX system: Simplify handling watchdog clock
      ARM: i.MX system: Add a reset fallback if base address of watchdog is not set
      ARM: i.MX: Remove Freescale i.MX27 IP Camera board support
      ARM: i.MX21 clk: Clock initialization rework
      ARM: i.MX21 clk: Remove clk_register_clkdev() for unused clocks
      ARM: i.MX21 clk: Cleanup driver
      ARM: i.MX21 clk: Add devicetree support
      ARM: i.MX: Remove i.MX1 camera support
      ARM: i.MX: Remove excess symbols ARCH_MX1, ARCH_MX25 and MACH_MX27
      ARM: i.MX: Remove Freescale Logic Product Development i.MX27 Lite-Kit board support
      ARM: i.MX27 clk: Introduce DT include for clock provider
      ARM: i.MX27 clk: Remove unused definitions
      ARM: i.MX27 clk: Add 26 MHz oscillator circuit clock gate
      ARM: i.MX: Use CLOCKSOURCE_OF_DECLARE() for DT targets

Andrew Lunn (2):
      ARM: Kirkwood: Add setup file for netxbig LEDs
      ARM: Kirkwood: Remove mach-kirkwood

Anson Huang (4):
      ARM: imx: add suspend support for i.mx6sx
      ARM: imx: add cpuidle support for i.mx6sx
      ARM: imx: mem bit must be cleared before entering DSM mode
      ARM: imx: add standby mode support for suspend

Antoine Ténart (1):
      ARM: berlin: add SMP support

Arnd Bergmann (17):
      ARM: shmobile: fix shmobile_smp_apmu_suspend_init build failure for !SUSPEND
      ARM: imx: imx6sx uses imx6q cpuidle code
      ARM: imx: build cpu_is_imx6sl function conditionally
      Merge tag 'v3.17-next-mediatek-support' of https://github.com/mbgg/linux-mediatek into next/soc
      ARM: mvebu: fix build without platforms selected
      Merge branch 'omap/cleanup' into next/soc
      Merge tag 'omap-for-v3.17/soc-new' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge branches 'samsung/cleanup' and 'samsung/s5p-cleanup-v2', tag 'v3.16-rc6' into next/soc
      Merge tag 'power-exynos' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 's5pv210-dt' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'misc-for-3.17' of git://github.com/hisilicon/linux-hisi into next/soc
      Merge tag 'v3.17-rockchip-smp-hotplug' of git://git.kernel.org/.../mmind/linux-rockchip into next/soc
      Merge branch 'next/fixes-non-critical' into next/soc
      Merge branch 'cleanup/gpio-header-removal' into next/soc
      Merge tag 'mvebu-soc-3.17-4' of git://git.infradead.org/linux-mvebu into next/soc
      Merge branch 'clk-rockchip' of git://git.linaro.org/people/mike.turquette/linux into next/soc
      Merge tag 'for-3.17/bcm-soc' of git://github.com/broadcom/mach-bcm into next/soc

Benoit Cousson (1):
      ARM: shmobile: Mark all SoCs in shmobile as CPUFreq, capable

Brian Norris (2):
      ARM: brcmstb: select GISB arbiter and interrupt drivers
      MAINTAINERS: add entry for Broadcom ARM STB architecture

Chander Kashyap (6):
      cpuidle: big.LITTLE: add of_device_id structure
      ARM: EXYNOS: add generic function to calculate cpu number
      cpuidle: big.LITTLE: Add ARCH_EXYNOS entry in config
      cpuidle: big.LITTLE: init driver for exynos5420
      ARM: EXYNOS: do not allow cpuidle registration for exynos5420
      ARM: EXYNOS: populate suspend and powered_up callbacks for mcpm

Chen-Yu Tsai (3):
      ARM: sunxi: Introduce Allwinner A23 support
      ARM: sunxi: Add earlyprintk support using R_UART (sun6i/sun8i)
      ARM: sunxi: select MFD_SUN6I_PRCM when sun8i arch support is enabled

Denis Carikli (2):
      ARM i.MX25 clk: Fix gpt timer clock.
      ARM: i.MX25 clk: Use of_clk_init() for DT case

Ezequiel Garcia (1):
      ARM: mvebu: Don't apply the thermal quirk if the SoC revision is unknown

Fabian Frederick (1):
      ARM: imx: use PTR_ERR_OR_ZERO

Fabio Estevam (6):
      ARM: imx: defconfig: Select CONFIG_FHANDLE
      ARM: imx_v6_v7_defconfig: Select CONFIG_SOC_IMX6SX
      ARM: clk-imx51-imx53: Remove clk_register_clkdev()
      ARM: imx_v4_v5_defconfig: Add USB device options
      ARM: mx6: Only check for 1.2GHz for mx6quad
      ARM: imx: clk-imx6sx: register SSI/SSI_IPG as shared gate clocks

Gaku Inami (3):
      ARM: shmobile: add cpufreq-cpu0 driver for common SH-Mobile
      ARM: shmobile: Remove ARCH_HAS_CPUFREQ config for shmobile
      ARM: shmobile: Remove opps table check for cpufreq

Geert Uytterhoeven (7):
      ARM: shmobile: rcar-gen2: Update for of_get_flat_dt_prop() update
      ARM: shmobile: rcar-gen2: Use "1ULL" instead of "(u64)1"
      ARM: shmobile: rcar-gen2: Remove useless copied section for LongTrail
      ARM: shmobile: r8a7779 dtsi: Update unit-addresses for clocks
      ARM: shmobile: r8a7779 dtsi: Correct #address-cells/#size-cells for clocks
      ARM: shmobile: Move r8a7779.h
      ARM: shmobile: Move r8a7791.h

Gregory CLEMENT (14):
      ARM: mvebu: Use the a standard errno in mvebu_get_soc_id
      ARM: mvebu: Use system controller to get the soc id when possible
      ARM: mvebu: split again armada_370_xp_pmsu_idle_enter() in PMSU code
      ARM: mvebu: sort the #include of pmsu.c in alphabetic order
      ARM: mvebu: add a common function for the boot address work around
      ARM: mvebu: use the common function for Armada 375 SMP workaround
      ARM: mvebu: rename the armada_370_xp symbols to mvebu_v7 in pmsu.c
      ARM: mvebu: make the cpuidle initialization more generic
      ARM: mvebu: use a local variable to store the resume address
      ARM: mvebu: make the snoop disabling optional in mvebu_v7_pmsu_idle_prepare()
      ARM: mvebu: export the SCU address
      cpuidle: mvebu: rename the driver from armada-370-xp to mvebu-v7
      ARM: mvebu: add cpuidle support for Armada 370
      ARM: mvebu: add cpuidle support for Armada 38x

Haifeng Yan (3):
      ARM: hisi: enable hix5hd2 SoC
      ARM: debug: Rename Hi3716 to HIX5HD2
      ARM: dts: Add hix5hd2-dkb dts file.

Haojian Zhuang (3):
      ARM: hisi: add ARCH_HISI
      power: reset: move hisilicon reboot code
      ARM: hisi: remove smp from machine descriptor

Heiko Stuebner (1):
      ARM: rockchip: select ARMv7 compiler flags for platsmp.o

Jason Cooper (3):
      Merge branch 'mvebu/soc-cpufreq' into mvebu/soc
      Merge branch 'mvebu/fixes' into mvebu/soc-cpuidle
      Merge branch 'mvebu/soc-cpuidle' into mvebu/soc

Kishon Vijay Abraham I (2):
      arm: dra7xx: Add hwmod data for pcie1 phy and pcie2 phy
      arm: dra7xx: Add hwmod data for pcie1 and pcie2 subsystems

Kukjin Kim (3):
      Merge branch 'v3.17-next/cleanup-samsung' into v3.17-next/dt-s5pv210
      Merge branch 'v3.17-next/cleanup-samsung' into v3.17-next/power-exynos
      Merge branch 'v3.17-next/cpuidle-exynos' into v3.17-next/power-exynos

Laurent Pinchart (1):
      ARM: shmobile: Fix device node reference leakage in shmobile_init_delay

Liu Ying (1):
      bus: imx-weim: populate devices on a simple bus

Lokesh Vutla (1):
      ARM: DRA7: hwmod: Add data for RTC

Magnus Damm (10):
      ARM: shmobile: Use shmobile_init_late() on r8a7790 DT-only
      ARM: shmobile: Use shmobile_init_late() on r8a7791 DT-only
      ARM: shmobile: Add shared R-Car Gen2 CMA reservation code
      ARM: shmobile: Allow use of boot code for non-SMP case
      ARM: shmobile: Adjust APMU code to build for non-SMP
      ARM: shmobile: Use __init for APMU suspend init function
      ARM: shmobile: Move r8a7790 reset code to pm-r8a7790.c
      ARM: shmobile: Allow r8a7790 to build non-SMP APMU code
      ARM: shmobile: Move r8a7791 reset code to pm-r8a7791.c
      ARM: shmobile: Allow r8a7791 to build non-SMP APMU code

Marc Carino (1):
      ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs

Mateusz Krawczuk (6):
      clk: samsung: Add clock driver for S5PV210 and compatible SoCs
      ARM: S5PV210: Migrate clock handling to Common Clock Framework
      phy: Add support for S5PV210 to the Exynos USB 2.0 PHY driver
      ARM: S5PV210: Add board file for boot using Device Tree
      ARM: dts: Add Device tree for s5pv210 SoC
      ARM: dts: Add Device tree for s5pc110/s5pv210 boards

Matthias Brugger (3):
      arm: add basic support for Mediatek MT6589 boards
      dt-bindings: add documentation for Mediatek SoC
      arm: mediatek: add dts for Aquaris5 mobile phone

Mugunthan V N (1):
      arm: dra7xx: Add hwmod data for MDIO and CPSW

Nishanth Menon (2):
      ARM: OMAP2+: DMA: remove requirement of irq for platform-dma driver
      ARM: DRA7: hwmod: remove interrupts for DMA

Olof Johansson (19):
      Merge tag 'renesas-clock-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-cpufreq-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-r8a7779-multiplatform-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'tegra-for-3.17-delay-timer' of git://git.kernel.org/.../tegra/linux into next/soc
      Merge tag 'versatile-for-3.17' of git://git.kernel.org/.../robh/linux into next/soc
      Merge tag 'renesas-soc-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'mvebu-soc-3.17' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'berlin-soc-3.17-1' of git://git.infradead.org/users/hesselba/linux-berlin into next/soc
      Merge tag 'renesas-r8a7779-multiplatform2-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge branch 'renesas/cleanup2' into next/soc
      Merge tag 'renesas-soc2-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc3-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-cpufreq2-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-r8a7779-multiplatform3-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-clock2-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'imx-soc-3.17' of git://git.kernel.org/.../shawnguo/linux into next/soc
      Merge tag 'sunxi-core-for-3.17' of git://git.kernel.org/.../mripard/linux into next/soc
      Merge tag 'mvebu-soc-3.17-2' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'exynos-cpuidle' of git://git.kernel.org/.../kgene/linux-samsung into next/soc

Pankaj Dubey (2):
      ARM: EXYNOS: Refactored code for using PMU address via DT
      ARM: EXYNOS: Move cpufreq and cpuidle device registration to init_machine

Paul Bolle (1):
      ARM: imx: remove unused defines

Peter De Schrijver (3):
      kernel: add calibration_delay_done()
      ARM: choose highest resolution delay timer
      clocksource: tegra: Use us counter as delay timer

Rob Herring (11):
      dts: versatile: add missing irq controller properties
      irqchip: versatile-fpga: Add IRQCHIP_DECLARE support
      irqchip: versatile-fpga: add support for arm,versatile-sic
      ARM: integrator: convert to use irqchip_init
      ARM: versatile: remove init_irq hook for DT boot
      dts: versatile: add pl180 compatible strings
      dt/bindings: arm-boards: add binding for Versatile core module
      dt/bindings: add compatible string for versatile osc clock
      ARM: timer-sp: allow getting timer1 clock from DT to fallback to legacy clock
      dts: versatile: add clock tree
      clk: versatile: add versatile OSC support

Roger Quadros (1):
      ARM: DRA7: hwmod: Add OCP2SCP3 module

Romain Perier (1):
      ARM: rockchip: Add cpu hotplug support for RK3XXX SoCs

Sachin Kamat (3):
      ARM: mvebu: Staticize armada_375_smp_cpu1_enable_wa
      ARM: mvebu: Staticize armada_370_xp_cpu_pm_init
      ARM: mvebu: Staticize mvebu_cpu_reset_init

Sathya Prakash M R (1):
      ARM: AM43xx: hwmod: add DSS hwmod data

Shawn Guo (24):
      Merge tag 'imx-fixes-3.16-2' into imx/soc
      ARM: imx: move EHCI platform defines out of platform_data header
      ARM: imx5: move SOC_IMX5 and SOC_IMX51 into 'Device tree only'
      ARM: imx5: drop option MACH_IMX51_DT
      ARM: imx5: remove imx51 non-DT support files
      ARM: imx5: remove i.MX5 non-DT device registration helpers
      ARM: imx5: make mx51_clocks_init() a DT call
      ARM: imx5: drop arguments from mx5_clocks_common_init()
      ARM: imx5: tzic_init_irq() can directly be .init_irq hook
      ARM: imx5: remove function imx51_soc_init()
      ARM: imx5: call mxc_timer_init_dt() on imx51
      ARM: imx5: retrieve iim base from device tree
      ARM: imx5: remove header crm-regs-imx5.h
      ARM: imx5: use dynamic mapping for CCM block
      ARM: imx5: use dynamic mapping for DPLL block
      ARM: imx5: reuse clock CCM mapping in pm code
      ARM: imx5: use dynamic mapping for Cortex and GPC block
      ARM: imx5: move init hooks into mach-imx5x.c
      ARM: imx5: remove file mm-imx5.c
      ARM: imx5: clean function declarations in mx51.h
      ARM: imx5: remove mx51.h and mx53.h
      ARM: imx6qdl: switch to use macro for clock ID
      ARM: imx: mark .dt_compat as const
      ARM: imx: drop PL310 errata 588369 and 727915

Silvio Fricke (2):
      ARM: imx_v6_v7_defconfig: Enable STMPE gpio support
      ARM: imx_v6_v7_defconfig: Enable flexcan driver for can support

Simon Horman (28):
      ARM: shmobile: r8a7779: Add clocks
      ARM: shmobile: Sync Marzen DTS with Marzen reference DTS
      ARM: shmobile: marzen: Specify external clock frequency in DT
      ARM: shmobile: r8a7779: Reference clocks
      ARM: shmobile: rcar-gen2: correct return value of shmobile_smp_apmu_suspend_init
      ARM: shmobile: r8a7779: Add helper to read mode pins
      ARM: shmobile: r8a7779: Move r8a7779_earlytimer_init to clock-r8a7779.c
      ARM: shmobile: marzen-reference: Move clock and OF device initialisation into board code
      ARM: shmobile: r8a7779: Initial multiplatform support
      ARM: shmobile: marzen-reference: Initialize CPG device
      ARM: shmobile: marzen-reference: Instantiate clkdevs for SCIF and TMU
      ARM: shmobile: Remove non-multiplatform Marzen reference support
      ARM: shmobile: Let Marzen multiplatform boot with Marzen DTB
      ARM: shmobile: Remove Marzen reference DTS
      ARM: shmobile: marzen-reference: Remove legacy clock support
      ARM: shmobile: r8a7779: Add Maximum CPU Frequency to DTS
      ARM: shmobile: r8a7779: Use DT CPU Frequency in common case
      ARM: shmobile: marzen-reference: Use DT CPU Frequency
      ARM: shmobile: r8a7779: Remove unused r8a7779_init_delay()
      ARM: shmobile: r8a7779: Add scif nodes to dtsi
      ARM: shmobile: marzen: Remove early_printk from command line
      ARM: shmobile: marzen: Initialise SCIF devices using DT
      ARM: shmobile: marzen: Do not use workaround for scif devices
      ARM: shmobile: marzen: Consistently use tabs for indentation
      ARM: shmobile: r8a7778: add SCI clock support for DT
      ARM: shmobile: r8a73a4: add SCI clock support for DT
      ARM: shmobile: r8a7740: correct SCI clock support for DT
      ARM: shmobile: sh73a0: add SCI clock support for DT

Stefan Agner (2):
      ARM: imx_v6_v7_defconfig: add FSL_EDMA and PRINTK_TIME
      ARM: imx: clk-vf610: fix FlexCAN clock gating

Steffen Trumtrar (2):
      ARM: i.MX: allow disabling supervisor protect via DT
      ARM: i.MX53: globally disable supervisor protect

Suman Anna (10):
      ARM: dts: OMAP2+: Add mailbox fifo and user information
      ARM: dts: OMAP4: Add mailbox node
      ARM: dts: AM33xx: Add mailbox node
      ARM: dts: AM4372: Correct mailbox node data
      ARM: dts: DRA7: Add mailbox nodes
      ARM: DRA7: hwmod_data: Add mailbox hwmod data
      ARM: OMAP2+: Avoid mailbox legacy device creation for DT-boot
      ARM: OMAP2: hwmod_data: Remove legacy mailbox data and addrs
      ARM: OMAP4: hwmod_data: Remove legacy mailbox addrs
      ARM: AM33xx: hwmod_data: Remove legacy mailbox addrs

Thomas Petazzoni (13):
      ARM: mvebu: mark armada_370_xp_pmsu_idle_prepare() as static
      ARM: mvebu: remove stub implementation of CPU hotplug on Armada 375/38x
      ARM: mvebu: slightly refactor/rename PMSU idle related functions
      ARM: mvebu: export PMSU idle enter/exit functions
      ARM: mvebu: implement CPU hotplug support for Armada XP
      Documentation: arm: add URLs to public datasheets for the Marvell Armada 370 SoC
      ARM: mvebu: ensure CPU clocks are enabled
      ARM: mvebu: extend PMSU code to support dynamic frequency scaling
      clk: mvebu: extend clk-cpu for dynamic frequency scaling
      cpuidle: mvebu: add Armada 370 support
      cpuidle: mvebu: add Armada 38x support
      Documentation: arm: add URLs to public datasheets for the Marvell Armada XP SoC
      Documentation: arm: misc updates to Marvell EBU SoC status

Tomasz Figa (13):
      cpufreq: s3c24xx: Remove some dead code
      serial: samsung: Remove support for legacy clock code
      ARM: SAMSUNG: Remove legacy clock code
      clk: samsung: Add S5PV210 Audio Subsystem clock driver
      ARM: S5PV210: Remove support for board files
      ARM: S5PV210: Untie PM support from legacy code
      ARM: S5PV210: move debug-macro.S into the common space
      ARM: S5PV210: Register cpufreq platform device
      cpufreq: s5pv210: Make the driver multiplatform aware
      ARM: S5PV210: Enable multi-platform build support
      gpio: samsung: Remove legacy support of S5PV210
      ARM: SAMSUNG: Remove remaining legacy code
      clk: samsung: s5pv210: Remove legacy board support

Tony Lindgren (2):
      Merge tag 'for-v3.17/omap-hwmod-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.17/soc
      Merge branch 'omap-for-v3.17/mailbox' into omap-for-v3.17/soc

Vincent Stehlé (1):
      ARM: shmobile: rcar-gen2: update call to dma_contiguous_reserve_area

Wei Xu (1):
      MAINTAINERS:ARM:hisi: add Hisilicon SoC family

Wei Yongjun (1):
      ARM: mvebu: fix return value check in armada_xp_pmsu_cpufreq_init()

keita kobayashi (4):
      ARM: shmobile: r8a7791 SYSC setup code
      ARM: shmobile: APMU: Add Core-Standby-state for Suspend to RAM
      ARM: shmobile: r8a7790: Support Core-Standby for Suspend to RAM
      ARM: shmobile: r8a7791: Support Core-Standby for Suspend to RAM


 Documentation/arm/Marvell/README                |   23 +-
 .../devicetree/bindings/arm/arm-boards          |    6 +
 .../bindings/arm/hisilicon/hisilicon.txt        |   11 +
 .../devicetree/bindings/arm/mediatek.txt        |    8 +
 .../bindings/clock/arm-integrator.txt           |    4 +-
 .../bindings/clock/clk-s5pv210-audss.txt        |   53 +
 .../devicetree/bindings/clock/imx1-clock.txt    |   26 +
 .../devicetree/bindings/clock/imx21-clock.txt   |   28 +
 .../devicetree/bindings/clock/imx27-clock.txt   |  127 +-
 .../devicetree/bindings/clock/imx6q-clock.txt   |  220 +--
 .../bindings/clock/mvebu-cpu-clock.txt          |    5 +-
 .../bindings/clock/samsung,s5pv210-clock.txt    |   78 +
 .../devicetree/bindings/phy/samsung-phy.txt     |    1 +
 MAINTAINERS                                     |   16 +
 arch/arm/Kconfig                                |   40 +-
 arch/arm/Kconfig.debug                          |   39 +-
 arch/arm/Makefile                               |    8 +-
 arch/arm/boot/dts/Makefile                      |   15 +-
 arch/arm/boot/dts/am33xx.dtsi                   |    9 +
 arch/arm/boot/dts/am4372.dtsi                   |    3 -
 arch/arm/boot/dts/dra7.dtsi                     |  117 ++
 arch/arm/boot/dts/hi3620.dtsi                   |    1 +
 arch/arm/boot/dts/hisi-x5hd2-dkb.dts            |   53 +
 arch/arm/boot/dts/hisi-x5hd2.dtsi               |  170 +++
 arch/arm/boot/dts/mt6589-aquaris5.dts           |   25 +
 arch/arm/boot/dts/mt6589.dtsi                   |   94 ++
 arch/arm/boot/dts/omap2420.dtsi                 |    2 +
 arch/arm/boot/dts/omap2430.dtsi                 |    2 +
 arch/arm/boot/dts/omap3.dtsi                    |    2 +
 arch/arm/boot/dts/omap4.dtsi                    |    9 +
 arch/arm/boot/dts/omap5.dtsi                    |    2 +
 arch/arm/boot/dts/r8a7779-marzen-reference.dts  |  121 --
 arch/arm/boot/dts/r8a7779-marzen.dts            |  116 +-
 arch/arm/boot/dts/r8a7779.dtsi                  |  220 +++
 arch/arm/boot/dts/s5pv210-aquila.dts            |  392 +++++
 arch/arm/boot/dts/s5pv210-goni.dts              |  449 ++++++
 arch/arm/boot/dts/s5pv210-pinctrl.dtsi          |  839 +++++++++++
 arch/arm/boot/dts/s5pv210-smdkc110.dts          |   78 +
 arch/arm/boot/dts/s5pv210-smdkv210.dts          |  238 +++
 arch/arm/boot/dts/s5pv210-torbreck.dts          |   92 ++
 arch/arm/boot/dts/s5pv210.dtsi                  |  633 ++++++++
 arch/arm/boot/dts/versatile-ab.dts              |   81 +-
 arch/arm/boot/dts/versatile-pb.dts              |   12 +-
 arch/arm/common/timer-sp.c                      |    4 +-
 arch/arm/configs/bcm_defconfig                  |    1 +
 arch/arm/configs/imx_v4_v5_defconfig            |    5 +-
 arch/arm/configs/imx_v6_v7_defconfig            |    9 +-
 arch/arm/configs/multi_v7_defconfig             |    3 +-
 arch/arm/configs/mxs_defconfig                  |    1 +
 .../debug-macro.S => include/debug/s5pv210.S}   |   23 +-
 arch/arm/lib/delay.c                            |   26 +-
 arch/arm/mach-bcm/Kconfig                       |   34 +-
 arch/arm/mach-bcm/Makefile                      |    8 +
 arch/arm/mach-bcm/brcmstb.c                     |   28 +
 arch/arm/mach-bcm/brcmstb.h                     |   19 +
 arch/arm/mach-bcm/headsmp-brcmstb.S             |   33 +
 arch/arm/mach-bcm/kona_smp.c                    |  202 +++
 arch/arm/mach-bcm/platsmp-brcmstb.c             |  363 +++++
 arch/arm/mach-berlin/Kconfig                    |    3 +
 arch/arm/mach-berlin/Makefile                   |    3 +-
 arch/arm/mach-berlin/headsmp.S                  |   30 +
 arch/arm/mach-berlin/platsmp.c                  |   99 ++
 arch/arm/mach-exynos/common.h                   |   14 +-
 arch/arm/mach-exynos/exynos.c                   |   30 +-
 arch/arm/mach-exynos/include/mach/map.h         |    3 -
 arch/arm/mach-exynos/mcpm-exynos.c              |  106 +-
 arch/arm/mach-exynos/platsmp.c                  |   22 +-
 arch/arm/mach-exynos/pm.c                       |   61 +-
 arch/arm/mach-exynos/pmu.c                      |   40 +-
 arch/arm/mach-exynos/regs-pmu.h                 |  521 +++----
 arch/arm/mach-hisi/Kconfig                      |   30 +-
 arch/arm/mach-hisi/Makefile                     |    2 +-
 arch/arm/mach-hisi/core.h                       |    5 +
 arch/arm/mach-hisi/headsmp.S                    |   16 +
 arch/arm/mach-hisi/hisilicon.c                  |   43 +-
 arch/arm/mach-hisi/hotplug.c                    |   58 +
 arch/arm/mach-hisi/platsmp.c                    |   53 +-
 arch/arm/mach-imx/Kconfig                       |   59 +-
 arch/arm/mach-imx/Makefile                      |   11 +-
 arch/arm/mach-imx/clk-imx1.c                    |  151 +-
 arch/arm/mach-imx/clk-imx21.c                   |  299 ++--
 arch/arm/mach-imx/clk-imx25.c                   |   47 +-
 arch/arm/mach-imx/clk-imx27.c                   |  452 +++---
 arch/arm/mach-imx/clk-imx31.c                   |    6 +-
 arch/arm/mach-imx/clk-imx35.c                   |    6 +-
 arch/arm/mach-imx/clk-imx51-imx53.c             |  256 ++--
 arch/arm/mach-imx/clk-imx6q.c                   |  540 ++++---
 arch/arm/mach-imx/clk-imx6sl.c                  |   11 +-
 arch/arm/mach-imx/clk-imx6sx.c                  |   25 +-
 arch/arm/mach-imx/clk-vf610.c                   |    8 +-
 arch/arm/mach-imx/clk.c                         |   10 +
 arch/arm/mach-imx/clk.h                         |    9 +
 arch/arm/mach-imx/common.h                      |   32 +-
 arch/arm/mach-imx/cpu-imx5.c                    |   25 +-
 arch/arm/mach-imx/cpu.c                         |   13 +
 arch/arm/mach-imx/cpuidle-imx6q.c               |    6 +-
 arch/arm/mach-imx/crm-regs-imx5.h               |  600 --------
 arch/arm/mach-imx/devices-imx51.h               |   66 -
 arch/arm/mach-imx/devices/Kconfig               |    9 +-
 arch/arm/mach-imx/devices/Makefile              |    2 -
 arch/arm/mach-imx/devices/devices-common.h      |   26 -
 arch/arm/mach-imx/devices/platform-fec.c        |   12 -
 .../mach-imx/devices/platform-fsl-usb2-udc.c    |    5 -
 arch/arm/mach-imx/devices/platform-imx-i2c.c    |   26 -
 arch/arm/mach-imx/devices/platform-imx-keypad.c |   10 -
 arch/arm/mach-imx/devices/platform-imx-ssi.c    |   20 -
 arch/arm/mach-imx/devices/platform-imx-uart.c   |   22 -
 arch/arm/mach-imx/devices/platform-imx2-wdt.c   |   18 -
 arch/arm/mach-imx/devices/platform-imx_udc.c    |   75 -
 arch/arm/mach-imx/devices/platform-mx1-camera.c |   42 -
 arch/arm/mach-imx/devices/platform-mxc-ehci.c   |    9 -
 arch/arm/mach-imx/devices/platform-mxc_nand.c   |    5 -
 arch/arm/mach-imx/devices/platform-mxc_rnga.c   |    5 +-
 arch/arm/mach-imx/devices/platform-pata_imx.c   |   10 -
 .../mach-imx/devices/platform-sdhci-esdhc-imx.c |   24 -
 arch/arm/mach-imx/devices/platform-spi_imx.c    |   27 -
 arch/arm/mach-imx/ehci-imx25.c                  |    1 +
 arch/arm/mach-imx/ehci-imx27.c                  |    1 +
 arch/arm/mach-imx/ehci-imx31.c                  |    1 +
 arch/arm/mach-imx/ehci-imx35.c                  |    1 +
 arch/arm/mach-imx/ehci-imx5.c                   |  171 ---
 arch/arm/mach-imx/ehci.h                        |   43 +
 arch/arm/mach-imx/gpc.c                         |    5 +-
 arch/arm/mach-imx/hardware.h                    |    2 -
 arch/arm/mach-imx/imx25-dt.c                    |    6 -
 arch/arm/mach-imx/imx27-dt.c                    |    6 -
 arch/arm/mach-imx/imx31-dt.c                    |    2 +-
 arch/arm/mach-imx/imx35-dt.c                    |    2 +-
 arch/arm/mach-imx/iomux-mx51.h                  |  827 -----------
 arch/arm/mach-imx/mach-armadillo5x0.c           |    1 +
 arch/arm/mach-imx/mach-cpuimx27.c               |    1 +
 arch/arm/mach-imx/mach-cpuimx35.c               |    1 +
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c        |    1 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |    1 +
 arch/arm/mach-imx/mach-imx27ipcam.c             |   77 -
 arch/arm/mach-imx/mach-imx27lite.c              |   83 --
 arch/arm/mach-imx/mach-imx50.c                  |    5 +-
 arch/arm/mach-imx/{imx51-dt.c => mach-imx51.c}  |   45 +-
 arch/arm/mach-imx/mach-imx53.c                  |   19 +-
 arch/arm/mach-imx/mach-imx6q.c                  |    4 +-
 arch/arm/mach-imx/mach-imx6sl.c                 |    2 +-
 arch/arm/mach-imx/mach-imx6sx.c                 |   10 +-
 arch/arm/mach-imx/mach-mx25_3ds.c               |    1 +
 arch/arm/mach-imx/mach-mx27_3ds.c               |    1 +
 arch/arm/mach-imx/mach-mx31_3ds.c               |    1 +
 arch/arm/mach-imx/mach-mx31lilly.c              |    1 +
 arch/arm/mach-imx/mach-mx31lite.c               |    1 +
 arch/arm/mach-imx/mach-mx31moboard.c            |    5 +-
 arch/arm/mach-imx/mach-mx35_3ds.c               |    1 +
 arch/arm/mach-imx/mach-pca100.c                 |    1 +
 arch/arm/mach-imx/mach-pcm037.c                 |    1 +
 arch/arm/mach-imx/mach-pcm038.c                 |    1 +
 arch/arm/mach-imx/mach-pcm043.c                 |    1 +
 arch/arm/mach-imx/mach-vf610.c                  |    2 +-
 arch/arm/mach-imx/mach-vpr200.c                 |    1 +
 arch/arm/mach-imx/mm-imx5.c                     |  155 --
 arch/arm/mach-imx/mx1-camera-fiq-ksym.c         |   18 -
 arch/arm/mach-imx/mx1-camera-fiq.S              |   35 -
 arch/arm/mach-imx/mx31moboard-devboard.c        |    5 +-
 arch/arm/mach-imx/mx31moboard-marxbot.c         |    5 +-
 arch/arm/mach-imx/mx31moboard-smartbot.c        |    5 +-
 arch/arm/mach-imx/mx51.h                        |  346 -----
 arch/arm/mach-imx/mx53.h                        |  342 -----
 arch/arm/mach-imx/mxc.h                         |    7 +
 arch/arm/mach-imx/pm-imx5.c                     |   98 +-
 arch/arm/mach-imx/pm-imx6.c                     |   67 +-
 arch/arm/mach-imx/system.c                      |   24 +-
 arch/arm/mach-imx/time.c                        |   55 +-
 arch/arm/mach-imx/tzic.c                        |    9 +-
 arch/arm/mach-integrator/integrator_ap.c        |   10 +-
 arch/arm/mach-integrator/integrator_cp.c        |   10 +-
 arch/arm/mach-kirkwood/Kconfig                  |  111 --
 arch/arm/mach-kirkwood/Makefile                 |   14 -
 arch/arm/mach-kirkwood/Makefile.boot            |    3 -
 arch/arm/mach-kirkwood/board-dt.c               |  223 ---
 arch/arm/mach-kirkwood/common.c                 |  746 ----------
 arch/arm/mach-kirkwood/common.h                 |   74 -
 arch/arm/mach-kirkwood/d2net_v2-setup.c         |  231 ---
 .../mach-kirkwood/include/mach/bridge-regs.h    |   86 --
 .../mach-kirkwood/include/mach/entry-macro.S    |   34 -
 arch/arm/mach-kirkwood/include/mach/hardware.h  |   14 -
 arch/arm/mach-kirkwood/include/mach/irqs.h      |   65 -
 arch/arm/mach-kirkwood/include/mach/kirkwood.h  |  142 --
 .../arm/mach-kirkwood/include/mach/uncompress.h |   46 -
 arch/arm/mach-kirkwood/irq.c                    |   82 --
 arch/arm/mach-kirkwood/lacie_v2-common.c        |  114 --
 arch/arm/mach-kirkwood/lacie_v2-common.h        |   16 -
 arch/arm/mach-kirkwood/mpp.c                    |   43 -
 arch/arm/mach-kirkwood/mpp.h                    |  348 -----
 arch/arm/mach-kirkwood/netxbig_v2-setup.c       |  422 ------
 arch/arm/mach-kirkwood/openrd-setup.c           |  255 ----
 arch/arm/mach-kirkwood/pcie.c                   |  296 ----
 arch/arm/mach-kirkwood/pm.c                     |   76 -
 arch/arm/mach-kirkwood/pm.h                     |   26 -
 arch/arm/mach-kirkwood/rd88f6192-nas-setup.c    |   89 --
 arch/arm/mach-kirkwood/rd88f6281-setup.c        |  128 --
 arch/arm/mach-kirkwood/t5325-setup.c            |  216 ---
 arch/arm/mach-kirkwood/ts219-setup.c            |  142 --
 arch/arm/mach-kirkwood/ts41x-setup.c            |  186 ---
 arch/arm/mach-kirkwood/tsx1x-common.c           |  113 --
 arch/arm/mach-kirkwood/tsx1x-common.h           |    7 -
 arch/arm/mach-mediatek/Kconfig                  |    6 +
 arch/arm/mach-mediatek/Makefile                 |    1 +
 .../mach/dma.h => mach-mediatek/mediatek.c}     |   25 +-
 arch/arm/mach-mvebu/Kconfig                     |   13 +
 arch/arm/mach-mvebu/Makefile                    |    4 +-
 arch/arm/mach-mvebu/armada-370-xp.h             |    2 +
 arch/arm/mach-mvebu/board-v7.c                  |   22 +-
 arch/arm/mach-mvebu/board.h                     |    5 +
 arch/arm/mach-mvebu/common.h                    |    3 +-
 arch/arm/mach-mvebu/cpu-reset.c                 |    2 +-
 arch/arm/mach-mvebu/headsmp-a9.S                |   15 -
 arch/arm/mach-mvebu/hotplug.c                   |   31 -
 arch/arm/mach-mvebu/kirkwood.c                  |    3 +
 arch/arm/mach-mvebu/mvebu-soc-id.c              |   21 +-
 arch/arm/mach-mvebu/netxbig.c                   |  191 +++
 arch/arm/mach-mvebu/platsmp-a9.c                |   45 +-
 arch/arm/mach-mvebu/platsmp.c                   |   49 +
 arch/arm/mach-mvebu/pmsu.c                      |  438 +++++-
 arch/arm/mach-mvebu/pmsu.h                      |    5 +
 arch/arm/mach-mvebu/pmsu_ll.S                   |   36 +
 arch/arm/mach-mvebu/system-controller.c         |   50 +
 arch/arm/mach-omap2/Makefile                    |    1 +
 arch/arm/mach-omap2/cm2_7xx.h                   |    4 +
 arch/arm/mach-omap2/devices.c                   |    2 +-
 arch/arm/mach-omap2/dma.c                       |    3 +
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      |   14 -
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      |   13 -
 .../omap_hwmod_2xxx_3xxx_interconnect_data.c    |    9 -
 .../omap_hwmod_2xxx_3xxx_ipblock_data.c         |   40 -
 .../omap_hwmod_33xx_43xx_interconnect_data.c    |   10 -
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c      |  100 ++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      |   10 -
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c       |  574 +++++++-
 arch/arm/mach-omap2/omap_hwmod_common_data.h    |    1 -
 .../mach-omap2/omap_hwmod_common_ipblock_data.c |   55 +
 arch/arm/mach-omap2/prcm43xx.h                  |    1 +
 arch/arm/mach-omap2/prm7xx.h                    |    4 +
 arch/arm/mach-rockchip/Makefile                 |    2 +
 arch/arm/mach-rockchip/platsmp.c                |   20 +
 arch/arm/mach-s3c24xx/common.c                  |    2 -
 arch/arm/mach-s3c24xx/iotiming-s3c2412.c        |    1 -
 arch/arm/mach-s3c24xx/mach-h1940.c              |    5 +-
 arch/arm/mach-s3c24xx/mach-jive.c               |    1 -
 arch/arm/mach-s3c24xx/mach-smdk2413.c           |    1 -
 arch/arm/mach-s3c24xx/mach-smdk2416.c           |    1 -
 arch/arm/mach-s3c24xx/mach-smdk2443.c           |    1 -
 arch/arm/mach-s3c24xx/mach-vstms.c              |    1 -
 arch/arm/mach-s3c24xx/s3c2410.c                 |    6 -
 arch/arm/mach-s3c24xx/s3c2412.c                 |    6 -
 arch/arm/mach-s3c24xx/s3c2442.c                 |    1 -
 arch/arm/mach-s3c24xx/s3c244x.c                 |    6 -
 arch/arm/mach-s3c64xx/mach-anw6410.c            |    1 -
 arch/arm/mach-s3c64xx/mach-crag6410.c           |    1 -
 arch/arm/mach-s3c64xx/mach-hmt.c                |    1 -
 arch/arm/mach-s3c64xx/mach-ncp.c                |    1 -
 arch/arm/mach-s3c64xx/mach-smartq.c             |    1 -
 arch/arm/mach-s3c64xx/mach-smdk6400.c           |    1 -
 arch/arm/mach-s3c64xx/mach-smdk6410.c           |    1 -
 arch/arm/mach-s3c64xx/s3c6400.c                 |    1 -
 arch/arm/mach-s3c64xx/s3c6410.c                 |    1 -
 arch/arm/mach-s5pv210/Kconfig                   |  197 +--
 arch/arm/mach-s5pv210/Makefile                  |   29 +-
 arch/arm/mach-s5pv210/Makefile.boot             |    2 -
 arch/arm/mach-s5pv210/clock.c                   | 1365 ------------------
 arch/arm/mach-s5pv210/common.c                  |  279 ----
 arch/arm/mach-s5pv210/common.h                  |   21 +-
 arch/arm/mach-s5pv210/dev-audio.c               |  246 ----
 arch/arm/mach-s5pv210/dma.c                     |  130 --
 .../mach-s5pv210/include/mach/gpio-samsung.h    |  135 --
 arch/arm/mach-s5pv210/include/mach/hardware.h   |   18 -
 arch/arm/mach-s5pv210/include/mach/irqs.h       |  137 --
 arch/arm/mach-s5pv210/include/mach/map.h        |  158 --
 arch/arm/mach-s5pv210/include/mach/memory.h     |   25 -
 arch/arm/mach-s5pv210/include/mach/pm-core.h    |   46 -
 arch/arm/mach-s5pv210/include/mach/regs-clock.h |    2 +-
 arch/arm/mach-s5pv210/include/mach/regs-gpio.h  |   41 -
 arch/arm/mach-s5pv210/include/mach/regs-irq.h   |   18 -
 arch/arm/mach-s5pv210/mach-aquila.c             |  688 ---------
 arch/arm/mach-s5pv210/mach-goni.c               |  917 ------------
 arch/arm/mach-s5pv210/mach-smdkc110.c           |  159 --
 arch/arm/mach-s5pv210/mach-smdkv210.c           |  338 -----
 arch/arm/mach-s5pv210/mach-torbreck.c           |  135 --
 arch/arm/mach-s5pv210/pm.c                      |  147 +-
 arch/arm/mach-s5pv210/s5pv210.c                 |   77 +
 arch/arm/mach-s5pv210/setup-fb-24bpp.c          |   49 -
 arch/arm/mach-s5pv210/setup-fimc.c              |   44 -
 arch/arm/mach-s5pv210/setup-i2c0.c              |   28 -
 arch/arm/mach-s5pv210/setup-i2c1.c              |   28 -
 arch/arm/mach-s5pv210/setup-i2c2.c              |   28 -
 arch/arm/mach-s5pv210/setup-ide.c               |   39 -
 arch/arm/mach-s5pv210/setup-keypad.c            |   24 -
 arch/arm/mach-s5pv210/setup-sdhci-gpio.c        |  103 --
 arch/arm/mach-s5pv210/setup-spi.c               |   34 -
 arch/arm/mach-s5pv210/setup-usb-phy.c           |   95 --
 .../s5p-sleep.S => mach-s5pv210/sleep.S}        |   19 +-
 arch/arm/mach-shmobile/Kconfig                  |   24 +-
 arch/arm/mach-shmobile/Makefile                 |   23 +-
 arch/arm/mach-shmobile/Makefile.boot            |    1 -
 .../arm/mach-shmobile/board-koelsch-reference.c |    4 +-
 arch/arm/mach-shmobile/board-koelsch.c          |    4 +-
 arch/arm/mach-shmobile/board-marzen-reference.c |   28 +-
 arch/arm/mach-shmobile/board-marzen.c           |    4 +-
 arch/arm/mach-shmobile/clock-r8a73a4.c          |    6 +
 arch/arm/mach-shmobile/clock-r8a7740.c          |   18 +-
 arch/arm/mach-shmobile/clock-r8a7778.c          |    6 +
 arch/arm/mach-shmobile/clock-r8a7779.c          |   23 +-
 arch/arm/mach-shmobile/clock-sh73a0.c           |    9 +
 arch/arm/mach-shmobile/common.h                 |    9 +
 arch/arm/mach-shmobile/cpufreq.c                |   17 +
 arch/arm/mach-shmobile/headsmp.S                |   13 +-
 arch/arm/mach-shmobile/platsmp-apmu.c           |   69 +-
 arch/arm/mach-shmobile/pm-r8a7779.c             |    4 +-
 arch/arm/mach-shmobile/pm-r8a7790.c             |   43 +-
 arch/arm/mach-shmobile/pm-r8a7791.c             |   73 +
 .../mach-shmobile/{include/mach => }/r8a7779.h  |    2 +-
 .../mach-shmobile/{include/mach => }/r8a7791.h  |    1 +
 arch/arm/mach-shmobile/rcar-gen2.h              |    1 +
 arch/arm/mach-shmobile/setup-r8a7779.c          |   49 +-
 arch/arm/mach-shmobile/setup-r8a7790.c          |    2 +
 arch/arm/mach-shmobile/setup-r8a7791.c          |    6 +-
 arch/arm/mach-shmobile/setup-rcar-gen2.c        |   72 +
 arch/arm/mach-shmobile/smp-r8a7779.c            |    4 +-
 arch/arm/mach-shmobile/smp-r8a7790.c            |   30 -
 arch/arm/mach-shmobile/smp-r8a7791.c            |   28 +-
 arch/arm/mach-shmobile/timer.c                  |   50 +-
 arch/arm/mach-sunxi/Kconfig                     |    8 +
 arch/arm/mach-sunxi/sunxi.c                     |    9 +
 arch/arm/mach-versatile/versatile_dt.c          |    1 -
 arch/arm/mm/Kconfig                             |    2 +-
 arch/arm/plat-omap/dma.c                        |    5 +-
 arch/arm/plat-samsung/Kconfig                   |  143 +-
 arch/arm/plat-samsung/Makefile                  |   15 -
 arch/arm/plat-samsung/clock-clksrc.c            |  212 ---
 arch/arm/plat-samsung/clock.c                   |  539 -------
 arch/arm/plat-samsung/cpu.c                     |    3 +-
 arch/arm/plat-samsung/devs.c                    |  330 -----
 arch/arm/plat-samsung/include/plat/camport.h    |   28 -
 .../plat-samsung/include/plat/clock-clksrc.h    |   83 --
 arch/arm/plat-samsung/include/plat/clock.h      |  152 --
 .../plat-samsung/include/plat/cpu-freq-core.h   |    3 -
 arch/arm/plat-samsung/include/plat/cpu.h        |   13 -
 arch/arm/plat-samsung/include/plat/devs.h       |   42 -
 arch/arm/plat-samsung/include/plat/fb-core.h    |   15 -
 arch/arm/plat-samsung/include/plat/fb.h         |   22 -
 arch/arm/plat-samsung/include/plat/fimc-core.h  |   51 -
 arch/arm/plat-samsung/include/plat/gpio-cfg.h   |   64 -
 arch/arm/plat-samsung/include/plat/hdmi.h       |   16 -
 arch/arm/plat-samsung/include/plat/irqs.h       |   72 -
 arch/arm/plat-samsung/include/plat/map-s5p.h    |    1 -
 arch/arm/plat-samsung/include/plat/mfc.h        |   35 -
 arch/arm/plat-samsung/include/plat/pll.h        |  323 -----
 arch/arm/plat-samsung/include/plat/s5p-clock.h  |   65 -
 arch/arm/plat-samsung/include/plat/sdhci.h      |   47 -
 arch/arm/plat-samsung/include/plat/tv-core.h    |   44 -
 arch/arm/plat-samsung/init.c                    |    1 -
 arch/arm/plat-samsung/pm-gpio.c                 |    4 +-
 arch/arm/plat-samsung/s5p-clock.c               |  294 ----
 arch/arm/plat-samsung/s5p-dev-mfc.c             |   81 +-
 arch/arm/plat-samsung/s5p-dev-uart.c            |   88 --
 arch/arm/plat-samsung/s5p-irq-eint.c            |  221 ---
 arch/arm/plat-samsung/s5p-irq-gpioint.c         |  218 ---
 arch/arm/plat-samsung/s5p-irq-pm.c              |   92 --
 arch/arm/plat-samsung/s5p-irq.c                 |   31 -
 arch/arm/plat-samsung/s5p-pm.c                  |   40 -
 drivers/bus/imx-weim.c                          |    4 +-
 drivers/clk/mvebu/clk-cpu.c                     |   80 +-
 drivers/clk/samsung/Makefile                    |    1 +
 drivers/clk/samsung/clk-s5pv210-audss.c         |  241 ++++
 drivers/clk/samsung/clk-s5pv210.c               |  856 +++++++++++
 drivers/clk/versatile/Makefile                  |    3 +-
 .../{clk-integrator.c => clk-versatile.c}       |   38 +-
 drivers/clocksource/tegra20_timer.c             |   13 +
 drivers/cpufreq/s3c2410-cpufreq.c               |    2 -
 drivers/cpufreq/s3c2412-cpufreq.c               |    3 -
 drivers/cpufreq/s3c2440-cpufreq.c               |    3 -
 drivers/cpufreq/s3c24xx-cpufreq.c               |    1 -
 drivers/cpufreq/s5pv210-cpufreq.c               |  131 +-
 drivers/cpuidle/Kconfig.arm                     |   14 +-
 drivers/cpuidle/Makefile                        |    2 +-
 drivers/cpuidle/cpuidle-armada-370-xp.c         |   93 --
 drivers/cpuidle/cpuidle-big_little.c            |   12 +-
 drivers/cpuidle/cpuidle-mvebu-v7.c              |  150 ++
 drivers/gpio/gpio-samsung.c                     |  240 ---
 drivers/irqchip/irq-versatile-fpga.c            |   18 +-
 drivers/phy/Kconfig                             |   10 +
 drivers/phy/Makefile                            |    1 +
 drivers/phy/phy-s5pv210-usb2.c                  |  187 +++
 drivers/phy/phy-samsung-usb2.c                  |    6 +
 drivers/phy/phy-samsung-usb2.h                  |    1 +
 drivers/power/reset/Kconfig                     |    6 +
 drivers/power/reset/Makefile                    |    1 +
 drivers/power/reset/hisi-reboot.c               |   67 +
 drivers/tty/serial/samsung.c                    |    4 -
 include/dt-bindings/clock/imx1-clock.h          |   40 +
 include/dt-bindings/clock/imx21-clock.h         |   80 +
 include/dt-bindings/clock/imx27-clock.h         |  108 ++
 include/dt-bindings/clock/imx6qdl-clock.h       |  224 +++
 include/dt-bindings/clock/s5pv210-audss.h       |   34 +
 include/dt-bindings/clock/s5pv210.h             |  239 +++
 include/dt-bindings/clock/vf610-clock.h         |    4 +-
 include/linux/mvebu-pmsu.h                      |   20 +
 include/linux/omap-dma.h                        |    1 +
 include/linux/platform_data/camera-mx1.h        |   35 -
 include/linux/platform_data/usb-ehci-mxc.h      |   46 -
 include/linux/platform_data/usb-imx_udc.h       |   23 -
 init/calibrate.c                                |   11 +
 407 files changed, 11489 insertions(+), 19492 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clk-s5pv210-audss.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx1-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx21-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
 create mode 100644 arch/arm/boot/dts/hisi-x5hd2-dkb.dts
 create mode 100644 arch/arm/boot/dts/hisi-x5hd2.dtsi
 create mode 100644 arch/arm/boot/dts/mt6589-aquaris5.dts
 create mode 100644 arch/arm/boot/dts/mt6589.dtsi
 delete mode 100644 arch/arm/boot/dts/r8a7779-marzen-reference.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-aquila.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-goni.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkc110.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkv210.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-torbreck.dts
 create mode 100644 arch/arm/boot/dts/s5pv210.dtsi
 rename arch/arm/{mach-s5pv210/include/mach/debug-macro.S => include/debug/s5pv210.S} (62%)
 create mode 100644 arch/arm/mach-bcm/brcmstb.c
 create mode 100644 arch/arm/mach-bcm/brcmstb.h
 create mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
 create mode 100644 arch/arm/mach-bcm/kona_smp.c
 create mode 100644 arch/arm/mach-bcm/platsmp-brcmstb.c
 create mode 100644 arch/arm/mach-berlin/headsmp.S
 create mode 100644 arch/arm/mach-berlin/platsmp.c
 create mode 100644 arch/arm/mach-hisi/headsmp.S
 delete mode 100644 arch/arm/mach-imx/crm-regs-imx5.h
 delete mode 100644 arch/arm/mach-imx/devices-imx51.h
 delete mode 100644 arch/arm/mach-imx/devices/platform-imx_udc.c
 delete mode 100644 arch/arm/mach-imx/devices/platform-mx1-camera.c
 delete mode 100644 arch/arm/mach-imx/ehci-imx5.c
 create mode 100644 arch/arm/mach-imx/ehci.h
 delete mode 100644 arch/arm/mach-imx/iomux-mx51.h
 delete mode 100644 arch/arm/mach-imx/mach-imx27ipcam.c
 delete mode 100644 arch/arm/mach-imx/mach-imx27lite.c
 rename arch/arm/mach-imx/{imx51-dt.c => mach-imx51.c} (51%)
 delete mode 100644 arch/arm/mach-imx/mm-imx5.c
 delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq-ksym.c
 delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq.S
 delete mode 100644 arch/arm/mach-imx/mx51.h
 delete mode 100644 arch/arm/mach-imx/mx53.h
 delete mode 100644 arch/arm/mach-kirkwood/Kconfig
 delete mode 100644 arch/arm/mach-kirkwood/Makefile
 delete mode 100644 arch/arm/mach-kirkwood/Makefile.boot
 delete mode 100644 arch/arm/mach-kirkwood/board-dt.c
 delete mode 100644 arch/arm/mach-kirkwood/common.c
 delete mode 100644 arch/arm/mach-kirkwood/common.h
 delete mode 100644 arch/arm/mach-kirkwood/d2net_v2-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/bridge-regs.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/kirkwood.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-kirkwood/irq.c
 delete mode 100644 arch/arm/mach-kirkwood/lacie_v2-common.c
 delete mode 100644 arch/arm/mach-kirkwood/lacie_v2-common.h
 delete mode 100644 arch/arm/mach-kirkwood/mpp.c
 delete mode 100644 arch/arm/mach-kirkwood/mpp.h
 delete mode 100644 arch/arm/mach-kirkwood/netxbig_v2-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/openrd-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/pcie.c
 delete mode 100644 arch/arm/mach-kirkwood/pm.c
 delete mode 100644 arch/arm/mach-kirkwood/pm.h
 delete mode 100644 arch/arm/mach-kirkwood/rd88f6192-nas-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/rd88f6281-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/t5325-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/ts219-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/ts41x-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/tsx1x-common.c
 delete mode 100644 arch/arm/mach-kirkwood/tsx1x-common.h
 create mode 100644 arch/arm/mach-mediatek/Kconfig
 create mode 100644 arch/arm/mach-mediatek/Makefile
 rename arch/arm/{mach-s5pv210/include/mach/dma.h => mach-mediatek/mediatek.c} (53%)
 delete mode 100644 arch/arm/mach-mvebu/hotplug.c
 create mode 100644 arch/arm/mach-mvebu/netxbig.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_common_ipblock_data.c
 delete mode 100644 arch/arm/mach-s5pv210/Makefile.boot
 delete mode 100644 arch/arm/mach-s5pv210/clock.c
 delete mode 100644 arch/arm/mach-s5pv210/common.c
 delete mode 100644 arch/arm/mach-s5pv210/dev-audio.c
 delete mode 100644 arch/arm/mach-s5pv210/dma.c
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/gpio-samsung.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/map.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/memory.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/pm-core.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s5pv210/mach-aquila.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-goni.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-smdkc110.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-smdkv210.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-torbreck.c
 create mode 100644 arch/arm/mach-s5pv210/s5pv210.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-fb-24bpp.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-fimc.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-i2c0.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-i2c1.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-i2c2.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-ide.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-keypad.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-sdhci-gpio.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-spi.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-usb-phy.c
 rename arch/arm/{plat-samsung/s5p-sleep.S => mach-s5pv210/sleep.S} (53%)
 create mode 100644 arch/arm/mach-shmobile/cpufreq.c
 create mode 100644 arch/arm/mach-shmobile/pm-r8a7791.c
 rename arch/arm/mach-shmobile/{include/mach => }/r8a7779.h (95%)
 rename arch/arm/mach-shmobile/{include/mach => }/r8a7791.h (90%)
 delete mode 100644 arch/arm/plat-samsung/clock-clksrc.c
 delete mode 100644 arch/arm/plat-samsung/clock.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/camport.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/clock-clksrc.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/clock.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/fimc-core.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/hdmi.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/irqs.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/mfc.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/pll.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s5p-clock.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/tv-core.h
 delete mode 100644 arch/arm/plat-samsung/s5p-clock.c
 delete mode 100644 arch/arm/plat-samsung/s5p-dev-uart.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq-eint.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq-gpioint.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq-pm.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq.c
 delete mode 100644 arch/arm/plat-samsung/s5p-pm.c
 create mode 100644 drivers/clk/samsung/clk-s5pv210-audss.c
 create mode 100644 drivers/clk/samsung/clk-s5pv210.c
 rename drivers/clk/versatile/{clk-integrator.c => clk-versatile.c} (63%)
 delete mode 100644 drivers/cpuidle/cpuidle-armada-370-xp.c
 create mode 100644 drivers/cpuidle/cpuidle-mvebu-v7.c
 create mode 100644 drivers/phy/phy-s5pv210-usb2.c
 create mode 100644 drivers/power/reset/hisi-reboot.c
 create mode 100644 include/dt-bindings/clock/imx1-clock.h
 create mode 100644 include/dt-bindings/clock/imx21-clock.h
 create mode 100644 include/dt-bindings/clock/imx27-clock.h
 create mode 100644 include/dt-bindings/clock/imx6qdl-clock.h
 create mode 100644 include/dt-bindings/clock/s5pv210-audss.h
 create mode 100644 include/dt-bindings/clock/s5pv210.h
 create mode 100644 include/linux/mvebu-pmsu.h
 delete mode 100644 include/linux/platform_data/camera-mx1.h
 delete mode 100644 include/linux/platform_data/usb-imx_udc.h
