Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3BUVNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:13:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab3BUVNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:13:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 06/09] arm-soc: soc-specific updates
Date: Thu, 21 Feb 2013 21:12:26 +0000
Message-Id: <1361481149-27559-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:usyqID22wo/NOus1EUV4pOt736eivARf+LMm5juhSJY
 bDKx7SW+Ssm083dYzSOCp7osYQz4JtbFBF6319apTu4k+rI9tm
 X3bjXg88X7o+33He/St8W1d2QLCDNxIMm0gEgYswNAtSCVHDZb
 OvkSiiggqhF7S0wH+GYowtUab5C3uLcfGB8i8ge6h8zK4bPbUK
 W+rv8fdjODeMf/X3e8dlAbkARfXFLhs6Lhr45wVVNx6Bgbu5Pg
 FKT2AoQRutUyxBHbQPH4vA7xhHR3njMUEtyEO+IzAZqAHOOhPT
 KMV9VzSul59l3Rjjh7/j9DgNi9JzdQMnyWBBH9n4PDWajTU2pv
 DYO3Txk21u6WA4ms924Q1MBNmzxfINUZ00D35mb51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39:

  Linux 3.8-rc7 (2013-02-09 08:20:39 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc

for you to fetch changes up to 9cb0d1babfcb1b4ac248c09425f7d5de1e771133:

  ARM: prima2: remove duplicate v7_invalidate_l1 (2013-02-20 18:21:58 +0100)

----------------------------------------------------------------
arm-soc: soc-specific updates

This is a larger set of new functionality for the existing SoC families,
including:

* vt8500 gains support for new CPU cores, notably the Cortex-A9 based wm8850
* prima2 gains support for the "marco" SoC family, its SMP based cousin
* tegra gains support for the new Tegra4 (Tegra114) family
* socfpga now supports a newer version of the hardware including SMP
* i.mx31 and bcm2835 are now using DT probing for their clocks
* lots of updates for sh-mobile
* OMAP updates for clocks, power management and USB
* i.mx6q and tegra now support cpuidle
* kirkwood now supports PCIe hot plugging
* tegra clock support is updated
* tegra USB PHY probing gets implemented diffently

----------------------------------------------------------------
Andrew Lunn (1):
      cpuidle: kirkwood: Move out of mach directory

Arnd Bergmann (5):
      ARM: prima2: fix __init section for cpu hotplug
      Merge tag 'renesas-soc5-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'omap-for-v3.9/usb-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      ARM: prima2: remove duplicate v7_invalidate_l1

Barry Song (10):
      ARM: PRIMA2: add CSR SiRFmarco device tree .dts
      ARM: PRIMA2: enable AUTO_ZRELADDR for SIRF in Kconfig
      ARM: PRIMA2: initialize l2x0 according to mach from DT
      ARM: PRIMA2: mv timer to timer-prima2 as we will add timer-marco
      ARM: PRIMA2: rstc: enable the support for Marco
      ARM: PRIMA2: rtciobg: it is also compatible with marco
      ARM: PRIMA2: irq: make prima2 irq can work even we enable GIC for Marco
      ARM: PRIMA2: add new SiRFmarco SMP SoC infrastructures
      ARM: PRIMA2: provide two DEBUG_LL ports for prima2 and marco
      ARM: MARCO: fix the build issue due to gic-vic-to-irqchip move

Bastian Hecht (4):
      ARM: shmobile: sh73a0: Add CPU sleep suspend
      ARM: shmobile: r8a7740: Add CPU sleep suspend
      ARM: SH-Mobile: sh73a0: Secondary CPUs handle own SCU flags
      ARM: SH-Mobile: sh73a0: Add CPU Hotplug

Dinh Nguyen (4):
      arm: socfpga: Add new device tree source for actual socfpga HW
      arm: socfpga: Add entries to enable make dtbs socfpga
      arm: Add v7_invalidate_l1 to cache-v7.S
      arm: socfpga: Add SMP support for actual socfpga harware

Dom Cobley (1):
      ARM: bcm2835: add a pm_power_off implementation

Fabio Estevam (6):
      ARM: Let CONFIG_MACH_IMX31_DT be built by default
      ARM: clk-imx31: Add dummy clock
      ARM: mx31: Replace clk_register_clkdev with clock DT lookup
      ARM: clk-imx35: Fix build warnings with W=1
      ARM: imx_v6_v7_defconfig: Select IPUV3 driver
      ARM: mxs_defconfig: Select CONFIG_DEVTMPFS_MOUNT

Gregory CLEMENT (1):
      rtc: Add support of rtc-mv for MVEBU SoCs

Guennadi Liakhovetski (3):
      ARM: sh7372: add clock lookup entries for DT-based devices
      ARM: sh7372: fix cache clean / invalidate order
      ARM: shmobile: add function declarations for sh7372 DT helper functions

Gwenhael Goavec-Merou (1):
      ARM: imx27: add a clock gate to activate SPLL clock

Hiroshi Doyu (13):
      ARM: tegra: Add CPU nodes to Tegra20 device tree
      ARM: tegra: Add CPU nodes to Tegra30 device tree
      ARM: tegra: Use DT /cpu node to detect number of CPU core
      ARM: Add API to detect SCU base address from CP15
      ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
      ARM: tegra: fuse: Add chip ID Tegra114 0x35
      ARM: dt: tegra114: Add new SoC base, Tegra114 SoC
      ARM: dt: tegra114: Add new board, Dalmore
      ARM: dt: tegra114: Add new board, Pluto
      ARM: tegra: Add initial support for Tegra114 SoC.
      ARM: tegra: add AHB entry to Tegra114 DT
      ARM: tegra: Add SMMU entry to Tegra114 DT
      ARM: tegra: Fix build error for gic update

Jason Cooper (1):
      Merge tag 'tags/mvebu_fixes_for_v3.8-rc6' into mvebu/drivers

Jason Gunthorpe (1):
      ARM: Kirkwood: Support basic hotplug for PCI-E

Jean Pihet (1):
      ARM: OMAP2+: powerdomain: fix powerdomain trace integration

Joseph Lo (6):
      ARM: tegra: add pending SGI checking API
      ARM: tegra20: cpuidle: add powered-down state for secondary CPU
      clk: tegra20: Implementing CPU low-power function for tegra_cpu_car_ops
      ARM: tegra20: flowctrl: add support for cpu_suspend_enter/exit
      ARM: tegra20: cpuidle: apply coupled cpuidle for powered-down mode
      ARM: tegra: add Tegra114 ARM_CPUIDLE_WFI_STATE support

Kuninori Morimoto (3):
      ARM: shmobile: r8a7740: add TMU timer support
      ARM: shmobile: sh73a0: fixup div4_clks bitmap
      ARM: shmobile: r8a7779: scif .irqs used SCIx_IRQ_MUXED()

Laxman Dewangan (3):
      ARM: tegra114: select PINCTRL for Tegra114 SoC
      ARM: DT: tegra114: add GPIO DT entry
      ARM: DT: tegra114: add pinmux DT entry

Magnus Damm (2):
      ARM: mach-shmobile: sh73a0 external IRQ wake update
      ARM: shmobile: Register ARM architected timer

Marek Vasut (1):
      ARM: mxs: Update mxs_defconfig

Olof Johansson (25):
      Merge tag 'armsoc-3.9' of git://server.prisktech.co.nz/git/linuxwmt into next/soc
      Merge branch 'vt8500/wm8x50' into next/soc
      Merge branch 'depends/cleanup' into next/soc
      Merge branch 'marco-timer-cleanup-rebase' of git://gitorious.org/sirfprima2-kernel/sirfprima2-kernel into next/soc
      Merge tag 'imx-soc' of git://git.pengutronix.de/git/imx/linux-2.6 into next/soc
      Merge branch 'soc' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'davinci-for-v3.9/soc' of git://gitorious.org/linux-davinci/linux-davinci into next/soc
      Merge tag 'bcm2835-for-3.9-soc' of git://git.kernel.org/.../swarren/linux-rpi into next/soc
      Merge tag 'renesas-soc2-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'imx6q-cpudile-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge tag 'v3.8-rc6' into next/soc
      Merge tag 'drivers_for_v3.9' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge tag 'renesas-soc3-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'tegra-for-3.9-soc-ccf' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'tegra-for-3.9-soc-usb' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'tegra-for-3.9-soc-cpuidle' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'tegra-for-3.9-soc-t114' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      ARM: tegra: remove empty tegra_smp_init_cpus()
      Merge tag 'omap-for-v3.9/pm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'imx-soc-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge tag 'renesas-soc4-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/soc
      ARM: tegra: Fix build error w/ ARCH_TEGRA_114_SOC w/o ARCH_TEGRA_3x_SOC
      Merge branch 'tegra/t114' into next/soc
      Merge tag 'mxs-soc-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge branch 'socfpga/hw' into next/soc

Paul Walmsley (19):
      ARM: OMAP2+: omap_device: remove obsolete pm_lats and early_device code
      ARM: OMAP4: clock/hwmod data: start to remove some IP block control "clocks"
      ARM: OMAP4: clock/hwmod data: remove MODULEMODE entries in mux + gate combos
      ARM: OMAP2xxx: clock data: clean up unused null clocks
      ARM: OMAP2xxx: powerdomain: core powerdomain missing logic retention states
      ARM: OMAP3xxx: CPUIdle: simplify the PER next-state code
      ARM: OMAP2+: hwmod: add support for blocking WFI when a device is active
      ARM: OMAP2420: hwmod data/PM: use hwmod to block WFI when I2C active
      ARM: OMAP3xxx: CPUIdle: optimize __omap3_enter_idle()
      ARM: OMAP4: MPUSS PM: remove unnecessary shim functions for powerdomain control
      ARM: OMAP2+: clockdomain: add pwrdm_state_switch() call to clkdm_sleep()
      ARM: OMAP2xxx: PM: clean up some crufty powerstate programming code
      ARM: OMAP2: PM/powerdomain: drop unnecessary pwrdm_wait_transition()
      ARM: OMAP2+: PM/powerdomain: move omap_set_pwrdm_state() to powerdomain code
      ARM: OMAP2+: powerdomain/clockdomain: add a per-powerdomain spinlock
      ARM: OMAP2xxx: CM: remove autodep handling
      ARM: OMAP2+: clockdomain: work on wkdep/sleepdep functions
      ARM: OMAP2+: clockdomain: convert existing atomic usecounts into spinlock-protected shorts/ints
      ARM: OMAP2+: powerdomain: fix whitespace, improve flag comments

Prashant Gaikwad (18):
      ARM: tegra: add function to read chipid
      ARM: tegra: move tegra_cpu_car.h to linux/clk/tegra.h
      ARM: tegra: define Tegra30 CAR binding
      clk: tegra: add Tegra specific clocks
      clk: tegra: add clock support for Tegra20
      clk: tegra: add clock support for Tegra30
      ARM: tegra: migrate to new clock code
      ARM: tegra: remove legacy clock code
      spi: tegra: do not use clock name to get clock
      ARM: tegra: add clock properties to Tegra20 DT
      ARM: tegra: add clock properties to Tegra30 DT
      ARM: tegra: paz00: add clock information to DT
      staging: nvec: remove use of clk_get_sys
      ASoC: tegra: remove auxdata
      ARM: tegra20: remove auxdata
      ARM: tegra30: remove auxdata
      clk: tegra20: remove unused TEGRA_CLK_DUPLICATE()s
      clk: tegra30: remove unused TEGRA_CLK_DUPLICATE()s

Robert Tivy (4):
      ARM: davinci: devices-da8xx.c: change pr_warning() to pr_warn()
      ARM: davinci: psc.c: change pr_warning() to pr_warn()
      ARM: davinci: psc: introduce reset API
      ARM: davinci: da850: add dsp clock definition

Roger Quadros (2):
      ARM: OMAP: Consolidate OMAP USB-HS platform data (part 1/3)
      ARM: OMAP: Consolidate OMAP USB-HS platform data (part 3/3)

Sachin Kamat (1):
      ARM: shmobile: Remove duplicate inclusion of dma-mapping.h in setup-r8a7740.c

Santosh Shilimkar (1):
      ARM: OMAP: Make use of available scu_a9_get_base() interface

Shawn Guo (9):
      Merge tag 'imx-cleanup-3.9' into imx6q-cpuidle
      ARM: imx: return zero in case next event gets a large increment
      ARM: imx: mask gpc interrupts initially
      ARM: imx: move imx6q_cpuidle_driver into a separate file
      ARM: imx6q: support WAIT mode using cpuidle
      Merge tag 'imx-cleanup-3.9' into imx/soc
      ARM: imx: use separated debug uart symbol for imx31 and imx35
      ARM: imx: support DEBUG_LL uart port selection for all i.MX SoCs
      ARM: imx_v6_v7_defconfig: enable anatop regulator and snvs rtc

Simon Horman (8):
      Merge remote-tracking branches 'arm-soc/irqchip/gic-vic-move' and 'arm-soc/timer/cleanup' into soc
      ARM: mach-shmobile: sh73a0: Allow initialisation of GIC by DT
      ARM: mach-shmobile: sh73a0: Minimal setup using DT
      ARM: mach-shmobile: sh73a0: Initialise MMCIF using DT
      ARM: mach-shmobile: sh73a0:  Add reg and device_type properties to cpus
      ARM: mach-shmobile: emev2:  Add reg and device_type properties to cpus
      ARM: shmobile: r8a7779: Correct TMU clock support
      ARM: shmobile: r8a7779: Correct TMU clock support again

Stephen Warren (8):
      clk: bcm2835: probe for fixed-clock in device tree
      Merge remote-tracking branch 'korg_arm-soc/depends/rmk-perf' into for-3.9/scu-base-rework
      ARM: tegra: define Tegra20 CAR binding
      ARM: tegra: add clocks properties to USB PHY nodes
      usb: host: tegra: don't touch EMC clock
      Merge branch 'for-3.9/scu-base-rework' into for-3.9/soc-t114
      ARM: tegra: enable ARCH_REQUIRE_GPIOLIB for Tegra114
      ARM: tegra: sort Kconfig selects for Tegra114

Tony Lindgren (3):
      Merge tag 'omap-cleanup-a-for-3.9' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9/pm
      Merge tag 'omap-cleanup-b-for-3.9' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9/pm
      Merge branch 'usbhost17-for-arm-soc' of git://github.com/rogerq/linux into omap-for-v3.9/usb

Tony Prisk (2):
      arm: vt8500: Add support for Wondermedia WM8750/WM8850
      dts: vt8500: Add initial dts support for WM8850

Torben Hohn (2):
      ARM: mxs: use apbx bus clock to drive the timers on timrotv2
      ARM: mxs: decrease mxs_clockevent_device.min_delta_ns to 2 clock cycles

Ulrich Hecht (2):
      ARM: mach-shmobile: add shmobile_cpu_disable_any()
      ARM: mach-shmobile: sh73a0: allow unplugging of CPU0

Venu Byravarasu (11):
      ARM: tegra: remove USB address related macros from iomap.h
      usb: phy: use kzalloc to allocate struct tegra_usb_phy
      ARM: tegra: Add new DT property to USB node.
      usb: host: tegra: Resetting PORT0 based on information received via DT.
      usb: phy: remove unused APIs from Tegra PHY.
      ARM: tegra: add DT nodes for Tegra USB PHY
      USB: PHY: tegra: get rid of instance number to differentiate legacy controller
      USB: PHY: tegra: Get rid of instance number to differentiate PHY type
      usb: add APIs to access host registers from Tegra PHY
      ARM: tegra: Add reset GPIO information to PHY DT node
      usb: host: tegra: make use of PHY pointer of HCD

Vivien Didelot (1):
      ARM: davinci: da8xx_register_spi() should not register SPI board info

 .../bindings/arm/altera/socfpga-system.txt         |    2 +
 Documentation/devicetree/bindings/arm/sirf.txt     |   10 +-
 Documentation/devicetree/bindings/arm/vt8500.txt   |    8 +
 .../devicetree/bindings/clock/imx31-clock.txt      |   91 +
 .../bindings/clock/nvidia,tegra20-car.txt          |  205 ++
 .../bindings/clock/nvidia,tegra30-car.txt          |  262 ++
 .../bindings/usb/nvidia,tegra20-ehci.txt           |    3 +
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   17 +
 arch/arm/Kconfig                                   |    2 +
 arch/arm/Kconfig.debug                             |   45 +-
 arch/arm/arm-soc-for-next-contents.txt             |   21 +-
 arch/arm/boot/dts/Makefile                         |   10 +-
 arch/arm/boot/dts/emev2.dtsi                       |    7 +
 arch/arm/boot/dts/imx31.dtsi                       |   17 +
 arch/arm/boot/dts/marco-evb.dts                    |   54 +
 arch/arm/boot/dts/marco.dtsi                       |  756 ++++++
 arch/arm/boot/dts/sh73a0-reference.dtsi            |   24 +
 arch/arm/boot/dts/sh73a0.dtsi                      |  100 +
 arch/arm/boot/dts/socfpga.dtsi                     |   22 +-
 arch/arm/boot/dts/socfpga_cyclone5.dts             |   34 +-
 arch/arm/boot/dts/socfpga_vt.dts                   |   64 +
 arch/arm/boot/dts/tegra114-dalmore.dts             |   21 +
 arch/arm/boot/dts/tegra114-pluto.dts               |   21 +
 arch/arm/boot/dts/tegra114.dtsi                    |  153 ++
 arch/arm/boot/dts/tegra20-harmony.dts              |    4 +
 arch/arm/boot/dts/tegra20-paz00.dts                |    6 +
 arch/arm/boot/dts/tegra20-seaboard.dts             |    4 +
 arch/arm/boot/dts/tegra20-trimslice.dts            |    4 +
 arch/arm/boot/dts/tegra20-ventana.dts              |    4 +
 arch/arm/boot/dts/tegra20.dtsi                     |   96 +
 arch/arm/boot/dts/tegra30.dtsi                     |   91 +-
 arch/arm/boot/dts/wm8850-w70v2.dts                 |   47 +
 arch/arm/boot/dts/wm8850.dtsi                      |  224 ++
 arch/arm/configs/imx_v6_v7_defconfig               |    8 +
 arch/arm/configs/kirkwood_defconfig                |    1 +
 arch/arm/configs/mxs_defconfig                     |   64 +-
 arch/arm/configs/prima2_defconfig                  |    3 +
 arch/arm/include/asm/smp_scu.h                     |   17 +
 arch/arm/include/debug/imx-uart.h                  |   88 +
 arch/arm/include/debug/imx.S                       |   29 +-
 arch/arm/mach-bcm2835/bcm2835.c                    |   28 +
 arch/arm/mach-davinci/board-da830-evm.c            |    9 +-
 arch/arm/mach-davinci/board-da850-evm.c            |    9 +-
 arch/arm/mach-davinci/board-mityomapl138.c         |    9 +-
 arch/arm/mach-davinci/clock.c                      |   39 +-
 arch/arm/mach-davinci/clock.h                      |    3 +
 arch/arm/mach-davinci/da850.c                      |   17 +
 arch/arm/mach-davinci/devices-da8xx.c              |   16 +-
 arch/arm/mach-davinci/include/mach/clock.h         |    3 +
 arch/arm/mach-davinci/include/mach/da8xx.h         |    4 +-
 arch/arm/mach-davinci/include/mach/psc.h           |    3 +
 arch/arm/mach-davinci/psc.c                        |   29 +-
 arch/arm/mach-imx/Makefile                         |    6 +-
 arch/arm/mach-imx/clk-imx27.c                      |    7 +-
 arch/arm/mach-imx/clk-imx31.c                      |   15 +-
 arch/arm/mach-imx/clk-imx35.c                      |    4 +-
 arch/arm/mach-imx/clk-imx6q.c                      |   12 +
 arch/arm/mach-imx/common.h                         |    3 +
 arch/arm/mach-imx/cpuidle-imx6q.c                  |   95 +
 arch/arm/mach-imx/cpuidle.h                        |    5 +
 arch/arm/mach-imx/gpc.c                            |    5 +
 arch/arm/mach-imx/headsmp.S                        |   47 -
 arch/arm/mach-imx/imx31-dt.c                       |   17 +-
 arch/arm/mach-imx/mach-imx6q.c                     |   17 +-
 arch/arm/mach-imx/platsmp.c                        |   10 +
 arch/arm/mach-imx/time.c                           |    3 +-
 arch/arm/mach-kirkwood/Makefile                    |    1 -
 arch/arm/mach-kirkwood/board-dt.c                  |    2 +
 arch/arm/mach-kirkwood/common.c                    |   23 +
 arch/arm/mach-kirkwood/common.h                    |    1 +
 arch/arm/mach-kirkwood/include/mach/kirkwood.h     |    3 +-
 arch/arm/mach-kirkwood/pcie.c                      |   10 +-
 arch/arm/mach-mxs/timer.c                          |   12 +-
 arch/arm/mach-omap2/am35xx-emac.c                  |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    2 +-
 arch/arm/mach-omap2/board-3630sdp.c                |    2 +-
 arch/arm/mach-omap2/board-am3517crane.c            |    2 +-
 arch/arm/mach-omap2/board-am3517evm.c              |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |    2 +-
 arch/arm/mach-omap2/board-cm-t3517.c               |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c             |    2 +-
 arch/arm/mach-omap2/board-igep0020.c               |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c             |    2 +-
 arch/arm/mach-omap2/board-overo.c                  |    2 +-
 arch/arm/mach-omap2/board-zoom.c                   |    2 +-
 arch/arm/mach-omap2/cclock2420_data.c              |   16 +-
 arch/arm/mach-omap2/cclock2430_data.c              |   16 +-
 arch/arm/mach-omap2/cclock44xx_data.c              |  578 +----
 arch/arm/mach-omap2/clockdomain.c                  |  569 +++--
 arch/arm/mach-omap2/clockdomain.h                  |   17 +-
 arch/arm/mach-omap2/cm2xxx.c                       |   33 +-
 arch/arm/mach-omap2/cm3xxx.c                       |   14 +-
 arch/arm/mach-omap2/cminst44xx.c                   |    2 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |   79 +-
 arch/arm/mach-omap2/devices.c                      |   25 +-
 arch/arm/mach-omap2/display.c                      |    2 +-
 arch/arm/mach-omap2/dma.c                          |    2 +-
 arch/arm/mach-omap2/drm.c                          |    3 +-
 arch/arm/mach-omap2/gpio.c                         |    3 +-
 arch/arm/mach-omap2/gpmc.c                         |    2 +-
 arch/arm/mach-omap2/hdq1w.c                        |    2 +-
 arch/arm/mach-omap2/hsmmc.c                        |    2 +-
 arch/arm/mach-omap2/hwspinlock.c                   |    3 +-
 arch/arm/mach-omap2/i2c.c                          |    3 +-
 arch/arm/mach-omap2/mcbsp.c                        |    2 +-
 arch/arm/mach-omap2/msdi.c                         |    2 +-
 arch/arm/mach-omap2/omap-iommu.c                   |    3 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |   44 +-
 arch/arm/mach-omap2/omap-smp.c                     |    2 +-
 arch/arm/mach-omap2/omap44xx.h                     |    1 -
 arch/arm/mach-omap2/omap_device.c                  |  537 +----
 arch/arm/mach-omap2/omap_device.h                  |   79 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |    8 +
 arch/arm/mach-omap2/omap_hwmod.h                   |    9 +
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |    7 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   99 +-
 arch/arm/mach-omap2/pm-debug.c                     |    6 +-
 arch/arm/mach-omap2/pm.c                           |   69 +-
 arch/arm/mach-omap2/pm.h                           |    1 -
 arch/arm/mach-omap2/pm24xx.c                       |   43 +-
 arch/arm/mach-omap2/pmu.c                          |    3 +-
 arch/arm/mach-omap2/powerdomain.c                  |  232 +-
 arch/arm/mach-omap2/powerdomain.h                  |   52 +-
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c   |    4 +-
 arch/arm/mach-omap2/powerdomains2xxx_data.c        |    9 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c        |   44 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |    3 +-
 arch/arm/mach-omap2/serial.c                       |    3 +-
 arch/arm/mach-omap2/sr_device.c                    |    3 +-
 arch/arm/mach-omap2/timer.c                        |    3 +-
 arch/arm/mach-omap2/usb-host.c                     |   41 +-
 arch/arm/mach-omap2/usb-musb.c                     |    2 +-
 arch/arm/mach-omap2/usb.h                          |   20 +-
 arch/arm/mach-omap2/wd_timer.c                     |    3 +-
 arch/arm/mach-prima2/Kconfig                       |   10 +
 arch/arm/mach-prima2/Makefile                      |    5 +-
 arch/arm/mach-prima2/common.c                      |   33 +-
 arch/arm/mach-prima2/common.h                      |   15 +-
 arch/arm/mach-prima2/headsmp.S                     |   40 +
 arch/arm/mach-prima2/hotplug.c                     |   41 +
 arch/arm/mach-prima2/include/mach/irqs.h           |    4 +-
 arch/arm/mach-prima2/include/mach/uart.h           |    6 +
 arch/arm/mach-prima2/include/mach/uncompress.h     |    3 +
 arch/arm/mach-prima2/irq.c                         |   16 +-
 arch/arm/mach-prima2/l2x0.c                        |   29 +-
 arch/arm/mach-prima2/platsmp.c                     |  157 ++
 arch/arm/mach-prima2/rstc.c                        |   45 +-
 arch/arm/mach-prima2/rtciobrg.c                    |    1 +
 arch/arm/mach-prima2/timer-marco.c                 |  316 +++
 arch/arm/mach-prima2/{timer.c => timer-prima2.c}   |    6 +-
 arch/arm/mach-shmobile/Makefile                    |    3 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |    2 +
 arch/arm/mach-shmobile/board-kzm9g.c               |    2 +
 arch/arm/mach-shmobile/clock-r8a7740.c             |    6 +-
 arch/arm/mach-shmobile/clock-r8a7779.c             |    1 +
 arch/arm/mach-shmobile/clock-sh7372.c              |    9 +
 arch/arm/mach-shmobile/clock-sh73a0.c              |   35 +-
 arch/arm/mach-shmobile/headsmp-sh73a0.S            |   50 +
 arch/arm/mach-shmobile/headsmp.S                   |   48 -
 arch/arm/mach-shmobile/hotplug.c                   |    6 +
 arch/arm/mach-shmobile/include/mach/common.h       |    9 +
 arch/arm/mach-shmobile/intc-sh73a0.c               |   16 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |   22 +
 arch/arm/mach-shmobile/pm-sh73a0.c                 |   32 +
 arch/arm/mach-shmobile/setup-r8a7740.c             |   95 +-
 arch/arm/mach-shmobile/setup-r8a7779.c             |   18 +-
 arch/arm/mach-shmobile/setup-sh73a0.c              |   62 +-
 arch/arm/mach-shmobile/sleep-sh7372.S              |   12 +-
 arch/arm/mach-shmobile/smp-sh73a0.c                |   68 +-
 arch/arm/mach-shmobile/timer.c                     |    3 +
 arch/arm/mach-socfpga/core.h                       |    4 +-
 arch/arm/mach-socfpga/headsmp.S                    |   16 +-
 arch/arm/mach-socfpga/platsmp.c                    |   17 +-
 arch/arm/mach-socfpga/socfpga.c                    |    7 +-
 arch/arm/mach-tegra/Kconfig                        |   15 +-
 arch/arm/mach-tegra/Makefile                       |    9 +-
 arch/arm/mach-tegra/board-dt-tegra114.c            |   46 +
 arch/arm/mach-tegra/board-dt-tegra20.c             |   60 +-
 arch/arm/mach-tegra/board-dt-tegra30.c             |   62 +-
 arch/arm/mach-tegra/board.h                        |    2 +
 arch/arm/mach-tegra/clock.c                        |  166 --
 arch/arm/mach-tegra/clock.h                        |  153 --
 arch/arm/mach-tegra/common.c                       |   69 +-
 arch/arm/mach-tegra/cpu-tegra.c                    |    2 +-
 arch/arm/mach-tegra/cpuidle-tegra114.c             |   61 +
 arch/arm/mach-tegra/cpuidle-tegra20.c              |  197 +-
 arch/arm/mach-tegra/cpuidle-tegra30.c              |    2 +-
 arch/arm/mach-tegra/cpuidle.c                      |    3 +
 arch/arm/mach-tegra/cpuidle.h                      |    6 +
 arch/arm/mach-tegra/flowctrl.c                     |   38 +-
 arch/arm/mach-tegra/flowctrl.h                     |    4 +
 arch/arm/mach-tegra/fuse.c                         |    8 +-
 arch/arm/mach-tegra/fuse.h                         |    1 +
 arch/arm/mach-tegra/headsmp.S                      |   43 -
 arch/arm/mach-tegra/hotplug.c                      |    2 +-
 arch/arm/mach-tegra/include/mach/clk.h             |   44 -
 arch/arm/mach-tegra/iomap.h                        |    9 -
 arch/arm/mach-tegra/irq.c                          |   15 +
 arch/arm/mach-tegra/irq.h                          |   22 +
 arch/arm/mach-tegra/pcie.c                         |    2 +-
 arch/arm/mach-tegra/platsmp.c                      |   25 +-
 arch/arm/mach-tegra/pm.c                           |    5 +-
 arch/arm/mach-tegra/powergate.c                    |    2 +-
 arch/arm/mach-tegra/sleep-tegra20.S                |  200 ++
 arch/arm/mach-tegra/sleep.S                        |   19 +
 arch/arm/mach-tegra/sleep.h                        |   26 +
 arch/arm/mach-tegra/tegra20_clocks.c               | 1623 -------------
 arch/arm/mach-tegra/tegra20_clocks.h               |   42 -
 arch/arm/mach-tegra/tegra20_clocks_data.c          | 1143 ---------
 arch/arm/mach-tegra/tegra30_clocks.c               | 2506 --------------------
 arch/arm/mach-tegra/tegra30_clocks.h               |   54 -
 arch/arm/mach-tegra/tegra30_clocks_data.c          | 1425 -----------
 arch/arm/mach-vt8500/Kconfig                       |   16 +
 arch/arm/mach-vt8500/vt8500.c                      |    2 +
 arch/arm/mm/cache-v7.S                             |   46 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-bcm2835.c                          |    9 +
 drivers/clk/mxs/clk-imx28.c                        |    2 +-
 drivers/clk/tegra/Makefile                         |   11 +
 drivers/clk/tegra/clk-audio-sync.c                 |   87 +
 drivers/clk/tegra/clk-divider.c                    |  187 ++
 drivers/clk/tegra/clk-periph-gate.c                |  179 ++
 drivers/clk/tegra/clk-periph.c                     |  218 ++
 drivers/clk/tegra/clk-pll-out.c                    |  123 +
 drivers/clk/tegra/clk-pll.c                        |  648 +++++
 drivers/clk/tegra/clk-super.c                      |  154 ++
 drivers/clk/tegra/clk-tegra20.c                    | 1349 +++++++++++
 drivers/clk/tegra/clk-tegra30.c                    | 1987 ++++++++++++++++
 drivers/clk/tegra/clk.c                            |   85 +
 drivers/clk/tegra/clk.h                            |  502 ++++
 drivers/cpuidle/Kconfig                            |    6 +
 drivers/cpuidle/Makefile                           |    1 +
 .../cpuidle/cpuidle-kirkwood.c                     |   45 +-
 drivers/dma/tegra20-apb-dma.c                      |    2 +-
 drivers/gpu/drm/tegra/dc.c                         |    3 +-
 drivers/gpu/drm/tegra/drm.c                        |    1 -
 drivers/gpu/drm/tegra/hdmi.c                       |    3 +-
 drivers/i2c/busses/i2c-tegra.c                     |    3 +-
 drivers/input/keyboard/tegra-kbc.c                 |    2 +-
 drivers/rtc/Kconfig                                |    2 +-
 drivers/spi/spi-tegra20-sflash.c                   |    4 +-
 drivers/spi/spi-tegra20-slink.c                    |    4 +-
 drivers/staging/nvec/TODO                          |    4 -
 drivers/staging/nvec/nvec.c                        |    5 +-
 drivers/usb/host/ehci-tegra.c                      |   97 +-
 drivers/usb/phy/tegra_usb_phy.c                    |  132 +-
 .../tegra_cpu_car.h => include/linux/clk/tegra.h   |   13 +-
 include/linux/platform_data/usb-omap.h             |    8 +-
 include/linux/tegra-soc.h                          |   22 +
 include/linux/usb/tegra_usb_phy.h                  |   16 +-
 sound/soc/tegra/tegra30_ahub.c                     |   16 +-
 256 files changed, 11534 insertions(+), 9689 deletions(-)
