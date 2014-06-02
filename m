Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaFBVit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:38:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53185 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaFBViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:38:10 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=206/7=5D=20ARM=3A=20SoC=20devicetree=20updates=20for=203=2E16?=
Date: Mon,  2 Jun 2014 14:04:09 -0700
Message-Id: <1401743050-7379-7-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401743050-7379-1-git-send-email-olof@lixom.net>
References: <1401743050-7379-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As with previous release, this continues to be among the largest branches
we merge, with lots of new contents.

New things for this release are among other things:

- DTSI contents for the new SoCs supported in 3.16 (see SoC pull request)
- Qualcomm APQ8064 and APQ8084 SoCs and eval boards
- Nvidia Jetson TK1 development board (Tegra T124-based)

Two new SoCs that didn't need enough new platform code to stand out
enough for me to notice when writing the SoC tag, but that adds new DT
contents are:

- TI DRA72
- Marvell Berlin 2Q


Conflicts:

arch/arm/boot/dts/Makefile:
	Keep r8a7791-henninger.dtb and r7s72100-genmai.dtb.
arch/arm/boot/dts/kirkwood-t5325.dts:
	Conflict with a fix/workaround on 3.15 that removed the alc5621
	node. Keep the branch version in 3.16.
arch/arm/boot/dts/omap3-n900.dts:
	Add/add conflict, keep both sides. Make sure to add both >;
	and }; lines.
arch/arm/boot/dts/r8a7790-lager.dts:
	Add/add conflict, keep both sides. Make sure to add the }; line. I also
	took out the empty line below the pmic node.
arch/arm/mach-exynos/firmware.c:
	Missed basing on fixes for 3.15. Remove the plat/cpu.h include.
include/dt-bindings/pinctrl/omap.h:
	Add/add conflict, keep both sides.

----------------------------------------------------------------

The following changes since commit a79441abab7f2a2e5c349495488eb29509f53666:

  Merge tag 'defconfig-for-3.16' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-3.16

for you to fetch changes up to 0f16aa3c24a216d14d7f0587e1cbd2c1b51a38f3:

  Merge tag 'samsung-dt-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/dt

----------------------------------------------------------------

Adam Baker (3):
      ARM: kirkwood: Move NSA310 common parts to include file
      ARM: kirkwood: Add DTS file for NSA320
      ARM: kirkwood: rename kirwood-nsa310-common to 3x0-common

Afzal Mohammed (1):
      ARM: dts: AM4372: clk: efuse based crystal frequency detect

Ajay Kumar (2):
      ARM: dts: Add pwmX_out pinctrl nodes to exynos5250
      ARM: dts: enable pwm backlight for exynos5250-snow

Alexander Shiyan (20):
      ARM: dts: imx27-phytec-phycore-rdk: Add missing pinctrl definition for SPI CS1
      ARM: dts: imx27-phytec-phycore-som: Enable SSI1
      ARM: dts: imx27-phytec-phycore-rdk: Add display support
      ARM: dts: imx27-phytec-phycore-rdk: Add display control signal definitions
      ARM: dts: i.MX: Use single naming style for i.MX WEIM device
      ARM i.MX51: Add Digi ConnectCore devicetree
      ARM: dts: i.MX51: Allow to define partitions onto NFC
      ARM: dts: imx51-babbage: Move "hog" pins into corresponded pin groups
      ARM: dts: imx51-babbage: Add missing pingroup for PMIC
      ARM: dts: imx51-babbage: Use predefined constants for keys definition
      ARM: dts: imx51-babbage: Add USB OTG regulator node
      ARM: dts: imx51-babbage: Sort nodes by name
      ARM: dts: imx51-babbage: Add devicetree node for I2C1
      ARM: dts: imx51-babbage: Use predefined constants for clock definition
      ARM: dts: imx27-phytec-phycore-rdk: Remove duplicate entries for USB PHY
      ARM: dts: imx27-phytec-phycore-som: Fix active level for FEC reset
      ARM: dts: imx27-phytec-phycore-som: Disable PM pins for USB OTG
      ARM: dts: imx: Remove excess entries for PMIC
      ARM: dts: imx27-phytec-phycore-rdk: Add CSI enable switch
      ARM: dts: imx27-phytec-phycore-rdk: Fix "reg" property for USBH2 PHY

Alexandre Belloni (14):
      ARM: at91/dt: sam9rl: add lcd, adc, usb gadget and pwm support
      ARM: at91/dt: add peripherals to the at91sam9rlek board
      ARM: at91/dt: sam9g45: improve ADC/touchscreen support
      ARM: at91/dt: at91sam9m10g45ek: add ADC and touchscreen support
      ARM: at91/dt: at91sam9m10g45ek PWM leds polarity is inversed
      ARM: sun4i: dt: add pinmux configuration for the PWM
      ARM: sun7i: dt: add pinmux configuration for the PWM
      ARM: sun4i: dt: add PWM support
      ARM: sun7i: dt: add PWM support
      ARM: sunxi: dt: add PWM support for the cubietruck
      ARM: at91/dt: sam9261: Fix PLL output ranges and other clocks divisors
      ARM: at91/dt: sam9261: Add ssc2, SSC clocks and pcks
      ARM: at91/dt: sam9rl: Fix PLL output range and mck divisors
      ARM: dts: berlin: convert BG2Q to DT clock nodes

Alexandre Courbot (2):
      ARM: tegra: add Tegra Note 7 device tree
      ARM: tegra: add device tree for SHIELD

Andrew Bresticker (1):
      ARM: tegra: fix Venice2 SD card VQMMC supply

Andrew Lunn (4):
      ARM: Kirkwood: Add node for audio codec
      ARM: Kirkwood: DT: Add missing #sound-dai-cells property
      ARM: Kirkwood: t5325: Use simple card to instantiate audio
      ARM: Kirkwood: DT versions of OpenRD boards

Andy Gross (1):
      soc: qcom: Add device tree binding for GSBI

Antoine Tenart (9):
      ARM: dts: berlin: add the Marvell Armada 1500 pro
      ARM: dts: berlin: add the Marvell BG2-Q DMP device tree
      ARM: dts: berlin: add the BG2Q GPIO nodes
      ARM: dts: berlin: add the BG2 GPIO nodes
      ARM: dts: berlin: add the BG2CD GPIO nodes
      dt-binding: ARM: add pinctrl binding docs for Marvell Berlin2 SoCs
      ARM: dts: berlin: add the pinctrl node and muxing setup for uarts
      ARM: dts: berlin: add the SDHCI nodes for the BG2Q
      ARM: dts: berlin: enable SD card reader and eMMC for the BG2Q DMP

Arnd Bergmann (7):
      Merge tag 'sti-dt-for-v3.16-1' of git://git.stlinux.com/devel/kernel/linux-sti into next/dt
      Merge branch 'at91/cleanup' into next/dt
      Merge tag 'at91-dt3' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'qcom-dt-for-3.16' of git://git.kernel.org/.../galak/linux-qcom into for-next
      Merge tag 'for-3.16/bcm-dt' of git://github.com/broadcom/mach-bcm into for-next
      Merge tag 'sunxi-dt-for-3.16-2' of https://github.com/mripard/linux into for-next
      Merge tag 'mvebu-dt-3.16-2' of git://git.infradead.org/linux-mvebu into next/dt

Arun Kumar K (5):
      ARM: dts: add dts file for exynos5800 SoC
      ARM: dts: add dts file for exynos5800-peach-pi board
      ARM: dts: add mfc node for exynos5800
      ARM: dts: correct the usb phy node in exynos5420-peach-pit
      ARM: dts: correct the usb phy node in exynos5800-peach-pi

Balaji T K (2):
      ARM: dts: omap5: add sata node
      ARM: dts: dra7: add OCP2SCP3 and SATA nodes

Barry Song (1):
      ARM: dts: sirf: move to use generic dma dt-binding for spi

Beniamino Galvani (2):
      of: add mundoreader and radxa vendor prefixes
      ARM: dts: rockchip: add root compatible properties

Beomho Seo (5):
      ARM: dts: add cm36651 light/proximity sensor node for exynos4412-trats2
      ARM: dts: fixed gpio key node for exynos4412-trats2
      ARM: dts: replace number by macro in clock binding for exynos4
      ARM: dts: replace number by macro in clock binding for exynos5250
      ARM: dts: replace number by macro in clock binding for exynos5420

Bo Shen (5):
      ARM: at91: sama5d3: add DMA property for SSC devices
      ARM: at91: sama5d3: disable sound by default
      ARM: at91: sama5d3: correct the sound compatible string
      ARM: at91: sama5d3: add the missing property
      ARM: at91: sama5d3: clock for ssc from rk pin

Boris BREZILLON (11):
      ARM: sunxi: dt: add APP4-EVB1 board support
      ARM: sunxi: dt: add PRCM clk and reset controller subdevices
      ARM: sunxi: dt: declare the r_pio pin controller for A31 SoC
      ARM: at91: prepare common clk transition for sam9x5 SoCs
      ARM: at91/dt: define sam9x5 clocks
      ARM: at91/dt: define sam9x5ek's crystal frequencies
      ARM: at91: move sam9x5 SoCs to the CCF
      ARM: at91: prepare common clk transition for sam9n12 SoC
      ARM: at91/dt: define sam9n12 clocks
      ARM: at91/dt: define sam9n12ek crystal frequencies
      ARM: at91: move sam9n12 SoC to the CCF

Chanho Park (4):
      ARM: dts: add PMU syscon node for exynos4
      ARM: dts: add exynos_usbphy node for exynos4
      ARM: dts: add hsotg device node for exynos4
      ARM: dts: enable usb nodes for exynos4412-trats2

Chanwoo Choi (1):
      ARM: dts: add pmu sysreg node to exynos3250

Chen-Yu Tsai (2):
      ARM: dts: sun7i: Add basic support for the Cubietruck WiFi module
      ARM: sunxi: dt: build DTs according to new MACH_SUNxI Kconfig symbols

Christoph Fritz (2):
      ARM: dts: omap3: set mcbsp2 status
      ARM: dts: omap3 a83x: fix duplicate usb pin config

Cosmin Stoica (1):
      ARM: dts: vf610-twr: Add support for sdhc1

Dave Gerlach (3):
      ARM: dts: am437x-gp-evm: Add vtt_fixed regulator
      ARM: dts: am335x-evmsk: Add vtt_fixed regulator
      ARM: dts: am43xx-clocks: use ti, fixed-factor-clock for dpll_per_clkdcoldo

David Lanzendörfer (2):
      ARM: dts: sun4i: Add mmc controller nodes
      ARM: dts: sun5i: Add mmc controller nodes

Denis Carikli (7):
      ARM: dts: mbimxsd35: Add sound support.
      ARM: dts: mbimxsd25 baseboard: Add USB support
      ARM: dts: i.MX35: Add USB support.
      ARM: dts: mbimxsd35 baseboard: Add USB support.
      ARM: dts: mbimxsd51 baseboard: Add USB support.
      ARM: dts: cpuimx35 Add touchscreen support.
      ARM: dts: cpuimx51 Add touchscreen support.

Dinh Nguyen (4):
      ARM: socfpga: dts: add eeprom and rtc on i2c0
      ARM: socfpga: dts: Remove hard coded clock-frequency property
      ARM: socfpga: dts: Add DTS entries for USB
      ARM: socfpga: dts: Add div-reg to the main_pll clocks

Dmitry Lifshitz (2):
      ARM: dts: sbc-t54: add support for sbc-t54 with cm-t54
      ARM: dts: cm-t54: add WiFi/BT support

Doug Anderson (3):
      ARM: dts: add pinctrl for i2c-arbitrator of exynos5250-snow
      ARM: dts: add pinctrl for EC irq of exynos5250-snow
      ARM: dts: add tps65090 power regulator for exynos5250-snow

Ezequiel Garcia (4):
      ARM: mvebu: Enable Armada 375 watchdog in the devicetree
      ARM: mvebu: Enable Armada 380/385 watchdog in the devicetree
      ARM: mvebu: Enable the thermal sensor in Armada 375 SoC
      ARM: mvebu: Enable the thermal sensor in Armada 380/385 SoC

Fabio Estevam (34):
      ARM: dts: imx25-pdk: Sort the dt nodes
      ARM: dts: imx25-pdk: Add UART1 pins
      ARM: dts: imx25-pdk: Add FEC pins
      ARM: dts: imx25-pdk: Provide a regulator for Ethernet PHY
      ARM: dts: imx25-pdk: Provide an Ethernet PHY reset
      ARM: dts: imx25-pdk: Add esdhc1 support
      ARM: dts: mx25: USB block requires only one clock
      ARM: dts: mx35: USB block requires only one clock
      ARM: dts: imx25.dtsi: Fix USB support.
      ARM: dts: imx25-pdk: Add audio support
      ARM: dts: imx25-pdk: Add keypad support
      ARM: dts: imx25-pdk: Add CAN support
      ARM: dts: imx25-pdk: Add USB Host1 support
      ARM: dts: imx35-pdk: Add initial device tree support
      ARM: dts: imx51-babbage: Add USB Host1 support
      ARM: dts: imx51-babbage: Add USB OTG support
      ARM: dts: imx27-pdk: Pass the memory range
      ARM: dts: imx27-pdk: Keep the dt nodes sorted
      ARM: dts: imx27-pdk: Pass the UART1 pin configuration
      ARM: dts: imx27-pdk: Pass the FEC pin configuration
      ARM: dts: imx27-pdk: Add PMIC support
      ARM: dts: imx27-phytec-phycore-som: Move PMIC IRQ GPIO into a separate pin group
      ARM: dts: imx27: Use the correct usb clock gate
      ARM: dts: imx27: Place the usb phy nodes in the board dts files
      ARM: dts: imx27-pdk: Add USB OTG support
      ARM: dts: imx27-pdk: Add NAND support
      ARM: dts: imx27-pdk: Add keypad support
      ARM: dts: imx6qdl-sabresd: Add HDMI support
      ARM: dts: imx6qdl-wandboard: Add HDMI support
      ARM: dts: imx53-qsb-common: Add TVE support
      ARM: dts: imx6q-udoo: Add HDMI support
      ARM: dts: imx6qdl-sabresd: Add USDHC4 support
      ARM: dts: imx51-eukrea-mbimxsd51-baseboard: Add CAN support
      ARM: dts: imx35-pdk: Fix memory region description

Gabriel FERNANDEZ (16):
      driver: reset: sti: add keyscan for stih415
      driver: reset: sti: add keyscan for stih416
      ARM: STi: DT: add keyscan for stih415
      ARM: STi: DT: add keyscan for stih416
      ARM: STi: DT: add keyscan for stih41x-b2000
      ARM: STi: DT: STiH41x: Rename CLK_SYSIN into clk_sysin
      ARM: STi: DT: STiH416: 416 DT Entry for clockgen A0/1/10/11/12
      ARM: STi: DT: STiH416: Remove unused CLK_S_ICN_REG_0 fixed clock
      ARM: STi: DT: STiH416: Remove unused CLK_S_GMAC0_PHY & CLK_S_ETH1_PHY fixed clocks
      ARM: STi: DT: STiH416: 416 DT Entry for clockgen B/C/D/E/F
      ARM: STi: DT: STiH416: 416 DT Entry for clockgen A9/DDR/GPU
      ARM: STi: DT: STiH415: 415 DT Entry for clockgen A0/1/10/11/12
      ARM: STi: DT: STiH415: Remove unused CLK_S_ICN_REG_0 fixed clock
      ARM: STi: DT: STiH415: Remove unused CLK_S_GMAC0_PHY & CLK_S_ETH1_PHY fixed clocks
      ARM: STi: DT: STiH415: 415 DT Entry for clockgen A9
      ARM: STi: DT: STiH41x Add clk_ignore_unused to bootargs

Geert Uytterhoeven (19):
      ARM: shmobile: r8a7790/lager dts: Rename label spi to qspi, add spi0 alias
      ARM: shmobile: r8a7791/koelsch dts: Rename label spi to qspi, add spi0 alias
      ARM: shmobile: r8a7790 dtsi: Add MSIOF nodes and aliases
      ARM: shmobile: r8a7791 dtsi: Add MSIOF nodes and aliases
      ARM: shmobile: lager dts: Add MSIOF nodes
      ARM: shmobile: koelsch dts: Add MSIOF nodes
      ARM: shmobile: r8a7778 dtsi: Improve and correct HSPI nodes
      ARM: shmobile: r8a7779 dtsi: Improve and correct HSPI nodes
      ARM: shmobile: bockw reference dts: Add SPI FLASH
      ARM: shmobile: armadillo-reference dts: Use KEY_* macros for gpio-keys
      ARM: shmobile: kzm9g-reference dts: Use KEY_* macros for gpio-keys
      ARM: shmobile: koelsch dts: Enable Quad SPI transfers for the SPI FLASH
      ARM: shmobile: lager dts: Enable Quad SPI transfers for the SPI FLASH
      ARM: shmobile: armadillo-reference dts: Seiko Instruments, Inc is "sii"
      ARM: shmobile: r8a7740 dtsi: Add Ethernet support
      ARM: shmobile: armadillo-reference dts: Add Ethernet support
      ARM: shmobile: r8a7790 dtsi: Add GPIO clocks
      ARM: shmobile: r8a7791 dtsi: Add GPIO clocks
      ARM: shmobile: r8a7740 dtsi: Remove duplicate interrupt-parent property

George Cherian (5):
      doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue
      ARM: dts: am43xx clock data
      ARM: dts: AM4372: Add USB nodes
      ARM: dts: am437x-gp-evm: Enable USB
      ARM: dts: am43x-epos-evm: Enable USB

Georgi Djakov (3):
      ARM: dts: msm: Add SDHC controller nodes for MSM8974 and DB8074 board
      ARM: dts: qcom: Add APQ8084 SoC support
      ARM: dts: qcom: Add APQ8084-MTP board support

Gilles Chanteperdrix (1):
      ARM: dts: omap4: add twd clock to DT

Gregory CLEMENT (6):
      ARM: mvebu: switch to the new PMSU binding in Armada 370/XP Device Tree
      ARM: mvebu: add SMP support in the Armada 375 device tree
      ARM: mvebu: add Device Tree description of xHCI controllers on Armada 38x
      ARM: mvebu: add Device Tree description of the EHCI controller on Armada 38x
      ARM: mvebu: add Device Tree description of the xHCI controller on Armada 375
      ARM: mvebu: add Device Tree description for the EHCI controllers on Armada 375

Grygorii Strashko (5):
      ARM: dts: keystone: add cell's information to i2c nodes
      ARM: dts: keystone: move i2c0 device node from SoC to board files
      ARM: dts: keystone: add cell's information to spi nodes
      ARM: dts: keystone: Use dma-ranges property
      ARM: dts: keystone-evm: add spi nor flash support

Guido Martínez (4):
      ARM: dts: am335x-bone-common: use phandles for USB and DMA refs
      ARM: dts: am335x-evm: use phandles for USB and DMA refs
      ARM: dts: am335x-evmsk: use phandles for USB and DMA refs
      ARM: dts: am335x-igep0033: use phandles for USB and DMA refs

Hans de Goede (23):
      ARM: sun6i: dt: Fixup prcm node name
      ARM: sun4i: dt: Add address- and size-cells info to i2c controller nodes
      ARM: sun5i: dt: Add address- and size-cells info to i2c controller nodes
      ARM: sun7i: dt: Add address- and size-cells info to i2c controller nodes
      ARM: dts: sun5i: Add pin-muxing info for the mmc controllers
      ARM: dts: sun6i: Add pin-muxing info for the mmc controllers
      ARM: dts: sun4i: Add pin-muxing info for the mmc0 controller
      ARM: dts: sun4i: Enable mmc controller on various A10 boards
      ARM: dts: sun5i: Enable mmc controller on various A10s and A13 boards
      ARM: dts: sun6i: Add mmc clocks
      ARM: dts: sun6i: Add mmc controller nodes
      ARM: dts: sun6i: Add new sun6i-a31-m9 dts file for Mele M9
      ARM: dts: sun7i: Add mmc controller nodes
      ARM: dts: sun7i: Add pin-muxing info for the mmc controllers
      ARM: dts: sun7i: Enable mmc controller on various A20 boards
      ARM: dts: sunxi: Add reg_vcc3v3 supply to sunxi-common-regulators.dtsi
      ARM: dts: sun4i: Add reg_vcc3v3 to sun4i board mmc nodes
      ARM: dts: sun5i: Add reg_vcc3v3 to sun5i board mmc nodes
      ARM: dts: sun6i: Add reg_vcc3v3 to sun6i board mmc nodes
      ARM: dts: sun7i: Add reg_vcc3v3 to sun7i board mmc nodes
      ARM: dts: sun5i: Add new A10s r7 hdmi tv dongle board
      ARM: dts: sun7i: cubietruck: set mmc3 bus-width property
      ARM: dts: sun7i: Add new i12-tvbox board

Heiko Stuebner (1):
      ARM: dts: rockchip: convert pinctrl nodes to new bindings

Iain Paton (2):
      ARM: dts: imx6: i2c4 cleanup
      ARM: dts: imx6: add new board RIoTboard

Ivan Khoronzhuk (2):
      ARM: dts: k2e-evm: add AEMIF/NAND device entry
      ARM: dts: k2l-evm: add AEMIF/NAND device entry

Ivan T. Ivanov (1):
      ARM: dts: MSM8974: Add pinctrl node

Joachim Eastwood (7):
      ARM: dts: Change IOPAD macro's for OMAP4/5
      ARM: dts: Add support for OMAP4 Variscite OM44 family
      ARM: dts: Add support for OMAP4 VAR-DVK-OM44
      ARM: dts: Add VAR-SOM-OM44 WLAN nodes
      ARM: OMAP2+: Use pdata quirks for wl12xx on VAR-STK/DVK-OM44
      ARM: dts: Convert DuoVero Parlor to use IOPAD macro
      ARM: dts: Enable mcpdm and mcbsp1 on DuoVero

Johan Hovold (1):
      ARM: dts: AM33XX: fix ethernet and mdio default state

Kamil Debski (1):
      ARM: dts: Add usb2phy to exynos5250

Kumar Gala (4):
      ARM: dts: qcom: Update msm8974/apq8074 device trees
      ARM: dts: qcom: Update msm8960 device trees
      ARM: dts: qcom: Update msm8660 device trees
      ARM: dts: qcom: Add initial APQ8064 SoC and IFC6410 board device trees

Laurent Pinchart (7):
      ARM: shmobile: lager: Set ethernet PHY LED mode
      ARM: shmobile: koelsch: Set ethernet PHY LED mode
      ARM: shmobile: r8a7790: Fix the I2C clocks parents in DT
      ARM: shmobile: r8a7791: Fix the I2C clocks parents in DT
      ARM: shmobile: dts: Move interrupt-parent property to root node
      ARM: dts: use ti,fixed-factor-clock for dpll4_m5x2_mul_ck
      ARM: dts: set 'ti,set-rate-parent' for dpll4_m5 path

Lee Jones (3):
      ARM: sti: stih416: Add support for B2020 RevE
      ARM: sti: stih416: Enable board LED support for B2020 RevE
      ARM: sti: stih41x: Provide a proper header for this DTSI file

Lucas Stach (6):
      ARM: dts: zynq: drop address cells from GIC node
      ARM: dts: keystone: drop address and size cells from GIC node
      ARM: dts: imx6: update pcie to bring in line with new binding
      ARM: dts: imx6qdl-sabresd: remove power-on gpio from pcie
      ARM: dts: imx6: edmqmx6: add pinctrl for pfuze irq gpio
      ARM: dts: imx6: edmqmx6: add SPI bus and flash

Magnus Damm (4):
      ARM: shmobile: Update r8a7791 CPU freq to 1500MHz in DTS
      ARM: shmobile: Add DTS gpio-keys support for SW2 on Lager
      ARM: shmobile: Add DTS gpio-keys support for SW2 on Koelsch
      ARM: shmobile: r8a7791: Add EHCI MSTP clock

Marek Szyprowski (3):
      ARM: dts: enable USB functionality for exynos4210-universal_c210
      ARM: dts: add multimedia nodes for exynos4210-universal_c210
      ARM: dts: add external sd card node for exynos4210-universal_c210

Marek Vasut (2):
      ARM: dts: imx: Add alias for ethernet controller
      ARM: dts: imx6qdl-sabresd: Add PCIe support

Matt Porter (1):
      ARM: dts: bcm590xx: add support for GPLDO and VBUS regulators

Maxime Coquelin (4):
      ARM: dts: Sort STi boards in Makefile
      ARM: dts: Fix STi boards compatibles
      ARM: dts: Add STiH407 SoC support
      ARM: dts: STiH407: Add B2120 board support

Maxime Ripard (11):
      ARM: sun6i: Sort the NMI node by physical address
      ARM: sun6i: dt: Add A31 DMA controller to DTSI
      ARM: sun7i: Add ARM PMU in A20 DTSI
      ARM: sun6i: Add ARM PMU in A31 DTSI
      ARM: sun6i: Add the USB clocks to the DTSI
      ARM: sun6i: dt: Add support for the USB controllers
      ARM: sun6i: Define the A31 CPUs enable-method
      ARM: sunxi: Add fixed 3V regulator
      ARM: sun6i: Enable USB Host support on the Colombus board
      ARM: sun6i: Fix OHCI2 node name
      ARM: sun6i: Add MMC0 controller to the Colombus board

Michael Heimpold (4):
      ARM: dts: imx28-duckbill: fix mmc settings
      ARM: dts: imx28: include gpio.h to allow use of symbolic names
      ARM: dts: imx28-duckbill: fix phy reset gpio
      ARM: dts: imx28-duckbill: use symbolic names from gpio.h

Minal Shah (1):
      ARM: dts: dra7: add support for parallel NAND flash

Mugunthan V N (2):
      ARM: dts: am4372: Add cpsw phy sel dt node
      ARM: dts: am437x-gp-evm: Add ethernet support for GP EVM

Nathan Lynch (1):
      ARM: dts: OMAP5: add pmu node

Nicolas Ferre (5):
      ARM: at91: add pull-up to i2c[02] on SAMA5D3 Xplained
      ARM: at91: add PWM pinctrl to SAMA5D3
      ARM: at91: add 2 PWM outputs to SAMA5D3 Xplained
      Merge branch 'at91-3.15-fixes' into at91-3.16-dt3
      Merge branch 'at91-3.16-cleanup' into at91-3.16-dt3

Olof Johansson (24):
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'renesas-dt-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-dt2-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'socfpga-dt-updates-for-3.16_v3' of git://git.rocketboards.org/linux-socfpga-next into next/dt
      Merge tag 'mvebu-dt-3.16' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'v3.16-rockchip-dt' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'keystone-dts' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt
      Merge tag 'at91-dt2' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'renesas-dt3-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'sunxi-dt-for-3.16' of https://github.com/mripard/linux into next/dt
      Merge tag 'imx-dt-3.16' of git://git.kernel.org/.../shawnguo/linux into next/dt
      Merge tag 'tegra-for-3.16-dt' of git://git.kernel.org/.../tegra/linux into next/dt
      Merge commit '702b691e4a71' into next/dt
      Merge tag 'samsung-dt' of http://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge branch 'mvebu/soc-orion5x' into next/dt
      Merge tag 'omap-for-v3.16/dt-part2-v2' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'berlin-dt-3.16' of https://github.com/shesselba/linux-berlin into next/dt
      Merge tag 'zynq-dt-for-3.16' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'sirf-dts-for-3.16' of git://git.kernel.org/.../baohua/linux into next/dt
      Merge tag 'socfpga_dt_updates-for-3.16_take_2_version_2' of git://git.rocketboards.org/linux-socfpga-next into next/dt
      Merge tag 'samsung-dt-2' of http://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'omap-for-v3.16/dt-part3' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'qcom-dt-for-3.16-2' of git://git.kernel.org/.../galak/linux-qcom into next/dt
      Merge tag 'samsung-dt-3' of git://git.kernel.org/.../kgene/linux-samsung into next/dt

Pekon Gupta (3):
      ARM: dts: am43xx: fix starting offset of NAND.filesystem MTD partition
      ARM: OMAP2+: gpmc: enable BCH_HW ecc-scheme for AM43xx platforms
      ARM: dts: am437x-gp-evm: add support for parallel NAND flash

Peter Robinson (1):
      ARM: dts: Only build OMAP dtb if associated SoC is built

Peter Ujfalusi (2):
      ARM: dts: omap54xx-clocks: remove the autoidle properties for clock nodes
      ARM: dts: omap54xx-clocks: Correct abe_iclk clock node

Philipp Zabel (13):
      ARM: dts: i.MX53: Enable CODA7541 VPU
      ARM: dts: i.MX53: Add reset line to VPU device node
      ARM: dts: Add Phytec pfla02 with i.MX6 DualLite/Solo
      ARM: dts: Add Phytec pbab01 with i.MX6 DualLite/Solo
      ARM: dts: pfla02: Add GPIO LEDs
      ARM: dts: pfla02: PHY reset is active-low
      ARM: dts: pbab01: Set linux,stdout-path to UART4
      ARM: dts: pbab01: Add I2C2 and I2C3
      ARM: dts: pbab01: Add I2C devices
      ARM: dts: pfla02: Add UART1 (uart3)
      ARM: dts: pbab01: Enable UART1
      ARM: dts: pbab01: Enable DVI
      ARM: dts: imx6q-gk802: Enable HDMI

Poddar, Sourav (2):
      ARM: dts: am33xx-clock: Fix ehrpwm tbclk data
      ARM: dts: am43x-clock: add tbclk data for ehrpwm

Rahul Sharma (15):
      ARM: dts: enable hdmi for exynos5250 based snow board
      ARM: dts: change to correct compatible string for exynos5420 hdmi
      ARM: dts: enable hdmi for exynos5420-peach-pit board
      ARM: dts: enable fimd for exynos5250-snow board
      ARM: dts: enable dp-controller for exynos5250-snow board
      ARM: dts: enable fimd for exynos5420 based peach-pit board
      ARM: dts: enable dp-controller for exynos5420-peach-pit board
      ARM: dts: move dp hpd gpio pin to pinctrl_0 for exynos5420 peach_pit
      ARM: dts: add pmu syscon handle to exynos5250 hdmi
      ARM: dts: add pmu syscon handle to exynos5420 hdmi
      ARM: dts: add dts files for exynos5260 SoC
      ARM: dts: add dts file for exynos5260-xyref5260 board
      ARM: dts: enable hdmi for exynos5800-peach-pi
      ARM: dts: enable display controller for exynos5800-peach-pi
      ARM: dts: enable fimd for exynos5800-peach-pi

Rajendra Nayak (4):
      ARM: dts: dra7-evm: Remove the wrong and undocumented compatible
      ARM: dts: Add support for DRA72x family of devices
      ARM: OMAP2+: Replace all __initdata with __initconst for const init
      ARM: OMAP2+: Add machine entry for dra72x devices

Roger Quadros (5):
      ARM: dts: am43x-epos-evm: Correct Touch controller info
      ARM: dts: omap4+: Add clocks to USB2 PHY node
      ARM: dts: dra7-clock: Add "l3init_960m_gfclk" clock gate
      ARM: dts: dra7: Add USB related nodes
      dts: dra7-evm: add USB support

Rongjun Ying (1):
      ARM: dts: sirf: add pin group for USP0 with only RX or TX frame sync for atlas6

Russell King (1):
      ARM: imx: add HDMI support for SolidRun HummingBoard and Cubox-i

Sachin Kamat (5):
      ARM: dts: Add PD entry to MFC codec on exynos5420
      ARM: dts: Add MFC memory banks to exynos5420 boards
      ARM: dts: enable RTC and WDT nodes on Origen boards
      ARM: dts: use key code macros on Origen and Arndale boards
      ARM: dts: update watchdog node name in exynos5440

Sakari Ailus (1):
      ARM: dts: n950: Add missing regulator definitions

Santosh Shilimkar (1):
      ARM: dts: keystone: Update USB node for dma properties

Sascha Hauer (7):
      ARM: dts: Add stdout-path property to i.MX boards
      ARM: dts: i.MX51 babbage: Fix FEC pad ctrl settings
      ARM: dts: i.MX25: Add mmc aliases
      ARM: dts: i.MX25: Add IRAM node
      ARM: dts: Karo TX25: Add pinctrl nodes
      ARM: dts: Karo TX25: Add phy reset gpio and supply for FEC
      ARM: dts: Karo TX25: use hardware ecc

Sebastian Andrzej Siewior (1):
      ARM: dts: socfpga: add gpio pieces

Sebastian Hesselbarth (19):
      ARM: dts: kirkwood: add node labels
      ARM: dts: kirkwood: add stdout-path property to all boards
      ARM: dts: kirkwood: remove clock-frequency properties from UART nodes
      ARM: dts: kirkwood: rename pin-controller nodes
      ARM: dts: kirkwood: add pinctrl node to common SoC include
      ARM: dts: kirkwood: consolidate common pinctrl settings
      ARM: dts: kirkwood: set default pinctrl for GBE1
      ARM: dts: kirkwood: set default pinctrl for UART0/1
      ARM: dts: kirkwood: set default pinctrl for SPI0
      ARM: dts: kirkwood: set default pinctrl for NAND
      ARM: dts: kirkwood: set default pinctrl for I2C0
      ARM: dts: kirkwood: set default pinctrl for I2C1 on 6282
      ARM: dts: kirkwood: set Guruplug ethernet PHY compatible
      ARM: dts: kirkwood: set Guruplug phy-connection-type to rgmii-id
      ARM: dts: berlin: add scu and chipctrl device nodes for BG2/BG2Q
      dt-binding: ARM: add clock binding docs for Marvell Berlin2 SoCs
      clk: berlin: add binding include for Berlin SoC clock ids
      ARM: dts: berlin: convert BG2CD to DT clock nodes
      ARM: dts: berlin: convert BG2 to DT clock nodes

Sebastian Reichel (6):
      ARM: dts: omap3-n900: Add WL1251 support
      ARM: dts: twl4030: Add madc
      ARM: dts: omap3-n900: Add sound support
      ARM: dts: omap3-n900: use MATRIX_KEY for keymap
      ARM: dts: omap3-n900: Add SSI support
      ARM: dts: omap3-n900: Add modem support

Sekhar Nori (1):
      ARM: dts: am437x: Add touchscreen support for GP EVM

Sergei Shtylyov (7):
      ARM: shmobile: henninger: initial device tree
      ARM: shmobile: henninger: add Ether DT support
      ARM: shmobile: henninger: enable SATA0
      ARM: shmobile: henninger: specify EXTAL frequency
      ARM: shmobile: henninger: add SDHI0/2 DT support
      ARM: shmobile: henninger: add QSPI DT support
      ARM: shmobile: henninger: add MSIOF0 DT support

Silvio Fricke (1):
      ARM: dts: imx6: edmqmx6: add vcc and vio power supplies to stmpe

Simon Horman (2):
      ARM: shmobile: lager: Correct setting of ethernet PHY LED mode
      ARM: shmobile: marzen-reference: Set SMSC lan to use irq-push-pull

Soren Brinkmann (2):
      ARM: zynq: dt: Clean up device tree
      ARM: zynq: dt: Add a fixed regulator for CPU voltage

Sourav Poddar (4):
      ARM: dts: am43x-epos: Add qspi device
      ARM: dts: dra7: Add qspi device
      ARM: omap2+: skip device build from platform code for dt
      ARM: dts: am4372: Add hdq device tree data

Stefan Agner (3):
      ARM: tegra: initial add of Colibri T30
      of: add vendor prefix for Toradex AG
      ARM: dts: add initial Colibri VF61 board support

Steffen Trumtrar (11):
      ARM: socfpga: dts: fix pdma interrupt
      ARM: socfpga: dts: add remaining interrupts for pdma
      ARM: socfpga: dts: add i2c busses
      ARM: socfpga: dts: add can0+1
      ARM: socfpga: dts: add support for EBV SOCrates
      ARM: socfpga: dts: add rtc on i2c0 to socrates
      ARM: socfpga: dts: convert to preprocessor includes
      Documentation: dt: socfpga: add reset-cells property
      Documentation: dt: reset: move socfpga-reset
      ARM: socfpga: dts: add reset-controller
      ARM: socfpga: dts: add watchdog0+1

Stephen Warren (8):
      ARM: tegra: add Jetson TK1 device tree
      ARM: tegra: define Jetson TK1 regulators
      ARM: tegra: fix Jetson TK1 SD card supply
      ARM: tegra: make Venice's +3.3V_RUN regulator always on
      ARM: tegra: use correct audio CODEC on Jetson TK1
      ARM: tegra: add SD wp-gpios to Jetson TK1 DT
      ARM: tegra: add SD wp-gpios to Dalmore DT
      ARM: tegra: add SD wp-gpios to Venice2 DT

Sylwester Nawrocki (1):
      ARM: dts: Add audio subsystem nodes to exynos4.dtsi

Tao Huang (1):
      ARM: dts: sirf: add resets for dspif, gps and dsp nodes

Tarek Dakhran (1):
      ARM: dts: add dts files for exynos5410 and exynos5410-smdk5410

Tero Kristo (1):
      ARM: dts: omap2 clock data

Thierry Reding (7):
      ARM: tegra: Add Tegra124 HDMI support
      ARM: tegra: venice2 - Enable HDMI
      ARM: tegra: jetson-tk1 - Enable HDMI support
      ARM: tegra: harmony - Add +5V HDMI supply
      ARM: tegra: beaver - Add +5V HDMI supply
      ARM: tegra: dalmore - Add +5V HDMI supply
      ARM: tegra: dalmore - Add DSI power supply

Thomas Petazzoni (9):
      ARM: mvebu: enable the coherency fabric on Armada 375
      ARM: mvebu: enable the coherency fabric on Armada 38x
      ARM: mvebu: add enable-method property for CPUs
      ARM: mvebu: add SMP support in the Armada 38x device tree
      ARM: mvebu: enable the SDHCI interface on Armada 385
      ARM: mvebu: add Device Tree description of AHCI interfaces on Armada 38x
      ARM: mvebu: use clocks property for serial ports
      ARM: mvebu: remove clock-frequency of serial port Device Tree nodes
      ARM: mvebu: don't use clocks property in UART node for Netgear RN2120

Tim Harvey (3):
      ARM: dts: ventana: Add HDMI support
      ARM: dts: imx: add LVDS backlight for Ventana
      ARM: dts: imx: Fix LVDS mapping for Ventana GW52xx

Tim Kryger (2):
      ARM: dts: Declare the PWM for bcm11351 (bcm281xx)
      ARM: dts: Enable the PWM for bcm28155 AP board

Tomasz Figa (2):
      ARM: dts: Enable USB gadget functionality for exynos4210-trats
      ARM: dts: add dts files for exynos3250 SoC

Tomi Valkeinen (2):
      ARM: dts: omap5-clocks.dtsi: add ti, set-rate-parent to dss_dss_clk
      ARM: dts: am43xx-clocks.dtsi: add ti, set-rate-parent to display clock path

Tony Lindgren (2):
      ARM: OMAP2+: Fix ssi hwmod entry to allow idling
      Merge branch 'for-v3.16/clk-dt' of https://github.com/t-kristo/linux-pm into omap-for-v3.16/dt-v2

Tushar Behera (3):
      ARM: dts: Add sound node for exynos5250-snow board
      ARM: dts: Add sound node for exynos5420-peach-pit board
      ARM: dts: add secure firmware support for exynos5420-arndale-octa

Ulrich Hecht (2):
      ARM: shmobile: Use r8a7740 suffix for i2c, mmcif, fsi2 compat strings
      ARM: shmobile: armadillo-reference dts: enable RTC

Valentin Longchamp (3):
      ARM: dts: kirkwood: resynch 98dx4122 dtsi
      ARM: dts: kirkwood: add kirkwood-km_common DTSI files
      ARM: dts: kirkwood: add kirkwood-km_fixedeth DTS file

Vincent Stehlé (1):
      ARM: dts: imx6qdl-sabresd.dtsi: Add red led

Vivek Gautam (11):
      ARM: dts: Enable support for USB 3.0 PHY controller for exynos5420
      ARM: dts: Enable support for DWC3 controller for exynos5420
      ARM: dts: Enable support for generic USB DRD phy for exynos5250
      ARM: dts: Update DWC3 usb controller to use new phy driver for exynos5250
      ARM: dts: Add Vbus regulator for USB 3.0 on exynos5250-snow
      ARM: dts: Add Vbus regulator for USB 3.0 on exynos5420-peach-pit
      ARM: dts: Add Vbus regulator for USB 3.0 on exynos5420-smdk5420
      ARM: dts: Add sysreg sytem controller node to exynos5250 and exynos5420
      ARM: dts: Add usb2phy support on exynos5420
      ARM: dts: Add USB 2.0 support on exynos5420
      ARM: dts: add Vbus regulator for USB 3.0 on exynos5800-peach-pi

Wenyou Yang (1):
      ARM: at91/dt: at91-sama5d3_xplained: add the regulator device node

Wolfram Sang (9):
      ARM: shmobile: r8a7791: add IIC0/1 clock macros
      ARM: shmobile: r8a7791: add IIC(B) clocks to dtsi
      ARM: shmobile: r8a7791: add IIC(B) cores to dtsi
      ARM: shmobile: koelsch: make i2c2-pfc node unique
      ARM: shmobile: koelsch: activate i2c6 bus
      ARM: shmobile: r8a7790: add IIC0-2 clock macros
      ARM: shmobile: r8a7790: add IIC(B) clocks to dtsi
      ARM: shmobile: r8a7790: add IIC(B) cores to dtsi
      ARM: dts: am335x-evm: fix comments for lcd pins

Xiubo Li (3):
      ARM: dts: vf610: Add Freescale FTM PWM node.
      ARM: dts: vf610-twr: Add PWM0's pinctrl node
      ARM: dts: vf610-twr: Enables FTM PWM device.

Ye He (1):
      ARM: dts: atlas6: add cortex-a9-pmu compatible PMU node


 .../devicetree/bindings/arm/marvell,berlin.txt  |  102 +
 .../devicetree/bindings/arm/omap/omap.txt       |   18 +-
 .../devicetree/bindings/arm/rockchip.txt        |   10 +
 .../devicetree/bindings/arm/samsung/pmu.txt     |    4 +
 .../devicetree/bindings/arm/samsung/sysreg.txt  |   11 +-
 .../devicetree/bindings/clock/altr_socfpga.txt  |    4 +-
 .../{arm/altera => reset}/socfpga-reset.txt     |    2 +
 .../devicetree/bindings/soc/qcom/qcom,gsbi.txt  |   78 +
 .../devicetree/bindings/usb/omap-usb.txt        |    4 +-
 .../devicetree/bindings/vendor-prefixes.txt     |    4 +
 arch/arm/boot/dts/Makefile                      |  120 +-
 arch/arm/boot/dts/am335x-bone-common.dtsi       |   41 +-
 arch/arm/boot/dts/am335x-evm.dts                |   96 +-
 arch/arm/boot/dts/am335x-evmsk.dts              |   51 +-
 arch/arm/boot/dts/am335x-igep0033.dtsi          |   46 +-
 arch/arm/boot/dts/am335x-nano.dts               |    5 +
 arch/arm/boot/dts/am33xx-clocks.dtsi            |   30 +-
 arch/arm/boot/dts/am33xx.dtsi                   |    2 +
 arch/arm/boot/dts/am4372.dtsi                   |  121 ++
 arch/arm/boot/dts/am437x-gp-evm.dts             |  229 +++
 arch/arm/boot/dts/am43x-epos-evm.dts            |  105 +-
 arch/arm/boot/dts/am43xx-clocks.dtsi            |  107 +-
 arch/arm/boot/dts/armada-370-db.dts             |    1 -
 arch/arm/boot/dts/armada-370-mirabox.dts        |    1 -
 arch/arm/boot/dts/armada-370-netgear-rn102.dts  |    1 -
 arch/arm/boot/dts/armada-370-netgear-rn104.dts  |    1 -
 arch/arm/boot/dts/armada-370-rd.dts             |    1 -
 arch/arm/boot/dts/armada-370-xp.dtsi            |    7 +
 arch/arm/boot/dts/armada-370.dtsi               |    5 +
 arch/arm/boot/dts/armada-375-db.dts             |    9 +-
 arch/arm/boot/dts/armada-375.dtsi               |   55 +
 arch/arm/boot/dts/armada-380.dtsi               |    2 +
 arch/arm/boot/dts/armada-385-db.dts             |   29 +-
 arch/arm/boot/dts/armada-385-rd.dts             |    5 +-
 arch/arm/boot/dts/armada-385.dtsi               |    2 +
 arch/arm/boot/dts/armada-38x.dtsi               |   84 +
 arch/arm/boot/dts/armada-xp-axpwifiap.dts       |    2 -
 arch/arm/boot/dts/armada-xp-db.dts              |    4 -
 arch/arm/boot/dts/armada-xp-gp.dts              |    4 -
 arch/arm/boot/dts/armada-xp-matrix.dts          |    4 -
 arch/arm/boot/dts/armada-xp-mv78230.dtsi        |    1 +
 arch/arm/boot/dts/armada-xp-mv78260.dtsi        |    1 +
 arch/arm/boot/dts/armada-xp-mv78460.dtsi        |    1 +
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts  |    1 -
 .../arm/boot/dts/armada-xp-openblocks-ax3-4.dts |    2 -
 arch/arm/boot/dts/armada-xp.dtsi                |    8 +-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts     |   62 +
 arch/arm/boot/dts/at91sam9261.dtsi              |  114 +-
 arch/arm/boot/dts/at91sam9g45.dtsi              |   33 +-
 arch/arm/boot/dts/at91sam9m10g45ek.dts          |   20 +-
 arch/arm/boot/dts/at91sam9n12.dtsi              |  348 +++-
 arch/arm/boot/dts/at91sam9n12ek.dts             |    8 +
 arch/arm/boot/dts/at91sam9rl.dtsi               |  272 ++-
 arch/arm/boot/dts/at91sam9rlek.dts              |   90 +-
 arch/arm/boot/dts/at91sam9x5.dtsi               |  355 +++-
 arch/arm/boot/dts/at91sam9x5_can.dtsi           |   31 +
 arch/arm/boot/dts/at91sam9x5_isi.dtsi           |   26 +
 arch/arm/boot/dts/at91sam9x5_lcd.dtsi           |   26 +
 arch/arm/boot/dts/at91sam9x5_macb0.dtsi         |   11 +
 arch/arm/boot/dts/at91sam9x5_macb1.dtsi         |   11 +
 arch/arm/boot/dts/at91sam9x5_usart3.dtsi        |   11 +
 arch/arm/boot/dts/at91sam9x5cm.dtsi             |    8 +
 arch/arm/boot/dts/atlas6.dtsi                   |   31 +-
 arch/arm/boot/dts/bcm11351.dtsi                 |    8 +
 arch/arm/boot/dts/bcm28155-ap.dts               |    4 +
 arch/arm/boot/dts/bcm59056.dtsi                 |   21 +
 arch/arm/boot/dts/berlin2.dtsi                  |  191 +-
 arch/arm/boot/dts/berlin2cd.dtsi                |  167 +-
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts      |   39 +
 arch/arm/boot/dts/berlin2q.dtsi                 |  363 ++++
 arch/arm/boot/dts/dra7-evm.dts                  |  228 ++-
 arch/arm/boot/dts/dra7.dtsi                     |  249 ++-
 arch/arm/boot/dts/dra72-evm.dts                 |   24 +
 arch/arm/boot/dts/dra72x.dtsi                   |   25 +
 arch/arm/boot/dts/dra74x.dtsi                   |   41 +
 arch/arm/boot/dts/dra7xx-clocks.dtsi            |   12 +-
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi       |  475 +++++
 arch/arm/boot/dts/exynos3250.dtsi               |  444 +++++
 arch/arm/boot/dts/exynos4.dtsi                  |   66 +-
 arch/arm/boot/dts/exynos4210-origen.dts         |   19 +-
 arch/arm/boot/dts/exynos4210-trats.dts          |   10 +
 arch/arm/boot/dts/exynos4210-universal_c210.dts |   59 +
 arch/arm/boot/dts/exynos4412-origen.dts         |   21 +-
 arch/arm/boot/dts/exynos4412-trats2.dts         |   54 +-
 arch/arm/boot/dts/exynos4412.dtsi               |    4 +
 arch/arm/boot/dts/exynos4x12.dtsi               |    9 +
 arch/arm/boot/dts/exynos5250-arndale.dts        |   13 +-
 arch/arm/boot/dts/exynos5250-cros-common.dtsi   |    6 +-
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi       |   28 +
 arch/arm/boot/dts/exynos5250-snow.dts           |  224 +++
 arch/arm/boot/dts/exynos5250.dtsi               |   52 +-
 arch/arm/boot/dts/exynos5260-pinctrl.dtsi       |  574 ++++++
 arch/arm/boot/dts/exynos5260-xyref5260.dts      |  103 +
 arch/arm/boot/dts/exynos5260.dtsi               |  304 +++
 arch/arm/boot/dts/exynos5410-smdk5410.dts       |   82 +
 arch/arm/boot/dts/exynos5410.dtsi               |  206 ++
 arch/arm/boot/dts/exynos5420-arndale-octa.dts   |   10 +
 arch/arm/boot/dts/exynos5420-peach-pit.dts      |  140 ++
 arch/arm/boot/dts/exynos5420-smdk5420.dts       |   51 +
 arch/arm/boot/dts/exynos5420.dtsi               |  110 +-
 arch/arm/boot/dts/exynos5440.dtsi               |    2 +-
 arch/arm/boot/dts/exynos5800-peach-pi.dts       |  253 +++
 arch/arm/boot/dts/exynos5800.dtsi               |   28 +
 .../dts/imx25-eukrea-mbimxsd25-baseboard.dts    |   13 +
 arch/arm/boot/dts/imx25-karo-tx25.dts           |   77 +
 arch/arm/boot/dts/imx25-pdk.dts                 |  217 ++-
 arch/arm/boot/dts/imx25.dtsi                    |   46 +-
 arch/arm/boot/dts/imx27-pdk.dts                 |  170 +-
 .../arm/boot/dts/imx27-phytec-phycard-s-rdk.dts |    4 +
 arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts  |  116 +-
 arch/arm/boot/dts/imx27-phytec-phycore-som.dtsi |   53 +-
 arch/arm/boot/dts/imx27.dtsi                    |   30 +-
 arch/arm/boot/dts/imx28-duckbill.dts            |   12 +-
 arch/arm/boot/dts/imx28.dtsi                    |    1 +
 arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi    |   15 +
 .../dts/imx35-eukrea-mbimxsd35-baseboard.dts    |   22 +
 arch/arm/boot/dts/imx35-pdk.dts                 |   68 +
 arch/arm/boot/dts/imx35.dtsi                    |   25 +-
 arch/arm/boot/dts/imx50.dtsi                    |    1 +
 arch/arm/boot/dts/imx51-babbage.dts             |  374 ++--
 .../arm/boot/dts/imx51-digi-connectcore-jsk.dts |  108 ++
 .../boot/dts/imx51-digi-connectcore-som.dtsi    |  377 ++++
 arch/arm/boot/dts/imx51-eukrea-cpuimx51.dtsi    |   11 +
 .../dts/imx51-eukrea-mbimxsd51-baseboard.dts    |  120 ++
 arch/arm/boot/dts/imx51.dtsi                    |    3 +
 arch/arm/boot/dts/imx53-mba53.dts               |    4 +
 arch/arm/boot/dts/imx53-qsb-common.dtsi         |   21 +
 arch/arm/boot/dts/imx53.dtsi                    |    3 +-
 arch/arm/boot/dts/imx6dl-hummingboard.dts       |   31 +
 arch/arm/boot/dts/imx6dl-phytec-pbab01.dts      |   19 +
 arch/arm/boot/dts/imx6dl-phytec-pfla02.dtsi     |   22 +
 arch/arm/boot/dts/imx6dl-riotboard.dts          |  539 ++++++
 arch/arm/boot/dts/imx6dl.dtsi                   |    3 +-
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts         |   40 +-
 arch/arm/boot/dts/imx6q-gk802.dts               |    7 +-
 arch/arm/boot/dts/imx6q-gw5400-a.dts            |    5 +
 arch/arm/boot/dts/imx6q-phytec-pbab01.dts       |   33 +-
 arch/arm/boot/dts/imx6q-phytec-pfla02.dtsi      |  307 +--
 arch/arm/boot/dts/imx6q-udoo.dts                |   23 +
 arch/arm/boot/dts/imx6qdl-cubox-i.dtsi          |   27 +
 arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi    |    2 +-
 arch/arm/boot/dts/imx6qdl-gw51xx.dtsi           |    5 +
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi           |   45 +
 arch/arm/boot/dts/imx6qdl-gw53xx.dtsi           |   24 +
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi           |   24 +
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi       |    4 +
 arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi    |  102 +
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi    |  356 ++++
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi        |    4 +
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi          |   65 +
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi        |   19 +
 arch/arm/boot/dts/imx6qdl.dtsi                  |    8 +-
 arch/arm/boot/dts/imx6sl.dtsi                   |    1 +
 arch/arm/boot/dts/k2e-evm.dts                   |   81 +
 arch/arm/boot/dts/k2hk-evm.dts                  |   29 +
 arch/arm/boot/dts/k2l-evm.dts                   |   81 +
 arch/arm/boot/dts/keystone.dtsi                 |   20 +-
 arch/arm/boot/dts/kirkwood-6192.dtsi            |   35 +-
 arch/arm/boot/dts/kirkwood-6281.dtsi            |   35 +-
 arch/arm/boot/dts/kirkwood-6282.dtsi            |   48 +-
 arch/arm/boot/dts/kirkwood-98dx4122.dtsi        |   68 +-
 arch/arm/boot/dts/kirkwood-b3.dts               |    7 +-
 arch/arm/boot/dts/kirkwood-cloudbox.dts         |    8 +-
 arch/arm/boot/dts/kirkwood-db.dtsi              |   10 +-
 arch/arm/boot/dts/kirkwood-dns320.dts           |    3 +-
 arch/arm/boot/dts/kirkwood-dns325.dts           |    1 +
 arch/arm/boot/dts/kirkwood-dnskw.dtsi           |    4 +-
 arch/arm/boot/dts/kirkwood-dockstar.dts         |    3 +-
 arch/arm/boot/dts/kirkwood-dreamplug.dts        |    5 +-
 arch/arm/boot/dts/kirkwood-ds109.dts            |    1 +
 arch/arm/boot/dts/kirkwood-ds110jv10.dts        |    1 +
 arch/arm/boot/dts/kirkwood-ds111.dts            |    1 +
 arch/arm/boot/dts/kirkwood-ds112.dts            |    1 +
 arch/arm/boot/dts/kirkwood-ds209.dts            |    1 +
 arch/arm/boot/dts/kirkwood-ds210.dts            |    1 +
 arch/arm/boot/dts/kirkwood-ds212.dts            |    1 +
 arch/arm/boot/dts/kirkwood-ds212j.dts           |    1 +
 arch/arm/boot/dts/kirkwood-ds409.dts            |    1 +
 arch/arm/boot/dts/kirkwood-ds409slim.dts        |    1 +
 arch/arm/boot/dts/kirkwood-ds411.dts            |    1 +
 arch/arm/boot/dts/kirkwood-ds411j.dts           |    1 +
 arch/arm/boot/dts/kirkwood-ds411slim.dts        |    1 +
 arch/arm/boot/dts/kirkwood-goflexnet.dts        |    3 +-
 .../boot/dts/kirkwood-guruplug-server-plus.dts  |   14 +-
 arch/arm/boot/dts/kirkwood-ib62x0.dts           |    5 +-
 arch/arm/boot/dts/kirkwood-iconnect.dts         |    3 +-
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts   |    3 +-
 arch/arm/boot/dts/kirkwood-km_common.dtsi       |   48 +
 arch/arm/boot/dts/kirkwood-km_fixedeth.dts      |   23 +
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts      |   39 +-
 arch/arm/boot/dts/kirkwood-laplug.dts           |    8 +-
 arch/arm/boot/dts/kirkwood-lsxl.dtsi            |    3 +-
 arch/arm/boot/dts/kirkwood-mplcec4.dts          |   19 +-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts  |   10 +-
 .../dts/kirkwood-netgear_readynas_duo_v2.dts    |    5 +-
 .../dts/kirkwood-netgear_readynas_nv+_v2.dts    |    5 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi      |    9 +-
 arch/arm/boot/dts/kirkwood-nsa310.dts           |   53 +-
 arch/arm/boot/dts/kirkwood-nsa310a.dts          |   57 +-
 arch/arm/boot/dts/kirkwood-nsa320.dts           |  215 +++
 ...-common.dtsi => kirkwood-nsa3x0-common.dtsi} |   60 +-
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts    |   15 +-
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts    |   24 +-
 arch/arm/boot/dts/kirkwood-openrd-base.dts      |   42 +
 arch/arm/boot/dts/kirkwood-openrd-client.dts    |   73 +
 arch/arm/boot/dts/kirkwood-openrd-ultimate.dts  |   58 +
 arch/arm/boot/dts/kirkwood-openrd.dtsi          |   90 +
 arch/arm/boot/dts/kirkwood-rd88f6192.dts        |    5 +-
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi       |    3 +-
 arch/arm/boot/dts/kirkwood-rs212.dts            |    1 +
 arch/arm/boot/dts/kirkwood-rs409.dts            |    1 +
 arch/arm/boot/dts/kirkwood-rs411.dts            |    1 +
 .../boot/dts/kirkwood-sheevaplug-common.dtsi    |    7 +-
 arch/arm/boot/dts/kirkwood-synology.dtsi        |   10 +-
 arch/arm/boot/dts/kirkwood-t5325.dts            |   42 +-
 arch/arm/boot/dts/kirkwood-topkick.dts          |   13 +-
 arch/arm/boot/dts/kirkwood-ts219-6281.dts       |    2 +-
 arch/arm/boot/dts/kirkwood-ts219-6282.dts       |    2 +-
 arch/arm/boot/dts/kirkwood-ts219.dtsi           |   11 +-
 arch/arm/boot/dts/kirkwood-ts419.dtsi           |    2 +-
 arch/arm/boot/dts/kirkwood.dtsi                 |   75 +-
 arch/arm/boot/dts/omap2420-clocks.dtsi          |  270 +++
 arch/arm/boot/dts/omap2420.dtsi                 |   26 +
 arch/arm/boot/dts/omap2430-clocks.dtsi          |  344 ++++
 arch/arm/boot/dts/omap2430.dtsi                 |   26 +
 arch/arm/boot/dts/omap24xx-clocks.dtsi          | 1244 ++++++++++++
 arch/arm/boot/dts/omap3-lilly-a83x.dtsi         |    7 +-
 arch/arm/boot/dts/omap3-n900.dts                |  225 ++-
 arch/arm/boot/dts/omap3-n950-n9.dtsi            |   14 +
 arch/arm/boot/dts/omap3.dtsi                    |   45 +
 arch/arm/boot/dts/omap34xx.dtsi                 |   11 +
 arch/arm/boot/dts/omap36xx-clocks.dtsi          |    2 +-
 arch/arm/boot/dts/omap36xx.dtsi                 |   11 +
 arch/arm/boot/dts/omap3xxx-clocks.dtsi          |    7 +-
 arch/arm/boot/dts/omap4-duovero-parlor.dts      |   18 +-
 arch/arm/boot/dts/omap4-duovero.dtsi            |   98 +-
 arch/arm/boot/dts/omap4-var-dvk-om44.dts        |   71 +
 .../arm/boot/dts/omap4-var-om44customboard.dtsi |  235 +++
 arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi  |   68 +
 arch/arm/boot/dts/omap4-var-som-om44.dtsi       |  343 ++++
 arch/arm/boot/dts/omap4-var-som.dts             |   96 -
 arch/arm/boot/dts/omap4-var-stk-om44.dts        |   17 +
 arch/arm/boot/dts/omap4.dtsi                    |    3 +
 arch/arm/boot/dts/omap5-cm-t54.dts              |  413 ++++
 arch/arm/boot/dts/omap5-sbc-t54.dts             |   51 +
 arch/arm/boot/dts/omap5.dtsi                    |   48 +
 arch/arm/boot/dts/omap54xx-clocks.dtsi          |   58 +-
 arch/arm/boot/dts/prima2.dtsi                   |   10 +-
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts      |   16 +
 arch/arm/boot/dts/qcom-apq8064-v2.0.dtsi        |    1 +
 arch/arm/boot/dts/qcom-apq8064.dtsi             |  170 ++
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts  |   39 +
 arch/arm/boot/dts/qcom-apq8084-mtp.dts          |    6 +
 arch/arm/boot/dts/qcom-apq8084.dtsi             |  179 ++
 arch/arm/boot/dts/qcom-msm8660-surf.dts         |   10 +
 arch/arm/boot/dts/qcom-msm8660.dtsi             |  115 +-
 arch/arm/boot/dts/qcom-msm8960-cdp.dts          |   10 +
 arch/arm/boot/dts/qcom-msm8960.dtsi             |  176 +-
 arch/arm/boot/dts/qcom-msm8974.dtsi             |   62 +-
 arch/arm/boot/dts/r8a73a4.dtsi                  |   18 -
 .../dts/r8a7740-armadillo800eva-reference.dts   |   44 +-
 arch/arm/boot/dts/r8a7740.dtsi                  |   32 +-
 arch/arm/boot/dts/r8a7778-bockw-reference.dts   |   14 +
 arch/arm/boot/dts/r8a7778.dtsi                  |   30 +-
 arch/arm/boot/dts/r8a7779-marzen-reference.dts  |    1 +
 arch/arm/boot/dts/r8a7779.dtsi                  |   33 +-
 arch/arm/boot/dts/r8a7790-lager.dts             |   62 +-
 arch/arm/boot/dts/r8a7790.dtsi                  |  131 +-
 arch/arm/boot/dts/r8a7791-henninger.dts         |  219 +++
 arch/arm/boot/dts/r8a7791-koelsch.dts           |   78 +-
 arch/arm/boot/dts/r8a7791.dtsi                  |  125 +-
 arch/arm/boot/dts/rk3066a-bqcurie2.dts          |    1 +
 arch/arm/boot/dts/rk3066a.dtsi                  |    2 +-
 arch/arm/boot/dts/rk3188-radxarock.dts          |    1 +
 arch/arm/boot/dts/rk3188.dtsi                   |    9 +-
 arch/arm/boot/dts/rk3xxx.dtsi                   |    9 +-
 arch/arm/boot/dts/sama5d3.dtsi                  |   84 +
 arch/arm/boot/dts/sama5d3xmb.dtsi               |    9 +-
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts    |   15 +-
 arch/arm/boot/dts/socfpga.dtsi                  |  194 +-
 arch/arm/boot/dts/socfpga_arria5.dtsi           |   26 +-
 arch/arm/boot/dts/socfpga_arria5_socdk.dts      |   21 +-
 arch/arm/boot/dts/socfpga_cyclone5.dtsi         |   26 +-
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts    |   21 +-
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts   |    6 +-
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts |   50 +
 arch/arm/boot/dts/socfpga_vt.dts                |    2 +-
 arch/arm/boot/dts/stih407-b2120.dts             |   78 +
 arch/arm/boot/dts/stih407-clock.dtsi            |   39 +
 arch/arm/boot/dts/stih407-pinctrl.dtsi          |  615 ++++++
 arch/arm/boot/dts/stih407.dtsi                  |  263 +++
 arch/arm/boot/dts/stih415-b2000.dts             |    2 +-
 arch/arm/boot/dts/stih415-b2020.dts             |    2 +-
 arch/arm/boot/dts/stih415-clock.dtsi            |  519 ++++-
 arch/arm/boot/dts/stih415-pinctrl.dtsi          |   16 +
 arch/arm/boot/dts/stih415.dtsi                  |   30 +-
 arch/arm/boot/dts/stih416-b2000.dts             |    3 +-
 arch/arm/boot/dts/stih416-b2020-revE.dts        |   35 +
 arch/arm/boot/dts/stih416-b2020.dts             |    3 +-
 arch/arm/boot/dts/stih416-clock.dtsi            |  735 ++++++-
 arch/arm/boot/dts/stih416-pinctrl.dtsi          |   16 +
 arch/arm/boot/dts/stih416.dtsi                  |   30 +-
 arch/arm/boot/dts/stih41x-b2000.dtsi            |   25 +-
 arch/arm/boot/dts/stih41x-b2020.dtsi            |    2 +-
 arch/arm/boot/dts/stih41x.dtsi                  |    7 +
 arch/arm/boot/dts/sun4i-a10-a1000.dts           |   10 +
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts      |   10 +
 arch/arm/boot/dts/sun4i-a10-hackberry.dts       |   10 +
 arch/arm/boot/dts/sun4i-a10-inet97fv2.dts       |   10 +
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts      |   10 +
 arch/arm/boot/dts/sun4i-a10-olinuxino-lime.dts  |   10 +
 arch/arm/boot/dts/sun4i-a10-pcduino.dts         |   10 +
 arch/arm/boot/dts/sun4i-a10.dtsi                |   78 +
 .../arm/boot/dts/sun5i-a10s-olinuxino-micro.dts |   34 +
 arch/arm/boot/dts/sun5i-a10s-r7-tv-dongle.dts   |  100 +
 arch/arm/boot/dts/sun5i-a10s.dtsi               |   41 +
 arch/arm/boot/dts/sun5i-a13-olinuxino-micro.dts |   17 +
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts       |   17 +
 arch/arm/boot/dts/sun5i-a13.dtsi                |   31 +
 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts       |   57 +
 arch/arm/boot/dts/sun6i-a31-colombus.dts        |   47 +
 arch/arm/boot/dts/sun6i-a31-m9.dts              |   50 +
 arch/arm/boot/dts/sun6i-a31.dtsi                |  279 ++-
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts     |   10 +
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts      |   48 +
 arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts       |  176 ++
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts |   27 +
 arch/arm/boot/dts/sun7i-a20.dtsi                |   95 +
 arch/arm/boot/dts/sunxi-common-regulators.dtsi  |   14 +
 arch/arm/boot/dts/tegra114-dalmore.dts          |   21 +-
 arch/arm/boot/dts/tegra114-roth.dts             | 1113 +++++++++++
 arch/arm/boot/dts/tegra114-tn7.dts              |  348 ++++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts       | 1827 ++++++++++++++++++
 arch/arm/boot/dts/tegra124-venice2.dts          |   42 +-
 arch/arm/boot/dts/tegra124.dtsi                 |   12 +
 arch/arm/boot/dts/tegra20-harmony.dts           |   12 +
 arch/arm/boot/dts/tegra30-beaver.dts            |   12 +
 arch/arm/boot/dts/tegra30-colibri-eval-v3.dts   |  205 ++
 arch/arm/boot/dts/tegra30-colibri.dtsi          |  377 ++++
 arch/arm/boot/dts/twl4030.dtsi                  |    6 +
 arch/arm/boot/dts/vf610-colibri.dts             |  123 ++
 arch/arm/boot/dts/vf610-twr.dts                 |   36 +
 arch/arm/boot/dts/vf610.dtsi                    |   24 +
 arch/arm/boot/dts/zynq-7000.dtsi                |   40 +-
 arch/arm/mach-at91/Kconfig                      |    2 -
 arch/arm/mach-at91/at91sam9n12.c                |    6 +-
 arch/arm/mach-at91/at91sam9x5.c                 |    6 +-
 arch/arm/mach-omap2/board-generic.c             |   45 +-
 arch/arm/mach-omap2/gpmc-nand.c                 |    2 +-
 arch/arm/mach-omap2/hdq1w.c                     |    2 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      |    9 +-
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c       |   10 -
 arch/arm/mach-omap2/pdata-quirks.c              |    7 +
 arch/arm/mach-qcom/board.c                      |    4 +-
 drivers/clk/ti/clk-43xx.c                       |    6 +
 drivers/reset/sti/reset-stih415.c               |    1 +
 drivers/reset/sti/reset-stih416.c               |    1 +
 include/dt-bindings/clock/berlin2.h             |   45 +
 include/dt-bindings/clock/berlin2q.h            |   31 +
 include/dt-bindings/clock/r8a7790-clock.h       |    3 +
 include/dt-bindings/clock/r8a7791-clock.h       |    3 +
 include/dt-bindings/clock/stih415-clks.h        |   15 +
 include/dt-bindings/clock/stih416-clks.h        |   15 +
 include/dt-bindings/pinctrl/omap.h              |   13 +-
 .../reset-controller/stih415-resets.h           |    1 +
 .../reset-controller/stih416-resets.h           |    1 +
 include/dt-bindings/reset/altr,rst-mgr.h        |   90 +
 include/dt-bindings/soc/qcom,gsbi.h             |   26 +
 368 files changed, 24586 insertions(+), 2088 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip.txt
 rename Documentation/devicetree/bindings/{arm/altera => reset}/socfpga-reset.txt (85%)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt
 create mode 100644 arch/arm/boot/dts/at91sam9x5_can.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_isi.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_lcd.dtsi
 create mode 100644 arch/arm/boot/dts/berlin2q-marvell-dmp.dts
 create mode 100644 arch/arm/boot/dts/berlin2q.dtsi
 create mode 100644 arch/arm/boot/dts/dra72-evm.dts
 create mode 100644 arch/arm/boot/dts/dra72x.dtsi
 create mode 100644 arch/arm/boot/dts/dra74x.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5260-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5260-xyref5260.dts
 create mode 100644 arch/arm/boot/dts/exynos5260.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5800-peach-pi.dts
 create mode 100644 arch/arm/boot/dts/exynos5800.dtsi
 create mode 100644 arch/arm/boot/dts/imx35-pdk.dts
 create mode 100644 arch/arm/boot/dts/imx51-digi-connectcore-jsk.dts
 create mode 100644 arch/arm/boot/dts/imx51-digi-connectcore-som.dtsi
 create mode 100644 arch/arm/boot/dts/imx6dl-phytec-pbab01.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-phytec-pfla02.dtsi
 create mode 100644 arch/arm/boot/dts/imx6dl-riotboard.dts
 create mode 100644 arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-km_common.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-km_fixedeth.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-nsa320.dts
 rename arch/arm/boot/dts/{kirkwood-nsa310-common.dtsi => kirkwood-nsa3x0-common.dtsi} (58%)
 create mode 100644 arch/arm/boot/dts/kirkwood-openrd-base.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-openrd-client.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-openrd-ultimate.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-openrd.dtsi
 create mode 100644 arch/arm/boot/dts/omap2420-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/omap2430-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/omap24xx-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/omap4-var-dvk-om44.dts
 create mode 100644 arch/arm/boot/dts/omap4-var-om44customboard.dtsi
 create mode 100644 arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi
 create mode 100644 arch/arm/boot/dts/omap4-var-som-om44.dtsi
 delete mode 100644 arch/arm/boot/dts/omap4-var-som.dts
 create mode 100644 arch/arm/boot/dts/omap4-var-stk-om44.dts
 create mode 100644 arch/arm/boot/dts/omap5-cm-t54.dts
 create mode 100644 arch/arm/boot/dts/omap5-sbc-t54.dts
 create mode 100644 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
 create mode 100644 arch/arm/boot/dts/qcom-apq8064-v2.0.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-apq8064.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-apq8084-mtp.dts
 create mode 100644 arch/arm/boot/dts/qcom-apq8084.dtsi
 create mode 100644 arch/arm/boot/dts/r8a7791-henninger.dts
 create mode 100644 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts
 create mode 100644 arch/arm/boot/dts/stih407-b2120.dts
 create mode 100644 arch/arm/boot/dts/stih407-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih407-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih407.dtsi
 create mode 100644 arch/arm/boot/dts/stih416-b2020-revE.dts
 create mode 100644 arch/arm/boot/dts/sun5i-a10s-r7-tv-dongle.dts
 create mode 100644 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts
 create mode 100644 arch/arm/boot/dts/sun6i-a31-m9.dts
 create mode 100644 arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts
 create mode 100644 arch/arm/boot/dts/tegra114-roth.dts
 create mode 100644 arch/arm/boot/dts/tegra114-tn7.dts
 create mode 100644 arch/arm/boot/dts/tegra124-jetson-tk1.dts
 create mode 100644 arch/arm/boot/dts/tegra30-colibri-eval-v3.dts
 create mode 100644 arch/arm/boot/dts/tegra30-colibri.dtsi
 create mode 100644 arch/arm/boot/dts/vf610-colibri.dts
 create mode 100644 include/dt-bindings/clock/berlin2.h
 create mode 100644 include/dt-bindings/clock/berlin2q.h
 create mode 100644 include/dt-bindings/clock/stih415-clks.h
 create mode 100644 include/dt-bindings/clock/stih416-clks.h
 create mode 100644 include/dt-bindings/reset/altr,rst-mgr.h
 create mode 100644 include/dt-bindings/soc/qcom,gsbi.h
