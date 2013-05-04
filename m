Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3EDHqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 03:46:36 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:64756 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3EDHqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 03:46:24 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/4] ARM: arm-soc driver changes for 3.10
Date: Sat,  4 May 2013 00:42:45 -0700
Message-Id: <1367653368-25291-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1367653368-25291-1-git-send-email-olof@lixom.net>
References: <1367653368-25291-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rather large set of patches for device drivers that for one
reason or another the subsystem maintainer preferred to get merged
through the arm-soc tree. There are both new drivers as well as
existing drivers that are getting converted from platform-specific
code into standalone drivers using the appropriate subsystem
specific interfaces.

In particular, we can now have pinctrl, clk, clksource and irqchip
drivers in one file per driver, without the need to call into
platform specific interface, or to get called from platform specific
code, as long as all information about the hardware is provided
through a device tree.

Most of the drivers we touch this time are for clocksource. Since
now most of them are part of drivers/clocksource, I expect that we
won't have to touch these again from arm-soc and can let the
clocksource maintainers take care of these in the future.

Another larger part of this series is specific to the exynos platform,
which is seeing some significant effort in upstreaming and
modernization of its device drivers this time around, which
unfortunately is also the cause for the churn and a lot of the
merge conflicts.

There is one new subsystem that gets merged as part of this series:
the reset controller interface, which is a very simple interface
for taking devices on the SoC out of reset or back into reset.
Patches to use this interface on i.MX follow later in this merge
window, and we are going to have other platforms (at least tegra
and sirf) get converted in 3.11. This will let us get rid of
platform specific callbacks in a number of platform independent
device drivers.


Conflicts:

arch/arm/Kconfig:
- Remove/change conflict. Take out the HAVE_ARM_TWD select.
- Change/change conflict on ARCH_NR_GPIO. Keep 392 for U8500 and the
  split VT8500/SUNXI entries

arch/arm/mach-omap2/*:
Keep all versions from the branch (caused by a duplicate commits from
the ARM tree).

drivers/clocksource/Makefile:
Add/add, keep both.

drivers/irqchip/Makefile:
Add/add, keep both. This file can do with a fresh sorting at some
point.

drivers/irqchip/irq-s3c24xx.c: 
- Include statements: Add/add, keep both.
- reg_pending change: Keep first line from HEAD and second from
branch.

drivers/pinctrl/pinctrl-samsung.c:
Add/add. Move new 5250 entry up into upper ifdef.

drivers/pinctrl/pinctrl-samsung.h:
Add/add, keep both.

----------------------------------------------------------------

The following changes since commit 1db772216f48978d5146b858586f6178433aad38:

  Merge branch 'for-3.10' of git://linux-nfs.org/~bfields/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers-for-linus

for you to fetch changes up to bc8fd900c4d460b4e4bf785bb48bfced0ac9941b:

  irqchip: s3c24xx: add missing __init annotations

----------------------------------------------------------------

Abhilash Kesavan (1):
      ARM: dts: Add max77686 device tree support for CROS5250

Andrzej Hajda (1):
      clk: exynos4: Add missing CMU_TOP and ISP clocks

Arnd Bergmann (25):
      Merge branch 'next/timer-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'next/irq-s3c24xx' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'next/pinctrl-exynos' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'at91-driversLCD' of git://github.com/at91linux/linux-at91 into next/drivers
      Merge tag 'renesas-intc-external-irq-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-clocksource-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-intc-external-irq2-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'vt8500/pinctrl' of git://server.prisktech.co.nz/git/linuxwmt into next/drivers
      Merge branch 'zynq/clksrc/cleanup' of git://git.xilinx.com/linux-xlnx into next/drivers
      Merge tag 'omap-for-v3.10/usb-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'omap-for-v3.10/timer-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'omap-for-v3.10/gpmc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge branch 'tegra/soc' into next/drivers
      Merge branch 'depends/clk' into next/drivers
      Merge tag 'tegra-for-3.10-clk' of git://git.kernel.org/.../swarren/linux-tegra into next/drivers
      Merge tag 'ux500-pinctrl' of git://git.kernel.org/.../linusw/linux-stericsson into next/drivers
      Merge tag 'irq-s3c24xx-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'mct-exynos-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'clk-exynos-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'pmu-exynos-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'timer-samsung-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'samsung/exynos-multiplatform' into next/drivers
      clocksource: exynos_mct: fix build error on non-DT
      ARM: exynos: restore mach/regs-clock.h for exynos5
      irqchip: s3c24xx: add missing __init annotations

Axel Lin (2):
      clocksource: mct: Add terminating entry for exynos_mct_ids table
      pinctrl: vt8500: wmt: Fix checking return value of pinctrl_register()

Bastian Hecht (1):
      irqchip: intc-irqpin: Add support for shared interrupt lines

Chanho Park (5):
      irqchip: exynos-combiner: Add set_irq_affinity function for combiner_irq
      irqchip: exynos-combiner: Correct combined IRQs for exynos4
      ARM: EXYNOS: Enable PMUs for exynos4
      ARM: EXYNOS: Add arm-pmu DT binding for exynos5250
      ARM: EXYNOS: Add arm-pmu DT binding for exynos421x

Dan Carpenter (1):
      reset: NULL deref on allocation failure

Dongjin Kim (3):
      ARM: dts: Add board dts file for ODROID-X
      ARM: dts: Fix the timing property of MSHC controller for exynos4412-odroidx
      ARM: dts: enable RTC device node for exynos4412-odroidx

Doug Anderson (2):
      clocksource: mct: Add missing semicolons in exynos_mct.c
      ARM: dts: Disable the RTC by default on exynos5

Ezequiel Garcia (8):
      ARM: omap2: gpmc: Mark local scoped functions static
      ARM: omap2: gpmc: Remove unused gpmc_round_ns_to_ticks() function
      ARM: omap2: gpmc: Fix gpmc_cs_reserved() return value
      ARM: omap2: gpmc-nand: Print something useful on CS request failure
      ARM: omap2: gpmc-onenand: Print something useful on CS request failure
      ARM: omap2: gpmc-onenand: Replace pr_err() with dev_err()
      ARM: omap2: gpmc-onenand: Replace printk KERN_ERR with dev_warn()
      ARM: omap2: gpmc: Remove redundant chip select out of range check

Fabio Baltieri (1):
      ARM: ux500: remove redundant DB8500_PIN_SLEEP definition

Giridhar Maruthy (3):
      ARM: dts: remove disabled status from watchdog node for exynos5440-ssdk5440
      ARM: dts: remove disabled status from RTC node for exynos5440-ssdk5440
      ARM: dts: change compatible value for exynos5440 i2c

Girish K S (1):
      ARM: dts: Add initial board support file for exynos5250-arndale

Heiko Stueber (1):
      clk: samsung: fix pm init on non-dt platforms

Heiko Stuebner (28):
      ARM: S3C24XX: move s3c244x irq init to common irq code
      ARM: S3C24XX: create dedicated irq init functions for s3c2440 and s3c2442
      ARM: S3C24XX: move s3c2440 irqs to common irq code
      ARM: S3C24XX: integrate s3c2440 irqs into common init
      ARM: S3C24XX: transform s3c2442 irqs into new structure
      ARM: S3C24XX: transform s3c2440 irqs into new structure
      ARM: S3C24XX: use samsung_sync_wakemask in s3c2412 pm
      ARM: S3C24XX: move s3c2412 irq init to common code
      ARM: S3C24XX: modify s3c2412 irq init to initialize all irqs
      ARM: S3C24XX: transform s3c2412 irqs into new structure
      ARM: S3C24XX: include first 4 bits of the eint register in irq mapping
      ARM: S3C24XX: add soc_is_s3c2412 option
      ARM: S3C24XX: handle s3c2412 eints using new infrastructure
      ARM: S3C24XX: fix redundant checks in the irq mapping function
      ARM: S3C24XX: fix irq parent check
      ARM: S3C24XX: move s3c24xx_init_irq to s3c2410_init_irq
      ARM: S3C24XX: make s3c24xx_init_intc static
      ARM: S3C24XX: add handle_irq function
      clk: samsung: register clk_div_tables for divider clocks
      clk: samsung: always allocate the clk_table
      clk: samsung: add infrastructure to add separate aliases
      ARM: S3C24XX: move irq driver to drivers/irqchip
      irqchip: s3c24xx: fix comments on some camera interrupts
      irqchip: s3c24xx: fix irqlist of second s3c2416 controller
      irqchip: s3c24xx: add irq_set_type callback for basic interrupt types
      irqchip: s3c24xx: globally keep track of the created intc instances
      irqchip: s3c24xx: make interrupt handling independent of irq_domain structure
      irqchip: s3c24xx: add devicetree support

Javier Martinez Canillas (3):
      ARM: OMAP2+: return -ENODEV if GPMC child device creation fails
      ARM: OMAP2+: rename gpmc_probe_nor_child() to gpmc_probe_generic_child()
      ARM: OMAP2+: Add GPMC DT support for Ethernet child nodes

Jingoo Han (2):
      ARM: EXYNOS: Add AUXDATA for DP controller
      ARM: dts: Add device tree node for DP controller for exynos5250

Johan Hovold (3):
      ARM: at91/avr32/atmel_lcdfb: add bus-clock entry
      atmel_lcdfb: move lcdcon2 register access to compute_hozval
      ARM: at91/avr32/atmel_lcdfb: add platform device-id table

Jon Hunter (26):
      Merge commit '6bb27d7349db51b50c40534710fe164ca0d58902' into omap-timer-for-v3.10
      ARM: OMAP2+: Display correct system timer name
      ARM: OMAP2+: Remove hard-coded test on timer ID
      ARM: OMAP2+: Simplify system timer clock definitions
      ARM: OMAP2+: Simplify system timers definitions
      ARM: OMAP3: Update clocksource timer selection
      ARM: OMAP2+: Store ID of system timers in timer structure
      ARM: OMAP4+: Fix sparse warning in system timers
      Merge commit '31d9adca82ce65e5c99d045b5fd917c702b6fce3' into tmp
      ARM: OMAP2+: Simplify code configuring ONENAND devices
      ARM: OMAP2+: Add variable to store number of GPMC waitpins
      ARM: OMAP2+: Add structure for storing GPMC settings
      ARM: OMAP2+: Add function for configuring GPMC settings
      ARM: OMAP2+: Convert ONENAND to use gpmc_cs_program_settings()
      ARM: OMAP2+: Convert NAND to use gpmc_cs_program_settings()
      ARM: OMAP2+: Convert SMC91x to use gpmc_cs_program_settings()
      ARM: OMAP2+: Convert TUSB to use gpmc_cs_program_settings()
      ARM: OMAP2+: Don't configure of chip-select options in gpmc_cs_configure()
      ARM: OMAP2+: Add function to read GPMC settings from device-tree
      ARM: OMAP2+: Add additional GPMC timing parameters
      ARM: OMAP2+: Add device-tree support for NOR flash
      ARM: OMAP2+: Convert NAND to retrieve GPMC settings from DT
      ARM: OMAP2+: Convert ONENAND to retrieve GPMC settings from DT
      ARM: OMAP2+: Detect incorrectly aligned GPMC base address
      ARM: OMAP2+: Remove unnecesssary GPMC definitions and variable
      ARM: OMAP2+: Allow GPMC probe to complete even if CS mapping fails

Julien Delacou (1):
      ARM: ux500: u8500: fix pinctrl IDLE state definition for SPI2

Kukjin Kim (7):
      ARM: dts: cleanup exynos5440.dtsi
      gpio: samsung: fixes build warning with s3c2410_defconfig
      ARM: dts: re-organized cpu node for exynos5440
      Merge branch 'next/timer-samsung' into next/clk-exynos
      Merge branch 'next/mct-exynos' into next/clk-exynos
      ARM: SAMSUNG: change GENERIC_GPIO to ARCH_REQUIRE_GPIOLIB
      Merge commit 'v3.9-rc5' into next/clk-exynos

Lee Jones (1):
      ARM: ux500: Add Snowball pin configuration for user LED

Leela Krishna Amudala (1):
      clk: exynos5250: register display block gate clocks to common clock framework

Lukasz Majewski (1):
      clk: exynos4: Export clocks used by exynos cpufreq drivers

Magnus Damm (22):
      clocksource: sh_cmt: Take care of clk_put() when setup_irq() fails
      clocksource: sh_cmt: Initialize 'max_match_value' and 'lock' in sh_cmt_setup()
      clocksource: sh_cmt: Introduce per-register functions
      clocksource: sh_cmt: Consolidate platform_set_drvdata() call
      clocksource: sh_cmt: CMSTR and CMCSR register access update
      clocksource: sh_cmt: CMCNT and CMCOR register access update
      clocksource: sh_cmt: Add control register callbacks
      clocksource: sh_cmt: Add CMT register layout comment
      irqchip: Renesas INTC External IRQ pin driver
      ARM: shmobile: irq_pin() for static IRQ pin assignment
      ARM: shmobile: INTC External IRQ pin driver on sh73a0
      ARM: shmobile: INTC External IRQ pin driver on r8a7779
      irqchip: intc-irqpin: Whitespace fixes
      irqchip: intc-irqpin: Cache mapped IRQ
      irqchip: intc-irqpin: Add force comments
      irqchip: intc-irqpin: Make use of devm functions
      irqchip: intc-irqpin: GPL header for platform data
      irqchip: Renesas IRQC driver
      ARM: shmobile: Make sh73a0 INTC irqpin platform data static
      ARM: shmobile: Make r8a7779 INTC irqpin platform data static
      irqchip: intc-irqpin: Initial DT support
      irqchip: irqc: Add DT support

Mark Jackson (1):
      ARM: OMAP: Clear GPMC bits when applying new setting.

Michal Simek (4):
      arm: zynq: Use standard timer binding
      arm: zynq: Move timer to clocksource interface
      arm: zynq: Do not use xilinx specific function names
      arm: zynq: Move timer to generic location

Olof Johansson (2):
      Merge branch 'reset/for_v3.10' of git://git.pengutronix.de/git/pza/linux into next/drivers
      Merge branch 'samsung/exynos-multiplatform' into next/drivers

Patrice Chotard (1):
      ARM: ux500: 8500: add ab8500-musb pinctrl support

Peter De Schrijver (14):
      clk: tegra: provide dummy cpu car ops
      clk: tegra: Refactor PLL programming code
      clk: tegra: Add TEGRA_PLL_BYPASS flag
      clk: tegra: introduce TEGRA_PLL_HAS_LOCK_ENABLE
      clk: tegra: Add PLL post divider table
      clk: tegra: move from a lock bit idx to a lock mask
      clk: tegra: Add new fields and PLL types for Tegra114
      clk: tegra: Add flags to tegra_clk_periph()
      clk: tegra: Workaround for Tegra114 MSENC problem
      ARM: tegra: Define Tegra114 CAR binding
      clk: tegra: Implement clocks for Tegra114
      clk: tegra: devicetree match for nvidia,tegra114-car
      ARM: dt: Add references to tegra_car clocks
      clk: tegra: Remove forced clk_enable of uartd

Philipp Zabel (1):
      reset: Add reset controller API

Prasanna Kumar (1):
      ARM: dts: Set up power domain for MFC and G-scaler for exynos5250

Prashant Gaikwad (1):
      clk: tegra: Fix cdev1 and cdev2 IDs

Roger Quadros (20):
      ARM: OMAP2+: omap-usb-host: Add usbhs_init_phys()
      ARM: OMAP2+: omap4panda: Adapt to ehci-omap changes
      ARM: OMAP3: Beagle: Adapt to ehci-omap changes
      ARM: OMAP3: 3430SDP: Adapt to ehci-omap changes
      ARM: OMAP3: 3630SDP: Adapt to ehci-omap changes
      ARM: OMAP: AM3517crane: Adapt to ehci-omap changes
      ARM: OMAP: AM3517evm: Adapt to ehci-omap changes
      ARM: OMAP3: cm-t35: Adapt to ehci-omap changes
      ARM: OMAP3: cm-t3517: Adapt to ehci-omap changes
      ARM: OMAP: devkit8000: Adapt to ehci-omap changes
      ARM: OMAP3: igep0020: Adapt to ehci-omap changes
      ARM: OMAP3: omap3evm: Adapt to ehci-omap changes
      ARM: OMAP3: omap3pandora: Adapt to ehci-omap changes
      ARM: OMAP3: omap3stalker: Adapt to ehci-omap changes
      ARM: OMAP3: omap3touchbook: Adapt to ehci-omap changes
      ARM: OMAP3: overo: Adapt to ehci-omap changes
      ARM: OMAP: zoom: Adapt to ehci-omap changes
      ARM: dts: OMAP4: Add HS USB Host IP nodes
      ARM: dts: OMAP3: Add HS USB Host IP nodes
      ARM: dts: omap3-beagle: Add USB Host support

Romain Naour (5):
      ARM: SAMSUNG: Rename s5p-time to samsung-time
      ARM: S3C24XX: Add samsung-time support for s3c24xx
      ARM: S3C64XX: Add samsung-time support for s3c64xx
      ARM: S5PC100: Add samsung-time support for s5pc100
      ARM: SAMSUNG: Remove unused plat-samsung/time.c

Russell King (2):
      ARM: cleanup: OMAP hwmod error checking
      ARM: OMAP: use consistent error checking

Sachin Kamat (12):
      ARM: dts: Add vmmc regulator node in exynos4412-origen.dts
      ARM: dts: Add sdhci node for exynos4412-origen
      ARM: dts: Update MFC DT binding documentation
      ARM: dts: Add MFC codec support for EXYNOS4 DT machines
      ARM: dts: Add MFC codec support to SMDKV310 DT
      ARM: dts: Add MFC codec support to Origen DT
      ARM: dts: Add MFC codec entry to exynos4412-origen DT
      ARM: dts: Add MFC codec entry to exynos4412-smdk4412 DT
      ARM: dts: Add MSHC node for exynos4412-origen DT
      ARM: dts: Add s5m8767 PMIC node to exynos4412-origen DT
      ARM: dts: Add sdhci node for exynos4412-smdk4412
      clk: samsung: Fix compilation error

Simon Horman (4):
      clocksource: sh_cmt: Set initcall level to subsys
      clocksource: sh_tmu: Set initcall level to subsys
      clocksource: em_sti: Set initcall level to subsys
      clocksource: sh_mtu2: Set initcall level to subsys

Stephen Warren (6):
      pinctrl: bcm2835: make use of of_property_read_u32_index()
      Merge branch 'for-3.10/soc' into for-3.10/clk
      Merge remote-tracking branch 'linaro_mturquette_linux/clk-for-3.10' into for-3.10/clk
      clk: tegra: defer application of init table
      clk: tegra: fix enum tegra114_clk to match binding
      dt: describe base reset signal binding

Sylwester Nawrocki (3):
      clk: exynos4: Correct sclk_mfc clock definition
      clk: exynos4: Add camera related clock definitions
      clk: exynos4: export clocks required for fimc-is

Thierry Reding (2):
      clk: tegra: Export peripheral reset functions
      clk: tegra: Make gr2d and gr3d clocks children of pll_c

Thomas Abraham (28):
      pinctrl: exynos: add exynos5250 SoC specific data
      gpio: samsung: skip gpiolib registration if pinctrl support is enabled for exynos5250
      ARM: EXYNOS: skip wakeup interrupt registration for exynos5250 if pinctrl is enabled
      ARM: dts: add board dts file for EXYNOS4412 based Origen board
      ARM: EXYNOS: add a register base address variable in mct controller driver
      ARM: EXYNOS: prepare an array of MCT interrupt numbers and use it
      ARM: EXYNOS: add device tree support for MCT controller driver
      ARM: EXYNOS: allow dt based discovery of mct controller using clocksource_of_init
      ARM: dts: add mct device tree node for all supported Exynos SoC's
      ARM: EXYNOS: remove static io-remapping of mct registers for Exynos5
      ARM: EXYNOS: move mct driver to drivers/clocksource
      clk: samsung: add common clock framework helper functions for Samsung platforms
      clk: samsung: add pll clock registration helper functions
      clk: exynos4: register clocks using common clock framework
      clk: exynos5250: register clocks using common clock framework
      clk: exynos5440: register clocks using common clock framework
      ARM: EXYNOS: Migrate clock support to common clock framework
      ARM: EXYNOS: Initialize the clocks prior to timer initialization
      ARM: EXYNOS: allow legacy board support to specify xxti and xusbxti clock speed
      ARM: EXYNOS: remove auxdata table from exynos4/5 dt machine file
      clocksource: mct: use fin_pll clock as the tick clock source for mct
      clocksource: mct: add support for mct clock setup
      ARM: dts: add Exynos4 and Exynos5 clock controller nodes
      ARM: dts: add clock provider information for all controllers in Exynos4 SoCs
      ARM: dts: add clock provider information for all controllers in Exynos5250 SoC
      ARM: dts: add clock provider information for all controllers in Exynos5440 SoC
      ARM: dts: add board specific fixed rate clock nodes for Exynos based platforms
      ARM: EXYNOS: fix compilation error introduced due to common clock migration

Tomasz Figa (17):
      clk: exynos4: Use mout_mpll_user_* on Exynos4x12
      clk: exynos4: Add missing mout_mipihsi clock
      clk: exynos4: Add missing sclk_audio0 clock
      clk: exynos4: Export sclk_pcm0
      clk: exynos4: Move dac and mixer to Exynos4210-specific clocks
      clk: samsung: Remove unimplemented ops for pll
      clk: exynos4: Export mout_core clock of Exynos4210
      clk: exynos4: Add G3D clocks
      clk: exynos4: Add missing mout_sata on Exynos4210
      clk: exynos4: Define {E,V}PLL registers
      clk: exynos4: Use SRC_MASK_PERIL{0,1} definitions
      clk: exynos4: Remove SoC-specific registers from save list
      clk: exynos4: Add E4210 prefix to LCD1 clock registers
      clk: exynos4: Add E4210 prefix to GATE_IP_PERIR register
      clk: exynos4: Remove E4X12 prefix from SRC_DMC register
      clk: exynos4: Add missing registers to suspend save list
      clk: exynos4: Add support for SoC-specific register save list

Tony Lindgren (3):
      Merge commit '7185684' into omap-for-v3.10/timer
      Merge branch 'omap-timer-for-v3.10' of git://github.com/jonhunter/linux into omap-for-v3.10/timer
      Merge branch 'omap-gpmc-for-v3.10-take2' of git://github.com/jonhunter/linux into omap-for-v3.10/gpmc

Tony Prisk (8):
      of: Add support for reading a u32 from a multi-value property.
      of: Remove duplicated code for validating property and value
      arm: vt8500: Increase available GPIOs on arch-vt8500
      pinctrl: gpio: vt8500: Add pincontrol driver for arch-vt8500
      arm: dts: vt8500: Update Wondermedia SoC dtsi files for pinctrl driver
      arm: vt8500: Remove gpio devicetree nodes
      gpio: vt8500: Remove arch-vt8500 gpio driver
      irqchip: vt8500: Convert arch-vt8500 to new irqchip infrastructure

Tushar Behera (2):
      clk: exynos5250: Fix divider values for sclk_mmc{0,1,2,3}
      clk: exynos5250: Fix parent clock for sclk_mmc{0,1,2,3}

Vivek Gautam (2):
      ARM: dts: Enabling ehci-s5p driver for EXYNOS5250
      ARM: dts: Enabling ohci-exynos driver for EXYNOS5250

Yen Lin (1):
      clk: tegra: Fix periph_clk_to_bit macro


 .../devicetree/bindings/bus/ti-gpmc.txt         |  103 +-
 .../devicetree/bindings/clock/exynos4-clock.txt |  288 +++
 .../bindings/clock/exynos5250-clock.txt         |  177 ++
 .../bindings/clock/exynos5440-clock.txt         |   61 +
 .../bindings/clock/nvidia,tegra114-car.txt      |  303 +++
 .../bindings/clock/nvidia,tegra20-car.txt       |    4 +-
 .../devicetree/bindings/gpio/gpio-vt8500.txt    |   24 -
 .../samsung,s3c24xx-irq.txt                     |   53 +
 .../devicetree/bindings/media/s5p-mfc.txt       |   21 +
 .../devicetree/bindings/mtd/gpmc-nor.txt        |   98 +
 .../devicetree/bindings/mtd/gpmc-onenand.txt    |    3 +
 .../devicetree/bindings/net/gpmc-eth.txt        |   97 +
 .../bindings/pinctrl/pinctrl-vt8500.txt         |   57 +
 .../devicetree/bindings/reset/reset.txt         |   75 +
 .../bindings/timer/cadence,ttc-timer.txt        |   17 +
 .../bindings/timer/samsung,exynos4210-mct.txt   |   68 +
 .../devicetree/bindings/usb/exynos-usb.txt      |   40 +
 arch/arm/Kconfig                                |   16 +-
 arch/arm/boot/dts/Makefile                      |    3 +
 arch/arm/boot/dts/cros5250-common.dtsi          |  138 ++
 arch/arm/boot/dts/exynos4.dtsi                  |   58 +
 arch/arm/boot/dts/exynos4210-origen.dts         |   18 +
 arch/arm/boot/dts/exynos4210-smdkv310.dts       |   18 +
 arch/arm/boot/dts/exynos4210-trats.dts          |   12 +
 arch/arm/boot/dts/exynos4210.dtsi               |   36 +
 arch/arm/boot/dts/exynos4212.dtsi               |   22 +
 arch/arm/boot/dts/exynos4412-odroidx.dts        |  111 +
 arch/arm/boot/dts/exynos4412-origen.dts         |  432 ++++
 arch/arm/boot/dts/exynos4412-smdk4412.dts       |   25 +
 arch/arm/boot/dts/exynos4412.dtsi               |   26 +
 arch/arm/boot/dts/exynos4x12.dtsi               |    6 +
 arch/arm/boot/dts/exynos5250-arndale.dts        |  129 ++
 arch/arm/boot/dts/exynos5250-smdk5250.dts       |   20 +
 arch/arm/boot/dts/exynos5250-snow.dts           |   11 +
 arch/arm/boot/dts/exynos5250.dtsi               |  149 ++
 arch/arm/boot/dts/exynos5440-ssdk5440.dts       |   19 +-
 arch/arm/boot/dts/exynos5440.dtsi               |   67 +-
 arch/arm/boot/dts/omap3-beagle.dts              |   71 +
 arch/arm/boot/dts/omap3.dtsi                    |   31 +
 arch/arm/boot/dts/omap4.dtsi                    |   30 +
 arch/arm/boot/dts/tegra114-dalmore.dts          |    1 -
 arch/arm/boot/dts/tegra114-pluto.dts            |    1 -
 arch/arm/boot/dts/tegra114.dtsi                 |    8 +-
 arch/arm/boot/dts/vt8500.dtsi                   |   10 +-
 arch/arm/boot/dts/wm8505.dtsi                   |   10 +-
 arch/arm/boot/dts/wm8650.dtsi                   |   10 +-
 arch/arm/boot/dts/wm8850.dtsi                   |   10 +-
 arch/arm/boot/dts/zynq-7000.dtsi                |   45 +-
 arch/arm/boot/dts/zynq-zc702.dts                |   10 -
 arch/arm/mach-at91/at91sam9261.c                |    2 +
 arch/arm/mach-at91/at91sam9261_devices.c        |    6 +-
 arch/arm/mach-at91/at91sam9263.c                |    1 +
 arch/arm/mach-at91/at91sam9263_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9g45.c                |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c        |    6 +-
 arch/arm/mach-at91/at91sam9rl.c                 |    1 +
 arch/arm/mach-at91/at91sam9rl_devices.c         |    2 +-
 arch/arm/mach-exynos/Kconfig                    |   12 +-
 arch/arm/mach-exynos/Makefile                   |    6 -
 arch/arm/mach-exynos/clock-exynos4.c            | 1601 --------------
 arch/arm/mach-exynos/clock-exynos4.h            |   35 -
 arch/arm/mach-exynos/clock-exynos4210.c         |  187 --
 arch/arm/mach-exynos/clock-exynos4212.c         |  201 --
 arch/arm/mach-exynos/clock-exynos5.c            | 1645 --------------
 arch/arm/mach-exynos/common.c                   |   88 +-
 arch/arm/mach-exynos/common.h                   |   10 +-
 arch/arm/mach-exynos/include/mach/irqs.h        |   19 +-
 arch/arm/mach-exynos/include/mach/map.h         |    1 -
 arch/arm/mach-exynos/include/mach/regs-mct.h    |   53 -
 arch/arm/mach-exynos/mach-armlex4210.c          |    3 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c          |  122 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c          |  141 +-
 arch/arm/mach-exynos/mach-nuri.c                |    5 +-
 arch/arm/mach-exynos/mach-origen.c              |    5 +-
 arch/arm/mach-exynos/mach-smdk4x12.c            |    5 +-
 arch/arm/mach-exynos/mach-smdkv310.c            |    7 +-
 arch/arm/mach-exynos/mach-universal_c210.c      |    9 +-
 arch/arm/mach-omap2/board-3430sdp.c             |   21 +-
 arch/arm/mach-omap2/board-3630sdp.c             |   21 +-
 arch/arm/mach-omap2/board-am3517crane.c         |   24 +-
 arch/arm/mach-omap2/board-am3517evm.c           |   17 +-
 arch/arm/mach-omap2/board-cm-t35.c              |   20 +-
 arch/arm/mach-omap2/board-cm-t3517.c            |   22 +-
 arch/arm/mach-omap2/board-devkit8000.c          |    8 -
 arch/arm/mach-omap2/board-generic.c             |    2 +-
 arch/arm/mach-omap2/board-igep0020.c            |   32 +-
 arch/arm/mach-omap2/board-omap3beagle.c         |   32 +-
 arch/arm/mach-omap2/board-omap3evm.c            |   25 +-
 arch/arm/mach-omap2/board-omap3pandora.c        |   21 +-
 arch/arm/mach-omap2/board-omap3stalker.c        |   17 +-
 arch/arm/mach-omap2/board-omap3touchbook.c      |   17 +-
 arch/arm/mach-omap2/board-omap4panda.c          |   55 +-
 arch/arm/mach-omap2/board-overo.c               |   16 +-
 arch/arm/mach-omap2/board-zoom.c                |   16 +-
 arch/arm/mach-omap2/common.h                    |    3 +-
 arch/arm/mach-omap2/gpmc-nand.c                 |   42 +-
 arch/arm/mach-omap2/gpmc-onenand.c              |  118 +-
 arch/arm/mach-omap2/gpmc-smc91x.c               |   30 +-
 arch/arm/mach-omap2/gpmc.c                      |  544 +++--
 arch/arm/mach-omap2/gpmc.h                      |   43 +-
 arch/arm/mach-omap2/timer.c                     |  124 +-
 arch/arm/mach-omap2/usb-host.c                  |  160 +-
 arch/arm/mach-omap2/usb-tusb6010.c              |   62 +-
 arch/arm/mach-omap2/usb.h                       |    9 +
 arch/arm/mach-s3c24xx/Kconfig                   |    7 +
 arch/arm/mach-s3c24xx/Makefile                  |    8 +-
 arch/arm/mach-s3c24xx/common.h                  |    4 +
 .../arm/mach-s3c24xx/include/mach/entry-macro.S |   70 -
 arch/arm/mach-s3c24xx/include/mach/irqs.h       |   58 +-
 arch/arm/mach-s3c24xx/irq-s3c2412.c             |  215 --
 arch/arm/mach-s3c24xx/irq-s3c2440.c             |  128 --
 arch/arm/mach-s3c24xx/irq-s3c244x.c             |  142 --
 arch/arm/mach-s3c24xx/mach-amlm5900.c           |    7 +-
 arch/arm/mach-s3c24xx/mach-anubis.c             |    6 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c          |    6 +-
 arch/arm/mach-s3c24xx/mach-bast.c               |    6 +-
 arch/arm/mach-s3c24xx/mach-gta02.c              |    6 +-
 arch/arm/mach-s3c24xx/mach-h1940.c              |   12 +-
 arch/arm/mach-s3c24xx/mach-jive.c               |    6 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c           |    6 +-
 arch/arm/mach-s3c24xx/mach-n30.c                |   10 +-
 arch/arm/mach-s3c24xx/mach-nexcoder.c           |    6 +-
 arch/arm/mach-s3c24xx/mach-osiris.c             |    6 +-
 arch/arm/mach-s3c24xx/mach-otom.c               |    6 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c             |    6 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c             |    6 +-
 arch/arm/mach-s3c24xx/mach-rx3715.c             |   11 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c           |    6 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c           |   14 +-
 arch/arm/mach-s3c24xx/mach-smdk2416.c           |    4 +-
 arch/arm/mach-s3c24xx/mach-smdk2440.c           |    6 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c           |    4 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c         |    6 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c             |    6 +-
 arch/arm/mach-s3c24xx/mach-vstms.c              |    6 +-
 arch/arm/mach-s3c24xx/pm-s3c2412.c              |    8 +
 arch/arm/mach-s3c64xx/Kconfig                   |    2 +
 arch/arm/mach-s3c64xx/mach-anw6410.c            |    4 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c           |    4 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                |    4 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c           |    4 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                |    4 +-
 arch/arm/mach-s3c64xx/mach-real6410.c           |    4 +-
 arch/arm/mach-s3c64xx/mach-smartq.c             |    2 +
 arch/arm/mach-s3c64xx/mach-smartq5.c            |    3 +-
 arch/arm/mach-s3c64xx/mach-smartq7.c            |    3 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c           |    4 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c           |    4 +-
 arch/arm/mach-s5p64x0/Kconfig                   |    4 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c           |    6 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c           |    6 +-
 arch/arm/mach-s5pc100/Kconfig                   |    1 +
 arch/arm/mach-s5pc100/mach-smdkc100.c           |    4 +-
 arch/arm/mach-s5pv210/Kconfig                   |    2 +-
 arch/arm/mach-s5pv210/mach-aquila.c             |    6 +-
 arch/arm/mach-s5pv210/mach-goni.c               |    6 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c           |    6 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c           |    6 +-
 arch/arm/mach-s5pv210/mach-torbreck.c           |    6 +-
 arch/arm/mach-shmobile/Kconfig                  |    2 +
 arch/arm/mach-shmobile/board-kzm9g.c            |   14 +-
 arch/arm/mach-shmobile/include/mach/common.h    |    1 +
 arch/arm/mach-shmobile/include/mach/irqs.h      |    4 +
 arch/arm/mach-shmobile/intc-r8a7779.c           |   53 +-
 arch/arm/mach-shmobile/intc-sh73a0.c            |  117 -
 arch/arm/mach-shmobile/setup-sh73a0.c           |  126 ++
 arch/arm/mach-tegra/tegra.c                     |    3 +
 arch/arm/mach-ux500/board-mop500-pins.c         |   34 +-
 arch/arm/mach-vt8500/Kconfig                    |    1 +
 arch/arm/mach-vt8500/Makefile                   |    2 +-
 arch/arm/mach-vt8500/common.h                   |    6 -
 arch/arm/mach-vt8500/vt8500.c                   |   14 +-
 arch/arm/mach-zynq/Kconfig                      |    1 +
 arch/arm/mach-zynq/Makefile                     |    2 +-
 arch/arm/mach-zynq/common.c                     |    3 +-
 arch/arm/mach-zynq/common.h                     |    2 -
 arch/arm/mach-zynq/timer.c                      |  324 ---
 arch/arm/plat-samsung/Kconfig                   |    6 +-
 arch/arm/plat-samsung/Makefile                  |    3 +-
 arch/arm/plat-samsung/devs.c                    |    2 +-
 arch/arm/plat-samsung/include/plat/cpu.h        |   15 +-
 arch/arm/plat-samsung/include/plat/s5p-time.h   |   40 -
 .../plat-samsung/include/plat/samsung-time.h    |   53 +
 .../plat-samsung/{s5p-time.c => samsung-time.c} |  138 +-
 arch/arm/plat-samsung/time.c                    |  287 ---
 arch/avr32/mach-at32ap/at32ap700x.c             |    6 +-
 drivers/Kconfig                                 |    2 +
 drivers/Makefile                                |    3 +
 drivers/clk/Makefile                            |    1 +
 drivers/clk/samsung/Makefile                    |    8 +
 drivers/clk/samsung/clk-exynos4.c               | 1091 +++++++++
 drivers/clk/samsung/clk-exynos5250.c            |  523 +++++
 drivers/clk/samsung/clk-exynos5440.c            |  139 ++
 drivers/clk/samsung/clk-pll.c                   |  419 ++++
 drivers/clk/samsung/clk-pll.h                   |   41 +
 drivers/clk/samsung/clk.c                       |  320 +++
 drivers/clk/samsung/clk.h                       |  289 +++
 drivers/clk/tegra/Makefile                      |    1 +
 drivers/clk/tegra/clk-periph-gate.c             |   11 +-
 drivers/clk/tegra/clk-periph.c                  |   14 +-
 drivers/clk/tegra/clk-pll.c                     | 1194 ++++++++--
 drivers/clk/tegra/clk-tegra114.c                | 2085 ++++++++++++++++++
 drivers/clk/tegra/clk-tegra20.c                 |  184 +-
 drivers/clk/tegra/clk-tegra30.c                 |  276 +--
 drivers/clk/tegra/clk.c                         |   14 +-
 drivers/clk/tegra/clk.h                         |   98 +-
 drivers/clocksource/Kconfig                     |    8 +
 drivers/clocksource/Makefile                    |    2 +
 drivers/clocksource/cadence_ttc_timer.c         |  436 ++++
 drivers/clocksource/em_sti.c                    |   13 +-
 .../mct.c => drivers/clocksource/exynos_mct.c   |  217 +-
 drivers/clocksource/sh_cmt.c                    |  189 +-
 drivers/clocksource/sh_mtu2.c                   |    2 +-
 drivers/clocksource/sh_tmu.c                    |    2 +-
 drivers/gpio/Kconfig                            |    6 -
 drivers/gpio/Makefile                           |    1 -
 drivers/gpio/gpio-samsung.c                     |    9 +-
 drivers/gpio/gpio-vt8500.c                      |  355 ---
 drivers/irqchip/Kconfig                         |    8 +
 drivers/irqchip/Makefile                        |    4 +
 drivers/irqchip/exynos-combiner.c               |   80 +-
 drivers/irqchip/irq-renesas-intc-irqpin.c       |  547 +++++
 drivers/irqchip/irq-renesas-irqc.c              |  307 +++
 .../irq.c => drivers/irqchip/irq-s3c24xx.c      |  691 +++++-
 .../irq.c => drivers/irqchip/irq-vt8500.c       |    6 +
 drivers/of/base.c                               |  111 +-
 drivers/pinctrl/Kconfig                         |    1 +
 drivers/pinctrl/Makefile                        |    1 +
 drivers/pinctrl/pinctrl-bcm2835.c               |   19 +-
 drivers/pinctrl/pinctrl-exynos.c                |  108 +
 drivers/pinctrl/pinctrl-samsung.c               |    2 +
 drivers/pinctrl/pinctrl-samsung.h               |    1 +
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c             |    6 +-
 drivers/pinctrl/vt8500/Kconfig                  |   52 +
 drivers/pinctrl/vt8500/Makefile                 |    8 +
 drivers/pinctrl/vt8500/pinctrl-vt8500.c         |  501 +++++
 drivers/pinctrl/vt8500/pinctrl-wm8505.c         |  532 +++++
 drivers/pinctrl/vt8500/pinctrl-wm8650.c         |  370 ++++
 drivers/pinctrl/vt8500/pinctrl-wm8750.c         |  409 ++++
 drivers/pinctrl/vt8500/pinctrl-wm8850.c         |  388 ++++
 drivers/pinctrl/vt8500/pinctrl-wmt.c            |  632 ++++++
 drivers/pinctrl/vt8500/pinctrl-wmt.h            |   79 +
 drivers/reset/Kconfig                           |   13 +
 drivers/reset/Makefile                          |    1 +
 drivers/reset/core.c                            |  297 +++
 drivers/video/atmel_lcdfb.c                     |  120 +-
 include/linux/clk/tegra.h                       |    1 +
 include/linux/of.h                              |    9 +
 .../platform_data/irq-renesas-intc-irqpin.h     |   29 +
 include/linux/platform_data/irq-renesas-irqc.h  |   27 +
 include/linux/reset-controller.h                |   51 +
 include/linux/reset.h                           |   17 +
 include/video/atmel_lcdc.h                      |    4 +-
 253 files changed, 16930 insertions(+), 7327 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos4-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5250-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5440-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra114-car.txt
 delete mode 100644 Documentation/devicetree/bindings/gpio/gpio-vt8500.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/samsung,s3c24xx-irq.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/gpmc-nor.txt
 create mode 100644 Documentation/devicetree/bindings/net/gpmc-eth.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-vt8500.txt
 create mode 100644 Documentation/devicetree/bindings/reset/reset.txt
 create mode 100644 Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
 create mode 100644 Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
 create mode 100644 Documentation/devicetree/bindings/usb/exynos-usb.txt
 create mode 100644 arch/arm/boot/dts/exynos4412-odroidx.dts
 create mode 100644 arch/arm/boot/dts/exynos4412-origen.dts
 create mode 100644 arch/arm/boot/dts/exynos5250-arndale.dts
 delete mode 100644 arch/arm/mach-exynos/clock-exynos4.c
 delete mode 100644 arch/arm/mach-exynos/clock-exynos4.h
 delete mode 100644 arch/arm/mach-exynos/clock-exynos4210.c
 delete mode 100644 arch/arm/mach-exynos/clock-exynos4212.c
 delete mode 100644 arch/arm/mach-exynos/clock-exynos5.c
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-mct.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-s3c24xx/irq-s3c2412.c
 delete mode 100644 arch/arm/mach-s3c24xx/irq-s3c2440.c
 delete mode 100644 arch/arm/mach-s3c24xx/irq-s3c244x.c
 delete mode 100644 arch/arm/mach-zynq/timer.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/s5p-time.h
 create mode 100644 arch/arm/plat-samsung/include/plat/samsung-time.h
 rename arch/arm/plat-samsung/{s5p-time.c => samsung-time.c} (68%)
 delete mode 100644 arch/arm/plat-samsung/time.c
 create mode 100644 drivers/clk/samsung/Makefile
 create mode 100644 drivers/clk/samsung/clk-exynos4.c
 create mode 100644 drivers/clk/samsung/clk-exynos5250.c
 create mode 100644 drivers/clk/samsung/clk-exynos5440.c
 create mode 100644 drivers/clk/samsung/clk-pll.c
 create mode 100644 drivers/clk/samsung/clk-pll.h
 create mode 100644 drivers/clk/samsung/clk.c
 create mode 100644 drivers/clk/samsung/clk.h
 create mode 100644 drivers/clk/tegra/clk-tegra114.c
 create mode 100644 drivers/clocksource/cadence_ttc_timer.c
 rename arch/arm/mach-exynos/mct.c => drivers/clocksource/exynos_mct.c (64%)
 delete mode 100644 drivers/gpio/gpio-vt8500.c
 create mode 100644 drivers/irqchip/irq-renesas-intc-irqpin.c
 create mode 100644 drivers/irqchip/irq-renesas-irqc.c
 rename arch/arm/mach-s3c24xx/irq.c => drivers/irqchip/irq-s3c24xx.c (53%)
 rename arch/arm/mach-vt8500/irq.c => drivers/irqchip/irq-vt8500.c (97%)
 create mode 100644 drivers/pinctrl/vt8500/Kconfig
 create mode 100644 drivers/pinctrl/vt8500/Makefile
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-vt8500.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8505.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8650.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8750.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8850.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wmt.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wmt.h
 create mode 100644 drivers/reset/Kconfig
 create mode 100644 drivers/reset/Makefile
 create mode 100644 drivers/reset/core.c
 create mode 100644 include/linux/platform_data/irq-renesas-intc-irqpin.h
 create mode 100644 include/linux/platform_data/irq-renesas-irqc.h
 create mode 100644 include/linux/reset-controller.h
 create mode 100644 include/linux/reset.h
