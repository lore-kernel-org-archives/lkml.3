Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3GBTTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:19:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3GBTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:19:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 3/7] ARM SoC specific changes
Date: Tue, 2 Jul 2013 21:04:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <201307022055.50717.arnd@arndb.de>
In-Reply-To: <201307022055.50717.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201307022104.01826.arnd@arndb.de>
X-Provags-ID: V02:K0:ZW1e+C8UHre+9ugdbbjXwZcf6CtlC0ueDyfTgXsFM8g
 vy6pdMGJuQGwlOZwkyZFObTBiQkRmfqh0w9AfNTrtIh4bSvh5D
 7RKx81uLNW3oN1bZVTqKnSQRO4Go07G0faY6nEDCT0I16zSjYK
 pfiD11T1+GmKAZjJpThQE4D996xk0sLqZTfGumV4fGY3BbmvmK
 Y5Viq83A5GsqNfM+WiFbot3mDzmV/kj62FmkL51S64ZtxKcFkg
 1trE5EiGcqgQrVCa84fR+6jh6MqXi4bFnzLzRHn23Sp5hc1/zp
 kGYp6uL5DaCebO0L9Vc9TADgkzux7eSKqHdwp/8ZxdoEJtbzBo
 gSp75CFXkktb/6rMgRZ4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-linus

for you to fetch changes up to 1eb92b24e243085d242cf5ffd64829bba70972e1:

  ARM: integrator: let pciv3 use mem/premem from device tree (2013-06-27 14:19:54 +0200)

----------------------------------------------------------------
ARM SoC specific changes

These changes are all to SoC-specific code, a total of 33 branches on
17 platforms were pulled into this. Like last time, Renesas sh-mobile
is now the platform with the most changes, followed by OMAP and EXYNOS.

Two new platforms, TI Keystone and Rockchips RK3xxx are added in
this branch, both containing almost no platform specific code at all,
since they are using generic subsystem interfaces for clocks, pinctrl,
interrupts etc. The device drivers are getting merged through the
respective subsystem maintainer trees.

One more SoC (u300) is now multiplatform capable and several others
(shmobile, exynos, msm, integrator, kirkwood, clps711x) are moving
towards that goal with this series but need more work.

Also noteworthy is the work on PCI here, which is traditionally part of
the SoC specific code. With the changes done by Thomas Petazzoni, we can
now more easily have PCI host controller drivers as loadable modules and
keep them separate from the platform code in drivers/pci/host. This has
already led to the discovery that three platforms (exynos, spear and imx)
are actually using an identical PCIe host controller and will be able
to share a driver once support for spear and imx is added.

Conflicts:
* asm/glue-proc.h has one CPU type getting added that conflicts
  with another addition in 3.10-rc7
* Simple context changes in arch/arm/Makefile and arch/arm/Kconfig

----------------------------------------------------------------

Afzal Mohammed (9):
      ARM: OMAP2+: separate out OMAP4 restart
      ARM: OMAP2+: AM43x: Kconfig
      ARM: OMAP2+: AM43x: kbuild
      ARM: OMAP2+: AM43x: soc_is support
      ARM: OMAP2+: AM437x: SoC revision detection
      ARM: OMAP2+: AM43x: static mapping
      ARM: OMAP2+: AM43x: early init
      ARM: OMAP2+: AM43x: GP or HS ?
      ARM: OMAP2+: AM43x: basic dt support

Aida Mynzhasova (2):
      ARM: OMAP2: TI81XX: id: Add cpu id for TI816x ES2.0 and ES2.1
      ARM: OMAP: TI816X: add powerdomains for TI816x

Alexander Shiyan (18):
      GPIO: clps711x: Rewrite driver for using generic GPIO code
      GPIO: clps711x: Add DT support
      ARM: clps711x: Re-add GPIO support
      ARM: clps711x: Remove NEED_MACH_MEMORY_H dependency
      ARM: clps711x: Set PLL clock to zero if we work from 13 mHz source
      ARM: clps711x: autcpu12: Move LCD DPOT definitions to board file
      ARM: clps711x: autcpu12: Add support for NOR flash
      ARM: clps711x: autcpu12: Special driver for handling memory is removed
      ARM: clps711x: autcpu12: Move remaining specific definitions to board file
      ARM: clps711x: p720t: Define PLD registers as GPIOs
      ARM: clps711x: Move specific definitions from hardware.h to boards files
      ARM: clps711x: Replace "arch_initcall" in common code with ".init_early"
      ARM: clps711x: Add clocksource framework
      ARM: clps711x: Optimize interrupt handling
      ARM: clps711x: edb7211: Add support for I2C
      ARM: clps711x: edb7211: Control LCD backlight via PWM
      ARM: clps711x: Add support for SYSCON driver
      ARM: clps711x: Update defconfig

Andrew Lunn (3):
      ARM: Kirkwood: Enable USB 3.0 in kirkwood_defconfig
      arm: kirkwood: Enable cpufreq and ondemand on kirkwood_defconfig
      arm: kirkwood: Instantiate cpufreq driver

Arnaud Ebalard (1):
      arm: kirkwood: NETGEAR ReadyNAS Duo v2 init PCIe via DT

Arnd Bergmann (27):
      drivers/bus: arm-cci: fix combined ARMv6+v7 build
      ARM: EXYNOS: Remove custom init_irq callbacks
      ARM: EXYNOS: Use exynos_init_io() as map_io callback
      ARM: EXYNOS: Remove legacy L2X0 initialization
      ARM: EXYNOS: Remove remaining dead code after non-DT support removal
      Merge tag 'integrator-pci-for-arm-soc' of git://git.kernel.org/.../linusw/linux-integrator into next/soc
      Merge tag 'u300-multiplatform' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc
      Merge tag 'imx-soc-3.11' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      ARM: u300: only build for ARCH_MULTI_V5
      Merge tag 'davinci-for-v3.11/soc-v2' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge tag 'sunxi-defconfig-for-3.11' of git://github.com/mripard/linux into next/soc
      Merge tag 'sunxi-core-for-3.11-2' of git://github.com/mripard/linux into next/soc
      Merge tag 'omap-for-v3.11/soc-part2-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge branch 'omap/pm-voltdomain-cleanup' into next/soc
      Merge tag 'exynos-arch-2' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'remove-nondt-exynos-3' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'samsung-defconfig-1' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'v3.11-rockchip-basics' of git://git.kernel.org/.../mmind/linux-rockchip into next/soc
      Merge tag 'renesas-cleanup-boot-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'regmap-3.11-2' of git://git.infradead.org/users/jcooper/linux into next/soc
      ARM: imx: Synertronixx scb9328 needs to select SOC_IMX1
      ARM: keystone: select ARM_ERRATA_798181 only for SMP
      ARM: imx: select syscon for IMX6SL
      ARM: multiplatform: always pick one CPU type
      Merge tag 'davinci-for-v3.11/soc-2' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge tag 'omap-pm-v3.11/fixes/omap5-voltdm' of git://git.kernel.org/.../khilman/linux-omap-pm into next/soc
      Merge tag 'soc-for-linus' into for-linus

Bastian Hecht (5):
      sh-pfc: Add entries for INTC external IRQs
      sh-pfc: r8a7740: Add SCIFA1 data group
      ARM: shmobile: armadillo800eva: Convert SCIFA1 to pinctrl
      ARM: shmobile: r8a7740: Add interim sh-eth device name to clocks list
      ARM: shmobile: r8a7740: Add I2C DT clock names

Benoit Cousson (7):
      ARM: OMAP5: PRM: Add OMAP54XX register and bitfield files
      ARM: OMAP5: CM: Add OMAP54XX register and bitfield files
      ARM: OMAP5: PRCM: Add OMAP54XX local MPU PRCM registers
      ARM: OMAP5: SCRM: Add OMAP54XX header file.
      ARM: OMAP5: clockdomain data: Add OMAP54XX data and update the header
      ARM: OMAP5: powerdomain data: Add OMAP54XX data and update the header
      ARM: OMAP5: hwmod data: Create initial OMAP5 SOC hwmod data

Catalin Marinas (1):
      ARM: Add base support for ARMv7-M

Dave Martin (1):
      ARM: vexpress/dcscb: handle platform coherency exit/setup and CCI

Dinh Nguyen (2):
      ARM: socfpga: Add support to gate peripheral clocks
      ARM: socfpga: Add syscon to be part of socfpga

Dirk Behme (3):
      ARM: i.MX6: add i.MX6 specific L2 cache configuration
      ARM: i.MX6: clk: add i.MX6 DualLite differences
      ARM: i.MX6: clk: add different DualLite MLB clock config

Dmitry Osipenko (1):
      ARM: tegra: emc: correction of ram-code parsing from dt

Doug Anderson (1):
      ARM: EXYNOS: Select PINCTRL_EXYNOS for exynos4/5 at chip level

Ezequiel Garcia (1):
      ARM: mvebu: Add support for USB storage class in mvebu_defconfig

Fabio Estevam (6):
      ARM: imx: imx_v6_v7_defconfig: Select CONFIG_DRM_IMX_TVE
      ARM: imx: Enable mx6 solo-lite support
      ARM: imx: irq-common: Include header to avoid sparse warning
      ARM: imx: clk: No need to initialize phandle struct
      ARM: imx_v6_v7_defconfig: Enable PWM and backlight options
      ARM: imx_v6_v7_defconfig: Enable Vybrid VF610

Guennadi Liakhovetski (9):
      pinctrl: sh-pfc: fix r8a7790 Function Select register tables
      pinctrl: sh-pfc: fix a typo in pfc-r8a7790
      pinctrl: r8a7790: add pinmux data for MMCIF and SDHI interfaces
      ARM: shmobile: sh73a0: add support for adjusting CPU frequency
      ARM: shmobile: sh73a0: add CPUFreq support
      ARM: shmobile: sh73a0: do not overwrite all div4 clock operations
      ARM: shmobile: sh73a0: div4 clocks must check the kick bit before changing rate
      ARM: shmobile: r8a73a4: add clock definitions and aliases for MMCIF and SDHI
      ARM: shmobile: r8a7790: add clock definitions and aliases for MMCIF and SDHI

Heiko Stuebner (10):
      ARM: S3C24XX: split s3c2412 spi dma channels
      ARM: S3C24XX: dma-s3c2443 - do not write into arbitary bits
      ARM: S3C24XX: remove obsolete s3c2412 specific dma settings
      clocksource: dw_apb_timer_of: enable the use the clocksource as sched clock
      clocksource: dw_apb_timer_of: add clock-handling
      clocksource: dw_apb_timer_of: select DW_APB_TIMER
      clocksource: dw_apb_timer_of: use clocksource_of_init
      arm: Add basic clocks for Rockchip rk3066a SoCs
      arm: add debug uarts for rockchip rk29xx and rk3xxx series
      arm: add basic support for Rockchip RK3066a boards

Huang Shijie (1):
      ARM: imx6q: clk: add the eim_slow clock

Jason Cooper (3):
      ARM: kirkwood: enable Sheevaplug DT in defconfig
      Merge tag 'tags/fixes-non-3.11-1' into mvebu/regmap
      Merge tag 'tags/cleanup-3.11-3' into mvebu/regmap

Jiada Wang (2):
      ARM: imx: disable pll8_mlb in mx6q_clks
      ARM: imx: remove MLB PLL from pllv3

Jingchang Lu (2):
      ARM: imx: add VF610 clock support
      ARM: imx: add initial support for VF610

Jingoo Han (4):
      pci: Add PCIe driver for Samsung Exynos
      ARM: EXYNOS: Enable PCIe support for Exynos5440
      ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC
      ARM: dts: Add pcie controller node for exynos5440-ssdk5440

Jon Medhurst (2):
      ARM: Enable selection of SMP operations at boot time
      ARM: vexpress: Select multi-cluster SMP operation if required

Joseph Lo (12):
      ARM: tegra: add an assembly marco to check Tegra SoC ID
      ARM: tegra: skip SCU and PL310 code when CPU is not Cortex-A9
      ARM: tegra: make tegra_resume can work for Tegra114
      ARM: tegra114: add power up sequence for warm boot CPU
      clk: tegra114: implement wait_for_reset and disable_clock for tegra_cpu_car_ops
      ARM: tegra114: add CPU hotplug support
      ARM: tegra: add cpu_disable for hotplug
      ARM: tegra: remove ifdef in the tegra_resume
      ARM: tegra: cpuidle: move the init function behind the suspend init function
      ARM: tegra: hook tegra_tear_down_cpu function in the PM suspend init function
      ARM: tegra: cpuidle: using IS_ENABLED for multi SoCs management in init func
      ARM: tegra: don't pass CPU ID to tegra_{set,clear}_cpu_in_lp2

Koji Matsuoka (1):
      sh-pfc: Initial r8a7790 PFC support

Kukjin Kim (1):
      ARM: EXYNOS: no more support non-DT for EXYNOS SoCs

Kuninori Morimoto (35):
      gpio-rcar: R-Car GPIO IRQ share interrupt
      ARM: shmobile: add GPIO IRQ macro
      ARM: shmobile: r8a7778: Register PFC device
      sh-pfc: Add r8a7778 pinmux support
      sh-pfc: r8a7779: use RCAR_GP_PIN() on _GP_GPIO() macro
      sh-pfc: r8a7778: add common PFC macro helper
      sh-pfc: r8a7778: add SDHI support
      sh-pfc: r8a7778: tidyup SDHI naming suffixes and sort it alphabetically
      ARM: shmobile: r8a7778: add GPIO support
      sh-pfc: r8a7778: fixup IRQ1A settings
      sh-pfc: r8a7778: add I2C pin groups
      sh-pfc: r8a7778: add HSPI pin groups
      sh-pfc: r8a7778: add MMCIF pin groups
      ARM: shmobile: kzm9g: tidyup FSI pinctrl
      ARM: shmobile: bockw: add pinctrl support
      ARM: shmobile: remove ";" from SH_FIXED_RATIO_CLK*() macro
      ARM: shmobile: use do{ }while() on SH_CLK_SET_RATIO()
      ARM: shmobile: r8a7778: fixup Ether setup code position
      ARM: shmobile: r8a73a4: add main clock
      ARM: shmobile: r8a73a4: add pll clocks
      ARM: shmobile: r8a73a4: add div4 clocks
      ARM: shmobile: r8a73a4: add div6 clocks
      ARM: shmobile: r8a7778: use fixed ratio clock
      ARM: shmobile: r8a7778: add SDHI clock support
      ARM: shmobile: r8a7778: Register SDHI device
      ARM: shmobile: r8a7790: add main clock
      ARM: shmobile: r8a7790: add div4 clocks
      ARM: shmobile: r8a7790: add div6 clocks
      ARM: shmobile: r8a7778: add support I2C clock
      ARM: shmobile: r8a7778: add support HSPI clock
      ARM: shmobile: r8a7778: add support MMC clock
      ARM: shmobile: r8a7778: add support I2C driver
      ARM: shmobile: r8a7778: add support HSPI driver
      ARM: shmobile: r8a7778: add support MMC driver
      ARM: shmobile: Remove Bonito board support

Lad, Prabhakar (2):
      ARM: davinci: remove __init atrribute from function declaration
      ARM: edma: Convert to devm_* api

Laurent Pinchart (102):
      gpio-rcar: Make the platform data gpio_base field signed
      gpio-rcar: Add RCAR_GP_PIN macro
      sh-pfc: Remove dependency on GPIOLIB
      sh-pfc: r8a7790: Add ETH pin groups and functions
      sh-pfc: r8a7790: Add INTC pin groups and functions
      sh-pfc: r8a7790: Add SCIF, SCIFA and SCIFB pin groups and functions
      sh-pfc: r8a7790: Remove GPIO data
      sh-pfc: r8a7790: Remove function GPIOs
      sh-pfc: r8a7790: Don't use GPIO enum entries
      sh-pfc: r8a7779: Replace hardcoded pin numbers with RCAR_GP_PIN macro
      sh-pfc: sh7372: Add BSC pin groups and functions
      sh-pfc: sh7372: Add CEU pin groups and functions
      sh-pfc: sh7372: Add FLCTL pin groups and functions
      sh-pfc: sh7372: Add FSI pin groups and functions
      sh-pfc: sh7372: Add HDMI pin groups and functions
      sh-pfc: sh7372: Add INTC pin groups and functions
      sh-pfc: sh7372: Add KEYSC pin groups and functions
      sh-pfc: sh7372: Add LCDC pin groups and functions
      sh-pfc: sh7372: Add SCIF pin groups and functions
      sh-pfc: sh7372: Add USB pin groups and functions
      ARM: shmobile: mackerel: Register pinctrl mapping for the ADXL34X
      ARM: shmobile: mackerel: Register pinctrl mapping for CEU
      ARM: shmobile: mackerel: Register pinctrl mapping for FLCTL
      ARM: shmobile: mackerel: Register pinctrl mapping for FSI
      ARM: shmobile: mackerel: Register pinctrl mapping for HDMI
      ARM: shmobile: mackerel: Register pinctrl mapping for LCD
      ARM: shmobile: mackerel: Register pinctrl mapping for SCIF
      ARM: shmobile: mackerel: Register IRQ pinctrl mapping for SDHI0
      ARM: shmobile: mackerel: Register pinctrl mapping for SMSC911x
      ARM: shmobile: mackerel: Register pinctrl mapping for ST1232
      ARM: shmobile: mackerel: Register pinctrl mapping for TCA6416
      ARM: shmobile: mackerel: Register pinctrl mapping for USBHS
      ARM: shmobile: ap4evb: Register pinctrl mapping for CEU
      ARM: shmobile: ap4evb: Register pinctrl mapping for FSI
      ARM: shmobile: ap4evb: Register pinctrl mapping for HDMI
      ARM: shmobile: ap4evb: Register pinctrl mapping for KEYSC
      ARM: shmobile: ap4evb: Register pinctrl mapping for LCD
      ARM: shmobile: ap4evb: Register pinctrl mapping for SCIF
      ARM: shmobile: ap4evb: Register pinctrl mapping for SMSC911x
      ARM: shmobile: ap4evb: Simplify tsc2007 pen state read function
      ARM: shmobile: ap4evb: Register pinctrl mapping for TSC2007
      ARM: shmobile: ap4evb: Register pinctrl mapping for USBHS
      sh-pfc: sh7372: Replace GPIO_PORTx enum with GPIO port numbers
      sh-pfc: sh7372: Remove function GPIOs
      ARM: shmobile: sh7372: Remove all GPIOs
      sh-pfc: sh7372: Add bias (pull-up/down) pinconf support
      sh-pfc: r8a7740: Add SCIF pin groups and functions
      sh-pfc: r8a7740: Declare missing INTC function
      sh-pfc: r8a7740: Add BSC pin groups and functions
      sh-pfc: r8a7740: Add GETHER pin groups and functions
      sh-pfc: r8a7740: Add CEU pin groups and functions
      sh-pfc: r8a7740: Add FSI pin groups and functions
      sh-pfc: r8a7740: Add HDMI pin groups and functions
      sh-pfc: r8a7740: Hardcode the LCDC0 output
      ARM: shmobile: armadillo800eva: Register pinctrl mapping for INTC
      ARM: shmobile: armadillo800eva: Register pinctrl mapping for GETHER
      ARM: shmobile: armadillo800eva: Register pinctrl mapping for CEU0
      ARM: shmobile: armadillo800eva: Register pinctrl mapping for FSI
      ARM: shmobile: armadillo800eva: Register pinctrl mapping for HDMI
      ARM: shmobile: armadillo800eva: Don't configure LCDC routing manually
      ARM: shmobile: armadillo800eva: Replace GPIO_PORTx with GPIO port numbers
      ARM: shmobile: bonito: Remove empty core devices array
      ARM: shmobile: bonito: Register pinctrl mapping for SCIF
      ARM: shmobile: bonito: Register pinctrl mapping for INTC
      ARM: shmobile: bonito: Register pinctrl mapping for BSC
      ARM: shmobile: bonito: Don't configure LCDC routing manually
      sh-pfc: r8a7740: Remove SCIF function GPIOS
      sh-pfc: r8a7740: Remove INTC function GPIOS
      sh-pfc: r8a7740: Remove BSC function GPIOS
      sh-pfc: r8a7740: Remove GETHER function GPIOS
      sh-pfc: r8a7740: Remove CEU function GPIOS
      sh-pfc: r8a7740: Remove FSI function GPIOS
      sh-pfc: r8a7740: Remove HDMI function GPIOS
      ARM: shmobile: r8a7740: Remove SCIF function GPIOs
      ARM: shmobile: r8a7740: Remove INTC function GPIOs
      ARM: shmobile: r8a7740: Remove BSC function GPIOs
      ARM: shmobile: r8a7740: Remove GETHER function GPIOs
      ARM: shmobile: r8a7740: Remove CEU function GPIOs
      ARM: shmobile: r8a7740: Remove FSI function GPIOs
      ARM: shmobile: r8a7740: Remove HDMI function GPIOs
      sh-pfc: r8a7740: Remove function GPIOs
      sh-pfc: r8a7740: Replace GPIO_PORTx enum with GPIO port numbers
      ARM: shmobile: r8a7740: Remove all GPIOs
      sh-pfc: r8a7740: Add bias (pull-up/down) pinconf support
      sh-pfc: r8a7778: Fix outdated GPIO_FN comments
      ARM: shmobile: r8a7790: Register GPIO devices
      ARM: shmobile: r8a7790: Remove all GPIOs
      sh-pfc: Add support for SoC-specific initialization
      sh-pfc: sh73a0: Add VCCQ MC0 regulator
      ARM: shmobile: kzm9g: Remove the VCCQ MC0 function GPIO
      ARM: shmobile: kzm9g-reference: Remove the VCCQ MC0 function GPIO
      sh-pfc: sh73a0: Add TPU pin groups and functions
      sh-pfc: r8a7740: Add TPU pin groups and functions
      sh-pfc: r8a7790: Add TPU pin groups and functions
      sh-pfc: sh73a0: Remove function GPIOs
      Revert "ARM: shmobile: Disallow PINCTRL without GPIOLIB"
      ARM: shmobile: lager: Initialize pinmux
      ARM: shmobile: marzen: Use RCAR_GP_PIN macro
      ARM: shmobile: r8a7740: Make private clock arrays static
      ARM: shmobile: r8a7740: add TPU PWM support
      ARM: shmobile: r8a7790: Make private clock arrays static
      ARM: shmobile: r8a7790: add TPU PWM support

Leela Krishna Amudala (1):
      ARM: EXYNOS: call scu_enable() only in case of cortex-A9 processor

Linus Walleij (51):
      ARM: u300: enable delaytimer on the U300
      ARM: u300: device tree support for the timer
      pinctrl: u300 device tree support
      pinctrl: coh901: add device tree support
      ARM: u300: basic device tree support
      i2c: stu300: device tree support
      ARM: u300: register I2C bus drivers from device tree
      watchdog: coh901327: devicetree support
      ARM: u300: add the COH 901 327 watchdog to device tree
      Documentation/devicetree: add a small note on PCI
      ARM: pci: create pci_common_init_dev()
      ARM: integrator: merge PCIv3 driver into one file
      ARM: integrator: convert PCIv3 bridge to platform device
      ARM: integrator: grab PCI error IRQ in probe()
      ARM: integrator: move PCI base address grab to probe
      ARM: integrator: move V3 register definitions into driver
      ARM: integrator: remap PCIv3 base dynamically
      ARM: integrator: move VGA base assignment
      ARM: integrator: move static ioremapping into PCIv3 driver
      ARM: integrator: basic PCIv3 device tree support
      rtc: coh901331: add devicetree support
      ARM: u300: add RTC to device tree
      ARM: u300: set up board power from device tree
      ARM: u300: support regulators in the device tree
      ARM: u300: enable MMC/SD card from device tree
      dma: coh901318: add devicetree support
      ARM: u300: augment device tree with DMA channels
      ARM: u300: add the COH 901 318 DMAC to device tree
      ARM: u300: add SPI PL022 to the device tree
      ARM: u300: probe the U300 dummy-spichip from device tree
      ARM: u300: add FSMC flash into the device tree
      ARM: u300: delete all static board data
      ARM: u300: move debugmacro to debug includes
      ARM: u300: remove deps from debug macro
      ARM: u300: push down syscon registers
      ARM: u300: delete <mach/hardware.h>
      ARM: u300: delete <mach/irqs.h>
      ARM: u300: localize <mach/u300-regs.h>
      ARM: u300: convert to multiplatform
      ARM: u300: delete remnant machine headers
      ARM: u300: add syscon node
      ARM: u300: remove register definition file
      clk: move the U300 fixed and fixed-factor to DT
      i2c: stu300: do not request a specific clock name
      ARM: u300: move the gated system controller clocks to DT
      ARM: u300: convert MMC/SD clock to device tree
      pinctrl: get rid of all platform data for coh901
      spi: pl022: use DMA by default when probing from DT
      ARM: u300: switch to using syscon regmap for board
      ARM: integrator: set local side PCI addresses right
      ARM: integrator: let pciv3 use mem/premem from device tree

Lorenzo Pieralisi (1):
      drivers: bus: add ARM CCI support

Magnus Damm (17):
      ARM: shmobile: r8a7779 pinmux platform device cleanup
      ARM: shmobile: r8a7740 pinmux platform device cleanup
      ARM: shmobile: sh73a0: Always use shmobile_setup_delay()
      ARM: shmobile: uImage load address rework
      ARM: shmobile: Let romImage rely on default ATAGS
      ARM: shmobile: Remove romImage CONFIG_MEMORY_START
      ARM: shmobile: Rework sh7372 sleep code to use virt_to_phys()
      ARM: shmobile: Add SMP boot function and argument
      ARM: shmobile: Add SCU boot function using argument
      ARM: shmobile: r8a7779 SMP with SCU boot fn and args
      ARM: shmobile: sh73a0 SMP with SCU boot fn and args
      ARM: shmobile: EMEV2 SMP with SCU boot fn and args
      ARM: shmobile: Remove old SCU boot code
      ARM: shmobile: Enable ARM_PATCH_PHYS_VIRT
      ARM: shmobile: Remove MEMORY_START/SIZE
      ARM: shmobile: Remove mach/memory.h
      ARM: shmobile: Remove AP4EVB board support

Markus Pargmann (1):
      ARM: imx: Remove mxc specific ulpi access ops

Martin Fuzzey (1):
      ARM: i.MX5: Allow DT clock providers

Matt Porter (6):
      ARM: davinci: move private EDMA API to arm/common
      ARM: edma: remove unused transfer controller handlers
      dmaengine: edma: Add TI EDMA device tree binding
      ARM: edma: Add DT and runtime PM support to the private EDMA API
      ARM: edma: Add EDMA crossbar event mux support
      dmaengine: edma: enable build for AM33XX

Maxime Ripard (2):
      ARM: sunxi: Add Allwinner A10s machine compatible
      ARM: multi_v7: Enable Allwinner EMAC in multi_v7_defconfig

Mohammed, Afzal (1):
      ARM: OMAP2+: AM43x: resolve SMP related build error

Nicolas Pitre (4):
      drivers/bus: arm-cci: function to enable CCI ports from early boot code
      ARM: vexpress: introduce DCSCB support
      ARM: vexpress/dcscb: add CPU use counts to the power up/down API implementation
      ARM: vexpress/dcscb: do not hardcode number of CPUs per cluster

Nicolin Chen (2):
      ARM: clk-imx6qdl: Add clko1 configuration for imx6qdl-sabresd
      ARM: imx_v6_v7_defconfig: Enable imx-wm8962 by default

Nishanth Menon (1):
      ARM: OMAP5: voltagedomain data: remove temporary OMAP4 voltage data

Olof Johansson (22):
      Merge tag 'soc-3.11-2' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge tag 'defconfig-3.11-3' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge tag 'pcie-3.11-2' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge tag 'pcie_kw-3.11' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge tag 'pcie_bridge-3.11' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge tag 'seb_clk-3.11' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge branch 'depends/rmk-devel-stable' into next/soc
      Merge branch 'VExpress_DCSCB' of git://git.linaro.org/people/nico/linux into next/soc
      Merge tag 'zynq-clk-for-3.11' of git://git.xilinx.com/linux-xlnx into next/soc
      Merge tag 'pcie_kw-3.11-2' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge tag 'renesas-pinmux-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge branch 'clps711x/soc' into next/soc
      Merge tag 's3c24xx-arch-1' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'omap-for-v3.11/pm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-for-v3.11/soc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-for-v3.11/omap5-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'regmap-3.11' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge tag 'renesas-phy-rcar-usb-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc2-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'tegra-for-3.11-soc' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'keystone-soc-for-arm-soc' of git://git.kernel.org/.../ssantosh/linux-keystone into next/soc

Peter Huewe (1):
      ARM: u300 use module_spi_driver to register driver

Phil Edworthy (2):
      pinctrl: sh-pfc: r8a7779: Fix missing MOD_SEL2 entry
      ARM: shmobile: r8a7779: Add PCIe clocks

Philip Avinash (1):
      ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK

Philipp Zabel (1):
      ARM i.MX5: Add S/PDIF clocks

Rob Herring (1):
      ARM: introduce common set_auxcr/get_auxcr functions

Roger Quadros (1):
      ARM: OMAP3: clock data: get rid of unused USB host clock aliases and dummies

Rogerio Pimentel (1):
      ARM: imx_v6_v7_defconfig: enable parallel display

Russell King (2):
      Merge branch 'for-next' of git://git.pengutronix.de/git/ukl/linux into devel-stable
      Merge tag '3.10-rc2-psci-ops-11-tag' of git://git.kernel.org/.../sstabellini/xen into devel-stable

Sanjeev Premi (1):
      ARM: OMAP2+: AM43x: SRAM base and size

Santosh Shilimkar (13):
      ARM: OMAP4: PM: Avoid expensive cpu_suspend() path for all CPU power states except off
      ARM: OMAP4+: PM: Consolidate MPU subsystem PM code for re-use
      ARM: OMAP4+: Make secondary_startup function name more consistent
      ARM: OMAP4+: PM: Consolidate OMAP4 PM code to re-use it for OMAP5
      ARM: OMAP4+: PRM: Move function prototypes to common header for re-use
      ARM: OMAP4+: CM: Move function prototypes to common header for re-use
      ARM: OMAP4+: PRCM MPU: Move function prototypes to common header for re-use
      ARM: OMAP5: voltagedomain data: Add OMAP5 voltage domain data
      ARM: OMAP5: Enable build and frameowrk initialisations
      ARM: dts: keystone: Add minimal Keystone SOC device tree data
      ARM: keystone: Add minimal TI Keystone platform support
      ARM: keystone: Enable SMP support on Keystone machines
      ARM: keystone: Move CPU bringup code to dedicated asm file

Sascha Hauer (1):
      ARM i.MX53: Add SATA clock

Sebastian Hesselbarth (10):
      clk: mvebu: introduce per-clock-gate flags
      clk: mvebu: add common clock functions for core clk and clk gating
      clk: mvebu: add Dove SoC-centric clock init
      clk: mvebu: add Kirkwood SoC-centric clock init
      clk: mvebu: add Armada 370 SoC-centric clock init
      clk: mvebu: add Armada XP SoC-centric clock init
      ARM: dove: move DT boards to SoC-centric clock init
      ARM: kirkwood: move DT boards to SoC-centric clock init
      ARM: mvebu: move DT boards to SoC-centric clock init
      clk: mvebu: disintegrate obsolete file

Sergei Shtylyov (18):
      sh-pfc: r8a7778: add USB pin groups
      sh-pfc: r8a7778: add Ether pin groups
      sh-pfc: r8a7779: add Ether pin groups
      ARM: shmobile: r8a7778: correct model name in Kconfig
      ARM: shmobile: r8a7779: fix Ether device name
      ARM: shmobile: r8a7778: fix Ether device name
      ARM: shmobile: Marzen: move USB EHCI, OHCI, and PHY devices to R8A7779 code
      ehci-platform: add pre_setup() method to platform data
      ARM: shmobile: r8a7779: setup EHCI internal buffer
      phy-rcar-usb: remove EHCI internal buffer setup
      ARM: shmobile: r8a7779: remove USB PHY 2nd memory resource
      phy-rcar-usb: correct base address
      phy-rcar-usb: add platform data
      ARM: shmobile: Marzen: pass platform data to USB PHY device
      phy-rcar-usb: handle platform data
      phy-rcar-usb: add R8A7778 support
      ARM: shmobile: r8a7778: add USB support
      ARM: shmobile: BOCK-W: add USB support

Shawn Guo (8):
      ARM: imx: include <asm/io.h> in hardware.h
      ARM: imx: move clk_prepare() out from mxc_restart()
      ARM: imx: create mxc_arch_reset_init_dt() for DT boot
      ARM: imx: add clock support for imx6sl
      ARM: imx: enable low-level debug support for imx6sl
      ARM: imx: add initial support for imx6sl
      ARM: imx6q: call of_clk_init() to register fixed rate clocks
      ARM: imx6: use common of_clk_init() call to initialize clocks

Simon Horman (4):
      gpio-rcar: Add support for IRQ_TYPE_EDGE_BOTH
      ARM: shmobile: r8a7790: Configure R-Car GPIO for IRQ_TYPE_EDGE_BOTH
      ARM: shmobile: sh73a0: Use DEFINE_RES_MEM*() everywhere
      Merge branches 'heads/pinmux' and 'heads/soc' into phy-rcar-usb-base

Soren Brinkmann (4):
      clk: zynq: Factor out PLL driver
      clk: zynq: Add clock controller driver
      arm: zynq: Migrate platform to clock controller
      clk: zynq: Remove deprecated clock code

Stefano Stabellini (1):
      arm: introduce psci_smp_ops

Thomas Petazzoni (27):
      arm: kirkwood: use the default of match table
      arm: mvebu: update defconfig with PCI and USB support
      clk: mvebu: create parent-child relation for PCIe clocks on Armada 370
      clk: mvebu: add more PCIe clocks for Armada XP
      pci: PCIe driver for Marvell Armada 370/XP systems
      arm: mvebu: PCIe support is now available on mvebu
      arm: kirkwood: update defconfig with PCIe driver and board updates
      pci: mvebu: no longer fake the slot location of downstream devices
      pci: mvebu: allow the enumeration of devices beyond physical bridges
      pci: mvebu: fix the emulation of the status register
      pci: mvebu: enable driver usage on Kirkwood
      arm: kirkwood: move PCIe window init to legacy driver
      arm: kirkwood: add SoC-level Device Tree data for PCIe interfaces
      arm: kirkwood: convert Iomega Iconnect to use DT for the PCIe interface
      arm: kirkwood: convert MPL CEC4 to use DT for the PCIe interface
      arm: kirkwood: convert ZyXEL NSA310 to use DT for the PCIe interface
      arm: kirkwood: convert QNAP TS219 to use DT for the PCIe interface
      arm: kirkwood: convert db-88f6281/db-88f6282 to the Device Tree
      arm: mvebu: remove dependency of SMP init on static I/O mapping
      arm: mvebu: avoid hardcoded virtual address in coherency code
      arm: mvebu: move cache and mvebu-mbus initialization later
      arm: mvebu: remove hardcoded static I/O mapping
      arm: mvebu: don't hardcode a physical address in headsmp.S
      arm: mvebu: don't hardcode the physical address for mvebu-mbus
      arm: mvebu: add another earlyprintk Kconfig option
      arm: mvebu: disable DEBUG_LL/EARLY_PRINTK in defconfig
      arm: mvebu: fix coherency_late_init() for multiplatform

Tomasz Figa (30):
      ARM: EXYNOS: Remove unused board files
      ARM: EXYNOS: Make ARCH_EXYNOS select USE_OF
      ARM: SAMSUNG: Introduce SAMSUNG_ATAGS Kconfig entry
      ARM: EXYNOS: Remove legacy PMU initialization code
      ARM: EXYNOS: Remove legacy EINT initialization code
      ARM: EXYNOS: Remove legacy UART initialization code
      ARM: EXYNOS: Remove legacy dev- and setup- files
      ARM: EXYNOS: Remove legacy interrupt initialization code
      ARM: EXYNOS: Remove legacy timer initialization code
      ARM: EXYNOS: Remove platform device initialization
      ARM: EXYNOS: Remove legacy mapping of chip ID block
      ARM: EXYNOS: Remove check for device tree presence
      ARM: EXYNOS: Remove legacy power domain registration code
      ARM: SAMSUNG: Introduce GPIO_SAMSUNG Kconfig entry
      ARM: EXYNOS: Provide compatibility stubs for PM code in pm-core.h header
      ARM: SAMSUNG: Compile legacy IRQ and GPIO PM code only with ATAGS support
      platform: Check for ARCH_EXYNOS separately
      USB: Check for ARCH_EXYNOS separately
      ARM: EXYNOS: Decouple ARCH_EXYNOS from PLAT_S5P
      ARM: SAMSUNG: Include most of mach/ headers conditionally
      ARM: EXYNOS: Do not select legacy Kconfig symbols any more
      ARM: EXYNOS: Remove setup-i2c0.c
      ARM: EXYNOS: Remove mach/gpio.h
      ARM: EXYNOS: Remove mach/regs-gpio.h header
      ARM: SAMSUNG: Make legacy MFC support code depend on SAMSUNG_ATAGS
      ARM: EXYNOS: Select SPARSE_IRQ for Exynos
      ARM: EXYNOS: Remove mach/irqs.h header
      ARM: EXYNOS: Remove unused base addresses from mach/map.h header
      thermal: exynos: Support both EXYNOS4X12 SoCs
      ARM: EXYNOS: Remove mach/regs-usb-phy.h header

Tony Lindgren (4):
      Merge tag 'omap-pm-v3.10/cleanup/pm' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.11/pm
      Merge tag 'omap-devel-b-for-3.11' of http://git.kernel.org/cgit/linux/kernel/git/pjw/omap-pending into omap-for-v3.11/soc
      Merge tag 'omap-devel-a-for-3.11' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.11/omap5
      ARM: OMAP5: Remove unused include for ocp2scp

Tushar Behera (1):
      ARM: exynos_defconfig: Enable GPIO buttons and RTC drivers

Ulf Hansson (1):
      ARM: u300: Update MMC configs for u300 defconfig

Ulrich Hecht (1):
      ARM: shmobile: r8a7790: HSCIF support

Uwe Kleine-König (3):
      ARM: ARMv7-M: Add support for exception handling
      ARM: ARMv7-M: Allow the building of new kernel port
      ARM: ARMv7-M: implement read_cpuid_ext

Vaibhav Hiremath (2):
      ARM: OMAP2+: AM33xx: Add missing reset status info to GFX hwmod
      ARM: OMAP3+: am33xx id: Add new am33xx specific function to check dev_feature

Vivek Gautam (1):
      ARM: EXYNOS: Enable XHCI support on exynos5

Vladimir Barinov (2):
      sh-pfc: r8a7779: add VIN pin groups
      sh-pfc: r8a7778: add VIN pin groups

Wei Yongjun (1):
      pci: mvebu: fix return value check in mvebu_pcie_probe()

 Documentation/arm/sunxi/README                     |    4 +
 Documentation/devicetree/bindings/arm/cci.txt      |  172 +
 .../devicetree/bindings/arm/keystone/keystone.txt  |   10 +
 .../devicetree/bindings/arm/rtsm-dcscb.txt         |   19 +
 Documentation/devicetree/bindings/arm/ste-u300.txt |   46 +
 .../devicetree/bindings/clock/imx5-clock.txt       |   13 +
 .../devicetree/bindings/clock/imx6q-clock.txt      |    1 +
 .../devicetree/bindings/clock/imx6sl-clock.txt     |   10 +
 .../bindings/clock/ste-u300-syscon-clock.txt       |   80 +
 .../devicetree/bindings/clock/vf610-clock.txt      |   26 +
 .../devicetree/bindings/clock/zynq-7000.txt        |  123 +-
 .../devicetree/bindings/dma/ste-coh901318.txt      |   32 +
 Documentation/devicetree/bindings/dma/ti-edma.txt  |   34 +
 .../devicetree/bindings/gpio/gpio-clps711x.txt     |   28 +
 .../bindings/gpio/gpio-stericsson-coh901.txt       |    7 +
 .../devicetree/bindings/i2c/i2c-st-ddci2c.txt      |   15 +
 .../devicetree/bindings/pci/designware-pcie.txt    |   73 +
 .../devicetree/bindings/pci/mvebu-pci.txt          |  221 ++
 Documentation/devicetree/bindings/pci/pci.txt      |    9 +
 .../devicetree/bindings/pci/v3-v360epc-pci.txt     |   15 +
 Documentation/devicetree/bindings/rtc/dw-apb.txt   |   19 +
 .../bindings/timer/stericsson-u300-apptimer.txt    |   18 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 .../bindings/watchdog/stericsson-coh901327.txt     |   19 +
 arch/arm/Kconfig                                   |   64 +-
 arch/arm/Kconfig-nommu                             |    2 +-
 arch/arm/Kconfig.debug                             |  101 +-
 arch/arm/Makefile                                  |    4 +
 arch/arm/boot/compressed/head-shmobile.S           |   21 +-
 arch/arm/boot/dts/Makefile                         |    3 +
 arch/arm/boot/dts/exynos5440-ssdk5440.dts          |    8 +
 arch/arm/boot/dts/exynos5440.dtsi                  |   40 +-
 arch/arm/boot/dts/integratorap.dts                 |   41 +
 arch/arm/boot/dts/keystone.dts                     |  117 +
 arch/arm/boot/dts/kirkwood-6281.dtsi               |   31 +
 arch/arm/boot/dts/kirkwood-6282.dtsi               |   48 +
 arch/arm/boot/dts/kirkwood-db-88f6281.dts          |   30 +
 arch/arm/boot/dts/kirkwood-db-88f6282.dts          |   34 +
 arch/arm/boot/dts/kirkwood-db.dtsi                 |   89 +
 arch/arm/boot/dts/kirkwood-iconnect.dts            |    8 +
 arch/arm/boot/dts/kirkwood-mplcec4.dts             |    8 +
 .../boot/dts/kirkwood-netgear_readynas_duo_v2.dts  |    8 +
 arch/arm/boot/dts/kirkwood-nsa310.dts              |    8 +
 arch/arm/boot/dts/kirkwood-ts219-6281.dts          |    3 +-
 arch/arm/boot/dts/kirkwood-ts219-6282.dts          |    3 +-
 arch/arm/boot/dts/kirkwood-ts219.dtsi              |    9 +-
 arch/arm/boot/dts/kirkwood.dtsi                    |    1 +
 arch/arm/boot/dts/rk3066a-clocks.dtsi              |  299 ++
 arch/arm/boot/dts/rk3066a.dtsi                     |  390 ++
 arch/arm/boot/dts/ste-u300.dts                     |  473 +++
 arch/arm/boot/dts/zynq-7000.dtsi                   |   71 +-
 arch/arm/boot/dts/zynq-zc702.dts                   |    4 -
 arch/arm/common/Kconfig                            |    3 +
 arch/arm/common/Makefile                           |    1 +
 arch/arm/{mach-davinci/dma.c => common/edma.c}     |  368 +-
 arch/arm/configs/ap4evb_defconfig                  |   56 -
 arch/arm/configs/bonito_defconfig                  |   72 -
 arch/arm/configs/clps711x_defconfig                |    8 +-
 arch/arm/configs/exynos_defconfig                  |    3 +
 arch/arm/configs/imx_v6_v7_defconfig               |   10 +
 arch/arm/configs/keystone_defconfig                |  157 +
 arch/arm/configs/kirkwood_defconfig                |   10 +-
 arch/arm/configs/multi_v7_defconfig                |    2 +
 arch/arm/configs/mvebu_defconfig                   |    6 +-
 arch/arm/configs/u300_defconfig                    |   14 +-
 arch/arm/include/asm/assembler.h                   |   17 +-
 arch/arm/include/asm/cp15.h                        |   14 +
 arch/arm/include/asm/cputype.h                     |   44 +-
 arch/arm/include/asm/glue-cache.h                  |   27 +
 arch/arm/include/asm/glue-df.h                     |    8 +
 arch/arm/include/asm/glue-proc.h                   |    9 +
 arch/arm/include/asm/hardware/pci_v3.h             |  186 -
 arch/arm/include/asm/irqflags.h                    |   22 +-
 arch/arm/include/asm/mach/arch.h                   |    5 +
 arch/arm/include/asm/mach/pci.h                    |   17 +-
 arch/arm/include/asm/psci.h                        |    9 +
 arch/arm/include/asm/ptrace.h                      |    4 +
 arch/arm/include/asm/system_info.h                 |    1 +
 arch/arm/include/asm/v7m.h                         |   44 +
 arch/arm/include/debug/imx-uart.h                  |   10 +
 arch/arm/include/debug/keystone.S                  |   43 +
 arch/arm/include/debug/mvebu.S                     |    5 +
 arch/arm/include/debug/rockchip.S                  |   42 +
 .../mach/debug-macro.S => include/debug/u300.S}    |    9 +-
 arch/arm/include/uapi/asm/ptrace.h                 |   35 +-
 arch/arm/kernel/Makefile                           |   13 +-
 arch/arm/kernel/bios32.c                           |    9 +-
 arch/arm/kernel/entry-common.S                     |    4 +
 arch/arm/kernel/entry-header.S                     |  124 +
 arch/arm/kernel/entry-v7m.S                        |  143 +
 arch/arm/kernel/head-nommu.S                       |   10 +-
 arch/arm/kernel/psci.c                             |    7 +-
 arch/arm/kernel/psci_smp.c                         |   84 +
 arch/arm/kernel/setup.c                            |   26 +-
 arch/arm/kernel/traps.c                            |    8 +
 arch/arm/mach-clps711x/Kconfig                     |    3 +-
 arch/arm/mach-clps711x/Makefile                    |    5 +-
 arch/arm/mach-clps711x/board-autcpu12.c            |  133 +-
 arch/arm/mach-clps711x/board-cdb89712.c            |    3 +
 arch/arm/mach-clps711x/board-clep7312.c            |    1 +
 arch/arm/mach-clps711x/board-edb7211.c             |   34 +-
 arch/arm/mach-clps711x/board-fortunet.c            |    1 +
 arch/arm/mach-clps711x/board-p720t.c               |  254 +-
 arch/arm/mach-clps711x/common.c                    |   89 +-
 arch/arm/mach-clps711x/common.h                    |    1 +
 arch/arm/mach-clps711x/devices.c                   |   68 +
 arch/arm/mach-clps711x/devices.h                   |   12 +
 arch/arm/mach-clps711x/include/mach/autcpu12.h     |   59 -
 arch/arm/mach-clps711x/include/mach/clps711x.h     |   88 +-
 arch/arm/mach-clps711x/include/mach/hardware.h     |    7 -
 arch/arm/mach-clps711x/include/mach/memory.h       |   41 -
 arch/arm/mach-clps711x/include/mach/syspld.h       |  116 -
 arch/arm/mach-davinci/Makefile                     |    2 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |    2 +-
 arch/arm/mach-davinci/davinci.h                    |   30 +-
 arch/arm/mach-davinci/devices-da8xx.c              |    8 +-
 arch/arm/mach-davinci/devices-tnetv107x.c          |    6 +-
 arch/arm/mach-davinci/devices.c                    |    6 +-
 arch/arm/mach-davinci/dm355.c                      |    6 +-
 arch/arm/mach-davinci/dm365.c                      |    6 +-
 arch/arm/mach-davinci/dm644x.c                     |    6 +-
 arch/arm/mach-davinci/dm646x.c                     |    6 +-
 arch/arm/mach-davinci/include/mach/cp_intc.h       |    4 +-
 arch/arm/mach-davinci/include/mach/da8xx.h         |   18 +-
 arch/arm/mach-davinci/include/mach/tnetv107x.h     |    6 +-
 arch/arm/mach-dove/Kconfig                         |    3 +-
 arch/arm/mach-dove/board-dt.c                      |    3 +-
 arch/arm/mach-dove/common.c                        |    1 -
 arch/arm/mach-exynos/Kconfig                       |  352 +-
 arch/arm/mach-exynos/Makefile                      |   33 -
 arch/arm/mach-exynos/common.c                      |  547 +--
 arch/arm/mach-exynos/common.h                      |    4 +-
 arch/arm/mach-exynos/dev-ahci.c                    |  255 --
 arch/arm/mach-exynos/dev-audio.c                   |  254 --
 arch/arm/mach-exynos/dev-ohci.c                    |   52 -
 arch/arm/mach-exynos/dev-uart.c                    |   55 -
 arch/arm/mach-exynos/dma.c                         |  322 --
 arch/arm/mach-exynos/firmware.c                    |   22 +-
 arch/arm/mach-exynos/include/mach/gpio.h           |  289 --
 arch/arm/mach-exynos/include/mach/irqs.h           |  476 ---
 arch/arm/mach-exynos/include/mach/map.h            |  214 --
 arch/arm/mach-exynos/include/mach/pm-core.h        |   12 +-
 arch/arm/mach-exynos/include/mach/regs-gpio.h      |   40 -
 arch/arm/mach-exynos/include/mach/regs-usb-phy.h   |   74 -
 arch/arm/mach-exynos/mach-armlex4210.c             |  207 --
 arch/arm/mach-exynos/mach-exynos4-dt.c             |    8 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    8 +-
 arch/arm/mach-exynos/mach-nuri.c                   | 1388 -------
 arch/arm/mach-exynos/mach-origen.c                 |  823 -----
 arch/arm/mach-exynos/mach-smdk4x12.c               |  396 --
 arch/arm/mach-exynos/mach-smdkv310.c               |  444 ---
 arch/arm/mach-exynos/mach-universal_c210.c         | 1159 ------
 arch/arm/mach-exynos/platsmp.c                     |    2 +-
 arch/arm/mach-exynos/pm.c                          |    1 -
 arch/arm/mach-exynos/pm_domains.c                  |  101 +-
 arch/arm/mach-exynos/setup-fimc.c                  |   44 -
 arch/arm/mach-exynos/setup-fimd0.c                 |   43 -
 arch/arm/mach-exynos/setup-i2c0.c                  |   29 -
 arch/arm/mach-exynos/setup-i2c1.c                  |   23 -
 arch/arm/mach-exynos/setup-i2c2.c                  |   23 -
 arch/arm/mach-exynos/setup-i2c3.c                  |   23 -
 arch/arm/mach-exynos/setup-i2c4.c                  |   23 -
 arch/arm/mach-exynos/setup-i2c5.c                  |   23 -
 arch/arm/mach-exynos/setup-i2c6.c                  |   23 -
 arch/arm/mach-exynos/setup-i2c7.c                  |   23 -
 arch/arm/mach-exynos/setup-keypad.c                |   36 -
 arch/arm/mach-exynos/setup-sdhci-gpio.c            |  152 -
 arch/arm/mach-exynos/setup-spi.c                   |   45 -
 arch/arm/mach-exynos/setup-usb-phy.c               |  223 --
 arch/arm/mach-imx/Kconfig                          |   65 +-
 arch/arm/mach-imx/Makefile                         |    4 +-
 arch/arm/mach-imx/clk-imx51-imx53.c                |   73 +-
 arch/arm/mach-imx/clk-imx6q.c                      |   48 +-
 arch/arm/mach-imx/clk-imx6sl.c                     |  267 ++
 arch/arm/mach-imx/clk-pllv3.c                      |   10 -
 arch/arm/mach-imx/clk-vf610.c                      |  319 ++
 arch/arm/mach-imx/clk.c                            |   35 +
 arch/arm/mach-imx/clk.h                            |    4 +-
 arch/arm/mach-imx/common.h                         |    2 +-
 arch/arm/mach-imx/hardware.h                       |    1 +
 arch/arm/mach-imx/imx25-dt.c                       |    2 +
 arch/arm/mach-imx/imx27-dt.c                       |    2 +
 arch/arm/mach-imx/imx31-dt.c                       |    2 +
 arch/arm/mach-imx/imx51-dt.c                       |    2 +
 arch/arm/mach-imx/irq-common.c                     |    1 +
 arch/arm/mach-imx/mach-imx53.c                     |    3 +
 arch/arm/mach-imx/mach-imx6q.c                     |   81 +-
 arch/arm/mach-imx/mach-imx6sl.c                    |   52 +
 arch/arm/mach-imx/mach-pca100.c                    |    4 +-
 arch/arm/mach-imx/mach-vf610.c                     |   48 +
 arch/arm/mach-imx/mm-imx1.c                        |    2 +-
 arch/arm/mach-imx/mm-imx21.c                       |    2 +-
 arch/arm/mach-imx/mm-imx25.c                       |    2 +-
 arch/arm/mach-imx/mm-imx27.c                       |    2 +-
 arch/arm/mach-imx/mm-imx3.c                        |    4 +-
 arch/arm/mach-imx/mm-imx5.c                        |    3 +-
 arch/arm/mach-imx/system.c                         |   47 +-
 arch/arm/mach-imx/ulpi.c                           |  118 -
 arch/arm/mach-imx/ulpi.h                           |   11 +-
 arch/arm/mach-integrator/Makefile                  |    2 +-
 arch/arm/mach-integrator/include/mach/platform.h   |   23 -
 arch/arm/mach-integrator/integrator_ap.c           |   31 +-
 arch/arm/mach-integrator/pci.c                     |  113 -
 arch/arm/mach-integrator/pci_v3.c                  |  564 ++-
 arch/arm/mach-integrator/pci_v3.h                  |    2 +
 arch/arm/mach-keystone/Kconfig                     |   15 +
 arch/arm/mach-keystone/Makefile                    |    6 +
 arch/arm/mach-keystone/Makefile.boot               |    1 +
 arch/arm/mach-keystone/keystone.c                  |   75 +
 arch/arm/mach-keystone/keystone.h                  |   23 +
 arch/arm/mach-keystone/platsmp.c                   |   43 +
 arch/arm/mach-keystone/smc.S                       |   29 +
 arch/arm/mach-kirkwood/Kconfig                     |   24 +-
 arch/arm/mach-kirkwood/Makefile                    |    3 +-
 arch/arm/mach-kirkwood/board-db88f628x-bp.c        |   24 +
 arch/arm/mach-kirkwood/board-dt.c                  |   18 +-
 arch/arm/mach-kirkwood/board-iconnect.c            |    8 -
 arch/arm/mach-kirkwood/board-mplcec4.c             |    1 -
 arch/arm/mach-kirkwood/board-nsa310.c              |   25 -
 arch/arm/mach-kirkwood/board-readynas.c            |    1 -
 arch/arm/mach-kirkwood/common.c                    |   47 +-
 arch/arm/mach-kirkwood/common.h                    |    8 +
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c        |  108 -
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h  |    2 +
 arch/arm/mach-kirkwood/pcie.c                      |   22 +
 arch/arm/mach-mvebu/Kconfig                        |    7 +-
 arch/arm/mach-mvebu/armada-370-xp.c                |   53 +-
 arch/arm/mach-mvebu/armada-370-xp.h                |   10 -
 arch/arm/mach-mvebu/coherency.c                    |   45 +-
 arch/arm/mach-mvebu/coherency.h                    |    4 -
 arch/arm/mach-mvebu/common.h                       |    2 +
 arch/arm/mach-mvebu/headsmp.S                      |   16 +-
 arch/arm/mach-mvebu/platsmp.c                      |   10 +-
 arch/arm/mach-omap2/Kconfig                        |    9 +
 arch/arm/mach-omap2/Makefile                       |   19 +-
 arch/arm/mach-omap2/am33xx.h                       |    1 +
 arch/arm/mach-omap2/board-generic.c                |   16 +
 arch/arm/mach-omap2/cclock33xx_data.c              |   30 +
 arch/arm/mach-omap2/cclock3xxx_data.c              |   11 -
 arch/arm/mach-omap2/clockdomain.h                  |    1 +
 arch/arm/mach-omap2/clockdomains54xx_data.c        |  464 +++
 arch/arm/mach-omap2/cm-regbits-54xx.h              | 1737 +++++++++
 arch/arm/mach-omap2/cm1_44xx.h                     |    7 +-
 arch/arm/mach-omap2/cm1_54xx.h                     |  213 ++
 arch/arm/mach-omap2/cm2_44xx.h                     |    7 +-
 arch/arm/mach-omap2/cm2_54xx.h                     |  389 ++
 arch/arm/mach-omap2/cm33xx.h                       |    2 +-
 arch/arm/mach-omap2/cm_44xx_54xx.h                 |   36 +
 arch/arm/mach-omap2/common.h                       |    5 +-
 arch/arm/mach-omap2/control.h                      |   12 +
 arch/arm/mach-omap2/id.c                           |   32 +-
 arch/arm/mach-omap2/io.c                           |   25 +-
 arch/arm/mach-omap2/omap-headsmp.S                 |    8 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |   69 +-
 arch/arm/mach-omap2/omap-smp.c                     |    6 +-
 arch/arm/mach-omap2/omap4-common.c                 |   16 -
 arch/arm/mach-omap2/omap4-restart.c                |   27 +
 arch/arm/mach-omap2/omap_hwmod.h                   |    1 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |    3 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         | 2150 +++++++++++
 arch/arm/mach-omap2/pm44xx.c                       |   58 +-
 arch/arm/mach-omap2/powerdomain.h                  |    1 +
 arch/arm/mach-omap2/powerdomains3xxx_data.c        |   62 +
 arch/arm/mach-omap2/powerdomains54xx_data.c        |  331 ++
 arch/arm/mach-omap2/prcm-common.h                  |   11 +
 arch/arm/mach-omap2/prcm44xx.h                     |    6 +
 arch/arm/mach-omap2/prcm_mpu44xx.h                 |   14 +-
 arch/arm/mach-omap2/prcm_mpu54xx.h                 |   87 +
 arch/arm/mach-omap2/prcm_mpu_44xx_54xx.h           |   36 +
 arch/arm/mach-omap2/prm-regbits-54xx.h             | 2701 ++++++++++++++
 arch/arm/mach-omap2/prm44xx.h                      |   33 +-
 arch/arm/mach-omap2/prm44xx_54xx.h                 |   58 +
 arch/arm/mach-omap2/prm54xx.h                      |  421 +++
 arch/arm/mach-omap2/scrm54xx.h                     |  231 ++
 arch/arm/mach-omap2/soc.h                          |   26 +
 arch/arm/mach-omap2/sram.c                         |    3 +
 arch/arm/mach-omap2/timer.c                        |    2 +-
 arch/arm/mach-omap2/voltage.h                      |    1 +
 arch/arm/mach-omap2/voltagedomains54xx_data.c      |   92 +
 arch/arm/mach-picoxcell/Kconfig                    |    1 -
 arch/arm/mach-picoxcell/common.c                   |    2 -
 arch/arm/mach-rockchip/Kconfig                     |   16 +
 arch/arm/mach-rockchip/Makefile                    |    1 +
 arch/arm/mach-rockchip/rockchip.c                  |   52 +
 arch/arm/mach-s3c24xx/dma-s3c2412.c                |   56 +-
 arch/arm/mach-s3c24xx/dma-s3c2443.c                |    3 +-
 arch/arm/mach-s3c24xx/dma.c                        |    3 -
 arch/arm/mach-shmobile/Kconfig                     |   65 +-
 arch/arm/mach-shmobile/Makefile                    |    2 -
 arch/arm/mach-shmobile/Makefile.boot               |   18 +-
 arch/arm/mach-shmobile/board-ap4evb.c              | 1332 -------
 arch/arm/mach-shmobile/board-armadillo800eva.c     |  116 +-
 arch/arm/mach-shmobile/board-bockw.c               |   21 +
 arch/arm/mach-shmobile/board-bonito.c              |  495 ---
 arch/arm/mach-shmobile/board-kzm9g-reference.c     |    1 -
 arch/arm/mach-shmobile/board-kzm9g.c               |   11 +-
 arch/arm/mach-shmobile/board-lager.c               |   15 +
 arch/arm/mach-shmobile/board-mackerel.c            |  171 +-
 arch/arm/mach-shmobile/board-marzen.c              |  188 +-
 arch/arm/mach-shmobile/clock-r8a73a4.c             |  387 +-
 arch/arm/mach-shmobile/clock-r8a7740.c             |   11 +-
 arch/arm/mach-shmobile/clock-r8a7778.c             |  183 +-
 arch/arm/mach-shmobile/clock-r8a7779.c             |    4 +-
 arch/arm/mach-shmobile/clock-r8a7790.c             |  255 +-
 arch/arm/mach-shmobile/clock-sh73a0.c              |  111 +-
 arch/arm/mach-shmobile/headsmp-scu.S               |   29 +-
 arch/arm/mach-shmobile/headsmp.S                   |   13 +-
 arch/arm/mach-shmobile/include/mach/clock.h        |    8 +-
 arch/arm/mach-shmobile/include/mach/common.h       |    6 +-
 .../arm/mach-shmobile/include/mach/head-ap4evb.txt |   93 -
 arch/arm/mach-shmobile/include/mach/irqs.h         |    5 +
 arch/arm/mach-shmobile/include/mach/memory.h       |    7 -
 arch/arm/mach-shmobile/include/mach/mmc-ap4eb.h    |   29 -
 arch/arm/mach-shmobile/include/mach/mmc.h          |    4 +-
 arch/arm/mach-shmobile/include/mach/r8a7740.h      |  488 ---
 arch/arm/mach-shmobile/include/mach/r8a7778.h      |   11 +
 arch/arm/mach-shmobile/include/mach/r8a7779.h      |    3 +
 arch/arm/mach-shmobile/include/mach/sh7372.h       |  393 +-
 arch/arm/mach-shmobile/include/mach/zboot.h        |    6 +-
 arch/arm/mach-shmobile/pm-sh7372.c                 |    3 +
 arch/arm/mach-shmobile/setup-r8a7740.c             |   24 +-
 arch/arm/mach-shmobile/setup-r8a7778.c             |  262 +-
 arch/arm/mach-shmobile/setup-r8a7779.c             |  215 +-
 arch/arm/mach-shmobile/setup-r8a7790.c             |   36 +-
 arch/arm/mach-shmobile/setup-sh73a0.c              |   95 +-
 arch/arm/mach-shmobile/sleep-sh7372.S              |    5 +-
 arch/arm/mach-shmobile/smp-emev2.c                 |    6 +-
 arch/arm/mach-shmobile/smp-r8a7779.c               |    6 +-
 arch/arm/mach-shmobile/smp-sh73a0.c                |    6 +-
 arch/arm/mach-socfpga/Kconfig                      |    2 +-
 arch/arm/mach-socfpga/socfpga.c                    |    2 -
 arch/arm/mach-sunxi/sunxi.c                        |    1 +
 arch/arm/mach-tegra/Makefile                       |    1 +
 arch/arm/mach-tegra/common.c                       |    2 +
 arch/arm/mach-tegra/common.h                       |    1 +
 arch/arm/mach-tegra/cpuidle-tegra20.c              |   10 +-
 arch/arm/mach-tegra/cpuidle-tegra30.c              |   10 +-
 arch/arm/mach-tegra/cpuidle.c                      |   19 +-
 arch/arm/mach-tegra/cpuidle.h                      |   15 +-
 arch/arm/mach-tegra/flowctrl.h                     |    1 +
 arch/arm/mach-tegra/fuse.h                         |   22 +-
 arch/arm/mach-tegra/hotplug.c                      |   13 +
 arch/arm/mach-tegra/platsmp.c                      |   26 +-
 arch/arm/mach-tegra/pm.c                           |   25 +-
 arch/arm/mach-tegra/pm.h                           |    4 +-
 arch/arm/mach-tegra/reset-handler.S                |   51 +-
 arch/arm/mach-tegra/sleep-tegra30.S                |   30 +-
 arch/arm/mach-tegra/sleep.S                        |    8 +-
 arch/arm/mach-tegra/sleep.h                        |   35 +-
 arch/arm/mach-tegra/tegra2_emc.c                   |    2 +-
 arch/arm/mach-u300/Kconfig                         |   32 +-
 arch/arm/mach-u300/Makefile                        |    2 -
 arch/arm/mach-u300/core.c                          |  759 ++--
 arch/arm/mach-u300/dummyspichip.c                  |   20 +-
 arch/arm/mach-u300/i2c.c                           |  285 --
 arch/arm/mach-u300/i2c.h                           |   23 -
 arch/arm/mach-u300/include/mach/hardware.h         |    5 -
 arch/arm/mach-u300/include/mach/irqs.h             |   80 -
 arch/arm/mach-u300/include/mach/syscon.h           |  592 ---
 arch/arm/mach-u300/include/mach/timex.h            |   17 -
 arch/arm/mach-u300/include/mach/u300-regs.h        |  165 -
 arch/arm/mach-u300/include/mach/uncompress.h       |   45 -
 arch/arm/mach-u300/regulator.c                     |   67 +-
 arch/arm/mach-u300/spi.c                           |  102 -
 arch/arm/mach-u300/spi.h                           |   26 -
 arch/arm/mach-u300/timer.c                         |  113 +-
 arch/arm/mach-u300/timer.h                         |    1 -
 arch/arm/mach-u300/u300-gpio.h                     |   70 -
 arch/arm/mach-vexpress/Kconfig                     |    9 +
 arch/arm/mach-vexpress/Makefile                    |    1 +
 arch/arm/mach-vexpress/core.h                      |    2 +
 arch/arm/mach-vexpress/dcscb.c                     |  253 ++
 arch/arm/mach-vexpress/dcscb_setup.S               |   38 +
 arch/arm/mach-vexpress/platsmp.c                   |   20 +
 arch/arm/mach-vexpress/v2m.c                       |    1 +
 arch/arm/mach-virt/Makefile                        |    1 -
 arch/arm/mach-virt/platsmp.c                       |   50 -
 arch/arm/mach-virt/virt.c                          |    3 -
 arch/arm/mach-zynq/slcr.c                          |    2 +-
 arch/arm/mm/Kconfig                                |   21 +-
 arch/arm/mm/Makefile                               |    2 +
 arch/arm/mm/cache-nop.S                            |   50 +
 arch/arm/mm/nommu.c                                |    7 +
 arch/arm/mm/proc-v7m.S                             |  157 +
 arch/arm/plat-samsung/Kconfig                      |   47 +-
 arch/arm/plat-samsung/Makefile                     |   11 +-
 arch/arm/plat-samsung/include/plat/dma-s3c24xx.h   |    5 -
 arch/arm/plat-samsung/include/plat/pm.h            |    5 +
 arch/arm/plat-samsung/init.c                       |    8 +-
 arch/arm/plat-samsung/pm-gpio.c                    |    5 +-
 arch/arm/plat-samsung/pm.c                         |    8 +-
 arch/arm/plat-samsung/s5p-dev-mfc.c                |   11 +-
 drivers/bus/Kconfig                                |    7 +
 drivers/bus/Makefile                               |    2 +
 drivers/bus/arm-cci.c                              |  533 +++
 drivers/clk/Makefile                               |    2 +-
 drivers/clk/clk-u300.c                             |  718 +++-
 drivers/clk/clk-zynq.c                             |  378 --
 drivers/clk/mvebu/Kconfig                          |   25 +-
 drivers/clk/mvebu/Makefile                         |    8 +-
 drivers/clk/mvebu/armada-370.c                     |  176 +
 drivers/clk/mvebu/armada-xp.c                      |  210 ++
 drivers/clk/mvebu/clk-core.c                       |  675 ----
 drivers/clk/mvebu/clk-core.h                       |   18 -
 drivers/clk/mvebu/clk-gating-ctrl.c                |  250 --
 drivers/clk/mvebu/clk-gating-ctrl.h                |   22 -
 drivers/clk/mvebu/clk.c                            |   23 -
 drivers/clk/mvebu/common.c                         |  163 +
 drivers/clk/mvebu/common.h                         |   48 +
 drivers/clk/mvebu/dove.c                           |  194 +
 drivers/clk/mvebu/kirkwood.c                       |  247 ++
 drivers/clk/socfpga/clk.c                          |  194 +-
 drivers/clk/tegra/clk-tegra114.c                   |   23 +-
 drivers/clk/zynq/Makefile                          |    3 +
 drivers/clk/zynq/clkc.c                            |  533 +++
 drivers/clk/zynq/pll.c                             |  235 ++
 drivers/clocksource/Kconfig                        |    2 +
 drivers/clocksource/cadence_ttc_timer.c            |   23 +-
 drivers/clocksource/dw_apb_timer_of.c              |   95 +-
 drivers/cpuidle/cpuidle-calxeda.c                  |   14 -
 drivers/dma/Kconfig                                |    2 +-
 drivers/dma/coh901318.c                            |   43 +
 drivers/dma/edma.c                                 |    2 +-
 drivers/gpio/Kconfig                               |   12 +-
 drivers/gpio/Makefile                              |    2 +-
 drivers/gpio/gpio-clps711x.c                       |  236 +-
 drivers/gpio/gpio-rcar.c                           |   28 +-
 drivers/i2c/busses/i2c-stu300.c                    |   16 +-
 drivers/media/platform/Kconfig                     |    6 +-
 drivers/media/platform/exynos4-is/Kconfig          |    3 +-
 drivers/media/platform/s5p-tv/Kconfig              |    2 +-
 drivers/mfd/syscon.c                               |    3 +
 drivers/mmc/host/davinci_mmc.c                     |    1 +
 drivers/mtd/maps/Kconfig                           |    7 -
 drivers/mtd/maps/Makefile                          |    1 -
 drivers/mtd/maps/autcpu12-nvram.c                  |  129 -
 drivers/pci/Kconfig                                |    2 +
 drivers/pci/Makefile                               |    3 +
 drivers/pci/host/Kconfig                           |   17 +
 drivers/pci/host/Makefile                          |    2 +
 drivers/pci/host/pci-mvebu.c                       |  914 +++++
 drivers/pci/host/pcie-designware.c                 | 1057 ++++++
 drivers/pinctrl/Kconfig                            |    5 +-
 drivers/pinctrl/pinctrl-coh901.c                   |   35 +-
 drivers/pinctrl/pinctrl-u300.c                     |    7 +
 drivers/pinctrl/sh-pfc/Kconfig                     |   13 +-
 drivers/pinctrl/sh-pfc/Makefile                    |    2 +
 drivers/pinctrl/sh-pfc/core.c                      |   22 +-
 drivers/pinctrl/sh-pfc/core.h                      |    4 +
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c               | 1923 +++++++---
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               | 2783 ++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c               |  493 ++-
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c               | 3835 ++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7372.c                | 1652 ++++++---
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |  742 ++--
 drivers/pinctrl/sh-pfc/sh_pfc.h                    |    4 +-
 drivers/rtc/rtc-coh901331.c                        |    6 +
 drivers/spi/spi-pl022.c                            |    1 +
 drivers/thermal/exynos_thermal.c                   |    3 +-
 drivers/tty/serial/xilinx_uartps.c                 |   85 +-
 drivers/usb/Kconfig                                |    1 +
 drivers/usb/host/Kconfig                           |    2 +-
 drivers/usb/host/ehci-platform.c                   |    6 +
 drivers/usb/phy/Kconfig                            |   10 +-
 drivers/usb/phy/phy-rcar-usb.c                     |  128 +-
 drivers/watchdog/coh901327_wdt.c                   |   12 +-
 include/dt-bindings/clock/imx6sl-clock.h           |  148 +
 include/dt-bindings/clock/vf610-clock.h            |  163 +
 include/linux/arm-cci.h                            |   61 +
 include/linux/clk/mvebu.h                          |   22 -
 include/linux/clk/zynq.h                           |    8 +-
 include/linux/dw_apb_timer.h                       |    1 -
 include/linux/mfd/davinci_voicecodec.h             |    3 +-
 include/linux/mfd/syscon/clps711x.h                |   94 +
 .../mach => include/linux/platform_data}/edma.h    |   94 +-
 include/linux/platform_data/gpio-rcar.h            |    5 +-
 include/linux/platform_data/pinctrl-coh901.h       |   22 -
 include/linux/platform_data/spi-davinci.h          |    2 +-
 include/linux/platform_data/usb-rcar-phy.h         |   28 +
 include/linux/usb/ehci_pdriver.h                   |    4 +
 sound/soc/davinci/davinci-evm.c                    |    1 +
 sound/soc/davinci/davinci-pcm.c                    |    1 +
 sound/soc/davinci/davinci-pcm.h                    |    2 +-
 483 files changed, 34845 insertions(+), 19523 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/cci.txt
 create mode 100644 Documentation/devicetree/bindings/arm/keystone/keystone.txt
 create mode 100644 Documentation/devicetree/bindings/arm/rtsm-dcscb.txt
 create mode 100644 Documentation/devicetree/bindings/arm/ste-u300.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx6sl-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/ste-u300-syscon-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/vf610-clock.txt
 create mode 100644 Documentation/devicetree/bindings/dma/ste-coh901318.txt
 create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-clps711x.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-stericsson-coh901.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-st-ddci2c.txt
 create mode 100644 Documentation/devicetree/bindings/pci/designware-pcie.txt
 create mode 100644 Documentation/devicetree/bindings/pci/mvebu-pci.txt
 create mode 100644 Documentation/devicetree/bindings/pci/pci.txt
 create mode 100644 Documentation/devicetree/bindings/pci/v3-v360epc-pci.txt
 create mode 100644 Documentation/devicetree/bindings/timer/stericsson-u300-apptimer.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/stericsson-coh901327.txt
 create mode 100644 arch/arm/boot/dts/keystone.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-db-88f6281.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-db-88f6282.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-db.dtsi
 create mode 100644 arch/arm/boot/dts/rk3066a-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/rk3066a.dtsi
 create mode 100644 arch/arm/boot/dts/ste-u300.dts
 rename arch/arm/{mach-davinci/dma.c => common/edma.c} (86%)
 delete mode 100644 arch/arm/configs/ap4evb_defconfig
 delete mode 100644 arch/arm/configs/bonito_defconfig
 create mode 100644 arch/arm/configs/keystone_defconfig
 delete mode 100644 arch/arm/include/asm/hardware/pci_v3.h
 create mode 100644 arch/arm/include/asm/v7m.h
 create mode 100644 arch/arm/include/debug/keystone.S
 create mode 100644 arch/arm/include/debug/rockchip.S
 rename arch/arm/{mach-u300/include/mach/debug-macro.S => include/debug/u300.S} (78%)
 create mode 100644 arch/arm/kernel/entry-v7m.S
 create mode 100644 arch/arm/kernel/psci_smp.c
 create mode 100644 arch/arm/mach-clps711x/devices.c
 create mode 100644 arch/arm/mach-clps711x/devices.h
 delete mode 100644 arch/arm/mach-clps711x/include/mach/autcpu12.h
 delete mode 100644 arch/arm/mach-clps711x/include/mach/memory.h
 delete mode 100644 arch/arm/mach-clps711x/include/mach/syspld.h
 delete mode 100644 arch/arm/mach-exynos/dev-ahci.c
 delete mode 100644 arch/arm/mach-exynos/dev-audio.c
 delete mode 100644 arch/arm/mach-exynos/dev-ohci.c
 delete mode 100644 arch/arm/mach-exynos/dev-uart.c
 delete mode 100644 arch/arm/mach-exynos/dma.c
 delete mode 100644 arch/arm/mach-exynos/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-usb-phy.h
 delete mode 100644 arch/arm/mach-exynos/mach-armlex4210.c
 delete mode 100644 arch/arm/mach-exynos/mach-nuri.c
 delete mode 100644 arch/arm/mach-exynos/mach-origen.c
 delete mode 100644 arch/arm/mach-exynos/mach-smdk4x12.c
 delete mode 100644 arch/arm/mach-exynos/mach-smdkv310.c
 delete mode 100644 arch/arm/mach-exynos/mach-universal_c210.c
 delete mode 100644 arch/arm/mach-exynos/setup-fimc.c
 delete mode 100644 arch/arm/mach-exynos/setup-fimd0.c
 delete mode 100644 arch/arm/mach-exynos/setup-i2c0.c
 delete mode 100644 arch/arm/mach-exynos/setup-i2c1.c
 delete mode 100644 arch/arm/mach-exynos/setup-i2c2.c
 delete mode 100644 arch/arm/mach-exynos/setup-i2c3.c
 delete mode 100644 arch/arm/mach-exynos/setup-i2c4.c
 delete mode 100644 arch/arm/mach-exynos/setup-i2c5.c
 delete mode 100644 arch/arm/mach-exynos/setup-i2c6.c
 delete mode 100644 arch/arm/mach-exynos/setup-i2c7.c
 delete mode 100644 arch/arm/mach-exynos/setup-keypad.c
 delete mode 100644 arch/arm/mach-exynos/setup-sdhci-gpio.c
 delete mode 100644 arch/arm/mach-exynos/setup-spi.c
 delete mode 100644 arch/arm/mach-exynos/setup-usb-phy.c
 create mode 100644 arch/arm/mach-imx/clk-imx6sl.c
 create mode 100644 arch/arm/mach-imx/clk-vf610.c
 create mode 100644 arch/arm/mach-imx/mach-imx6sl.c
 create mode 100644 arch/arm/mach-imx/mach-vf610.c
 delete mode 100644 arch/arm/mach-imx/ulpi.c
 delete mode 100644 arch/arm/mach-integrator/pci.c
 create mode 100644 arch/arm/mach-integrator/pci_v3.h
 create mode 100644 arch/arm/mach-keystone/Kconfig
 create mode 100644 arch/arm/mach-keystone/Makefile
 create mode 100644 arch/arm/mach-keystone/Makefile.boot
 create mode 100644 arch/arm/mach-keystone/keystone.c
 create mode 100644 arch/arm/mach-keystone/keystone.h
 create mode 100644 arch/arm/mach-keystone/platsmp.c
 create mode 100644 arch/arm/mach-keystone/smc.S
 create mode 100644 arch/arm/mach-kirkwood/board-db88f628x-bp.c
 delete mode 100644 arch/arm/mach-kirkwood/board-nsa310.c
 delete mode 100644 arch/arm/mach-kirkwood/db88f6281-bp-setup.c
 create mode 100644 arch/arm/mach-omap2/clockdomains54xx_data.c
 create mode 100644 arch/arm/mach-omap2/cm-regbits-54xx.h
 create mode 100644 arch/arm/mach-omap2/cm1_54xx.h
 create mode 100644 arch/arm/mach-omap2/cm2_54xx.h
 create mode 100644 arch/arm/mach-omap2/cm_44xx_54xx.h
 create mode 100644 arch/arm/mach-omap2/omap4-restart.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_54xx_data.c
 create mode 100644 arch/arm/mach-omap2/powerdomains54xx_data.c
 create mode 100644 arch/arm/mach-omap2/prcm_mpu54xx.h
 create mode 100644 arch/arm/mach-omap2/prcm_mpu_44xx_54xx.h
 create mode 100644 arch/arm/mach-omap2/prm-regbits-54xx.h
 create mode 100644 arch/arm/mach-omap2/prm44xx_54xx.h
 create mode 100644 arch/arm/mach-omap2/prm54xx.h
 create mode 100644 arch/arm/mach-omap2/scrm54xx.h
 create mode 100644 arch/arm/mach-omap2/voltagedomains54xx_data.c
 create mode 100644 arch/arm/mach-rockchip/Kconfig
 create mode 100644 arch/arm/mach-rockchip/Makefile
 create mode 100644 arch/arm/mach-rockchip/rockchip.c
 delete mode 100644 arch/arm/mach-shmobile/board-ap4evb.c
 delete mode 100644 arch/arm/mach-shmobile/board-bonito.c
 delete mode 100644 arch/arm/mach-shmobile/include/mach/head-ap4evb.txt
 delete mode 100644 arch/arm/mach-shmobile/include/mach/memory.h
 delete mode 100644 arch/arm/mach-shmobile/include/mach/mmc-ap4eb.h
 delete mode 100644 arch/arm/mach-u300/i2c.c
 delete mode 100644 arch/arm/mach-u300/i2c.h
 delete mode 100644 arch/arm/mach-u300/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-u300/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-u300/include/mach/syscon.h
 delete mode 100644 arch/arm/mach-u300/include/mach/timex.h
 delete mode 100644 arch/arm/mach-u300/include/mach/u300-regs.h
 delete mode 100644 arch/arm/mach-u300/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-u300/spi.c
 delete mode 100644 arch/arm/mach-u300/spi.h
 delete mode 100644 arch/arm/mach-u300/timer.h
 delete mode 100644 arch/arm/mach-u300/u300-gpio.h
 create mode 100644 arch/arm/mach-vexpress/dcscb.c
 create mode 100644 arch/arm/mach-vexpress/dcscb_setup.S
 delete mode 100644 arch/arm/mach-virt/platsmp.c
 create mode 100644 arch/arm/mm/cache-nop.S
 create mode 100644 arch/arm/mm/proc-v7m.S
 create mode 100644 drivers/bus/arm-cci.c
 delete mode 100644 drivers/clk/clk-zynq.c
 create mode 100644 drivers/clk/mvebu/armada-370.c
 create mode 100644 drivers/clk/mvebu/armada-xp.c
 delete mode 100644 drivers/clk/mvebu/clk-core.c
 delete mode 100644 drivers/clk/mvebu/clk-core.h
 delete mode 100644 drivers/clk/mvebu/clk-gating-ctrl.c
 delete mode 100644 drivers/clk/mvebu/clk-gating-ctrl.h
 delete mode 100644 drivers/clk/mvebu/clk.c
 create mode 100644 drivers/clk/mvebu/common.c
 create mode 100644 drivers/clk/mvebu/common.h
 create mode 100644 drivers/clk/mvebu/dove.c
 create mode 100644 drivers/clk/mvebu/kirkwood.c
 create mode 100644 drivers/clk/zynq/Makefile
 create mode 100644 drivers/clk/zynq/clkc.c
 create mode 100644 drivers/clk/zynq/pll.c
 delete mode 100644 drivers/mtd/maps/autcpu12-nvram.c
 create mode 100644 drivers/pci/host/Kconfig
 create mode 100644 drivers/pci/host/Makefile
 create mode 100644 drivers/pci/host/pci-mvebu.c
 create mode 100644 drivers/pci/host/pcie-designware.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-r8a7778.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-r8a7790.c
 create mode 100644 include/dt-bindings/clock/imx6sl-clock.h
 create mode 100644 include/dt-bindings/clock/vf610-clock.h
 create mode 100644 include/linux/arm-cci.h
 delete mode 100644 include/linux/clk/mvebu.h
 create mode 100644 include/linux/mfd/syscon/clps711x.h
 rename {arch/arm/mach-davinci/include/mach => include/linux/platform_data}/edma.h (58%)
 delete mode 100644 include/linux/platform_data/pinctrl-coh901.h
 create mode 100644 include/linux/platform_data/usb-rcar-phy.h
