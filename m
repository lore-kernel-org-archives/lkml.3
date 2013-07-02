Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3GBTTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:19:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3GBTTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:19:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 0/7] ARM SoC updates for 3.11
Date: Tue, 2 Jul 2013 21:18:21 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
MIME-Version: 1.0
Message-Id: <201307022118.21872.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:QBE+9GyArq+IcJqOw097izwdwAmZt5CBMTS64cqElGX
 U7fc25pMgRDv5T4Y+rvza5EM9GV+LXPhnQyd2vmNMlj+mTzxUR
 0YhLA4qu8UgJpCNdVKoQmr52KbpWlwe1KdKlFFI6Gz++ZnPQw5
 vShEZOcXh081u2a5QqFhdhTgSbKPp+jw1JOrQBs+KVaBtJ+H1R
 Th+ZyH1en/ej50o6s0KlchxqR0JCDb/jT0RcdTHLPBlW+1QuLI
 zGq7ueOw0JsYhRl7lpuJBx1TnjY7IQEscq/WSm73jdvG6cgF0E
 +counF+2f5t6DUWIJEuX5mmIPjxNNd0b+p3VaKK+N1r5DSuHzh
 9uVvCCpnX4OLkqTIJIsQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the pull requests for arm-soc for 3.11. Things are not all that
different from the previous times, but we decided to reduce the number of
branches a bit, which simplified the work for us and resulted in fewer
conflicts between our branches.

While in 3.10 there were lots of platforms converted to "multiplatform",
that trend did not continue this time. Instead, we have four new
SoC platforms that got added, and a couple of platforms have gotten
smaller as we remove support for non-devicetree based booting.

Changes to the device tree source files now make up the larges chunk
of the total changesets, which I consider a good thing. Once the 
process of converting platforms and drivers to devicetree has completed
enough, those files will get moved out of the kernel and get maintained
as a separate project.

For reference, a merge of all seven branches is available at
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git for-linus

I believe this merge window has the larges number of ARM related changes
so far, here are some overall statistics:

* 1241 non-merge changesets

* 132 branches merged into arm-soc

* 162 individual contributors

* 1105 files changed, 62057 insertions, 34538 deletions

* Top contributors in number of patches:

 Laurent Pinchart (105)
 Lee Jones (86)
 Linus Walleij (67)
 Thomas Petazzoni (55)
 Kuninori Morimoto (50)
 Tomasz Figa (37)
 Maxime Ripard (32)
 Alexander Shiyan (29)
 Arnd Bergmann (26)
 Jean-Christophe PLAGNIOL-VILLARD (23)
 Sergei Shtylyov (21)
 Magnus Damm (19)
 Guennadi Liakhovetski (18)

* Interesting note:

  Almost all of the people above are European, some Asian, and no American,
  contrary to the usual distribution of geographies we have in other parts
  of the kernel.

* Dirstat:

   0.8% Documentation/devicetree/bindings/clock/
   1.5% Documentation/devicetree/bindings/
  21.8% arch/arm/boot/dts/
   0.9% arch/arm/configs/
   0.4% arch/arm/include/asm/
   0.7% arch/arm/mach-at91/
   0.9% arch/arm/mach-clps711x/
   1.4% arch/arm/mach-exynos/include/mach/
   6.3% arch/arm/mach-exynos/
   1.9% arch/arm/mach-imx/
   0.7% arch/arm/mach-integrator/
   0.8% arch/arm/mach-msm/
  18.9% arch/arm/mach-omap2/
   1.1% arch/arm/mach-shmobile/include/mach/
   4.2% arch/arm/mach-shmobile/
   1.1% arch/arm/mach-u300/include/mach/
   1.3% arch/arm/mach-u300/
   1.2% arch/arm/mach-ux500/
   5.2% arch/arm/
   0.6% drivers/bus/
   1.7% drivers/clk/mvebu/
   1.2% drivers/clk/samsung/
   0.8% drivers/clk/zynq/
   1.9% drivers/clk/
   0.8% drivers/dma/
   0.6% drivers/gpio/
   1.8% drivers/pci/host/
  13.1% drivers/pinctrl/sh-pfc/
   0.8% drivers/pinctrl/
   0.5% drivers/usb/
   1.5% drivers/
   1.0% include/dt-bindings/clock/
   0.6% include/linux/

* List of all pull requests we got for each of our branches

next/fixes-non-critical
	mvebu/fixes-non-critical
		git://git.infradead.org/users/jcooper/linux.git tags/fixes-non-3.11-1
	sirf/fixes-non-critical
		git://gitorious.org/sirfprima2-kernel/sirfprima2-kernel.git tags/sirf-arm-soc-v3.10-fixes
	omap/fixes-non-critical
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/fixes-non-critical-signed
	davinci/board
		git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci.git tags/davinci-for-v3.11/board
	msm/fixes
		git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-fix-for-3.11
	patches
		MAINTAINERS: ARM: SIRF: add the source code tree path
		ARM: dts: msm: Fix merge resolution
		clocksource: kona: adapt to CLOCKSOURCE_OF_DECLARE change
		X.509: do not emit any informational output
		mtd: omap2: allow bulding as a module
		[SCSI] nsp32: use mdelay instead of large udelay constants
		hwrng: bcm2835: fix MODULE_LICENSE tag
		ARM: sirf: use CONFIG_SIRF rather than CONFIG_PRIMA2 where necessary
	at91/fixes
		git://github.com/at91linux/linux-at91.git tags/at91-fixes
	exynos/fixes
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/non-critical-fixes-1
	patches
		ARM: mxs: don't select HAVE_PWM
		ARM: mxs: stub out mxs_pm_init for !CONFIG_PM
		cpuidle: calxeda: select ARM_CPU_SUSPEND
	at91/fixes2
		git://github.com/at91linux/linux-at91.git tags/at91-fixes

next/cleanup
	at91/cleanup
		git://github.com/at91linux/linux-at91.git tags/at91-cleanup
	machdesc/cleanup
		git://github.com/mripard/linux.git tags/arm-soc-cleanups-for-3.11
	mvebu/cleanup
		git://git.infradead.org/users/jcooper/linux.git tags/cleanup-3.11-3
	dt/pci-helpers
		git://git.infradead.org/users/jcooper/linux.git tags/of_pci-3.11
	omap/cleanup
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/cleanup-signed
	mvebu/cleanup4
		git://git.infradead.org/users/jcooper/linux.git tags/cleanup-3.11-4
	msm/cleanup
		git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-fix-for-3.11
	sunxi/core
		git://github.com/mripard/linux.git tags/sunxi-core-for-3.11
	zynq/cleanup
		git://git.xilinx.com/linux-xlnx.git tags/zynq-cleanup-for-3.11
	at91/cleanup2
		git://github.com/at91linux/linux-at91.git tags/at91-cleanup
	picoxcell/cleanup
		git://github.com/jamieiles/linux-2.6-ji.git picoxcell-next
	omap/pm-serial-cleanup
		git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into omap-for-v3.11/pm-serial
	omap/pm-voltdomain-cleanup
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/pm-voltdomain-signed
	omap/dma-cleanup
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/dma-signed
	samsung/cleanup
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/samsung-cleanup-1
	bcm/cleanup
		git://github.com/broadcom/bcm11351.git armsoc/for-3.11/cleanups

next/soc
	mvebu/soc
		git://git.infradead.org/users/jcooper/linux.git tags/soc-3.11-2
	mvebu/defconfig
		git://git.infradead.org/users/jcooper/linux.git tags/defconfig-3.11-3
	mvebu/pcie
		git://git.infradead.org/users/jcooper/linux.git tags/pcie-3.11-2
	mvebu/pcie-kirkwood
		git://git.infradead.org/users/jcooper/linux.git tags/pcie_kw-3.11
	mvebu/pcie2
		git://git.infradead.org/users/jcooper/linux.git tags/pcie_bridge-3.11
	mvebu/clk-cleanup
		git://git.infradead.org/users/jcooper/linux.git tags/seb_clk-3.11
	vexpress/dual-cluster
		git://git.linaro.org/people/nico/linux VExpress_DCSCB
		depends on depends/rmk-devel-stable
		+patch "drivers/bus: arm-cci: fix combined ARMv6+v7 build"
	zynq/clk
		git://git.xilinx.com/linux-xlnx tags/zynq-clk-for-3.11
	mvebu/pcie-kirkwood2
		git://git.infradead.org/users/jcooper/linux.git tags/pcie_kw-3.11-2
	renesas/pinmux-gpio
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-pinmux-for-v3.11
	renesas/soc
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-soc-for-v3.11
	clps711x/soc
		patches
			GPIO: clps711x: Rewrite driver for using generic GPIO cod
			GPIO: clps711x: Add DT support
			ARM: clps711x: Re-add GPIO support
			ARM: clps711x: Remove NEED_MACH_MEMORY_H dependency
			ARM: clps711x: Set PLL clock to zero if we work from 13 mHz sourc
			ARM: clps711x: autcpu12: Move LCD DPOT definitions to board file
			ARM: clps711x: autcpu12: Add support for NOR flash
			ARM: clps711x: autcpu12: Special driver for handling memory is re
			ARM: clps711x: autcpu12: Move remaining specific definitions to b
			ARM: clps711x: p720t: Define PLD registers as GPIOs
			ARM: clps711x: Move specific definitions from hardware.h to board
			ARM: clps711x: Replace "arch_initcall" in common code with ".init
			ARM: clps711x: Add clocksource framework
			ARM: clps711x: Optimize interrupt handling
			ARM: clps711x: edb7211: Add support for I2C
			ARM: clps711x: edb7211: Control LCD backlight via PWM
			ARM: clps711x: Add support for SYSCON driver
			ARM: clps711x: Update defconfig
	patches
		ARM: socfpga: Add support to gate peripheral clocks
		ARM: socfpga: Add syscon to be part of socfpga
	samsung/s3c24xx-arch
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/s3c24xx-arch-1
	omap/pm
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/pm-signed
	omap/soc
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/gpmc-signed
	omap/omap5
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/soc-signed
	mvebu/regmap
		git://git.infradead.org/users/jcooper/linux.git tags/regmap-3.11
			depends on cleanup and fixes-non-critical branches
	renesas/usb
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-phy-rcar-usb-for-v3.11
	renesas/soc2
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-soc2-for-v3.11
	tegra/soc
		git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git tegra-for-3.11-soc
	keystone/soc
		git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git tags/keystone-soc-for-arm-soc
	integrator/pci
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-integrator.git tags/integrator-pci-for-arm-soc
	u300/multiplatform
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git tags/u300-multiplatform
	imx/soc
		git://git.linaro.org/people/shawnguo/linux-2.6.git tags/imx-soc-3.11
	davinci/soc
		git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci.git tags/davinci-for-v3.11/soc-v2
i	sunxi/defconfig
		git://github.com/mripard/linux.git tags/sunxi-defconfig-for-3.11
	sunxi/core2
		git://github.com/mripard/linux.git tags/sunxi-core-for-3.11-2
	omap/soc2
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/soc-part2-signed
	samsung/exynos-arch
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/exynos-arch-2
	rockchip/soc
		git://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git tags/v3.11-rockchip-basics
	renesas/soc-cleanup
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-cleanup-boot-for-v3.11
	patches
		ARM: dts: Add pcie controller node for exynos5440-ssdk5440
		ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC
		ARM: EXYNOS: Enable PCIe support for Exynos5440
		pci: Add PCIe driver for Samsung Exynos
		ARM: integrator: let pciv3 use mem/premem from device tree
		ARM: integrator: set local side PCI addresses right

next/boards
	mvebu/boards
		  git://git.infradead.org/users/jcooper/linux.git tags/boards-3.11-2
	renesas/defconfig
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-defconfig-for-v3.11
	renesas/boards
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-boards-for-v3.11
		depends on renesas/pinmux-gpio
		depends on renesas/soc
	ux500/core
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git tags/ux500-core-for-arm-soc
	ux500/pinctrl
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git tags/ux500-pinctrl-for-arm-soc
	patch
		"ARM: ux500: board-mop500: remove unused pin modes"
	bcm2835/defconfig
		git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-rpi.git bcm2835-for-3.11-defconfig
	renesas/defconfig2
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-defconfig2-for-v3.11
	tegra/defconfig
		git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git tegra-for-3.11-defconfig
	omap/boards
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/mailbox-signed
	samsung/exynos-remove-nondt
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/remove-nondt-exynos-3
	samsung/defconfig
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/samsung-defconfig-1
	renesas/boards
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-boards2-for-v3.11
	zynq/defconfig
		git://git.xilinx.com/linux-xlnx.git tags/zynq-defconfig-for-3.11
	mvebu/regmap2
		git://git.infradead.org/users/jcooper/linux.git tags/regmap-3.11-2
	patches
		ARM: multiplatform: always pick one CPU type
		ARM: imx: select syscon for IMX6SL
		ARM: keystone: select ARM_ERRATA_798181 only for SMP
		ARM: imx: Synertronixx scb9328 needs to select SOC_IMX1
		ARM: OMAP2+: AM43x: resolve SMP related build error
		ARM: keystone: Move CPU bringup code to dedicated asm file
	davinci/soc2
		git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci.git tags/davinci-for-v3.11/soc-2
	omap/voltdm
		git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm.git tags/omap-pm-v3.11/fixes/omap5-voltdm

next/dt
	nomadik/dt
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-nomadik.git tags/nomadik-dt-for-arm-soc
	mvebu/dt
		git://git.infradead.org/users/jcooper/linux.git tags/dt-3.11-3
	patch
		"ARM: nomadik: fix clocksource warning"
	at91/dt
		git://github.com/at91linux/linux-at91.git tags/at91-dt
	vt8500/dt
		git://github.com/linux-wmt/linux-vtwm vt8500/dts-3.11
	cleanup/dts-cpus
		git://linux-arm.org/linux-2.6-lp dts-cpus-updates
	patch
		"ARM: dts: add missing cpu #address-cell values"
	mvebu/dt4
		git://git.infradead.org/users/jcooper/linux.git tags/dt-3.11-4
	renesas/dt
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-dt-for-v3.11
	patches
		ARM: socfpga: dts: Add ethernet bindings for SOCFPGA
		ARM: socfpga: dts: Add gate-clock bindings
	samsung/s3c24xx-dt
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/s3c24xx-dt-1
	samsung/exynos-dt
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/exynos-dt-1
	mvebu/dt5
		git://git.infradead.org/users/jcooper/linux.git tags/dt-3.11-5
	ux500/dt
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git tags/ux500-dt-for-arm-soc
	bcm2835/dt
		git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-rpi.git bcm2835-for-3.11-dt
	tegra/dt
		git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git tegra-for-3.11-dt
	sunxi/dt
		git://github.com/mripard/linux.git tags/sunxi-dt-for-3.11
	at91/dt2
		git://github.com/at91linux/linux-at91.git tags/at91-dt
	zynq/dt
		git://git.xilinx.com/linux-xlnx.git tags/zynq-dt-for-3.11
	mxs/dt
		git://git.linaro.org/people/shawnguo/linux-2.6.git tags/mxs-dt-3.11
	imx/dt
		git://git.linaro.org/people/shawnguo/linux-2.6.git tags/imx-dt-3.11
	sunxi/dt2
		git://github.com/mripard/linux.git tags/sunxi-dt-for-3.11-2
	nomadik/dt2
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-nomadik.git tags/nomadik-dt-2
	samsung/exynos-dt2
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/exynos-dt-2
	samsung/s3c24xx-dt2
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/s3c24xx-dt-2
	omap/dt
		git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.11/dts
	bcm/dt
		git://github.com/broadcom/bcm11351.git armsoc/for-3.11/dt
	renesas/dt
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-dt2-for-v3.11
	mvebu/dt6
		git://git.infradead.org/users/jcooper/linux.git tags/dt-3.11-6
	at91/dt3
		git://github.com/at91linux/linux-at91.git tags/at91-dt

next/drivers
	ux500/dma40
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git tags/ux500-dma40-for-arm-soc
	timer/dw_apb_timer_of
		git://github.com/mmind/linux-rockchip.git tags/dw_apb_timer_of
	samsung/s3c24xx-drivers
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/s3c24xx-driver-1
	omap/gpmc
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/gpmc-signed
	ux500/clksrc
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git tags/ux500-clksrc-for-arm-soc
	ux500/dma540_2
		git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git tags/ux500-dma40-for-arm-soc-2
	renesas/rcar-gpio
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-gpio-rcar-for-v3.11
		depends on renesas/pinmux-gpio
	at91/drivers
		git://github.com/at91linux/linux-at91.git tags/at91-drivers
	patch
		gpio: rcar: fix gpio_rcar_of_table
	omap/gpmc2
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/gpmc-part2-signed
	drivers/mailbox
		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.11/mailbox-signed
	samsung/common-clk-audio
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/common-clk-audio
	samsung/s3c24xx-pinctrl2
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/s3c24xx-pinctrl-2
	ux500/cleanup patches
		ARM: ux500: Provide a AB8500 GPIO Device Tree node
		ARM: ux500: Correct the EN_3v3 regulator's on/off GPIO
		ARM: ux500: Remove mop500_snowball_ethernet_clock_enable()
	renesas/pinmux2
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-pinmux2-for-v3.11
	renesas/gpio-rcar2
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-gpio-rcar2-for-v3.11

next/late
	renesas/cleanup
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-cleanup-for-v3.11
	samsung/exynos5420
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/soc-exynos5420-1
	samsung/soc2
		git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git tags/soc-exynos5420-2
	nspire/soc patches 
		arm: Add Initial TI-Nspire support
		arm: Add device trees for TI-Nspire hardware
	sti/soc patches
		ARM: sti: Add STiH415 SOC support
		ARM: sti: Add STiH416 SOC support
		ARM: sti: Add DEBUG_LL console support
		ARM: stih41x: Add B2000 board support
		ARM: stih41x: Add B2020 board support
	rensas/sh-sci
		git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-sh-sci-for-v3.11
	patches
		ARM: ux500: bail out on alien cpus
	davinci/dt
		git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci davinci-for-v3.11/dt
	msm/clock
		git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-clock-for-3.11b
		based on msm/fixes to avoid conflict
