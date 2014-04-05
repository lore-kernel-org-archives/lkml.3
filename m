Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaDETBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:01:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:58018 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbaDETBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:01:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 0/8] ARM: SoC: pending changes for 3.15
Date: Sat, 5 Apr 2014 20:01:18 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201404052101.19381.arnd@arndb.de>
X-Provags-ID: V02:K0:NhfpNDCz2d5F+uHQ14NpeOtJQ9ysRTCN26YfExUGOSB
 DG923Ti7Uep5GDXlAuCcbn0UxT1mYpqll68i1WGa+/WL+wji7K
 XI/ld8TwCAF95HBzHw1JPce3GWuXJgsAa2prdw9At/Yj8AJoJB
 OKuYhE13VeMo0+B4LlHQlfD7Lf/H/e/RVZd4pC+NVWis0/u24a
 YNwjRHzBvRHDAQUPhZZSe61j7KXZNhBfoIC5BLaLTlUbXKaKu+
 Jk2D8/NTCaDTLHh5oAnpFVo3KvAD5Qbo/Wodr2YeQSGxa1vaLX
 YSw19Oxk+FXrshsuKpIHP1Pn8jHUXvF7X29CA8c0yb+MvzvoqN
 94IiLULp4BMYzbXeJ3sqgMPBkRGdBrK3D10dt0H3h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the changes from the arm-soc tree for the 3.15 merge window.

It's mostly business as usual, but both the dirstat output and the
patch count tell me that it's time for the devicetree stuff to get
moved out of the kernel into its own git tree.  We have had plans
for this for a while, and a mirror already exists that only contains
the device tree sources, but for the moment it still saves us some
trouble to have everything in one place, while there are still
platforms that are migrating from board files to DT and need things
to change atomically.

We are a bit late this merge window, which means you get to see
more merge conflicts at once than normal, from subsystem trees
you already merged. I have uploaded a tag 'for-linus-3.15' that
contains the conflict resolutions I did, and I tried to describe
every conflict I saw in the individual pull request emails.

We don't have other branches lined up for this merge window,
since we're already late I'm sending everything at once.

	Arnd

----------------------------------------------------------------

Summary:

fixes: 	  79 patches,   80 files,   347 insertions(+),   270 deletions(-)
cleanup: 104 patches,  261 files,  2696 insertions(+),  1832 deletions(-)
soc: 	 153 patches,  172 files,  3918 insertions(+),  3679 deletions(-)
boards:  105 patches,   34 files,  2196 insertions(+),   216 deletions(-)
dt: 	 583 patches,  372 files, 31308 insertions(+),  6243 deletions(-)
drivers: 123 patches,  106 files   5489 insertions(+),   698 deletions(-)
sh:	   1 patch,      1 file,      1 insertion (+),     1 deletion (-)
cleanup2: 66 patches,   92 files,  1157 insertions(+),  1369 deletions(-)

total: 1208 patches,  1018 files, 47128 insertions(+), 14324 deletions(-)

----------------------------------------------------------------

Dirstat:

   0.1% Documentation/devicetree/bindings/arm/msm/
   0.1% Documentation/devicetree/bindings/arm/omap/
   0.3% Documentation/devicetree/bindings/arm/
   0.9% Documentation/devicetree/bindings/clock/
   0.2% Documentation/devicetree/bindings/reset/
   0.6% Documentation/devicetree/bindings/
  60.7% arch/arm/boot/dts/
   1.2% arch/arm/configs/
   0.1% arch/arm/include/
   0.3% arch/arm/mach-at91/
   0.6% arch/arm/mach-bcm/
   0.3% arch/arm/mach-clps711x/
   0.2% arch/arm/mach-cns3xxx/
   0.8% arch/arm/mach-davinci/include/mach/
   3.1% arch/arm/mach-davinci/
   0.2% arch/arm/mach-exynos/include/mach/
   1.2% arch/arm/mach-exynos/
   0.1% arch/arm/mach-imx/devices/
   2.9% arch/arm/mach-imx/
   0.1% arch/arm/mach-integrator/include/mach/
   0.4% arch/arm/mach-integrator/
   0.3% arch/arm/mach-ixp4xx/
   0.3% arch/arm/mach-kirkwood/
   0.1% arch/arm/mach-mmp/
   0.5% arch/arm/mach-msm/
   0.9% arch/arm/mach-mvebu/
   0.6% arch/arm/mach-omap2/
   0.2% arch/arm/mach-prima2/
   0.1% arch/arm/mach-pxa/
   0.6% arch/arm/mach-qcom/
   0.3% arch/arm/mach-rockchip/
   0.1% arch/arm/mach-s3c24xx/include/mach/
   0.1% arch/arm/mach-s3c24xx/
   0.1% arch/arm/mach-s3c64xx/include/mach/
   0.1% arch/arm/mach-s5p64x0/include/mach/
   0.1% arch/arm/mach-s5pc100/include/mach/
   0.1% arch/arm/mach-s5pv210/include/mach/
   0.8% arch/arm/mach-shmobile/include/mach/
   4.1% arch/arm/mach-shmobile/
   0.5% arch/arm/mach-tegra/
   1.2% arch/arm/mach-ux500/
   0.1% arch/arm/mach-zynq/
   0.1% arch/arm/mm/
   0.5% arch/arm/plat-samsung/include/plat/
   0.7% arch/arm/plat-samsung/
   1.4% arch/arm/
   0.1% drivers/bus/
   4.3% drivers/clk/bcm/
   0.6% drivers/clk/samsung/
   0.2% drivers/clk/versatile/
   0.2% drivers/clk/zynq/
   0.1% drivers/clocksource/
   0.9% drivers/irqchip/
   0.1% drivers/mfd/
   1.0% drivers/reset/sti/
   0.1% drivers/reset/
   0.6% drivers/watchdog/
   0.3% drivers/
   0.1% include/dt-bindings/clock/
   0.1% include/dt-bindings/reset-controller/
   0.2% include/linux/

----------------------------------------------------------------

Afzal Mohammed (2):
      ARM: OMAP2+: AM43x: enable in default config
      ARM: OMAP2+: AM43x: determine features

Aida Mynzhasova (1):
      ARM: dts: mxs: add auart2 pinmux to imx28.dtsi

Alex Elder (4):
      clk: bcm281xx: add initial clock framework support
      clk: bcm281xx: don't disable unused peripheral clocks
      ARM: dts: bcm281xx: define real clocks
      ARM: bcm281xx: symbol cleanup

Alexander Shiyan (38):
      ARM: dts: i.MX51: Update CPU node
      ARM: dts: i.MX51: Add dummy clock to AUDMUX
      ARM: dts: i.MX51: Switch to use standard IRQ flags definitions
      ARM: dts: i.MX51: Move usbphy0 node from AIPS1
      ARM: dts: i.MX51 boards: Switch to use standard GPIO flags definitions
      ARM: dts: imx51-babbage: Fix chipselect level for dataflash on spi0.1
      ARM: dts: imx51-babbage: Define FEC reset pin
      ARM: dts: imx27-phytec-phycore-som: Add on-flash BBT support
      ARM: dts: imx27-phytec-phycore-rdk: Add DT node for camera module
      ARM: dts: imx27-phytec-phycore-som: Update FEC node
      ARM: dts: i.MX27 boards: Switch to use standard GPIO and IRQ flags definitions
      ARM: dts: i.MX27: Configure GPIOs as "input" by default
      ARM: dts: imx27-phytec-phycore-som: Add pinctrl for CSPI1 and GPIOs used on module
      ARM: dts: imx27-phytec-phycore-som: Rename file to .dtsi
      ARM: dts: imx27-phytec-phycore-som: Add NFC pin group
      ARM: dts: imx27-phytec-phycore-rdk: Enable 1-Wire module
      ARM: dts: imx27-phytec-phycore-som: Add spi-cs-high property to PMIC
      ARM: dts: imx27-phytec-phycore-rdk: Add pingrp for SDHC
      ARM: dts: imx27-phytec-phycore-rdk: Add pinctrl definitions for WEIM
      ARM: dts: i.MX27: Add SSI nodes
      ARM: dts: imx53-evk: Remove board support
      ARM: dts: i.MX51: Switch to use standard definitions for input subsystem
      ARM: dts: imx27-phytec-phycard-s-som: Sort entries
      ARM: dts: imx27-phytec-phycard-s-som: Add NFC node
      ARM: dts: imx27-phytec-phycard-s-rdk: Add pinctrl definitions for SDHC2
      ARM: dts: imx27-phytec-phycard-s-som: Rename file to .dtsi
      ARM: dts: imx27-phytec-phycore: Add diagnostic PMIC LEDs
      ARM: dts: i.MX27: Add USB nodes
      ARM: dts: imx27-phytec-phycore-rdk: Add USBH2 node
      ARM: dts: imx27-phytec-phycore-som: Add USBOTG node
      ARM: clps711x: Add CLPS711X irqchip driver
      ARM: dts: clps711x: Add bindings documentation for CLPS711X irqchip driver
      ARM: clps711x: Migrate CLPS711X subarch to the new irqchip driver
      ARM: clps711x: autcpu12: Fix incorrect NAND CLE GPIO
      MAINTAINERS: ARM: clps711x: Use regex patterns to involve all CLPS711X drivers
      ARM: clps711x: Remove EP72XX_ROM_BOOT option
      ARM: clps711x: Update defconfig
      ARM: nspire: Fix compiler warning

Alexandre Belloni (23):
      ARM: dts: mxs: add #io-channel-cells to mx28 lradc
      ARM: dts: mxs: Add iio-hwmon to mx28 soc
      ARM: dts: mxs: Add iio-hwmon to mx23 soc
      ARM: at91/defconfig: refresh at91sam9rl_defconfig
      ARM: at91/defconfig: remove useless configuration in at91sam9260_9g20_defconfig
      ARM: at91/defconfig: refresh at91sam9260_9g20_defconfig
      ARM: at91: prepare at91sam9rl DT transition
      ARM: at91: Add at91sam9rl DT SoC support
      ARM: at91/defconfig: Add the sam9rl to the list of DT-enabled SOCs
      ARM: at91: dt: sam9rl: Device Tree for the at91sam9rlek
      ARM: at91: prepare common clk transition for sam9rl SoCs
      ARM: at91/dt: define at91sam9rl clocks
      ARM: at91/dt: define main clk frequency of at91sam9rlek
      ARM: at91: switch sam9rl to common clock framework
      ARM: at91/DT: atmel_usba correct atmel,vbus-gpio meaning
      Documentation: dt: iio: improve atmel-adc documentation
      Documentation: dt: iio: move arm/atmel-adc.txt to iio/adc/at91_adc.txt
      ARM: at91/dt: at91-ariag25: remove useless adc properties
      ARM: at91/dt: at91sam9260: remove useless adc properties
      ARM: at91/dt: at91sam9g45: remove useless adc properties
      ARM: at91/dt: at91sam9x5: remove useless adc properties
      ARM: at91/dt: sama5d3: remove useless adc properties
      ARM: at91/dt: at91-cosino: remove useless adc properties

Alexandre Courbot (8):
      ARM: trusted_foundations: fix vendor prefix typos
      ARM: trusted_foundations: fallback when TF support is missing
      ARM: firmware: enable Trusted Foundations by default
      ARM: firmware: add prepare_idle() operation
      ARM: trusted_foundations: implement prepare_idle()
      ARM: tegra: cpuidle: use firmware for power down
      ARM: tegra: enable fhandle in tegra_defconfig
      ARM: enable fhandle in multi_v7_defconfig

Andrew Lunn (33):
      ARM: Kirkwood: Add support for Excito Bubba B3
      ARM: Kirkwood: Add DT description of QNAP 419
      ARM: Kirkwood: Add DT description of rd88f6192.
      ARM: Kirkwood: convert rd88f6281-setup.c to DT.
      DT: Vendor prefixes: Add ricoh, qnap, sii and synology
      DT: i2c: Trivial: Add sii,s35390a
      ARM: kirkwood: Give pm.c its own header file.
      ARM: kirkwood: Convert mv88f6281gtw_ge switch setup to DT
      ARM: kirkwood: Drop printing the SoC type and revision
      ARM: kirkwood: Separate board-dt from common and pcie code.
      ARM: kirkwood: ioremap the cpu_config register before using it.
      ARM: kirkwood: ioremap memory control register
      ARM: mvebu: Add ARCH_MULTI_V7 to SoCs
      ARM: orion: Move cache-feroceon-l2.h out of plat-orion
      ARM: MM: Add DT binding for Feroceon L2 cache
      ARM: config: Add a multi_v5_defconfig
      ARM: config: Add mvebu_v5_defconfig
      ARM: Fix default CPU selection for ARCH_MULTI_V5
      ARM: MM Enable building Feroceon L2 cache controller with ARCH_MVEBU
      ARM: mvebu: Move kirkwood DT boards into mach-mvebu
      ARM: mvebu: Let kirkwood use the system controller for restart
      ARM: mvebu: Enable mvebu-soc-id on Kirkwood
      ARM: mvebu: Simplify headers and make local
      drivers: Enable building of Kirkwood drivers for mach-mvebu
      ARM: kirkwood: Remove redundant kexec code
      ARM: kirkwood: Add HP T5325 devices to {multi|mvebu}_v5_defconfig
      ARM: kirkwood: Add HP T5325 thin client
      ARM: kirkwood: Instantiate L2 cache from DT.
      ARM: mvebu: Instantiate system controller in kirkwood.dtsi
      ARM: kirkwood: Add audio node to kirkwood.dtsi
      ARM: kirkwood: Add i2c alias so setting bus number
      ARM: kirkwood: Add dts file describing HP T5325 thin client
      Power: Reset: Generalize qnap-poweroff to work on Synology devices.

Andrii.Tseglytskyi (2):
      ARM: dts: OMAP36xx: Add device node for ABB
      ARM: dts: OMAP4: Add device nodes for ABB

Andrzej Hajda (4):
      ARM: dts: use macros in clock bindings for exynos4
      ARM: dts: use macros in clock bindings for exynos5250
      ARM: dts: use macros in clock bindings for exynos5420
      ARM: dts: use macros in clock bindings for exynos5440

Anson Huang (17):
      ARM: dts: imx6q: update setting of VDDARM_CAP voltage
      ARM: dts: imx6q: add vddsoc/pu setpoint info
      ARM: dts: imx6dl: enable cpufreq support
      ARM: dts: imx6qdl: add necessary thermal clk
      ARM: dts: imx6qdl-sabresd: Add power key support
      ARM: dts: imx6sl: add ocram device support
      ARM: dts: imx6sl: add keypad support for i.mx6sl-evk board.
      ARM: dts: imx6qdl-sabresd: correct gpio key's active state
      ARM: dts: imx6q: add 852MHz setpoint for CPU freq
      ARM: imx: AHB rate must be set to 132MHz on i.mx6sl
      ARM: imx: add cpuidle support for i.mx6sl
      ARM: imx: add suspend in ocram support for i.mx6q
      ARM: imx: add suspend in ocram support for i.mx6dl
      ARM: imx: add suspend in ocram support for i.mx6sl
      ARM: imx: add always-on clock array for i.mx6sl to maintain correct usecount
      ARM: imx: avoid calling clk APIs in idle thread which may cause schedule
      ARM: imx: add speed grading check for i.mx6 soc

Archit Taneja (1):
      ARM: dts: omap4+: Add DMM bindings

Arnd Bergmann (129):
      Merge tag 'davinci-for-v3.15/nand' of git://git.kernel.org/.../nsekhar/linux-davinci into next/drivers
      Merge tag 'irqchip-mvebu-fixes-3.14' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge tag 'mvebu-watchdog-3.15' of git://git.infradead.org/linux-mvebu into next/drivers
      irqchip: VIC: export vic_init_cascaded
      Merge branch 'qcom/cleanup' into next/drivers
      Merge tag 'qcom-drivers-for-3.15' of git://git.kernel.org/.../galak/linux-qcom into next/drivers
      Merge tag 'mvebu-dt-3.15-2' of git://git.infradead.org/linux-mvebu into next/dt
      Merge branch 'mvebu/soc' into next/soc
      Merge tag 'mvebu-soc-3xx-3.15' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'efm32-next' of git://git.pengutronix.de/git/ukl/linux into next/cleanup
      Merge branch 'qcom/cleanup' into next/dt
      Merge tag 'qcom-dt-for-3.15' of git://git.kernel.org/.../galak/linux-qcom into next/dt
      Merge tag 'kconfig-cleanup-for-3.15' of git://git.kernel.org/.../robh/linux into next/cleanup
      Merge tag 'armsoc/for-3.15/drivers' of git://github.com/broadcom/mach-bcm into next/drivers
      Merge branch 'efm32/cleanup' into next/dt
      Merge tag 'efm32-next' of git://git.pengutronix.de/git/ukl/linux into next/dt
      Merge tag 'socfpga_updates_for_3.15_v2' of git://git.rocketboards.org/linux-socfpga-next into next/drivers
      Merge tag 'mvebu-soc-3.15-2' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'mvebu-soc-3.15-3' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'mvebu-dt-3.15-3' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'mvebu-drivers-3.15-2' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge tag 'mvebu-defconfig-3.15-2' of git://git.infradead.org/linux-mvebu into next/boards
      Merge branch 'mvebu/soc3' into next/dt
      Merge tag 'mvebu-dt-3.15-4' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'mvebu-dt-3.15-5' of git://git.infradead.org/linux-mvebu into next/dt
      ARM: fix duplicate symbols in multi_v5_defconfig
      Merge tag 'sunxi-defconfig-for-3.15' of https://github.com/mripard/linux into next/boards
      Merge tag 'sunxi-core-for-3.15' of https://github.com/mripard/linux into next/soc
      Merge branch 'bcm/cleanup' into next/soc
      Merge tag 'armsoc/for-3.15/soc-3' of git://github.com/broadcom/mach-bcm into next/soc
      ARM: davinci: remove tnetv107x support
      Merge tag 'davinci-for-v3.15/soc' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'sunxi-dt-for-3.15-2' of https://github.com/mripard/linux into next/dt
      Merge tag 'omap-for-v3.15/dt-part3' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'omap-for-v3.15/dt-overo-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'armsoc/for-3.15/dt-2' of git://github.com/broadcom/mach-bcm into next/dt
      Merge tag 'omap-for-v3.15/fixes-for-merge-window' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      ARM: prima2: build reset code standalone
      Merge tag 'armsoc/for-3.15/soc-4' of git://github.com/broadcom/mach-bcm into next/soc
      ARM: mmp: allow platform devices with modular USB
      Merge tag 'samsung-fixes' of git://git.kernel.org/.../kgene/linux-samsung into next/fixes-non-critical
      Merge tag 'DT-for-v3.15-part-1-v2' of git://git.stlinux.com/devel/kernel/linux-sti into next/dt
      Merge branch 'sti/dt' into next/drivers
      Merge tag 'sti-reset-for-v3.15' of git://git.stlinux.com/devel/kernel/linux-sti into next/drivers
      Merge branch 'cleanup/kconfig' into next/drivers
      ARM: at91: split out at91x40 into a top-level option
      ARM: at91: don't provide dt init code for at91x40
      ARM: at91: export sam9_smc interfaces
      ARM: at91: fix broken "if () else" statement
      ARM: at91: sama5 always uses DT
      ARM: davinci: make dm644x-evm phy fixup conditional
      ARM: davinci: fix Kconfig for DA850_EVM
      ARM: efm32: select AUTO_ZRELADDR
      ARM: ep93xx: export ep93xx_chip_revision
      ARM: hisi: fix building without CONFIG_HOTPLUG_CPU
      ARM: ixp4xx/omixp: always include linux/leds.h
      ARM: ixp4xx: avoid use of PCIBIOS_MIN_MEM in io.h
      ARM: ixp4xx: fix gpio rework
      ARM: ks8695/og: make PCI setup conditional
      ARM: lpc32xx: export lpc32xx_return_iram_size
      ARM: msm: add missing include of linux/module.h
      ARM: msm: avoid calling debug_ll_addr on !MMU
      ARM: msm: export legacy DMA interfaces
      ARM: omap1: don't rely on tps65010
      ARM: mvebu: add missing header
      ARM: orion5x: make dns323 independent of PHY support
      ARM: pxa: don't "select" SMC91X on MACH_XCEP
      ARM: pxa: enable pxafb unconditionally for some boards
      ARM: pxa: fix colibri build
      ARM: pxa: fix pxa_ssp_* declarations
      ARM: pxa: remove broken balloon3_gpio_vbus reference
      ARM: pxa: select I2C_GPIO only if I2C is on
      ARM: pxa: trizeps4 and trizeps4wl use the same file
      ARM: rpc: autoselect CPU_SA110
      ARM: footbridge: don't build floppy code for addin mode
      ARM: footbridge: fix build with PCI disabled
      ARM: footbridge: make screen_info setup conditional
      ARM: realview: fix sparsemem build
      ARM: integrator: only select pl01x if TTY is enabled
      ARM: s3c24xx: MINI2440 needs I2C for EEPROM_AT24
      ARM: s3c24xx: fix gta02 build error
      ARM: s3c24xx: osiris dvs needs tps65010
      ARM: s3c64xx: MACH_SMDK6400 needs HSMMC1
      ARM: s3c64xx: select power domains only when used
      ARM: s5p64x0: fix building with only one soc type
      ARM: s5pv210: enable IDE support in MACH_TORBRECK
      ARM: samsung: allow serial driver to be disabled
      ARM: samsung: fix SAMSUNG_PM_DEBUG Kconfig logic
      ARM: samsung: select ATAGS where necessary
      ARM: samsung: select CRC32 for SAMSUNG_PM_CHECK
      ARM: exynos: fix l2x0 saved regs handling
      ARM: exynos: add missing include of linux/module.h
      ARM: efm32: allow uncompress debug output
      ARM: hisi: select HAVE_ARM_SCU only for SMP
      ARM: mvebu: don't select CONFIG_NEON
      ARM: sunxi: fix build for THUMB2_KERNEL
      ARM: tegra: make debug_ll code build for ARMv6
      Merge branch 'randconfig-fixes' into next/fixes-non-critical
      Revert "ARM: ixp4xx: fix gpio rework"
      Revert "ARM: ixp4xx: Make dma_set_coherent_mask common, correct implementation"
      Revert "net: stmmac: Add SOCFPGA glue driver"
      Revert "dts: socfpga: Add DTS entry for adding the stmmac glue layer for stmmac."
      Merge branch 'reset/for_v3.15' of git://git.pengutronix.de/git/pza/linux into next/drivers
      Merge tag 'keystone-dts-fixes' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt
      Merge tag 'davinci-for-v3.15/soc-2' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge tag 'zynq-cleanup-for-3.15-v2' of git://git.xilinx.com/linux-xlnx into next/cleanup2
      ARM: moxart: fix CPU selection
      ARM: cache-tauros2: remove ARMv6 code
      Merge tag 'samsung-pm-1' of http://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branches 'samsung/cleanup', 'samsung/exynos-clk' and 'samsung/exynos-clk2' into next/cleanup3
      Merge tag 'samsung-cleanup-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'samsung-dt-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'samsung-cleanup-3' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'samsung-dt-3' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'samsung-pm-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'exynos-cleanup' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      devicetree: fix newly added exynos sata bindings
      ARM: at91: fix a typo
      Merge tag 'dt-3.15' into torvalds/master
      Merge tag 'fixes-non-critical-3.15' into for-next
      Merge tag 'cleanup-3.15' into for-next
      Merge tag 'soc-3.15' into for-next
      Merge tag 'boards-3.15' into for-next
      Merge tag 'dt-3.15-resolved' into for-next
      Merge tag 'drivers-3.15' into for-next
      Merge tag 'sh-3.15' into for-next
      Merge tag 'cleanup3-3.15' into for-next

Ashutosh singh (4):
      ARM: dts: imx6q-phytec: Added USB_OTG Support
      ARM: dts: imx6q-phytec: Added USB_HOST Support
      ARM: dts: imx6q-phytec: Added GPMI-NAND Support
      ARM: dts: imx6q-phytec: Added SATA Support

Balaji T K (3):
      ARM: dts: am437x gp-evm: add sd card dt nodes
      ARM: dts: am335x-evm: add SD card hotplug support
      ARM: dts: am43x-epos-evm: add SD card hotplug support

Barry Song (6):
      ARM: prima2: l2x0: fix checkpatch issues
      ARM: prima2: platsmp: fix checkpatch issues
      ARM: prima2: common: fix checkpatch issues
      ARM: prima2: rtciobrg: fix the typo about license
      ARM: prima2: staticize sirfsoc_init_late function
      ARM: prima2: move to generic reset controller driver framework

Ben Dooks (2):
      ARM: shmobile: lager: fix error return code check from clk_get()
      ARM: shmobile: koelsch: fix error return code check from clk_get()

Ben Peddell (1):
      ARM: Kirkwood: Add support for many Synology NAS devices

Bo Shen (1):
      ARM: at91: add PWM clock

Boris BREZILLON (1):
      ARM: at91: prepare sam9 dt boards transition to common clk

Bryan Wu (1):
      ARM: tegra: enable PCA9546 on Cardhu

Chanwoo Choi (5):
      ARM: dts: Add ADC's dt data to read raw data for exynos4x12
      ARM: dts: Add PMU dt data to support PMU for exynos4x12
      ARM: dts: Add GPS_ALIVE power domain for exynos4x12
      ARM: dts: Move common dt data for interrupt combiner controller for exynos4x12
      ARM: dts: Add ADC and themistor nodes for exynos4412-trats2

Chen-Yu Tsai (12):
      ARM: dts: sun7i: add pin muxing options for UART2
      ARM: dts: sun4i: rename clock node names to clk@N
      ARM: dts: sun5i: rename clock node names to clk@N
      ARM: dts: sun6i: rename clock node names to clk@N
      ARM: dts: sun7i: rename clock node names to clk@N
      ARM: dts: sun7i: Add GMAC clock node to sun7i DTSI
      ARM: dts: sun7i: Add GMAC controller node to sun7i DTSI
      ARM: dts: sun7i: Add pin muxing options for the GMAC
      ARM: dts: sun7i: cubietruck: Enable the GMAC
      ARM: dts: sun7i: cubieboard2: Enable GMAC instead of EMAC
      ARM: dts: sun7i: a20-olinuxino-micro: Enable GMAC instead of EMAC
      ARM: dts: sun7i: Add ethernet alias for GMAC

Christoph Fritz (2):
      ARM: dts: omap3: Add support for INCOstartec a83x module
      ARM: dts: omap3: Add support for INCOstartec DBB056 baseboard

Darren Etheridge (1):
      pinctrl: am43xx: dt-bindings: add MUX_MODE8

Dave Gerlach (1):
      ARM: OMAP2+: clockdomain: Reintroduce SW_SLEEP Support

David Lanzendörfer (1):
      ARM: sun4i: dt: Add support for the INet-97F_Rev_02 board

Denis Carikli (15):
      of: add vendor prefix for Eukrea Electromatique.
      ARM: dts: i.MX25: Add ssi clocks and DMA events.
      ARM: dts: i.MX25: Add sdma script path.
      ARM: dts: imx25.dtsi: Add a label for the Audio Multiplexer.
      ARM: dts: Add support for the cpuimx51 board from Eukrea and its baseboard.
      ARM: dts: imx25: Add pinctrl functions.
      ARM: dts: imx25.dtsi: label the iomuxc.
      ARM: dts: mxs: Add 18bit pin config for lcdif.
      ARM: dts: mxs: Add a new pin config for the usb0 ID.
      ARM: dts: Add support for the cpuimx25 board from Eukrea and its baseboard.
      ARM: dts: imx53: Add gpio and input dt includes.
      ARM: dts: Add support for the cpuimx35 board from Eukrea and its baseboard.
      ARM: imx_v6_v7_defconfig: Enable backlight gpio support.
      ARM i.MX35: build in pinctrl support.
      ARM: imx_v6_v7_defconfig: Enable some drivers used on the cpuimx35.

Dinh Nguyen (8):
      net: stmmac: Add SOCFPGA glue driver
      dts: socfpga: Add DTS entry for adding the stmmac glue layer for stmmac.
      ARM: socfpga: Update socfpga_defconfig
      dts: socfpga: Update clock entry to support multiple parents
      dts: socfpga: Add support for SD/MMC on the SOCFPGA platform
      dts: socfpga: Add sysmgr node so the gmac can use to reference
      dts: socfpga: Add DTS entry for adding the stmmac glue layer for stmmac.
      dts: stmmac: Document the clocks property in the stmmac base document

Dmitry Eremin-Solenikov (1):
      ARM: pxa: add gpio keys information

Dmitry Lifshitz (12):
      ARM: dts: sbc-t3x: use omap specific pinctrl defines
      ARM: dts: sbc-t3x: refactor DT support
      ARM: dts: sbc-t3x: disable mmc3
      ARM: dts: sb-t35: fix Ethernet power supply
      ARM: dts: cm-t3x: add gpio-led pinmux
      ARM: dts: cm-t3x30: add twl4030 gpio pullups
      ARM: dts: cm-t3x30: add HS USB Host support
      ARM: dts: sbc-t3730: add pinmux for usb hub reset
      ARM: dts: cm-t3x30: add USB OTG support
      ARM: dts: sbc-t3530: add support for sbc-t3530
      ARM: dts: sbc-t3517: add support for sbc-t3517
      ARM: OMAP2+: make reset pulse for sbc-t3x usb hubs

Eric Bénard (1):
      ARM: mxs: Add support for the eukrea-cpuimx28.

Ezequiel Garcia (24):
      ARM: dove: Remove UBI support from defconfig
      ARM: mvebu: Enable Armada 370/XP watchdog in the devicetree
      ARM: kirkwood: Add RSTOUT 'reg' entry to devicetree
      ARM: dove: Enable Dove watchdog in the devicetree
      ARM: mvebu: Enable watchdog support in defconfig
      ARM: dove: Enable watchdog support in the defconfig
      watchdog: orion: Add clock error handling
      watchdog: orion: Use atomic access for shared registers
      watchdog: orion: Remove unused macros
      watchdog: orion: Make sure the watchdog is initially stopped
      watchdog: orion: Handle the interrupt so it's properly acked
      watchdog: orion: Make RSTOUT register a separate resource
      watchdog: orion: Remove unneeded BRIDGE_CAUSE clear
      watchdog: orion: Introduce an orion_watchdog device structure
      watchdog: orion: Introduce per-compatible of_device_id data
      watchdog: orion: Add per-compatible clock initialization
      watchdog: orion: Add per-compatible watchdog start implementation
      watchdog: orion: Add support for Armada 370 and Armada XP SoC
      watchdog: orion: Enable the build on ARCH_MVEBU
      ARM: mvebu: Rename the ARCH_MVEBU menu option
      ARM: mvebu: Add a 2 GHz fixed-clock on Armada 38x SoCs
      ARM: mvebu: Add the Core Divider clock to Armada 38x SoCs
      ARM: mvebu: Add support for NAND controller in Armada 38x SoC
      ARM: mvebu: Enable NAND controller in Armada 385-DB

Fabio Estevam (23):
      ARM: dts: imx6q-udoo: Add Ethernet support
      ARM: dts: imx6q-sabrelite: Remove duplicate GPIO entry
      ARM: dts: imx6q-sabrelite: Place 'status' as the last node
      ARM: dts: imx6: Use 'vddarm' as the regulator name
      ARM: dts: imx28-evk: Run I2C0 at 400kHz
      ARM: dts: imx28-m28cu3: Remove 'reset-active-high'
      ARM: dts: mx53: Remove 'enable-active-low' property
      ARM: dts: imx28-tx28: Remove 'enable-active-low' property
      ARM: dts: imx6qdl-sabresd: Add PFUZE100 support
      ARM: dts: imx6qdl-sabreauto: Add LVDS support
      ARM: dts: imx6sl-evk: Add PFUZE100 support
      ARM: dts: imx6sl-evk: Add audio support
      ARM: dts: imx6qdl-sabreauto: Add PFUZE100 support
      ARM: dts: imx6sl-evk: Add debug LED support
      ARM: dts: imx6sl-evk: Keep VGEN1 regulator always enabled
      watchdog: orion_wdt: Use %pa to print 'phys_addr_t'
      ARM: imx_v6_v7_defconfig: Select PCI support
      ARM: imx: Use INT_MEM_CLK_LPM as the bit name
      ARM: imx_v4_v5_defconfig: Select CONFIG_MMC_UNSAFE_RESUME
      ARM: imx_v6_v7_defconfig: Select CONFIG_MMC_UNSAFE_RESUME
      ARM: mach-imx: Select CONFIG_SRAM at ARCH_MXC level
      ARM: imx_v6_v7_defconfig: Select CONFIG_DEBUG_FS
      ARM: mach-imx: Kconfig: Remove IMX_HAVE_PLATFORM_IMX2_WDT from SOC_IMX53

Felipe Balbi (1):
      ARM: omap1: fix build when !CONFIG_OMAP_32K_TIMER

Fengguang Wu (1):
      rtc: isl12057: use PTR_ERR_OR_ZERO to fix coccinelle warnings

Florian Fainelli (1):
      ARM: restrict BCM_KONA_UART to ARCH_BCM_MOBILE

Florian Meier (2):
      ARM: bcm2835: add dmaengine driver to device tree
      ARM: bcm2835: add I2S driver to device tree

Florian Vaussard (23):
      ARM: dts: Add support for OMAP4 Gumstix DuoVero/Parlor
      ARM: OMAP3: remove deprecated CONFIG_OMAP_IOMMU_IVA2
      ARM: dts: OMAP3: Update ISP IOMMU node
      ARM: dts: OMAP3: Add IVA IOMMU node
      ARM: dts: OMAP4: Add IOMMU nodes
      ARM: dts: overo: reorganize include files
      ARM: dts: omap3-tobi: Add missing pinctrl
      ARM: dts: omap3-overo: Add missing pinctrl
      ARM: dts: omap3-overo: Enable WiFi/BT combo
      ARM: dts: omap3-overo: Add HSUSB PHY
      ARM: dts: omap: Add common file for SMSC9221
      ARM: dts: omap3-tobi: Use include file omap-gpmc-smsc9221
      ARM: dts: omap3-tobi: Add AT24C01 EEPROM
      ARM: dts: overo: Push uart3 pinmux down to expansion board
      ARM: dts: overo: Create a file for common Gumstix peripherals
      ARM: dts: overo: Add LIS33DE accelerometer
      ARM: dts: Add support for the Overo Palo43
      ARM: dts: Add support for the Overo Gallop43
      ARM: dts: Add support for the Overo Alto35
      ARM: dts: Add support for the Overo Chestnut43
      ARM: dts: Add support for the Overo Summit
      CLK: TI: OMAP4/5/DRA7: Remove gpmc_fck from dummy clocks
      ARM: dts: omap4/5: Use l3_ick for the gpmc node

Frank Li (1):
      ARM: dts: imx6qdl: enable dma for spi

Fugang Duan (1):
      ARM: dts: vf610-twr: Add ADC support

Gaku Inami (1):
      ARM: shmobile: r8a7790 CA7-SCU enablement

Geert Uytterhoeven (22):
      ARM: shmobile: r8a7791: Add thermal clock in device tree
      ARM: shmobile: r8a7790: Add thermal clock in device tree
      ARM: shmobile: lager: Make spi_flash_data const
      ARM: shmobile: Remove duplicate shmobile_invalidate_start() declaration
      ARM: shmobile: koelsch: Enable DEVTMPFS_MOUNT in defconfig
      ARM: shmobile: genmai legacy: Add RSPI support
      ARM: shmobile: r7s72100 dtsi: Add RSPI nodes
      ARM: shmobile: koelsch legacy: Add QSPI support
      ARM: shmobile: r8a7791 dtsi: Add QSPI node
      ARM: shmobile: koelsch dts: Add QSPI nodes
      ARM: shmobile: lager legacy: Switch QSPI to named IRQs
      ARM: shmobile: koelsch defconfig: Enable RSPI and MTD_M25P80
      ARM: shmobile: genmai defconfig: Enable RSPI
      ARM: shmobile: lager legacy: Add QSPI pinmux
      ARM: shmobile: r8a7790 dtsi: Add QSPI node
      ARM: shmobile: lager dts: Add QSPI nodes
      ARM: shmobile: lager defconfig: Enable RSPI and MTD_M25P80
      ARM: shmobile: r8a7778 dtsi: Remove duplicate i2c nodes
      ARM: shmobile: r7s72100 clock: Add RSPI clocks
      ARM: shmobile: r7s72100 clock: Add RSPI clocks for DT
      ARM: shmobile: r8a7791 clock: add QSPI clocks
      ARM: shmobile: r8a7791: Fix SCIFA3-5 clocks

Greg Ungerer (3):
      ARM: dts: imx: add device tree pin definitions for the IMX50
      ARM: dts: imx: add IMX50 SoC device tree
      ARM: dts: imx: add device tree support for Freescale imx50evk board

Gregory CLEMENT (4):
      ARM: mvebu: Makefile clean-up
      ARM: mvebu: add Device Tree description of the Armada 375 SoC
      ARM: mvebu: add initial support for the Armada 375 SOCs
      ARM: mvebu: add Device Tree for the Armada 385 RD board

Grygorii Strashko (5):
      ARM: dts: keystone: add gpio device entry
      ARM: dts: k2hk-evm: add leds supports
      ARM: dts: k2hk-evm: rename clock node to clocks
      ARM: config: keystone: enable gpio support
      ARM: config: keystone: enable led support

Guennadi Liakhovetski (1):
      ARM: shmobile: wait for MSTP clock status to toggle, when enabling it

Gwenhael Goavec-Merou (8):
      ARM: imx27-apf27dev: Add sdhci support
      ARM: dts: imx27-apf27dev: fix display size
      ARM: dts: imx27: imx27-apf27: add pinctrl for fec and uart1
      ARM: dts: imx27: imx27-apf27dev: add pinctrl for cspi, i2c, sdhc and framebuffer
      ARM: dts: apf28dev: set gpio polarity for usb regulator and pinctrl for regulator gpio
      ARM: imx28: add apf28 specific initialization (macaddr)
      ARM: dts: apf27dev: Add pwm support
      ARM: dts: imx27-apf27dev: Add pinctrl for cspi, sdhci, leds and keys

Hans de Goede (10):
      ARM: sun4i: dt: Remove grouping + simple-bus compatible for regulators
      ARM: sunxi: dt: Add sunxi-common-regulators include file
      ARM: sun7i: dt: Add ahci / sata support
      ARM: sun4i: dt: Add USB host nodes to hackberry dts
      ARM: sun4i: dt: Add USB host nodes to mini-xplus dts
      ARM: sun4i: dt: Add USB host nodes to pcduino.dts
      ARM: sun5i: dt: Add USB host nodes to a10s-olinuxino-micro
      ARM: sun5i: dt: Add USB host nodes to a13-olinuxino-micro
      ARM: sun7i: dt: Add USB host nodes to cubietruck dts
      ARM: sun4i: dt: Add support for the A10-OLinuXino-LIME board

Hauke Mehrtens (4):
      ARM: BCM5301X: add dts files for BCM4708 SoC
      ARM: BCM5301X: initial support for the BCM5301X/BCM470X SoCs with ARM CPU
      ARM: BCM5301X: add early debugging support
      ARM: BCM5301X: workaround suppress fault

Heiko Stuebner (8):
      ARM: SAMSUNG: remove obsolete tick.h
      ARM: SAMSUNG: remove unneeded s3c24xx_init_cpu()
      ARM: rockchip: add snoop-control-unit
      ARM: rockchip: add sram dt nodes and documentation
      ARM: rockchip: add power-management-unit
      ARM: rockchip: add smp bringup code
      ARM: SAMSUNG: use generic uncompress.h
      ARM: SAMSUNG: remove all custom uncompress.h

Hisashi Nakamura (1):
      ARM: shmobile: r8a7790 SYSC setup code

Huang Shijie (1):
      ARM: dts: vf610: use the interrupt macros

Imre Kaloz (1):
      ARM: OMAP2+: Use pdata quirks for wl12xx on the AM335x EV-MSK

Ivan Khoronzhuk (10):
      ARM: dts: keystone: add watchdog entry
      ARM: dts: keystone: add keystone timer entry
      ARM: config: keystone: enable watchdog support
      ARM: dts: keystone: drop msmcsram clock node
      ARM: davinci: aemif: get rid of davinci-nand driver dependency on aemif
      ARM: dts: keystone: add AEMIF/NAND device entry
      ARM: config: keystone: enable AEMIF/NAND support
      ARM: dts: keystone: Fix domain register range for clkfftc1
      ARM: dts: keystone: Fix control register range for clktsip
      ARM: dts: keystone: use common "ti,keystone" compatible instead of -evm

Jason Cooper (8):
      Merge tag 'tags/mvebu-soc-3.15' into mvebu/soc-3xx
      Merge tag 'tags/mvebu-dt-fixes-3.14' into mvebu/dt
      ARM: mvebu: Armada 375/38x depend on MULTI_V7
      ARM: kirkwood: select dtbs based on SoC
      Merge branch 'mvebu/soc-3xx' into mvebu/soc
      Merge branch 'mvebu/soc-kw' into mvebu/soc
      Merge branch 'mvebu/dt-3xx' into mvebu/dt
      ARM: mvebu: select dtbs from MACH_ARMADA_*

Jean-Jacques Hiblot (6):
      ARM: at91: dt: Add at91sam9261 dt SoC support
      ARM: at91: dt: defconfig: Added the sam9261 to the list of DT-enabled SOCs
      ARM: at91: dt: sam9261: Device Tree support for the at91sam9261ek
      ARM: at91: updated the at91_dt_defconfig with support for the ADS7846
      ARM: at91: prepare common clk transition for sam9261 SoC
      ARM: at91: move sam9261 SoC to common clk

Jingchang Lu (1):
      ARM: dts: vf610: Add eDMA node

John Tobias (2):
      ARM: dts: imx6sl: Adding cpu frequency and VDDSOC/PU table.
      ARM: imx: add select on ARCH_MXC for cpufreq support

Josh Cartwright (2):
      bus: mvebu-mbus: make use of of_find_matching_node_and_match
      ARM: mvebu: make use of of_find_matching_node_and_match

Keita Kobayashi (1):
      ARM: shmobile: r8a7790 CA15-SCU enablement

Kevin Hilman (1):
      ARM: davinci: fix DT booting with default defconfig

Kishon Vijay Abraham I (1):
      ARM: dts: omap5: added dt properties to adapt to the new phy framwork

Krzysztof Halasa (2):
      IXP4xx: Fix Goramo Multilink GPIO conversion.
      IXP4xx: Fix DMA masks.

Krzysztof Hałasa (2):
      CNS3xxx: Fix a WARN() related to IRQ allocation.
      CNS3xxx: Fix PCIe early iotable_init().

Kukjin Kim (1):
      Merge branch 'v3.15-next/cleanup-samsung-2' into v3.15-next/s2r-pm-samsung-2

Kumar Gala (12):
      ARM: dts: msm: split out msm8660 and msm8960 soc into dts include
      ARM: msm: kill off hotplug.c
      clocksource: qcom: Move clocksource code out of mach-msm
      ARM: qcom: Split Qualcomm support into legacy and multiplatform
      clocksource: qcom: split building of legacy vs multiplatform support
      ARM: qcom: Rename various msm prefixed functions to qcom
      tty: serial: msm: Enable building msm_serial for ARCH_QCOM
      drm/msm: drop ARCH_MSM Kconfig depend
      power: reset: msm - switch Kconfig to ARCH_QCOM depends
      hwrng: msm: switch Kconfig to ARCH_QCOM depends
      gpio: msm: switch Kconfig to ARCH_QCOM depends
      ARM: qcom: Enable basic support for Qualcomm platforms in multi_v7_defconfig

Kuninori Morimoto (22):
      ARM: shmobile: bockw: use SSI DMAEngine for sound
      ARM: shmobile: bockw: use HPBIF DMAEngine for sound
      ARM: shmobile: bockw: add USB Func DMAEngine support
      ARM: shmobile: r8a7790: add Audio DMAC clock
      ARM: shmobile: r8a7790: add Audio DMAC support
      ARM: shmobile: marzen: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: mackerel: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: lager: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: kzm9g: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: kzm9d: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: genmai: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: bockw: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: armadillo: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: ape6evm: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: bockw: use wp-gpios instead of WP pin
      ARM: shmobile: lager: add sound support
      ARM: shmobile: lager: add sound support on defconfig
      ARM: shmobile: lager: add SDHI0/2 support
      ARM: shmobile: lager: add SDHI0/2 support on DTS
      ARM: shmobile: r8a7778: add audio clock in new style
      ARM: shmobile: r8a7790: add audio clock
      ARM: shmobile: r8a7790: add sound SCU clock support

Laurent Pinchart (20):
      ARM: shmobile: dts: Remove r8a7791-koelsch-reference.dts
      ARM: shmobile: Add GPIO keys to Koelsch DTS
      ARM: shmobile: r8a7791: Add serial ports to the device tree
      ARM: shmobile: r8a7790: Add serial ports to the device tree
      ARM: shmobile: r8a7790: Add VIN clocks to device tree
      ARM: shmobile: r8a7791: Add VIN clocks to device tree
      ARM: shmobile: r8a7790: Add SATA clocks to device tree
      ARM: shmobile: r8a7791: Add SATA clocks to device tree
      ARM: shmobile: r8a7790: Fix serial ports DT compatible strings
      ARM: shmobile: r8a7790: Replace IRQ type numerical values with macros
      ARM: shmobile: r8a7779: Wait for status on selected MSTP clocks
      ARM: shmobile: lager-reference: Refactor clock lookup hack
      ARM: shmobile: lager: Add DU device to DTS
      ARM: shmobile: lager-reference: Add DU device
      ARM: shmobile: koelsch-reference: Refactor clock lookup hack
      ARM: shmobile: koelsch-reference: Add DU device
      ARM: shmobile: koelsch-reference: Add DU device to DTS
      sh: intc: Enable driver compilation with COMPILE_TEST
      ARM: shmobile: r8a7791: Remove legacy clock aliases for DT devices
      ARM: shmobile: APMU: Fix warnings due to improper printk formats

Laxman Dewangan (2):
      ARM: tegra: add system-power-controller property for PMIC node
      ARM: tegra: defconfig updates

Lee Jones (2):
      ARM: STi: stih416: Add support for the FSM Serial Flash Controller
      ARM: STi: stih41x: Add support for the FSM Serial Flash Controller

Leela Krishna Amudala (2):
      ARM: dts: Add pmu sysreg node to exynos5250 and exynos5420
      ARM: dts: update watchdog device nodes for exynos5250 and exynos5420

Linus Walleij (32):
      ARM/serial: at91: switch atmel serial to use gpiolib
      ARM: ux500: move AB8500 GPIOs to device tree
      ARM: ux500: move AB8500 YCBCR settings to device tree
      ARM: ux500: move AB8500 PWM out settings to device tree
      ARM: ux500: move AB8500 audio interface 1 settings to DT
      ARM: ux500: move AB8500 USB UICC settings to DT
      ARM: ux500: move AB8500 DMIC settings to DT
      ARM: ux500: move AB8500 EXTCPENA from board file to DT
      ARM: ux500: move AB8500 modem I2C settings to DT
      ARM: ux500: move AB8500 clock out pins to DT
      ARM: ux500: move last AB8505 set-up to DT
      ARM: integrator: define clocks in the device trees
      ARM: SP804: make Integrator/CP timer pick clock from DT
      ARM: integrator: switch to fetch clocks from device tree
      clk: versatile: pass a parent to the ICST clock
      clk: versatile: respect parent rate in ICST clock
      irqchip: vic: update the base IRQ member correctly
      irqchip: support cascaded VICs
      ARM: integrator: use managed resources for the IM-PD1
      ARM: integrator: register the IM-PD1 VIC
      ARM: integrator: select GPIO block
      ARM: ux500: switch SSP/SPI clock name to "SSPCLK"
      ARM: u300: switch SSP/SPI clock name to "SSPCLK"
      ARM: integrator: localize the lm.h header
      ARM: integrator: localize the impd1.h header
      ARM: integrator: merge platform.h to hardware.h
      ARM: integrator: localize the hardware.h header
      ARM: integrator: register sched_clock directly
      ARM: ux500: delete pointless DT config option
      ARM: ux500: skip GIC CPU and dist address checks
      ARM: ux500: drop a chunk of GPIO definitions
      mfd: dbx500/abx500: root out hardcoded IRQ assignments

Liu Ying (4):
      ARM: dts: i.MX51 babbage: Support diagnostic LED
      ARM: dts: imx6qdl-sabreauto: Support debug LED
      ARM: imx: clk-imx6sl: Suppress duplicate const sparse warning
      ARM: imx: clk-vf610: Suppress duplicate const sparse warning

Lokesh Vutla (3):
      ARM: OMAP2+: AM43xx: implement support for machine restart
      ARM: OMAP2+: AM43x: Add ID for ES1.1
      ARM: dts: am437x-gp-evm: Add gp dts.

Lothar Waßmann (2):
      ARM: dts: imx6qdl: add aliases for can interfaces
      ARM: dts: imx53: add support for Ka-Ro TX53 modules

Lucas Stach (4):
      ARM: imx53: use clock defines in DTS files
      ARM: imx51: use clock defines in DTS files
      ARM: imx50: use clock defines in DTS files
      ARM: dts: tegra: add PCIe interrupt mapping properties

Ludovic Desroches (1):
      ARM: at91: sama5d3: get rid of atmel_tsadcc driver

Magnus Damm (15):
      ARM: shmobile: Remove Lager USBHS UDC ifdefs
      ARM: shmobile: Lager USB0 cable detection workaround
      ARM: shmobile: Add SDHI devices for legacy Koelsch
      ARM: shmobile: Get rid of legacy KZM9D defconfig
      ARM: shmobile: Remove KZM9D board code
      ARM: shmobile: Remove Koelsch DT reference legacy clock bits
      ARM: shmobile: Remove Lager DT reference legacy clock bits
      ARM: shmobile: Add r8a7791 legacy SDHI clocks
      ARM: shmobile: Remove legacy r8a7790 DT clocks
      ARM: shmobile: Use 64-bit dma_addr_t on r8a7790/r8a7791
      ARM: shmobile: Break out R-Car SYSC PM code
      ARM: shmobile: Remove __init from rcar_gen2_read_mode_pins()
      ARM: shmobile: Move SYSC base variable to inside ifdefs
      ARM: shmobile: Add SDHI devices to r8a7791 DTSI
      ARM: shmobile: Add SDHI devices for Koelsch DTS

Marc Dietrich (1):
      ARM: tegra: paz00: Add LVDS support to device tree

Marc Zyngier (1):
      ARM: sun7i: add arch timer node

Marek Belisko (1):
      ARM: dts: omap3-gta04: Add touchscreen properties

Marek Vasut (7):
      ARM: dts: imx6q-sabrelite: Enable PCI express
      ARM: dts: imx53: Fix display pinmux for M53EVK
      ARM: dts: imx53: Fix backlight for M53EVK
      ARM: dts: imx53: Add USB support for M53EVK
      ARM: dts: imx53: Add AHCI SATA DT node
      ARM: dts: imx53: Enable AHCI SATA for M53EVK
      ARM: dts: mxs: Fix the RTC compatible prop on M28EVK

Mark Brown (3):
      ARM: dts: Remove leftover spi0 node for smdk5250
      serial: s3c: Fix build of header without serial_core.h preinclusion
      ARM: S3C64XX: Fix build for implicit serial_s3c.h inclusion

Markus Mayer (8):
      ARM: bcm2835: Move to mach-bcm directory
      ARM: bcm281xx: Move kona_l2_cache_init() so it can be shared
      ARM: bcm281xx: Consolidate reboot code
      ARM: bcm281xx: Re-order hearder files
      ARM: bcm281xx: Rename board_init() function
      ARM: bcm21664: Add board support.
      ARM: DT: bcm21664: Device tree bindings
      ARM: dts: bcm21664: Add device tree files.

Markus Pargmann (8):
      ARM: dts: imx27 pin functions
      ARM: dts: imx27 iomux device node
      ARM: dts: imx27 phyCARD-S pinctrl
      ARM: dts: imx27 phycore move uart1 to rdk
      ARM: dts: imx27 phycore pinctrl
      ARM: dts: imx5: use imx51-ssi
      ARM: dts: imx6: use imx51-ssi
      ARM: dts: tps65910 backup battery regulator

Matt Porter (6):
      ARM: dts: AM33XX: Add ecap interrupt properties
      ARM: dts: remove bcm11351-brt.dts
      Merge tag 'armsoc/for-3.15/soc-2' into armsoc/for-3.15/soc-3
      ARM: dts: add bcm590xx pmu support and enable for bcm28155-ap
      ARM: dts: bcm28155-ap: leave camldo1 on to fix reboot
      ARM: configs: bcm_defconfig: enable bcm590xx regulator support

Maxime Ripard (25):
      reset: Add of_reset_control_get
      ARM: sun4i: a10: Add missing serial aliases
      ARM: sun5i: a10s: Add missing serial aliases
      ARM: sun6i: Add missing serial aliases
      ARM: sun7i: Add missing serial aliases
      ARM: sun5i: a13: Add missing serial aliases
      ARM: sun6i: dt: Add PLL6 and SPI module clocks
      ARM: sun6i: dt: Add SPI controllers to the A31 DTSI
      ARM: sunxi: Enable A31 SPI and SID in the defconfig
      ARM: mxs: cfa10049: Add NAU7802 ADCs to the device tree
      ARM: dts: cfa10036: Add dr_mode and phy_type properties to the DT
      ARM: sunxi: dt: Convert to the new clock compatibles
      ARM: dt: sun7i: Add A20 SPI controller nodes
      ARM: dt: sun4i: Add A10 SPI controller nodes
      ARM: dt: sun5i: Add A10s SPI controller nodes
      ARM: dt: sun5i: Add A13 SPI controller nodes
      ARM: dt: sun7i: Add SPI muxing options
      ARM: dts: sun7i: Enable the SPI controllers of the A20-olinuxino-micro
      ARM: sun6i: dt: Fix mod0 compatible
      ARM: sun6i: Enable the I2C controllers
      ARM: sun6i: Enable the I2C muxing options
      ARM: sun6i: colombus: Enable the I2C controllers
      ARM: sunxi: dt: Update the watchdog compatibles
      ARM: sunxi: Add the new watchog compatibles to the reboot code
      ARM: sunxi: Select HAVE_ARM_ARCH_TIMER

Michael Grzeschik (1):
      ARM: i.MX28: dts: rename usbphy pin names

Michael Heimpold (1):
      ARM: mxs: add support for I2SE's duckbill series

Michal Simek (6):
      ARM: zynq: Split slcr in two parts
      ARM: zynq: Map I/O memory on clkc init
      ARM: zynq: Add and use zynq_slcr_read/write() helper functions
      ARM: zynq: Introduce zynq_slcr_unlock()
      ARM: zynq: Move of_clk_init from clock driver
      ARM: zynq: Add waituart implementation

Mugunthan V N (1):
      ARM: dts: am33xx: correcting dt node unit address for usb

Murali Karicheri (6):
      ARM: dts: keystone: fix domain id for clkdebugsstrc
      ARM: dts: keystone: update for supporting K2L/K2E EVMs
      ARM: dts: keystone: preparatory patch to support K2L and K2E SOCs
      ARM: dts: keystone: add support for K2 Lamarr SoC and EVM
      ARM: dts: keystone: add support for k2 Edison SoC and EVM
      ARM: dts: k2hk-evm: set ubifs partition size for 512M NAND

Naveen Krishna Chatradhi (1):
      ARM: dts: add dt node for sss module for exynos5250/5420

Neil Zhang (1):
      irqchip: mmp: avoid use head file in a specific arch

NeilBrown (5):
      ARM: dts: omap3-gta04: Add support for magnetometer
      ARM: dts: omap3-gta04: Add twl4030 charger
      ARM: dts: omap3-gta04: Add basic sound support
      ARM: dts: omap3-gta04: Enable mmc2 for wifi
      ARM: dts: omap3-gta04: Add bma180 accelerometer

Nicolas Ferre (1):
      ARM: at91/DT: add NAND + DMA property

Nicolin Chen (2):
      ARM: dts: imx: specify the value of audmux pinctrl instead of 0x80000000
      ARM: dts: imx6qdl: add spdif support for sabreauto

Nishanth Menon (6):
      ARM: OMAP3+: DPLL: stop reparenting to same parent if already done
      ARM: dts: OMAP3+: add clock nodes for CPU
      ARM: dts: Add basic devices for AM3517-craneboard
      ARM: dts: omap3430-sdp: add dip switch information for MMC operation
      ARM: dts: DRA7: Add device nodes for ABB
      ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM

Oliver Schinagl (1):
      ARM: sun4i: dt: Add ahci / sata support

Olof Johansson (64):
      Merge tag 'dropmachtimexh-v2' of git://git.pengutronix.de/git/ukl/linux into next/cleanup
      Merge tag 'renesas-boards-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-cleanup-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-defconfig-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-dt-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-soc-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'imx6-dt-3.15' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-dt-3.15' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'qcom-cleanup-for-3.15' of git://git.kernel.org/.../galak/linux-qcom into next/cleanup
      Merge tag 'ab8500-dt-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'qcom-soc-for-3.15' of git://git.kernel.org/.../galak/linux-qcom into next/soc
      Merge tag 'renesas-boards2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-defconfig2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-dt2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'integrator-for-v3.15-1' of git://git.kernel.org/.../linusw/linux-integrator into next/drivers
      Merge tag 'mvebu-dt-3.15' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'mvebu-soc-3.15' of git://git.infradead.org/linux-mvebu into next/cleanup
      Merge tag 'mvebu-defconfig-3.15' of git://git.infradead.org/linux-mvebu into next/boards
      Merge branch 'integrator/multiplatform-base' into next/cleanup2
      Merge tag 'integrator-for-v3.15-2' of git://git.kernel.org/.../linusw/linux-integrator into next/cleanup2
      Merge tag 'v3.15-rockchip-smp' of git://git.kernel.org/.../mmind/linux-rockchip into next/soc
      Merge tag 'omap-for-v3.15/soc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-for-v3.15/prcm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-for-v3.15/dt-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'mvebu-watchdog-3.15-2' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge tag 'omap-for-v3.15/crossbar-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'samsung-drivers' of http://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'samsung-cleanup' of http://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'samsung-dt' of http://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'exynos-clk' of http://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'sunxi-dt-for-3.15' of https://github.com/mripard/linux into next/dt
      Merge tag 'ux500-dt-v3.15-2' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'irq-mmp' of https://git.kernel.org/.../hzhuang1/linux into next/cleanup
      Merge tag 'pxa' of https://git.kernel.org/.../hzhuang1/linux into next/boards
      Merge tag 'sirf-soc-for-3.15' of git://git.kernel.org/.../baohua/linux into next/cleanup
      Merge tag 'imx6-dt-3.15-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-dt-3.15-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-soc-3.15' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      ARM: enable ARM_HAS_SG_CHAIN for multiplatform
      Merge tag 'keystone-dts' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt
      Merge tag 'keystone-soc' of git://git.kernel.org/.../ssantosh/linux-keystone into next/boards
      Merge tag 'armsoc/for-3.15/soc-2' of git://github.com/broadcom/mach-bcm into next/soc
      Merge tag 'armsoc/for-3.15/dt' of git://github.com/broadcom/mach-bcm into next/dt
      Merge tag 'armsoc/for-3.15/cleanup' of git://github.com/broadcom/mach-bcm into next/cleanup
      Merge tag 'bcm2835-for-3.15-soc' of git://git.kernel.org/.../swarren/linux-rpi into next/cleanup
      Merge tag 'bcm2835-for-3.15-dt' of git://git.kernel.org/.../swarren/linux-rpi into next/dt
      Merge tag 'omap-for-v3.15/dt-part2' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'zynq-dt-for-3.15' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'renesas-intc-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/sh
      Merge tag 'renesas-boards3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-defconfig3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-dt3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-clock-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-soc2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-dt4-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-clock2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-clock3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-soc3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-clock4-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'tegra-for-3.15-tf' of git://git.kernel.org/.../tegra/linux into next/soc
      Merge tag 'tegra-for-3.15-drivers' of git://git.kernel.org/.../tegra/linux into next/drivers
      Merge tag 'tegra-for-3.15-soc' of git://git.kernel.org/.../tegra/linux into next/soc
      Merge tag 'tegra-for-3.15-dt' of git://git.kernel.org/.../tegra/linux into next/dt
      Merge tag 'tegra-for-3.15-defconfig' of git://git.kernel.org/.../tegra/linux into next/boards

Pankaj Dubey (2):
      clocksource: exynos_mct: remove unwanted header file inclusion
      irqchip: exynos-combiner: call handle_bad_irq directly

Paul Bolle (3):
      ARM: S3C24XX: Fix typo CONFIG_CPUS_3C2443
      ARM: S3C24XX: get rid of unneeded selects
      ARM: OMAP2+: remove OMAP_PACKAGE_ZAC and OMAP_PACKAGE_ZAF

Paul Gortmaker (1):
      ARM: S3C64XX: mach-crag6410-module.c is not modular

Pekon Gupta (4):
      ARM: OMAP2+: gpmc: update gpmc_hwecc_bch_capable() for new platforms and ECC schemes
      ARM: dts: am335x-evm: NAND: update MTD partition table
      ARM: dts: AM33xx: updated default ECC scheme in nand-ecc-opt
      ARM: dts: am43xx: add support for parallel NAND flash

Peter Chen (4):
      ARM: dts: imx6q-arm2: enable USB OTG
      ARM: dts: mxs: add mxs phy controller id
      ARM: dts: imx6: add anatop phandle for usbphy
      ARM: dts: imx6: add mxs phy controller id

Peter Ujfalusi (9):
      ARM: dts: omap4-panda-common: Move audio related pinmux to respective nodes
      ARM: dts: omap4-sdp: Move audio related pinmux to respective nodes
      ARM: dts: omap4: Set all audio related IP's status to disabled as default
      ARM: dts: omap4-panda-common: No need to disable the unused audio nodes
      ARM: dts: omap4-sdp: No need to disable mcbsp3 node
      ARM: dts: omap5: Set all audio related IP's status to disabled as default
      ARM: dts: omap3: Set disabled status for McBSP instances as default state
      ARM: dts: omap2: Set disabled status for McBSP instances as default state
      ARM: dts: am335x-evmsk: Correct audio clock frequency

Philipp Zabel (5):
      reset: allow drivers to request probe deferral
      ARM: dts: imx6q-sabrelite: PHY reset is active-low
      ARM: imx6q: Add GPR6 and GPR7 register definitions for iomuxc gpr
      ARM i.MX6q: Mark VPU and IPU AXI transfers as cacheable, increase IPU priority
      reset: Add optional resets and stubs

Punit Agrawal (2):
      drivers: cci: Extend support to CCI revisions > r1p2
      drivers: cci: Export CCI PMU revision

Rajendra Nayak (1):
      ARM: OMAP2+: AM43x: Use gptimer as clocksource

Rashika Kheria (1):
      reset: Mark function as static and remove unused function in core.c

Richard Weinberger (1):
      ARM: mach-bcm: Remove GENERIC_TIME

Rob Herring (9):
      ARM: centralize common multi-platform kconfig options
      ARM: select HAVE_SMP for V7 multi-platform
      ARM: select MIGHT_HAVE_CACHE_L2X0 for V6 and V7 multi-platform
      ARM: Select V6K instead of V6 by default for multi-platform
      ARM: bcm2835: enable V6K instead of plain V6
      ARM: cns3xxx: enable V6K instead of plain V6
      ARM: vt8500: enable V6K instead of plain V6
      ARM: virt: make mach-virt just a kconfig option
      ARM: virt: select ARM_AMBA

Robert Nelson (1):
      ARM: dts: imx53: Enable AHCI SATA for imx53-qsb

Roger Quadros (3):
      ARM: OMAP2+: Remove legacy_init_ehci_clk()
      ARM: dts: Get rid of incompatible ids for hci-omap USB host nodes
      ARM: dts: Update echi-omap DT binding example usage

Rohit Vaswani (6):
      ARM: msm: Remove pen_release usage
      ARM: qcom: Re-organize platsmp to make it extensible
      devicetree: bindings: Document Krait/Scorpion cpus and enable-method
      ARM: qcom: Add SMP support for KPSSv1
      ARM: qcom: Add SMP support for KPSSv2
      ARM: dts: qcom: Add nodes necessary for SMP boot

Roman Byshko (10):
      ARM: sun4i: dt: Add bindings for USB clocks
      ARM: sun5i: dt: Add bindings for USB clocks
      ARM: sun7i: dt: Add bindings for USB clocks
      ARM: sun4i: dt: Add USB host bindings
      ARM: sun5i: dt: Add USB host bindings
      ARM: sun7i: dt: Add USB host bindings
      ARM: sun4i: dt: Add USB host nodes to Mele A1000 dts
      ARM: sun4i: dt: Add USB host nodes to cubieboard dts
      ARM: sun5i: dt: Add USB host nodes to A13-Olinuxino
      ARM: sun7i: dt: Add USB host nodes to cubieboard2 dts

Rostislav Lisovy (4):
      ARM: dts: i.MX53: Internal keyboard controller
      ARM: dts: Add vendor prefix for Voipac Technologies s.r.o.
      ARM: dts: i.MX53: dts for Voipac x53-dmm-668 module
      ARM: dts: i.MX53: Devicetree for Voipac Baseboard using x53-dmm-668 module

Sachin Kamat (22):
      ARM: SAMSUNG: Remove platform dependency from samsung.S
      ARM: S3C24XX: Move rtc-core.h from plat to mach
      ARM: dts: Add regulator entries to smdk5420
      ARM: dts: Re-organize RTC status for exynos5420
      ARM: dts: Re-organize RTC status for exynos5250
      ARM: dts: Add ADMA node to exynos5420
      ARM: dts: Add I2S nodes to exynos5420
      ARM: dts: Add fixed voltage regulators to smdk5420
      ARM: dts: Add PMIC support to arndale-octa board
      ARM: dts: Add wake up key to arndale-octa board
      ARM: dts: Add vmmc-supply to MMC on arndale-octa board
      ARM: debug: Use generic uncompress.h for exynos
      ARM: EXYNOS: Remove uncompress.h
      ARM: EXYNOS: Add support to reserve memory for MFC-v7
      ARM: SAMSUNG: Introduce generic Exynos4 and 5 helpers
      ARM: EXYNOS: Consolidate CPU init code
      ARM: EXYNOS: Consolidate exynos4 and exynos5 machine files
      ARM: EXYNOS: Add generic compatible strings
      ARM: dts: Update Exynos DT files with generic compatible strings
      ARM: S3C24XX: Remove invalid code from hardware.h
      ARM: SAMSUNG: Remove hardware.h inclusion
      ARM: EXYNOS: Remove hardware.h file

Santosh Shilimkar (1):
      ARM: dts: Build all keystone dt blobs

Sascha Hauer (7):
      ARM: dts: imx53: Add mmc aliases
      ARM: dts: imx51: Add mmc aliases
      ARM: dts: imx6q: Add spi4 alias
      ARM: dts: imx6qdl: Add mmc aliases
      ARM: dts: imx6: Add DFI FS700-M60 board support
      ARM: dts: imx6q: Add support for Zealz GK802
      ARM i.MX: remove PWM platform support

Sascha Silbe (1):
      ARM: dts: imx6qdl-wandboard: use GPIO_6 for FEC interrupt

Sebastian Andrzej Siewior (1):
      ARM: imx: enable delaytimer on the imx timer

Sebastian Hesselbarth (6):
      ARM: dove: add additional pinctrl registers
      ARM: dove: add global-config register node
      ARM: dove: add system controller node
      ARM: mvebu: move DT Dove to MVEBU
      ARM: dove: drop pinctrl PMU reg property
      ARM: add Marvell Dove and some drivers to multi_v7 defconfig

Sebastian Reichel (7):
      ARM: dts: omap3 clocks: simplify ssi aliases
      ARM: dts: TWL4030: Add keypad node
      ARM: dts: OMAP3-N900: Add TWL4030 Keypad Matrix
      ARM: dts: OMAP3-N900: Add support for tsl2563
      ARM: dts: OMAP3-N900: Add tpa6130a2 support
      ARM: dts: OMAP3-N900: Add isp1704 support
      ARM: dts: OMAP3-N900: Add bq24150a support

Sekhar Nori (4):
      ARM: davinci: enable da8xx build concurrently with older devices
      ARM: davinci: add da8xx specific configs to davinci_all_defconfig
      ARM: davinci: da8xx: fix multiple watchdog device registration
      ARM: davinci: remove da8xx_omapl_defconfig

Sergei Shtylyov (12):
      ARM: shmobile: Lager: conditionally select CONFIG_MICREL_PHY
      ARM: shmobile: Lager: pass Ether PHY IRQ
      ARM: shmobile: Koelsch: pass Ether PHY IRQ
      ARM: shmobile: Armadillo 800 EVA: set proper DMA masks for Ether device
      ARM: shmobile: BOCK-W: set proper DMA masks for Ether device
      ARM: shmobile: Lager: set proper DMA masks for Ether device
      ARM: shmobile: Koelsch: set proper DMA masks for Ether device
      ARM: shmobile: Genmai: set proper DMA masks for Ether device
      ARM: shmobile: r8a7790: add Ether DT support
      ARM: shmobile: lager: add Ether DT support
      ARM: shmobile: r8a7791: add Ether DT support
      ARM: shmobile: koelsch: add Ether DT support

Shawn Guo (20):
      ARM: dts: imx6qdl: make pinctrl nodes board specific
      ARM: dts: imx6sl: make pinctrl nodes board specific
      ARM: dts: imx6: use generic node name for fixed regulator
      ARM: dts: imx53: make pinctrl nodes board specific
      ARM: dts: imx51: make pinctrl nodes board specific
      ARM: dts: vf610: make pinctrl nodes board specific
      ARM: dts: imx53-mba53: create a container for fixed regulators
      ARM: dts: imx: use generic node name for fixed regulator
      Merge tag 'kconfig-cleanup-for-3.15' into imx/soc
      ARM: imx6q: remove unneeded clk lookups
      ARM: imx6q: support ptp and rmii clock from pad
      bus: imx-weim: support CS GPR configuration
      ARM: imx6: move v7_cpu_resume() into suspend-imx6.S
      ARM: imx6: build headsmp.o only on CONFIG_SMP
      ARM: imx6: call suspend_set_ops() from suspend routine
      ARM: imx6: do not call imx6q_suspend_init() with !CONFIG_SUSPEND
      ARM: imx6: introduce CONFIG_SOC_IMX6 for i.MX6 common stuff
      ARM: imx6: rename pm-imx6q.c to pm-imx6.c
      ARM: imx6: build suspend-imx6.o with CONFIG_SOC_IMX6
      ARM: imx6: drop .text.head section annotation from headsmp.S

Shinya Kuribayashi (2):
      ARM: shmobile: r8a7790: Wait for status on all MSTP clocks
      ARM: shmobile: r8a7791: Wait for status on all MSTP clocks

Silvio F (2):
      DT: Add Data Modul vendor prefix
      ARM: dts: imx6: Add support for imx6q dmo edmqmx6

Simon Horman (15):
      ARM: shmobile: koelsch: Conditionally select MICREL_PHY for Multiplatform
      ARM: shmobile: ape6evm: Conditionally select SMSC_PHY
      ARM: shmobile: armadillo800eva: Conditionally select SMSC_PHY
      ARM: shmobile: bockw: Sort Kconfig node's selections
      ARM: shmobile: r8a7779: Remove unused clock constants
      ARM: shmobile: emev2: Use __initconst for const init definition
      ARM: shmobile: kzm9d: Conditionally select SMSC_PHY
      ARM: shmobile: mackerel: Conditionally select SMSC_PHY
      ARM: shmobile: marzen: Conditionally select SMSC_PHY
      Revert "ARM: shmobile: marzen: Conditionally select SMSC_PHY"
      ARM: shmobile: genmai: Enable r7s72100-ether
      ARM: shmobile: Add defconfig for shmobile multiplatform
      ARM: shmobile: koelsch: Enable SDHI, GPIO and regulators in defconfig
      ARM: shmobile: r7s72100: Add clock for r7s72100-ether
      ARM: shmobile: r8a7790: Correct SYS DMAC clock defines

Simon Kågström (1):
      ARM: ixp4xx: Make dma_set_coherent_mask common, correct implementation

Soren Brinkmann (1):
      arm: dt: zynq: Add fclk-enable property to clkc node

Sourav Poddar (7):
      ARM: dts: am4372: Add pwm-cells property for ecap device.
      ARM: dts: am43x-epos-evm: Add pwm backlight support.
      ARM: dts: am43x-epos-evm: Add I2C2 data.
      ARM: dts: am43x-epos-evm: Add SPI data.
      ARM: dts: am437x-gp-evm: Add pwm backlight support.
      ARM: dts: am437x-gp-evm: Enable gpio.
      ARM: dts: am43x-gp-evm: Add matrix gpio keys.

Sricharan R (4):
      DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
      DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP
      ARM: OMAP4+: Correct Wakeup-gen code to use physical irq number
      ARM: DRA: Enable Crossbar IP support for DRA7XX

Srinivas Kandagatla (13):
      ARM: STi: STiH416: Add interrupt support for pin controller
      ARM: STi: STiH415: Add interrupt support for pin controller
      ARM: STi: STiH415: Add reset controller support.
      ARM: STi: STiH415: Add soft reset controller support.
      ARM: STi: STiH416: Add reset controller support.
      ARM: STi: STiH416: Add soft reset controller support.
      ARM: STi: STiH415: Add ethernet support.
      ARM: STi: STiH416: Add ethernet support.
      ARM: STi: STIH415: Add IR support.
      ARM: STi: STIH416: Add IR support.
      drivers: reset: stih415: add softreset controller
      drivers: reset: stih416: add softreset controller
      MAINTAINERS: Update ARM STi maintainers

Stanimir Varbanov (2):
      ARM: dts: qcom: Add RNG device tree node
      ARM: dts: qcom-msm8960-cdp: Add RNG device tree node

Stefan Agner (1):
      ARM: tegra: don't timeout if CPU is powergated

Stefan Roese (2):
      arm: dts: am33xx.dtsi: Add node name to rtc device node
      ARM: dts: Add MMC2/SDIO/WLAN support for cm-t3530

Stefan Sørensen (1):
      ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Steffen Trumtrar (6):
      ARM: zynq: Move clock_init from slcr to common
      ARM: dts: Add support for the i.MX35.
      ARM: dts: i.MX53: move common QSB nodes to new file
      ARM: dts: i.MX53: add support for MCIMX53-START-R
      ARM: zynq: Hang iomapped slcr address on device_node
      ARM: zynq: Make zynq_slcr_base static

Stephen Boyd (4):
      ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu hotplug/smp
      devicetree: bindings: Document qcom,kpss-acc
      devicetree: bindings: Document qcom,saw2 node
      ARM: dts: msm: Add krait-pmu to platforms with Krait CPUs

Stephen Gallimore (4):
      drivers: reset: STi SoC system configuration reset controller support
      drivers: reset: Reset controller driver for STiH415
      drivers: reset: Reset controller driver for STiH416
      ARM: STi: Add reset controller support to mach-sti Kconfig

Stephen Warren (12):
      ARM: tegra: document which Dalmore revisions are supported
      ARM: bcm2835: fix DT node sort order
      ARM: tegra: enable LCD panel on Seaboard
      ARM: tegra: enable LCD panel on Ventana
      ARM: tegra: add SPI flash to Venice2 DT
      ARM: bcm2835: node name unit address cleanup
      ARM: bcm2835: fix clock DT node names
      ARM: tegra: remove tegra EMC scaling driver
      ARM: tegra: use 2 address cells for Tegra124 DT
      ARM: tegra: fix Dalmore pinctrl configuration
      ARM: tegra: fix board DT pinmux setup
      ARM: update multi_v7_defconfig for Tegra

Suman Anna (11):
      ARM: AM43x: hwmod data: register spinlock OCP interface
      ARM: dts: OMAP: Add #hwlock-cells property to hwspinlock nodes
      ARM: dts: DRA7: Add hwspinlock node
      ARM: dts: AM4372: Add hwspinlock node
      ARM: OMAP3: fix iva mmu programming issues
      ARM: OMAP2+: change the ISP device archdata MMU name for DT
      ARM: OMAP2+: use pdata quirks for iommu reset lines
      ARM: OMAP5: hwmod data: add mmu data for ipu & dsp
      ARM: OMAP2+: extend iommu pdata-quirks to OMAP5
      ARM: dts: OMAP5: Add IOMMU nodes
      ARM: OMAP4: hwmod data: correct the idlemodes for spinlock

Sébastien Szymanski (1):
      ARM: dts: imx28-apf28dev: add user button

Takashi Yoshii (2):
      ARM: shmobile: koelsch: (1+1)GiB memory in DT
      ARM: shmobile: kzm9d: Use common clock framework

Thierry Reding (13):
      ARM: tegra: Properly sort clocks property
      ARM: tegra: Use "disabled" for status property
      ARM: tegra: Combine VBUS enable pins into one node
      ARM: tegra: Export I/O rail functions
      ARM: tegra: Overhaul Venice2 regulators
      ARM: tegra: Hook up SDMMC3 power-supply on Venice2
      ARM: tegra: Add Tegra124 host1x support
      ARM: tegra: Add Tegra124 eDP support
      ARM: tegra: Enable eDP for Venice2
      ARM: tegra: Add Tegra124 USB support
      ARM: tegra: Enable USB on Venice2
      ARM: tegra: Fix whitespace around '='
      ARM: tegra: Rename as3722 node to pmic

Thomas Abraham (2):
      ARM: dts: update vdd_arm voltage range for exynos4412 based boards
      ARM: dts: add max77686 pmic node for smdk5250

Thomas Petazzoni (29):
      ARM: mvebu: rename mvebu_defconfig to mvebu_v7_defconfig
      ARM: mvebu: remove unneeded ->map_io field for Armada 370/XP
      ARM: mvebu: use GPIO DT defines in Armada 370/XP boards
      ARM: mvebu: use input DT defines in Armada 370/XP boards
      ARM: mvebu: add audio I2S controller to Armada 370 Device Tree
      ARM: mvebu: add I2C0 muxing option for Armada 370 SoC
      ARM: mvebu: add audio support to Armada 370 DB
      ARM: mvebu: enable S/PDIF audio in Armada 370 DB Device Tree
      ARM: mvebu: enable audio options in mvebu_defconfig
      ARM: mvebu: update defconfigs for Armada 375 and 38x
      ARM: mvebu: add Device Tree for the Armada 375 DB board
      ARM: mvebu: add Device Tree description of the Armada 380/385 SoCs
      ARM: mvebu: add Device Tree for the Armada 385 DB board
      rtc: mv: reset date if after year 2038
      ARM: mvebu: rename armada-370-xp.c to board-v7.c
      ARM: mvebu: rename DT machine structure for Armada 370/XP
      ARM: mvebu: make CPU_PJ4B selection a per-SoC choice
      ARM: mvebu: add Armada 375 support to the system-controller driver
      ARM: mvebu: add workaround for data abort issue on Armada 375
      ARM: mvebu: add initial support for the Armada 380/385 SOCs
      Documentation: arm: update Marvell documentation about Armada 375/38x
      ARM: mvebu: use C preprocessor include for Armada 375/38x DTs
      ARM: mvebu: use GIC_{SPI,PPI} in Armada 375/38x DTs
      ARM: mvebu: use macros for interrupt flags on Armada 375/38x
      ARM: mvebu: change the default PCIe apertures for Armada 370/XP
      ARM: mvebu: switch the Armada XP DB to use internal registers at 0xf1000000
      ARM: mvebu: switch the Armada XP GP to use internal registers at 0xf1000000
      ARM: mvebu: the Armada XP Matrix board has 4 GB
      ARM: mvebu: use the correct phy connection mode on Armada 385 DB

Tim Harvey (2):
      ARM: dts: disable flexcan by default
      ARM: dts: add Gateworks Ventana support

Tim Kryger (1):
      ARM: dts: Leave sdio1 as disabled on bcm28155-ap

Tomasz Figa (24):
      ARM: dts: Keep G3D regulator always on for exynos5250-arndale
      clk: exynos4: Remove remnants of non-DT support
      clk: samsung: Provide common helpers for register save/restore
      clk: samsung: exynos4: Move suspend/resume handling to SoC driver
      clk: samsung: exynos5250: Move suspend/resume handling to SoC driver
      clk: samsung: exynos5420: Move suspend/resume handling to SoC driver
      clk: samsung: s3c64xx: Move suspend/resume handling to SoC driver
      clk: samsung: Drop old suspend/resume code
      clk: samsung: exynos4: Add remaining suspend/resume handling
      ARM: EXYNOS: Drop legacy Exynos4 clock suspend/resume code
      ARM: EXYNOS: Do not resume l2x0 if not enabled before suspend
      ARM: SAMSUNG: Add soc_is_s3c2410() helper
      ARM: SAMSUNG: Save UART DIVSLOT register based on SoC type
      ARM: SAMSUNG: Use debug_ll_addr() to get UART base address
      ARM: SAMSUNG: Consolidate PM debug functions
      ARM: SAMSUNG: Move Samsung PM debug code into separate file
      ARM: SAMSUNG: Move common save/restore helpers to separate file
      ARM: SAMSUNG: Move s3c_pm_check_* prototypes to plat/pm-common.h
      ARM: EXYNOS: Fix abuse of CONFIG_PM
      ARM: EXYNOS: Remove PM initcalls and useless indirection
      ARM: EXYNOS: Stop using legacy Samsung PM code
      ARM: EXYNOS: Allow wake-up using GIC interrupts
      ARM: S5P64X0: Explicitly include linux/serial_s3c.h in mach/pm-core.h
      ARM: EXYNOS: Fix compilation error in cpuidle.c

Tomi Valkeinen (1):
      ARM: OMAP2+: clock: fix rate prints

Tony Lindgren (3):
      Merge branch 'crossbar_3.14_rc1' of git://github.com/Sricharanti/sricharan into omap-for-v3.15/crossbar
      Merge tag 'for-v3.15/omap-hwmod-clk-prcm-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.15/prcm
      Merge tag 'for_3.15/dts_signed' of git://git.kernel.org/.../bcousson/linux-omap-dt into omap-for-v3.15/dt

Troy Kisky (26):
      ARM: dts: imx: pinfunc: add MX6QDL_PAD_SD1_CLK__OSC32K_32K_OUT
      ARM: dts: imx: imx6qdl.dtsi: add mipi_csi tag
      ARM: dts: imx: imx6q.dtsi: use IRQ_TYPE_LEVEL_HIGH
      ARM: dts: imx: imx6dl.dtsi: use IRQ_TYPE_LEVEL_HIGH
      ARM: dts: imx: imx6sl.dtsi: use IRQ_TYPE_LEVEL_HIGH
      ARM: dts: imx: imx6qdl.dtsi: use IRQ_TYPE_LEVEL_HIGH
      ARM: dts: imx: sabrelite: add Dual Lite/Solo support
      ARM: dts: imx6qdl-sabrelite: Add uart1 support
      ARM: dts: imx6qdl-sabrelite: remove usdhc4 wp-gpio
      ARM: dts: imx6qdl-sabrelite: move USDHC4 CD to pinctrl_usdhc4
      ARM: dts: imx6qdl-sabrelite: move USDHC3 CD/WP to pinctrl_usdhc3
      ARM: dts: imx6qdl-sabrelite: move spi-nor CS to pinctrl_ecspi1
      ARM: dts: imx6qdl-sabrelite: move usbotg power enable to pinctrl_usbotg
      ARM: dts: imx6qdl-sabrelite: move phy reset to pinctrl_enet
      ARM: dts: imx6qdl-sabrelite: explicitly set pad for SGTL5000 sys_mclk
      ARM: dts: imx6qdl-sabrelite: add pwms for backlights
      ARM: dts: imx6qdl-sabrelite: add skews for Micrel phy
      ARM: dts: imx6qdl-sabrelite: fix ENET group
      ARM: dts: imx6qdl-sabrelite: Add over-current pin to usbotg
      ARM: dts: imx: add nitrogen6x board
      ARM: dts: imx6qdl-sabrelite: add gpio-keys
      ARM: dts: imx: pinfunc: add MX6QDL_PAD_GPIO_6__ENET_IRQ
      ARM: dts: imx6qdl: use interrupts-extended for fec
      ARM: dts: imx6qdl-sabrelite: use GPIO_6 for FEC interrupt.
      ARM: dts: imx6qdl-sabreauto: use GPIO_6 for FEC interrupt.
      ARM: dts: imx6q-arm2: use GPIO_6 for FEC interrupt.

Tushar Behera (9):
      ARM: SAMSUNG: Replace inclusion of plat/regs-serial.h header file
      ARM: SAMSUNG: Delete unused plat/regs-serial.h header file
      ARM: SAMSUNG: Remove Exynos specific code from devs, s5p-pm-irq and pm-gpio.c
      ARM: EXYNOS: Remove unused header file from pm_domains.c
      ARM: exynos_defconfig: Update EHCI config entry
      ARM: SAMSUNG: Reorganize calls to reserve memory for MFC
      ARM: dts: Disable MDMA1 node for arndale-octa board
      ARM: dts: Keep some essential LDOs enabled for arndale-octa board
      dt-bindings: clock: Move exynos-audss-clk.h to dt-bindings/clock

Ulrich Hecht (1):
      ARM: mach-shmobile: kzm9g: add zboot support

Uwe Kleine-König (19):
      rtc: at91sam9: include <mach/hardware.h> explicitly
      rtc: pxa: drop unused #define TIMER_FREQ
      clocksource: sirf/marco+prima2: drop usage of CLOCK_TICK_RATE
      ARM: sa1100: stop using mach/timex.h
      ARM: netx: stop using mach/timex.h
      ARM: mmp: stop using mach/timex.h
      ARM: ep93xx: stop using mach/timex.h
      ARM: at91: don't use <mach/timex.h>
      input: ixp4xx-beeper: don't use symbols from <mach/timex.h>
      ARM: ixp4xx: stop using <mach/timex.h>
      ARM: rpc: stop using <mach/timex.h>
      ARM: drop <mach/timex.h> for !ARCH_MULTIPLATFORM, too
      ARM: ixp4xx: fix timer latch calculation
      ARM: efm32: drop unused file entry-macro.S
      ARM: efm32: drop selecting CLKSRC_MMIO
      Merge tag 'dropmachtimexh-v2' of git://git.pengutronix.de/git/ukl/linux
      ARM: efm32: drop unused file <mach/timex.h>
      ARM: efm32: fix unit address part in USART2 device nodes' names
      ARM: efm32: properly namespace i2c location property

Valentin Raevsky (1):
      ARM: dts: Add initial support for cm-fx6.

Valentine Barshak (21):
      ARM: shmobile: r8a7791: Add SATA nodes to r8a7791.dtsi
      ARM: shmobile: koelsch: Enable SATA0 in r8a7791-koelsch.dts
      ARM: shmobile: r8a7790: Add SATA nodes to r8a7790.dtsi
      ARM: shmobile: lager: Enable SATA1 in r8a7790-lager.dts
      ARM: shmobile: lager: Add VIN1 SoC camera support
      ARM: shmobile: lager: Add SATA support
      ARM: shmobile: koelsch: Add SATA0 support
      ARM: shmobile: r8a7791: Add I2C clocks
      ARM: shmobile: r8a7791: Add VIN clocks
      ARM: shmobile: r8a7790: Add VIN clock support
      ARM: shmobile: r8a7790: Add SATA clocks
      ARM: shmobile: r8a7791: Add ZS clock
      ARM: shmobile: r8a7791: Add SATA clocks
      ARM: shmobile: r8a7790: Add PCI USB host clock support
      ARM: shmobile: lager: Enable VIN along with ADV7180 decoder in defconfig
      ARM: shmobile: koelsch: Enable SATA in defconfig
      ARM: shmobile: lager: Enable SATA in defconfig
      ARM: shmobile: lager: Add USBHS support
      ARM: shmobile: koelsch: Add I2C support
      ARM: shmobile: koelsch: Enable I2C in defconfig
      ARM: shmobile: lager: Add internal USB PCI support

Vince Weaver (1):
      ARM: bcm2835: perf_event support for Raspberry-Pi

Will Deacon (1):
      irqchip: gic: use dmb ishst instead of dsb when raising a softirq

Wolfram Sang (12):
      ARM: shmobile: r7s72100: really add i2c clocks
      drivers/amba: don't check resource with devm_ioremap_resource
      ARM: shmobile: r8a7791: remove superfluous interrupt-parents
      ARM: shmobile: r8a7790: remove superfluous interrupt-parents
      ARM: shmobile: r8a7790: add i2c aliases to dtsi
      ARM: shmobile: r8a7791: add i2c master nodes to dtsi
      ARM: shmobile: r8a7791: add i2c2 bus to koelsch dt
      ARM: shmobile: r7s72100: add nodes for i2c controllers to dtsi
      ARM: shmobile: genmai: adapt dts to use native i2c driver
      ARM: shmobile: r7s72100: update defconfig for I2C usage
      ARM: shmobile: r8a7791: fix clock index for i2c5
      ARM: shmobile: r7s72100: fix bus clock calculation

Xiubo Li (4):
      ARM: dts: vf610: Add edma mux Tx and Rx support for SAI node.
      ARM: dts: vf610-twr: Enable SAI ALSA SoC DAI device
      ARM: dts: vf610-twr: Enable SGTL5000 codec.
      ARM: dts: vf610-twr: Add simple-card support.

Yegor Yefremov (3):
      ARM: dts: am335x-evmsk: enable USB1
      ARM: dts: am335x-evmsk: enable dual_emac mode
      ARM: dts: am335x-evmsk: enable DMA controller for USB

Yuan Yao (2):
      ARM: dts: vf610: lpuart: Add eDMA support
      ARM: dts: vf610: i2c: Add eDMA support

Yuvaraj Kumar C D (1):
      ARM: dts: enable ahci sata and sata phy for exynos5250

Zalan Blenessy (1):
      ARM: sun7i: dt: Add USB host nodes to a20-olinuxino-micro dts

Zoltan HERPAI (1):
      ARM: sun4i: dt: Add basic board support for LinkSprite pcDuino

 Documentation/arm/Marvell/README                   |   12 +-
 .../devicetree/bindings/arm/armada-375.txt         |    9 +
 .../devicetree/bindings/arm/armada-38x.txt         |   10 +
 .../devicetree/bindings/arm/bcm/bcm21664.txt       |   15 +
 .../devicetree/bindings/arm/bcm/kona-resetmgr.txt  |   14 +
 Documentation/devicetree/bindings/arm/bcm4708.txt  |    8 +
 Documentation/devicetree/bindings/arm/cpus.txt     |   25 +-
 Documentation/devicetree/bindings/arm/gic.txt      |    6 +
 .../devicetree/bindings/arm/keystone/keystone.txt  |   10 +
 .../devicetree/bindings/arm/mrvl/feroceon.txt      |   16 +
 .../devicetree/bindings/arm/msm/qcom,kpss-acc.txt  |   30 +
 .../devicetree/bindings/arm/msm/qcom,saw2.txt      |   35 +
 .../bindings/arm/mvebu-system-controller.txt       |    3 +-
 .../devicetree/bindings/arm/omap/crossbar.txt      |   27 +
 Documentation/devicetree/bindings/arm/omap/dmm.txt |   22 +
 .../devicetree/bindings/arm/omap/omap.txt          |    6 +
 .../devicetree/bindings/arm/rockchip/pmu.txt       |   16 +
 .../devicetree/bindings/arm/rockchip/smp-sram.txt  |   30 +
 .../devicetree/bindings/arm/samsung/pmu.txt        |   15 +
 .../devicetree/bindings/ata/exynos-sata-phy.txt    |   14 -
 .../devicetree/bindings/ata/exynos-sata.txt        |   31 +-
 Documentation/devicetree/bindings/bus/imx-weim.txt |   28 +-
 .../devicetree/bindings/clock/arm-integrator.txt   |   34 +
 .../devicetree/bindings/clock/exynos4-clock.txt    |  259 +----
 .../devicetree/bindings/clock/exynos5250-clock.txt |  163 +--
 .../devicetree/bindings/clock/exynos5420-clock.txt |  184 +---
 .../devicetree/bindings/clock/exynos5440-clock.txt |   45 +-
 .../devicetree/bindings/clock/zynq-7000.txt        |    4 +-
 .../devicetree/bindings/i2c/trivial-devices.txt    |    1 +
 .../{arm/atmel-adc.txt => iio/adc/at91_adc.txt}    |   33 +-
 .../interrupt-controller/cirrus,clps711x-intc.txt  |   41 +
 .../devicetree/bindings/mmc/socfpga-dw-mshc.txt    |   23 +
 .../devicetree/bindings/net/socfpga-dwmac.txt      |   27 +
 Documentation/devicetree/bindings/net/stmmac.txt   |    6 +
 .../bindings/pci/nvidia,tegra20-pcie.txt           |    8 +
 .../devicetree/bindings/phy/samsung-phy.txt        |   40 +
 .../bindings/power_supply/qnap-poweroff.txt        |    5 +-
 .../devicetree/bindings/reset/sirf,rstc.txt        |   42 +
 .../devicetree/bindings/reset/st,sti-powerdown.txt |   47 +
 .../devicetree/bindings/reset/st,sti-softreset.txt |   46 +
 .../devicetree/bindings/serial/atmel-usart.txt     |    3 +
 .../devicetree/bindings/usb/atmel-usb.txt          |    4 +-
 .../devicetree/bindings/usb/ehci-omap.txt          |    2 +-
 .../devicetree/bindings/usb/ohci-omap3.txt         |    2 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    7 +
 .../devicetree/bindings/watchdog/marvel.txt        |   11 +-
 MAINTAINERS                                        |   32 +-
 arch/arm/Kconfig                                   |   47 +-
 arch/arm/Kconfig.debug                             |   29 +-
 arch/arm/Makefile                                  |    3 +-
 arch/arm/boot/dts/Makefile                         |  140 ++-
 arch/arm/boot/dts/am335x-evm.dts                   |   60 +-
 arch/arm/boot/dts/am335x-evmsk.dts                 |   56 ++
 arch/arm/boot/dts/am33xx.dtsi                      |   17 +-
 arch/arm/boot/dts/am3517-craneboard.dts            |  174 ++++
 arch/arm/boot/dts/am4372.dtsi                      |   46 +
 arch/arm/boot/dts/am437x-gp-evm.dts                |  127 +++
 arch/arm/boot/dts/am43x-epos-evm.dts               |  183 ++++
 arch/arm/boot/dts/armada-370-db.dts                |   56 ++
 arch/arm/boot/dts/armada-370-mirabox.dts           |    7 +-
 arch/arm/boot/dts/armada-370-rd.dts                |    6 +-
 arch/arm/boot/dts/armada-370-xp.dtsi               |    8 +-
 arch/arm/boot/dts/armada-370.dtsi                  |   33 +
 arch/arm/boot/dts/armada-375-db.dts                |  130 +++
 arch/arm/boot/dts/armada-375.dtsi                  |  464 +++++++++
 arch/arm/boot/dts/armada-380.dtsi                  |  117 +++
 arch/arm/boot/dts/armada-385-db.dts                |  122 +++
 arch/arm/boot/dts/armada-385-rd.dts                |   94 ++
 arch/arm/boot/dts/armada-385.dtsi                  |  149 +++
 arch/arm/boot/dts/armada-38x.dtsi                  |  376 +++++++
 arch/arm/boot/dts/armada-xp-axpwifiap.dts          |    6 +-
 arch/arm/boot/dts/armada-xp-db.dts                 |   13 +-
 arch/arm/boot/dts/armada-xp-gp.dts                 |   22 +-
 arch/arm/boot/dts/armada-xp-matrix.dts             |    7 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   |   12 +-
 arch/arm/boot/dts/armada-xp.dtsi                   |    6 +
 arch/arm/boot/dts/at91-ariag25.dts                 |    1 -
 arch/arm/boot/dts/at91-cosino.dtsi                 |    1 -
 arch/arm/boot/dts/at91-cosino_mega2560.dts         |    1 -
 arch/arm/boot/dts/at91sam9260.dtsi                 |   11 +-
 arch/arm/boot/dts/at91sam9261.dtsi                 |  735 ++++++++++++++
 arch/arm/boot/dts/at91sam9261ek.dts                |  211 ++++
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   12 +-
 arch/arm/boot/dts/at91sam9n12.dtsi                 |    1 +
 arch/arm/boot/dts/at91sam9rl.dtsi                  |  802 +++++++++++++++
 arch/arm/boot/dts/at91sam9rlek.dts                 |  157 +++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   14 +-
 arch/arm/boot/dts/atlas6.dtsi                      |    3 +-
 arch/arm/boot/dts/bcm11351.dtsi                    |  192 +++-
 .../dts/{bcm11351-brt.dts => bcm21664-garnet.dts}  |   12 +-
 arch/arm/boot/dts/bcm21664.dtsi                    |  292 ++++++
 arch/arm/boot/dts/bcm28155-ap.dts                  |   51 +-
 arch/arm/boot/dts/bcm2835.dtsi                     |   92 +-
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts        |   35 +
 arch/arm/boot/dts/bcm4708.dtsi                     |   34 +
 arch/arm/boot/dts/bcm5301x.dtsi                    |   95 ++
 arch/arm/boot/dts/bcm59056.dtsi                    |   74 ++
 arch/arm/boot/dts/dove.dtsi                        |   22 +-
 arch/arm/boot/dts/dra7.dtsi                        |  151 +++
 arch/arm/boot/dts/efm32gg-dk3750.dts               |    2 +-
 arch/arm/boot/dts/efm32gg.dtsi                     |    4 +-
 arch/arm/boot/dts/exynos4.dtsi                     |   78 +-
 arch/arm/boot/dts/exynos4210-origen.dts            |    2 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |    2 +-
 arch/arm/boot/dts/exynos4210-trats.dts             |    2 +-
 arch/arm/boot/dts/exynos4210-universal_c210.dts    |    2 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |   11 +-
 arch/arm/boot/dts/exynos4212.dtsi                  |   15 +-
 arch/arm/boot/dts/exynos4412-odroidx.dts           |    4 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |    6 +-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |    2 +-
 arch/arm/boot/dts/exynos4412-tiny4412.dts          |    2 +-
 arch/arm/boot/dts/exynos4412-trats2.dts            |   23 +-
 arch/arm/boot/dts/exynos4412.dtsi                  |   16 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |   60 +-
 arch/arm/boot/dts/exynos5.dtsi                     |    7 -
 arch/arm/boot/dts/exynos5250-arndale.dts           |   28 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  169 +++-
 arch/arm/boot/dts/exynos5250-snow.dts              |    6 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |  148 +--
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |  315 +++++-
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |  255 ++++-
 arch/arm/boot/dts/exynos5420.dtsi                  |  172 +++-
 arch/arm/boot/dts/exynos5440-sd5v1.dts             |    2 +-
 arch/arm/boot/dts/exynos5440-ssdk5440.dts          |    2 +-
 arch/arm/boot/dts/exynos5440.dtsi                  |   35 +-
 arch/arm/boot/dts/imx23-evk.dts                    |    8 +-
 arch/arm/boot/dts/imx23-olinuxino.dts              |    5 +-
 arch/arm/boot/dts/imx23-stmp378x_devb.dts          |    5 +-
 arch/arm/boot/dts/imx23.dtsi                       |    8 +-
 arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi       |   73 ++
 .../boot/dts/imx25-eukrea-mbimxsd25-baseboard.dts  |  174 ++++
 arch/arm/boot/dts/imx25-pinfunc.h                  |  494 ++++++++++
 arch/arm/boot/dts/imx25.dtsi                       |   18 +-
 arch/arm/boot/dts/imx27-apf27.dts                  |   38 +
 arch/arm/boot/dts/imx27-apf27dev.dts               |  149 ++-
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts   |   77 +-
 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dts   |   44 -
 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi  |  103 ++
 arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts     |  178 +++-
 ...ycore-som.dts => imx27-phytec-phycore-som.dtsi} |  133 ++-
 arch/arm/boot/dts/imx27-pinfunc.h                  |  526 ++++++++++
 arch/arm/boot/dts/imx27.dtsi                       |  207 ++--
 arch/arm/boot/dts/imx28-apf28dev.dts               |   29 +-
 arch/arm/boot/dts/imx28-apx4devkit.dts             |    5 +-
 arch/arm/boot/dts/imx28-cfa10036.dts               |    2 +
 arch/arm/boot/dts/imx28-cfa10037.dts               |    7 +-
 arch/arm/boot/dts/imx28-cfa10049.dts               |   31 +-
 arch/arm/boot/dts/imx28-cfa10057.dts               |    7 +-
 arch/arm/boot/dts/imx28-cfa10058.dts               |    7 +-
 arch/arm/boot/dts/imx28-duckbill.dts               |  121 +++
 arch/arm/boot/dts/imx28-eukrea-mbmx283lc.dts       |   71 ++
 arch/arm/boot/dts/imx28-eukrea-mbmx287lc.dts       |   50 +
 arch/arm/boot/dts/imx28-eukrea-mbmx28lc.dtsi       |  326 ++++++
 arch/arm/boot/dts/imx28-evk.dts                    |   24 +-
 arch/arm/boot/dts/imx28-m28cu3.dts                 |   17 +-
 arch/arm/boot/dts/imx28-m28evk.dts                 |   20 +-
 arch/arm/boot/dts/imx28-sps1.dts                   |    7 +-
 arch/arm/boot/dts/imx28-tx28.dts                   |   24 +-
 arch/arm/boot/dts/imx28.dtsi                       |   65 +-
 arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi       |   81 ++
 .../boot/dts/imx35-eukrea-mbimxsd35-baseboard.dts  |  143 +++
 arch/arm/boot/dts/imx35.dtsi                       |  359 +++++++
 arch/arm/boot/dts/imx50-evk.dts                    |  119 +++
 arch/arm/boot/dts/imx50-pinfunc.h                  |  923 +++++++++++++++++
 arch/arm/boot/dts/imx50.dtsi                       |  478 +++++++++
 arch/arm/boot/dts/imx51-apf51.dts                  |   40 +-
 arch/arm/boot/dts/imx51-apf51dev.dts               |  102 +-
 arch/arm/boot/dts/imx51-babbage.dts                |  255 ++++-
 arch/arm/boot/dts/imx51-eukrea-cpuimx51.dtsi       |   93 ++
 .../boot/dts/imx51-eukrea-mbimxsd51-baseboard.dts  |  175 ++++
 arch/arm/boot/dts/imx51.dtsi                       |  459 ++-------
 arch/arm/boot/dts/imx53-ard.dts                    |   33 +-
 arch/arm/boot/dts/imx53-evk.dts                    |  126 ---
 arch/arm/boot/dts/imx53-m53evk.dts                 |  232 ++++-
 arch/arm/boot/dts/imx53-mba53.dts                  |   39 +-
 arch/arm/boot/dts/imx53-qsb-common.dtsi            |  345 +++++++
 arch/arm/boot/dts/imx53-qsb.dts                    |  219 +----
 arch/arm/boot/dts/imx53-qsrb.dts                   |  158 +++
 arch/arm/boot/dts/imx53-smd.dts                    |  119 ++-
 arch/arm/boot/dts/imx53-tqma53.dtsi                |  175 +++-
 arch/arm/boot/dts/imx53-tx53-x03x.dts              |  315 ++++++
 arch/arm/boot/dts/imx53-tx53-x13x.dts              |  243 +++++
 arch/arm/boot/dts/imx53-tx53.dtsi                  |  510 +++++++++-
 arch/arm/boot/dts/imx53-voipac-bsb.dts             |  159 +++
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi        |  277 ++++++
 arch/arm/boot/dts/imx53.dtsi                       |  663 ++-----------
 arch/arm/boot/dts/imx6dl-dfi-fs700-m60.dts         |   23 +
 arch/arm/boot/dts/imx6dl-gw51xx.dts                |   19 +
 arch/arm/boot/dts/imx6dl-gw52xx.dts                |   19 +
 arch/arm/boot/dts/imx6dl-gw53xx.dts                |   19 +
 arch/arm/boot/dts/imx6dl-gw54xx.dts                |   19 +
 arch/arm/boot/dts/imx6dl-nitrogen6x.dts            |   21 +
 arch/arm/boot/dts/imx6dl-pinfunc.h                 |    2 +
 arch/arm/boot/dts/imx6dl-sabrelite.dts             |   20 +
 arch/arm/boot/dts/imx6dl.dtsi                      |   29 +-
 arch/arm/boot/dts/imx6q-arm2.dts                   |  140 ++-
 arch/arm/boot/dts/imx6q-cm-fx6.dts                 |  107 ++
 arch/arm/boot/dts/imx6q-dfi-fs700-m60.dts          |   23 +
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts            |  372 +++++++
 arch/arm/boot/dts/imx6q-gk802.dts                  |  171 ++++
 arch/arm/boot/dts/imx6q-gw51xx.dts                 |   19 +
 arch/arm/boot/dts/imx6q-gw52xx.dts                 |   23 +
 arch/arm/boot/dts/imx6q-gw53xx.dts                 |   23 +
 arch/arm/boot/dts/imx6q-gw5400-a.dts               |  546 +++++++++++
 arch/arm/boot/dts/imx6q-gw54xx.dts                 |   23 +
 arch/arm/boot/dts/imx6q-nitrogen6x.dts             |   25 +
 arch/arm/boot/dts/imx6q-phytec-pbab01.dts          |   16 +
 arch/arm/boot/dts/imx6q-phytec-pfla02.dtsi         |  167 +++-
 arch/arm/boot/dts/imx6q-pinfunc.h                  |    2 +
 arch/arm/boot/dts/imx6q-sabrelite.dts              |  178 +---
 arch/arm/boot/dts/imx6q-sbc6x.dts                  |   58 +-
 arch/arm/boot/dts/imx6q-udoo.dts                   |   54 +-
 arch/arm/boot/dts/imx6q.dtsi                       |   23 +-
 arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi       |  199 ++++
 arch/arm/boot/dts/imx6qdl-gw51xx.dtsi              |  374 +++++++
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi              |  490 ++++++++++
 arch/arm/boot/dts/imx6qdl-gw53xx.dtsi              |  553 +++++++++++
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi              |  580 +++++++++++
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi          |  422 ++++++++
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  378 ++++++-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |  423 ++++++++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  277 +++++-
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi           |  131 ++-
 arch/arm/boot/dts/imx6qdl.dtsi                     |  938 +++---------------
 arch/arm/boot/dts/imx6sl-evk.dts                   |  427 +++++++-
 arch/arm/boot/dts/imx6sl.dtsi                      |  385 +++-----
 arch/arm/boot/dts/integratorap.dts                 |   35 +
 arch/arm/boot/dts/integratorcp.dts                 |  102 +-
 arch/arm/boot/dts/k2e-clocks.dtsi                  |   78 ++
 arch/arm/boot/dts/k2e-evm.dts                      |   60 ++
 arch/arm/boot/dts/k2e.dtsi                         |   80 ++
 arch/arm/boot/dts/k2hk-clocks.dtsi                 |  426 ++++++++
 arch/arm/boot/dts/k2hk-evm.dts                     |   83 +-
 arch/arm/boot/dts/k2hk.dtsi                        |   46 +
 arch/arm/boot/dts/k2l-clocks.dtsi                  |  267 +++++
 arch/arm/boot/dts/k2l-evm.dts                      |   37 +
 arch/arm/boot/dts/k2l.dtsi                         |   55 ++
 arch/arm/boot/dts/keystone-clocks.dtsi             |  427 +-------
 arch/arm/boot/dts/keystone.dtsi                    |  102 +-
 arch/arm/boot/dts/kirkwood-b3.dts                  |  204 ++++
 arch/arm/boot/dts/kirkwood-ds109.dts               |   41 +
 arch/arm/boot/dts/kirkwood-ds110jv10.dts           |   41 +
 arch/arm/boot/dts/kirkwood-ds111.dts               |   44 +
 arch/arm/boot/dts/kirkwood-ds112.dts               |   48 +
 arch/arm/boot/dts/kirkwood-ds209.dts               |   44 +
 arch/arm/boot/dts/kirkwood-ds210.dts               |   46 +
 arch/arm/boot/dts/kirkwood-ds212.dts               |   47 +
 arch/arm/boot/dts/kirkwood-ds212j.dts              |   41 +
 arch/arm/boot/dts/kirkwood-ds409.dts               |   48 +
 arch/arm/boot/dts/kirkwood-ds409slim.dts           |   40 +
 arch/arm/boot/dts/kirkwood-ds411.dts               |   52 +
 arch/arm/boot/dts/kirkwood-ds411j.dts              |   48 +
 arch/arm/boot/dts/kirkwood-ds411slim.dts           |   48 +
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts     |   62 ++
 arch/arm/boot/dts/kirkwood-rd88f6192.dts           |  112 +++
 arch/arm/boot/dts/kirkwood-rd88f6281-a0.dts        |   26 +
 arch/arm/boot/dts/kirkwood-rd88f6281-a1.dts        |   31 +
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi          |  152 +++
 arch/arm/boot/dts/kirkwood-rs212.dts               |   48 +
 arch/arm/boot/dts/kirkwood-rs409.dts               |   44 +
 arch/arm/boot/dts/kirkwood-rs411.dts               |   44 +
 arch/arm/boot/dts/kirkwood-synology.dtsi           |  871 +++++++++++++++++
 arch/arm/boot/dts/kirkwood-t5325.dts               |  208 ++++
 arch/arm/boot/dts/kirkwood-ts419-6281.dts          |   20 +
 arch/arm/boot/dts/kirkwood-ts419-6282.dts          |   32 +
 arch/arm/boot/dts/kirkwood-ts419.dtsi              |   75 ++
 arch/arm/boot/dts/kirkwood.dtsi                    |   24 +-
 arch/arm/boot/dts/marco.dtsi                       |    3 +-
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi          |   58 ++
 arch/arm/boot/dts/omap2420.dtsi                    |    2 +
 arch/arm/boot/dts/omap2430.dtsi                    |    5 +
 arch/arm/boot/dts/omap3-beagle-xm.dts              |    4 +
 arch/arm/boot/dts/omap3-beagle.dts                 |    4 +
 arch/arm/boot/dts/omap3-cm-t3517.dts               |  136 +++
 arch/arm/boot/dts/omap3-cm-t3530.dts               |   48 +
 arch/arm/boot/dts/omap3-cm-t3730.dts               |   57 +-
 arch/arm/boot/dts/omap3-cm-t3x.dtsi                |  110 +++
 arch/arm/boot/dts/omap3-cm-t3x30.dtsi              |   74 +-
 arch/arm/boot/dts/omap3-devkit8000.dts             |   16 +-
 arch/arm/boot/dts/omap3-gta04.dts                  |   51 +-
 arch/arm/boot/dts/omap3-igep.dtsi                  |    1 +
 arch/arm/boot/dts/omap3-lilly-a83x.dtsi            |  459 +++++++++
 arch/arm/boot/dts/omap3-lilly-dbb056.dts           |  170 ++++
 arch/arm/boot/dts/omap3-n900.dts                   |   90 ++
 arch/arm/boot/dts/omap3-overo-alto35-common.dtsi   |   77 ++
 arch/arm/boot/dts/omap3-overo-alto35.dts           |   22 +
 arch/arm/boot/dts/omap3-overo-base.dtsi            |  221 +++++
 .../boot/dts/omap3-overo-chestnut43-common.dtsi    |   69 ++
 arch/arm/boot/dts/omap3-overo-chestnut43.dts       |   38 +
 .../boot/dts/omap3-overo-common-peripherals.dtsi   |   94 ++
 arch/arm/boot/dts/omap3-overo-gallop43-common.dtsi |   57 ++
 arch/arm/boot/dts/omap3-overo-gallop43.dts         |   38 +
 arch/arm/boot/dts/omap3-overo-palo43-common.dtsi   |   53 +
 arch/arm/boot/dts/omap3-overo-palo43.dts           |   38 +
 arch/arm/boot/dts/omap3-overo-storm-alto35.dts     |   21 +
 arch/arm/boot/dts/omap3-overo-storm-chestnut43.dts |   38 +
 arch/arm/boot/dts/omap3-overo-storm-gallop43.dts   |   38 +
 arch/arm/boot/dts/omap3-overo-storm-palo43.dts     |   38 +
 arch/arm/boot/dts/omap3-overo-storm-summit.dts     |   30 +
 arch/arm/boot/dts/omap3-overo-storm-tobi.dts       |    2 +-
 arch/arm/boot/dts/omap3-overo-storm.dtsi           |   35 +
 arch/arm/boot/dts/omap3-overo-summit-common.dtsi   |   31 +
 arch/arm/boot/dts/omap3-overo-summit.dts           |   30 +
 arch/arm/boot/dts/omap3-overo-tobi-common.dtsi     |   51 +-
 arch/arm/boot/dts/omap3-overo-tobi.dts             |    2 +-
 arch/arm/boot/dts/omap3-overo.dtsi                 |   98 +-
 arch/arm/boot/dts/omap3-sb-t35.dtsi                |   29 +-
 arch/arm/boot/dts/omap3-sbc-t3517.dts              |   43 +
 arch/arm/boot/dts/omap3-sbc-t3530.dts              |   36 +
 arch/arm/boot/dts/omap3-sbc-t3730.dts              |   23 +-
 arch/arm/boot/dts/omap3.dtsi                       |   29 +-
 arch/arm/boot/dts/omap3430-sdp.dts                 |    7 +-
 arch/arm/boot/dts/omap3430es1-clocks.dtsi          |   10 +-
 .../boot/dts/omap36xx-omap3430es2plus-clocks.dtsi  |   10 +-
 arch/arm/boot/dts/omap36xx.dtsi                    |   20 +
 arch/arm/boot/dts/omap4-duovero-parlor.dts         |  146 +++
 arch/arm/boot/dts/omap4-duovero.dtsi               |  252 +++++
 arch/arm/boot/dts/omap4-panda-common.dtsi          |   31 +-
 arch/arm/boot/dts/omap4-sdp.dts                    |   33 +-
 arch/arm/boot/dts/omap4.dtsi                       |   66 +-
 arch/arm/boot/dts/omap443x.dtsi                    |   26 +
 arch/arm/boot/dts/omap4460.dtsi                    |   37 +
 arch/arm/boot/dts/omap5-uevm.dts                   |    8 +-
 arch/arm/boot/dts/omap5.dtsi                       |   45 +-
 arch/arm/boot/dts/prima2.dtsi                      |    3 +-
 arch/arm/boot/dts/qcom-msm8660-surf.dts            |   59 +-
 arch/arm/boot/dts/qcom-msm8660.dtsi                |   87 ++
 arch/arm/boot/dts/qcom-msm8960-cdp.dts             |   66 +-
 arch/arm/boot/dts/qcom-msm8960.dtsi                |  135 +++
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   81 ++
 arch/arm/boot/dts/r7s72100-genmai-reference.dts    |   13 +-
 arch/arm/boot/dts/r7s72100.dtsi                    |  147 +++
 arch/arm/boot/dts/r8a7778-bockw-reference.dts      |    4 +-
 arch/arm/boot/dts/r8a7778.dtsi                     |   40 -
 arch/arm/boot/dts/r8a7790-lager.dts                |  153 ++-
 arch/arm/boot/dts/r8a7790.dtsi                     |  192 +++-
 arch/arm/boot/dts/r8a7791-koelsch-reference.dts    |  115 ---
 arch/arm/boot/dts/r8a7791-koelsch.dts              |  274 +++++-
 arch/arm/boot/dts/r8a7791.dtsi                     |  323 +++++-
 arch/arm/boot/dts/rk3066a.dtsi                     |   13 +
 arch/arm/boot/dts/rk3188.dtsi                      |   13 +
 arch/arm/boot/dts/rk3xxx.dtsi                      |   10 +
 arch/arm/boot/dts/sama5d3.dtsi                     |   28 +-
 arch/arm/boot/dts/sama5d3xdm.dtsi                  |    6 +-
 arch/arm/boot/dts/socfpga.dtsi                     |   40 +-
 arch/arm/boot/dts/socfpga_arria5.dtsi              |   11 +
 arch/arm/boot/dts/socfpga_arria5_socdk.dts         |   21 +
 arch/arm/boot/dts/socfpga_cyclone5.dtsi            |   11 +
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts       |   14 +
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts      |   17 +
 arch/arm/boot/dts/socfpga_vt.dts                   |   16 +
 arch/arm/boot/dts/ste-dbx5x0.dtsi                  |   12 +-
 arch/arm/boot/dts/ste-href-ab8500.dtsi             |  428 ++++++++
 arch/arm/boot/dts/ste-href-ab8505.dtsi             |  240 +++++
 arch/arm/boot/dts/ste-hrefprev60.dtsi              |    1 +
 arch/arm/boot/dts/ste-hrefv60plus.dtsi             |    1 +
 arch/arm/boot/dts/ste-snowball.dts                 |    1 +
 arch/arm/boot/dts/ste-u300.dts                     |    2 +-
 arch/arm/boot/dts/stih415-clock.dtsi               |   14 +
 arch/arm/boot/dts/stih415-pinctrl.dtsi             |  204 ++++
 arch/arm/boot/dts/stih415.dtsi                     |   70 ++
 arch/arm/boot/dts/stih416-clock.dtsi               |   14 +
 arch/arm/boot/dts/stih416-pinctrl.dtsi             |  210 ++++
 arch/arm/boot/dts/stih416.dtsi                     |   79 ++
 arch/arm/boot/dts/stih41x-b2000.dtsi               |   22 +
 arch/arm/boot/dts/stih41x-b2020.dtsi               |   14 +
 arch/arm/boot/dts/stih41x-b2020x.dtsi              |   28 +
 arch/arm/boot/dts/sun4i-a10-a1000.dts              |   55 +-
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts         |   40 +
 arch/arm/boot/dts/sun4i-a10-hackberry.dts          |   56 +-
 arch/arm/boot/dts/sun4i-a10-inet97fv2.dts          |   69 ++
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts         |   31 +
 arch/arm/boot/dts/sun4i-a10-olinuxino-lime.dts     |  111 +++
 arch/arm/boot/dts/sun4i-a10-pcduino.dts            |   79 ++
 arch/arm/boot/dts/sun4i-a10.dtsi                   |  211 +++-
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts   |   27 +
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |  158 ++-
 arch/arm/boot/dts/sun5i-a13-olinuxino-micro.dts    |   27 +
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts          |   27 +
 arch/arm/boot/dts/sun5i-a13.dtsi                   |  159 ++-
 arch/arm/boot/dts/sun6i-a31-colombus.dts           |   18 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  188 +++-
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts        |   53 +-
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |   61 ++
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts    |   68 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  302 +++++-
 arch/arm/boot/dts/sunxi-common-regulators.dtsi     |   75 ++
 arch/arm/boot/dts/tegra114-dalmore.dts             |    9 +-
 arch/arm/boot/dts/tegra114.dtsi                    |    8 +-
 arch/arm/boot/dts/tegra124-venice2.dts             |  312 +++---
 arch/arm/boot/dts/tegra124.dtsi                    |  339 +++++--
 arch/arm/boot/dts/tegra20-paz00.dts                |   46 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |   55 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |   39 +-
 arch/arm/boot/dts/tegra20.dtsi                     |    4 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |    7 +
 arch/arm/boot/dts/tegra30.dtsi                     |    6 +-
 arch/arm/boot/dts/tps65910.dtsi                    |    5 +
 arch/arm/boot/dts/twl4030.dtsi                     |    7 +
 arch/arm/boot/dts/vf610-cosmic.dts                 |   29 +-
 arch/arm/boot/dts/vf610-twr.dts                    |  158 ++-
 arch/arm/boot/dts/vf610.dtsi                       |  273 ++----
 arch/arm/boot/dts/zynq-7000.dtsi                   |   43 +-
 arch/arm/common/timer-sp.c                         |    8 +-
 arch/arm/configs/ape6evm_defconfig                 |    2 +
 arch/arm/configs/armadillo800eva_defconfig         |    2 +
 arch/arm/configs/at91_dt_defconfig                 |    3 +
 arch/arm/configs/at91sam9260_9g20_defconfig        |    9 +-
 arch/arm/configs/at91sam9rl_defconfig              |   10 +-
 arch/arm/configs/bcm2835_defconfig                 |    1 +
 arch/arm/configs/bcm_defconfig                     |    7 +
 arch/arm/configs/bockw_defconfig                   |    2 +
 arch/arm/configs/clps711x_defconfig                |    3 +-
 arch/arm/configs/da8xx_omapl_defconfig             |  139 ---
 arch/arm/configs/davinci_all_defconfig             |   25 +
 arch/arm/configs/dove_defconfig                    |    3 +-
 arch/arm/configs/exynos_defconfig                  |    2 +-
 arch/arm/configs/genmai_defconfig                  |    8 +-
 arch/arm/configs/imx_v4_v5_defconfig               |    1 +
 arch/arm/configs/imx_v6_v7_defconfig               |    7 +
 arch/arm/configs/keystone_defconfig                |   15 +
 arch/arm/configs/koelsch_defconfig                 |   21 +-
 arch/arm/configs/kzm9d_defconfig                   |   89 --
 arch/arm/configs/kzm9g_defconfig                   |    2 +
 arch/arm/configs/lager_defconfig                   |   21 +
 arch/arm/configs/mackerel_defconfig                |    2 +
 arch/arm/configs/marzen_defconfig                  |    2 +
 arch/arm/configs/multi_v5_defconfig                |  190 ++++
 arch/arm/configs/multi_v7_defconfig                |   25 +
 arch/arm/configs/mvebu_v5_defconfig                |  181 ++++
 .../{mvebu_defconfig => mvebu_v7_defconfig}        |   10 +
 arch/arm/configs/omap2plus_defconfig               |    1 +
 arch/arm/configs/shmobile_defconfig                |  129 +++
 arch/arm/configs/socfpga_defconfig                 |    6 +
 arch/arm/configs/sunxi_defconfig                   |    3 +
 arch/arm/configs/tegra_defconfig                   |    7 +-
 arch/arm/firmware/Kconfig                          |    3 +-
 arch/arm/firmware/trusted_foundations.c            |   20 +-
 arch/arm/include/asm/firmware.h                    |    4 +
 .../asm/hardware}/cache-feroceon-l2.h              |    4 +-
 arch/arm/include/asm/smp.h                         |   10 +
 arch/arm/include/asm/timex.h                       |    6 -
 arch/arm/include/asm/trusted_foundations.h         |   13 +-
 arch/arm/include/debug/samsung.S                   |    2 +-
 arch/arm/include/debug/tegra.S                     |   18 +-
 arch/arm/include/debug/zynq.S                      |    3 +
 arch/arm/kernel/devtree.c                          |   40 +
 arch/arm/mach-at91/Kconfig                         |   25 +-
 arch/arm/mach-at91/Kconfig.non_dt                  |    8 +-
 arch/arm/mach-at91/at91rm9200.c                    |    1 +
 arch/arm/mach-at91/at91rm9200_devices.c            |   11 +-
 arch/arm/mach-at91/at91rm9200_time.c               |    1 +
 arch/arm/mach-at91/at91sam9260.c                   |    1 +
 arch/arm/mach-at91/at91sam9260_devices.c           |   14 +-
 arch/arm/mach-at91/at91sam9261.c                   |   26 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |    5 +
 arch/arm/mach-at91/at91sam9263.c                   |    2 +
 arch/arm/mach-at91/at91sam9263_devices.c           |    5 +
 arch/arm/mach-at91/at91sam926x_time.c              |    1 +
 arch/arm/mach-at91/at91sam9g45.c                   |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |    6 +
 arch/arm/mach-at91/at91sam9n12.c                   |    1 +
 arch/arm/mach-at91/at91sam9rl.c                    |   25 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    6 +
 arch/arm/mach-at91/at91sam9x5.c                    |    1 +
 arch/arm/mach-at91/at91x40.c                       |    2 +-
 arch/arm/mach-at91/at91x40_time.c                  |    1 +
 arch/arm/mach-at91/board-dt-sam9.c                 |   11 +-
 arch/arm/mach-at91/board-gsia18s.c                 |    1 +
 arch/arm/mach-at91/board-pcontrol-g20.c            |    1 +
 arch/arm/mach-at91/board-stamp9g20.c               |    1 +
 arch/arm/mach-at91/include/mach/at91x40.h          |    2 +
 arch/arm/mach-at91/include/mach/timex.h            |   37 -
 arch/arm/mach-at91/pm.c                            |    1 +
 arch/arm/mach-at91/sam9_smc.c                      |    3 +
 arch/arm/mach-at91/setup.c                         |    2 +-
 arch/arm/mach-bcm/Kconfig                          |   47 +-
 arch/arm/mach-bcm/Makefile                         |    8 +-
 arch/arm/mach-bcm/bcm_5301x.c                      |   61 ++
 arch/arm/mach-bcm/board_bcm21664.c                 |   78 ++
 arch/arm/mach-bcm/board_bcm281xx.c                 |   83 +-
 .../bcm2835.c => mach-bcm/board_bcm2835.c}         |    0
 arch/arm/mach-bcm/kona.c                           |   64 +-
 arch/arm/mach-bcm/kona.h                           |    7 +-
 arch/arm/mach-bcm2835/Kconfig                      |   15 -
 arch/arm/mach-bcm2835/Makefile                     |    1 -
 arch/arm/mach-berlin/Kconfig                       |    4 -
 arch/arm/mach-clps711x/Kconfig                     |   14 -
 arch/arm/mach-clps711x/board-autcpu12.c            |    4 +-
 arch/arm/mach-clps711x/board-cdb89712.c            |    2 -
 arch/arm/mach-clps711x/board-clep7312.c            |    2 -
 arch/arm/mach-clps711x/board-edb7211.c             |    2 -
 arch/arm/mach-clps711x/board-p720t.c               |    2 -
 arch/arm/mach-clps711x/common.c                    |  201 +---
 arch/arm/mach-clps711x/common.h                    |    5 +-
 arch/arm/mach-clps711x/include/mach/clps711x.h     |   16 -
 arch/arm/mach-clps711x/include/mach/hardware.h     |   17 -
 arch/arm/mach-clps711x/include/mach/timex.h        |    2 -
 arch/arm/mach-cns3xxx/Kconfig                      |    3 -
 arch/arm/mach-cns3xxx/cns3420vb.c                  |    1 -
 arch/arm/mach-cns3xxx/core.c                       |   33 +-
 arch/arm/mach-cns3xxx/pcie.c                       |  105 +-
 arch/arm/mach-davinci/Kconfig                      |   17 -
 arch/arm/mach-davinci/Makefile                     |    2 -
 arch/arm/mach-davinci/Makefile.boot                |   20 +-
 arch/arm/mach-davinci/aemif.c                      |  107 +-
 arch/arm/mach-davinci/board-da830-evm.c            |    3 +
 arch/arm/mach-davinci/board-da850-evm.c            |    3 +
 arch/arm/mach-davinci/board-dm644x-evm.c           |   16 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |    3 +
 arch/arm/mach-davinci/board-mityomapl138.c         |    4 +
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |  287 ------
 arch/arm/mach-davinci/davinci.h                    |    2 +
 arch/arm/mach-davinci/devices-tnetv107x.c          |  434 --------
 arch/arm/mach-davinci/devices.c                    |   17 +-
 arch/arm/mach-davinci/dm355.c                      |    8 +-
 arch/arm/mach-davinci/dm365.c                      |    8 +-
 arch/arm/mach-davinci/dm644x.c                     |    8 +-
 arch/arm/mach-davinci/dm646x.c                     |    8 +-
 arch/arm/mach-davinci/include/mach/cputype.h       |    8 -
 arch/arm/mach-davinci/include/mach/irqs.h          |   97 --
 arch/arm/mach-davinci/include/mach/mux.h           |  269 -----
 arch/arm/mach-davinci/include/mach/psc.h           |   47 -
 arch/arm/mach-davinci/include/mach/serial.h        |    8 -
 arch/arm/mach-davinci/include/mach/timex.h         |   22 -
 arch/arm/mach-davinci/include/mach/tnetv107x.h     |   61 --
 arch/arm/mach-davinci/include/mach/uncompress.h    |    6 -
 arch/arm/mach-davinci/tnetv107x.c                  |  766 ---------------
 arch/arm/mach-dove/Kconfig                         |   12 -
 arch/arm/mach-dove/Makefile                        |    1 -
 arch/arm/mach-dove/include/mach/bridge-regs.h      |    1 +
 arch/arm/mach-dove/include/mach/timex.h            |    9 -
 arch/arm/mach-ebsa110/include/mach/timex.h         |   19 -
 arch/arm/mach-efm32/include/mach/entry-macro.S     |    4 -
 arch/arm/mach-efm32/include/mach/timex.h           |    3 -
 arch/arm/mach-ep93xx/core.c                        |    3 +-
 arch/arm/mach-ep93xx/include/mach/timex.h          |    5 -
 arch/arm/mach-exynos/Kconfig                       |   16 +-
 arch/arm/mach-exynos/Makefile                      |    9 +-
 arch/arm/mach-exynos/common.h                      |   17 +-
 arch/arm/mach-exynos/cpuidle.c                     |    4 +-
 arch/arm/mach-exynos/{common.c => exynos.c}        |  237 +++--
 arch/arm/mach-exynos/include/mach/hardware.h       |   18 -
 arch/arm/mach-exynos/include/mach/pm-core.h        |   75 --
 arch/arm/mach-exynos/include/mach/timex.h          |   29 -
 arch/arm/mach-exynos/include/mach/uncompress.h     |   48 -
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   59 --
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   81 --
 arch/arm/mach-exynos/mfc.h                         |   16 +
 arch/arm/mach-exynos/platsmp.c                     |    2 -
 arch/arm/mach-exynos/pm.c                          |  316 +++---
 arch/arm/mach-exynos/pm_domains.c                  |    2 -
 arch/arm/mach-exynos/regs-pmu.h                    |    3 +-
 arch/arm/mach-exynos/sleep.S                       |   85 ++
 arch/arm/mach-footbridge/Kconfig                   |    2 +-
 arch/arm/mach-footbridge/Makefile                  |    3 +-
 arch/arm/mach-footbridge/cats-hw.c                 |    2 +
 arch/arm/mach-footbridge/include/mach/timex.h      |   18 -
 arch/arm/mach-gemini/include/mach/timex.h          |   13 -
 arch/arm/mach-highbank/Kconfig                     |    7 -
 arch/arm/mach-hisi/Kconfig                         |    6 +-
 arch/arm/mach-hisi/Makefile                        |    3 +-
 arch/arm/mach-hisi/hotplug.c                       |    2 +
 arch/arm/mach-imx/Kconfig                          |   57 +-
 arch/arm/mach-imx/Makefile                         |    9 +-
 arch/arm/mach-imx/clk-imx21.c                      |    1 -
 arch/arm/mach-imx/clk-imx25.c                      |    8 -
 arch/arm/mach-imx/clk-imx27.c                      |    1 -
 arch/arm/mach-imx/clk-imx51-imx53.c                |    2 -
 arch/arm/mach-imx/clk-imx6q.c                      |    7 +-
 arch/arm/mach-imx/clk-imx6sl.c                     |  159 ++-
 arch/arm/mach-imx/clk-vf610.c                      |   36 +-
 arch/arm/mach-imx/common.h                         |   17 +-
 arch/arm/mach-imx/cpuidle-imx6q.c                  |    4 +-
 arch/arm/mach-imx/cpuidle-imx6sl.c                 |   57 ++
 arch/arm/mach-imx/cpuidle.h                        |    5 +
 arch/arm/mach-imx/devices-imx25.h                  |    4 -
 arch/arm/mach-imx/devices-imx51.h                  |    4 -
 arch/arm/mach-imx/devices/Kconfig                  |    3 -
 arch/arm/mach-imx/devices/Makefile                 |    1 -
 arch/arm/mach-imx/devices/devices-common.h         |    9 -
 arch/arm/mach-imx/devices/platform-mxc_pwm.c       |   69 --
 arch/arm/mach-imx/hardware.h                       |    4 +-
 arch/arm/mach-imx/headsmp.S                        |   40 -
 arch/arm/mach-imx/mach-imx6q.c                     |   98 +-
 arch/arm/mach-imx/mach-imx6sl.c                    |    6 +-
 arch/arm/mach-imx/pm-imx6.c                        |  551 +++++++++++
 arch/arm/mach-imx/pm-imx6q.c                       |  240 -----
 arch/arm/mach-imx/suspend-imx6.S                   |  361 +++++++
 arch/arm/mach-imx/time.c                           |   12 +
 arch/arm/mach-integrator/Kconfig                   |   11 +-
 arch/arm/mach-integrator/core.c                    |    4 +-
 .../{include/mach/platform.h => hardware.h}        |  110 +--
 arch/arm/mach-integrator/impd1.c                   |   85 +-
 .../arm/mach-integrator/{include/mach => }/impd1.h |    4 -
 arch/arm/mach-integrator/include/mach/hardware.h   |   45 -
 arch/arm/mach-integrator/include/mach/timex.h      |   26 -
 arch/arm/mach-integrator/integrator_ap.c           |   25 +-
 arch/arm/mach-integrator/integrator_cp.c           |   23 +-
 arch/arm/mach-integrator/leds.c                    |    4 +-
 arch/arm/mach-integrator/lm.c                      |    2 +-
 arch/arm/mach-integrator/{include/mach => }/lm.h   |    0
 arch/arm/mach-integrator/pci_v3.c                  |    4 +-
 arch/arm/mach-iop13xx/include/mach/timex.h         |    1 -
 arch/arm/mach-iop32x/include/mach/timex.h          |    6 -
 arch/arm/mach-iop33x/include/mach/timex.h          |    6 -
 arch/arm/mach-ixp4xx/common-pci.c                  |   39 -
 arch/arm/mach-ixp4xx/common.c                      |   75 +-
 arch/arm/mach-ixp4xx/goramo_mlr.c                  |   43 +-
 arch/arm/mach-ixp4xx/include/mach/io.h             |    3 +-
 arch/arm/mach-ixp4xx/include/mach/timex.h          |   16 -
 arch/arm/mach-ixp4xx/omixp-setup.c                 |    2 -
 arch/arm/mach-keystone/Kconfig                     |    4 -
 arch/arm/mach-keystone/keystone.c                  |    2 +-
 arch/arm/mach-kirkwood/Kconfig                     |    7 -
 arch/arm/mach-kirkwood/Makefile                    |    4 +-
 arch/arm/mach-kirkwood/board-dt.c                  |  113 ++-
 arch/arm/mach-kirkwood/board-mv88f6281gtw_ge.c     |   50 -
 arch/arm/mach-kirkwood/common.c                    |    3 +-
 arch/arm/mach-kirkwood/common.h                    |   13 -
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h  |    3 +
 arch/arm/mach-kirkwood/include/mach/timex.h        |   10 -
 arch/arm/mach-kirkwood/pm.c                        |    9 +-
 arch/arm/mach-kirkwood/pm.h                        |   26 +
 arch/arm/mach-ks8695/board-og.c                    |    3 +-
 arch/arm/mach-ks8695/include/mach/timex.h          |   21 -
 arch/arm/mach-lpc32xx/common.c                     |    1 +
 arch/arm/mach-mmp/aspenite.c                       |    4 +-
 arch/arm/mach-mmp/devices.c                        |   14 +-
 arch/arm/mach-mmp/time.c                           |   12 +-
 arch/arm/mach-mmp/ttc_dkb.c                        |   18 +-
 arch/arm/mach-moxart/Kconfig                       |    7 +-
 arch/arm/mach-msm/Kconfig                          |   54 +-
 arch/arm/mach-msm/Makefile                         |    8 -
 arch/arm/mach-msm/common.h                         |    3 -
 arch/arm/mach-msm/dma.c                            |    3 +
 arch/arm/mach-msm/headsmp.S                        |   39 -
 arch/arm/mach-msm/hotplug.c                        |   74 --
 arch/arm/mach-msm/include/mach/timex.h             |   21 -
 arch/arm/mach-msm/io.c                             |    2 +
 arch/arm/mach-msm/platsmp.c                        |  161 ---
 arch/arm/mach-mv78xx0/common.c                     |    2 +-
 arch/arm/mach-mv78xx0/include/mach/bridge-regs.h   |    1 +
 arch/arm/mach-mv78xx0/include/mach/timex.h         |    9 -
 arch/arm/mach-mvebu/Kconfig                        |   85 +-
 arch/arm/mach-mvebu/Makefile                       |    5 +-
 arch/arm/mach-mvebu/board-t5325.c                  |   41 +
 .../arm/mach-mvebu/{armada-370-xp.c => board-v7.c} |   59 +-
 arch/arm/mach-mvebu/board.h                        |   22 +
 .../{mach-dove/board-dt.c => mach-mvebu/dove.c}    |   20 +-
 arch/arm/mach-mvebu/kirkwood-pm.c                  |   76 ++
 arch/arm/mach-mvebu/kirkwood-pm.h                  |   26 +
 arch/arm/mach-mvebu/kirkwood.c                     |  199 ++++
 arch/arm/mach-mvebu/kirkwood.h                     |   22 +
 arch/arm/mach-mvebu/mvebu-soc-id.c                 |    1 +
 arch/arm/mach-mvebu/system-controller.c            |   23 +-
 arch/arm/mach-mxs/Kconfig                          |    4 -
 arch/arm/mach-mxs/mach-mxs.c                       |   33 +
 arch/arm/mach-netx/include/mach/timex.h            |   20 -
 arch/arm/mach-netx/time.c                          |   11 +-
 arch/arm/mach-nomadik/Kconfig                      |    5 -
 arch/arm/mach-nspire/Kconfig                       |    5 -
 arch/arm/mach-nspire/nspire.c                      |    2 +-
 arch/arm/mach-omap1/board-h2.c                     |    3 +
 arch/arm/mach-omap1/board-osk.c                    |    3 +
 arch/arm/mach-omap1/include/mach/timex.h           |    5 -
 arch/arm/mach-omap1/pm.c                           |    6 +-
 arch/arm/mach-omap2/Kconfig                        |   25 +-
 arch/arm/mach-omap2/Makefile                       |    1 +
 arch/arm/mach-omap2/board-generic.c                |    3 +-
 arch/arm/mach-omap2/clkt_dpll.c                    |    6 +-
 arch/arm/mach-omap2/clockdomains3xxx_data.c        |    2 +-
 arch/arm/mach-omap2/cminst44xx.c                   |   18 +-
 arch/arm/mach-omap2/devices.c                      |    3 +
 arch/arm/mach-omap2/dpll3xxx.c                     |    2 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |   31 +-
 arch/arm/mach-omap2/id.c                           |   16 +-
 arch/arm/mach-omap2/include/mach/timex.h           |    5 -
 arch/arm/mach-omap2/io.c                           |    1 +
 arch/arm/mach-omap2/irq.c                          |    8 +
 arch/arm/mach-omap2/mux.h                          |    3 -
 arch/arm/mach-omap2/omap-wakeupgen.c               |    4 +-
 arch/arm/mach-omap2/omap4-common.c                 |    4 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   12 +-
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c         |    1 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    3 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |   83 ++
 arch/arm/mach-omap2/pdata-quirks.c                 |  117 ++-
 arch/arm/mach-omap2/pm.h                           |    2 +-
 arch/arm/mach-omap2/prminst44xx.c                  |    3 +
 arch/arm/mach-omap2/soc.h                          |    3 +-
 arch/arm/mach-omap2/timer.c                        |    3 +-
 arch/arm/mach-orion5x/Kconfig                      |    1 -
 arch/arm/mach-orion5x/dns323-setup.c               |    2 +
 arch/arm/mach-orion5x/include/mach/bridge-regs.h   |    1 +
 arch/arm/mach-orion5x/include/mach/timex.h         |   11 -
 arch/arm/mach-picoxcell/Kconfig                    |    5 -
 arch/arm/mach-prima2/Kconfig                       |    7 +-
 arch/arm/mach-prima2/common.c                      |   11 +-
 arch/arm/mach-prima2/common.h                      |    1 -
 arch/arm/mach-prima2/l2x0.c                        |    9 +-
 arch/arm/mach-prima2/platsmp.c                     |    6 +-
 arch/arm/mach-prima2/rstc.c                        |   99 +-
 arch/arm/mach-prima2/rtciobrg.c                    |    2 +-
 arch/arm/mach-pxa/Kconfig                          |    9 +-
 arch/arm/mach-pxa/balloon3.c                       |    1 -
 arch/arm/mach-pxa/colibri-evalboard.c              |    1 +
 arch/arm/mach-pxa/corgi.c                          |   40 +
 arch/arm/mach-pxa/include/mach/timex.h             |   34 -
 arch/arm/mach-qcom/Kconfig                         |   33 +
 arch/arm/mach-qcom/Makefile                        |    5 +
 .../arm/{mach-msm/board-dt.c => mach-qcom/board.c} |   23 +-
 arch/arm/mach-qcom/platsmp.c                       |  378 +++++++
 arch/arm/{mach-msm => mach-qcom}/scm-boot.c        |    0
 arch/arm/{mach-msm => mach-qcom}/scm-boot.h        |    8 +-
 arch/arm/{mach-msm => mach-qcom}/scm.c             |    0
 arch/arm/{mach-msm => mach-qcom}/scm.h             |    0
 arch/arm/mach-realview/include/mach/memory.h       |    2 +
 arch/arm/mach-realview/include/mach/timex.h        |   23 -
 arch/arm/mach-rockchip/Kconfig                     |    4 +-
 arch/arm/mach-rockchip/Makefile                    |    1 +
 .../include/mach/timex.h => mach-rockchip/core.h}  |   20 +-
 .../mach/timex.h => mach-rockchip/headsmp.S}       |   27 +-
 arch/arm/mach-rockchip/platsmp.c                   |  184 ++++
 arch/arm/mach-rockchip/rockchip.c                  |    2 +
 arch/arm/mach-rpc/include/mach/timex.h             |   17 -
 arch/arm/mach-rpc/time.c                           |   15 +-
 arch/arm/mach-s3c24xx/Kconfig                      |    6 +-
 arch/arm/mach-s3c24xx/clock-s3c2410.c              |    3 +-
 arch/arm/mach-s3c24xx/clock-s3c2412.c              |    3 +-
 arch/arm/mach-s3c24xx/clock-s3c2440.c              |    2 +-
 arch/arm/mach-s3c24xx/common.c                     |    5 +-
 arch/arm/mach-s3c24xx/dma-s3c2410.c                |    2 +-
 arch/arm/mach-s3c24xx/dma-s3c2412.c                |    2 +-
 arch/arm/mach-s3c24xx/dma-s3c2440.c                |    2 +-
 arch/arm/mach-s3c24xx/dma-s3c2443.c                |    2 +-
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S   |    2 +-
 arch/arm/mach-s3c24xx/include/mach/hardware.h      |   14 +-
 .../plat => mach-s3c24xx/include/mach}/rtc-core.h  |   13 +-
 arch/arm/mach-s3c24xx/include/mach/tick.h          |   15 -
 arch/arm/mach-s3c24xx/include/mach/timex.h         |   24 -
 arch/arm/mach-s3c24xx/include/mach/uncompress.h    |   57 --
 arch/arm/mach-s3c24xx/mach-amlm5900.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-anubis.c                |    2 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |    2 +-
 arch/arm/mach-s3c24xx/mach-bast.c                  |    2 +-
 arch/arm/mach-s3c24xx/mach-gta02.c                 |    4 +-
 arch/arm/mach-s3c24xx/mach-h1940.c                 |    2 +-
 arch/arm/mach-s3c24xx/mach-jive.c                  |    2 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-n30.c                   |    2 +-
 arch/arm/mach-s3c24xx/mach-nexcoder.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-osiris.c                |    2 +-
 arch/arm/mach-s3c24xx/mach-otom.c                  |    2 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c                |    2 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c                |    2 +-
 arch/arm/mach-s3c24xx/mach-rx3715.c                |    2 +-
 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2440.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c                |    2 +-
 arch/arm/mach-s3c24xx/mach-vstms.c                 |    2 +-
 arch/arm/mach-s3c24xx/pm.c                         |    2 +-
 arch/arm/mach-s3c24xx/s3c2410.c                    |    2 +-
 arch/arm/mach-s3c24xx/s3c2412.c                    |    2 +-
 arch/arm/mach-s3c24xx/s3c2416.c                    |    2 +-
 arch/arm/mach-s3c24xx/s3c2443.c                    |    2 +-
 arch/arm/mach-s3c24xx/s3c244x.c                    |    2 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S              |    2 +-
 arch/arm/mach-s3c24xx/sleep.S                      |    2 +-
 arch/arm/mach-s3c64xx/Kconfig                      |    3 +-
 arch/arm/mach-s3c64xx/common.c                     |    2 +-
 arch/arm/mach-s3c64xx/include/mach/debug-macro.S   |    2 +-
 arch/arm/mach-s3c64xx/include/mach/pm-core.h       |    2 +
 arch/arm/mach-s3c64xx/include/mach/tick.h          |   31 -
 arch/arm/mach-s3c64xx/include/mach/timex.h         |   24 -
 arch/arm/mach-s3c64xx/include/mach/uncompress.h    |   31 -
 arch/arm/mach-s3c64xx/irq-pm.c                     |   14 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq.c                |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |    3 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    2 +-
 arch/arm/mach-s3c64xx/pm.c                         |    1 -
 arch/arm/mach-s3c64xx/s3c6400.c                    |    2 +-
 arch/arm/mach-s3c64xx/s3c6410.c                    |    2 +-
 arch/arm/mach-s5p64x0/common.c                     |   20 +-
 arch/arm/mach-s5p64x0/common.h                     |    5 +-
 arch/arm/mach-s5p64x0/include/mach/debug-macro.S   |    3 +-
 arch/arm/mach-s5p64x0/include/mach/pm-core.h       |    2 +
 arch/arm/mach-s5p64x0/include/mach/timex.h         |   27 -
 arch/arm/mach-s5p64x0/include/mach/uncompress.h    |   34 -
 arch/arm/mach-s5p64x0/irq-pm.c                     |    8 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |    2 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |    2 +-
 arch/arm/mach-s5p64x0/pm.c                         |    1 -
 arch/arm/mach-s5pc100/common.c                     |    2 +-
 arch/arm/mach-s5pc100/include/mach/debug-macro.S   |    2 +-
 arch/arm/mach-s5pc100/include/mach/tick.h          |   31 -
 arch/arm/mach-s5pc100/include/mach/timex.h         |   24 -
 arch/arm/mach-s5pc100/include/mach/uncompress.h    |   30 -
 arch/arm/mach-s5pc100/mach-smdkc100.c              |    2 +-
 arch/arm/mach-s5pv210/Kconfig                      |    1 +
 arch/arm/mach-s5pv210/common.c                     |    2 +-
 arch/arm/mach-s5pv210/include/mach/debug-macro.S   |    2 +-
 arch/arm/mach-s5pv210/include/mach/timex.h         |   29 -
 arch/arm/mach-s5pv210/include/mach/uncompress.h    |   28 -
 arch/arm/mach-s5pv210/mach-aquila.c                |    2 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    2 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c              |    2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |    2 +-
 arch/arm/mach-s5pv210/mach-torbreck.c              |    2 +-
 arch/arm/mach-sa1100/include/mach/timex.h          |   12 -
 arch/arm/mach-sa1100/time.c                        |    8 +-
 arch/arm/mach-shmobile/Kconfig                     |   26 +-
 arch/arm/mach-shmobile/Makefile                    |    4 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |    2 +
 arch/arm/mach-shmobile/board-bockw.c               |   45 +-
 arch/arm/mach-shmobile/board-genmai.c              |   75 +-
 arch/arm/mach-shmobile/board-koelsch-reference.c   |  106 +-
 arch/arm/mach-shmobile/board-koelsch.c             |  305 +++++-
 arch/arm/mach-shmobile/board-kzm9d-reference.c     |   48 -
 arch/arm/mach-shmobile/board-lager-reference.c     |  109 ++-
 arch/arm/mach-shmobile/board-lager.c               |  492 +++++++++-
 arch/arm/mach-shmobile/clock-r7s72100.c            |   36 +-
 arch/arm/mach-shmobile/clock-r8a7778.c             |    4 +
 arch/arm/mach-shmobile/clock-r8a7779.c             |   27 +-
 arch/arm/mach-shmobile/clock-r8a7790.c             |  196 ++--
 arch/arm/mach-shmobile/clock-r8a7791.c             |  153 ++-
 arch/arm/mach-shmobile/include/mach/common.h       |    1 -
 arch/arm/mach-shmobile/include/mach/head-kzm9g.txt |  410 ++++++++
 arch/arm/mach-shmobile/include/mach/pm-rcar.h      |   15 +
 arch/arm/mach-shmobile/include/mach/r8a7779.h      |   13 +-
 arch/arm/mach-shmobile/include/mach/r8a7790.h      |   26 +
 arch/arm/mach-shmobile/include/mach/timex.h        |    6 -
 arch/arm/mach-shmobile/include/mach/zboot.h        |    3 +
 arch/arm/mach-shmobile/include/mach/zboot_macros.h |   43 +
 arch/arm/mach-shmobile/platsmp-apmu.c              |    3 +-
 arch/arm/mach-shmobile/pm-r8a7779.c                |  131 +--
 arch/arm/mach-shmobile/pm-r8a7790.c                |   45 +
 arch/arm/mach-shmobile/pm-rcar.c                   |  141 +++
 arch/arm/mach-shmobile/setup-emev2.c               |    2 +-
 arch/arm/mach-shmobile/setup-r8a7790.c             |   90 ++
 arch/arm/mach-shmobile/setup-rcar-gen2.c           |    2 +-
 arch/arm/mach-shmobile/smp-r8a7779.c               |   17 +-
 arch/arm/mach-shmobile/smp-r8a7790.c               |   17 +
 arch/arm/mach-socfpga/Kconfig                      |    7 -
 arch/arm/mach-spear/Kconfig                        |   10 -
 arch/arm/mach-spear/include/mach/timex.h           |   19 -
 arch/arm/mach-sti/Kconfig                          |    7 +-
 arch/arm/mach-sunxi/Kconfig                        |    6 +-
 arch/arm/mach-sunxi/Makefile                       |    2 +-
 arch/arm/mach-sunxi/headsmp.S                      |    9 -
 arch/arm/mach-sunxi/platsmp.c                      |    2 +-
 arch/arm/mach-sunxi/sunxi.c                        |    4 +-
 arch/arm/mach-tegra/Kconfig                        |    8 -
 arch/arm/mach-tegra/Makefile                       |    1 -
 arch/arm/mach-tegra/cpuidle-tegra114.c             |    7 +-
 arch/arm/mach-tegra/platsmp.c                      |    2 +-
 arch/arm/mach-tegra/powergate.c                    |    2 +
 arch/arm/mach-tegra/tegra2_emc.c                   |  347 -------
 arch/arm/mach-tegra/tegra2_emc.h                   |   24 -
 arch/arm/mach-u300/Kconfig                         |    6 -
 arch/arm/mach-ux500/Kconfig                        |   10 -
 arch/arm/mach-ux500/Makefile                       |    1 -
 arch/arm/mach-ux500/board-mop500-audio.c           |    1 -
 arch/arm/mach-ux500/board-mop500-pins.c            |  291 ------
 arch/arm/mach-ux500/board-mop500.h                 |   73 --
 arch/arm/mach-ux500/cpu-db8500.c                   |   17 -
 arch/arm/mach-ux500/cpu.c                          |   10 -
 arch/arm/mach-ux500/irqs-board-mop500.h            |   55 --
 arch/arm/mach-ux500/irqs-db8500.h                  |  125 ---
 arch/arm/mach-ux500/irqs.h                         |   49 -
 arch/arm/mach-versatile/core.c                     |    2 +-
 arch/arm/mach-vexpress/Kconfig                     |    5 -
 arch/arm/mach-virt/Kconfig                         |   10 -
 arch/arm/mach-virt/Makefile                        |    5 -
 arch/arm/mach-virt/virt.c                          |   41 -
 arch/arm/mach-vt8500/Kconfig                       |    4 -
 arch/arm/mach-w90x900/include/mach/timex.h         |   25 -
 arch/arm/mach-zynq/Kconfig                         |    9 +-
 arch/arm/mach-zynq/common.c                        |    8 +-
 arch/arm/mach-zynq/common.h                        |    2 +-
 arch/arm/mach-zynq/slcr.c                          |  104 +-
 arch/arm/mm/Kconfig                                |    4 +-
 arch/arm/mm/cache-feroceon-l2.c                    |   45 +-
 arch/arm/mm/cache-tauros2.c                        |   29 +-
 arch/arm/plat-omap/Kconfig                         |    3 -
 arch/arm/plat-omap/include/plat/timex.h            |   33 -
 arch/arm/plat-orion/common.c                       |   10 +-
 arch/arm/plat-samsung/Kconfig                      |    6 +-
 arch/arm/plat-samsung/Makefile                     |    2 +
 arch/arm/plat-samsung/clock.c                      |    3 +-
 arch/arm/plat-samsung/cpu.c                        |    7 -
 arch/arm/plat-samsung/devs.c                       |   14 +-
 arch/arm/plat-samsung/include/plat/cpu.h           |   11 +-
 arch/arm/plat-samsung/include/plat/mfc.h           |    3 -
 arch/arm/plat-samsung/include/plat/pm-common.h     |  110 +++
 arch/arm/plat-samsung/include/plat/pm.h            |   80 +-
 arch/arm/plat-samsung/include/plat/regs-serial.h   |    1 -
 arch/arm/plat-samsung/include/plat/uncompress.h    |  175 ----
 arch/arm/plat-samsung/init.c                       |    9 +-
 arch/arm/plat-samsung/pm-check.c                   |    2 +-
 arch/arm/plat-samsung/pm-common.c                  |   75 ++
 arch/arm/plat-samsung/pm-debug.c                   |   97 ++
 arch/arm/plat-samsung/pm-gpio.c                    |    5 +-
 arch/arm/plat-samsung/pm.c                         |  148 +--
 arch/arm/plat-samsung/s5p-dev-mfc.c                |   17 +-
 arch/arm/plat-samsung/s5p-dev-uart.c               |    1 -
 arch/arm/plat-samsung/s5p-irq-pm.c                 |   13 -
 arch/arm/plat-samsung/s5p-sleep.S                  |   43 -
 drivers/amba/tegra-ahb.c                           |    2 -
 drivers/bus/arm-cci.c                              |   24 +-
 drivers/bus/imx-weim.c                             |   58 ++
 drivers/bus/mvebu-mbus.c                           |    3 +-
 drivers/char/hw_random/Kconfig                     |    6 +-
 drivers/clk/Kconfig                                |    1 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/bcm/Kconfig                            |    9 +
 drivers/clk/bcm/Makefile                           |    3 +
 drivers/clk/bcm/clk-bcm281xx.c                     |  416 ++++++++
 drivers/clk/bcm/clk-kona-setup.c                   |  769 +++++++++++++++
 drivers/clk/bcm/clk-kona.c                         | 1033 ++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h                         |  410 ++++++++
 drivers/clk/samsung/clk-exynos-audss.c             |    2 +-
 drivers/clk/samsung/clk-exynos4.c                  |  172 +++-
 drivers/clk/samsung/clk-exynos5250.c               |   49 +-
 drivers/clk/samsung/clk-exynos5420.c               |   49 +-
 drivers/clk/samsung/clk-exynos5440.c               |    2 +-
 drivers/clk/samsung/clk-s3c64xx.c                  |   79 +-
 drivers/clk/samsung/clk.c                          |   71 +-
 drivers/clk/samsung/clk.h                          |   14 +-
 drivers/clk/ti/clk-44xx.c                          |    1 -
 drivers/clk/ti/clk-54xx.c                          |    1 -
 drivers/clk/ti/clk-7xx.c                           |    1 -
 drivers/clk/versatile/clk-icst.c                   |   21 +-
 drivers/clk/versatile/clk-icst.h                   |    1 +
 drivers/clk/versatile/clk-impd1.c                  |   12 +-
 drivers/clk/versatile/clk-integrator.c             |   83 +-
 drivers/clk/versatile/clk-realview.c               |    4 +-
 drivers/clk/zynq/clkc.c                            |   89 +-
 drivers/clocksource/Kconfig                        |    3 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/exynos_mct.c                   |    2 -
 .../timer.c => drivers/clocksource/qcom-timer.c    |   29 +-
 drivers/clocksource/timer-marco.c                  |   13 +-
 drivers/clocksource/timer-prima2.c                 |   16 +-
 drivers/cpufreq/Kconfig.arm                        |    2 +-
 drivers/cpuidle/Kconfig.arm                        |    2 +-
 drivers/gpio/Kconfig                               |    2 +-
 drivers/gpu/drm/msm/Kconfig                        |    2 +-
 drivers/input/misc/ixp4xx-beeper.c                 |    2 +-
 drivers/irqchip/Kconfig                            |   16 +
 drivers/irqchip/Makefile                           |    2 +
 drivers/irqchip/exynos-combiner.c                  |    3 +-
 drivers/irqchip/irq-clps711x.c                     |  243 +++++
 drivers/irqchip/irq-crossbar.c                     |  208 ++++
 drivers/irqchip/irq-gic.c                          |   86 +-
 drivers/irqchip/irq-mmp.c                          |    2 +-
 drivers/irqchip/irq-vic.c                          |   60 +-
 drivers/leds/Kconfig                               |    4 +-
 drivers/mfd/ab8500-core.c                          |   27 +-
 drivers/mfd/db8500-prcmu.c                         |   34 +-
 drivers/mtd/nand/davinci_nand.c                    |   22 -
 drivers/phy/Kconfig                                |    2 +-
 drivers/power/reset/Kconfig                        |    2 +-
 drivers/power/reset/qnap-poweroff.c                |   49 +-
 drivers/reset/Kconfig                              |    2 +
 drivers/reset/Makefile                             |    1 +
 drivers/reset/core.c                               |   71 +-
 drivers/reset/sti/Kconfig                          |   15 +
 drivers/reset/sti/Makefile                         |    4 +
 drivers/reset/sti/reset-stih415.c                  |  112 +++
 drivers/reset/sti/reset-stih416.c                  |  143 +++
 drivers/reset/sti/reset-syscfg.c                   |  186 ++++
 drivers/reset/sti/reset-syscfg.h                   |   69 ++
 drivers/rtc/rtc-at91sam9.c                         |    2 +-
 drivers/rtc/rtc-isl12057.c                         |    5 +-
 drivers/rtc/rtc-mv.c                               |   12 +
 drivers/rtc/rtc-pxa.c                              |    1 -
 drivers/sh/clk/cpg.c                               |   38 +
 drivers/sh/intc/Kconfig                            |    2 +-
 drivers/thermal/Kconfig                            |    2 +-
 drivers/tty/serial/Kconfig                         |    2 +-
 drivers/tty/serial/atmel_serial.c                  |   49 +-
 drivers/watchdog/Kconfig                           |    2 +-
 drivers/watchdog/orion_wdt.c                       |  381 ++++++--
 include/asm-generic/vmlinux.lds.h                  |   10 +
 include/dt-bindings/clock/bcm281xx.h               |   65 ++
 .../dt-bindings/{clk => clock}/exynos-audss-clk.h  |    0
 include/dt-bindings/clock/r8a7790-clock.h          |    4 +-
 include/dt-bindings/pinctrl/am43xx.h               |    1 +
 .../dt-bindings/reset-controller/stih415-resets.h  |   26 +
 .../dt-bindings/reset-controller/stih416-resets.h  |   50 +
 include/linux/clk/zynq.h                           |    2 +-
 include/linux/irqchip/arm-gic.h                    |    7 +-
 include/linux/irqchip/arm-vic.h                    |    6 +-
 .../linux/irqchip/irq-crossbar.h                   |   12 +-
 include/linux/mfd/abx500/ab8500.h                  |    2 -
 include/linux/mfd/dbx500-prcmu.h                   |    2 -
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |   18 +
 include/linux/platform_data/atmel.h                |    1 +
 include/linux/platform_data/clk-integrator.h       |    1 -
 include/linux/platform_data/mtd-davinci-aemif.h    |    5 +-
 include/linux/pxa2xx_ssp.h                         |    2 +-
 include/linux/reset.h                              |   65 +-
 include/linux/serial_s3c.h                         |    2 +
 include/linux/sh_clk.h                             |   19 +-
 1018 files changed, 47128 insertions(+), 14324 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/armada-375.txt
 create mode 100644 Documentation/devicetree/bindings/arm/armada-38x.txt
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/bcm21664.txt
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/kona-resetmgr.txt
 create mode 100644 Documentation/devicetree/bindings/arm/bcm4708.txt
 create mode 100644 Documentation/devicetree/bindings/arm/mrvl/feroceon.txt
 create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
 create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
 create mode 100644 Documentation/devicetree/bindings/arm/omap/crossbar.txt
 create mode 100644 Documentation/devicetree/bindings/arm/omap/dmm.txt
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu.txt
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/pmu.txt
 delete mode 100644 Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
 create mode 100644 Documentation/devicetree/bindings/clock/arm-integrator.txt
 rename Documentation/devicetree/bindings/{arm/atmel-adc.txt => iio/adc/at91_adc.txt} (75%)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/cirrus,clps711x-intc.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/socfpga-dw-mshc.txt
 create mode 100644 Documentation/devicetree/bindings/net/socfpga-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/reset/sirf,rstc.txt
 create mode 100644 Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
 create mode 100644 Documentation/devicetree/bindings/reset/st,sti-softreset.txt
 create mode 100644 arch/arm/boot/dts/am3517-craneboard.dts
 create mode 100644 arch/arm/boot/dts/am437x-gp-evm.dts
 create mode 100644 arch/arm/boot/dts/armada-375-db.dts
 create mode 100644 arch/arm/boot/dts/armada-375.dtsi
 create mode 100644 arch/arm/boot/dts/armada-380.dtsi
 create mode 100644 arch/arm/boot/dts/armada-385-db.dts
 create mode 100644 arch/arm/boot/dts/armada-385-rd.dts
 create mode 100644 arch/arm/boot/dts/armada-385.dtsi
 create mode 100644 arch/arm/boot/dts/armada-38x.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9rl.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9rlek.dts
 rename arch/arm/boot/dts/{bcm11351-brt.dts => bcm21664-garnet.dts} (79%)
 create mode 100644 arch/arm/boot/dts/bcm21664.dtsi
 create mode 100644 arch/arm/boot/dts/bcm4708-netgear-r6250.dts
 create mode 100644 arch/arm/boot/dts/bcm4708.dtsi
 create mode 100644 arch/arm/boot/dts/bcm5301x.dtsi
 create mode 100644 arch/arm/boot/dts/bcm59056.dtsi
 create mode 100644 arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi
 create mode 100644 arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard.dts
 create mode 100644 arch/arm/boot/dts/imx25-pinfunc.h
 delete mode 100644 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dts
 create mode 100644 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi
 rename arch/arm/boot/dts/{imx27-phytec-phycore-som.dts => imx27-phytec-phycore-som.dtsi} (52%)
 create mode 100644 arch/arm/boot/dts/imx27-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx28-duckbill.dts
 create mode 100644 arch/arm/boot/dts/imx28-eukrea-mbmx283lc.dts
 create mode 100644 arch/arm/boot/dts/imx28-eukrea-mbmx287lc.dts
 create mode 100644 arch/arm/boot/dts/imx28-eukrea-mbmx28lc.dtsi
 create mode 100644 arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi
 create mode 100644 arch/arm/boot/dts/imx35-eukrea-mbimxsd35-baseboard.dts
 create mode 100644 arch/arm/boot/dts/imx35.dtsi
 create mode 100644 arch/arm/boot/dts/imx50-evk.dts
 create mode 100644 arch/arm/boot/dts/imx50-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx50.dtsi
 create mode 100644 arch/arm/boot/dts/imx51-eukrea-cpuimx51.dtsi
 create mode 100644 arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard.dts
 delete mode 100644 arch/arm/boot/dts/imx53-evk.dts
 create mode 100644 arch/arm/boot/dts/imx53-qsb-common.dtsi
 create mode 100644 arch/arm/boot/dts/imx53-qsrb.dts
 create mode 100644 arch/arm/boot/dts/imx53-tx53-x03x.dts
 create mode 100644 arch/arm/boot/dts/imx53-tx53-x13x.dts
 create mode 100644 arch/arm/boot/dts/imx53-voipac-bsb.dts
 create mode 100644 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
 create mode 100644 arch/arm/boot/dts/imx6dl-dfi-fs700-m60.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-gw51xx.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-gw52xx.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-gw53xx.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-gw54xx.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-nitrogen6x.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-sabrelite.dts
 create mode 100644 arch/arm/boot/dts/imx6q-cm-fx6.dts
 create mode 100644 arch/arm/boot/dts/imx6q-dfi-fs700-m60.dts
 create mode 100644 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
 create mode 100644 arch/arm/boot/dts/imx6q-gk802.dts
 create mode 100644 arch/arm/boot/dts/imx6q-gw51xx.dts
 create mode 100644 arch/arm/boot/dts/imx6q-gw52xx.dts
 create mode 100644 arch/arm/boot/dts/imx6q-gw53xx.dts
 create mode 100644 arch/arm/boot/dts/imx6q-gw5400-a.dts
 create mode 100644 arch/arm/boot/dts/imx6q-gw54xx.dts
 create mode 100644 arch/arm/boot/dts/imx6q-nitrogen6x.dts
 create mode 100644 arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-gw51xx.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-gw53xx.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
 create mode 100644 arch/arm/boot/dts/k2e-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/k2e-evm.dts
 create mode 100644 arch/arm/boot/dts/k2e.dtsi
 create mode 100644 arch/arm/boot/dts/k2hk-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/k2hk.dtsi
 create mode 100644 arch/arm/boot/dts/k2l-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/k2l-evm.dts
 create mode 100644 arch/arm/boot/dts/k2l.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-b3.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds109.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds110jv10.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds111.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds112.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds209.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds210.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds212.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds212j.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds409.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds409slim.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds411.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds411j.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ds411slim.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-rd88f6192.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-rd88f6281-a0.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-rd88f6281-a1.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-rs212.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-rs409.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-rs411.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-synology.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-t5325.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ts419-6281.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ts419-6282.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ts419.dtsi
 create mode 100644 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-cm-t3517.dts
 create mode 100644 arch/arm/boot/dts/omap3-cm-t3530.dts
 create mode 100644 arch/arm/boot/dts/omap3-cm-t3x.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-lilly-a83x.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-lilly-dbb056.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-alto35-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-alto35.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-base.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-chestnut43-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-chestnut43.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-common-peripherals.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-gallop43-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-gallop43.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-palo43-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-palo43.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-storm-alto35.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-storm-chestnut43.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-storm-gallop43.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-storm-palo43.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-storm-summit.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-storm.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-summit-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-summit.dts
 create mode 100644 arch/arm/boot/dts/omap3-sbc-t3517.dts
 create mode 100644 arch/arm/boot/dts/omap3-sbc-t3530.dts
 create mode 100644 arch/arm/boot/dts/omap4-duovero-parlor.dts
 create mode 100644 arch/arm/boot/dts/omap4-duovero.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-msm8660.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-msm8960.dtsi
 delete mode 100644 arch/arm/boot/dts/r8a7791-koelsch-reference.dts
 create mode 100644 arch/arm/boot/dts/ste-href-ab8500.dtsi
 create mode 100644 arch/arm/boot/dts/ste-href-ab8505.dtsi
 create mode 100644 arch/arm/boot/dts/stih41x-b2020x.dtsi
 create mode 100644 arch/arm/boot/dts/sun4i-a10-inet97fv2.dts
 create mode 100644 arch/arm/boot/dts/sun4i-a10-olinuxino-lime.dts
 create mode 100644 arch/arm/boot/dts/sun4i-a10-pcduino.dts
 create mode 100644 arch/arm/boot/dts/sunxi-common-regulators.dtsi
 delete mode 100644 arch/arm/configs/da8xx_omapl_defconfig
 delete mode 100644 arch/arm/configs/kzm9d_defconfig
 create mode 100644 arch/arm/configs/multi_v5_defconfig
 create mode 100644 arch/arm/configs/mvebu_v5_defconfig
 rename arch/arm/configs/{mvebu_defconfig => mvebu_v7_defconfig} (91%)
 create mode 100644 arch/arm/configs/shmobile_defconfig
 rename arch/arm/{plat-orion/include/plat => include/asm/hardware}/cache-feroceon-l2.h (75%)
 delete mode 100644 arch/arm/mach-at91/include/mach/timex.h
 create mode 100644 arch/arm/mach-bcm/bcm_5301x.c
 create mode 100644 arch/arm/mach-bcm/board_bcm21664.c
 rename arch/arm/{mach-bcm2835/bcm2835.c => mach-bcm/board_bcm2835.c} (100%)
 delete mode 100644 arch/arm/mach-bcm2835/Kconfig
 delete mode 100644 arch/arm/mach-bcm2835/Makefile
 delete mode 100644 arch/arm/mach-clps711x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-davinci/board-tnetv107x-evm.c
 delete mode 100644 arch/arm/mach-davinci/devices-tnetv107x.c
 delete mode 100644 arch/arm/mach-davinci/include/mach/timex.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/tnetv107x.h
 delete mode 100644 arch/arm/mach-davinci/tnetv107x.c
 delete mode 100644 arch/arm/mach-dove/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/timex.h
 delete mode 100644 arch/arm/mach-efm32/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-efm32/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/timex.h
 rename arch/arm/mach-exynos/{common.c => exynos.c} (70%)
 delete mode 100644 arch/arm/mach-exynos/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/pm-core.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/timex.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-exynos/mach-exynos4-dt.c
 delete mode 100644 arch/arm/mach-exynos/mach-exynos5-dt.c
 create mode 100644 arch/arm/mach-exynos/mfc.h
 create mode 100644 arch/arm/mach-exynos/sleep.S
 delete mode 100644 arch/arm/mach-footbridge/include/mach/timex.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/timex.h
 create mode 100644 arch/arm/mach-imx/cpuidle-imx6sl.c
 delete mode 100644 arch/arm/mach-imx/devices/platform-mxc_pwm.c
 create mode 100644 arch/arm/mach-imx/pm-imx6.c
 delete mode 100644 arch/arm/mach-imx/pm-imx6q.c
 create mode 100644 arch/arm/mach-imx/suspend-imx6.S
 rename arch/arm/mach-integrator/{include/mach/platform.h => hardware.h} (81%)
 rename arch/arm/mach-integrator/{include/mach => }/impd1.h (83%)
 delete mode 100644 arch/arm/mach-integrator/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-integrator/include/mach/timex.h
 rename arch/arm/mach-integrator/{include/mach => }/lm.h (100%)
 delete mode 100644 arch/arm/mach-iop13xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-iop32x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-iop33x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-kirkwood/board-mv88f6281gtw_ge.c
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/timex.h
 create mode 100644 arch/arm/mach-kirkwood/pm.h
 delete mode 100644 arch/arm/mach-ks8695/include/mach/timex.h
 delete mode 100644 arch/arm/mach-msm/headsmp.S
 delete mode 100644 arch/arm/mach-msm/hotplug.c
 delete mode 100644 arch/arm/mach-msm/include/mach/timex.h
 delete mode 100644 arch/arm/mach-msm/platsmp.c
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/timex.h
 create mode 100644 arch/arm/mach-mvebu/board-t5325.c
 rename arch/arm/mach-mvebu/{armada-370-xp.c => board-v7.c} (58%)
 create mode 100644 arch/arm/mach-mvebu/board.h
 rename arch/arm/{mach-dove/board-dt.c => mach-mvebu/dove.c} (61%)
 create mode 100644 arch/arm/mach-mvebu/kirkwood-pm.c
 create mode 100644 arch/arm/mach-mvebu/kirkwood-pm.h
 create mode 100644 arch/arm/mach-mvebu/kirkwood.c
 create mode 100644 arch/arm/mach-mvebu/kirkwood.h
 delete mode 100644 arch/arm/mach-netx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/timex.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/timex.h
 delete mode 100644 arch/arm/mach-orion5x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/timex.h
 create mode 100644 arch/arm/mach-qcom/Kconfig
 create mode 100644 arch/arm/mach-qcom/Makefile
 rename arch/arm/{mach-msm/board-dt.c => mach-qcom/board.c} (52%)
 create mode 100644 arch/arm/mach-qcom/platsmp.c
 rename arch/arm/{mach-msm => mach-qcom}/scm-boot.c (100%)
 rename arch/arm/{mach-msm => mach-qcom}/scm-boot.h (78%)
 rename arch/arm/{mach-msm => mach-qcom}/scm.c (100%)
 rename arch/arm/{mach-msm => mach-qcom}/scm.h (100%)
 delete mode 100644 arch/arm/mach-realview/include/mach/timex.h
 rename arch/arm/{mach-lpc32xx/include/mach/timex.h => mach-rockchip/core.h} (59%)
 rename arch/arm/{mach-versatile/include/mach/timex.h => mach-rockchip/headsmp.S} (54%)
 create mode 100644 arch/arm/mach-rockchip/platsmp.c
 delete mode 100644 arch/arm/mach-rpc/include/mach/timex.h
 rename arch/arm/{plat-samsung/include/plat => mach-s3c24xx/include/mach}/rtc-core.h (69%)
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/tick.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/tick.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/tick.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-sa1100/include/mach/timex.h
 delete mode 100644 arch/arm/mach-shmobile/board-kzm9d-reference.c
 create mode 100644 arch/arm/mach-shmobile/include/mach/head-kzm9g.txt
 create mode 100644 arch/arm/mach-shmobile/include/mach/pm-rcar.h
 delete mode 100644 arch/arm/mach-shmobile/include/mach/timex.h
 create mode 100644 arch/arm/mach-shmobile/pm-r8a7790.c
 create mode 100644 arch/arm/mach-shmobile/pm-rcar.c
 delete mode 100644 arch/arm/mach-spear/include/mach/timex.h
 delete mode 100644 arch/arm/mach-sunxi/headsmp.S
 delete mode 100644 arch/arm/mach-tegra/tegra2_emc.c
 delete mode 100644 arch/arm/mach-tegra/tegra2_emc.h
 delete mode 100644 arch/arm/mach-ux500/board-mop500-pins.c
 delete mode 100644 arch/arm/mach-ux500/irqs-board-mop500.h
 delete mode 100644 arch/arm/mach-ux500/irqs-db8500.h
 delete mode 100644 arch/arm/mach-ux500/irqs.h
 delete mode 100644 arch/arm/mach-virt/Kconfig
 delete mode 100644 arch/arm/mach-virt/Makefile
 delete mode 100644 arch/arm/mach-virt/virt.c
 delete mode 100644 arch/arm/mach-w90x900/include/mach/timex.h
 delete mode 100644 arch/arm/plat-omap/include/plat/timex.h
 create mode 100644 arch/arm/plat-samsung/include/plat/pm-common.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-serial.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/uncompress.h
 create mode 100644 arch/arm/plat-samsung/pm-common.c
 create mode 100644 arch/arm/plat-samsung/pm-debug.c
 create mode 100644 drivers/clk/bcm/Kconfig
 create mode 100644 drivers/clk/bcm/Makefile
 create mode 100644 drivers/clk/bcm/clk-bcm281xx.c
 create mode 100644 drivers/clk/bcm/clk-kona-setup.c
 create mode 100644 drivers/clk/bcm/clk-kona.c
 create mode 100644 drivers/clk/bcm/clk-kona.h
 rename arch/arm/mach-msm/timer.c => drivers/clocksource/qcom-timer.c (98%)
 create mode 100644 drivers/irqchip/irq-clps711x.c
 create mode 100644 drivers/irqchip/irq-crossbar.c
 create mode 100644 drivers/reset/sti/Kconfig
 create mode 100644 drivers/reset/sti/Makefile
 create mode 100644 drivers/reset/sti/reset-stih415.c
 create mode 100644 drivers/reset/sti/reset-stih416.c
 create mode 100644 drivers/reset/sti/reset-syscfg.c
 create mode 100644 drivers/reset/sti/reset-syscfg.h
 create mode 100644 include/dt-bindings/clock/bcm281xx.h
 rename include/dt-bindings/{clk => clock}/exynos-audss-clk.h (100%)
 create mode 100644 include/dt-bindings/reset-controller/stih415-resets.h
 create mode 100644 include/dt-bindings/reset-controller/stih416-resets.h
 rename arch/arm/mach-mmp/include/mach/timex.h => include/linux/irqchip/irq-crossbar.h (56%)
