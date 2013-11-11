Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3KKFeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:34:17 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50723 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3KKFdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:33:06 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 6/6] ARM: SoC DT updates for 3.13
Date: Sun, 10 Nov 2013 21:29:36 -0800
Message-Id: <1384147776-18735-7-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1384147776-18735-1-git-send-email-olof@lixom.net>
References: <1384147776-18735-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of this branch consists of updates, additions and general churn of
the device tree source files in the kernel (arch/arm/boot/dts). Besides
that, there are a few things to point out:

- Lots of platform conversion on OMAP2+, with removal of old board files
  for various platforms.
- Final conversion of a bunch of ux500 (ST-Ericsson) platforms as well
- Some updates to pinctrl and other subsystems. Most of these are for
  DT-enablement of the various platforms and acks have been collected.


Conflicts:
* arch/arm/boot/dts/Makefile: gitk --merge will make you cry here.
  Essentially, keep everything from both sides (including both
  SHMOBILE_MULTI lines) but go with the ARCH_SOCFPGA version from
  this branch.
* arch/arm/boot/dts/omap3-evm.dts:
  File move conflicting with mainline bugfix. Delete the contents from HEAD, I
  prefer to redo the bugfix instead of making the equivalent edit in a merge
  commit.
* arch/arm/mach-omap2/Kconfig:
  Keep MACH_OMAP_GENERIC, remove HAVE_CLK
* arch/arm/mach-s3c64xx/Kconfig:
  Add/remove conflict. Move down endif, keep new config entry.

----------------------------------------------------------------

The following changes since commit e010e0be7fb633dac037a1f599e10df12082a393:

  Merge branch 'next/boards' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-linus

for you to fetch changes up to 07eb663b7ec7fdb9c325e22e83f5975c724b6249:

  Merge tag 'dt-3.13-5' of git://git.infradead.org/linux-mvebu into next/dt

----------------------------------------------------------------

Aaro Koskinen (4):
      ARM: OMAP2+: pdata-quirks: set internal clock source for MMC2 on N950/N9
      ARM: dts: omap3-devkit8000: fix a typo in GMPC node
      ARM: dts: add minimal DT support for Nokia N950 & N9 phones
      ARM: OMAP2: delete board-rm680

Afzal Mohammed (2):
      ARM: dts: AM4372: cpu(s) node per latest binding
      ARM: dts: AM4372: add few nodes

Alexander Holler (1):
      ARM: dts: am335x-bone: add CD for mmc1

Alexander Shiyan (3):
      ARM: dts: i.MX51: Separate TXD/RXD and RTS/CTS pinmux entries for UARTs
      ARM: dts: i.MX51: Add IRAM devicetree node
      ARM: dts: i.MX51: Add W1 devicetree node

Alexandre Belloni (1):
      ARM: dts: AM33XX: Add PMU support

Andrew Bresticker (1):
      ARM: dts: add i2c device nodes for Exynos5420

Arnaud Ebalard (1):
      ARM: mvebu: Add Netgear ReadyNAS 104 board

Balaji T K (4):
      ARM: dts: am335x-bone-common: correct mux mode for cmd line
      ARM: dts: am335x-evm[sdk]: switch mmc1 to 4-bit mode
      ARM: dts: dra7-evm: Add mmc1 node for micro-sd support
      ARM: dts: dra7-evm: Add mmc2 node for eMMC support

Barry Song (2):
      ARM: dts: sirf: add missed chhifbg node in prima2 and atlas6 dts
      ARM: dts: sirf: add missed cell, cs and dma channel for SPI nodes

Benoit Parrot (1):
      ARM: dts: AM33XX: Add LCDC info into am335x-evm

Bo Shen (5):
      ARM: at91: add at91sam9n12 ssc clock in look up table
      ARM: at91: add ssc dma parameter for at91sam9n12
      ARM: at91: enable wm8904 on at91sam9n12ek board
      ARM: at91: enable ssc on at91sam9n12ek board
      ARM: at91: add sound support on at91sam9n12ek board

Chao Fu (2):
      ARM: dts: vf610: Add DSPI nodes
      ARM: dts: vf610-twr: Enable DSPI0 devices and Flash at26df081a

Christian Daudt (1):
      ARM: dts: rename ARCH_BCM to ARCH_BCM_MOBILE (dt)

Dan Murphy (1):
      ARM: dts: AM33XX: add ethernet alias's for am33xx

Darren Etheridge (2):
      ARM: dts: AM33XX beagle black: add pinmux and hdmi node to enable display
      ARM: dts: am335x-evm: Add audio support for am335x-evm.dts

Dinh Nguyen (2):
      arm: socfpga: Add clock for smp_twd timer
      dts: socfpga: Add support for Altera's SOCFPGA Arria V board

Dong Aisheng (2):
      ARM: dts: imx6qdl: add uhs pinctrl state for usdhc3
      ARM: dts: imx6sl: add pinctrl uhs states for usdhc

Enric Balletbo i Serra (3):
      ARM: dts: AM33XX: Add support for IGEP COM AQUILA
      ARM: dts: AM33XX: Add support for IGEP AQUILA EXPANSION board.
      ARM: dts: igep0033: Add mmc1 node for SDCARD support.

Eric Witcher (1):
      ARM: dts: omap5-uevm: fix mcspi node pin descriptions

Ezequiel Garcia (3):
      ARM: mvebu: Add Core Divider clock device-tree binding
      ARM: mvebu: Add a 2 GHz fixed-clock Armada 370/XP
      ARM: mvebu: Add the core-divider clock to Armada 370/XP

Fabio Estevam (17):
      ARM: dts: imx6qdl-wandboard: Add usbotg support
      ARM: dts: imx28-evk: Allow usb peripheral mode to work
      ARM: dts: imx53-qsb: Allow usb peripheral mode to work
      ARM: dts: imx6q-sabrelite: Put the nodes in alphabetical order
      ARM: dts: imx6q-sabrelite: Add LVDS support
      ARM: imx6qdl-wandboard: Add spdif support
      ARM: dts: imx6sl: Add spi aliases
      ARM: dts: imx6qdl-sabresd: SDHC ports are 8 bit-wide
      ARM: dts: imx28-evk: Enable touchscreen support
      ARM: dts: imx6q-udoo: Add initial board support
      ARM: dts: imx6q-sabrelite: Add ethernet phy reset pin into hog
      ARM: dts: imx6qdl-sabresd: Provide phy-reset-gpios
      ARM: dts: imx6qdl-wandboard: Provide phy-reset-gpios
      ARM: dts: imx53-qsb: SDHC3 is connected in 8-bit mode
      ARM: dts: imx53-qsb: SDHC1 does not have cd-gpios
      ARM: dts: imx53-qsb: Do not use GPIO1_8 as wakeup source
      ARM: dts: imx51-babbage: Make DVI and WVGA panel functional

Felipe Balbi (2):
      ARM: dts: OMAP5: add palmas-usb node
      ARM: configs: omap2plus_defconfig: enable dwc3 and dependencies

Fugang Duan (1):
      ARM: dts: add iomuxc-gpr device node for imx6sl

George Cherian (1):
      ARM: dts: OMAP5: Add dr_mode for dwc3

Gregory CLEMENT (1):
      ARM: dts: mvebu: Update with the new compatible string for mv64xxx-i2c

Guennadi Liakhovetski (5):
      ARM: shmobile: ape6evm-reference: add MMCIF and SDHI DT nodes
      ARM: shmobile: only enable used I2C interfaces in DT on all Renesas boards
      ARM: shmobile: r8a7790: add I2C DT nodes
      ARM: shmobile: r8a73a4: add a DT node for the DMAC
      ARM: shmobile: armadillo800eva-reference: add SDHI and MMCIF interfaces

Gwenhael Goavec-Merou (2):
      ARM: imx51-apf51dev: Add parallel display support
      ARM: imx27-apf27dev: Add framebuffer support

Hiroshi Doyu (1):
      ARM: tegra: fix Tegra114 IOMMU register address

Huang Shijie (2):
      ARM: dts: imx6sl: add a pinctrl for ECSPI1
      ARM: dts: imx6sl-evk: enable the SPI NOR

J Keerthy (3):
      ARM: dts: dra7-evm: add smps123 supply for CPU
      ARM: dts: OMAP5: Add CPU OPP table
      ARM: dts: DRA7: Add CPU OPP table

Jason Gunthorpe (3):
      ARM: kirkwood: Remove kirkwood_setup_wins and rely on the DT binding
      ARM: kirkwood: Move the crypto node under the mbus node
      ARM: kirkwood: Move the nand node under the mbus node

Javier Martinez Canillas (11):
      ARM: dts: omap3-igep: add pinmux node for GPIO LED configuration
      ARM: dts: omap3-igep0020: add mux conf for GPIO LEDs
      ARM: dts: omap3-igep0030: add mux conf for GPIO LED
      ARM: OMAP2+: pdata-quirks: add legacy display init for IGEPv2 board
      ARM: OMAP2+: igep0020: use display init from dss-common
      ARM: dts: AM33XX: use pinmux node defined in included file
      ARM: dts: AM33XX: don't redefine OCP bus and device nodes
      ARM: dts: omap3-igep: Add USB OTG support
      ARM: dts: omap3-igep0020: Add HS USB Host support
      ARM: dts: omap3-igep0020: use standard constant for IRQ flags
      ARM: OMAP2+: remove legacy support for IGEP boards

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: remove pinctrl conflict between mmc and SPI for at91sam9g20ek

Jean-Francois Moine (3):
      ARM: Dove: Add the audio devices in DT
      ARM: Dove: Add the audio device to the Cubox DT
      ARM: Dove: fix bad properties of the si5351 clkout2 used by Cubox audio

Jiansong Chen (1):
      ARM: dts: sirf: add missed graphics2d iobg in atlas6 dts

Jingoo Han (1):
      ARM: dts: use 'status' property for PCIe nodes

Joel Fernandes (5):
      ARM: dts: OMAP4: Add AES node
      ARM: dts: OMAP4: Add DES3DES node
      ARM: dts: AM33XX: Fix AES interrupt number
      ARM: dts: AM437X: Add AES node
      ARM: dts: AM437X: Add DES node

Joseph Lo (4):
      ARM: tegra: Add initial device tree for Tegra124
      ARM: tegra: add Venice2 board support
      ARM: tegra: enable Tegra RTC as default for Tegra124
      ARM: tegra: enable LP1 suspend mode for Venice2

Jyri Sarha (1):
      ARM: dts: AM33XX: mcasp: Add location for data port registers to reg-property

Keerthy (1):
      ARM: dts: DRA7: Add TPS659038 PMIC nodes

Kevin Hilman (10):
      Merge tag 'dt-3.13' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'dt-3.13-2' of git://git.infradead.org/linux-mvebu into next/dt
      Merge branch 'renesas/dt2' into next/dt
      Merge tag 'socfpga-dts-updates-for-v3.13' of git://git.rocketboards.org/linux-socfpga-next into next/dt
      Merge tag 'omap-for-v3.13/quirk-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'omap-for-v3.13/dt-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'dt-3.13-3' of git://git.infradead.org/linux-mvebu into next/dt
      Merge branch 'tegra/dt' into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'omap-for-v3.13/board-removal-signed-take2' of git://git.kernel.org/.../tmlind/linux-omap into next/dt

Kishon Vijay Abraham I (2):
      ARM: dts: omap5-uevm: Split SMPS10 in two nodes
      ARM: dts: omap5-uevm: remove always_on, boot_on from smps10_out1

Koen Kooi (3):
      ARM: dts: am335x-boneblack: add eMMC DT entry
      ARM: dts: am335x-bone-common: switch mmc1 to 4-bit mode
      ARM: dts: am335x-bone-common: add cpu0 and mmc1 triggers

Kuninori Morimoto (5):
      ARM: shmobile: r8a7778: add renesas_intc_irqpin support on DTSI
      ARM: shmobile: bockw: add SMSC support on DTS
      ARM: shmobile: marzen: fixup SMSC IRQ number on DTS
      ARM: shmobile: r8a7779: add irqpin default status on DTSI
      ARM: shmobile: bockw: fixup ether node naming

Lars Poeschel (1):
      ARM: dts: AM33xx: Correct gpio #interrupt-cells property

Laurent Pinchart (1):
      ARM: shmobile: armadillo-reference: Add PWM backlight node to DT

Laxman Dewangan (2):
      ARM: tegra: add palmas pincontrol to Dalmore device tree
      ARM: tegra: use dt-binding header for key code

Lee Jones (95):
      ARM: ux500: Remove PrimeCell IDs from Nomadik I2C DT nodes
      mfd: dbx500-prcmu: Correctly reorder PRCMU clock identifiers
      mfd: dbx500-prcmu: Move PRCMU numerical clock identifiers into DT include file
      mfd: dbx500: Remove any mention of the BML8580CLK
      ARM: ux500: Add PRCMU clock node to DBx500 Device Tree
      ARM: ux500: Supply the DMA clock lookup to the DBX500 DT
      ARM: ux500: Add PRCC Peripheral clock node to DBx500 Device Tree
      ARM: ux500: Supply the GPIO clocks lookup to the DBX500 DT
      ARM: ux500: Supply the USB clock lookup to the DBX500 DT
      ARM: ux500: Supply the Ethernet clock lookup to Snowball's DT
      ARM: ux500: Add PRCC Kernel clock node to DBx500 Device Tree
      ARM: ux500: Supply the I2C clocks lookup to the DBX500 DT
      ARM: ux500: Supply the UART clocks lookup to the DBX500 DT
      ARM: ux500: Supply the SDI (MMC) clocks lookup to the DBX500 DT
      ARM: ux500: Supply the MSP (Audio) clocks lookup to the DBX500 DT
      ARM: ux500: Add RTC (fixed-frequency) clock node to DBx500 Device Tree
      ARM: ux500: Supply the RTC clock lookup to the DBX500 DT
      ARM: ux500: Add TWD (fixed-factor) clock node to DBx500 Device Tree
      ARM: ux500: Supply the TWD Timer clock lookup to the DBX500 DT
      ARM: ux500: Add a DT node for the Nomadik System Timer (MTU0)
      ARM: ux500: Don't attempt to enable the Nomadik System Timer twice
      clk: ux500: Remove BML8580 clock
      clk: ux500: Copy u8500_clk_init() ready for DT enablement
      clk: ux500: Provide u8500_clk with skeleton Device Tree support
      clk: ux500: Add a 2-cell Device Tree parser for obtaining PRCC clocks
      clk: ux500: Add Device Tree support for the PRCMU clock
      clk: ux500: Add Device Tree support for the PRCC Peripheral clock
      clk: ux500: Add Device Tree support for the PRCC Kernel clock
      clk: ux500: Add Device Tree support for the RTC clock
      clk: ux500: Add Device Tree support for the TWD clock
      usb: musb: ux500: Don't supply a con_id when requesting the clock
      ARM: ux500: Call appropriate clock initialisation based on DT or !DT booting
      ARM: ux500: Remove AUXDATA relating to GPIO clock-name bindings
      ARM: ux500: Remove AUXDATA relating to UART clock-name bindings
      ARM: ux500: Remove AUXDATA relating to I2C clock-name bindings
      ARM: ux500: Relocate AUXDATA relating to MSP (Audio)
      ARM: ux500: Remove AUXDATA relating to SDI (MMC) clock-name bindings
      ARM: ux500: Remove AUXDATA relating to USB clock-name bindings
      ARM: ux500: Remove AUXDATA relating to Ethernet clock-name bindings
      ARM: ux500: Remove AUXDATA relating to DMA clock-name bindings
      ARM: ux500: Reclassify PRCMU AUXDATA entry
      ARM: ux500: Remove SSP AUXDATA pertaining to DMA bindings
      ARM: ux500: Remove Audio/MSP support when booting with ATAGs
      ARM: ux500: Remove TPS61052 High Power White LED Driver ATAG support
      ARM: ux500: Remove ATAG support for LP5521 Programmable Three-Channel LED driver
      ARM: ux500: Remove ATAG booting support for Snowball's heatbeat LED
      ARM: ux500: Purge support for Snowball user buttons when booting with ATAGs
      ARM: ux500: Disable Snowball's SMSC911x Ethernet when booting with ATAGs
      ARM: ux500: Remove support for Snowball's Ethernet regulator when booting with ATAGs
      ARM: ux500: Disable Snowball's CPUFreq functionality when booting with ATAGs enabled
      ARM: ux500: Purge SDI regulator support when booting with ATAGs enable
      ARM: ux500: Deactivate Crypt support when booting with ATAGs
      ARM: ux500: Rip out Hash support when booting with ATAGs
      ARM: ux500: Prevent CODEC platform data from being passed when booting ATAGs
      ARM: ux500: Stop passing GPIO pdata when booitng with ATAGs enabled
      ARM: ux500: Remove TC35892 Flexible IO Expander when booting ATAGs
      ARM: ux500: Remove Light sensor Rohm BH1780GLI when booting with ATAGs
      ARM: ux500: Purge SFH7741 Proximity Sensor support when booting with ATAGs
      ARM: ux500: Remove I2C support when booting with ATAG support
      ARM: ux500: Purge SDI support for ATAG booting
      ARM: ux500: Rip out keypad initialisation which is no longer used
      ARM: ux500: Remove USB support when booting using ATAGs
      ARM: ux500: Purge support for registering the RTC when booting with ATAGs
      ARM: ux500: Stop registering Pinctrl when booting with ATAG support
      ARM: ux500: Stop enabling GPIOs when not booting with Device Tree
      ARM: ux500: Deactivate enablement of DMA40 during ATAG booting
      ARM: ux500: Do not register the PMU device if booting with ATAGs
      ARM: ux500: Rip out SSP/SPI registration when not booting with Device Tree
      ARM: ux500: Stop initialising the pinmaps when booting with ATAGs
      ARM: ux500: Remove UART support when booting without Device Tree
      ARM: ux500: Stop requesting the SoC device to play 'parent' role
      ARM: ux500: Purge DB8500 PRCMU registration when not booting with DT
      ARM: ux500: Don't register Synaptics RMI4 TS when booting with ATAGs
      ARM: ux500: Delete U8500 UIB support when booting with ATAGs
      ARM: ux500: Don't register the STMPE/SKE when booting with ATAG support
      ARM: ux500: Remove BU21013 ROHM TS support when booting with only ATAGs
      ARM: ux500: Take out STUIB support when not booting with Device Tree
      ARM: ux500: Purge UIB framework when booting with ATAGs
      ARM: ux500: Remove ATAG booting support for MOP500
      ARM: ux500: Remove ATAG booting support for U8520
      ARM: ux500: Remove ATAG booting support for HREF
      ARM: ux500: Remove ATAG booting support for Snowball
      ARM: ux500: Fix trivial white-space error in the DBX500 DTSI file
      ARM: ux500: Provide a clock lookup for the Crypto driver
      ARM: ux500: Provide a clock lookup for the Hash driver
      ARM: ux500: Provide a Device Tree node for CPUFreq in the DBx500
      ARM: ux500: Enable CPUFreq on Snowball
      clk: ux500: Provide a look-up for the ARMSS clock
      ARM: dts: Remove '0x's from OMAP2420 H4 DTS file
      ARM: dts: Remove '0x's from OMAP3 IGEP0020 DTS file
      ARM: dts: Remove '0x's from OMAP3 IGEP0030 DTS file
      ARM: dts: Remove '0x's from OMAP3 DTS file
      ARM: dts: Remove '0x's from OMAP3430 SDP DTS file
      ARM: dts: Remove '0x's from OMAP4 DTS file
      ARM: dts: Remove '0x's from OMAP5 DTS file

Linus Walleij (18):
      ARM: ux500: delete surplus PRCMU regulator defines
      ARM: ux500: skip redefined regulator names on v60plus board
      ARM: ux500: delete devices-common remnants
      ARM: ux500: add default trigger on HREF LED
      ARM: ux500 enable the AB8500 gpio for all HREFs
      ARM: ux500: correct I2C address of ambient light sensor
      ARM: ux500: fix proximity sensor button
      ARM: ux500: correct CD for micro SD on hrev60plus
      ARM: ux500: move TC35892 at 0x42 to hrefprev60
      ARM: ux500: split HREF UIB files
      ARM: ux500: split the HREF DTS files from two to four
      ARM: ux500: register the tc35892 GPIO on the TVK UIB
      ARM: ux500: move BU21013 touchpad GPIOs into top-level DTS
      ARM: ux500: fix clock for GPIO block 8
      clk: ux500: fix erroneous bit assignment
      ARM: ux500: fix clock for GPIO blocks 6 and 7
      ARM: ux500: fix I2C4 clock bit
      ARM: ux500: register all SSP and SPI blocks

Lokesh Vutla (2):
      ARM: dts: AM4372: Add L2, EDMA, mailbox, MMC and SHAM nodes
      ARM: dts: AM33xx: Add RNG node

Lothar Waßmann (5):
      ARM: dts: mxs: add pinctrl header files
      ARM: dts: mxs: modify mx23/mx28 dts files to use pinctrl headers
      ARM: dts: mxs: modify mx23/mx28 dts files to use padconfig defines
      ARM: dts: tx28: restructure and update DTS file
      ARM: dts: mxs: convert usb0_id_pins_a to use symbolic pin defs

Luka Perkov (1):
      ARM: kirkwood: ib62x0: add u-boot environment partition

Magnus Damm (5):
      ARM: shmobile: Add r8a7790 CA15 CPU cores
      ARM: shmobile: Add r8a7790 CA7 CPU cores to DTSI
      ARM: shmobile: r8a7791 IRQC device tree node
      ARM: shmobile: r8a7791 Arch timer device tree node
      ARM: shmobile: r8a7791 SMP device tree node

Marek Belisko (1):
      ARM: dts: Add devicetree for gta04 board.

Marek Vasut (2):
      ARM: dts: mxs: Add muxing options for the SSP2 MMC
      ARM: dts: mxs: Add MSR M28CU3 board

Mark A. Greer (2):
      ARM: dts: AM33XX: Add SHAM data and documentation
      ARM: dts: AM33XX: Add AES data and documentation

Mark Brown (1):
      ARM: dts: Disable Exynos5250 I2S controllers by default

Mark Jackson (1):
      ARM: dts: Add support for Newflow NanoBone board

Markus Mayer (2):
      ARM: bcm281xx: Add device node for the GPIO controller
      ARM: dts: bcm281xx: Add card detect GPIO

Markus Pargmann (1):
      ARM: dts: am33xx, change usb ctrl module label

Matt Porter (5):
      ARM: dts: add initial VF610 Cosmic/Cosmic+ board support
      ARM: dts: AM33XX: Add EDMA support
      ARM: dts: AM33XX: Add SPI DMA support
      ARM: dts: AM33XX: Add MMC support and documentation
      ARM: dts: bcm11351: Use GIC/IRQ defines for sdio interrupts

Maxime Ripard (5):
      ARM: sun7i: Enable the I2C controllers
      ARM: sun7i: Add the pin muxing options for the I2C controllers
      ARM: sun7i: cubieboard2: Enable the I2C controllers
      ARM: sun7i: olinuxino-micro: Enable the I2C controllers
      ARM: sun6i: Fix the APB2 clock gates register size

Mugunthan V N (1):
      ARM: dts: AM4372: Update Support for EPOS EVM

Nishanth Menon (9):
      ARM: dts: am335x-boneblack: move fixed regulator to board level
      ARM: dts: omap5-uevm: mark TWL6037 as system-power-controller
      ARM: dts: omap4-panda-es: Do not reset gpio1
      ARM: dts: OMAP3+: Add i2c aliases
      ARM: dts: AM33xx+: Add i2c aliases
      ARM: OMAP3+: do not register non-dt OPP tables for device tree boot
      ARM: OMAP2+: add missing lateinit hook for calling pm late init
      ARM: OMAP3+: use cpu0-cpufreq driver in device tree supported boot
      ARM: dts: omap5-uevm: add smps123 supply for CPU

Oliver Schinagl (2):
      ARM: sunxi: dt: Add sunxi-sid to dts for sun4i, sun5i and sun7i
      ARM: sunxi: dts: Add support for the cubieboard3, the CubieTruck

Olof Johansson (19):
      Merge tag 'samsung-dt-s3c64xx' of http://git.kernel.org/.../kgene/linux-samsung into next/dt
      ARM: ux500: enable appended dtb in u8500_defconfig
      Merge tag 'ux500-dt-for-v3.13-2' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge branch 'ux500/dt' into next/dt
      Merge tag 'ux500-devicetree-2' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'renesas-dt-for-v3.13' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'omap-for-v3.13/pinctrl-fix' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'sunxi-dt-for-3.13' of https://github.com/mripard/linux into next/dt
      Merge tag 'sunxi-fixes-for-3.13' of https://github.com/mripard/linux into next/dt
      Merge tag 'ux500-dt-for-v3.13-3' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge most of tag 'tags/exynos-dt' of git://git.kernel.org/.../kgene/linux-samsung.git into next/dt
      Merge tag 'imx-dt-3.13' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'dt-3.13-4' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'omap-for-v3.13/cpufreq-late' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'omap-for-v3.13/dt-late' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge branch 'sirf/dt' into next/dt
      Merge tag 'omap-for-v3.13/dt-fixes-for-merge-window' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge branch 'bcm/dt' into next/dt
      Merge tag 'dt-3.13-5' of git://git.infradead.org/linux-mvebu into next/dt

Pantelis Antoniou (1):
      ARM: dts: AM33XX: Add mcasp0 and mcasp1 device tree entries

Pavel Machek (1):
      ARM: dts: N900: Add device tree

Peter Chen (1):
      ARM: imx: mx6sl-evk: Enable USB function

Peter Ujfalusi (4):
      ARM: dts: am335x-evmsk: Audio support
      ARM: dts: AM4372: Add McASP nodes
      ARM: dts: omap5-uevm: Correct twl6040 reset GPIO pinmux
      ARM: dts: omap5-uevm: Remove pinmux for dmic pins

R Sricharan (1):
      ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board

Rahul Sharma (4):
      of/documentation: update with clock information for exynos hdmi subsystem
      ARM: dts: add clocks to hdmi dt node for exynos5250
      ARM: dts: add dt nodes for hdmi subsystem for exynos5420
      ARM: dts: enable hdmi subsystem for exynos5420 smdk board

Rajendra Nayak (2):
      ARM: dts: omap: Add reset/idle on init bindings for OMAP
      ARM: dts: am335x-evmsk: Do not reset gpio0

Renwei Wu (1):
      ARM: dts: sirf: add missed address-cells and size-cells for prima2 I2C

Roger Quadros (8):
      ARM: dts: omap3-beagle: Make USB host pin naming consistent
      ARM: dts: omap3-beagle: Use reset-gpios for hsusb2_reset
      ARM: dts: omap4-panda: Use reset-gpios for hsusb1_reset
      ARM: dts: omap5-uevm: Use reset-gpios for hsusb2/3_reset
      ARM: dts: omap3-beagle-xm: Add USB Host support
      ARM: dts: omap3-beagle: Add USB OTG PHY details
      ARM: dts: omap3: Adapt USB OTG to generic PHY framework
      ARM: dts: omap3-beagle: Adapt USB OTG to generic PHY framework

Rogerio Pimentel (1):
      ARM: dts: imx6qdl-sabresd: Add backlight support for lvds

Ruslan Bilovol (1):
      ARM: dts: twl6030: Move common configuration for OMAP4 boards in a separate dtsi file

Sachin Kamat (3):
      ARM: dts: Add fixed voltage regulator to simple bus for origen
      ARM: dts: Add reg property to regulator nodes in exynos5250-arndale
      ARM: dts: Add HDMI related I2C nodes for Arndale board

Sean Cross (1):
      ARM: dts: imx6qdl: add pcie device node

Sean Paul (1):
      ARM: dts: add mixer clocks to mixer node for Exynos5250

Sebastian Andrzej Siewior (1):
      dt: dbx5x0: remove mentor,musb binding

Sebastian Hesselbarth (6):
      ARM: dove: use preprocessor on device tree files
      ARM: dove: add MBUS_ID macro to Dove DT
      ARM: dove: add MBus DT node
      ARM: dove: relocate internal registers device nodes
      ARM: dove: add PCIe controllers to SoC DT
      ARM: dove: add initial DT file for Globalscale D3Plug

Sebastian Reichel (14):
      ARM: dts: omap3-n900: Add pinctrl for i2c devices
      ARM: dts: omap3-n900: Fix i2c bus speed
      ARM: dts: omap3-n900: Add UART support
      ARM: dts: omap3-n900: Add support for SD cards
      ARM: dts: omap3-n900: GPIO key definitions
      ARM: dts: omap3-n900: Add vibrator device
      ARM: dts: omap3-n900: Add LP5523 support
      ARM: dts: TWL4030: Add missing regulators
      ARM: dts: omap3-n900: Specify regulator info
      ARM: dts: omap3-n900: Add NAND support
      ARM: dts: omap3-n900:: Mux RX51_LCD_RESET_GPIO in DTS
      ARM: dts: omap3-n900: Add TLV320AIC3X support
      ARM: dts: omap3-n900: Add LP5523 support
      ARM: dts: TWL4030: Add power button support

Shawn Guo (3):
      ARM: dts: imx6sl reuses imx6q sdma firmware
      ARM: dts: imx6q: add quirky select input for USB_OTG_ID
      ARM: imx: imx6sl iomuxc syscon is compatible to imx6q

Simon Horman (1):
      Merge tag 'renesas-soc-for-v3.13' into dt2-base

Sricharan R (1):
      ARM: dts: OMAP5: Remove clock-frequency field for cpu timers

Steffen Trumtrar (5):
      ARM: socfpga: dts: Move common nodes to cyclone5 dtsi
      ARM: socfpga: dts: Add support for terasic SoCkit
      ARM: socfpga: dts: cleanup indentation
      ARM: socfpga: dts: fix s2f_* clock name
      ARM: imx27: add missing #pwm-cells property

Stephen Warren (1):
      ARM: tegra: add GPIO controller to tegra124.dtsi

Suman Anna (3):
      ARM: dts: OMAP4: Add hwspinlock node
      ARM: dts: OMAP5: Add hwspinlock node
      ARM: dts: AM33XX: Add hwspinlock node

Sylwester Nawrocki (1):
      ARM: dts: Add MIPI PHY node to exynos4.dtsi

Thierry Reding (2):
      ARM: tegra: Mark Tegra30 display controller compatible with Tegra20
      ARM: tegra: Use symbolic names for gr3d clocks

Thomas Petazzoni (4):
      ARM: mvebu: the MPIC now provides MSI controller features
      ARM: mvebu: link PCIe controllers to the MSI controller
      arm: mvebu: add support for the Armada XP Matrix board
      ARM: kirkwood: add support for OpenBlocks A7 platform

Tim Kryger (1):
      ARM: dts: bcm: Add missing UARTs for bcm11351 (bcm281xx)

Tomasz Figa (7):
      irqchip: vic: Parse interrupt and resume masks from device tree
      ARM: S3C64XX: Bypass legacy initialization when booting with DT
      gpio: samsung: Skip initialization if device tree is present
      ARM: S3C64XX: Add board file for boot using Device Tree
      ARM: dts: Add basic dts include files for Samsung S3C64xx SoCs
      ARM: dts: Add dts file for S3C6410-based Mini6410 board
      ARM: dts: Add dts file for S3C6410-based SMDK6410 board

Tomi Valkeinen (1):
      ARM: dts: omap4-panda: add DPI pinmuxing

Tony Lindgren (26):
      ARM: OMAP2+: Always build in board-generic
      ARM: OMAP2+: Add quirk support for legacy platform data init
      ARM: OMAP2+: Use pdata quirk support for board-generic.c
      ARM: OMAP2+: Use pdata quirks for wl12xx legacy init
      pinctrl: single: Prepare for supporting SoC specific features
      pinctrl: single: Add support for wake-up interrupts
      pinctrl: single: Add support for auxdata
      Merge tag 'pinctrl-single-for-linus-for-v3.13-signed' into omap-for-v3.13/quirk
      ARM: OMAP2+: Add support for auxdata
      ARM: OMAP: Move DT wake-up event handling over to use pinctrl-single-omap
      ARM: OMAP2+: Use pdata quirks for wl12xx for omap3 evm and zoom3
      ARM: OMAP2+: Add minimal 8250 support for GPMC
      ARM: OMAP2+: Run make savedefconfig on omap2plus_defconfig to shrink it
      ARM: OMAP2+: Add WLAN modules and of_serial to omap2plus_defconfig
      Merge tag 'for_3.13/dts_signed' of git://git.kernel.org/.../bcousson/linux-omap-dt into omap-for-v3.13/dt
      Merge branches 'omap-for-v3.13/dt' and 'omap-for-v3.13/quirk' into omap-for-v3.13/board-removal
      ARM: dts: Shared file for omap GPMC connected smsc911x
      ARM: dts: Add common support for omap3-evm
      ARM: dts: Add basic support for TMDSEVM3730 (Mistral AM/DM37x EVM)
      ARM: dts: Add basic support for zoom3
      ARM: OMAP2+: Remove legacy booting support for omap3 EVM
      ARM: OMAP2+: Remove legacy support for zoom platforms
      pinctrl: single: Fix build when not built on ARM
      Merge tag 'for_3.13_late/dts_signed' of git://git.kernel.org/.../bcousson/linux-omap-dt into omap-for-v3.13/dt
      ARM: dts: Add missing reg, interrupt and dma entries for omap3
      Merge tag 'for_3.13_super_late/dts_signed' of git://git.kernel.org/.../bcousson/linux-omap-dt into omap-for-v3.13/dt

Wei Ni (2):
      ARM: tegra: add DT entry for nct1008 to Dalmore
      ARM: tegra: add vcc supply for nct1008 to Cardhu

Ye He (1):
      ARM: dts: sirf: add missed memcontrol-monitor node in prima2 and atlas6 dts


 .../devicetree/bindings/arm/omap/omap.txt       |    3 +-
 Documentation/devicetree/bindings/arm/vic.txt   |   12 +
 .../bindings/clock/mvebu-corediv-clock.txt      |   19 +
 .../devicetree/bindings/crypto/omap-aes.txt     |   31 +
 .../devicetree/bindings/crypto/omap-sham.txt    |   28 +
 .../devicetree/bindings/hwrng/omap_rng.txt      |   22 +
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt   |   26 +-
 .../bindings/pinctrl/fsl,mxs-pinctrl.txt        |  859 +--------------
 .../bindings/pinctrl/pinctrl-single.txt         |   11 +
 .../devicetree/bindings/usb/ux500-usb.txt       |    2 +-
 .../devicetree/bindings/video/exynos_hdmi.txt   |   14 +-
 .../devicetree/bindings/video/exynos_mixer.txt  |    4 +
 MAINTAINERS                                     |    8 +-
 arch/arm/boot/dts/Makefile                      |   44 +-
 arch/arm/boot/dts/am335x-base0033.dts           |   16 +
 arch/arm/boot/dts/am335x-bone-common.dtsi       |  311 +++---
 arch/arm/boot/dts/am335x-bone.dts               |   18 +
 arch/arm/boot/dts/am335x-boneblack.dts          |   61 ++
 arch/arm/boot/dts/am335x-evm.dts                |  771 +++++++------
 arch/arm/boot/dts/am335x-evmsk.dts              |  474 ++++----
 arch/arm/boot/dts/am335x-igep0033.dtsi          |  278 +++++
 arch/arm/boot/dts/am335x-nano.dts               |  431 ++++++++
 arch/arm/boot/dts/am33xx.dtsi                   |  155 ++-
 arch/arm/boot/dts/am4372.dtsi                   |  599 ++++++++++
 arch/arm/boot/dts/am43x-epos-evm.dts            |  168 +++
 arch/arm/boot/dts/armada-370-netgear-rn104.dts  |  193 ++++
 arch/arm/boot/dts/armada-370-xp.dtsi            |   20 +-
 arch/arm/boot/dts/armada-370.dtsi               |    9 +
 arch/arm/boot/dts/armada-xp-matrix.dts          |   75 ++
 arch/arm/boot/dts/armada-xp-mv78230.dtsi        |    1 +
 arch/arm/boot/dts/armada-xp-mv78260.dtsi        |    1 +
 arch/arm/boot/dts/armada-xp-mv78460.dtsi        |    1 +
 arch/arm/boot/dts/armada-xp.dtsi                |   10 +
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi     |    1 -
 arch/arm/boot/dts/at91sam9n12.dtsi              |    3 +
 arch/arm/boot/dts/at91sam9n12ek.dts             |   34 +
 arch/arm/boot/dts/atlas6.dtsi                   |   33 +-
 arch/arm/boot/dts/bcm11351-brt.dts              |    1 +
 arch/arm/boot/dts/bcm11351.dtsi                 |   54 +-
 arch/arm/boot/dts/bcm28155-ap.dts               |    1 +
 arch/arm/boot/dts/dove-cm-a510.dts              |    2 +-
 arch/arm/boot/dts/dove-cubox.dts                |   20 +-
 arch/arm/boot/dts/dove-d2plug.dts               |    2 +-
 arch/arm/boot/dts/dove-d3plug.dts               |  103 ++
 arch/arm/boot/dts/dove-dove-db.dts              |    2 +-
 arch/arm/boot/dts/dove.dtsi                     | 1037 ++++++++++--------
 arch/arm/boot/dts/dra7-evm.dts                  |  275 +++++
 arch/arm/boot/dts/dra7.dtsi                     |  586 ++++++++++
 arch/arm/boot/dts/exynos4.dtsi                  |   10 +
 arch/arm/boot/dts/exynos4210-origen.dts         |   21 +-
 arch/arm/boot/dts/exynos4412-origen.dts         |   21 +-
 arch/arm/boot/dts/exynos5250-arndale.dts        |   33 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts       |    8 -
 arch/arm/boot/dts/exynos5250.dtsi               |   11 +-
 arch/arm/boot/dts/exynos5420-smdk5420.dts       |   26 +
 arch/arm/boot/dts/exynos5420.dtsi               |   75 ++
 arch/arm/boot/dts/exynos5440-ssdk5440.dts       |    2 +
 arch/arm/boot/dts/exynos5440.dtsi               |    2 +
 arch/arm/boot/dts/imx23-evk.dts                 |   16 +-
 arch/arm/boot/dts/imx23-olinuxino.dts           |   18 +-
 arch/arm/boot/dts/imx23-pinfunc.h               |  333 ++++++
 arch/arm/boot/dts/imx23-stmp378x_devb.dts       |   12 +-
 arch/arm/boot/dts/imx23.dtsi                    |  221 ++--
 arch/arm/boot/dts/imx27-apf27dev.dts            |   26 +
 arch/arm/boot/dts/imx27.dtsi                    |    1 +
 arch/arm/boot/dts/imx28-apf28.dts               |    2 +-
 arch/arm/boot/dts/imx28-apf28dev.dts            |   36 +-
 arch/arm/boot/dts/imx28-apx4devkit.dts          |   60 +-
 arch/arm/boot/dts/imx28-cfa10036.dts            |   26 +-
 arch/arm/boot/dts/imx28-cfa10037.dts            |   18 +-
 arch/arm/boot/dts/imx28-cfa10049.dts            |  156 +--
 arch/arm/boot/dts/imx28-cfa10055.dts            |   80 +-
 arch/arm/boot/dts/imx28-cfa10056.dts            |   38 +-
 arch/arm/boot/dts/imx28-cfa10057.dts            |   66 +-
 arch/arm/boot/dts/imx28-cfa10058.dts            |   24 +-
 arch/arm/boot/dts/imx28-evk.dts                 |   59 +-
 arch/arm/boot/dts/imx28-m28cu3.dts              |  266 +++++
 arch/arm/boot/dts/imx28-m28evk.dts              |   28 +-
 arch/arm/boot/dts/imx28-pinfunc.h               |  506 +++++++++
 arch/arm/boot/dts/imx28-sps1.dts                |   14 +-
 arch/arm/boot/dts/imx28-tx28.dts                |  703 ++++++++++--
 arch/arm/boot/dts/imx28.dtsi                    |  620 ++++++-----
 arch/arm/boot/dts/imx51-apf51dev.dts            |   27 +
 arch/arm/boot/dts/imx51-babbage.dts             |   37 +-
 arch/arm/boot/dts/imx51.dtsi                    |   23 +
 arch/arm/boot/dts/imx53-qsb.dts                 |    9 +-
 arch/arm/boot/dts/imx6q-pinfunc.h               |    4 +-
 arch/arm/boot/dts/imx6q-sabrelite.dts           |  104 +-
 arch/arm/boot/dts/imx6q-udoo.dts                |   39 +
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi        |    5 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi          |   18 +
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi        |   23 +
 arch/arm/boot/dts/imx6qdl.dtsi                  |   67 ++
 arch/arm/boot/dts/imx6sl-evk.dts                |   67 +-
 arch/arm/boot/dts/imx6sl.dtsi                   |  172 ++-
 arch/arm/boot/dts/kirkwood-db-88f6281.dts       |    1 -
 arch/arm/boot/dts/kirkwood-db-88f6282.dts       |    1 -
 arch/arm/boot/dts/kirkwood-db.dtsi              |   44 +-
 arch/arm/boot/dts/kirkwood-dnskw.dtsi           |   76 +-
 arch/arm/boot/dts/kirkwood-dockstar.dts         |   40 +-
 arch/arm/boot/dts/kirkwood-goflexnet.dts        |   51 +-
 .../boot/dts/kirkwood-guruplug-server-plus.dts  |   40 +-
 arch/arm/boot/dts/kirkwood-ib62x0.dts           |   53 +-
 arch/arm/boot/dts/kirkwood-iconnect.dts         |   59 +-
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts   |   51 +-
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts      |   14 +-
 arch/arm/boot/dts/kirkwood-mplcec4.dts          |   63 +-
 .../dts/kirkwood-netgear_readynas_duo_v2.dts    |   61 +-
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi   |   86 +-
 arch/arm/boot/dts/kirkwood-nsa310.dts           |    1 -
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts    |   74 +-
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts    |  223 ++++
 .../boot/dts/kirkwood-sheevaplug-common.dtsi    |   42 +-
 arch/arm/boot/dts/kirkwood-topkick.dts          |   62 +-
 arch/arm/boot/dts/kirkwood-ts219-6282.dts       |    1 -
 arch/arm/boot/dts/kirkwood.dtsi                 |   57 +-
 arch/arm/boot/dts/mxs-pinfunc.h                 |   31 +
 arch/arm/boot/dts/omap-gpmc-smsc911x.dtsi       |   52 +
 arch/arm/boot/dts/omap-zoom-common.dtsi         |   33 +
 arch/arm/boot/dts/omap2420-h4.dts               |    6 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts           |   65 +-
 arch/arm/boot/dts/omap3-beagle.dts              |   46 +-
 arch/arm/boot/dts/omap3-devkit8000.dts          |    2 +-
 arch/arm/boot/dts/omap3-evm-37xx.dts            |  151 +++
 arch/arm/boot/dts/omap3-evm-common.dtsi         |   94 ++
 arch/arm/boot/dts/omap3-evm.dts                 |   60 +-
 arch/arm/boot/dts/omap3-gta04.dts               |  170 +++
 arch/arm/boot/dts/omap3-igep.dtsi               |   11 +
 arch/arm/boot/dts/omap3-igep0020.dts            |  107 +-
 arch/arm/boot/dts/omap3-igep0030.dts            |   17 +-
 arch/arm/boot/dts/omap3-n9.dts                  |   18 +
 arch/arm/boot/dts/omap3-n900.dts                |  484 ++++++++
 arch/arm/boot/dts/omap3-n950-n9.dtsi            |  174 +++
 arch/arm/boot/dts/omap3-n950.dts                |   18 +
 arch/arm/boot/dts/omap3-zoom3.dts               |  217 ++++
 arch/arm/boot/dts/omap3.dtsi                    |   58 +-
 arch/arm/boot/dts/omap3430-sdp.dts              |   22 +-
 arch/arm/boot/dts/omap36xx.dtsi                 |    4 +
 arch/arm/boot/dts/omap4-panda-common.dtsi       |   82 +-
 arch/arm/boot/dts/omap4-panda-es.dts            |    4 +
 arch/arm/boot/dts/omap4-sdp.dts                 |   21 +-
 arch/arm/boot/dts/omap4.dtsi                    |   37 +-
 arch/arm/boot/dts/omap5-uevm.dts                |   84 +-
 arch/arm/boot/dts/omap5.dtsi                    |   30 +-
 arch/arm/boot/dts/prima2.dtsi                   |   30 +-
 arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts |   73 ++
 arch/arm/boot/dts/r8a73a4-ape6evm.dts           |    1 +
 arch/arm/boot/dts/r8a73a4.dtsi                  |   52 +
 .../dts/r8a7740-armadillo800eva-reference.dts   |   78 ++
 arch/arm/boot/dts/r8a7740.dtsi                  |   35 +
 arch/arm/boot/dts/r8a7778-bockw-reference.dts   |   27 +-
 arch/arm/boot/dts/r8a7778.dtsi                  |   19 +
 arch/arm/boot/dts/r8a7779-marzen-reference.dts  |    8 +-
 arch/arm/boot/dts/r8a7779.dtsi                  |    5 +
 arch/arm/boot/dts/r8a7790.dtsi                  |   89 ++
 arch/arm/boot/dts/r8a7791.dtsi                  |   33 +
 arch/arm/boot/dts/s3c6400.dtsi                  |   41 +
 arch/arm/boot/dts/s3c6410-mini6410.dts          |  228 ++++
 arch/arm/boot/dts/s3c6410-smdk6410.dts          |  103 ++
 arch/arm/boot/dts/s3c6410.dtsi                  |   57 +
 arch/arm/boot/dts/s3c64xx-pinctrl.dtsi          |  687 ++++++++++++
 arch/arm/boot/dts/s3c64xx.dtsi                  |  199 ++++
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts    |    2 +
 arch/arm/boot/dts/sh73a0.dtsi                   |    5 +
 arch/arm/boot/dts/socfpga.dtsi                  |  297 ++---
 arch/arm/boot/dts/socfpga_arria5.dtsi           |   58 +
 arch/arm/boot/dts/socfpga_arria5_socdk.dts      |   40 +
 ...cfpga_cyclone5.dts => socfpga_cyclone5.dtsi} |   20 -
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts    |   40 +
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts   |   37 +
 arch/arm/boot/dts/ste-dbx5x0.dtsi               |  216 +++-
 .../dts/{ste-stuib.dtsi => ste-href-stuib.dtsi} |    2 -
 arch/arm/boot/dts/ste-href-tvk1281618.dtsi      |   41 +
 arch/arm/boot/dts/ste-href.dtsi                 |  109 +-
 arch/arm/boot/dts/ste-hrefprev60-stuib.dts      |   34 +
 arch/arm/boot/dts/ste-hrefprev60-tvk.dts        |   19 +
 .../{ste-hrefprev60.dts => ste-hrefprev60.dtsi} |   37 +-
 arch/arm/boot/dts/ste-hrefv60plus-stuib.dts     |   36 +
 arch/arm/boot/dts/ste-hrefv60plus-tvk.dts       |   21 +
 arch/arm/boot/dts/ste-hrefv60plus.dts           |  210 ----
 arch/arm/boot/dts/ste-hrefv60plus.dtsi          |   70 ++
 arch/arm/boot/dts/ste-snowball.dts              |   85 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                |    5 +
 arch/arm/boot/dts/sun5i-a10s.dtsi               |    5 +
 arch/arm/boot/dts/sun5i-a13.dtsi                |    5 +
 arch/arm/boot/dts/sun6i-a31.dtsi                |    2 +-
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts     |   12 +
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts      |   63 ++
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts |   18 +
 arch/arm/boot/dts/sun7i-a20.dtsi                |   71 ++
 arch/arm/boot/dts/tegra114-dalmore.dts          |   32 +-
 arch/arm/boot/dts/tegra114.dtsi                 |    6 +-
 arch/arm/boot/dts/tegra124-venice2.dts          |   27 +
 arch/arm/boot/dts/tegra124.dtsi                 |  149 +++
 arch/arm/boot/dts/tegra30-cardhu.dtsi           |    3 +-
 arch/arm/boot/dts/tegra30.dtsi                  |    5 +-
 arch/arm/boot/dts/twl4030.dtsi                  |   49 +-
 arch/arm/boot/dts/twl6030_omap4.dtsi            |   38 +
 arch/arm/boot/dts/vf610-cosmic.dts              |   47 +
 arch/arm/boot/dts/vf610-twr.dts                 |   17 +
 arch/arm/boot/dts/vf610.dtsi                    |   12 +
 arch/arm/configs/omap2plus_defconfig            |  109 +-
 arch/arm/configs/u8500_defconfig                |   12 +-
 arch/arm/mach-at91/at91sam9n12.c                |    1 +
 arch/arm/mach-kirkwood/board-dt.c               |    1 -
 arch/arm/mach-mxs/mach-mxs.c                    |    7 +
 arch/arm/mach-omap2/Kconfig                     |   56 +-
 arch/arm/mach-omap2/Makefile                    |   14 +-
 arch/arm/mach-omap2/board-3630sdp.c             |  225 ----
 arch/arm/mach-omap2/board-generic.c             |   40 +-
 arch/arm/mach-omap2/board-igep0020.c            |  718 ------------
 arch/arm/mach-omap2/board-ldp.c                 |    3 +-
 arch/arm/mach-omap2/board-omap3evm.c            |  756 -------------
 arch/arm/mach-omap2/board-rm680.c               |  167 ---
 arch/arm/mach-omap2/board-zoom-debugboard.c     |  139 ---
 arch/arm/mach-omap2/board-zoom-display.c        |   71 --
 arch/arm/mach-omap2/board-zoom-peripherals.c    |  360 ------
 arch/arm/mach-omap2/board-zoom.c                |  159 ---
 arch/arm/mach-omap2/board-zoom.h                |   10 -
 arch/arm/mach-omap2/common.h                    |    7 +
 arch/arm/mach-omap2/devices.c                   |   38 -
 arch/arm/mach-omap2/dss-common.c                |   44 +
 arch/arm/mach-omap2/dss-common.h                |    1 +
 arch/arm/mach-omap2/gpmc.c                      |   38 +
 arch/arm/mach-omap2/io.c                        |   20 +
 arch/arm/mach-omap2/mux.c                       |    8 +-
 arch/arm/mach-omap2/opp.c                       |    4 +
 arch/arm/mach-omap2/pdata-quirks.c              |  174 +++
 arch/arm/mach-omap2/pm.c                        |   12 +-
 arch/arm/mach-omap2/prm3xxx.h                   |    8 +-
 arch/arm/mach-omap2/prm44xx_54xx.h              |    8 +-
 arch/arm/mach-omap2/prm_common.c                |   11 +
 arch/arm/mach-s3c64xx/Kconfig                   |   16 +-
 arch/arm/mach-s3c64xx/Makefile                  |    1 +
 arch/arm/mach-s3c64xx/common.c                  |   12 +
 arch/arm/mach-s3c64xx/dma.c                     |    9 +
 arch/arm/mach-s3c64xx/irq-pm.c                  |    9 +
 arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c         |   85 ++
 arch/arm/mach-s3c64xx/s3c6400.c                 |    9 +
 arch/arm/mach-s3c64xx/s3c6410.c                 |    9 +
 arch/arm/mach-ux500/Makefile                    |    5 +-
 arch/arm/mach-ux500/board-mop500-audio.c        |   50 -
 arch/arm/mach-ux500/board-mop500-sdi.c          |   51 -
 arch/arm/mach-ux500/board-mop500-stuib.c        |  120 --
 arch/arm/mach-ux500/board-mop500-u8500uib.c     |   92 --
 arch/arm/mach-ux500/board-mop500-uib.c          |  133 ---
 arch/arm/mach-ux500/board-mop500.c              |  637 -----------
 arch/arm/mach-ux500/board-mop500.h              |   16 -
 arch/arm/mach-ux500/cpu-db8500.c                |  124 +--
 arch/arm/mach-ux500/cpu.c                       |   19 +-
 arch/arm/mach-ux500/devices-common.c            |   60 -
 arch/arm/mach-ux500/devices-common.h            |  149 ---
 arch/arm/mach-ux500/devices-db8500.c            |   94 --
 arch/arm/mach-ux500/devices-db8500.h            |  110 --
 arch/arm/mach-ux500/devices.h                   |    8 -
 arch/arm/mach-ux500/setup.h                     |    1 -
 arch/arm/mach-ux500/timer.c                     |    4 +-
 arch/arm/mach-ux500/usb.c                       |  135 ---
 arch/arm/plat-samsung/init.c                    |   12 +-
 drivers/clk/ux500/Makefile                      |    1 +
 drivers/clk/ux500/u8500_of_clk.c                |  559 ++++++++++
 drivers/clk/ux500/u8540_clk.c                   |    2 +-
 drivers/gpio/gpio-samsung.c                     |   34 +-
 drivers/irqchip/irq-vic.c                       |    7 +-
 drivers/mfd/db8500-prcmu.c                      |    1 -
 drivers/mfd/dbx500-prcmu-regs.h                 |    1 -
 drivers/pinctrl/pinctrl-single.c                |  388 ++++++-
 drivers/usb/musb/ux500.c                        |    2 +-
 include/dt-bindings/mfd/dbx500-prcmu.h          |   83 ++
 include/dt-bindings/pinctrl/am43xx.h            |   31 +
 include/dt-bindings/pinctrl/dra.h               |   50 +
 include/linux/mfd/dbx500-prcmu.h                |   70 +-
 include/linux/platform_data/clk-ux500.h         |    3 +
 include/linux/platform_data/pinctrl-single.h    |   12 +
 274 files changed, 15383 insertions(+), 8922 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/mvebu-corediv-clock.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/omap-sham.txt
 create mode 100644 Documentation/devicetree/bindings/hwrng/omap_rng.txt
 create mode 100644 arch/arm/boot/dts/am335x-base0033.dts
 create mode 100644 arch/arm/boot/dts/am335x-igep0033.dtsi
 create mode 100644 arch/arm/boot/dts/am335x-nano.dts
 create mode 100644 arch/arm/boot/dts/armada-370-netgear-rn104.dts
 create mode 100644 arch/arm/boot/dts/armada-xp-matrix.dts
 create mode 100644 arch/arm/boot/dts/dove-d3plug.dts
 create mode 100644 arch/arm/boot/dts/dra7-evm.dts
 create mode 100644 arch/arm/boot/dts/dra7.dtsi
 create mode 100644 arch/arm/boot/dts/imx23-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx28-m28cu3.dts
 create mode 100644 arch/arm/boot/dts/imx28-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx6q-udoo.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-openblocks_a7.dts
 create mode 100644 arch/arm/boot/dts/mxs-pinfunc.h
 create mode 100644 arch/arm/boot/dts/omap-gpmc-smsc911x.dtsi
 create mode 100644 arch/arm/boot/dts/omap-zoom-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-evm-37xx.dts
 create mode 100644 arch/arm/boot/dts/omap3-evm-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-gta04.dts
 create mode 100644 arch/arm/boot/dts/omap3-n9.dts
 create mode 100644 arch/arm/boot/dts/omap3-n900.dts
 create mode 100644 arch/arm/boot/dts/omap3-n950-n9.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-n950.dts
 create mode 100644 arch/arm/boot/dts/omap3-zoom3.dts
 create mode 100644 arch/arm/boot/dts/s3c6400.dtsi
 create mode 100644 arch/arm/boot/dts/s3c6410-mini6410.dts
 create mode 100644 arch/arm/boot/dts/s3c6410-smdk6410.dts
 create mode 100644 arch/arm/boot/dts/s3c6410.dtsi
 create mode 100644 arch/arm/boot/dts/s3c64xx-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/s3c64xx.dtsi
 create mode 100644 arch/arm/boot/dts/socfpga_arria5.dtsi
 create mode 100644 arch/arm/boot/dts/socfpga_arria5_socdk.dts
 rename arch/arm/boot/dts/{socfpga_cyclone5.dts => socfpga_cyclone5.dtsi} (78%)
 create mode 100644 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
 create mode 100644 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
 rename arch/arm/boot/dts/{ste-stuib.dtsi => ste-href-stuib.dtsi} (95%)
 create mode 100644 arch/arm/boot/dts/ste-href-tvk1281618.dtsi
 create mode 100644 arch/arm/boot/dts/ste-hrefprev60-stuib.dts
 create mode 100644 arch/arm/boot/dts/ste-hrefprev60-tvk.dts
 rename arch/arm/boot/dts/{ste-hrefprev60.dts => ste-hrefprev60.dtsi} (60%)
 create mode 100644 arch/arm/boot/dts/ste-hrefv60plus-stuib.dts
 create mode 100644 arch/arm/boot/dts/ste-hrefv60plus-tvk.dts
 delete mode 100644 arch/arm/boot/dts/ste-hrefv60plus.dts
 create mode 100644 arch/arm/boot/dts/ste-hrefv60plus.dtsi
 create mode 100644 arch/arm/boot/dts/sun7i-a20-cubietruck.dts
 create mode 100644 arch/arm/boot/dts/tegra124-venice2.dts
 create mode 100644 arch/arm/boot/dts/tegra124.dtsi
 create mode 100644 arch/arm/boot/dts/twl6030_omap4.dtsi
 create mode 100644 arch/arm/boot/dts/vf610-cosmic.dts
 delete mode 100644 arch/arm/mach-omap2/board-3630sdp.c
 delete mode 100644 arch/arm/mach-omap2/board-igep0020.c
 delete mode 100644 arch/arm/mach-omap2/board-omap3evm.c
 delete mode 100644 arch/arm/mach-omap2/board-rm680.c
 delete mode 100644 arch/arm/mach-omap2/board-zoom-debugboard.c
 delete mode 100644 arch/arm/mach-omap2/board-zoom-display.c
 delete mode 100644 arch/arm/mach-omap2/board-zoom-peripherals.c
 delete mode 100644 arch/arm/mach-omap2/board-zoom.c
 delete mode 100644 arch/arm/mach-omap2/board-zoom.h
 create mode 100644 arch/arm/mach-omap2/pdata-quirks.c
 create mode 100644 arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c
 delete mode 100644 arch/arm/mach-ux500/board-mop500-stuib.c
 delete mode 100644 arch/arm/mach-ux500/board-mop500-u8500uib.c
 delete mode 100644 arch/arm/mach-ux500/board-mop500-uib.c
 delete mode 100644 arch/arm/mach-ux500/devices-common.c
 delete mode 100644 arch/arm/mach-ux500/devices-common.h
 delete mode 100644 arch/arm/mach-ux500/usb.c
 create mode 100644 drivers/clk/ux500/u8500_of_clk.c
 create mode 100644 include/dt-bindings/mfd/dbx500-prcmu.h
 create mode 100644 include/dt-bindings/pinctrl/am43xx.h
 create mode 100644 include/dt-bindings/pinctrl/dra.h
 create mode 100644 include/linux/platform_data/pinctrl-single.h
