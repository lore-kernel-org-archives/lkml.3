Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3KKFeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:34:03 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38489 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3KKFdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:33:00 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 3/6] ARM: SoC platform changes for 3.13
Date: Sun, 10 Nov 2013 21:29:33 -0800
Message-Id: <1384147776-18735-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1384147776-18735-1-git-send-email-olof@lixom.net>
References: <1384147776-18735-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New and updated SoC support. Among the things new for this release are:

- More support for the AM33xx platforms from TI
- Tegra 124 support, and some updates to older tegra families as well
- imx cleanups and updates across the board
- A rename of Broadcom's Mobile platforms which were introduced as ARCH_BCM,
and turned out to be too broad a name. New name is ARCH_BCM_MOBILE.
- A whole bunch of updates and fixes for integrator, making the platform code
more modern and switches over to DT-only booting.
- Support for two new Renesas shmobile chipsets. Next up for them is more work
on consolidation instead of introduction of new non-multiplatform SoCs, we're
all looking forward to that!
- Misc cleanups for older Samsung platforms, some Allwinner updates, etc.


Conflicts: None

----------------------------------------------------------------

The following changes since commit 880b93205793c421bc57654b178df9dd13bfb370:

  Merge branch 'next/cleanup' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-linus

for you to fetch changes up to 005ff5fb077ebf93882bd643932f932a9b402529:

  ARM: bcm281xx: Add ARCH_BCM_MOBILE to bcm config

----------------------------------------------------------------

Afzal Mohammed (7):
      ARM: OMAP2+: hwmod: AM335x/AM43x: move common data
      ARM: OMAP2+: hwmod: AM335x: runtime register update
      ARM: OMAP2+: hwmod: AM335x: remove static register offs
      ARM: OMAP2+: PRCM: AM43x definitions
      ARM: OMAP2+: hwmod: AM43x support
      ARM: OMAP2+: hwmod: AM43x operations
      ARM: OMAP2+: AM43x: PRCM kbuild

Ambresh K (3):
      ARM: OMAP2+: PM: AM43x powerdomain data
      ARM: OMAP2+: CM: AM43x clockdomain data
      ARM: OMAP2+: AM43x PRCM init

Ankur Kishore (1):
      ARM: OMAP2+: CM: cm_inst offset s16->u16

Benoit Cousson (1):
      ARM: OMAP5: hwmod: add missing ocp2scp hwmod data

Christian Daudt (4):
      ARM: bcm281xx: more descriptive machine string
      rename ARCH_BCM to ARCH_BCM_MOBILE (mach-bcm)
      ARM: bcm281xx: Add ARCH Timers to config
      ARM: bcm281xx: Add ARCH_BCM_MOBILE to bcm config

Daniel Lezcano (1):
      ARM: highbank: cpuidle: convert to platform driver

Ezequiel Garcia (3):
      ARM: kirkwood: Add standby support
      ARM: kirkwood: Remove unneeded MBus initialization
      ARM: kirkwood: Remove unneeded PCIe clock adding

Fabio Estevam (9):
      ARM: imx_v6_v7_defconfig: Add SPDIF support
      ARM: imx_v6_v7_defconfig: Add CHIPIDEA_UDC support
      ARM: mxs_defconfig: Add CHIPIDEA_UDC support
      ARM: mach-imx: clk-imx51-imx53: Retrieve base address and irq from dt
      ARM: mach-imx: mm-imx5: Retrieve tzic base address from dt
      ARM: mach-imx: mm-imx5: Retrieve iomuxc base address from dt
      ARM: mxs_defconfig: Turn off CONFIG_DEBUG_GPIO
      ARM: imx_v6_v7_defconfig: Enable LEDS_GPIO related options
      ARM: imx_v6_v7_defconfig: Select CONFIG_PROVE_LOCKING

Fathi Boudra (1):
      ARM: vexpress: Make defconfig work again

Fugang Duan (2):
      ARM: imx6sl: add imx6sl iomux-gpr field define
      ARM: imx6sl: config iomux-gpr1 to select clock for fec

George Cherian (1):
      ARM: OMAP2+: hwmod: Add USB hwmod data for AM437x.

Guennadi Liakhovetski (3):
      ARM: shmobile: r8a73a4: add a DMAC platform device and clock for it
      ARM: shmobile: r8a7790: add I2C clocks and aliases for the DT mode
      ARM: shmobile: r8a73a4: add a clock alias for the DMAC in DT mode

Hisashi Nakamura (1):
      ARM: shmobile: Initial r8a7791 SoC support

Joseph Lo (7):
      ARM: tegra: add Tegra124 SoC support
      ARM: tegra: add PMC compatible value for Tegra124
      ARM: tegra: CPU hotplug support for Tegra124
      ARM: tegra: make tegra_resume can work with current and later chips
      ARM: tegra: enable CPU idle for Tegra124
      ARM: tegra: re-calculate the LP1 data for Tegra30/114
      ARM: tegra: add LP1 support code for Tegra124

Kevin Hilman (12):
      Documentation: arm/Marvell: clarify Armada SoCs that match 78xx0 pattern
      Merge tag 'renesas-soc2-for-v3.13' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'keystone-soc-for-arm-soc' of git://git.kernel.org/.../ssantosh/linux-keystone into next/soc
      ARM: keystone: fix PM domain initcall to be keystone only
      Merge tag 'omap-for-v3.13/hwmod-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-for-v3.13/soc-take2' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge branch 'davinci/soc' into next/soc
      Merge tag 'integrator-for-v3.13-2' of git://git.kernel.org/.../linusw/linux-integrator into next/soc
      Merge tag 'soc-3.13-2' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'highbank-for-3.13' of git://git.kernel.org/.../robh/linux into next/soc
      Merge tag 'omap-for-v3.13/am43xx-hwmod-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'tegra-for-3.13-soc-v2' of git://git.kernel.org/.../swarren/linux-tegra into next/soc

Kuninori Morimoto (5):
      ARM: shmobile: r8a7778: add SSI/SRU clock support
      ARM: shmobile: r8a7778: add USBHS clock
      ARM: shmobile: r8a7778: add usb phy power control function
      ARM: shmobile: r8a7778: split r8a7778_init_irq_extpin() for DT
      ARM: shmobile: r8a7779: split r8a7779_init_irq_extpin() for DT

Laurent Pinchart (2):
      ARM: shmobile: r8a7779: Rename DU device in clock lookups list
      ARM: shmobile: r8a7790: Add DU and LVDS clocks

Linus Walleij (10):
      ARM: integrator: get the CM control register by proxy
      ARM: integrator: update defconfig
      ARM: integrator: get the LM interrupts from DT
      ARM: integrator: print the Linux IRQ in LL_DEBUG code
      ARM: integrator: delete non-devicetree boot path
      ARM: integrator: decommission the <mach/irqs.h> header
      ARM: integrator: move CM base into device tree
      cpufreq: probe the Integrator cpufreq driver from DT
      ARM: integrator: use devm_ioremap() to remap CM
      ARM: integrator: core module registers from compatible strings

Lokesh Vutla (1):
      ARM: AM33xx: hwmod: Add RNG module data

Magnus Damm (22):
      ARM: shmobile: Introduce shmobile_smp_cpu_disable()
      ARM: shmobile: Use shmobile_smp_cpu_disable() on sh73a0
      ARM: shmobile: Remove unused shmobile_smp_init_cpus()
      ARM: shmobile: Expose shmobile_invalidate_start()
      ARM: shmobile: Introduce shmobile_boot_size
      ARM: shmobile: r8a7791 CMT support
      ARM: shmobile: Shared APMU SMP support code without DT
      ARM: shmobile: Add r8a7790 SMP support using APMU code
      ARM: shmobile: Add CPU notifier based SCU boot vector code
      ARM: shmobile: Let sh73a0 rely on SCU CPU notifier
      ARM: shmobile: Let EMEV2 rely on SCU CPU notifier
      ARM: shmobile: Let r8a7779 rely on SCU CPU notifier
      ARM: shmobile: Remove shmobile_smp_scu_boot_secondary()
      ARM: shmobile: Extend APMU code to allow single cluster only
      ARM: shmobile: Include CA7 cores in APMU table
      ARM: shmobile: Break out R-Car Gen2 setup code
      ARM: shmobile: Introduce r8a7791_add_standard_devices()
      ARM: shmobile: r8a7791 IRQC platform device support
      ARM: shmobile: r8a7791 Arch timer workaround
      ARM: shmobile: Initial r7s72100 SoC support
      ARM: shmobile: r7s72100 SCIF support
      ARM: shmobile: r8a7791 SMP support

Markus Mayer (1):
      ARM: bcm281xx: Enable GPIO driver

Max Filippov (2):
      ARM: shmobile: r8a7778: add HPB-DMAC support
      ARM: shmobile: r8a7779: add HPB-DMAC support

Maxime Ripard (8):
      ARM: sunxi: Split out the DT machines for sun6i and sun7i
      ARM: sunxi: Simplify restart setup code
      ARM: sunxi: Order Kconfig options alphabetically
      ARM: sunxi: Add a defconfig for the Allwinner SoCs
      Documentation: sunxi: Update A13 user manual dead link
      Documentation: sunxi: Update Allwinner SoC documentation
      Documentation: dt: Remove interrupt sources list for Allwinner SoCs
      Documentation: dt: Remove clock gates IDs list for Allwinner SoCs

Michael Opdenacker (2):
      ARM: davinci: remove deprecated IRQF_DISABLED
      ARM: imx: remove IRQF_DISABLED

Nicolin Chen (1):
      ARM: imx6q: Add pll4_audio_div to clock tree

Nishanth Menon (1):
      ARM: OMAP5: id: Remove ES1.0 support

Olof Johansson (9):
      Merge tag 'samsung-clk-s3c64xx' of http://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'renesas-soc-for-v3.13' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-smp-for-v3.13' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge branch 'cleanup/dt-clock' into next/soc
      Merge tag 'sunxi-core-for-3.13' of https://github.com/mripard/linux into next/soc
      ARM: sunxi: remove .init_time hooks
      Merge tag 'sunxi-defconfig-for-3.13' of https://github.com/mripard/linux into next/soc
      Merge tag 'imx-soc-3.13' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge tag 'bcm-for-3.13-soc2' of git://github.com/broadcom/bcm11351 into next/soc

Pawel Moll (1):
      ARM: vexpress: Enable platform-specific options in defconfig

R Sricharan (1):
      ARM: OMAP5/DRA7: realtime_counter: Configure CNTFRQ register

Rajendra Nayak (2):
      ARM: OMAP2+: hwmod: cleanup HWMOD_INIT_NO_RESET usage
      ARM: OMAP2+: hwmod: Extract no-idle and no-reset info from DT

Rob Herring (5):
      cpuidle: calxeda: add cpu_pm_enter/exit calls
      cpuidle: calxeda: add support to use PSCI calls
      ARM: PSCI: remove unnecessary include of arm-gic.h
      ARM: highbank: adapt to use ARM PSCI calls
      dts: calxeda: add ARM PSCI binding

Roger Quadros (1):
      ARM: OMAP5: hwmod data: Add USB Host and TLL modules

Santosh Shilimkar (9):
      ARM: dts: keystone: Add clock tree data to devicetree
      ARM: dts: keystone: Add clock phandle to UART nodes
      ARM: keystone: Enable clock drivers
      ARM: keystone: add PM domain support for clock management
      ARM: dts: keystone: Add i2c device nodes
      ARM: dts: keystone: Add the SPI nodes
      dma: Allow TI_EDMA selectable for ARCH_KEYSTONE
      ARM: keystone: Select TI_EDMA to be able to enable SPI driver
      ARM: keystone: Enable I2C and SPI bus support

Sean Cross (2):
      ARM: imx: Add LVDS general-purpose clocks to i.MX6Q
      ARM: imx6q: clock and Kconfig update for PCIe support

Sebastian Hesselbarth (1):
      ARM: kirkwood: retain MAC address for DT ethernet

Sebastian Reichel (1):
      ARM: OMAP2+: hwmod data: Add SSI information

Shawn Guo (16):
      Merge remote-tracking branch 'shesselba/clk-of-init-v2_for-3.13' into imx/soc
      ARM: imx: add low-level debug for vybrid
      ARM: imx: add soc revision helper functions
      ARM: imx6q: use common soc revision helpers
      ARM: imx: add a common function to initialize revision from anatop
      ARM: imx: use imx_init_revision_from_anatop() on imx6sl
      ARM: imx6: report soc info via soc device
      ARM: imx: remove stale mx53_display_revision() declaration
      ARM: imx: replace imx6q_restart() with mxc_restart()
      ARM: imx: do not return from imx_cpu_die() call
      ARM: imx: reset core along with enable/disable operation
      ARM: imx: drop extern with function prototypes in common.h
      ARM: imx6q: move low-power code out of clock driver
      ARM: imx6q: call WB and RBC configuration from imx6q_pm_enter()
      ARM: imx: ensure dsm_request signal is not asserted when setting LPM
      ARM: imx: enable suspend for imx6sl

Simon Horman (2):
      Merge tag 'renesas-smp-for-v3.13' into soc2-base
      Merge tag 'renesas-fixes4-for-v3.12' into soc2-base

Sourav Poddar (1):
      ARM: OMAP2: hwmod: Add qspi data for am437x.

Sricharan R (1):
      ARM: OMAP2+: DRA7: realtime_counter: Add ratio registers for 20MHZ sys-clk frequency

Stephen Warren (1):
      ARM: tegra: add fuses as device randomness

Suman Anna (3):
      ARM: OMAP2+: hwmod: check for module address space during init
      ARM: OMAP5: hwmod data: Add spinlock data
      ARM: AM33xx: hwmod_data: add the sysc configuration for spinlock

Thierry Reding (4):
      ARM: tegra: Remove duplicate powergate defines
      ARM: tegra: Constify list of CPU domains
      ARM: tegra: Add Tegra114 powergate support
      ARM: imx: Include linux/err.h

Tim Kryger (1):
      ARM: bcm_defconfig: Run "make savedefconfig"

Tomasz Figa (5):
      ARM: SAMSUNG: Add soc_is_s3c6400/s3c6410 macros
      ARM: S3C64XX: Use clk_prepare_enable/clk_disable_unprepare in dma.c
      usb: ohci-s3c2410.c: Use clk_prepare_enable/clk_disable_unprepare
      ARM: S3C64XX: Migrate clock handling to Common Clock Framework
      ARM: S3C64XX: Remove old clock management code

Tony Lindgren (3):
      Merge tag 'for-v3.13/hwmod' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.13/hwmod
      ARM: OMAP2+: Fix build error for realtime counter init if not enabled
      Merge tag 'for-v3.13/am43xx-support' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.13/hwmod

Uwe Kleine-König (1):
      ARM: davinci: convert to clockevents_config_and_register

Yoshikazu Fujikawa (1):
      ARM: shmobile: r8a7791 SCIF support


 Documentation/arm/Marvell/README                |    1 +
 Documentation/arm/sunxi/README                  |   26 +-
 .../devicetree/bindings/arm/arm-boards          |   50 +-
 .../devicetree/bindings/clock/imx6q-clock.txt   |    5 +
 .../devicetree/bindings/clock/sunxi.txt         |    4 +-
 .../bindings/clock/sunxi/sun4i-a10-gates.txt    |   93 -
 .../bindings/clock/sunxi/sun5i-a10s-gates.txt   |   75 -
 .../bindings/clock/sunxi/sun5i-a13-gates.txt    |   58 -
 .../bindings/clock/sunxi/sun6i-a31-gates.txt    |   83 -
 .../bindings/clock/sunxi/sun7i-a20-gates.txt    |   98 -
 .../interrupt-controller/allwinner,sun4i-ic.txt |    3 -
 .../interrupt-controller/sunxi/sun4i-a10.txt    |   89 -
 .../interrupt-controller/sunxi/sun5i-a13.txt    |   55 -
 arch/arm/Kconfig                                |    3 +-
 arch/arm/Kconfig.debug                          |    8 +
 arch/arm/boot/dts/ecx-common.dtsi               |    8 +
 arch/arm/boot/dts/imx6sl.dtsi                   |    4 +-
 arch/arm/boot/dts/integrator.dtsi               |    5 +
 arch/arm/boot/dts/integratorap.dts              |    5 +-
 arch/arm/boot/dts/integratorcp.dts              |    4 +-
 arch/arm/boot/dts/keystone-clocks.dtsi          |  821 +++++++
 arch/arm/boot/dts/keystone.dts                  |   63 +-
 arch/arm/boot/dts/r7s72100.dtsi                 |   36 +
 arch/arm/boot/dts/r8a7791.dtsi                  |   41 +
 arch/arm/configs/bcm_defconfig                  |   10 +-
 arch/arm/configs/imx_v6_v7_defconfig            |   16 +-
 arch/arm/configs/integrator_defconfig           |   25 +-
 arch/arm/configs/keystone_defconfig             |    2 +
 arch/arm/configs/multi_v7_defconfig             |    1 +
 arch/arm/configs/mxs_defconfig                  |    7 +-
 arch/arm/configs/sunxi_defconfig                |   61 +
 arch/arm/configs/vexpress_defconfig             |   73 +-
 arch/arm/include/debug/vf.S                     |   26 +
 arch/arm/kernel/psci_smp.c                      |    1 -
 arch/arm/mach-bcm/Kconfig                       |   22 +-
 arch/arm/mach-bcm/Makefile                      |    2 +-
 arch/arm/mach-bcm/board_bcm281xx.c              |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c         |    2 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c     |    2 +-
 arch/arm/mach-davinci/time.c                    |   13 +-
 arch/arm/mach-highbank/Kconfig                  |    1 +
 arch/arm/mach-highbank/Makefile                 |    2 -
 arch/arm/mach-highbank/core.h                   |    4 -
 arch/arm/mach-highbank/highbank.c               |   24 +-
 arch/arm/mach-highbank/hotplug.c                |   37 -
 arch/arm/mach-highbank/platsmp.c                |   68 -
 arch/arm/mach-highbank/pm.c                     |   27 +-
 arch/arm/mach-imx/Kconfig                       |    5 +-
 arch/arm/mach-imx/Makefile                      |    2 +
 arch/arm/mach-imx/anatop.c                      |   33 +-
 arch/arm/mach-imx/clk-imx51-imx53.c             |   15 +-
 arch/arm/mach-imx/clk-imx6q.c                   |  190 +-
 arch/arm/mach-imx/clk-imx6sl.c                  |    3 +
 arch/arm/mach-imx/common.h                      |  186 +-
 arch/arm/mach-imx/cpu.c                         |   95 +-
 arch/arm/mach-imx/epit.c                        |    2 +-
 arch/arm/mach-imx/gpc.c                         |    4 +-
 arch/arm/mach-imx/hotplug.c                     |    4 +-
 arch/arm/mach-imx/mach-armadillo5x0.c           |    3 +-
 arch/arm/mach-imx/mach-imx6q.c                  |   77 +-
 arch/arm/mach-imx/mach-imx6sl.c                 |   33 +-
 arch/arm/mach-imx/mach-mx31_3ds.c               |    2 +-
 arch/arm/mach-imx/mach-pcm037.c                 |    3 +-
 arch/arm/mach-imx/mm-imx5.c                     |   19 +-
 arch/arm/mach-imx/mx31lilly-db.c                |    3 +-
 arch/arm/mach-imx/mxc.h                         |    6 +
 arch/arm/mach-imx/pm-imx6q.c                    |  176 +-
 arch/arm/mach-imx/src.c                         |    1 +
 arch/arm/mach-imx/system.c                      |    5 +
 arch/arm/mach-imx/time.c                        |    2 +-
 .../arm/mach-integrator/{include/mach => }/cm.h |    7 +-
 arch/arm/mach-integrator/core.c                 |  182 +-
 arch/arm/mach-integrator/include/mach/irqs.h    |   81 -
 arch/arm/mach-integrator/integrator_ap.c        |  152 +-
 arch/arm/mach-integrator/integrator_cp.c        |  185 +-
 arch/arm/mach-integrator/leds.c                 |    5 +-
 arch/arm/mach-integrator/pci_v3.c               |  127 +-
 arch/arm/mach-keystone/Kconfig                  |    2 +
 arch/arm/mach-keystone/Makefile                 |    3 +
 arch/arm/mach-keystone/pm_domain.c              |   82 +
 arch/arm/mach-kirkwood/Makefile                 |    2 +
 arch/arm/mach-kirkwood/board-dt.c               |   96 +-
 arch/arm/mach-kirkwood/common.c                 |    1 +
 arch/arm/mach-kirkwood/common.h                 |    6 +
 .../mach-kirkwood/include/mach/bridge-regs.h    |    2 +
 arch/arm/mach-kirkwood/pm.c                     |   73 +
 arch/arm/mach-omap2/Makefile                    |    9 +-
 arch/arm/mach-omap2/clockdomain.h               |    4 +-
 arch/arm/mach-omap2/clockdomains43xx_data.c     |  196 ++
 arch/arm/mach-omap2/cm33xx.c                    |   16 +-
 arch/arm/mach-omap2/cm33xx.h                    |   12 +-
 arch/arm/mach-omap2/cminst44xx.c                |   29 +-
 arch/arm/mach-omap2/cminst44xx.h                |   26 +-
 arch/arm/mach-omap2/id.c                        |    8 +-
 arch/arm/mach-omap2/io.c                        |    6 +
 arch/arm/mach-omap2/omap-secure.h               |    4 +
 arch/arm/mach-omap2/omap-smp.c                  |    7 +
 arch/arm/mach-omap2/omap_hwmod.c                |   57 +-
 arch/arm/mach-omap2/omap_hwmod.h                |    1 +
 .../omap_hwmod_33xx_43xx_common_data.h          |  163 ++
 .../omap_hwmod_33xx_43xx_interconnect_data.c    |  643 +++++
 .../omap_hwmod_33xx_43xx_ipblock_data.c         | 1469 +++++++++++
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c      | 2280 ++----------------
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      |   48 +
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c      |  758 ++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      |    6 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c      |  230 +-
 arch/arm/mach-omap2/powerdomain.h               |    1 +
 arch/arm/mach-omap2/powerdomains43xx_data.c     |  136 ++
 arch/arm/mach-omap2/prcm43xx.h                  |  146 ++
 arch/arm/mach-omap2/soc.h                       |    2 -
 arch/arm/mach-omap2/timer.c                     |   17 +
 arch/arm/mach-s3c64xx/Makefile                  |    2 +-
 arch/arm/mach-s3c64xx/clock.c                   | 1007 --------
 arch/arm/mach-s3c64xx/common.c                  |   21 +-
 arch/arm/mach-s3c64xx/common.h                  |   12 +-
 arch/arm/mach-s3c64xx/dma.c                     |    4 +-
 arch/arm/mach-s3c64xx/include/mach/regs-clock.h |  132 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c            |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c           |    2 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                |    2 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c           |    2 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq.c             |   11 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c           |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c           |    2 +-
 arch/arm/mach-s3c64xx/pm.c                      |   21 -
 arch/arm/mach-s3c64xx/s3c6400.c                 |    6 -
 arch/arm/mach-s3c64xx/s3c6410.c                 |    7 -
 arch/arm/mach-shmobile/Kconfig                  |   12 +
 arch/arm/mach-shmobile/Makefile                 |    7 +
 arch/arm/mach-shmobile/board-lager-reference.c  |    3 +-
 arch/arm/mach-shmobile/board-lager.c            |    3 +-
 arch/arm/mach-shmobile/clock-r7s72100.c         |  202 ++
 arch/arm/mach-shmobile/clock-r8a73a4.c          |    5 +-
 arch/arm/mach-shmobile/clock-r8a7778.c          |   44 +-
 arch/arm/mach-shmobile/clock-r8a7779.c          |    2 +-
 arch/arm/mach-shmobile/clock-r8a7790.c          |   24 +-
 arch/arm/mach-shmobile/clock-r8a7791.c          |  237 ++
 arch/arm/mach-shmobile/headsmp.S                |    3 +
 arch/arm/mach-shmobile/include/mach/common.h    |   12 +-
 arch/arm/mach-shmobile/include/mach/r7s72100.h  |    8 +
 arch/arm/mach-shmobile/include/mach/r8a73a4.h   |    9 +
 arch/arm/mach-shmobile/include/mach/r8a7778.h   |   11 +
 arch/arm/mach-shmobile/include/mach/r8a7779.h   |    8 +
 arch/arm/mach-shmobile/include/mach/r8a7790.h   |    7 +-
 arch/arm/mach-shmobile/include/mach/r8a7791.h   |   10 +
 arch/arm/mach-shmobile/include/mach/rcar-gen2.h |    8 +
 arch/arm/mach-shmobile/platsmp-apmu.c           |  195 ++
 arch/arm/mach-shmobile/platsmp-scu.c            |   30 +-
 arch/arm/mach-shmobile/platsmp.c                |   22 +-
 arch/arm/mach-shmobile/setup-r7s72100.c         |   88 +
 arch/arm/mach-shmobile/setup-r8a73a4.c          |   91 +
 arch/arm/mach-shmobile/setup-r8a7778.c          |  128 +-
 arch/arm/mach-shmobile/setup-r8a7779.c          |  160 +-
 arch/arm/mach-shmobile/setup-r8a7790.c          |   69 +-
 arch/arm/mach-shmobile/setup-r8a7791.c          |  184 ++
 arch/arm/mach-shmobile/setup-rcar-gen2.c        |   91 +
 arch/arm/mach-shmobile/smp-emev2.c              |    6 -
 arch/arm/mach-shmobile/smp-r8a7779.c            |    4 -
 arch/arm/mach-shmobile/smp-r8a7790.c            |   67 +
 arch/arm/mach-shmobile/smp-r8a7791.c            |   62 +
 arch/arm/mach-shmobile/smp-sh73a0.c             |   14 +-
 arch/arm/mach-sunxi/Kconfig                     |    6 +-
 arch/arm/mach-sunxi/sunxi.c                     |   35 +-
 arch/arm/mach-tegra/Kconfig                     |    8 +
 arch/arm/mach-tegra/Makefile                    |    5 +
 arch/arm/mach-tegra/cpuidle.c                   |    4 +-
 arch/arm/mach-tegra/flowctrl.c                  |    2 +
 arch/arm/mach-tegra/fuse.c                      |   54 +
 arch/arm/mach-tegra/fuse.h                      |    1 +
 arch/arm/mach-tegra/hotplug.c                   |    2 +
 arch/arm/mach-tegra/iomap.h                     |    3 +
 arch/arm/mach-tegra/platsmp.c                   |    2 +
 arch/arm/mach-tegra/pm.c                        |   12 +-
 arch/arm/mach-tegra/pmc.c                       |    8 +-
 arch/arm/mach-tegra/powergate.c                 |   48 +-
 arch/arm/mach-tegra/reset-handler.S             |   13 +-
 arch/arm/mach-tegra/sleep-tegra30.S             |   49 +-
 arch/arm/mach-tegra/tegra.c                     |    1 +
 arch/arm/plat-samsung/include/plat/cpu.h        |    4 +
 drivers/clk/samsung/Makefile                    |    2 -
 drivers/cpufreq/integrator-cpufreq.c            |   61 +-
 drivers/cpuidle/Kconfig.arm                     |    2 +-
 drivers/cpuidle/cpuidle-calxeda.c               |   61 +-
 drivers/dma/Kconfig                             |    2 +-
 drivers/usb/host/ohci-s3c2410.c                 |    8 +-
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h     |    5 +
 include/linux/tegra-powergate.h                 |    9 +-
 189 files changed, 8328 insertions(+), 5357 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun4i-a10-gates.txt
 delete mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun5i-a10s-gates.txt
 delete mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun5i-a13-gates.txt
 delete mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
 delete mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun7i-a20-gates.txt
 delete mode 100644 Documentation/devicetree/bindings/interrupt-controller/sunxi/sun4i-a10.txt
 delete mode 100644 Documentation/devicetree/bindings/interrupt-controller/sunxi/sun5i-a13.txt
 create mode 100644 arch/arm/boot/dts/keystone-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/r7s72100.dtsi
 create mode 100644 arch/arm/boot/dts/r8a7791.dtsi
 create mode 100644 arch/arm/configs/sunxi_defconfig
 create mode 100644 arch/arm/include/debug/vf.S
 delete mode 100644 arch/arm/mach-highbank/hotplug.c
 delete mode 100644 arch/arm/mach-highbank/platsmp.c
 rename arch/arm/mach-integrator/{include/mach => }/cm.h (88%)
 delete mode 100644 arch/arm/mach-integrator/include/mach/irqs.h
 create mode 100644 arch/arm/mach-keystone/pm_domain.c
 create mode 100644 arch/arm/mach-kirkwood/pm.c
 create mode 100644 arch/arm/mach-omap2/clockdomains43xx_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_interconnect_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_43xx_data.c
 create mode 100644 arch/arm/mach-omap2/powerdomains43xx_data.c
 create mode 100644 arch/arm/mach-omap2/prcm43xx.h
 delete mode 100644 arch/arm/mach-s3c64xx/clock.c
 create mode 100644 arch/arm/mach-shmobile/clock-r7s72100.c
 create mode 100644 arch/arm/mach-shmobile/clock-r8a7791.c
 create mode 100644 arch/arm/mach-shmobile/include/mach/r7s72100.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/r8a7791.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/rcar-gen2.h
 create mode 100644 arch/arm/mach-shmobile/platsmp-apmu.c
 create mode 100644 arch/arm/mach-shmobile/setup-r7s72100.c
 create mode 100644 arch/arm/mach-shmobile/setup-r8a7791.c
 create mode 100644 arch/arm/mach-shmobile/setup-rcar-gen2.c
 create mode 100644 arch/arm/mach-shmobile/smp-r8a7790.c
 create mode 100644 arch/arm/mach-shmobile/smp-r8a7791.c
