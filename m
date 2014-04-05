Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaDETGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:06:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:59685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaDETGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:06:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 5/8] ARM: SoC: device tree changes
Date: Sat, 5 Apr 2014 20:05:28 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201404052101.19381.arnd@arndb.de>
In-Reply-To: <201404052101.19381.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201404052105.28848.arnd@arndb.de>
X-Provags-ID: V02:K0:0Jb2PGGaLAQVOv86ZlT3t2Lu8XtpILr6ph4Up0G3QBS
 XdjT0jmBcKG3osOOKciwUTq8bJCKRlqR2gNlQzxmbOjcTjwo5M
 nlKsrJbB9oJVsYkXQbBYplG1iSOFRq03UEk3i/8B1ywYC8InnQ
 CQEiAuE0O+fa60IaDxQXxKCYh/DszwNj1oPc8t/5Ly4fa2nhYF
 eFtpvpWLzh13OvescFUzAA3XIByhw4D6xy2jVdQWYDcbxwebfi
 AvR76A837pnxOPKbpnwHZxW1z/uBsjOKSvFMiACE6ehBnh9vg1
 k0WpUwDuS960AUR5cAu7Qv6qeNYc74jl+k2cPSN/p38FD7BEdz
 8hY0DAvkpAZDdSFg6By3x5FzI3ZFnsd//yB+XAXzM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 00e8ec2f0b05bfc8acaf13cf91c2ca1e624f3535:

  ARM: mvebu: move DT Dove to MVEBU (2014-03-04 04:13:48 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-3.15

for you to fetch changes up to 50b4af414d414af9e4df6f64e613bb0ffe581055:

  dts: stmmac: Document the clocks property in the stmmac base document (2014-03-29 01:12:08 +0100)

----------------------------------------------------------------
ARM: SoC: device tree changes

A large part of the arm-soc patches are nowadays DT changes, adding support
for new SoCs, boards and devices without changing kernel source. The plan
is still to move the devicetree files out of the kernel tree and reduce
the amount of churn going on here, but we keep finding reasons to delay
doing that.

Changes are really all over the place, with little sticking out particularly.
We have contributions from a total of 116 people in this branch.

Unfortunately, the size of this branch also causes a significant number
of conflicts at the moment, typically when subsystem maintainers merge
patches that change the driver at the same time as the dts files. In
most cases this could be avoided because the dts changes are supposed
to be compatible in both ways, and we are asking everyone to send ARM
dts changes through our tree only.

Conflicts:
* keystone-clocks.dtsi is split up into per-soc files, which conflicts
  with a bug-fix that went into 3.14. The new location already has the
  correct fix, so all conflicting lines can be removed
* qcom adds new nodes that conflict with an earlier branch. Remember
  the closing '};' at the end of the node.
* same issue in sun7i-a20.dtsi
* multiple header file inclusions are added in
  arch/arm/mach-omap2/pdata-quirks.c, they are all needed.
* The MACH_UX500_DT gets removed, but was changed in the cleanup
  branch. We still want to remove it.
* A change in the at91_adc.txt binding conflicts with a typo fix
* In the stmmac.txt binding, a clarification on the max-frame-size
  conflicts with the missing clock documentation that was added
* Changes to arch/arm/boot/dts/imx53-qsb.dts from 17b5001b5143e
  "imx-drm: convert to componentised device support" and
  e05c8c9a790a0 "ARM: dts: imx53: Add IPU DI ports and endpoints,
  move imx-drm node to dtsi" now need to be applied to
  arch/arm/boot/dts/imx53-qsb-common.dtsi instead, as the modified
  nodes have been moved to a new file

There is another tag 'tags/dt-3.15-resolved' that contains my
merge of this with today's snapshot of 3.15-rc, for reference.

----------------------------------------------------------------
Aida Mynzhasova (1):
      ARM: dts: mxs: add auart2 pinmux to imx28.dtsi

Alex Elder (1):
      ARM: dts: bcm281xx: define real clocks

Alexander Shiyan (30):
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

Alexandre Belloni (12):
      ARM: dts: mxs: add #io-channel-cells to mx28 lradc
      ARM: dts: mxs: Add iio-hwmon to mx28 soc
      ARM: dts: mxs: Add iio-hwmon to mx23 soc
      ARM: at91/DT: atmel_usba correct atmel,vbus-gpio meaning
      Documentation: dt: iio: improve atmel-adc documentation
      Documentation: dt: iio: move arm/atmel-adc.txt to iio/adc/at91_adc.txt
      ARM: at91/dt: at91-ariag25: remove useless adc properties
      ARM: at91/dt: at91sam9260: remove useless adc properties
      ARM: at91/dt: at91sam9g45: remove useless adc properties
      ARM: at91/dt: at91sam9x5: remove useless adc properties
      ARM: at91/dt: sama5d3: remove useless adc properties
      ARM: at91/dt: at91-cosino: remove useless adc properties

Andrew Lunn (11):
      ARM: Kirkwood: Add support for Excito Bubba B3
      ARM: Kirkwood: Add DT description of QNAP 419
      ARM: Kirkwood: Add DT description of rd88f6192.
      ARM: Kirkwood: convert rd88f6281-setup.c to DT.
      DT: Vendor prefixes: Add ricoh, qnap, sii and synology
      DT: i2c: Trivial: Add sii,s35390a
      ARM: kirkwood: Instantiate L2 cache from DT.
      ARM: mvebu: Instantiate system controller in kirkwood.dtsi
      ARM: kirkwood: Add audio node to kirkwood.dtsi
      ARM: kirkwood: Add i2c alias so setting bus number
      ARM: kirkwood: Add dts file describing HP T5325 thin client

Andrii.Tseglytskyi (2):
      ARM: dts: OMAP36xx: Add device node for ABB
      ARM: dts: OMAP4: Add device nodes for ABB

Andrzej Hajda (4):
      ARM: dts: use macros in clock bindings for exynos4
      ARM: dts: use macros in clock bindings for exynos5250
      ARM: dts: use macros in clock bindings for exynos5420
      ARM: dts: use macros in clock bindings for exynos5440

Anson Huang (9):
      ARM: dts: imx6q: update setting of VDDARM_CAP voltage
      ARM: dts: imx6q: add vddsoc/pu setpoint info
      ARM: dts: imx6dl: enable cpufreq support
      ARM: dts: imx6qdl: add necessary thermal clk
      ARM: dts: imx6qdl-sabresd: Add power key support
      ARM: dts: imx6sl: add ocram device support
      ARM: dts: imx6sl: add keypad support for i.mx6sl-evk board.
      ARM: dts: imx6qdl-sabresd: correct gpio key's active state
      ARM: dts: imx6q: add 852MHz setpoint for CPU freq

Archit Taneja (1):
      ARM: dts: omap4+: Add DMM bindings

Arnd Bergmann (16):
      Merge tag 'mvebu-dt-3.15-2' of git://git.infradead.org/linux-mvebu into next/dt
      Merge branch 'qcom/cleanup' into next/dt
      Merge tag 'qcom-dt-for-3.15' of git://git.kernel.org/.../galak/linux-qcom into next/dt
      Merge branch 'efm32/cleanup' into next/dt
      Merge tag 'efm32-next' of git://git.pengutronix.de/git/ukl/linux into next/dt
      Merge tag 'mvebu-dt-3.15-3' of git://git.infradead.org/linux-mvebu into next/dt
      Merge branch 'mvebu/soc3' into next/dt
      Merge tag 'mvebu-dt-3.15-4' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'mvebu-dt-3.15-5' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'sunxi-dt-for-3.15-2' of https://github.com/mripard/linux into next/dt
      Merge tag 'omap-for-v3.15/dt-part3' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'omap-for-v3.15/dt-overo-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'armsoc/for-3.15/dt-2' of git://github.com/broadcom/mach-bcm into next/dt
      Merge tag 'DT-for-v3.15-part-1-v2' of git://git.stlinux.com/devel/kernel/linux-sti into next/dt
      Merge tag 'keystone-dts-fixes' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt

Ashutosh singh (4):
      ARM: dts: imx6q-phytec: Added USB_OTG Support
      ARM: dts: imx6q-phytec: Added USB_HOST Support
      ARM: dts: imx6q-phytec: Added GPMI-NAND Support
      ARM: dts: imx6q-phytec: Added SATA Support

Balaji T K (3):
      ARM: dts: am437x gp-evm: add sd card dt nodes
      ARM: dts: am335x-evm: add SD card hotplug support
      ARM: dts: am43x-epos-evm: add SD card hotplug support

Ben Peddell (1):
      ARM: Kirkwood: Add support for many Synology NAS devices

Bryan Wu (1):
      ARM: tegra: enable PCA9546 on Cardhu

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

David Lanzendörfer (1):
      ARM: sun4i: dt: Add support for the INet-97F_Rev_02 board

Denis Carikli (12):
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

Dinh Nguyen (2):
      dts: socfpga: Add DTS entry for adding the stmmac glue layer for stmmac.
      dts: stmmac: Document the clocks property in the stmmac base document

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

Ezequiel Garcia (7):
      ARM: mvebu: Enable Armada 370/XP watchdog in the devicetree
      ARM: kirkwood: Add RSTOUT 'reg' entry to devicetree
      ARM: dove: Enable Dove watchdog in the devicetree
      ARM: mvebu: Add a 2 GHz fixed-clock on Armada 38x SoCs
      ARM: mvebu: Add the Core Divider clock to Armada 38x SoCs
      ARM: mvebu: Add support for NAND controller in Armada 38x SoC
      ARM: mvebu: Enable NAND controller in Armada 385-DB

Fabio Estevam (15):
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

Florian Meier (2):
      ARM: bcm2835: add dmaengine driver to device tree
      ARM: bcm2835: add I2S driver to device tree

Florian Vaussard (21):
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

Frank Li (1):
      ARM: dts: imx6qdl: enable dma for spi

Fugang Duan (1):
      ARM: dts: vf610-twr: Add ADC support

Geert Uytterhoeven (8):
      ARM: shmobile: r8a7791: Add thermal clock in device tree
      ARM: shmobile: r8a7790: Add thermal clock in device tree
      ARM: shmobile: r7s72100 dtsi: Add RSPI nodes
      ARM: shmobile: r8a7791 dtsi: Add QSPI node
      ARM: shmobile: koelsch dts: Add QSPI nodes
      ARM: shmobile: r8a7790 dtsi: Add QSPI node
      ARM: shmobile: lager dts: Add QSPI nodes
      ARM: shmobile: r8a7778 dtsi: Remove duplicate i2c nodes

Greg Ungerer (3):
      ARM: dts: imx: add device tree pin definitions for the IMX50
      ARM: dts: imx: add IMX50 SoC device tree
      ARM: dts: imx: add device tree support for Freescale imx50evk board

Gregory CLEMENT (2):
      ARM: mvebu: add Device Tree description of the Armada 375 SoC
      ARM: mvebu: add Device Tree for the Armada 385 RD board

Grygorii Strashko (3):
      ARM: dts: keystone: add gpio device entry
      ARM: dts: k2hk-evm: add leds supports
      ARM: dts: k2hk-evm: rename clock node to clocks

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

Hauke Mehrtens (1):
      ARM: BCM5301X: add dts files for BCM4708 SoC

Huang Shijie (1):
      ARM: dts: vf610: use the interrupt macros

Imre Kaloz (1):
      ARM: OMAP2+: Use pdata quirks for wl12xx on the AM335x EV-MSK

Ivan Khoronzhuk (7):
      ARM: dts: keystone: add watchdog entry
      ARM: dts: keystone: add keystone timer entry
      ARM: dts: keystone: drop msmcsram clock node
      ARM: dts: keystone: add AEMIF/NAND device entry
      ARM: dts: keystone: Fix domain register range for clkfftc1
      ARM: dts: keystone: Fix control register range for clktsip
      ARM: dts: keystone: use common "ti,keystone" compatible instead of -evm

Jason Cooper (3):
      Merge tag 'tags/mvebu-dt-fixes-3.14' into mvebu/dt
      Merge branch 'mvebu/dt-3xx' into mvebu/dt
      ARM: mvebu: select dtbs from MACH_ARMADA_*

Jingchang Lu (1):
      ARM: dts: vf610: Add eDMA node

John Tobias (1):
      ARM: dts: imx6sl: Adding cpu frequency and VDDSOC/PU table.

Kishon Vijay Abraham I (1):
      ARM: dts: omap5: added dt properties to adapt to the new phy framwork

Kuninori Morimoto (1):
      ARM: shmobile: lager: add SDHI0/2 support on DTS

Laurent Pinchart (12):
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
      ARM: shmobile: lager: Add DU device to DTS
      ARM: shmobile: koelsch-reference: Add DU device to DTS

Laxman Dewangan (1):
      ARM: tegra: add system-power-controller property for PMIC node

Lee Jones (2):
      ARM: STi: stih416: Add support for the FSM Serial Flash Controller
      ARM: STi: stih41x: Add support for the FSM Serial Flash Controller

Leela Krishna Amudala (2):
      ARM: dts: Add pmu sysreg node to exynos5250 and exynos5420
      ARM: dts: update watchdog device nodes for exynos5250 and exynos5420

Linus Walleij (16):
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
      ARM: ux500: switch SSP/SPI clock name to "SSPCLK"
      ARM: u300: switch SSP/SPI clock name to "SSPCLK"
      ARM: ux500: delete pointless DT config option
      ARM: ux500: skip GIC CPU and dist address checks
      ARM: ux500: drop a chunk of GPIO definitions
      mfd: dbx500/abx500: root out hardcoded IRQ assignments

Liu Ying (2):
      ARM: dts: i.MX51 babbage: Support diagnostic LED
      ARM: dts: imx6qdl-sabreauto: Support debug LED

Lokesh Vutla (1):
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

Magnus Damm (2):
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

Markus Mayer (2):
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

Matt Porter (4):
      ARM: dts: AM33XX: Add ecap interrupt properties
      ARM: dts: remove bcm11351-brt.dts
      ARM: dts: add bcm590xx pmu support and enable for bcm28155-ap
      ARM: dts: bcm28155-ap: leave camldo1 on to fix reboot

Maxime Ripard (21):
      ARM: sun4i: a10: Add missing serial aliases
      ARM: sun5i: a10s: Add missing serial aliases
      ARM: sun6i: Add missing serial aliases
      ARM: sun7i: Add missing serial aliases
      ARM: sun5i: a13: Add missing serial aliases
      ARM: sun6i: dt: Add PLL6 and SPI module clocks
      ARM: sun6i: dt: Add SPI controllers to the A31 DTSI
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

Michael Grzeschik (1):
      ARM: i.MX28: dts: rename usbphy pin names

Michael Heimpold (1):
      ARM: mxs: add support for I2SE's duckbill series

Murali Karicheri (6):
      ARM: dts: keystone: fix domain id for clkdebugsstrc
      ARM: dts: keystone: update for supporting K2L/K2E EVMs
      ARM: dts: keystone: preparatory patch to support K2L and K2E SOCs
      ARM: dts: keystone: add support for K2 Lamarr SoC and EVM
      ARM: dts: keystone: add support for k2 Edison SoC and EVM
      ARM: dts: k2hk-evm: set ubifs partition size for 512M NAND

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

Nishanth Menon (4):
      ARM: dts: OMAP3+: add clock nodes for CPU
      ARM: dts: Add basic devices for AM3517-craneboard
      ARM: dts: omap3430-sdp: add dip switch information for MMC operation
      ARM: dts: DRA7: Add device nodes for ABB

Oliver Schinagl (1):
      ARM: sun4i: dt: Add ahci / sata support

Olof Johansson (21):
      Merge tag 'renesas-dt-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'imx6-dt-3.15' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-dt-3.15' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'ab8500-dt-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'renesas-dt2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'mvebu-dt-3.15' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'omap-for-v3.15/dt-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'samsung-dt' of http://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'exynos-clk' of http://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'sunxi-dt-for-3.15' of https://github.com/mripard/linux into next/dt
      Merge tag 'ux500-dt-v3.15-2' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'imx6-dt-3.15-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-dt-3.15-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'keystone-dts' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt
      Merge tag 'armsoc/for-3.15/dt' of git://github.com/broadcom/mach-bcm into next/dt
      Merge tag 'bcm2835-for-3.15-dt' of git://git.kernel.org/.../swarren/linux-rpi into next/dt
      Merge tag 'omap-for-v3.15/dt-part2' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'zynq-dt-for-3.15' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'renesas-dt3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-dt4-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'tegra-for-3.15-dt' of git://git.kernel.org/.../tegra/linux into next/dt

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

Philipp Zabel (1):
      ARM: dts: imx6q-sabrelite: PHY reset is active-low

Robert Nelson (1):
      ARM: dts: imx53: Enable AHCI SATA for imx53-qsb

Roger Quadros (3):
      ARM: OMAP2+: Remove legacy_init_ehci_clk()
      ARM: dts: Get rid of incompatible ids for hci-omap USB host nodes
      ARM: dts: Update echi-omap DT binding example usage

Rohit Vaswani (1):
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

Sachin Kamat (9):
      ARM: dts: Add regulator entries to smdk5420
      ARM: dts: Re-organize RTC status for exynos5420
      ARM: dts: Re-organize RTC status for exynos5250
      ARM: dts: Add ADMA node to exynos5420
      ARM: dts: Add I2S nodes to exynos5420
      ARM: dts: Add fixed voltage regulators to smdk5420
      ARM: dts: Add PMIC support to arndale-octa board
      ARM: dts: Add wake up key to arndale-octa board
      ARM: dts: Add vmmc-supply to MMC on arndale-octa board

Santosh Shilimkar (1):
      ARM: dts: Build all keystone dt blobs

Sascha Hauer (6):
      ARM: dts: imx53: Add mmc aliases
      ARM: dts: imx51: Add mmc aliases
      ARM: dts: imx6q: Add spi4 alias
      ARM: dts: imx6qdl: Add mmc aliases
      ARM: dts: imx6: Add DFI FS700-M60 board support
      ARM: dts: imx6q: Add support for Zealz GK802

Sascha Silbe (1):
      ARM: dts: imx6qdl-wandboard: use GPIO_6 for FEC interrupt

Sebastian Hesselbarth (4):
      ARM: dove: add additional pinctrl registers
      ARM: dove: add global-config register node
      ARM: dove: add system controller node
      ARM: dove: drop pinctrl PMU reg property

Sebastian Reichel (7):
      ARM: dts: omap3 clocks: simplify ssi aliases
      ARM: dts: TWL4030: Add keypad node
      ARM: dts: OMAP3-N900: Add TWL4030 Keypad Matrix
      ARM: dts: OMAP3-N900: Add support for tsl2563
      ARM: dts: OMAP3-N900: Add tpa6130a2 support
      ARM: dts: OMAP3-N900: Add isp1704 support
      ARM: dts: OMAP3-N900: Add bq24150a support

Sergei Shtylyov (4):
      ARM: shmobile: r8a7790: add Ether DT support
      ARM: shmobile: lager: add Ether DT support
      ARM: shmobile: r8a7791: add Ether DT support
      ARM: shmobile: koelsch: add Ether DT support

Shawn Guo (8):
      ARM: dts: imx6qdl: make pinctrl nodes board specific
      ARM: dts: imx6sl: make pinctrl nodes board specific
      ARM: dts: imx6: use generic node name for fixed regulator
      ARM: dts: imx53: make pinctrl nodes board specific
      ARM: dts: imx51: make pinctrl nodes board specific
      ARM: dts: vf610: make pinctrl nodes board specific
      ARM: dts: imx53-mba53: create a container for fixed regulators
      ARM: dts: imx: use generic node name for fixed regulator

Silvio F (2):
      DT: Add Data Modul vendor prefix
      ARM: dts: imx6: Add support for imx6q dmo edmqmx6

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

Srinivas Kandagatla (10):
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

Stanimir Varbanov (2):
      ARM: dts: qcom: Add RNG device tree node
      ARM: dts: qcom-msm8960-cdp: Add RNG device tree node

Stefan Roese (2):
      arm: dts: am33xx.dtsi: Add node name to rtc device node
      ARM: dts: Add MMC2/SDIO/WLAN support for cm-t3530

Steffen Trumtrar (3):
      ARM: dts: Add support for the i.MX35.
      ARM: dts: i.MX53: move common QSB nodes to new file
      ARM: dts: i.MX53: add support for MCIMX53-START-R

Stephen Warren (9):
      ARM: tegra: document which Dalmore revisions are supported
      ARM: bcm2835: fix DT node sort order
      ARM: tegra: enable LCD panel on Seaboard
      ARM: tegra: enable LCD panel on Ventana
      ARM: tegra: add SPI flash to Venice2 DT
      ARM: bcm2835: node name unit address cleanup
      ARM: bcm2835: fix clock DT node names
      ARM: tegra: use 2 address cells for Tegra124 DT
      ARM: tegra: fix Dalmore pinctrl configuration

Suman Anna (9):
      ARM: dts: OMAP: Add #hwlock-cells property to hwspinlock nodes
      ARM: dts: DRA7: Add hwspinlock node
      ARM: dts: AM4372: Add hwspinlock node
      ARM: OMAP3: fix iva mmu programming issues
      ARM: OMAP2+: change the ISP device archdata MMU name for DT
      ARM: OMAP2+: use pdata quirks for iommu reset lines
      ARM: OMAP5: hwmod data: add mmu data for ipu & dsp
      ARM: OMAP2+: extend iommu pdata-quirks to OMAP5
      ARM: dts: OMAP5: Add IOMMU nodes

Sébastien Szymanski (1):
      ARM: dts: imx28-apf28dev: add user button

Takashi Yoshii (1):
      ARM: shmobile: koelsch: (1+1)GiB memory in DT

Thierry Reding (12):
      ARM: tegra: Properly sort clocks property
      ARM: tegra: Use "disabled" for status property
      ARM: tegra: Combine VBUS enable pins into one node
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

Thomas Petazzoni (17):
      ARM: mvebu: use GPIO DT defines in Armada 370/XP boards
      ARM: mvebu: use input DT defines in Armada 370/XP boards
      ARM: mvebu: add audio I2S controller to Armada 370 Device Tree
      ARM: mvebu: add I2C0 muxing option for Armada 370 SoC
      ARM: mvebu: add audio support to Armada 370 DB
      ARM: mvebu: enable S/PDIF audio in Armada 370 DB Device Tree
      ARM: mvebu: add Device Tree for the Armada 375 DB board
      ARM: mvebu: add Device Tree description of the Armada 380/385 SoCs
      ARM: mvebu: add Device Tree for the Armada 385 DB board
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

Tony Lindgren (1):
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

Uwe Kleine-König (2):
      ARM: efm32: fix unit address part in USART2 device nodes' names
      ARM: efm32: properly namespace i2c location property

Valentin Raevsky (1):
      ARM: dts: Add initial support for cm-fx6.

Valentine Barshak (4):
      ARM: shmobile: r8a7791: Add SATA nodes to r8a7791.dtsi
      ARM: shmobile: koelsch: Enable SATA0 in r8a7791-koelsch.dts
      ARM: shmobile: r8a7790: Add SATA nodes to r8a7790.dtsi
      ARM: shmobile: lager: Enable SATA1 in r8a7790-lager.dts

Vince Weaver (1):
      ARM: bcm2835: perf_event support for Raspberry-Pi

Wolfram Sang (8):
      ARM: shmobile: r8a7791: remove superfluous interrupt-parents
      ARM: shmobile: r8a7790: remove superfluous interrupt-parents
      ARM: shmobile: r8a7790: add i2c aliases to dtsi
      ARM: shmobile: r8a7791: add i2c master nodes to dtsi
      ARM: shmobile: r8a7791: add i2c2 bus to koelsch dt
      ARM: shmobile: r7s72100: add nodes for i2c controllers to dtsi
      ARM: shmobile: genmai: adapt dts to use native i2c driver
      ARM: shmobile: r8a7791: fix clock index for i2c5

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

Zalan Blenessy (1):
      ARM: sun7i: dt: Add USB host nodes to a20-olinuxino-micro dts

Zoltan HERPAI (1):
      ARM: sun4i: dt: Add basic board support for LinkSprite pcDuino

 .../devicetree/bindings/arm/bcm/bcm21664.txt       |  15 +
 .../devicetree/bindings/arm/bcm/kona-resetmgr.txt  |  14 +
 .../devicetree/bindings/arm/keystone/keystone.txt  |  10 +
 Documentation/devicetree/bindings/arm/omap/dmm.txt |  22 +
 .../devicetree/bindings/arm/omap/omap.txt          |   6 +
 .../devicetree/bindings/arm/samsung/pmu.txt        |  15 +
 .../devicetree/bindings/clock/exynos4-clock.txt    | 259 +-----
 .../devicetree/bindings/clock/exynos5250-clock.txt | 163 +---
 .../devicetree/bindings/clock/exynos5420-clock.txt | 184 +---
 .../devicetree/bindings/clock/exynos5440-clock.txt |  45 +-
 .../devicetree/bindings/i2c/trivial-devices.txt    |   1 +
 .../{arm/atmel-adc.txt => iio/adc/at91_adc.txt}    |  33 +-
 .../devicetree/bindings/net/socfpga-dwmac.txt      |  27 +
 Documentation/devicetree/bindings/net/stmmac.txt   |   6 +
 .../bindings/pci/nvidia,tegra20-pcie.txt           |   8 +
 .../devicetree/bindings/reset/st,sti-powerdown.txt |  47 ++
 .../devicetree/bindings/reset/st,sti-softreset.txt |  46 +
 .../devicetree/bindings/usb/atmel-usb.txt          |   4 +-
 .../devicetree/bindings/usb/ehci-omap.txt          |   2 +-
 .../devicetree/bindings/usb/ohci-omap3.txt         |   2 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   7 +
 arch/arm/boot/dts/Makefile                         | 123 ++-
 arch/arm/boot/dts/am335x-evm.dts                   |  60 +-
 arch/arm/boot/dts/am335x-evmsk.dts                 |  56 ++
 arch/arm/boot/dts/am33xx.dtsi                      |  13 +-
 arch/arm/boot/dts/am3517-craneboard.dts            | 174 ++++
 arch/arm/boot/dts/am4372.dtsi                      |  46 +
 arch/arm/boot/dts/am437x-gp-evm.dts                | 127 +++
 arch/arm/boot/dts/am43x-epos-evm.dts               | 183 ++++
 arch/arm/boot/dts/armada-370-db.dts                |  56 ++
 arch/arm/boot/dts/armada-370-mirabox.dts           |   7 +-
 arch/arm/boot/dts/armada-370-rd.dts                |   6 +-
 arch/arm/boot/dts/armada-370-xp.dtsi               |   8 +-
 arch/arm/boot/dts/armada-370.dtsi                  |  33 +
 arch/arm/boot/dts/armada-375-db.dts                | 130 +++
 arch/arm/boot/dts/armada-375.dtsi                  | 464 ++++++++++
 arch/arm/boot/dts/armada-380.dtsi                  | 117 +++
 arch/arm/boot/dts/armada-385-db.dts                | 122 +++
 arch/arm/boot/dts/armada-385-rd.dts                |  94 +++
 arch/arm/boot/dts/armada-385.dtsi                  | 149 ++++
 arch/arm/boot/dts/armada-38x.dtsi                  | 376 +++++++++
 arch/arm/boot/dts/armada-xp-axpwifiap.dts          |   6 +-
 arch/arm/boot/dts/armada-xp-db.dts                 |  13 +-
 arch/arm/boot/dts/armada-xp-gp.dts                 |  22 +-
 arch/arm/boot/dts/armada-xp-matrix.dts             |   7 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   |  12 +-
 arch/arm/boot/dts/armada-xp.dtsi                   |   6 +
 arch/arm/boot/dts/at91-ariag25.dts                 |   1 -
 arch/arm/boot/dts/at91-cosino.dtsi                 |   1 -
 arch/arm/boot/dts/at91-cosino_mega2560.dts         |   1 -
 arch/arm/boot/dts/at91sam9260.dtsi                 |  11 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  12 +-
 arch/arm/boot/dts/at91sam9n12.dtsi                 |   1 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  14 +-
 arch/arm/boot/dts/bcm11351.dtsi                    | 192 +++--
 .../dts/{bcm11351-brt.dts => bcm21664-garnet.dts}  |  12 +-
 arch/arm/boot/dts/bcm21664.dtsi                    | 292 +++++++
 arch/arm/boot/dts/bcm28155-ap.dts                  |  51 +-
 arch/arm/boot/dts/bcm2835.dtsi                     |  92 +-
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts        |  35 +
 arch/arm/boot/dts/bcm4708.dtsi                     |  34 +
 arch/arm/boot/dts/bcm5301x.dtsi                    |  95 +++
 arch/arm/boot/dts/bcm59056.dtsi                    |  74 ++
 arch/arm/boot/dts/dove.dtsi                        |  22 +-
 arch/arm/boot/dts/dra7.dtsi                        | 151 ++++
 arch/arm/boot/dts/efm32gg-dk3750.dts               |   2 +-
 arch/arm/boot/dts/efm32gg.dtsi                     |   4 +-
 arch/arm/boot/dts/exynos4.dtsi                     |  73 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |   9 +-
 arch/arm/boot/dts/exynos4412-odroidx.dts           |   2 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |   4 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |  34 +-
 arch/arm/boot/dts/exynos5.dtsi                     |   7 -
 arch/arm/boot/dts/exynos5250-arndale.dts           |   4 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts          | 146 ++++
 arch/arm/boot/dts/exynos5250-snow.dts              |   4 +
 arch/arm/boot/dts/exynos5250.dtsi                  | 118 +--
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      | 298 +++++++
 arch/arm/boot/dts/exynos5420-smdk5420.dts          | 253 ++++++
 arch/arm/boot/dts/exynos5420.dtsi                  | 159 +++-
 arch/arm/boot/dts/exynos5440.dtsi                  |  33 +-
 arch/arm/boot/dts/imx23-evk.dts                    |   8 +-
 arch/arm/boot/dts/imx23-olinuxino.dts              |   5 +-
 arch/arm/boot/dts/imx23-stmp378x_devb.dts          |   5 +-
 arch/arm/boot/dts/imx23.dtsi                       |   8 +-
 arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi       |  73 ++
 .../boot/dts/imx25-eukrea-mbimxsd25-baseboard.dts  | 174 ++++
 arch/arm/boot/dts/imx25-pinfunc.h                  | 494 +++++++++++
 arch/arm/boot/dts/imx25.dtsi                       |  18 +-
 arch/arm/boot/dts/imx27-apf27.dts                  |  38 +
 arch/arm/boot/dts/imx27-apf27dev.dts               | 149 +++-
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts   |  77 +-
 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dts   |  44 -
 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi  | 103 +++
 arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts     | 178 +++-
 ...ycore-som.dts => imx27-phytec-phycore-som.dtsi} | 133 ++-
 arch/arm/boot/dts/imx27-pinfunc.h                  | 526 ++++++++++++
 arch/arm/boot/dts/imx27.dtsi                       | 207 +++--
 arch/arm/boot/dts/imx28-apf28dev.dts               |  29 +-
 arch/arm/boot/dts/imx28-apx4devkit.dts             |   5 +-
 arch/arm/boot/dts/imx28-cfa10036.dts               |   2 +
 arch/arm/boot/dts/imx28-cfa10037.dts               |   7 +-
 arch/arm/boot/dts/imx28-cfa10049.dts               |  31 +-
 arch/arm/boot/dts/imx28-cfa10057.dts               |   7 +-
 arch/arm/boot/dts/imx28-cfa10058.dts               |   7 +-
 arch/arm/boot/dts/imx28-duckbill.dts               | 121 +++
 arch/arm/boot/dts/imx28-eukrea-mbmx283lc.dts       |  71 ++
 arch/arm/boot/dts/imx28-eukrea-mbmx287lc.dts       |  50 ++
 arch/arm/boot/dts/imx28-eukrea-mbmx28lc.dtsi       | 326 +++++++
 arch/arm/boot/dts/imx28-evk.dts                    |  24 +-
 arch/arm/boot/dts/imx28-m28cu3.dts                 |  17 +-
 arch/arm/boot/dts/imx28-m28evk.dts                 |  20 +-
 arch/arm/boot/dts/imx28-sps1.dts                   |   7 +-
 arch/arm/boot/dts/imx28-tx28.dts                   |  24 +-
 arch/arm/boot/dts/imx28.dtsi                       |  65 +-
 arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi       |  81 ++
 .../boot/dts/imx35-eukrea-mbimxsd35-baseboard.dts  | 143 ++++
 arch/arm/boot/dts/imx35.dtsi                       | 359 ++++++++
 arch/arm/boot/dts/imx50-evk.dts                    | 119 +++
 arch/arm/boot/dts/imx50-pinfunc.h                  | 923 ++++++++++++++++++++
 arch/arm/boot/dts/imx50.dtsi                       | 478 +++++++++++
 arch/arm/boot/dts/imx51-apf51.dts                  |  40 +-
 arch/arm/boot/dts/imx51-apf51dev.dts               | 102 ++-
 arch/arm/boot/dts/imx51-babbage.dts                | 255 +++++-
 arch/arm/boot/dts/imx51-eukrea-cpuimx51.dtsi       |  93 ++
 .../boot/dts/imx51-eukrea-mbimxsd51-baseboard.dts  | 175 ++++
 arch/arm/boot/dts/imx51.dtsi                       | 459 ++--------
 arch/arm/boot/dts/imx53-ard.dts                    |  33 +-
 arch/arm/boot/dts/imx53-evk.dts                    | 126 ---
 arch/arm/boot/dts/imx53-m53evk.dts                 | 232 ++++-
 arch/arm/boot/dts/imx53-mba53.dts                  |  39 +-
 arch/arm/boot/dts/imx53-qsb-common.dtsi            | 345 ++++++++
 arch/arm/boot/dts/imx53-qsb.dts                    | 219 +----
 arch/arm/boot/dts/imx53-qsrb.dts                   | 158 ++++
 arch/arm/boot/dts/imx53-smd.dts                    | 119 ++-
 arch/arm/boot/dts/imx53-tqma53.dtsi                | 175 +++-
 arch/arm/boot/dts/imx53-tx53-x03x.dts              | 315 +++++++
 arch/arm/boot/dts/imx53-tx53-x13x.dts              | 243 ++++++
 arch/arm/boot/dts/imx53-tx53.dtsi                  | 510 ++++++++++-
 arch/arm/boot/dts/imx53-voipac-bsb.dts             | 159 ++++
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi        | 277 ++++++
 arch/arm/boot/dts/imx53.dtsi                       | 663 +++------------
 arch/arm/boot/dts/imx6dl-dfi-fs700-m60.dts         |  23 +
 arch/arm/boot/dts/imx6dl-gw51xx.dts                |  19 +
 arch/arm/boot/dts/imx6dl-gw52xx.dts                |  19 +
 arch/arm/boot/dts/imx6dl-gw53xx.dts                |  19 +
 arch/arm/boot/dts/imx6dl-gw54xx.dts                |  19 +
 arch/arm/boot/dts/imx6dl-nitrogen6x.dts            |  21 +
 arch/arm/boot/dts/imx6dl-pinfunc.h                 |   2 +
 arch/arm/boot/dts/imx6dl-sabrelite.dts             |  20 +
 arch/arm/boot/dts/imx6dl.dtsi                      |  29 +-
 arch/arm/boot/dts/imx6q-arm2.dts                   | 140 ++-
 arch/arm/boot/dts/imx6q-cm-fx6.dts                 | 107 +++
 arch/arm/boot/dts/imx6q-dfi-fs700-m60.dts          |  23 +
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts            | 372 ++++++++
 arch/arm/boot/dts/imx6q-gk802.dts                  | 171 ++++
 arch/arm/boot/dts/imx6q-gw51xx.dts                 |  19 +
 arch/arm/boot/dts/imx6q-gw52xx.dts                 |  23 +
 arch/arm/boot/dts/imx6q-gw53xx.dts                 |  23 +
 arch/arm/boot/dts/imx6q-gw5400-a.dts               | 546 ++++++++++++
 arch/arm/boot/dts/imx6q-gw54xx.dts                 |  23 +
 arch/arm/boot/dts/imx6q-nitrogen6x.dts             |  25 +
 arch/arm/boot/dts/imx6q-phytec-pbab01.dts          |  16 +
 arch/arm/boot/dts/imx6q-phytec-pfla02.dtsi         | 167 +++-
 arch/arm/boot/dts/imx6q-pinfunc.h                  |   2 +
 arch/arm/boot/dts/imx6q-sabrelite.dts              | 178 +---
 arch/arm/boot/dts/imx6q-sbc6x.dts                  |  58 +-
 arch/arm/boot/dts/imx6q-udoo.dts                   |  54 +-
 arch/arm/boot/dts/imx6q.dtsi                       |  23 +-
 arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi       | 199 +++++
 arch/arm/boot/dts/imx6qdl-gw51xx.dtsi              | 374 ++++++++
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi              | 490 +++++++++++
 arch/arm/boot/dts/imx6qdl-gw53xx.dtsi              | 553 ++++++++++++
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi              | 580 +++++++++++++
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi          | 422 +++++++++
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           | 378 ++++++++-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           | 423 ++++++++++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             | 277 +++++-
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi           | 131 ++-
 arch/arm/boot/dts/imx6qdl.dtsi                     | 938 +++------------------
 arch/arm/boot/dts/imx6sl-evk.dts                   | 427 +++++++++-
 arch/arm/boot/dts/imx6sl.dtsi                      | 385 +++------
 arch/arm/boot/dts/k2e-clocks.dtsi                  |  78 ++
 arch/arm/boot/dts/k2e-evm.dts                      |  60 ++
 arch/arm/boot/dts/k2e.dtsi                         |  80 ++
 arch/arm/boot/dts/k2hk-clocks.dtsi                 | 426 ++++++++++
 arch/arm/boot/dts/k2hk-evm.dts                     |  83 +-
 arch/arm/boot/dts/k2hk.dtsi                        |  46 +
 arch/arm/boot/dts/k2l-clocks.dtsi                  | 267 ++++++
 arch/arm/boot/dts/k2l-evm.dts                      |  37 +
 arch/arm/boot/dts/k2l.dtsi                         |  55 ++
 arch/arm/boot/dts/keystone-clocks.dtsi             | 427 +---------
 arch/arm/boot/dts/keystone.dtsi                    | 102 ++-
 arch/arm/boot/dts/kirkwood-b3.dts                  | 204 +++++
 arch/arm/boot/dts/kirkwood-ds109.dts               |  41 +
 arch/arm/boot/dts/kirkwood-ds110jv10.dts           |  41 +
 arch/arm/boot/dts/kirkwood-ds111.dts               |  44 +
 arch/arm/boot/dts/kirkwood-ds112.dts               |  48 ++
 arch/arm/boot/dts/kirkwood-ds209.dts               |  44 +
 arch/arm/boot/dts/kirkwood-ds210.dts               |  46 +
 arch/arm/boot/dts/kirkwood-ds212.dts               |  47 ++
 arch/arm/boot/dts/kirkwood-ds212j.dts              |  41 +
 arch/arm/boot/dts/kirkwood-ds409.dts               |  48 ++
 arch/arm/boot/dts/kirkwood-ds409slim.dts           |  40 +
 arch/arm/boot/dts/kirkwood-ds411.dts               |  52 ++
 arch/arm/boot/dts/kirkwood-ds411j.dts              |  48 ++
 arch/arm/boot/dts/kirkwood-ds411slim.dts           |  48 ++
 arch/arm/boot/dts/kirkwood-rd88f6192.dts           | 112 +++
 arch/arm/boot/dts/kirkwood-rd88f6281-a0.dts        |  26 +
 arch/arm/boot/dts/kirkwood-rd88f6281-a1.dts        |  31 +
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi          | 152 ++++
 arch/arm/boot/dts/kirkwood-rs212.dts               |  48 ++
 arch/arm/boot/dts/kirkwood-rs409.dts               |  44 +
 arch/arm/boot/dts/kirkwood-rs411.dts               |  44 +
 arch/arm/boot/dts/kirkwood-synology.dtsi           | 871 +++++++++++++++++++
 arch/arm/boot/dts/kirkwood-t5325.dts               | 208 +++++
 arch/arm/boot/dts/kirkwood-ts419-6281.dts          |  20 +
 arch/arm/boot/dts/kirkwood-ts419-6282.dts          |  32 +
 arch/arm/boot/dts/kirkwood-ts419.dtsi              |  75 ++
 arch/arm/boot/dts/kirkwood.dtsi                    |  24 +-
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi          |  58 ++
 arch/arm/boot/dts/omap2420.dtsi                    |   2 +
 arch/arm/boot/dts/omap2430.dtsi                    |   5 +
 arch/arm/boot/dts/omap3-beagle-xm.dts              |   4 +
 arch/arm/boot/dts/omap3-beagle.dts                 |   4 +
 arch/arm/boot/dts/omap3-cm-t3517.dts               | 136 +++
 arch/arm/boot/dts/omap3-cm-t3530.dts               |  48 ++
 arch/arm/boot/dts/omap3-cm-t3730.dts               |  57 +-
 arch/arm/boot/dts/omap3-cm-t3x.dtsi                | 110 +++
 arch/arm/boot/dts/omap3-cm-t3x30.dtsi              |  74 +-
 arch/arm/boot/dts/omap3-devkit8000.dts             |  16 +-
 arch/arm/boot/dts/omap3-gta04.dts                  |  51 +-
 arch/arm/boot/dts/omap3-igep.dtsi                  |   1 +
 arch/arm/boot/dts/omap3-lilly-a83x.dtsi            | 459 ++++++++++
 arch/arm/boot/dts/omap3-lilly-dbb056.dts           | 170 ++++
 arch/arm/boot/dts/omap3-n900.dts                   |  90 ++
 arch/arm/boot/dts/omap3-overo-alto35-common.dtsi   |  77 ++
 arch/arm/boot/dts/omap3-overo-alto35.dts           |  22 +
 arch/arm/boot/dts/omap3-overo-base.dtsi            | 221 +++++
 .../boot/dts/omap3-overo-chestnut43-common.dtsi    |  69 ++
 arch/arm/boot/dts/omap3-overo-chestnut43.dts       |  38 +
 .../boot/dts/omap3-overo-common-peripherals.dtsi   |  94 +++
 arch/arm/boot/dts/omap3-overo-gallop43-common.dtsi |  57 ++
 arch/arm/boot/dts/omap3-overo-gallop43.dts         |  38 +
 arch/arm/boot/dts/omap3-overo-palo43-common.dtsi   |  53 ++
 arch/arm/boot/dts/omap3-overo-palo43.dts           |  38 +
 arch/arm/boot/dts/omap3-overo-storm-alto35.dts     |  21 +
 arch/arm/boot/dts/omap3-overo-storm-chestnut43.dts |  38 +
 arch/arm/boot/dts/omap3-overo-storm-gallop43.dts   |  38 +
 arch/arm/boot/dts/omap3-overo-storm-palo43.dts     |  38 +
 arch/arm/boot/dts/omap3-overo-storm-summit.dts     |  30 +
 arch/arm/boot/dts/omap3-overo-storm-tobi.dts       |   2 +-
 arch/arm/boot/dts/omap3-overo-storm.dtsi           |  35 +
 arch/arm/boot/dts/omap3-overo-summit-common.dtsi   |  31 +
 arch/arm/boot/dts/omap3-overo-summit.dts           |  30 +
 arch/arm/boot/dts/omap3-overo-tobi-common.dtsi     |  51 +-
 arch/arm/boot/dts/omap3-overo-tobi.dts             |   2 +-
 arch/arm/boot/dts/omap3-overo.dtsi                 |  98 +--
 arch/arm/boot/dts/omap3-sb-t35.dtsi                |  29 +-
 arch/arm/boot/dts/omap3-sbc-t3517.dts              |  43 +
 arch/arm/boot/dts/omap3-sbc-t3530.dts              |  36 +
 arch/arm/boot/dts/omap3-sbc-t3730.dts              |  23 +-
 arch/arm/boot/dts/omap3.dtsi                       |  29 +-
 arch/arm/boot/dts/omap3430-sdp.dts                 |   7 +-
 arch/arm/boot/dts/omap3430es1-clocks.dtsi          |  10 +-
 .../boot/dts/omap36xx-omap3430es2plus-clocks.dtsi  |  10 +-
 arch/arm/boot/dts/omap36xx.dtsi                    |  20 +
 arch/arm/boot/dts/omap4-duovero-parlor.dts         | 146 ++++
 arch/arm/boot/dts/omap4-duovero.dtsi               | 252 ++++++
 arch/arm/boot/dts/omap4-panda-common.dtsi          |  31 +-
 arch/arm/boot/dts/omap4-sdp.dts                    |  33 +-
 arch/arm/boot/dts/omap4.dtsi                       |  64 +-
 arch/arm/boot/dts/omap443x.dtsi                    |  26 +
 arch/arm/boot/dts/omap4460.dtsi                    |  37 +
 arch/arm/boot/dts/omap5-uevm.dts                   |   8 +-
 arch/arm/boot/dts/omap5.dtsi                       |  43 +-
 arch/arm/boot/dts/qcom-msm8660.dtsi                |  24 +
 arch/arm/boot/dts/qcom-msm8960.dtsi                |  59 ++
 arch/arm/boot/dts/qcom-msm8974.dtsi                |  76 ++
 arch/arm/boot/dts/r7s72100-genmai-reference.dts    |  13 +-
 arch/arm/boot/dts/r7s72100.dtsi                    | 147 ++++
 arch/arm/boot/dts/r8a7778.dtsi                     |  40 -
 arch/arm/boot/dts/r8a7790-lager.dts                | 153 +++-
 arch/arm/boot/dts/r8a7790.dtsi                     | 169 +++-
 arch/arm/boot/dts/r8a7791-koelsch-reference.dts    | 115 ---
 arch/arm/boot/dts/r8a7791-koelsch.dts              | 274 +++++-
 arch/arm/boot/dts/r8a7791.dtsi                     | 323 ++++++-
 arch/arm/boot/dts/sama5d3.dtsi                     |  28 +-
 arch/arm/boot/dts/sama5d3xdm.dtsi                  |   6 +-
 arch/arm/boot/dts/socfpga.dtsi                     |   2 +
 arch/arm/boot/dts/socfpga_arria5_socdk.dts         |  21 +
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts       |  14 +
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts      |  17 +
 arch/arm/boot/dts/socfpga_vt.dts                   |   5 +
 arch/arm/boot/dts/ste-dbx5x0.dtsi                  |  12 +-
 arch/arm/boot/dts/ste-href-ab8500.dtsi             | 428 ++++++++++
 arch/arm/boot/dts/ste-href-ab8505.dtsi             | 240 ++++++
 arch/arm/boot/dts/ste-hrefprev60.dtsi              |   1 +
 arch/arm/boot/dts/ste-hrefv60plus.dtsi             |   1 +
 arch/arm/boot/dts/ste-snowball.dts                 |   1 +
 arch/arm/boot/dts/ste-u300.dts                     |   2 +-
 arch/arm/boot/dts/stih415-clock.dtsi               |  14 +
 arch/arm/boot/dts/stih415-pinctrl.dtsi             | 204 +++++
 arch/arm/boot/dts/stih415.dtsi                     |  70 ++
 arch/arm/boot/dts/stih416-clock.dtsi               |  14 +
 arch/arm/boot/dts/stih416-pinctrl.dtsi             | 210 +++++
 arch/arm/boot/dts/stih416.dtsi                     |  79 ++
 arch/arm/boot/dts/stih41x-b2000.dtsi               |  22 +
 arch/arm/boot/dts/stih41x-b2020.dtsi               |  14 +
 arch/arm/boot/dts/stih41x-b2020x.dtsi              |  28 +
 arch/arm/boot/dts/sun4i-a10-a1000.dts              |  55 +-
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts         |  40 +
 arch/arm/boot/dts/sun4i-a10-hackberry.dts          |  56 +-
 arch/arm/boot/dts/sun4i-a10-inet97fv2.dts          |  69 ++
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts         |  31 +
 arch/arm/boot/dts/sun4i-a10-olinuxino-lime.dts     | 111 +++
 arch/arm/boot/dts/sun4i-a10-pcduino.dts            |  79 ++
 arch/arm/boot/dts/sun4i-a10.dtsi                   | 211 ++++-
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts   |  27 +
 arch/arm/boot/dts/sun5i-a10s.dtsi                  | 158 +++-
 arch/arm/boot/dts/sun5i-a13-olinuxino-micro.dts    |  27 +
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts          |  27 +
 arch/arm/boot/dts/sun5i-a13.dtsi                   | 159 +++-
 arch/arm/boot/dts/sun6i-a31-colombus.dts           |  18 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   | 188 ++++-
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts        |  53 +-
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |  61 ++
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts    |  68 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   | 302 ++++++-
 arch/arm/boot/dts/sunxi-common-regulators.dtsi     |  75 ++
 arch/arm/boot/dts/tegra114-dalmore.dts             |   7 +-
 arch/arm/boot/dts/tegra114.dtsi                    |   8 +-
 arch/arm/boot/dts/tegra124-venice2.dts             | 301 ++++---
 arch/arm/boot/dts/tegra124.dtsi                    | 339 ++++++--
 arch/arm/boot/dts/tegra20-paz00.dts                |  46 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |  55 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |  39 +-
 arch/arm/boot/dts/tegra20.dtsi                     |   4 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |   7 +
 arch/arm/boot/dts/tegra30.dtsi                     |   6 +-
 arch/arm/boot/dts/tps65910.dtsi                    |   5 +
 arch/arm/boot/dts/twl4030.dtsi                     |   7 +
 arch/arm/boot/dts/vf610-cosmic.dts                 |  29 +-
 arch/arm/boot/dts/vf610-twr.dts                    | 158 +++-
 arch/arm/boot/dts/vf610.dtsi                       | 273 ++----
 arch/arm/boot/dts/zynq-7000.dtsi                   |   1 +
 arch/arm/mach-keystone/keystone.c                  |   2 +-
 arch/arm/mach-mxs/mach-mxs.c                       |  33 +
 arch/arm/mach-omap2/clockdomains3xxx_data.c        |   2 +-
 arch/arm/mach-omap2/devices.c                      |   3 +
 arch/arm/mach-omap2/gpmc-nand.c                    |  31 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  12 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |  83 ++
 arch/arm/mach-omap2/pdata-quirks.c                 | 117 ++-
 arch/arm/mach-ux500/Kconfig                        |   4 -
 arch/arm/mach-ux500/Makefile                       |   1 -
 arch/arm/mach-ux500/board-mop500-audio.c           |   1 -
 arch/arm/mach-ux500/board-mop500-pins.c            | 291 -------
 arch/arm/mach-ux500/board-mop500.h                 |  73 --
 arch/arm/mach-ux500/cpu-db8500.c                   |  17 -
 arch/arm/mach-ux500/cpu.c                          |  10 -
 arch/arm/mach-ux500/irqs-board-mop500.h            |  55 --
 arch/arm/mach-ux500/irqs-db8500.h                  | 125 ---
 arch/arm/mach-ux500/irqs.h                         |  49 --
 arch/arm/plat-omap/Kconfig                         |   3 -
 drivers/mfd/ab8500-core.c                          |  27 +-
 drivers/mfd/db8500-prcmu.c                         |  34 +-
 include/dt-bindings/pinctrl/am43xx.h               |   1 +
 .../dt-bindings/reset-controller/stih415-resets.h  |  26 +
 .../dt-bindings/reset-controller/stih416-resets.h  |  50 ++
 include/linux/mfd/abx500/ab8500.h                  |   2 -
 include/linux/mfd/dbx500-prcmu.h                   |   2 -
 372 files changed, 31308 insertions(+), 6243 deletions(-)
