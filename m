Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3GBTSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:18:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3GBTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:18:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 5/7] ARM SoC device tree changes
Date: Tue, 2 Jul 2013 21:08:48 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <201307022055.50717.arnd@arndb.de>
In-Reply-To: <201307022055.50717.arnd@arndb.de>
MIME-Version: 1.0
Message-Id: <201307022108.48580.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:8X0XVs3rU/H+aaHuDZD+eLjg4+uw3D2c9mwBGzkBjSM
 C/lh9NEYWKY0s+mDSh7eksjUyKwjZawQDKrlC/1x+53XH6sX6k
 cmloqVxLfc59lu0UA/n1P3PE1LI5iH5JT834pEQUg1e1Gt/6c3
 S8DwZCTcLe92BpT8rHwwD2QQ4tWRNacII04rTk7wxJjzgXruGq
 Q1xULs9efY6zf9HPuAyANWtN/Smg2hzm4AJpXoPfBjmwRomSBm
 cElnjHyQfeG/v66rDK5M14ftjjiAYC3sWt9m9u1fmp/bgXxEar
 FXBhV3N72Vr1FrTNT2q3Yk9UgoRYhTWFyZjZsnQ8qAd+RiQRdh
 C0+cU6h4HOhm6/l9QoWc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-linus

for you to fetch changes up to 9686bb66a4c50e43ffee903a9fc62237ee2de1e6:

  Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt (2013-06-26 16:56:24 +0200)

----------------------------------------------------------------

ARM SoC device tree changes

These changes from 30 individual branches for the most part update device
tree files, but there are also a few source code changes that have crept
in this time, usually in order to atomically move over a driver from
using hardcoded data to DT probing.

A number of platforms change their DT files to use the C preprocessor,
which is causing a bit of churn, but that is hopefully only this once.

There are a few conflicts with the other branches unfortunately:

* in exynos5440.dtsi and kirkwood-6281.dtsi, device nodes are added
  from multiple branches. Need to be careful to have the right
  set of closing braces as git gets this one wrong.

* In kirkwood.dtsi, one 'ranges' line got split into two lines, while
  another line got added. Order of the lines does not matter.

* in sama5d3.dtsi, some cleanup was merged the wrong way, causing
  a bogus conflict. We want the 'dmas' and 'dma-names' properties
  to get added here.

* Two lines got removed independently in arch/arm/mach-mxs/mach-mxs.c

* Contents get added independently in arch/arm/mach-omap2/cclock33xx_data.c

----------------------------------------------------------------

The following changes since commit 9dfedaad4e6b7f9fbae06d3b342a1c77b8c025a5:

  Merge tag 'boards-for-linus' into for-linus (2013-07-02 15:11:10 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git 

for you to fetch changes up to d1bf673810d5a1e050e423c22687d705f35adcba:

  Merge tag 'dt-for-linus' into for-linus (2013-07-02 15:29:09 +0200)

----------------------------------------------------------------

Adam Baker (1):
      ARM: Kirkwood add cpus definition needed by cpufreq driver to dtsi

Afzal Mohammed (2):
      ARM: dts: AM43x: Initial support
      ARM: dts: AM43x EPOS EVM support

Alexander Shiyan (11):
      ARM: dts: Add aliases for i.MX27 SPI controller
      ARM: dts: Add SPI support for i.MX27 Phytec PCM038 module
      ARM: dts: imx27-phytec-phycore: Add reset GPIO for FEC
      ARM: dts: imx27-phytec-phycore: Rename file to match functionality
      ARM: dts: imx27-phytec-phycore-som: Remove UART definitions
      ARM: dts: imx27-phytec-phycore-som: Add initial support for PCM970 RDK
      ARM: dts: i.MX27: Add DMA devicetree node
      ARM: dts: i.MX27: Add SDHC devicetree nodes
      ARM: dts: imx27-phytec-phycore-rdk: Add SDHC support
      ARM: dts: imx27-phytec-phycore-rdk: Add MTD name for NOR flash
      ARM: dts: imx27: Add VPU devicetree node

Amit Daniel Kachhap (1):
      ARM: dts: Add more opp levels in exynos5440

Andrew Lunn (1):
      ARM: Kirkwood: ts219: Enable second PCIe port in DT.

Arnd Bergmann (16):
      ARM: nomadik: fix clocksource warning
      ARM: dts: add missing cpu #address-cell values
      Merge tag 'zynq-dt-for-3.11' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'mxs-dt-3.11' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-soc-3.11' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-dt-3.11' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'sunxi-dt-for-3.11-2' of git://github.com/mripard/linux into next/dt
      Merge tag 'nomadik-dt-2' of git://git.kernel.org/.../linusw/linux-nomadik into next/dt
      Merge tag 'exynos-dt-2' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 's3c24xx-dt-2' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge branch 'for_3.11/dts' of git://git.kernel.org/.../bcousson/linux-omap-dt into next/dt
      Merge tag 'renesas-dt2-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge branch 'armsoc/for-3.11/dt' of git://github.com/broadcom/bcm11351 into next/dt
      Merge tag 'dt-3.11-6' of git://git.infradead.org/users/jcooper/linux into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'dt-for-linus' into for-linus

Bastian Hecht (3):
      ARM: shmobile: r8a7740: Add OF support to initialze the GIC
      ARM: shmobile: r8a7740: Prepare for reference DT setup
      ARM: shmobile: armadillo800eva: Reference DT implementation

Boris BREZILLON (1):
      ARM: at91/dt: add pinctrl definition for at91 tc blocks

Brian Lilly (3):
      ARM: cfa10049: Switch the chip select pin of the LCD controller
      ARM: mxs: dt: Add the Crystalfontz CFA-10055 device tree
      ARM: mxs: dt: Add Crystalfontz CFA-10057 device tree

Christian Daudt (1):
      ARM: mmc: bcm281xx SDHCI driver (dt mods)

Christian Hemp (2):
      ARM: dts: imx6q: Add pinctrl for usdhc2 and enet
      ARM: dts: Phytec imx6q pfla02 and pbab01 support

Dan Murphy (3):
      ARM: dts: omap4-panda: Update the LED support for the panda
      ARM: dts: omap4-panda: Update the twl6040 gpio to macro definition
      ARM: dts: omap5-uevm: Add LED support for uEVM blue LED

Daniel Mack (1):
      ARM: bcm2835: Add Raspberry Pi's ACT LED to DT

Dinh Nguyen (2):
      ARM: socfpga: dts: Add ethernet bindings for SOCFPGA
      ARM: socfpga: dts: Add gate-clock bindings

Dirk Behme (2):
      ARM: dts: i.MX6: configure L2 cache data and tag latency
      i.MX6: Documentation: update from fsl,card-wired to non-removable

Dongjin Kim (2):
      ARM: dts: add max77686 node entry for ODROID-X
      ARM: dts: add vmmc regulator support for ODROID-X

Doug Anderson (1):
      ARM: dts: Enable RTC node for exynos5250-snow

Douglas Gilbert (1):
      ARM: at91: add Acme Systems Fox G20 board

Eduardo Valentin (3):
      ARM: dts: OMAP443x: Add bandgap entry for OMAP443x devices
      ARM: dts: OMAP4460: Add bandgap entry for OMAP4460 devices
      ARM: dts: OMAP5: Add bandgap DT entry

Emilio López (1):
      ARM: sun4i: cubieboard: Enable the i2c controllers

Eric Brower (1):
      ARM: tegra: Add gpio-leds to Tegra30 Beaver

Eric Bénard (3):
      ARM: mx28: add auart2 2 pins pinmux to imx28.dtsi
      ARM: mx28: add auart3 2 pins pinmux to imx28.dtsi
      ARM: mx28: add auart4 2 pins pinmux to imx28.dtsi

Ezequiel Garcia (3):
      ARM: mvebu: Add support for NOR flash device on Armada XP-DB board
      ARM: mvebu: Remove device tree unused properties on A370
      ARM: Kirkwood: Fix the internal register ranges translation

Fabio Baltieri (5):
      ARM: ux500: Fix intcore regulator name
      ARM: ux500: Fix trivial typo in v-anamic1 comment
      ARM: ux500: Correct anamic2 typo in DT files
      ARM: ux500: Add DT regulators for ab8500-codec
      ARM: ux500: Provide auxdata to ux500 ASoC driver

Fabio Estevam (2):
      ARM: dts: mx28: Adjust the digctl compatible string
      ARM: mxs: Use soc bus infrastructure

Florian Vaussard (15):
      ARM: dts: OMAP2+: Use #include for all device trees
      ARM: dts: OMAP2+: Use existing constants for GPIOs
      ARM: dts: OMAP4/5: Use existing constants for IRQs
      ARM: dts: OMAP2+: Header file for pinctrl constants
      ARM: dts: OMAP2+: Use pinctrl constants
      ARM: dts: AM3XXX: Use #include for all device trees
      ARM: dts: AM33XX: Use existing constants for GPIOs
      ARM: dts: AM33XX: Specific pinctrl header
      ARM: dts: AM33XX: Use pinctrl constants
      ARM: dts: OMAP4/AM35xx: Add missing dtb in the dtbs target
      ARM: dts: Protect pinctrl headers against multiple inclusions
      ARM: dts: OMAP3: Include IRQ header
      ARM: dts: omap3-tobi: Add SMSC911X node
      ARM: dts: omap3-tobi: Correct polarity for GPIO LED
      ARM: dts: omap3-overo: Add default trigger for TWL4030 LED

Gabriel Fernandez (2):
      ARM: ux500: DT: Rename root node "soc-u9500" into "soc"
      ARM: ux500: use #include syntax to include *.dtsi.

Giridhar Maruthy (1):
      ARM: dts: Removing pdma for exynos5440

Girish K S (2):
      ARM: dts: add dts node for the ahci sata exynos5440
      ARM: dts: enable spi for EXYNOS5440 SOC

Guennadi Liakhovetski (5):
      ARM: shmobile: kzm9g-reference: add AS3711 and CPUFreq DT bindings
      ARM: shmobile: marzen-reference: add irqpin support in DT
      irqchip: renesas-intc-irqpin: DT binding for sense bitfield width
      ARM: shmobile: sh73a0: remove "0x" prefix from DT node names
      ARM: shmobile: irqpin: add a DT property to enable masking on parent

Gwenhael Goavec-Merou (3):
      ARM: dts: apf28dev: Add touchscreen support for APF28dev
      ARM: imx27: Add PWM0 to device tree
      ARM: imx: apf51: add nfc support

Heiko Stuebner (2):
      ARM: dts: add devicetree support for s3c2416-smdk2416
      ARM: S3C24XX: update uart addresses in s3c2416-dt auxdata

Hiroshi Doyu (6):
      ARM: tegra20: create a DT header defining CLK IDs
      ARM: tegra30: create a DT header defining CLK IDs
      ARM: tegra114: create a DT header defining CLK IDs
      ARM: tegra20: convert device tree files to use CLK defines
      ARM: tegra30: convert device tree files to use CLK defines
      ARM: tegra114: convert device tree files to use CLK defines

Huang Shijie (13):
      ARM: dts: imx6q: remove the unused pins for gpmi-nand
      ARM: dts: imx6dl: add pinctrl for gpmi-nand
      ARM: dts: enable the gpmi-nand for imx6q{dl}-sabreauto boards
      ARM: dts: imx6dl: add a pinctrl for eCSPI1
      ARM: dts: imx6dl: add a gpio for hog
      ARM: dts: imx6q: add a gpio for hog
      ARM: dts: add SPI/NOR for mx6q{dl}-sabreauto boards
      drivers: bus: add a new driver for WEIM
      ARM: dts: imx6q{dl}: fix the pin conflict between SPI and WEIM
      ARM: dts: imx6qdl: add more information for WEIM
      ARM: dts: imx6q: add pinctrls for WEIM NOR
      ARM: dts: imx6dl: add pinctrls for WEIM NOR
      ARM: dts: imx6qdl-sabreauto: enable the WEIM NOR

J Keerthy (1):
      ARM: dts: OMAP5: Add Palmas MFD node and regulator nodes

Javier Martinez Canillas (3):
      ARM: dts: omap3-igep0020: Add SMSC911x LAN chip support
      ARM: dts: omap3-igep0020: Add NAND flash support
      ARM: dts: omap3-igep0030: Add NAND flash support

Jean-Christophe PLAGNIOL-VILLARD (12):
      ARM: at91: dt: sam9260: add i2c gpio pinctrl
      ARM: at91: dt: usb-a9260: update shutdown controller
      ARM: at91: dt: usb-a9263: update shutdown controller
      ARM: at91: dt: usb-a9263: add dataflash support
      ARM: at91: dt: add Calao USB-A9G20 low power version
      ARM: at91: drop non DT: Calao USB-A96x
      ARM: at91: sam9x5 add udc DT support
      ARM: at91: sam9x5ek add udc DT support
      ARM: at91: sam9g45 add udc DT support
      ARM: at91: sam9m10g45ek add udc DT support
      ARM: at91: dt: rm9200: add spi support
      ARM: at91: dt: rm9200ek: add spi support

Jingchang Lu (2):
      ARM: dts: add SoC level device tree source for VF610
      ARM: dts: add initial VF610 Tower board dts support

Jingoo Han (2):
      ARM: dts: add pin state information for DP HPD support to Exynos5250
      ARM: dts: Document DP clock in samsung,exynos5-dp binding

Jonas Andersson (3):
      ARM: dts: imx53: add cspi pinctrl
      ARM: dts: imx53: add ecspi2 pinctrl
      ARM: dts: imx53: add fec pinctrl

Kevin Hilman (3):
      ARM: dts: OMAP3: beagle/overo: mux console UART, enable wakeup
      ARM: dts: OMAP3: beagle: enable user button via gpio_keys, enable wakeup
      ARM: dts: TWL4030: fix mux and wakeup for SYS_NIRQ line

Laxman Dewangan (1):
      ARM: tegra: enable spi4 on Dalmore

Lee Jones (26):
      ARM: ux500: Move Snowball's thermal DT node into existing PRCMU one
      ARM: ux500: Create a new of_dev_auxdata structure for u8540 enablement
      ARM: ux500: Add a VQMMC (level-shifting) regulator DT node for Snowball
      ARM: ux500: Supply address location names for the DMA40 DMA controller
      ARM: ux500: Setup the DMA40 driver's DT node using the new DMA API
      ARM: ux500: Supply UART's DMA configuration via Device Tree
      ARM: ux500: Supply MMC DMA configuration via Device Tree
      ARM: ux500: Populate the ux500-musb Device Tree entry
      ARM: ux500: Pass DMA memcpy channels though Device Tree
      ARM: ux500: Supply a DTS file for the u8540 platform
      ARM: ux500: Over-ride TCDM size when booting the DB8540 platform
      ARM: ux500: Add Device Tree nodes for the ux500 Crypt device
      ARM: ux500: Add Device Tree nodes for the ux500 Hash device
      ARM: ux500: Provide an AUXDATA entry for ux500-crypt
      ARM: ux500: Provide an AUXDATA entry for ux500-hash
      crypto: ux500/cryp - Enable DT probing of the driver
      crypto: ux500/hash - Enable DT probing of the driver
      ARM: ux500: Standardise DBx5x0 based Pinctrl compat string in the DTS
      ARM: ux500: Standardise Pinctrl compatible string for DBx5x based platforms
      pinctrl/nomadik: Standardise Pinctrl compat string for DBx5x based platforms
      ARM: ux500: Apply other compatible name to the u8540 DTS file
      ARM: nomadik: Standardise Nomadik STN8815 based Pinctrl compat string in the DTS
      pinctrl/nomadik: Standardise Pinctrl compat string for Nomadik based platforms
      ARM: ux500: Add an auxdata entry for MUSB for clock-name look-up
      ARM: ux500: Reduce PRCMU reg-names to shorter form for u8540 DT
      ARM: ux500: Allocate correct amount of memory for the u8540 in DT

Leela Krishna Amudala (1):
      Documentation: Add examples to samsung-pinctrl device tree bindings documentation

Linus Walleij (14):
      ARM: nomadik: convert all clocks except timer to dt
      ARM: nomadik: register clocksource from device tree
      ARM: nomadik: add led and key for S8815
      ARM: nomadik: move the pin configuration to DT
      ARM: ux500: build ccu8540 device tree blob
      ARM: ux500: fix typo in STUIB device tree
      ARM: ux500: register LP5521 LEDs in the device tree
      ARM: ux500: enable the crypto and hash on all dbx500
      ARM: ux500: bump MMC/SD max frequency for DT boots
      ARM: ux500: use symbolic names for interrupt flags
      ARM: ux500: cut chip-select GPIOs from SSP device
      ARM: ux500: drop any 0x prefix from I2C DT devices
      clk: nomadik: implement the Nomadik clocks properly
      ARM: nomadik: add the new clocks to the device tree

Lorenzo Pieralisi (14):
      ARM: dts: am33xx: cpus/cpu nodes dts updates
      ARM: dts: armada-370-xp: cpus/cpu node dts updates
      ARM: dts: at91: cpus/cpu node dts updates
      ARM: dts: exynos5440: cpus/cpu nodes dts updates
      ARM: dts: imx: cpus/cpu nodes dts updates
      ARM: dts: lpc32xx: cpus/cpu nodes dts updates
      ARM: dts: omap: cpus/cpu nodes dts updates
      ARM: dts: picoxcell: cpus/cpu nodes dts updates
      ARM: dts: prima2: cpus/cpu node dts updates
      ARM: dts: pxa2xx: cpus/cpu nodes dts updates
      ARM: dts: r8a7740: cpus/cpu nodes dts updates
      ARM: dts: sh7372: cpus/cpu nodes dts updates
      ARM: dts: spear: cpus/cpu nodes dts updates
      ARM: dts: sunxi: cpus/cpu nodes dts updates

Ludovic Desroches (2):
      ARM: at91: dt: add header to define at_hdmac configuration
      ARM: at91: dt: switch DMA DT bindings to pre-processor

Magnus Damm (2):
      ARM: shmobile: Remove unused r8a73a4 GIC CPU interface DT bits
      ARM: shmobile: Remove unused r8a7790 GIC CPU interface DT bits

Marek Vasut (9):
      ARM: mxs: Fix UARTs on M28EVK
      ARM: mx5: Add AUDMUX4 pinctrl data
      ARM: mx5: Add CAN1 pinctrl data
      ARM: mx5: Add I2C1 pinctrl data
      ARM: mx5: Add I2C2 pinctrl data
      ARM: mx5: Add NAND pinctrl data
      ARM: mx5: Add LCD IPU pinctrl data
      ARM: mx5: Add PWM1 pinctrl data
      ARM: mx5: Add support for DENX M53EVK

Markus Niebel (4):
      ARM i.MX53: mba53: add sound support
      ARM i.MX53: mba53: add missing gpio stuff for pca9554
      ARM i.MX53: mba53: use reset gpio for FEC
      ARM i.MX53: mba53: add DI1_CLK to pinctrl for disp1

Matt Porter (3):
      ARM: dts: bcm281xx: use #include for device tree files
      ARM: dts: bcm281xx: use existing defines for irqs
      ARM: dts: bcm281xx: change comment to C89 style

Maxime Ripard (12):
      ARM: sun5i: Update the clock compatible strings
      ARM: sunxi: dt: Register the pio node as interrupt controller
      ARM: sunxi: dt: Add i2c controller nodes to the DTSI
      ARM: sun4i: dt: Add i2c muxing options
      ARM: sun5i: dt: Add i2c muxing options
      ARM: sun5i: olinuxino: Enable the i2c controllers
      ARM: sunxi: dt: Add Allwinner A10s DTSI
      ARM: mxs: Remove init_irq declaration in machine description
      ARM: dts: cfa10036: Change the OLED display to SSD1306
      ARM: cfa10036: dt: Change i2c0 clock frequency
      ARM: cfa10036: Add USB0 OTG port
      ARM: sunxi: Add Olimex A10s-Olinuxino-micro device tree

Michael Grzeschik (4):
      ARM: dts: imx: add imx5x usbmisc entries
      ARM: dts: imx: add imx5x usb clock DT lookups
      ARM: dts: imx: use usb-nop-xceiv usbphy entries for imx5x
      ARM: dts: imx: imx53-qsb.dts: enable usbotg and usbh1

Michael Olbrich (1):
      ARM i.MX53: mba53: enable usbotg & usbh1

Mugunthan V N (3):
      ARM: dts: AM33XX: Add pinmux configuration for CPSW to beaglebone
      ARM: dts: AM33XX: Add pinmux configuration for CPSW to EVMsk
      ARM: dts: AM33XX: Add pinmux configuration for CPSW to am335x EVM

Nicolas Ferre (8):
      ARM: at91: at91sam9x5 RTC is not compatible with at91rm9200 one
      ARM: at91/at91-ariag25.dts: add RTC node
      ARM: at91/at91sam9x5.dtsi: add UART0/1 nodes
      ARM: at91/at91-ariag25.dts: UART0/1 nodes are disabled
      ARM: at91: switch Fox G20 board .dts to pre-processor defines
      ARM: at91/DT: fix SPI compatibility string
      ARM: at91/DT: sama5d3: add SPI DMA client infos
      ARM: at91/DT: at91sam9n12: add SPI DMA client infos

Nicolin Chen (7):
      ARM: dts: imx6qdl-sabresd: add clko1 iomux configuration
      ARM: dtsi: imx6q/imx6dl: Add a pinctrl for I2C1
      ARM: dtsi: imx6dl: Add a pinctrl for AUDMUX
      ARM: dtsi: imx6qdl-sabresd: add a fixed regulator for WM8962
      ARM: dtsi: imx6qdl-sabresd: Add WM8962 CODEC support
      ARM: dtsi: imx6qdl-sabresd: Enable SSI2 and AUDMUX
      ARM: dtsi: imx6qdl-sabresd: Enable WM8962 audio support

Olof Johansson (15):
      Merge tag 'nomadik-dt-for-arm-soc' of git://git.kernel.org/.../linusw/linux-nomadik into next/dt
      Merge tag 'dt-3.11-3' of git://git.infradead.org/users/jcooper/linux into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge branch 'dts-cpus-updates' of git://linux-arm.org/linux-2.6-lp into next/dt
      Merge tag 'vt8500/dts-3.11' of git://github.com/linux-wmt/linux-vtwm into next/dt
      Merge tag 'dt-3.11-4' of git://git.infradead.org/users/jcooper/linux into next/dt
      Merge tag 'renesas-dt-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 's3c24xx-dt-1' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'exynos-dt-1' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'dt-3.11-5' of git://git.infradead.org/users/jcooper/linux into next/dt
      Merge tag 'ux500-dt-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'bcm2835-for-3.11-dt' of git://git.kernel.org/.../swarren/linux-rpi into next/dt
      Merge tag 'tegra-for-3.11-dt' of git://git.kernel.org/.../swarren/linux-tegra into next/dt
      Merge tag 'sunxi-dt-for-3.11' of git://github.com/mripard/linux into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt

Padmavathi Venna (1):
      ARM: dts: Add wm8994 regulator support on smdk5250

Philip Avinash (4):
      ARM: dts: AM33XX: Add NAND flash device tree data to am335x-evm
      ARM: dts: AM33XX: Add PWMSS device tree nodes
      ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm
      ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk

Philip, Avinash (1):
      ARM: dts: AM33XX: Add ELM node

Philipp Zabel (5):
      ARM i.MX53: dts: add i2c aliases
      ARM i.MX53: tqma53: fix pinctrl settings
      ARM i.MX53: tqma53: rev 300 specific pin configuration
      ARM i.MX53: Add TVE entry to i.MX53 dtsi
      ARM i.MX53: mba53: add Tevision Encoder

Rabin Vincent (1):
      clocksource: nomadik-mtu: support of probe

Rhyland Klein (2):
      ARM: tegra: Add charger subnode to tps65090 node
      ARM: tegra: add power-supplies link between battery and charger

Richard Genoud (1):
      ARM: at91: dt: at91sam9x5: add SPI DMA client infos

Roger Quadros (4):
      ARM: dts: omap5-uevm: Add USB Host support
      ARM: dts: omap4-panda: Add USB Host support
      ARM: dts: omap4-panda: Fix DVI EDID reads
      ARM: dts: omap5-uevm: Provide USB Host PHY clock frequency

Rogerio Pimentel (1):
      ARM: dts: mx53qsb: Add support for parallel display

Sachin Kamat (16):
      ARM: dts: Remove keypad entries from exynos4x12-pinctrl.dtsi
      ARM: dts: Add keypad entries to Exynos4412 based Origen
      ARM: dts: Add keypad entries to SMDK4412
      ARM: dts: Add MFC clock entries for exynos4
      ARM: dts: Update MFC documentation for clock entries
      ARM: dts: Add TMU clock entries to exynos4210.dtsi
      ARM: dts: Enable TMU on Origen4210 board
      ARM: dts: Remove combiner IRQ node from exynos4x12.dtsi
      clk: exynos4: Add additional G2D clocks
      ARM: dts: Remove duplicate and add missing G2D nodes
      ARM: dts: Add clock entries to G2D node for exynos4210
      ARM: dts: Add clock entries to G2D node for exynos4x12
      ARM: dts: Update G2D documentation for clock entries
      ARM: dts: Add PWM related pinctrl entries for exynos4210
      ARM: dts: Add LCD related pinctrl entries for exynos4210
      ARM: dts: Add FIMD node to Origen4210 board

Sascha Hauer (2):
      ARM i.MX53: tqma53: Fix interrupt polarity for the mc34708
      ARM i.MX53: mba53: Add display support

Sebastian Hesselbarth (1):
      ARM: dove: add si5351 clock driver to CuBox DT

Shawn Guo (6):
      Merge tag 'imx-soc-3.11' into imx/dt
      ARM: imx: move imx53-qsb audio codec clk lookup into DT
      ARM: dts: add device tree source for imx6sl SoC
      ARM: dts: imx6sl: add initial imx6sl-evk support
      ARM: dts: imx6qdl: remove redundant usbmisc label
      ARM: dts: imx6qdl: remove redundant ocotp node

Simon Baatz (3):
      ARM: mvebu: Use standard MMC binding for all users of mvsdio
      ARM: Kirkwood: Add dts files for Sheevaplug and eSATA Sheevaplug
      arm: kirkwood: sheevaplug: move pinmux configs to the right devices

Soren Brinkmann (4):
      arm: zynq: Remove board specific compatibility string
      arm: dt: zynq: Use 'status' property for UART nodes
      arm: dt: zynq: Add support for the zc706 platform
      arm: dt: zynq: Add support for the zed platform

Sourav Poddar (1):
      ARM: dts: omap5-uevm: Add uart pinctrl data

Sricharan R (1):
      ARM: dts: omap5: Make uevm as the official board and deprecate sevm support

Steffen Trumtrar (9):
      ARM: i.MX53: add audmux pinctrl
      ARM: i.MX53: add csi pinctrl
      ARM: i.MX53: add ecspi pinctrl
      ARM: i.MX53: add pwm2 pinctrl
      ARM: i.MX53: add uart1 pinctrl
      ARM: i.MX53: add uart2 pinctrl
      ARM: dts: add Ka-Ro tx53 devicetree
      ARM i.MX53: tqma53: add WP/CD pinctrl and vmmc to esdhc2
      ARM i.MX53: mba53: fix lvds/disp pinctrl

Stephen Warren (10):
      Merge branch 'for-3.11/deps-for-clk' into for-3.11/dt
      ARM: tegra: fix memory size on Beaver
      ARM: tegra: use #include for all device trees
      ARM: tegra: create a DT header defining GPIO IDs
      ARM: tegra: convert device tree files to use GPIO defines
      ARM: tegra: convert device tree files to use IRQ defines
      ARM: tegra: add audio-related nodes to Tegra114 DT
      ARM: tegra: enable audio on Dalmore
      ARM: tegra: enable audio on Beaver
      ARM: mxc: fix gpio-ranges for VF610

Subash Patel (1):
      ARM: dts: update bootargs to support 8GiB for SSDK5440 and SD5v1

Suman Anna (1):
      ARM: dts: OMAP4+: Remove multimedia carveouts

Thomas Abraham (2):
      ARM: dts: add max8997 device node for exynos4210-origen board
      ARM: dts: add ohci and ehci controller nodes for EXYNOS5440

Thomas Petazzoni (25):
      arm: mvebu: enable the third USB interface on OpenBlocks AX3
      arm: mvebu: enable two USB interfaces on the Armada XP GP board
      arm: kirkwood: cloudbox: move pinmux configs to the right devices
      arm: kirkwood: dlink dns: move pinmux configs to the right devices
      arm: kirkwood: dockstar: move pinmux configs to the right devices
      arm: kirkwood: dreamplug: move pinmux configs to the right devices
      arm: kirkwood: goflexnet: move pinmux configs to the right devices
      arm: kirkwood: guruplug: move pinmux configs to the right devices
      arm: kirkwood: ib62x0: move pinmux configs to the right devices
      arm: kirkwood: iconnect: give meaningful names to pinmux configs
      arm: kirkwood: iconnect: move pinmux configs to the right devices
      arm: kirkwood: iomega ix2-200: move pinmux configs to the right devices
      arm: kirkwood: ns2: move pinmux configs to the right devices
      arm: kirkwood: keymile: move pinmux configs to the right devices
      arm: kirkwood: buffalo linkstation: move pinmux configs to the right devices
      arm: kirkwood: mplcec4: move pinmux configs to the right devices
      arm: kirkwood: readynas: move pinmux configs to the right devices
      arm: kirkwood: nsa310: move pinmux configs to the right devices
      arm: kirkwood: openblocks_a6: move pinmux configs to the right devices
      arm: kirkwood: topkick: move pinmux configs to the right devices
      arm: kirkwood: ts219: move pinmux configs to the right devices
      arm: kirkwood: openblocks-a6: group pinmux configurations
      arm: kirkwood: openblocks-a6: add support for Init button
      arm: mvebu: armada-xp-db: ensure PCIe range is specified
      arm: mvebu: enable mini-PCIe connectors on Armada 370 RD

Tony Prisk (7):
      dts: vt8500: Fix invalid/missing cpu nodes for soc files.
      dts: vt8500: Add devicetree support for WM8750 SoC and APC8750 board
      dts: vt8500: Update serial nodes and disable by default in SoC files
      dts: clk: vt8500: Update SoC dtsi to use WM8850 PLL      clocks
      dts: vt8500: Populate missing PLL nodes
      dts: vt8500: Add ARM, AHB, APB and DDR clock nodes to SoC files
      dts: vt8500: Correct reference clock on WM8850 SoCs

Tushar Behera (2):
      ARM: dts: Enable RTC node for Arndale
      ARM: dts: Set BUCK7 as always on for Origen board

Vaibhav Hiremath (7):
      ARM: dts: AM33XX: Add default pinctrl binding for I2C device
      ARM: dts: AM33XX: Add pinctrl binding to gpio-leds node
      ARM: dts: AM33XX: Fix uart numbering to match hardware/TRM
      ARM: dts: AM33XX: Add default pinctrl binding for UART0 device
      ARM: dts: AM33XX: Set pinmux for clkout2 pad used for clock output
      ARM: AM33XX: clock: Add debugSS clock nodes
      ARM: AM33XX: clock data: Enable clkout2 as part of init

Valentin Longchamp (2):
      ARM: kirkwood: refactor dtsi to largest common nodes
      ARM: kirkwood: add i2c-gpio controller for km_kirkwood

Venu Byravarasu (3):
      ARM: tegra: finalize USB EHCI and PHY bindings
      ARM: tegra: modify ULPI reset GPIO properties
      ARM: tegra: update device trees for USB binding rework

Vikas Sajjan (3):
      ARM: dts: Add DT node for DP controller for Arndale Board
      ARM: dts: Add clock provider information for DP controller in Exynos5250 SoC
      ARM: dts: Add display timing node to exynos5250-arndale.dts

Vivek Gautam (3):
      ARM: dts: Enabling samsung-usb3phy driver for exynos5250
      ARM: dts: Add device tree bindings for dwc3-exynos
      ARM: dts: Enabling dwc3-exynos driver for exynos5250

Wenyou Yang (2):
      ARM: at91/dtsi: add the watchdog nodes for at91 SoC
      ARM: at91/dts: add the watchdog nodes for at91 boards

Willy Tarreau (1):
      ARM: mvebu: set aliases for ethernet controllers

Youngmin Nam (1):
      ARM: dts: Enable RTC by default on EXYNOS5440

 .../devicetree/bindings/arm/omap/omap.txt          |   3 +
 .../devicetree/bindings/arm/ste-nomadik.txt        |   5 +
 Documentation/devicetree/bindings/bus/imx-weim.txt |  49 ++
 .../devicetree/bindings/clock/altr_socfpga.txt     |   7 +
 .../devicetree/bindings/clock/exynos4-clock.txt    |   3 +-
 .../bindings/clock/nvidia,tegra114-car.txt         | 252 +------
 .../bindings/clock/nvidia,tegra20-car.txt          | 154 +---
 .../bindings/clock/nvidia,tegra30-car.txt          | 211 +-----
 .../devicetree/bindings/clock/st,nomadik.txt       | 104 +++
 .../devicetree/bindings/gpu/samsung-g2d.txt        |   5 +
 .../interrupt-controller/renesas,intc-irqpin.txt   |  16 +
 .../devicetree/bindings/media/s5p-mfc.txt          |   5 +
 Documentation/devicetree/bindings/mfd/ab8500.txt   |   2 +-
 .../devicetree/bindings/mmc/bcm,kona-sdhci.txt     |  16 +
 .../bindings/pinctrl/fsl,imx-pinctrl.txt           |   2 +-
 .../bindings/pinctrl/samsung-pinctrl.txt           |  44 +-
 .../devicetree/bindings/usb/exynos-usb.txt         |  34 +
 .../bindings/usb/nvidia,tegra20-ehci.txt           |  27 +-
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |  41 +-
 .../devicetree/bindings/video/exynos_dp.txt        |   6 +
 arch/arm/boot/dts/Makefile                         |  32 +-
 arch/arm/boot/dts/am335x-bone.dts                  | 118 ++-
 arch/arm/boot/dts/am335x-evm.dts                   | 264 ++++++-
 arch/arm/boot/dts/am335x-evmsk.dts                 | 184 ++++-
 arch/arm/boot/dts/am33xx.dtsi                      | 125 +++-
 arch/arm/boot/dts/am3517-evm.dts                   |   2 +-
 arch/arm/boot/dts/am3517_mt_ventoux.dts            |   2 +-
 arch/arm/boot/dts/am4372.dtsi                      |  68 ++
 arch/arm/boot/dts/am43x-epos-evm.dts               |  18 +
 arch/arm/boot/dts/armada-370-db.dts                |   1 +
 arch/arm/boot/dts/armada-370-mirabox.dts           |   1 +
 arch/arm/boot/dts/armada-370-rd.dts                |  17 +
 arch/arm/boot/dts/armada-370-xp.dtsi               |  17 +-
 arch/arm/boot/dts/armada-370.dtsi                  |   4 -
 arch/arm/boot/dts/armada-xp-db.dts                 |  34 +
 arch/arm/boot/dts/armada-xp-gp.dts                 |  10 +
 arch/arm/boot/dts/armada-xp-mv78460.dtsi           |   3 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   |   9 +
 arch/arm/boot/dts/armada-xp.dtsi                   |   6 +-
 arch/arm/boot/dts/at91-ariag25.dts                 |  21 +-
 arch/arm/boot/dts/at91-foxg20.dts                  | 157 ++++
 arch/arm/boot/dts/at91rm9200.dtsi                  | 102 ++-
 arch/arm/boot/dts/at91rm9200ek.dts                 |  10 +
 arch/arm/boot/dts/at91sam9260.dtsi                 |  94 ++-
 arch/arm/boot/dts/at91sam9263.dtsi                 |  46 +-
 arch/arm/boot/dts/at91sam9263ek.dts                |   4 +
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   4 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 | 151 +++-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   9 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 | 107 ++-
 arch/arm/boot/dts/at91sam9n12ek.dts                |   4 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  | 195 ++++-
 arch/arm/boot/dts/at91sam9x5ek.dtsi                |   9 +
 arch/arm/boot/dts/bcm11351-brt.dts                 |  19 +-
 arch/arm/boot/dts/bcm11351.dtsi                    |  39 +-
 arch/arm/boot/dts/bcm2835-rpi-b.dts                |  11 +
 arch/arm/boot/dts/ccu8540.dts                      |  41 ++
 arch/arm/boot/dts/ccu9540.dts                      |   6 +-
 arch/arm/boot/dts/dbx5x0.dtsi                      | 226 ++++--
 arch/arm/boot/dts/dove-cubox.dts                   |  51 +-
 arch/arm/boot/dts/exynos4.dtsi                     |   2 +
 arch/arm/boot/dts/exynos4210-origen.dts            | 169 +++++
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi          |  89 +++
 arch/arm/boot/dts/exynos4210.dtsi                  |   5 +
 arch/arm/boot/dts/exynos4412-odroidx.dts           | 197 +++++
 arch/arm/boot/dts/exynos4412-origen.dts            |  66 ++
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |  85 ++-
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |  56 --
 arch/arm/boot/dts/exynos4x12.dtsi                  |  10 +-
 arch/arm/boot/dts/exynos5250-arndale.dts           |  31 +
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi          |   7 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  40 +-
 arch/arm/boot/dts/exynos5250-snow.dts              |   4 +
 arch/arm/boot/dts/exynos5250.dtsi                  |  34 +-
 arch/arm/boot/dts/exynos5440-sd5v1.dts             |   2 +-
 arch/arm/boot/dts/exynos5440-ssdk5440.dts          |  41 +-
 arch/arm/boot/dts/exynos5440.dtsi                  |  70 +-
 arch/arm/boot/dts/href.dtsi                        |  61 +-
 arch/arm/boot/dts/hrefprev60.dts                   |  10 +-
 arch/arm/boot/dts/hrefv60plus.dts                  |  20 +-
 arch/arm/boot/dts/imx23.dtsi                       |   8 +-
 arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts     |  37 +
 arch/arm/boot/dts/imx27-phytec-phycore-som.dts     | 179 +++++
 arch/arm/boot/dts/imx27-phytec-phycore.dts         |  79 --
 arch/arm/boot/dts/imx27.dtsi                       |  80 +-
 arch/arm/boot/dts/imx28-apf28dev.dts               |   1 +
 arch/arm/boot/dts/imx28-cfa10036.dts               |  38 +-
 arch/arm/boot/dts/imx28-cfa10049.dts               |   8 +-
 arch/arm/boot/dts/imx28-cfa10055.dts               | 179 +++++
 arch/arm/boot/dts/imx28-cfa10057.dts               | 191 +++++
 arch/arm/boot/dts/imx28-m28evk.dts                 |  14 +-
 arch/arm/boot/dts/imx28.dtsi                       |  43 +-
 arch/arm/boot/dts/imx51-apf51.dts                  |   7 +
 arch/arm/boot/dts/imx51.dtsi                       |  23 +
 arch/arm/boot/dts/imx53-m53evk.dts                 | 259 +++++++
 arch/arm/boot/dts/imx53-mba53.dts                  | 175 ++++-
 arch/arm/boot/dts/imx53-qsb.dts                    |  36 +
 arch/arm/boot/dts/imx53-tqma53.dtsi                |  45 +-
 arch/arm/boot/dts/imx53-tx53.dtsi                  | 122 ++++
 arch/arm/boot/dts/imx53.dtsi                       | 297 +++++++-
 arch/arm/boot/dts/imx6dl-sabreauto.dts             |   8 +
 arch/arm/boot/dts/imx6dl-sabresd.dts               |   1 +
 arch/arm/boot/dts/imx6dl.dtsi                      | 114 +++
 arch/arm/boot/dts/imx6q-phytec-pbab01.dts          |  34 +
 arch/arm/boot/dts/imx6q-phytec-pfla02.dtsi         |  74 ++
 arch/arm/boot/dts/imx6q-sabreauto.dts              |   8 +
 arch/arm/boot/dts/imx6q-sabresd.dts                |   1 +
 arch/arm/boot/dts/imx6q.dtsi                       | 104 ++-
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  41 ++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  66 ++
 arch/arm/boot/dts/imx6qdl.dtsi                     |  13 +-
 arch/arm/boot/dts/imx6sl-evk.dts                   |  74 ++
 arch/arm/boot/dts/imx6sl.dtsi                      | 779 ++++++++++++++++++++
 arch/arm/boot/dts/kirkwood-6281.dtsi               |  28 +
 arch/arm/boot/dts/kirkwood-6282.dtsi               |  28 +
 arch/arm/boot/dts/kirkwood-cloudbox.dts            |  10 +-
 arch/arm/boot/dts/kirkwood-dns320.dts              |   7 +
 arch/arm/boot/dts/kirkwood-dns325.dts              |   5 +
 arch/arm/boot/dts/kirkwood-dnskw.dtsi              |  32 +-
 arch/arm/boot/dts/kirkwood-dockstar.dts            |   9 +-
 arch/arm/boot/dts/kirkwood-dreamplug.dts           |  12 +-
 arch/arm/boot/dts/kirkwood-goflexnet.dts           |  18 +-
 .../arm/boot/dts/kirkwood-guruplug-server-plus.dts |  10 +-
 arch/arm/boot/dts/kirkwood-ib62x0.dts              |  17 +-
 arch/arm/boot/dts/kirkwood-iconnect.dts            |  36 +-
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts      |  15 +-
 arch/arm/boot/dts/kirkwood-is2.dts                 |   2 +
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts         |  13 +-
 arch/arm/boot/dts/kirkwood-lsxl.dtsi               |  22 +-
 arch/arm/boot/dts/kirkwood-mplcec4.dts             |  25 +-
 .../boot/dts/kirkwood-netgear_readynas_duo_v2.dts  |  22 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi         |  10 +-
 arch/arm/boot/dts/kirkwood-ns2.dts                 |   2 +
 arch/arm/boot/dts/kirkwood-ns2lite.dts             |   2 +
 arch/arm/boot/dts/kirkwood-ns2max.dts              |   2 +
 arch/arm/boot/dts/kirkwood-ns2mini.dts             |   2 +
 arch/arm/boot/dts/kirkwood-nsa310.dts              |  30 +-
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts       | 108 +--
 arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi  |  93 +++
 arch/arm/boot/dts/kirkwood-sheevaplug-esata.dts    |  43 ++
 arch/arm/boot/dts/kirkwood-sheevaplug.dts          |  43 ++
 arch/arm/boot/dts/kirkwood-topkick.dts             |  52 +-
 arch/arm/boot/dts/kirkwood-ts219-6281.dts          |   8 +-
 arch/arm/boot/dts/kirkwood-ts219-6282.dts          |  16 +-
 arch/arm/boot/dts/kirkwood-ts219.dtsi              |  10 +
 arch/arm/boot/dts/kirkwood.dtsi                    |  41 +-
 arch/arm/boot/dts/lpc32xx.dtsi                     |   8 +-
 arch/arm/boot/dts/omap2.dtsi                       |  11 +-
 arch/arm/boot/dts/omap2420-h4.dts                  |   2 +-
 arch/arm/boot/dts/omap2420.dtsi                    |   2 +-
 arch/arm/boot/dts/omap2430.dtsi                    |   2 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts              |  48 +-
 arch/arm/boot/dts/omap3-beagle.dts                 |  72 +-
 arch/arm/boot/dts/omap3-devkit8000.dts             |  11 +-
 arch/arm/boot/dts/omap3-evm.dts                    |   7 +-
 arch/arm/boot/dts/omap3-igep.dtsi                  |  43 +-
 arch/arm/boot/dts/omap3-igep0020.dts               | 111 ++-
 arch/arm/boot/dts/omap3-igep0030.dts               |  60 +-
 arch/arm/boot/dts/omap3-overo.dtsi                 |  20 +-
 arch/arm/boot/dts/omap3-tobi.dts                   |  52 +-
 arch/arm/boot/dts/omap3.dtsi                       |  11 +-
 arch/arm/boot/dts/omap3430-sdp.dts                 |   5 +-
 arch/arm/boot/dts/omap34xx.dtsi                    |   2 +-
 arch/arm/boot/dts/omap36xx.dtsi                    |   2 +-
 arch/arm/boot/dts/omap4-panda-a4.dts               |  10 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi          | 162 ++++-
 arch/arm/boot/dts/omap4-panda-es.dts               |  38 +-
 arch/arm/boot/dts/omap4-panda.dts                  |   4 +-
 arch/arm/boot/dts/omap4-sdp-es23plus.dts           |   8 +-
 arch/arm/boot/dts/omap4-sdp.dts                    | 126 ++--
 arch/arm/boot/dts/omap4-var-som.dts                |   8 +-
 arch/arm/boot/dts/omap4.dtsi                       | 131 ++--
 arch/arm/boot/dts/omap443x.dtsi                    |   8 +-
 arch/arm/boot/dts/omap4460.dtsi                    |  15 +-
 arch/arm/boot/dts/omap5-evm.dts                    | 261 -------
 arch/arm/boot/dts/omap5-uevm.dts                   | 485 ++++++++++++
 arch/arm/boot/dts/omap5.dtsi                       | 180 +++--
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi             |   8 +-
 arch/arm/boot/dts/picoxcell-pc3x3.dtsi             |   8 +-
 arch/arm/boot/dts/prima2.dtsi                      |   2 +
 arch/arm/boot/dts/pxa2xx.dtsi                      |   7 +-
 arch/arm/boot/dts/r8a73a4.dtsi                     |   6 -
 .../boot/dts/r8a7740-armadillo800eva-reference.dts |  45 ++
 arch/arm/boot/dts/r8a7740.dtsi                     | 121 +++
 arch/arm/boot/dts/r8a7779.dtsi                     |  17 +
 arch/arm/boot/dts/r8a7790.dtsi                     |   6 -
 arch/arm/boot/dts/s3c2416-pinctrl.dtsi             | 173 +++++
 arch/arm/boot/dts/s3c2416-smdk2416.dts             |  72 ++
 arch/arm/boot/dts/s3c2416.dtsi                     |  79 ++
 arch/arm/boot/dts/s3c24xx.dtsi                     |  92 +++
 arch/arm/boot/dts/sama5d3.dtsi                     |  33 +-
 arch/arm/boot/dts/sh7372.dtsi                      |   5 +
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts       |  86 +++
 arch/arm/boot/dts/sh73a0.dtsi                      |  18 +-
 arch/arm/boot/dts/snowball.dts                     |  80 +-
 arch/arm/boot/dts/socfpga.dtsi                     | 217 +++++-
 arch/arm/boot/dts/socfpga_cyclone5.dts             |  13 +
 arch/arm/boot/dts/socfpga_vt.dts                   |   5 +
 arch/arm/boot/dts/spear13xx.dtsi                   |   2 +
 arch/arm/boot/dts/spear3xx.dtsi                    |   8 +-
 arch/arm/boot/dts/spear600.dtsi                    |   8 +-
 arch/arm/boot/dts/ste-nomadik-s8815.dts            |  69 ++
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi         | 574 ++++++++++++++-
 arch/arm/boot/dts/stuib.dtsi                       |  26 +-
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts         |  12 +
 arch/arm/boot/dts/sun4i-a10.dtsi                   |  54 ++
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts   |  76 ++
 arch/arm/boot/dts/sun5i-a10s.dtsi                  | 286 ++++++++
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts          |  18 +
 arch/arm/boot/dts/sun5i-a13.dtsi                   |  89 ++-
 arch/arm/boot/dts/tegra114-dalmore.dts             |  71 +-
 arch/arm/boot/dts/tegra114-pluto.dts               |   2 +-
 arch/arm/boot/dts/tegra114.dtsi                    | 277 ++++---
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         |  29 +-
 arch/arm/boot/dts/tegra20-harmony.dts              |  67 +-
 arch/arm/boot/dts/tegra20-iris-512.dts             |  13 +-
 arch/arm/boot/dts/tegra20-medcom-wide.dts          |  12 +-
 arch/arm/boot/dts/tegra20-paz00.dts                |  48 +-
 arch/arm/boot/dts/tegra20-plutux.dts               |  12 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |  69 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |  15 +-
 arch/arm/boot/dts/tegra20-tec.dts                  |  13 +-
 arch/arm/boot/dts/tegra20-trimslice.dts            |  46 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |  60 +-
 arch/arm/boot/dts/tegra20-whistler.dts             |  47 +-
 arch/arm/boot/dts/tegra20.dtsi                     | 285 ++++----
 arch/arm/boot/dts/tegra30-beaver.dts               |  68 +-
 arch/arm/boot/dts/tegra30-cardhu-a02.dts           |  16 +-
 arch/arm/boot/dts/tegra30-cardhu-a04.dts           |  18 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |  47 +-
 arch/arm/boot/dts/tegra30.dtsi                     | 288 ++++----
 arch/arm/boot/dts/twl4030_omap3.dtsi               |  25 +
 arch/arm/boot/dts/usb_a9260.dts                    |   9 +
 arch/arm/boot/dts/usb_a9263.dts                    |  14 +
 arch/arm/boot/dts/usb_a9g20.dts                    |  18 +-
 arch/arm/boot/dts/usb_a9g20_common.dtsi            |  27 +
 arch/arm/boot/dts/usb_a9g20_lpw.dts                |  31 +
 arch/arm/boot/dts/vf610-pinfunc.h                  | 810 +++++++++++++++++++++
 arch/arm/boot/dts/vf610-twr.dts                    |  57 ++
 arch/arm/boot/dts/vf610.dtsi                       | 464 ++++++++++++
 arch/arm/boot/dts/vt8500-bv07.dts                  |   4 +
 arch/arm/boot/dts/vt8500.dtsi                      |  29 +-
 arch/arm/boot/dts/wm8505-ref.dts                   |   4 +
 arch/arm/boot/dts/wm8505.dtsi                      |  84 ++-
 arch/arm/boot/dts/wm8650-mid.dts                   |   3 +
 arch/arm/boot/dts/wm8650.dtsi                      |  79 +-
 arch/arm/boot/dts/wm8750-apc8750.dts               |  30 +
 arch/arm/boot/dts/wm8750.dtsi                      | 347 +++++++++
 arch/arm/boot/dts/wm8850-w70v2.dts                 |   4 +
 arch/arm/boot/dts/wm8850.dtsi                      |  94 ++-
 arch/arm/boot/dts/zynq-7000.dtsi                   |   2 +
 arch/arm/boot/dts/zynq-zc702.dts                   |   6 +-
 arch/arm/boot/dts/zynq-zc706.dts                   |  35 +
 arch/arm/boot/dts/zynq-zed.dts                     |  35 +
 arch/arm/configs/at91_dt_defconfig                 |   2 +
 arch/arm/configs/at91sam9260_9g20_defconfig        |   1 -
 arch/arm/configs/at91sam9263_defconfig             |   1 -
 arch/arm/configs/nhk8815_defconfig                 |   6 +
 arch/arm/mach-at91/Kconfig.non_dt                  |  19 -
 arch/arm/mach-at91/Makefile                        |   3 -
 arch/arm/mach-at91/at91sam9g45.c                   |   2 +
 arch/arm/mach-at91/at91sam9x5.c                    |   2 +
 arch/arm/mach-at91/board-usb-a926x.c               | 384 ----------
 arch/arm/mach-imx/clk-imx51-imx53.c                |   2 -
 arch/arm/mach-imx/mach-imx53.c                     |  16 -
 arch/arm/mach-mxs/Kconfig                          |   1 +
 arch/arm/mach-mxs/mach-mxs.c                       | 129 +++-
 arch/arm/mach-nomadik/Kconfig                      |   1 +
 arch/arm/mach-nomadik/cpu-8815.c                   |  73 +-
 arch/arm/mach-omap2/cclock33xx_data.c              |  49 +-
 arch/arm/mach-s3c24xx/Kconfig                      |  12 +
 arch/arm/mach-s3c24xx/Makefile                     |   1 +
 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c            |  91 +++
 arch/arm/mach-shmobile/Kconfig                     |  14 +
 arch/arm/mach-shmobile/Makefile                    |   1 +
 .../board-armadillo800eva-reference.c              | 213 ++++++
 arch/arm/mach-shmobile/include/mach/r8a7740.h      |   3 +
 arch/arm/mach-shmobile/intc-r8a7740.c              |  24 +-
 arch/arm/mach-shmobile/setup-r8a7740.c             |  54 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |  26 +-
 arch/arm/mach-zynq/common.c                        |   1 -
 drivers/bus/Kconfig                                |   9 +
 drivers/bus/Makefile                               |   1 +
 drivers/bus/imx-weim.c                             | 138 ++++
 drivers/clk/clk-nomadik.c                          | 576 ++++++++++++++-
 drivers/clk/samsung/clk-exynos4.c                  |   9 +-
 drivers/clocksource/nomadik-mtu.c                  |  60 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |   6 +
 drivers/crypto/ux500/hash/hash_core.c              |   6 +
 drivers/irqchip/irq-renesas-intc-irqpin.c          |   9 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |   6 +-
 drivers/regulator/ab8500.c                         |   8 +-
 include/dt-bindings/clock/tegra114-car.h           | 342 +++++++++
 include/dt-bindings/clock/tegra20-car.h            | 158 ++++
 include/dt-bindings/clock/tegra30-car.h            | 265 +++++++
 include/dt-bindings/dma/at91.h                     |  27 +
 include/dt-bindings/gpio/tegra-gpio.h              |  50 ++
 include/dt-bindings/pinctrl/am33xx.h               |  42 ++
 include/dt-bindings/pinctrl/omap.h                 |  55 ++
 299 files changed, 15647 insertions(+), 3302 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/bus/imx-weim.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st,nomadik.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt
 create mode 100644 arch/arm/boot/dts/am4372.dtsi
 create mode 100644 arch/arm/boot/dts/am43x-epos-evm.dts
 create mode 100644 arch/arm/boot/dts/at91-foxg20.dts
 create mode 100644 arch/arm/boot/dts/ccu8540.dts
 create mode 100644 arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts
 create mode 100644 arch/arm/boot/dts/imx27-phytec-phycore-som.dts
 delete mode 100644 arch/arm/boot/dts/imx27-phytec-phycore.dts
 create mode 100644 arch/arm/boot/dts/imx28-cfa10055.dts
 create mode 100644 arch/arm/boot/dts/imx28-cfa10057.dts
 create mode 100644 arch/arm/boot/dts/imx53-m53evk.dts
 create mode 100644 arch/arm/boot/dts/imx53-tx53.dtsi
 create mode 100644 arch/arm/boot/dts/imx6q-phytec-pbab01.dts
 create mode 100644 arch/arm/boot/dts/imx6q-phytec-pfla02.dtsi
 create mode 100644 arch/arm/boot/dts/imx6sl-evk.dts
 create mode 100644 arch/arm/boot/dts/imx6sl.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-sheevaplug-esata.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-sheevaplug.dts
 delete mode 100644 arch/arm/boot/dts/omap5-evm.dts
 create mode 100644 arch/arm/boot/dts/omap5-uevm.dts
 create mode 100644 arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts
 create mode 100644 arch/arm/boot/dts/s3c2416-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/s3c2416-smdk2416.dts
 create mode 100644 arch/arm/boot/dts/s3c2416.dtsi
 create mode 100644 arch/arm/boot/dts/s3c24xx.dtsi
 create mode 100644 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
 create mode 100644 arch/arm/boot/dts/sun5i-a10s.dtsi
 create mode 100644 arch/arm/boot/dts/twl4030_omap3.dtsi
 create mode 100644 arch/arm/boot/dts/usb_a9g20_common.dtsi
 create mode 100644 arch/arm/boot/dts/usb_a9g20_lpw.dts
 create mode 100644 arch/arm/boot/dts/vf610-pinfunc.h
 create mode 100644 arch/arm/boot/dts/vf610-twr.dts
 create mode 100644 arch/arm/boot/dts/vf610.dtsi
 create mode 100644 arch/arm/boot/dts/wm8750-apc8750.dts
 create mode 100644 arch/arm/boot/dts/wm8750.dtsi
 create mode 100644 arch/arm/boot/dts/zynq-zc706.dts
 create mode 100644 arch/arm/boot/dts/zynq-zed.dts
 delete mode 100644 arch/arm/mach-at91/board-usb-a926x.c
 create mode 100644 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c
 create mode 100644 arch/arm/mach-shmobile/board-armadillo800eva-reference.c
 create mode 100644 drivers/bus/imx-weim.c
 create mode 100644 include/dt-bindings/clock/tegra114-car.h
 create mode 100644 include/dt-bindings/clock/tegra20-car.h
 create mode 100644 include/dt-bindings/clock/tegra30-car.h
 create mode 100644 include/dt-bindings/dma/at91.h
 create mode 100644 include/dt-bindings/gpio/tegra-gpio.h
 create mode 100644 include/dt-bindings/pinctrl/am33xx.h
 create mode 100644 include/dt-bindings/pinctrl/omap.h
