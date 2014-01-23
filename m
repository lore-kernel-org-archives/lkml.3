Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaAWStF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:49:05 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37186 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaAWSrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:47:20 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/6] ARM: SoC DT updates for 3.14
Date: Thu, 23 Jan 2014 10:36:26 -0800
Message-Id: <1390502188-16896-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1390502188-16896-1-git-send-email-olof@lixom.net>
References: <1390502188-16896-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT and DT-conversion-related changes for various ARM platforms. Most
of these are to enable various devices on various boards, etc, and not
necessarily worth enumerating.

New boards and systems continue to come in as new devicetree files that
don't require corresponding C changes any more, which is indicating that
the system is starting to work fairly well.

A few things worth pointing out:

* ST Ericsson ux500 platforms have made the major push to move over to fully
support the platform with DT.
* Renesas platforms continue their conversion over from legacy platform devices
to DT-based for hardware description.


Conflicts:

arch/arm/boot/dts/armada-370-xp.dtsi:

Conflict with the sorting of the file combined with a compatible string
rename coming in through the SATA tree. Carry down the new compatible
string (marvell,armada-370-sata) to the moved entry further down the file,
the USB node stays where it is.

----------------------------------------------------------------

The following changes since commit 796e6948528f45d2bbc5698d0ea673ea18efdb8d:

  Merge branch 'next/soc' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-linus

for you to fetch changes up to 310c85476d5047f5ace4d1c527e1bbbc0c7ad672:

  Merge tag 'davinci-for-v3.14/dt' of git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci into next/dt

----------------------------------------------------------------

Alex Ling (1):
      ARM: dts: add support for EXYNOS4412 based TINY4412 board

Andrew Lunn (5):
      ARM: Dove: Add DT node for PMU interrupt controller.
      ARM: Dove: Add RTC interrupt via PMU interrupt controller.
      ARM: DT: Kirkwood: Use symbolic names from input.h
      ARM: DT: Kirkwood: Use symbolic names from gpio.h
      Phy: Add DT nodes on kirkwood and Dove for the SATA PHY

Arnaud Ebalard (14):
      ARM: mvebu: Add RN104 SATA LEDs driven via NXP PCA9554 I2C to GPIO muxer
      ARM: mvebu: Add DT entry for ReadyNAS Duo v2 to use gpio-poweroff driver
      ARM: kirkwood: NETGEAR ReadyNAS Duo v2 .dts cleanup
      ARM: mvebu: NETGEAR ReadyNAS 102 .dts cleanup
      ARM: mvebu: NETGEAR ReadyNAS 104 .dts cleanup
      ARM: mvebu: Fix whitespace in NETGEAR ReadyNAS .dts files
      ARM: mvebu: Add Netgear ReadyNAS 2120 board
      ARM: kirkwood: Add support for NETGEAR ReadyNAS NV+ v2
      ARM: mvebu: Enable NAND controller in ReadyNAS 102 .dts file
      ARM: mvebu: Enable NAND controller in ReadyNAS 104 .dts file
      ARM: mvebu: Enable NAND controller in ReadyNAS 2120 .dts file
      ARM: mvebu: Enable ISL12057 RTC chip in ReadyNAS 102 .dts file
      ARM: mvebu: Enable ISL12057 RTC chip in ReadyNAS 104 .dts file
      ARM: mvebu: Enable ISL12057 RTC chip in ReadyNAS 2120 .dts file

Ashwini Ghuge (1):
      ARM: tegra: add port FF to GPIO IDs

Barry Song (1):
      ARM: dts: sirf: add lost clocks for cphifbg

Bin Shi (1):
      ARM: dts: sirf: add lost bus_width, clock and status for sdhci

Bo Shen (3):
      ARM: at91: sama5d3: enable qt1070 as a wakeup source
      ARM: at91: add PWM device node
      ARM: at91: at91sam9m10g45ek: switch to PWM leds

Boris BREZILLON (5):
      ARM: at91/dt: add ethernet phy to at91rm9200ek board
      ARM: at91/dt: add atmel,pullup-gpio to at91rm9200ek usb1 definition
      ARM: at91/dt: add clk properties to sama5d3 SHA device node
      ARM: at91/dt: add clk properties to sama5d3 AES device node
      ARM: at91/dt: add clk properties to sama5d3 TDES device node

Carlo Caione (1):
      ARM: dts: sun4i/sun7i: add RTC node

Chander Kashyap (2):
      clocksource: mct: extend mct to support 8 local interrupts for Exynos5420
      ARM: dts: populate cpu node entries to 8 cpus for exynos5420

Chen-Yu Tsai (4):
      ARM: dts: sun7i: Add pin muxing options for clock outputs
      ARM: dts: sun7i: Change 32768 Hz oscillator node name to clk@N style
      ARM: dts: sun7i: external clock outputs
      arm: sun7i: cubietruck: Enable the i2c controllers

Dinh Nguyen (1):
      ARM: dts: socfpga: update L2 tag and data latency

Emilio López (7):
      ARM: sunxi: dt: add EMAC aliases
      ARM: sunxi: add PLL4 support
      ARM: sunxi: add PLL5 and PLL6 support
      ARM: sun4i: dt: mod0 clocks
      ARM: sun5i: dt: mod0 clocks
      ARM: sun7i: dt: mod0 clocks
      ARM: sunxi: dt: add nodes for the mbus clock

Eric Brower (2):
      ARM: tegra: modify Tegra30 USB2 default phy_type to UTMI
      ARM: tegra: enable USB2 on Tegra30 Beaver

Ezequiel Garcia (4):
      ARM: mvebu: Add support for NAND controller in Armada 370/XP
      ARM: mvebu: Enable NAND controller in Armada XP GP board
      ARM: mvebu: Enable NAND controller in Armada 370 Mirabox
      ARM: mvebu: Enable NAND controller in A370 Reference Design board

Hans de Goede (4):
      ARM: dts: sun5i: Add new sun5i-a13-olinuxino-micro board
      ARM: dts: sun4i: Add rtp controller node
      ARM: dts: sun5i: Add rtp controller node
      ARM: dts: sun7i: Add rtp controller node

Jason Cooper (6):
      ARM: mvebu: dts: remove unneeded linux,default-state from led nodes
      ARM: kirkwood: sort dt nodes by address
      ARM: dove: sort DT nodes by address
      ARM: orion5x: sort DT nodes by address
      ARM: mvebu: sort DT nodes by address
      ARM: kirkwood: 6282: sort DT nodes by address

Jean-Christophe PLAGNIOL-VILLARD (6):
      ARM: at91: sam9g45: add fb dt support
      ARM: at91: sam9263: add fb dt support
      ARM: at91: at9sam9m10g45ek: add dt lcd support
      ARM: at91: sam9263ek: add dt lcd support
      ARM: at91: Animeo IP: fix mtd partition table
      ARM: at91: dt: at91rm9200ek: add emac and nor flash support

Jonas Jensen (1):
      ARM: moxart: add MOXA ART SoC device tree files

Joseph Lo (1):
      ARM: tegra: add clock properties for devices of Tegra124

Josh Wu (1):
      ARM: at91: sama5d3/dt: add sama5d36ek dts files

KV Sujith (2):
      ARM: davinci: da850: add GPIO DT node
      ARM: davinci: da850 evm: add GPIO pinumux entries DT node

Kevin Hilman (13):
      Merge tag 'mvebu-dt-3.14-2' of git://git.infradead.org/linux-mvebu into next/dt
      Merge branch 'next/cleanup' into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'integrator-v3.14-1' of git://git.kernel.org/.../linusw/linux-integrator into next/dt
      Merge tag 'nomadik-dt-v3.14' of git://git.kernel.org/.../linusw/linux-nomadik into next/dt
      Merge tag 'mvebu-dt-3.14-3' of git://git.infradead.org/linux-mvebu into next/dt
      Merge branch 'mvebu/dt-4' into next/dt
      Merge tag 'keystone-dts' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt
      Merge tag 'renesas-dt-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'sunxi-dt-for-3.14-2' of https://github.com/mripard/linux into next/dt
      Merge tag 'socfpga-dt-for-3.14' of git://git.rocketboards.org/linux-socfpga-next into next/dt
      Merge tag 'sirf-dts-for-3.14' of git://git.kernel.org/.../baohua/linux into next/dt
      Merge tag 'davinci-for-v3.14/dt' of git://git.kernel.org/.../nsekhar/linux-davinci into next/dt

Kukjin Kim (1):
      Merge branch 'v3.14-next/fixes-samsung-2' into v3.14-next/dt-exynos-2

Kuninori Morimoto (35):
      ARM: shmobile: r8a7778: add I2C support on DTSI
      ARM: shmobile: r8a7779: tidyup I2C driver name on DTSI
      ARM: shmobile: lager: add default PFC settings on DTS
      ARM: shmobile: lager: add MMCIF support on DTS
      ARM: shmobile: bockw: add default PFC settings on DTS
      ARM: shmobile: bockw: remove manual PFC settings on reference
      ARM: shmobile: r8a7778: add MMCIF support on DTSI
      ARM: shmobile: bockw: add MMCIF support on DTS
      ARM: shmobile: bockw: fixup MMC pin conflict on DTS
      ARM: shmobile: r8a7778: add SDHI support on DTSI
      ARM: shmobile: bockw: add SDHI support on DTS
      ARM: shmobile: r8a7779: add SDHI support on DTSI
      ARM: shmobile: marzen: add SDHI support on DTS
      ARM: shmobile: r8a7740: tidyup DT node naming
      ARM: shmobile: r8a73a4: tidyup DT node naming
      ARM: shmobile: r8a7778: tidyup DT node naming
      ARM: shmobile: r8a7779: tidyup DT node naming
      ARM: shmobile: r8a7790: tidyup DT node naming
      ARM: shmobile: sh73a0: tidyup DT node naming
      ARM: shmobile: armadillo: tidyup DT node naming
      ARM: shmobile: ape6evm: tidyup DT node naming
      ARM: shmobile: kzm9g: tidyup DT node naming
      ARM: shmobile: bockw: tidyup DT node naming
      ARM: shmobile: marzen: tidyup DT node naming
      ARM: shmobile: lager: tidyup DT node naming
      ARM: shmobile: r8a7778: add I2C support on DTSI
      ARM: shmobile: r8a7778: add HSPI suppport on DTSI
      ARM: shmobile: bockw: enable HSPI0 on DTS
      ARM: shmobile: marzen: remove SDHI0 WP pin setting from DTS
      ARM: shmobile: marzen: remove SDHI0 WP pin setting
      ARM: shmobile: sh73a0: fixup sdhi compatible name
      ARM: shmobile: r8a7740: add FSI support via DTSI
      ARM: shmobile: armadillo: add FSI support for DTS
      ARM: shmobile: sh73a0: add FSI support via DTSI
      ARM: shmobile: kzm9g: add FSI support for DTS

Laurent Pinchart (38):
      ARM: shmobile: r8a7778: Fix pin control device address in DT
      ARM: shmobile: Use #include in device tree sources
      ARM: shmobile: Use interrupt macros in SoC DT files
      ARM: shmobile: Use interrupt macros in board DT files
      ARM: shmobile: marzen-reference: Use falling edge IRQ for LAN9221
      ARM: shmobile: bockw-reference: Use falling edge IRQ for LAN9221
      ARM: shmobile: kzm9g-reference: Use falling edge IRQ for LAN9221
      ARM: shmobile: armadillo-reference: Use low level IRQ for ST1231
      ARM: shmobile: kzm9g-reference: Add PCF8575 GPIO extender to DT
      ARM: shmobile: kzm9g-reference: Add GPIO keys to DT
      ARM: shmobile: Use interrupt macros in r8a73a4 and r8a7778 DT files
      ARM: shmobile: emev2: Use interrupt macros in DT files
      ARM: shmobile: emev2: Setup internal peripheral interrupts as level high
      ARM: shmobile: koelsch: dts: Add gpio-keys device
      clk: shmobile: Add R-Car Gen2 clocks support
      clk: shmobile: Add DIV6 clock support
      clk: shmobile: Add MSTP clock support
      ARM: shmobile: armadillo: dts: Add PWM backlight power supply
      ARM: shmobile: armadillo: dts: Add PWM backlight enable GPIO
      ARM: shmobile: r8a73a4: Specify PFC interrupts in DT
      ARM: shmobile: r8a7740: Specify PFC interrupts in DT
      ARM: shmobile: sh73a0: Specify PFC interrupts in DT
      ARM: shmobile: armadillo: dts: Add gpio-keys device
      ARM: shmobile: r8a7790: Add clocks
      ARM: shmobile: r8a7790: Reference clocks
      ARM: shmobile: r8a7791: Add clocks
      ARM: shmobile: Sync Lager DTS with Lager reference DTS
      ARM: shmobile: Sync Koelsch DTS with Koelsch reference DTS
      ARM: shmobile: lager: Specify external clock frequency in DT
      ARM: shmobile: koelsch: Specify external clock frequency in DT
      ARM: shmobile: Remove Lager reference DTS
      ARM: shmobile: Remove Koelsch reference DTS
      ARM: shmobile: r8a7790: Add MSIOF clocks in device tree
      ARM: shmobile: r8a7791: Add MSIOF clocks in device tree
      ARM: shmobile: r8a7790: Add QSPI module clock in device tree
      ARM: shmobile: r8a7791: Add QSPI module clock in device tree
      ARM: shmobile: r8a7790: Add SSI clocks in device tree
      ARM: shmobile: r8a7791: Add SSI clocks in device tree

Laxman Dewangan (8):
      ARM: tegra: convert device tree files to use key defines
      ARM: tegra: Add header file for pinctrl constants
      ARM: tegra: convert dts files of Tegra114 platforms to use pinctrl defines
      ARM: tegra: convert dts files of Tegra20 platforms to use pinctrl defines
      ARM: tegra: convert dts files of Tegra30 platforms to use pinctrl defines
      ARM: tegra: add default pinctrl nodes for Venice2
      ARM: tegra: fix missing pincontrol configuration for Venice2
      ARM: tegra: add ams AS3722 device to Venice2 DT

Lee Jones (10):
      ARM: ux500: Remove legacy ATAG SSP support
      ARM: ux500: Consolidate [A|D]B8500 platform data
      ARM: ux500: Add DMA config bindings for MSP devices
      ARM: ux500: Clean-up non-DT IRQ initialisation
      ARM: ux500: Remove unused call to register AMBA devices
      ARM: ux500: Clean-up legacy extern prototype
      ARM: ux500: Remove checking for DT during timer init
      dma: ste_dma40: Expand DT binding to accept 'high-priority channel' flag
      dma: ste_dma40: Parse flags property for new 'high priority channel' request
      ARM: nomadik: Remove '0x's from nomadik stn8815 DTS file

Leela Krishna Amudala (3):
      ARM: dts: Add device nodes for GScaler blocks for exynos5420
      ARM: dts: Add SPI nodes to the exynos5420 device tree file
      ARM: dts: add pwm DT nodes to Exynos5250 and Exynos5420

Linus Walleij (34):
      ARM: ux500: adjust the TC3589x devices to the binding
      ARM: ux500: move UART pin control to the device tree
      ARM: ux500: move I2C pin control to the device tree
      ARM: ux500: move MMC/SD/SDIO pin control to the device tree
      ARM: ux500: move MSP pin control to the device tree
      ARM: ux500: move GPIO217/218 config to device tree
      ARM: ux500: move MUSB pin config to device tree
      ARM: ux500: move SPI pin config to device tree
      ARM: ux500: create MCDE node to collect resources
      ARM: ux500: move MCDE pin config to device tree
      ARM: ux500: move SKE pin config to device tree
      ARM: ux500: drop STM pinmap settings
      ARM: ux500: move old HREF ipgpio to the device tree
      ARM: ux500: move GPIO key configuration to device tree
      ARM: ux500: move the WLAN GPIO pin setup to the device tree
      ARM: ux500: move the HREFv60plus IPGPIO pins to device tree
      ARM: ux500: move final HREFv60 LCD pins to device tree
      ARM: ux500: move HREFv60plus pin configs to device tree
      ARM: ux500: move snowball ethernet config to device tree
      ARM: ux500: convert Snowball SPI pin reference
      ARM: ux500: move snowball LED pin control to device tree
      ARM: ux500: move snowball pin configs to device tree
      ARM: ux500: delete remnant pin config macros
      ARM: ux500: delete Nomadik pinctrl AUXDATA
      ARM: ux500: get rid of unused header
      pinctrl: nomadik: move platform data handling into driver
      pinctrl: nomadik: decomission non-DT boot path
      ARM: ux500: decomission the non-DT MTU init sequence
      clksrc: delete nomadik MTU non-DT boot path
      ARM: ux500: decomission custom SMP TWD timer init
      ARM: nomadik: get rid of explicit ethernet GPIO management
      ARM: integrator: delete static core module mappings
      ARM: integrator: move EBI to the device tree
      ARM: ux500: delete U8540 UART auxdata

Ludovic Desroches (2):
      ARM: at91: at91sam9g45: set default mmc pinctrl-names
      ARM: at91: at91sam9g45: add i2c pinctrl

Magnus Damm (19):
      ARM: shmobile: r8a7791 PFC device tree node
      ARM: shmobile: r8a7791 GPIO device tree node
      ARM: shmobile: r8a7791 Koelsch DT reference DTS bits
      ARM: shmobile: Use r8a7791 suffix for IRQC compat string
      ARM: shmobile: Configure r8a7791 PFC on Koelsch via DTS
      ARM: shmobile: Add r8a7790 thermal device node to DTS
      ARM: shmobile: Add r8a7791 thermal device node to DTS
      ARM: shmobile: Use r8a7790 suffix for MMCIF compat string
      ARM: shmobile: Use r8a7790 suffix for IRQC compat string
      ARM: shmobile: Enable DSW2 with gpio-keys on KZM9D
      ARM: shmobile: Koelsch DT reference GPIO LED support
      ARM: shmobile: Include all 2 GiB of memory on APE6EVM DT Ref
      ARM: shmobile: Include all 4 GiB of memory on Lager
      ARM: shmobile: Include all 4 GiB of memory on Lager DT Ref
      ARM: shmobile: Fix r8a7791 GPIO resources in DTS
      ARM: shmobile: Use sh73a0 suffix for INTC compat string
      ARM: shmobile: Use r8a7740 suffix for INTC compat string
      ARM: shmobile: Use r8a7778 suffix for INTC compat string
      ARM: shmobile: Use r8a7779 suffix for INTC compat string

Mark Brown (4):
      ARM: dts: Add CODEC MCLK for SMDK5250
      ARM: dts: Leave Exynos5250 SPI controller disabled by default
      ARM: dts: Disable I2C controllers by default on Exynos5250
      ARM: dts: Rename Exynos5250 ChromeOS common file to have exynos prefix

Maxime COQUELIN (3):
      ARM: STi: Supply I2C configuration to STiH416 SoC
      ARM: STi: Supply I2C configuration to STiH415 SoC
      ARM: STi: Add I2C config to B2000 and B2020 boards

Maxime Hadjinlian (2):
      ARM: Kirkwood: Add 6192 DTSI file
      ARM: Kirkwood: DT board setup for LaPlug

Maxime Ripard (5):
      ARM: sun6i: Add the reset controller to the DTSI
      ARM: sun6i: dt: Add IP needed to bring up the additional cores
      Merge tag 'sunxi-clk-3.14-for-maxime' of https://bitbucket.org/emiliolopez/linux into sunxi/dt-for-3.14
      ARM: sun4i: dt: Move the aliases to the DTSI
      ARM: sun4i: dt: Remove chosen nodes

Mike Dunn (1):
      ARM: pxa: add PWM nodes to pxa27x.dtsi

Mikko Perttunen (2):
      ARM: tegra: Add host1x, DC and HDMI to Tegra114 device tree
      ARM: tegra: Enable HDMI support on Dalmore

Murali Karicheri (3):
      ARM: keystone: dts: add a k2hk-evm specific dts file
      ARM: keystone: dts: fix typo in the ddr3 pllclk node name
      ARM: keystone: dts: add paclk divider clock node

Naveen Krishna Chatradhi (1):
      ARM: dts: Add device nodes for TMU blocks for exynos5420

Nicolas Ferre (9):
      ARM: at91/trivial: fix at91rm9200 rts/cts pinctrl definitions
      ARM: at91/dt: binding: add precision to AIC documentation
      ARM: at91/dt: binding: add missing compatibility string in SDRAM/DDR documentation
      ARM: at91/dt/trivial: use macro for AES irq type
      ARM: at91/dt/trivial: before sama5d3, Atmel MPU were using at91 prefix
      ARM: at91/dt/sama5d3: add DMA information to SHA/AES/TDES nodes
      ARM: at91: add i2c2 pinctrl speficifation to sama5d3 DT
      ARM: at91: add uart aliases to sama5d3 dtsi
      ARM: at91/at91rm9200ek.dts: rearrange nodes in address ascending order

Olof Johansson (18):
      Merge tag 'ux500-devicetree-v3.14-1' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'mvebu-dt-3.14' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'DT-for-v3.14-part-1' of http://git.stlinux.com/devel/kernel/linux-sti into next/dt
      Merge tag 'zynq-dt-for-3.14' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'samsung-dt' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'at91-dt2' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'samsung-dt-2' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge branch 'tegra/dma-reset-rework' into next/dt
      Merge tag 'tegra-for-3.14-dt' of git://git.kernel.org/.../tegra/linux into next/dt
      Merge tag 'tegra-for-3.14-dt-2' of git://git.kernel.org/.../tegra/linux into next/dt
      Merge tag 'renesas-dt2-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge branch 'qcom/dt' into next/dt
      Merge tag 'mvebu-dt-3.14-5' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'sunxi-dt-for-3.14' of https://github.com/mripard/linux into next/dt
      Merge tag 'renesas-dt3-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'samsung-dt-3' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'renesas-dt-fixes-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'ux500-devicetree-v3.14-2' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt

Padmavathi Venna (1):
      ARM: dts: Add DMA controller node info on Exynos5420

Qipan Li (1):
      ARM: dts: SiRF: add lost usp1_uart_nostreamctrl pin group for atlas6

Rodolfo Giometti (1):
      ARM: at91: add support for Cosino board series by HCE Engineering

Rongjun Ying (2):
      ARM: dts: sirf: add clock, frequence-voltage table for CPU0
      ARM: dts: SiRF: add pin group for USP0 with only RX or TX frame sync

Sachin Kamat (5):
      ARM: dts: Update min voltage for vdd_arm on Arndale
      ARM: dts: Add hs-i2c nodes to exynos5420
      ARM: dts: Fix sysreg node name in exynos4.dtsi
      ARM: dts: Update Samsung sysreg binding document
      ARM: dts: Add initial support for Arndale Octa board

Santosh Shilimkar (2):
      ARM: dts: keystone: Add the GICV and GICH address space
      ARM: dts: keystone: Add guestos maintenance interrupt

Sebastian Hesselbarth (2):
      ARM: kirkwood: provide pinctrl default to sdio nodes
      ARM: kirkwood: mark guruplug sdio as non-removable

Simon Baatz (1):
      ARM: kirkwood: Cleanup comments in Sheevaplug dts files

Simon Horman (10):
      ARM: shmobile: r8a7779: add HSPI support to DTSI
      ARM: shmobile: marzen: enable HSPI0 in DTS
      Merge commit '70c8f01' into dt3-base
      Merge remote-tracking branch 'mike-turquette/clk-next-shmobile' into dt3-base
      Merge remote-tracking branch 'daniel-lezcano/clockevents/for-Simon-3.13-rc2' into dt3-base
      Merge tag 'v3.13-rc3' into dt3-base
      Merge branch 'heads/sh-sci' into dt3-base
      Merge branch 'heads/soc2' into dt3-base
      Revert "ARM: shmobile: r8a7790: Add SSI clocks in device tree"
      Revert "ARM: shmobile: r8a7791: Add SSI clocks in device tree"

Soren Brinkmann (2):
      arm: dt: zynq: Remove 'clock-ranges' from TTC nodes
      arm: dt: zynq: Add 'cpus' node

Srinivas Kandagatla (3):
      ARM: orion5x: Fix typo in device_type property of phy node
      ARM: dove: Fix typo in device_type property of phy node
      ARM: STi: OF: Fix a typo in pincfg header

Stefan Agner (1):
      ARM: tegra: correct Colibri T20 regulator settings

Steffen Trumtrar (2):
      ARM: zynq: add gem support
      ARM: dts: socfpga: add pl330 clock

Stephen Boyd (2):
      ARM: dts: MSM8974: Add restart node
      ARM: dts: MSM8974: Add MMIO architected timer node

Stephen Warren (14):
      ARM: tegra: add missing unit addresses to DT
      ARM: tegra: fix node sort order
      ARM: tegra: add reset properties to Tegra124 DTs
      ARM: tegra: add APB DMA controller to Tegra124 DT
      ARM: tegra: add Tegra124 pinmux node to DT
      ARM: tegra: add MMC controllers to Tegra124 DT
      ARM: tegra: add I2C controllers to Tegra124 DT
      ARM: tegra: enable I2C controllers on Venice2
      ARM: tegra: add audio-related device to Tegra124 DT
      ARM: tegra: add sound card to Venice2 DT
      ARM: tegra: fix pinctrl misconfiguration on Venice2
      ARM: tegra: set up /aliases entries for RTCs
      ARM: tegra: set up /aliases for RTCs on Venice2
      ARM: bcm2835: add USB controller to device tree

Takashi Yoshii (2):
      ARM: shmobile: emev2: Add clock tree description in DT
      ARM: shmobile: Include all 2 GiB of memory on APE6EVM

Thierry Reding (13):
      ARM: tegra: Add Tegra124 PWM support
      ARM: tegra: Enable PWM on Venice2
      ARM: tegra: Fix misconfiguration of pin PH2 on Venice2
      ARM: tegra: Add SPI controller nodes for Tegra124
      ARM: tegra: Enable LVDS on Harmony
      ARM: tegra: Enable LVDS on Cardhu
      ARM: tegra: Add MIPI calibration DT entries for Tegra114
      ARM: tegra: Add Tegra114 DSI support
      ARM: tegra: Add Tegra114 gr2d support
      ARM: tegra: Add Tegra114 gr3d support
      ARM: tegra: Enable DSI support on Dalmore
      ARM: tegra: Enable Venice2 keyboard
      ARM: tegra: Enable power key on Venice2

Thomas Petazzoni (1):
      ARM: mvebu: fix register length for Armada XP PMSU

Tomasz Figa (5):
      Documentation: devicetree: Update Exynos MCT bindings description
      ARM: dts: Drop interrupt controller properties from MCT nodes for exynos4 SoCs
      ARM: dts: Move MCT node to exynos4x12.dtsi
      ARM: dts: Simplify MCT interrupt map for exynos4 SoCs
      ARM: dts: Fix missing spaces after labels for exynos

Ulf Hansson (3):
      ARM: ux500: Refactor common DT configs for sdi[n] devices
      ARM: ux500: Configure regulator for I/O voltage for SD-card slot
      ARM: ux500: regulators: Remove dead code for SD-card regulator

WingMan Kwok (2):
      ARM: dts: keystone: Add usb phy devicetree bindings
      ARM: dts: keystone: Add usb devicetree bindings

Xianglong Du (1):
      ARM: dts: sirf: add lost minigpsrtc device node

Yuvaraj Kumar C D (6):
      ARM: dts: Move dwmmc nodes from exynos5.dtsi to exynos5250.dtsi
      ARM: dts: change status property of dwmmc nodes for exynos5250
      ARM: dts: Move fifo-depth property from exynos5250 board dts
      ARM: dts: rename mmc dts node for exynos5 series
      ARM: dts: Add dwmmc DT nodes for exynos5420 SOC
      ARM: dts: Fix status property of mmc nodes for snow board


 .../devicetree/bindings/arm/arm-boards          |    8 +
 .../devicetree/bindings/arm/atmel-aic.txt       |    1 +
 .../devicetree/bindings/arm/atmel-at91.txt      |    3 +-
 .../devicetree/bindings/arm/moxart.txt          |   12 +
 .../devicetree/bindings/arm/samsung/sysreg.txt  |    7 +-
 .../bindings/clock/renesas,cpg-div6-clocks.txt  |   28 +
 .../bindings/clock/renesas,cpg-mstp-clocks.txt  |   51 +
 .../clock/renesas,rcar-gen2-cpg-clocks.txt      |   32 +
 .../devicetree/bindings/dma/ste-dma40.txt       |    3 +
 .../devicetree/bindings/mmc/exynos-dw-mshc.txt  |    2 +
 .../bindings/timer/samsung,exynos4210-mct.txt   |   54 +-
 .../devicetree/bindings/usb/keystone-phy.txt    |   20 +
 .../devicetree/bindings/usb/keystone-usb.txt    |   42 +
 arch/arm/boot/dts/Makefile                      |   10 +
 arch/arm/boot/dts/animeo_ip.dts                 |   31 +-
 arch/arm/boot/dts/armada-370-mirabox.dts        |   25 +-
 arch/arm/boot/dts/armada-370-netgear-rn102.dts  |  125 +-
 arch/arm/boot/dts/armada-370-netgear-rn104.dts  |  131 ++-
 arch/arm/boot/dts/armada-370-rd.dts             |   21 +
 arch/arm/boot/dts/armada-370-xp.dtsi            |  167 +--
 arch/arm/boot/dts/armada-370.dtsi               |   74 +-
 arch/arm/boot/dts/armada-xp-gp.dts              |    8 +
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts  |  327 ++++++
 .../arm/boot/dts/armada-xp-openblocks-ax3-4.dts |    3 +-
 arch/arm/boot/dts/armada-xp.dtsi                |  100 +-
 arch/arm/boot/dts/at91-cosino.dtsi              |  122 ++
 arch/arm/boot/dts/at91-cosino_mega2560.dts      |   84 ++
 arch/arm/boot/dts/at91rm9200.dtsi               |    4 +-
 arch/arm/boot/dts/at91rm9200ek.dts              |   57 +-
 arch/arm/boot/dts/at91sam9263.dtsi              |   46 +
 arch/arm/boot/dts/at91sam9263ek.dts             |   30 +
 arch/arm/boot/dts/at91sam9g45.dtsi              |   76 ++
 arch/arm/boot/dts/at91sam9m10g45ek.dts          |   54 +-
 arch/arm/boot/dts/at91sam9n12.dtsi              |    9 +
 arch/arm/boot/dts/at91sam9x5.dtsi               |    9 +
 arch/arm/boot/dts/atlas6.dtsi                   |   26 +
 arch/arm/boot/dts/bcm2835-rpi-b.dts             |    9 +-
 arch/arm/boot/dts/bcm2835.dtsi                  |    6 +
 arch/arm/boot/dts/da850-evm.dts                 |    3 +
 arch/arm/boot/dts/da850.dtsi                    |   14 +
 arch/arm/boot/dts/dove-cubox.dts                |    2 +-
 arch/arm/boot/dts/dove.dtsi                     |  500 ++++----
 arch/arm/boot/dts/emev2-kzm9d.dts               |   42 +-
 arch/arm/boot/dts/emev2.dtsi                    |  116 +-
 arch/arm/boot/dts/exynos4.dtsi                  |    6 +-
 arch/arm/boot/dts/exynos4210.dtsi               |   23 +-
 arch/arm/boot/dts/exynos4212.dtsi               |   24 +-
 arch/arm/boot/dts/exynos4412-tiny4412.dts       |   93 ++
 arch/arm/boot/dts/exynos4412.dtsi               |   28 +-
 arch/arm/boot/dts/exynos4x12.dtsi               |   20 +
 arch/arm/boot/dts/exynos5.dtsi                  |   25 +-
 arch/arm/boot/dts/exynos5250-arndale.dts        |   62 +-
 ...-common.dtsi => exynos5250-cros-common.dtsi} |   34 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts       |   62 +-
 arch/arm/boot/dts/exynos5250-snow.dts           |   13 +-
 arch/arm/boot/dts/exynos5250.dtsi               |   58 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts   |   66 ++
 arch/arm/boot/dts/exynos5420-smdk5420.dts       |   33 +
 arch/arm/boot/dts/exynos5420.dtsi               |  346 +++++-
 arch/arm/boot/dts/exynos5440.dtsi               |    2 +-
 arch/arm/boot/dts/integrator.dtsi               |    5 +
 arch/arm/boot/dts/k2hk-evm.dts                  |   63 ++
 arch/arm/boot/dts/keystone-clocks.dtsi          |   36 +-
 .../boot/dts/{keystone.dts => keystone.dtsi}    |   35 +-
 arch/arm/boot/dts/kirkwood-6192.dtsi            |  107 ++
 arch/arm/boot/dts/kirkwood-6281.dtsi            |    4 +
 arch/arm/boot/dts/kirkwood-6282.dtsi            |   39 +-
 arch/arm/boot/dts/kirkwood-cloudbox.dts         |   10 +-
 arch/arm/boot/dts/kirkwood-db.dtsi              |    4 +-
 arch/arm/boot/dts/kirkwood-dns320.dts           |   12 +-
 arch/arm/boot/dts/kirkwood-dns325.dts           |   12 +-
 arch/arm/boot/dts/kirkwood-dnskw.dtsi           |   18 +-
 arch/arm/boot/dts/kirkwood-dockstar.dts         |    6 +-
 arch/arm/boot/dts/kirkwood-dreamplug.dts        |    6 +-
 arch/arm/boot/dts/kirkwood-goflexnet.dts        |   24 +-
 .../boot/dts/kirkwood-guruplug-server-plus.dts  |   12 +-
 arch/arm/boot/dts/kirkwood-ib62x0.dts           |   18 +-
 arch/arm/boot/dts/kirkwood-iconnect.dts         |   28 +-
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts   |   22 +-
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts      |    4 +-
 arch/arm/boot/dts/kirkwood-laplug.dts           |  175 +++
 arch/arm/boot/dts/kirkwood-lsxl.dtsi            |   30 +-
 arch/arm/boot/dts/kirkwood-mplcec4.dts          |   14 +-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts  |   14 +-
 .../dts/kirkwood-netgear_readynas_duo_v2.dts    |  111 +-
 .../dts/kirkwood-netgear_readynas_nv+_v2.dts    |  268 +++++
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi      |    8 +-
 arch/arm/boot/dts/kirkwood-ns2lite.dts          |    4 +-
 arch/arm/boot/dts/kirkwood-ns2max.dts           |   10 +-
 arch/arm/boot/dts/kirkwood-ns2mini.dts          |   10 +-
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi   |    4 +-
 arch/arm/boot/dts/kirkwood-nsa310.dts           |   32 +-
 arch/arm/boot/dts/kirkwood-nsa310a.dts          |   30 +-
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts    |   10 +-
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts    |   10 +-
 .../boot/dts/kirkwood-sheevaplug-common.dtsi    |    2 +-
 arch/arm/boot/dts/kirkwood-sheevaplug-esata.dts |    8 +-
 arch/arm/boot/dts/kirkwood-sheevaplug.dts       |    8 +-
 arch/arm/boot/dts/kirkwood-topkick.dts          |   10 +-
 arch/arm/boot/dts/kirkwood-ts219-6281.dts       |    8 +-
 arch/arm/boot/dts/kirkwood-ts219-6282.dts       |    8 +-
 arch/arm/boot/dts/kirkwood.dtsi                 |  160 +--
 arch/arm/boot/dts/moxart-uc7112lx.dts           |  109 ++
 arch/arm/boot/dts/moxart.dtsi                   |  154 +++
 .../dts/orion5x-lacie-ethernet-disk-mini-v2.dts |    2 +-
 arch/arm/boot/dts/orion5x.dtsi                  |  106 +-
 arch/arm/boot/dts/prima2.dtsi                   |   41 +
 arch/arm/boot/dts/pxa27x.dtsi                   |   24 +
 arch/arm/boot/dts/qcom-msm8974.dtsi             |   64 ++
 arch/arm/boot/dts/r7s72100-genmai.dts           |    2 +-
 arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts |   15 +-
 arch/arm/boot/dts/r8a73a4-ape6evm.dts           |   10 +-
 arch/arm/boot/dts/r8a73a4.dtsi                  |  184 ++-
 .../dts/r8a7740-armadillo800eva-reference.dts   |   90 +-
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts   |    2 +-
 arch/arm/boot/dts/r8a7740.dtsi                  |  144 ++-
 arch/arm/boot/dts/r8a7778-bockw-reference.dts   |   57 +-
 arch/arm/boot/dts/r8a7778-bockw.dts             |    2 +-
 arch/arm/boot/dts/r8a7778.dtsi                  |  172 ++-
 arch/arm/boot/dts/r8a7779-marzen-reference.dts  |   36 +-
 arch/arm/boot/dts/r8a7779-marzen.dts            |    2 +-
 arch/arm/boot/dts/r8a7779.dtsi                  |  114 +-
 arch/arm/boot/dts/r8a7790-lager-reference.dts   |   45 -
 arch/arm/boot/dts/r8a7790-lager.dts             |   64 +-
 arch/arm/boot/dts/r8a7790.dtsi                  |  413 ++++++-
 arch/arm/boot/dts/r8a7791-koelsch-reference.dts |  115 ++
 arch/arm/boot/dts/r8a7791-koelsch.dts           |   35 +-
 arch/arm/boot/dts/r8a7791.dtsi                  |  467 +++++++-
 arch/arm/boot/dts/sama5d3.dtsi                  |   44 +-
 arch/arm/boot/dts/sama5d36.dtsi                 |   20 +
 arch/arm/boot/dts/sama5d36ek.dts                |   53 +
 arch/arm/boot/dts/sama5d3_uart.dtsi             |    5 +
 arch/arm/boot/dts/sama5d3xdm.dtsi               |    1 +
 arch/arm/boot/dts/sh7372-mackerel.dts           |    2 +-
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts    |  103 +-
 arch/arm/boot/dts/sh73a0-kzm9g.dts              |    2 +-
 arch/arm/boot/dts/sh73a0.dtsi                   |  168 +--
 arch/arm/boot/dts/socfpga.dtsi                  |    4 +
 arch/arm/boot/dts/st-pincfg.h                   |    2 +-
 arch/arm/boot/dts/ste-dbx5x0.dtsi               |   32 +
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi  |  745 ++++++++++++
 arch/arm/boot/dts/ste-href-stuib.dtsi           |   41 +
 arch/arm/boot/dts/ste-href-tvk1281618.dtsi      |   90 +-
 arch/arm/boot/dts/ste-href.dtsi                 |   80 +-
 arch/arm/boot/dts/ste-hrefprev60.dtsi           |   78 +-
 arch/arm/boot/dts/ste-hrefv60plus.dtsi          |  251 ++++-
 arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi      |   80 ++
 arch/arm/boot/dts/ste-nomadik-s8815.dts         |    4 -
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi      |    4 +-
 arch/arm/boot/dts/ste-snowball.dts              |  231 +++-
 arch/arm/boot/dts/stih415-pinctrl.dtsi          |   36 +
 arch/arm/boot/dts/stih415.dtsi                  |   53 +
 arch/arm/boot/dts/stih416-pinctrl.dtsi          |   35 +
 arch/arm/boot/dts/stih416.dtsi                  |   53 +
 arch/arm/boot/dts/stih41x-b2000.dtsi            |    9 +
 arch/arm/boot/dts/stih41x-b2020.dtsi            |   22 +
 arch/arm/boot/dts/sun4i-a10-a1000.dts           |    4 -
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts      |    9 -
 arch/arm/boot/dts/sun4i-a10-hackberry.dts       |    4 -
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts      |    4 -
 arch/arm/boot/dts/sun4i-a10.dtsi                |  164 ++-
 arch/arm/boot/dts/sun5i-a10s.dtsi               |  132 ++-
 arch/arm/boot/dts/sun5i-a13-olinuxino-micro.dts |   68 ++
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts       |    4 -
 arch/arm/boot/dts/sun5i-a13.dtsi                |  128 ++-
 arch/arm/boot/dts/sun6i-a31.dtsi                |   34 +
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts      |   18 +
 arch/arm/boot/dts/sun7i-a20.dtsi                |  222 +++-
 arch/arm/boot/dts/tegra114-dalmore.dts          |  630 ++++++-----
 arch/arm/boot/dts/tegra114.dtsi                 |  138 ++-
 arch/arm/boot/dts/tegra124-venice2.dts          | 1064 ++++++++++++++++++
 arch/arm/boot/dts/tegra124.dtsi                 |  418 +++++++
 arch/arm/boot/dts/tegra20-colibri-512.dtsi      |  205 ++--
 arch/arm/boot/dts/tegra20-harmony.dts           |  316 +++---
 arch/arm/boot/dts/tegra20-iris-512.dts          |   30 +-
 arch/arm/boot/dts/tegra20-medcom-wide.dts       |    2 +-
 arch/arm/boot/dts/tegra20-paz00.dts             |   50 +-
 arch/arm/boot/dts/tegra20-plutux.dts            |    4 +-
 arch/arm/boot/dts/tegra20-seaboard.dts          |  353 +++---
 arch/arm/boot/dts/tegra20-tamonten.dtsi         |   47 +-
 arch/arm/boot/dts/tegra20-tec.dts               |    6 +-
 arch/arm/boot/dts/tegra20-trimslice.dts         |   54 +-
 arch/arm/boot/dts/tegra20-ventana.dts           |   62 +-
 arch/arm/boot/dts/tegra20-whistler.dts          |   84 +-
 arch/arm/boot/dts/tegra20.dtsi                  |   55 +-
 arch/arm/boot/dts/tegra30-beaver.dts            |  126 ++-
 arch/arm/boot/dts/tegra30-cardhu-a02.dts        |   14 +-
 arch/arm/boot/dts/tegra30-cardhu-a04.dts        |   14 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi           |  104 +-
 arch/arm/boot/dts/tegra30.dtsi                  |   72 +-
 arch/arm/boot/dts/zynq-7000.dtsi                |   39 +-
 arch/arm/boot/dts/zynq-zc702.dts                |    5 +
 arch/arm/boot/dts/zynq-zc706.dts                |    5 +
 arch/arm/boot/dts/zynq-zed.dts                  |    5 +
 arch/arm/mach-integrator/integrator_ap.c        |   60 +-
 arch/arm/mach-integrator/integrator_cp.c        |   14 -
 arch/arm/mach-nomadik/cpu-8815.c                |   32 -
 arch/arm/mach-shmobile/board-bockw-reference.c  |   12 -
 arch/arm/mach-shmobile/board-marzen.c           |    2 -
 arch/arm/mach-shmobile/clock-r8a73a4.c          |   10 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |    8 +-
 arch/arm/mach-shmobile/clock-r8a7778.c          |    8 +-
 arch/arm/mach-shmobile/clock-r8a7779.c          |    8 +-
 arch/arm/mach-shmobile/clock-r8a7790.c          |   12 +-
 arch/arm/mach-shmobile/clock-sh73a0.c           |    8 +-
 arch/arm/mach-ux500/Makefile                    |    6 +-
 arch/arm/mach-ux500/board-mop500-audio.c        |    3 -
 arch/arm/mach-ux500/board-mop500-pins.c         |  804 -------------
 arch/arm/mach-ux500/board-mop500-regulators.c   |   14 -
 arch/arm/mach-ux500/board-mop500-regulators.h   |    1 -
 arch/arm/mach-ux500/board-mop500-sdi.c          |    2 -
 arch/arm/mach-ux500/board-mop500.c              |   78 --
 arch/arm/mach-ux500/board-mop500.h              |    1 -
 arch/arm/mach-ux500/cpu-db8500.c                |   26 +-
 arch/arm/mach-ux500/cpu.c                       |   23 +-
 arch/arm/mach-ux500/devices-db8500.c            |   28 -
 arch/arm/mach-ux500/devices-db8500.h            |   19 -
 arch/arm/mach-ux500/devices.c                   |   26 -
 arch/arm/mach-ux500/devices.h                   |   15 -
 arch/arm/mach-ux500/setup.h                     |    6 -
 arch/arm/mach-ux500/timer.c                     |   76 +-
 drivers/clk/Makefile                            |    1 +
 drivers/clk/shmobile/Makefile                   |    7 +
 drivers/clk/shmobile/clk-div6.c                 |  185 +++
 drivers/clk/shmobile/clk-mstp.c                 |  229 ++++
 drivers/clk/shmobile/clk-rcar-gen2.c            |  298 +++++
 drivers/clocksource/exynos_mct.c                |    4 +
 drivers/clocksource/nomadik-mtu.c               |   23 +-
 drivers/dma/ste_dma40.c                         |    4 +
 drivers/pinctrl/pinctrl-nomadik.c               |  296 ++++-
 drivers/pinctrl/pinctrl-nomadik.h               |   14 +-
 include/dt-bindings/clock/r8a7790-clock.h       |    7 +
 include/dt-bindings/clock/r8a7791-clock.h       |    6 +
 include/dt-bindings/gpio/tegra-gpio.h           |    1 +
 include/dt-bindings/pinctrl/pinctrl-tegra.h     |   45 +
 include/linux/clk/shmobile.h                    |   19 +
 .../platform_data/clocksource-nomadik-mtu.h     |    9 -
 include/linux/platform_data/pinctrl-nomadik.h   |  242 ----
 238 files changed, 12679 insertions(+), 4211 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/moxart.txt
 create mode 100644 Documentation/devicetree/bindings/clock/renesas,cpg-div6-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/renesas,rcar-gen2-cpg-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/usb/keystone-phy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/keystone-usb.txt
 create mode 100644 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
 create mode 100644 arch/arm/boot/dts/at91-cosino.dtsi
 create mode 100644 arch/arm/boot/dts/at91-cosino_mega2560.dts
 create mode 100644 arch/arm/boot/dts/exynos4412-tiny4412.dts
 rename arch/arm/boot/dts/{cros5250-common.dtsi => exynos5250-cros-common.dtsi} (95%)
 create mode 100644 arch/arm/boot/dts/exynos5420-arndale-octa.dts
 create mode 100644 arch/arm/boot/dts/k2hk-evm.dts
 rename arch/arm/boot/dts/{keystone.dts => keystone.dtsi} (82%)
 create mode 100644 arch/arm/boot/dts/kirkwood-6192.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-laplug.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
 create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
 create mode 100644 arch/arm/boot/dts/moxart.dtsi
 delete mode 100644 arch/arm/boot/dts/r8a7790-lager-reference.dts
 create mode 100644 arch/arm/boot/dts/r8a7791-koelsch-reference.dts
 create mode 100644 arch/arm/boot/dts/sama5d36.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d36ek.dts
 create mode 100644 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/sun5i-a13-olinuxino-micro.dts
 delete mode 100644 arch/arm/mach-ux500/board-mop500.c
 delete mode 100644 arch/arm/mach-ux500/devices-db8500.c
 delete mode 100644 arch/arm/mach-ux500/devices-db8500.h
 delete mode 100644 arch/arm/mach-ux500/devices.c
 delete mode 100644 arch/arm/mach-ux500/devices.h
 create mode 100644 drivers/clk/shmobile/Makefile
 create mode 100644 drivers/clk/shmobile/clk-div6.c
 create mode 100644 drivers/clk/shmobile/clk-mstp.c
 create mode 100644 drivers/clk/shmobile/clk-rcar-gen2.c
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-tegra.h
 create mode 100644 include/linux/clk/shmobile.h
 delete mode 100644 include/linux/platform_data/clocksource-nomadik-mtu.h
 delete mode 100644 include/linux/platform_data/pinctrl-nomadik.h
