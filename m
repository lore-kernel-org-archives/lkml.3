Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbaHHQsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:48:51 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55728 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbaHHQrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:47:48 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/7] ARM: SoC device-tree changes for 3.17
Date: Fri,  8 Aug 2014 09:47:56 -0700
Message-Id: <1407516479-1251-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 2.0.1.473.gc4d58ca
In-Reply-To: <1407516479-1251-1-git-send-email-olof@lixom.net>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the board branch, this keeps having large sets of changes for
every release, but that's quite expected and is so far working well.

Most of this is plumbing for various device bindings and new platforms,
but there's also a bit of cleanup and code removal for things that
are moved from platform code to DT contents (some OMAP clock code in
particular).

There's also a pinctrl driver for tegra here (appropriately acked),
that's introduced this way to make it more bisectable.

I'm happy to say that there were no conflicts at all with this branch
this release, which means that changes are flowing through our tree as
expected instead of merged through driver maintainers (or at least not
done with conflicts).

There are several new boards added, and a couple of SoCs. In no particular
order:

* Rockchip RK3288 SoC support, including DTS for a dev board that they
  have seeded with some community developers.
* Better support for Hardkernel Exynos4-based ODROID boards.
* CCF conversions (and dtsi contents) for several Renesas platforms.
* Gumstix Pepper (TI AM335x) board support
* TI eval board support for AM437x
* Allwinner A23 SoC, very similar to existing ones which mostly has
  resulted in DT changes for support. Also includes support for an Ippo
  tablet with the chipset.
* Allwinner A31 Hummingbird board support, not to be confused with the
  SolidRun i.MX-based Hummingboard.
* Tegra30 Apalis board support



Conflicts: None!

----------------------------------------------------------------

The following changes since commit 70cd5beccd0a88524a9b043be01d57787e2da137:

  Merge branch 'next/boards' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-3.17

for you to fetch changes up to 8850e0ba5721c2e2db34bc38290722db1b402be5:

  Merge tag 'samsung-dt-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/dt

----------------------------------------------------------------

Alban Bedel (2):
      ARM: tegra: tamonten: add the base board regulators
      ARM: tegra: tamonten: add the display to the Medcom Wide

Alex Elder (3):
      devicetree: bindings: document Broadcom CPU enable method
      ARM: dts: enable SMP support for bcm28155
      ARM: dts: enable SMP support for bcm21664

Alexander Bersenev (3):
      ARM: sunxi: Add pins for IR controller on A20 to dtsi
      ARM: sunxi: Enable IR controller on cubieboard 2 and cubietruck in dts
      ARM: sunxi: Add IR controllers on A20 to dtsi

Alexander Shiyan (3):
      ARM: dts: Add support for the cpuimx27 board from Eukrea and its baseboard
      ARM: dts: i.MX35: Add GPT node
      ARM: i.MX27 clk: dts: Use clock defines in DTS files

Alexandre Belloni (40):
      ARM: at91/dt: sam9261 crystals under the clocks node
      ARM: at91/dt: sam9n12 crystals under the clocks node
      ARM: at91/dt: sam9rl crystals under the clocks node
      ARM: at91/dt: sam9x5 crystals under the clocks node
      ARM: at91/dt: sama5d3 crystals under the clocks node
      Documentation: dt: document all the atmel pmc compatibles
      ARM: at91/dt: ariag25: define crystals frequencies
      ARM: at91: prepare common clk transition for rm9200
      ARM: at91/dt: rm9200: define clocks
      ARM: at91: move at91rm9200 SoC to the CCF
      ARM: at91/dt: at91rm9200ek: define crystals frequencies
      ARM: at91: prepare common clk transition for sam9260
      ARM: at91/dt: sam9260: define clocks
      ARM: at91/dt: sam9g20: define clocks
      ARM: at91: move at91sam9260 SoCs to the CCF
      ARM: at91/dt: at91sam9g20ek: define crystals frequencies
      ARM: at91/dt: foxg20: define crystals frequencies
      ARM: at91/dt: usb_a9260: define crystals frequencies
      ARM: at91/dt: tny_a9260: define crystals frequencies
      ARM: at91/dt: qil_a9260: define crystals frequencies
      ARM: at91/dt: mpa1600: define crytals frequencies
      ARM: at91/dt: ge863-pro3: define main crystal frequency
      ARM: at91/dt: aks-cdu: define slow crytal frequency
      ARM: at91/dt: evk-pro3: define slow crytal frequency
      ARM: at91/dt: ethernut5: define crystals frequencies
      ARM: at91/dt: animeo_ip: define crystals frequencies
      ARM: at91/dt: kizbox: define main crystal frequency
      ARM: at91: prepare common clk transition for sam9g45
      ARM: at91/dt: sam9g45: define clocks
      ARM: at91: move at91sam9g45 SoC to the CCF
      ARM: at91/dt: sam9m10g45ek: define crystals frequencies
      ARM: at91/dt: pm9g45: crystals frequencies
      ARM: at91/dt: cosino define crystals frequencies
      ARM: at91: prepare common clk transition for sam9263
      ARM: at91/dt: sam9263: define clocks
      ARM: at91: move at91sam9263 SoC to the CCF
      ARM: at91/dt: sam9263ek: define crystals frequencies
      ARM: at91/dt: tny_a9263: define crystals frequencies
      ARM: at91/dt: usb_a9263: define crystals frequencies
      ARM: dt: imx28-cfa10036: introduce a regulator for mmc0

Alexandre Courbot (4):
      ARM: tegra: roth: fix unsupported pinmux properties
      ARM: tegra: roth: enable input on mmc clock pins
      ARM: tegra: of: add GK20A device tree binding
      ARM: tegra: roth: add display DT node

Andreas Faerber (6):
      ARM: dts: Fill in CPU clock-frequency for exynos5410
      ARM: dts: Document exynos5410 PMU
      ARM: dts: Add PMU to exynos5410
      ARM: EXYNOS: Add support for Exynos5410 PMU
      ARM: dts: max77686 is exynos5250-snow only
      ARM: dts: cypress,cyapa trackpad is exynos5250-Snow only

Andreas Färber (5):
      Documentation: devicetree: Adapteva vendor prefix
      Documentation: devicetree: Adapteva boards
      ARM: dts: zynq: Add Parallella device tree
      ARM: dts: zynq: Add DMAC for Parallella
      ARM: dts: zynq: Add SPI

Andrew Lunn (1):
      ARM: Kirkwood: Add DT descriptions for net2big and net5big.

Anson Huang (2):
      ARM: dts: imx6sx-sdb: add gpio key support
      ARM: dts: imx6sx: iomux-gpr syscon is compatible to imx6q

Anssi Hannula (2):
      ARM: dts: imx6: remove wrong spdif rxtx2 clock
      ARM: dts: imx6: remove non-working spdif rxtx4 and rxtx6 clocks

Antoine Ténart (6):
      ARM: dts: berlin: add I2C nodes for BG2Q
      ARM: dts: berlin: enable i2c0 and i2c2
      Documentation: bindings: add the Berlin CPU control doc
      Documentation: bindings: add the marvell,berlin-smp CPU enable method
      ARM: dts: berlin: add SMP related nodes and properties for BG2
      ARM: dts: berlin: add SMP related nodes and properties for BG2Q

Arnd Bergmann (8):
      Merge tag 'mvebu-dt-3.17-3' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'zynq-dt-for-3.17-2' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge branch 'clk-rockchip' of git://git.linaro.org/people/mike.turquette/linux into next/soc
      Merge tag 'v3.17-rockchip-rk3288' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'v3.17-rockchip-rk3xxx-dts' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'mvebu-dt-3.17-4' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'v3.16-rc6' into next/dt
      Merge tag 'for-3.17/bcm-dt' of git://github.com/broadcom/mach-bcm into next/dt

Ash Charles (1):
      ARM: dts: Add devicetree for Gumstix Pepper board

Ben Dooks (4):
      ARM: shmobile: lager: enable i2c devices
      ARM: shmobile: lager: add i2c1, i2c2 pins
      ARM: shmobile: r8a7790: add internal PCI bridge nodes
      ARM: shmobile: lager: enable internal PCI

Beniamino Galvani (3):
      ARM: dts: add i2c and regulator nodes to rk3188-radxarock
      ARM: dts: rockchip: add pwm nodes
      ARM: dts: rk3188-radxarock: add GPIO IR receiver node

Benoit Cousson (2):
      ARM: shmobile: lager: Add VDD MPU regulator for DVFS
      ARM: shmobile: r8a7790/lager dts: Add DVFS parameters into cpu0 node for r8a7790

Benoit Masson (2):
      of: Add Lenovo Group Ltd. to the vendor-prefixes list.
      ARM: mvebu: Add dts definition for Lenovo Iomega ix4-300d NAS

Bo Shen (2):
      ARM: at91: sama5d3xek: switch sound to CCF
      ARM: at91: at91sam9n12ek: switch sound to CCF

Carlo Caione (2):
      ARM: dts: sun4i: Add AXP209 support to various boards
      ARM: dts: sun7i: Add AXP209 support to various boards

Chanho Park (1):
      ARM: dts: clean up arm-pmu node for exynos4

Chanwoo Choi (3):
      ARM: dts: Add TMU dt node to monitor the temperature for exynos3250
      ARM: dts: Remove duplicate 'interrput-parent' property for exynos3250
      ARM: dts: Add missing pinctrl for uart0/1 for exynos3250

Chen-Yu Tsai (10):
      ARM: sunxi: Add Allwinner A23 dtsi
      ARM: sun8i: dt: Add Ippo-q8h v5 support
      ARM: dts: sunxi: Add #interrupt-cells to pinctrl nodes
      ARM: sun8i: Add basic clock nodes to the DTSI
      ARM: sun8i: Add reset controller nodes to the DTSI
      ARM: sun8i: Add PRCM clock and reset controller nodes to the DTSI
      ARM: dts: sun6i: Add pin muxing options for GMAC
      ARM: dts: sun6i: Add GMAC clock node to the A31 dtsi
      ARM: dts: sun6i: Add A31 GMAC gigabit ethernet controller node
      ARM: dts: sun6i: Add ethernet alias for GMAC

Darren Etheridge (1):
      ARM: dts: am335x-evmsk: enable display and lcd panel support

Denis Carikli (3):
      ARM: dts: imx25: mbimxsd25: Add displays support.
      ARM: dts: mbimxsd25: cmo-qvga: Fix lcd regulator
      ARM: dts: i.MX25: Fix gpt timers clocks.

Doug Anderson (9):
      ARM: dts: Create a cros-ec-keyboard fragment
      ARM: tegra: Use the cros-ec-keyboard fragment in venice2
      ARM: dts: Use the cros-ec-keyboard fragment in exynos5250-snow
      ARM: dts: Add mask-tpm-reset node in exynos5420-peach-pit
      ARM: tegra: Add the EC i2c tunnel to tegra124-venice2
      ARM: dts: Add cros_ec to exynos5420-peach-pit and exynos5800-peach-pi
      ARM: dts: Build dtbs for Rockchip boards
      ARM: dts: Turn on USB host vbus on rk3288-evb
      ARM: dts: Enable USB host0 (EHCI) on rk3288-evb

Dylan Reid (2):
      ARM: tegra: Add Tegra124 HDA support
      ARM: tegra: venice2 - Enable HDA

Ezequiel Garcia (3):
      ARM: mvebu: Add support for the network controller in Armada 375 SoC
      ARM: mvebu: Enable the network controller in Armada 375 DB board
      ARM: mvebu: Add missing MDIO clock in Armada 375

Fabio Estevam (13):
      ARM: dts: imx6qdl-sabresd: Configure the ECSPI1 chip select pin
      ARM: dts: imx51-babbage: Add PMIC RTC support
      ARM: dts: imx6q-udoo: Add USB Host support
      ARM: dts: imx6sx: Use "vddarm" as the regulator name
      ARM: dts: imx6sx: Fix usbmisc compatible string
      ARM: dts: imx6sx-sdb: Add USB support
      ARM: dts: imx6sx-sdb: Add PMIC support
      ARM: dts: mx6: Disable the keypad in the dtsi files
      ARM: dts: imx25-pdk: Add USB OTG support
      ARM: dts: imx6sx: Fix sdma node
      ARM: dts: imx6sx: Pass the fsl,fifo-depth property
      ARM: dts: imx6sx-sdb: Add audio support
      ARM: imx6: Align ssi nodes between mx6 variants

Felipe Balbi (2):
      ARM: dts: am4372: let boards access all nodes through labels
      ARM: dts: add support for AM437x StarterKit

Fugang Duan (1):
      ARM: dts: imx6sl: add fec sleep pinctrl for pin PM state

Gaku Inami (2):
      ARM: shmobile: koelsch dts: Add VDD MPU regulator for DVFS
      ARM: shmobile: r8a7791/koelsch dts: Add DVFS parameters into cpu0 node for r8a7791

Geert Uytterhoeven (4):
      ARM: shmobile: armadillo800eva reference dts: Add matching LED labels
      ARM: shmobile: r8a7791 dtsi: add SYS-DMAC clocks
      ARM: shmobile: r8a7790: Fix whitespace errors in pci nodes
      ARM: shmobile: genmai reference dts: Add RSPI node

George Joseph (1):
      ARM: dts: Restructure imx6qdl-wandboard.dtsi for new rev C1 board.

Gregory CLEMENT (1):
      ARM: mvebu: add CA9 MPcore SoC Controller node

Grygorii Strashko (3):
      ARM: dts: keystone: fix netcp's clocks definitions
      ARM: dts: keystone: add mdio devices entries
      ARM: dts: keystone-evm: add 1g ethernet phys nodes

Hans de Goede (5):
      ARM: dts: sun7i: Rename sun7i-a20-ir to sun4i-a10-ir
      ARM: dts: sun7i: Add ir receiver support to a20-i12-tvbox
      ARM: dts: sun4i: Add new ba10-tvbox board
      ARM: dts: sun4i: Add ir controller nodes and pinmux
      ARM: dts: sun4i: Add ir node to various boards

Heiko Schocher (1):
      ARM: dts: imx6: add aristainetos board support

Heiko Stuebner (21):
      dt-bindings: arm: add cortex-a12 and cortex-a17 cpu compatible properties
      ARM: rockchip: clarify usability of DEBUG_RK3X_UART debug_ll options
      ARM: rockchip: add debug uart used by rk3288
      ARM: Kconfig: set default gpio number for rockchip SoCs
      ARM: rockchip: enable support for RK3288 SoCs
      ARM: dts: rockchip: add core rk3288 dtsi
      ARM: dts: add rk3288 evaluation board
      ARM: dts: rockchip: add cru nodes and update device clocks to use it
      ARM: dts: rockchip: move oscillator input clock into main dtsi
      arm: dts: rockchip: remove obsolete clock gate definitions
      ARM: dts: rockchip: remove soc subnodes
      ARM: dts: rockchip: add handles for shared nodes that don't have one yet
      ARM: dts: uses handles to reference nodes for changes
      ARM: dts: rockchip: remove address from pinctrl nodes
      ARM: dts: rockchip: oder nodes by register address
      ARM: dts: add rk3066 and rk3188 i2c device nodes and pinctrl settings
      ARM: dts: rockchip: add tps65910 regulator for bqcurie2
      ARM: dts: rk3188-radxarock: enable sd-card slot
      ARM: dts: rockchip: add both clocks to uart nodes
      ARM: dts: rockchip: remove pinctrl setting from radxarock uart2
      ARM: dts: rockchip: add watchdog node

Iain Paton (1):
      ARM: dts: imx6: RIoTboard explicitly define pad settings

Jason Cooper (1):
      ARM: kirkwood: fix net5big regulator gpio assignments

Jisheng Zhang (1):
      ARM: dts: berlin2q: set L2CC tag and data latency to 2 cycles

Kamil Debski (2):
      ARM: dts: add support for USB phy, host and device for exynos4412-odroidx
      ARM: dts: disable 'always on' for BUCK8 regulator for exynos4412-odroid-common

Keerthy (6):
      ARM: dts: AM43x: Add TPS65218 device tree nodes
      ARM: dts: AM437x: Fix i2c nodes indentation
      ARM: dts: AM437x: Add TPS65218 device tree nodes
      ARM: omap2plus_defconfig: enable TPS65218 configs
      ARM: dts: dra7xx-clocks: Add divider table to optfclk_pciephy_div clock
      ARM: dts: dra7xx-clocks: Change the parent of apll_pcie_in_clk_mux to dpll_pcie_ref_m2ldo_ck

Kever Yang (1):
      ARM: dts: add rk3288 ehci usb devices

Khiem Nguyen (1):
      ARM: shmobile: Lager: Correct I2C bus for VDD MPU regulator

Kishon Vijay Abraham I (6):
      ARM: dts: dra7xx-clocks: Add missing 32KHz clocks used for PHY
      ARM: dts: dra7xx-clocks: rename pcie clocks to accommodate second PHY instance
      ARM: dts: dra7xx-clocks: Add missing clocks for second PCIe PHY instance
      ARM: dts: dra7: Add dt data for PCIe PHY control module
      ARM: dts: dra7: Add dt data for PCIe PHY
      ARM: dts: dra7: Add dt data for PCIe controller

Kukjin Kim (1):
      Merge branch 'v3.17-next/power-exynos' into v3.17-next/dt-samsung-2

Kuninori Morimoto (7):
      ARM: shmobile: r8a7790: add MSTP10 support on DTSI
      ARM: shmobile: r8a7790: add R-Car sound support on DTSI
      ARM: shmobile: r8a7791: add audio clock on DTSI
      ARM: shmobile: r8a7791: add MSTP10 support on DTSI
      ARM: shmobile: r8a7791: add R-Car sound support on DTSI
      ARM: shmobile: r8a7790: add DVC support for sound node on DTSI
      ARM: shmobile: r8a7791: add DVC support for sound node on DTSI

Linus Walleij (3):
      ARM: ux500: add VCC and VIO regulators to STMPE IC
      ARM: ux500: add some DB8500 DMA channel info
      ARM: ux500: add misc sensors to the device trees

Lothar Waßmann (2):
      ARM: dts: imx6: add missing compatible and clock properties for kpp
      ARM: dts: imx6: add support for Ka-Ro TX6 modules

Lucas Stach (1):
      ARM: tegra: jetson-tk1: mark eMMC as non-removable

Magnus Damm (1):
      ARM: shmobile: Lager memory map update

Marc Carino (4):
      ARM: brcmstb: add CPU binding for Broadcom Brahma15
      ARM: brcmstb: add misc. DT bindings for brcmstb
      ARM: brcmstb: gic: add compatible string for Broadcom Brahma15
      ARM: brcmstb: dts: add a reference DTS for Broadcom 7445

Marcel Ziswiler (3):
      ARM: tegra: initial support for apalis t30
      ARM: tegra: Migrate Apalis T30 PCIe power supply scheme
      ARM: tegra: apalis t30: fix device tree compatible node

Marcin Wojtas (1):
      ARM: mvebu: Add ethernet aliases required by U-Boot

Marek Szyprowski (6):
      ARM: dts: add port sub-nodes to exynos usb host modules for exynos4
      ARM: dts: enable common hardware blocks for exynos4412-odroidx
      ARM: dts: correct memory size for exynos4412-odroidx
      ARM: dts: refactor Odroid DTS file and add support for Odroid X2 and U2/U3
      ARM: dts: add support for GPIO buttons for exynos4412-odroid
      ARM: dts: fix T-FLASH hotplug detection for exynos4412-odroid-common

Marek Vasut (2):
      ARM: dts: mxs: Split M28EVK into SoM and EVK parts
      ARM: dts: mx5: Split M53EVK into SoM and EVK parts

Markus Pargmann (4):
      ARM: dts: imx50: add ssi dma properties
      ARM: dts: imx5: remove fsl,ssi-dma-events
      ARM: dts: imx6qdl: remove fsl,ssi-dma-events
      ARM: dts: imx: remove ssi fsl,mode for audio cards

Maxime Ripard (1):
      ARM: dts: sun6i: Add Merrii A31 Hummingbird support

Michal Simek (2):
      ARM: zynq: DT: Add CAN node
      ARM: zynq: DT: Clarify Xilinx Zynq platform

Nicolas Ferre (3):
      ARM: at91/dt: add DMA controller node to at91sam9rl
      ARM: at91/dt: add NAND + DMA property for at91sam9rl
      Merge tag 'CCF-for-3.17' of git://github.com/at91linux/linux-at91 into at91-3.17-dt

Olof Johansson (21):
      Merge tag 'renesas-dt-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'berlin-dt-3.17-1' of git://git.infradead.org/users/hesselba/linux-berlin into next/dt
      Merge tag 'renesas-dt2-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'ux500-devicetree-v3.16-1' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'renesas-dt3-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'omap-for-v3.17/dt-part1' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'keystone-dts' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt
      Merge tag 'imx-dt-3.17' of git://git.kernel.org/.../shawnguo/linux into next/dt
      Merge tag 'zynq-dt-for-3.17' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'sunxi-dt-for-3.17' of git://git.kernel.org/.../mripard/linux into next/dt
      Merge tag 'tegra-for-3.17-xusb-padctl' of git://git.kernel.org/.../tegra/linux into next/dt
      Merge tag 'tegra-for-3.17-dt' of git://git.kernel.org/.../tegra/linux into next/dt
      Merge tag 'samsung-dt' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'mvebu-dt-3.17' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'mvebu-dt-3.17-2' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'renesas-clock3-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'zynq-dt-for-3.17-3' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'v3.17-rockchip-rk3288-2' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'v3.17-rockchip-rk3xxx-dts-2' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'samsung-dt-2' of git://git.kernel.org/.../kgene/linux-samsung into next/dt

Peter Ujfalusi (3):
      ARM: DTS: omap5-uevm: Enable palmas clk32kgaudio clock
      ARM: DTS: omap5-uevm: Add node for twl6040 audio codec
      ARM: DTS: omap5-uevm: Enable basic audio (McPDM <-> twl6040)

Phil Edworthy (8):
      ARM: shmobile: r8a7790: Add PCIEC clock device tree node
      ARM: shmobile: r8a7790: Add default PCIe bus clock
      ARM: shmobile: r8a7790: Add PCIe Controller device node
      ARM: shmobile: r8a7791: Add PCIEC clock device tree node
      ARM: shmobile: r8a7791: Add default PCIe bus clock
      ARM: shmobile: r8a7791: Add PCIe Controller device node
      ARM: shmobile: koelsch: Enable PCIe Controller & PCIe bus clock
      ARM: shmobile: henninger: Enable PCIe Controller & PCIe bus clock

Philipp Zabel (2):
      ARM: dts: pfla02: Add ethernet phy supply regulator
      ARM: dts: imx6qdl: Add CSI device tree port nodes for IPU1 and IPU2

R Sricharan (2):
      ARM: dts: dra7: add routable-irqs property for gic node
      ARM: dts: dra7: add crossbar device binding

Rahul Sharma (1):
      ARM: dts: remove display power domain for exynos5420

Robert Nelson (2):
      ARM: dts: add initial Rex Pro board support
      ARM: dts: add initial Rex Basic board support

Roger Quadros (1):
      ARM: dts: dra7-evm: Add regulator information to USB2 PHYs

Russell King (3):
      ARM: dts: cubox-i: add eSATA DT configuration
      ARM: dts: cubox-i: disable spread-spectrum for Cubox-i eSATA
      ARM: dts: dove: add DT LCD controllers

Sebastian Hesselbarth (2):
      dt-binding: add vendor prefix for SolidRun
      ARM: dts: mvebu: split SolidRun CuBox into variants

Sergei Shtylyov (4):
      ARM: shmobile: henninger: add I2C2 DT support
      ARM: shmobile: r8a7791: add internal PCI bridge nodes
      ARM: shmobile: koelsch: enable internal PCI
      ARM: shmobile: henninger: enable internal PCI

Shawn Guo (7):
      Merge tag 'imx-soc-3.17' into imx/dt
      ARM: dts: imx: add pin function header for imx6sx
      ARM: dts: imx: add initial imx6sx device tree source
      ARM: dts: imx: add initial imx6sx-sdb board support
      ARM: dts: imx6qdl: use DT macro for clock ID
      ARM: dts: imx: correct sdma compatbile for imx6sl and imx6sx
      ARM: dts: imx53: correct clock-names of SATA node

Silvio Fricke (3):
      ARM: dts: imx6: edmqmx6: Add PCIe support
      ARM: dts: imx6: edmqmx6: Add two other i2c buses
      ARM: dts: imx6: edmqmx6: Add can bus

Simon Guinot (2):
      ARM: Kirkwood: allow to use netxbig DTSI for d2net_v2 DTS
      ARM: Kirkwood: add DT support for d2 Network v2

Simon Horman (22):
      ARM: shmobile: marzen: Remove early_printk from command line
      ARM: shmobile: lager: Move i2c[12]_pins nodes to pfc node
      ARM: shmobile: lager: Remove duplicate i2c3 nodes
      ARM: shmobile: koelsch: Remove duplicate i2c6 nodes
      ARM: shmobile: henninger: Consistently use tabs for indentation
      ARM: shmobile: r8a7779: Consistently use tabs for indentation
      ARM: shmobile: armadillo800eva-reference: Remove early_printk from command line
      ARM: shmobile: kzm9g-reference: Remove early_printk from command line
      Merge branch 'clock-for-v3.17' into dt-for-v3.17
      ARM: shmobile: r8a7778: Add SCIF nodes
      ARM: shmobile: bockw-reference: Initialise SCIF device using DT
      ARM: shmobile: r8a73a4: Add SCIF nodes
      ARM: shmobile: ape6evm-reference: Initialise SCIF device using DT
      ARM: shmobile: r8a7740: Add SCIF nodes
      ARM: shmobile: armadillo800eva-reference: Initialise SCIF device using DT
      ARM: shmobile: sh73a0: Add SCIF nodes
      ARM: shmobile: kzm9g-reference: Initialise SCIF device using DT
      ARM: shmobile: r8a7778: add TMU clock support for DT
      ARM: shmobile: r8a7740: add TMU clock support for DT
      ARM: shmobile: r8a73a4: add CMT1 clock support for DT
      ARM: shmobile: r8a7740: add CMT1 clock support for DT
      ARM: shmobile: sh73a0: add CMT1 clock support for DT

Soren Brinkmann (5):
      tty: cadence: Document DT binding
      ARM: zynq: DT: Migrate UART to Cadence binding
      ARM: zynq: DT: Add XADC node
      ARM: zynq: DT: Add GPIO node
      ARM: zynq: DT: Remove DMA from board DTs

Stefan Agner (2):
      ARM: dts: vf610: fix length of eshdc1 register property
      ARM: dts: vf610: add FlexCAN node

Steffen Trumtrar (1):
      ARM: dts: i.MX53: add aipstz nodes

Sylwester Nawrocki (1):
      ARM: dts: Add sound nodes for Odroid-X2/U3 boards

Tero Kristo (5):
      ARM: OMAP2: convert sys_ck and osc_ck to standard clock types
      ARM: OMAP2420: clock: get rid of fixed-div property use
      ARM: OMAP2: PRM: add support for OMAP2 specific clock providers
      ARM: OMAP2: clock: use DT clock boot if available
      ARM: OMAP24xx: clock: remove legacy clock data

Thierry Reding (9):
      of: Add NVIDIA Tegra XUSB pad controller binding
      pinctrl: Add NVIDIA Tegra XUSB pad controller support
      Merge branch 'for-3.17/fuse-move' into for-3.17/dt
      Merge branch 'for-3.17/dt-cros-ec-kbd' into for-3.17/dt
      Merge branch 'for-3.17/xusb-padctl' into for-3.17/dt
      ARM: tegra: add GK20A GPU to Tegra124 DT
      ARM: tegra: tegra124: Add XUSB pad controller
      ARM: tegra: jetson-tk1: Add XUSB pad controller
      ARM: tegra: paz00: Fix some indentation inconsistencies

Thomas Abraham (1):
      ARM: dts: Specify MAX77686 pmic interrupt for exynos5250-smdk5250

Thomas Petazzoni (1):
      ARM: mvebu: update Armada XP DT for dynamic frequency scaling

Tim Harvey (2):
      ARM: dts: imx6: ventana: change sound device name
      ARM: dts: imx6: ventana: update model to reflect Dual/Solo CPU types

Tomasz Figa (1):
      ARM: dts: Add I2S dt node for exynos3250

Tony Lindgren (2):
      Merge branch 'dts-crossbar' into omap-for-v3.17/dt
      Merge branch 'for-v3.17/omap2-use-dt-clks' of http://github.com/t-kristo/linux-pm into omap-for-v3.17/dt

Tuomas Tynkkynen (1):
      ARM: tegra: Fix typoed ams,ext-control properties

Tushar Behera (3):
      ARM: dts: Enable audio support for exynos5800-peach-pi
      ARM: dts: Sort nodes within Peach-pit/Peach-pi dts files
      ARM: dts: Add sound-card name for Snow/Peach-Pit/Peach-Pi

Vikas Sajjan (3):
      ARM: dts: Add mask-tpm-reset node in exynos5800-peach-pi
      ARM: dts: Add PMU DT node for exynos5260 SoC
      ARM: EXYNOS: Add exynos5260 PMU compatible string to DT match table

Vince Bridgers (1):
      ARM: socfpga: Add missing #reset-cells to socfpga device tree

Wolfram Sang (1):
      ARM: shmobile: r8a7790: lager: use iic cores instead of i2c

Yoshihiro Shimoda (2):
      ARM: shmobile: r8a7790: add USB3.0 clocks to device tree
      ARM: shmobile: r8a7791: add USB3.0 clocks to device tree

Zoltan HERPAI (1):
      ARM: dts: sun7i: Add board support for LinkSprite pcDuino V3


 .../devicetree/bindings/arm/adapteva.txt        |    7 +
 .../bindings/arm/armada-380-mpcore-soc-ctrl.txt |   14 +
 .../devicetree/bindings/arm/atmel-pmc.txt       |    5 +-
 .../bindings/arm/bcm/brcm,bcm11351-cpu-method   |   36 +
 .../devicetree/bindings/arm/brcm-brcmstb.txt    |   95 +
 .../arm/cpu-enable-method/marvell,berlin-smp    |   41 +
 Documentation/devicetree/bindings/arm/cpus.txt  |    4 +
 Documentation/devicetree/bindings/arm/gic.txt   |    1 +
 .../devicetree/bindings/arm/marvell,berlin.txt  |   16 +
 .../devicetree/bindings/arm/omap/omap.txt       |    3 +
 .../devicetree/bindings/arm/omap/prcm.txt       |   65 +
 .../devicetree/bindings/arm/samsung/pmu.txt     |    2 +
 Documentation/devicetree/bindings/arm/tegra.txt |    2 +
 .../devicetree/bindings/arm/xilinx.txt          |    8 +-
 .../devicetree/bindings/gpu/nvidia,gk20a.txt    |   43 +
 .../pinctrl/nvidia,tegra124-xusb-padctl.txt     |  127 ++
 .../devicetree/bindings/serial/cdns,uart.txt    |   20 +
 .../devicetree/bindings/vendor-prefixes.txt     |    3 +
 arch/arm/Kconfig                                |    1 +
 arch/arm/Kconfig.debug                          |   20 +-
 arch/arm/boot/dts/Makefile                      |   51 +-
 arch/arm/boot/dts/aks-cdu.dts                   |    6 +
 arch/arm/boot/dts/am335x-evmsk.dts              |  105 +
 arch/arm/boot/dts/am335x-pepper.dts             |  653 ++++++
 arch/arm/boot/dts/am4372.dtsi                   |    8 +-
 arch/arm/boot/dts/am437x-gp-evm.dts             |   71 +-
 arch/arm/boot/dts/am437x-sk-evm.dts             |  613 ++++++
 arch/arm/boot/dts/am43x-epos-evm.dts            |   59 +
 arch/arm/boot/dts/animeo_ip.dts                 |    8 +
 arch/arm/boot/dts/armada-375-db.dts             |   26 +
 arch/arm/boot/dts/armada-375.dtsi               |   34 +
 arch/arm/boot/dts/armada-38x.dtsi               |    5 +
 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts |  284 +++
 arch/arm/boot/dts/armada-xp-mv78230.dtsi        |    2 +
 arch/arm/boot/dts/armada-xp-mv78260.dtsi        |    2 +
 arch/arm/boot/dts/armada-xp-mv78460.dtsi        |    4 +
 arch/arm/boot/dts/armada-xp.dtsi                |    2 +-
 arch/arm/boot/dts/at91-ariag25.dts              |    8 +
 arch/arm/boot/dts/at91-cosino.dtsi              |    8 +
 arch/arm/boot/dts/at91-foxg20.dts               |    8 +
 arch/arm/boot/dts/at91-qil_a9260.dts            |    8 +
 arch/arm/boot/dts/at91-sama5d3_xplained.dts     |   12 +-
 arch/arm/boot/dts/at91rm9200.dtsi               |  304 +++
 arch/arm/boot/dts/at91rm9200ek.dts              |    8 +
 arch/arm/boot/dts/at91sam9260.dtsi              |  314 ++-
 arch/arm/boot/dts/at91sam9261.dtsi              |   20 +-
 arch/arm/boot/dts/at91sam9261ek.dts             |   16 +-
 arch/arm/boot/dts/at91sam9263.dtsi              |  311 +++
 arch/arm/boot/dts/at91sam9263ek.dts             |    8 +
 arch/arm/boot/dts/at91sam9g20.dtsi              |   24 +
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi     |    8 +
 arch/arm/boot/dts/at91sam9g45.dtsi              |  342 ++-
 arch/arm/boot/dts/at91sam9m10g45ek.dts          |    8 +
 arch/arm/boot/dts/at91sam9n12.dtsi              |   20 +-
 arch/arm/boot/dts/at91sam9n12ek.dts             |   18 +-
 arch/arm/boot/dts/at91sam9rl.dtsi               |   32 +-
 arch/arm/boot/dts/at91sam9rlek.dts              |   17 +-
 arch/arm/boot/dts/at91sam9x5.dtsi               |   30 +-
 arch/arm/boot/dts/at91sam9x5cm.dtsi             |   12 +-
 arch/arm/boot/dts/bcm11351.dtsi                 |   19 +
 arch/arm/boot/dts/bcm21664.dtsi                 |   19 +
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts      |   14 +
 arch/arm/boot/dts/bcm7445.dtsi                  |  111 +
 arch/arm/boot/dts/berlin2.dtsi                  |    6 +
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts      |    8 +
 arch/arm/boot/dts/berlin2q.dtsi                 |   80 +
 arch/arm/boot/dts/cros-ec-keyboard.dtsi         |  105 +
 arch/arm/boot/dts/dove-cubox-es.dts             |   12 +
 arch/arm/boot/dts/dove-cubox.dts                |    3 -
 arch/arm/boot/dts/dove.dtsi                     |   14 +
 arch/arm/boot/dts/dra7-evm.dts                  |    8 +
 arch/arm/boot/dts/dra7.dtsi                     |  265 ++-
 arch/arm/boot/dts/dra7xx-clocks.dtsi            |   39 +-
 arch/arm/boot/dts/ethernut5.dts                 |   10 +
 arch/arm/boot/dts/evk-pro3.dts                  |    6 +
 arch/arm/boot/dts/exynos3250.dtsi               |   28 +-
 arch/arm/boot/dts/exynos4.dtsi                  |   30 +
 arch/arm/boot/dts/exynos4210.dtsi               |    6 -
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi |  371 ++++
 arch/arm/boot/dts/exynos4412-odroidu3.dts       |   61 +
 arch/arm/boot/dts/exynos4412-odroidx.dts        |  279 +--
 arch/arm/boot/dts/exynos4412-odroidx2.dts       |   32 +
 arch/arm/boot/dts/exynos4412.dtsi               |    4 +
 arch/arm/boot/dts/exynos4x12.dtsi               |    6 -
 arch/arm/boot/dts/exynos5250-cros-common.dtsi   |  159 --
 arch/arm/boot/dts/exynos5250-smdk5250.dts       |    2 +
 arch/arm/boot/dts/exynos5250-snow.dts           |  259 ++-
 arch/arm/boot/dts/exynos5260.dtsi               |    5 +
 arch/arm/boot/dts/exynos5410.dtsi               |    9 +
 arch/arm/boot/dts/exynos5420-peach-pit.dts      |  392 +++-
 arch/arm/boot/dts/exynos5420.dtsi               |    6 -
 arch/arm/boot/dts/exynos5800-peach-pi.dts       |  374 +++-
 arch/arm/boot/dts/ge863-pro3.dtsi               |    4 +
 ...mx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts |   73 +
 ...mx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts |   45 +
 ...imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts |   45 +
 .../dts/imx25-eukrea-mbimxsd25-baseboard.dts    |    1 -
 arch/arm/boot/dts/imx25-pdk.dts                 |    8 +-
 arch/arm/boot/dts/imx25.dtsi                    |    8 +-
 arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi    |  296 +++
 .../dts/imx27-eukrea-mbimxsd27-baseboard.dts    |  273 +++
 arch/arm/boot/dts/imx27-pdk.dts                 |    2 +-
 arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts  |    2 +-
 arch/arm/boot/dts/imx27-phytec-phycore-som.dtsi |    3 +-
 arch/arm/boot/dts/imx27.dtsi                    |  115 +-
 arch/arm/boot/dts/imx28-cfa10036.dts            |   22 +
 arch/arm/boot/dts/imx28-m28.dtsi                |   87 +
 arch/arm/boot/dts/imx28-m28evk.dts              |   62 +-
 .../dts/imx35-eukrea-mbimxsd35-baseboard.dts    |    1 -
 arch/arm/boot/dts/imx35.dtsi                    |    8 +
 arch/arm/boot/dts/imx50.dtsi                    |    8 +-
 arch/arm/boot/dts/imx51-babbage.dts             |    2 +-
 .../dts/imx51-eukrea-mbimxsd51-baseboard.dts    |    1 -
 arch/arm/boot/dts/imx51.dtsi                    |    3 -
 arch/arm/boot/dts/imx53-m53.dtsi                |  140 ++
 arch/arm/boot/dts/imx53-m53evk.dts              |  113 +-
 arch/arm/boot/dts/imx53-mba53.dts               |    1 -
 arch/arm/boot/dts/imx53-qsb-common.dtsi         |    1 -
 arch/arm/boot/dts/imx53-tx53.dtsi               |    1 -
 arch/arm/boot/dts/imx53-voipac-bsb.dts          |    1 -
 arch/arm/boot/dts/imx53.dtsi                    |   15 +-
 arch/arm/boot/dts/imx6dl-aristainetos_4.dts     |   85 +
 arch/arm/boot/dts/imx6dl-aristainetos_7.dts     |   74 +
 arch/arm/boot/dts/imx6dl-gw51xx.dts             |    2 +-
 arch/arm/boot/dts/imx6dl-gw52xx.dts             |    2 +-
 arch/arm/boot/dts/imx6dl-gw53xx.dts             |    2 +-
 arch/arm/boot/dts/imx6dl-gw54xx.dts             |    2 +-
 arch/arm/boot/dts/imx6dl-rex-basic.dts          |   30 +
 arch/arm/boot/dts/imx6dl-riotboard.dts          |   33 +-
 arch/arm/boot/dts/imx6dl-tx6dl-comtft.dts       |  103 +
 arch/arm/boot/dts/imx6dl-tx6u-801x.dts          |  177 ++
 arch/arm/boot/dts/imx6dl-tx6u-811x.dts          |  150 ++
 arch/arm/boot/dts/imx6dl-wandboard-revb1.dts    |   22 +
 arch/arm/boot/dts/imx6dl-wandboard.dts          |    2 +-
 arch/arm/boot/dts/imx6dl.dtsi                   |   17 +-
 arch/arm/boot/dts/imx6q-cubox-i.dts             |    4 +
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts         |   54 +
 arch/arm/boot/dts/imx6q-gw51xx.dts              |    2 +-
 arch/arm/boot/dts/imx6q-gw52xx.dts              |    2 +-
 arch/arm/boot/dts/imx6q-gw53xx.dts              |    2 +-
 arch/arm/boot/dts/imx6q-gw5400-a.dts            |    5 +-
 arch/arm/boot/dts/imx6q-gw54xx.dts              |    2 +-
 arch/arm/boot/dts/imx6q-rex-pro.dts             |   34 +
 arch/arm/boot/dts/imx6q-tx6q-1010-comtft.dts    |  103 +
 arch/arm/boot/dts/imx6q-tx6q-1010.dts           |  177 ++
 arch/arm/boot/dts/imx6q-tx6q-1020-comtft.dts    |  136 ++
 arch/arm/boot/dts/imx6q-tx6q-1020.dts           |  210 ++
 arch/arm/boot/dts/imx6q-tx6q-1110.dts           |  154 ++
 arch/arm/boot/dts/imx6q-udoo.dts                |   32 +
 arch/arm/boot/dts/imx6q-wandboard-revb1.dts     |   26 +
 arch/arm/boot/dts/imx6q-wandboard.dts           |    2 +-
 arch/arm/boot/dts/imx6q.dtsi                    |   35 +-
 arch/arm/boot/dts/imx6qdl-aristainetos.dtsi     |  418 ++++
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi           |    5 +-
 arch/arm/boot/dts/imx6qdl-gw53xx.dtsi           |    5 +-
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi           |    6 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi       |    1 -
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi    |    1 +
 arch/arm/boot/dts/imx6qdl-rex.dtsi              |  357 +++
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi        |    1 -
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi          |    2 +-
 arch/arm/boot/dts/imx6qdl-tx6.dtsi              |  696 ++++++
 arch/arm/boot/dts/imx6qdl-wandboard-revb1.dtsi  |   42 +
 arch/arm/boot/dts/imx6qdl-wandboard-revc1.dtsi  |   41 +
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi        |   22 -
 arch/arm/boot/dts/imx6qdl.dtsi                  |  161 +-
 arch/arm/boot/dts/imx6sl-evk.dts                |   17 +-
 arch/arm/boot/dts/imx6sl.dtsi                   |   12 +-
 arch/arm/boot/dts/imx6sx-pinfunc.h              | 1544 +++++++++++++
 arch/arm/boot/dts/imx6sx-sdb.dts                |  479 ++++
 arch/arm/boot/dts/imx6sx.dtsi                   | 1208 +++++++++++
 arch/arm/boot/dts/k2e-clocks.dtsi               |    2 +-
 arch/arm/boot/dts/k2hk-clocks.dtsi              |    2 +-
 arch/arm/boot/dts/k2hk-evm.dts                  |   12 +
 arch/arm/boot/dts/k2l-clocks.dtsi               |    2 +-
 arch/arm/boot/dts/keystone-clocks.dtsi          |    2 +-
 arch/arm/boot/dts/keystone.dtsi                 |   11 +
 arch/arm/boot/dts/kirkwood-d2net.dts            |   42 +
 arch/arm/boot/dts/kirkwood-net2big.dts          |   60 +
 arch/arm/boot/dts/kirkwood-net5big.dts          |  111 +
 arch/arm/boot/dts/kirkwood-netxbig.dtsi         |  154 ++
 arch/arm/boot/dts/kizbox.dts                    |    4 +
 arch/arm/boot/dts/mpa1600.dts                   |    8 +
 arch/arm/boot/dts/omap2420.dtsi                 |    3 +
 arch/arm/boot/dts/omap2430.dtsi                 |    3 +
 arch/arm/boot/dts/omap5-uevm.dts                |   68 +-
 arch/arm/boot/dts/pm9g45.dts                    |    8 +
 arch/arm/boot/dts/r7s72100-genmai.dts           |   10 +
 arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts |   14 +-
 arch/arm/boot/dts/r8a73a4.dtsi                  |   42 +
 .../dts/r8a7740-armadillo800eva-reference.dts   |   28 +-
 arch/arm/boot/dts/r8a7740.dtsi                  |   63 +
 arch/arm/boot/dts/r8a7778-bockw-reference.dts   |   14 +-
 arch/arm/boot/dts/r8a7778.dtsi                  |   42 +
 arch/arm/boot/dts/r8a7779.dtsi                  |   14 +-
 arch/arm/boot/dts/r8a7790-lager.dts             |   88 +-
 arch/arm/boot/dts/r8a7790.dtsi                  |  207 +-
 arch/arm/boot/dts/r8a7791-henninger.dts         |   45 +-
 arch/arm/boot/dts/r8a7791-koelsch.dts           |   89 +-
 arch/arm/boot/dts/r8a7791.dtsi                  |  218 +-
 arch/arm/boot/dts/rk3066a-bqcurie2.dts          |  214 +-
 arch/arm/boot/dts/rk3066a-clocks.dtsi           |  299 ---
 arch/arm/boot/dts/rk3066a.dtsi                  |  519 +++--
 arch/arm/boot/dts/rk3188-clocks.dtsi            |  289 ---
 arch/arm/boot/dts/rk3188-radxarock.dts          |  218 +-
 arch/arm/boot/dts/rk3188.dtsi                   |  446 ++--
 arch/arm/boot/dts/rk3288-evb-act8846.dts        |  134 ++
 arch/arm/boot/dts/rk3288-evb-rk808.dts          |   18 +
 arch/arm/boot/dts/rk3288-evb.dtsi               |   96 +
 arch/arm/boot/dts/rk3288.dtsi                   |  595 +++++
 arch/arm/boot/dts/rk3xxx.dtsi                   |  356 ++-
 arch/arm/boot/dts/sama5d3.dtsi                  |   22 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi               |   12 +-
 arch/arm/boot/dts/sama5d3xmb.dtsi               |    2 +
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts    |   16 +-
 arch/arm/boot/dts/sh73a0.dtsi                   |   72 +
 arch/arm/boot/dts/socfpga.dtsi                  |    1 +
 arch/arm/boot/dts/ste-dbx5x0.dtsi               |   10 +
 arch/arm/boot/dts/ste-href-stuib.dtsi           |    2 +
 arch/arm/boot/dts/ste-href-tvk1281618.dtsi      |   59 +
 arch/arm/boot/dts/ste-hrefv60plus.dtsi          |   24 -
 arch/arm/boot/dts/ste-snowball.dts              |   38 +-
 arch/arm/boot/dts/sun4i-a10-a1000.dts           |   15 +
 arch/arm/boot/dts/sun4i-a10-ba10-tvbox.dts      |  110 +
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts      |   15 +
 arch/arm/boot/dts/sun4i-a10-hackberry.dts       |   21 +
 arch/arm/boot/dts/sun4i-a10-inet97fv2.dts       |   21 +-
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts      |   28 +
 arch/arm/boot/dts/sun4i-a10-olinuxino-lime.dts  |   15 +
 arch/arm/boot/dts/sun4i-a10-pcduino.dts         |    9 +
 arch/arm/boot/dts/sun4i-a10.dtsi                |   34 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi               |    2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                |    2 +-
 arch/arm/boot/dts/sun6i-a31-hummingbird.dts     |  119 +
 arch/arm/boot/dts/sun6i-a31.dtsi                |   92 +-
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts     |   16 +
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts      |   16 +
 arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts       |   22 +
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts |   10 +
 arch/arm/boot/dts/sun7i-a20-pcduino3.dts        |  173 ++
 arch/arm/boot/dts/sun7i-a20.dtsi                |   34 +-
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts     |   30 +
 arch/arm/boot/dts/sun8i-a23.dtsi                |  343 +++
 arch/arm/boot/dts/tegra114-roth.dts             |   32 +-
 arch/arm/boot/dts/tegra124-jetson-tk1.dts       |   33 +-
 arch/arm/boot/dts/tegra124-venice2.dts          |  128 +-
 arch/arm/boot/dts/tegra124.dtsi                 |   40 +
 arch/arm/boot/dts/tegra20-medcom-wide.dts       |   61 +-
 arch/arm/boot/dts/tegra20-paz00.dts             |    6 +-
 arch/arm/boot/dts/tegra20-plutux.dts            |   41 +
 arch/arm/boot/dts/tegra20-tamonten.dtsi         |   10 +-
 arch/arm/boot/dts/tegra20-tec.dts               |   41 +
 arch/arm/boot/dts/tegra30-apalis-eval.dts       |  260 +++
 arch/arm/boot/dts/tegra30-apalis.dtsi           |  678 ++++++
 arch/arm/boot/dts/tny_a9260_common.dtsi         |    8 +
 arch/arm/boot/dts/tny_a9263.dts                 |    8 +
 arch/arm/boot/dts/usb_a9260_common.dtsi         |    8 +
 arch/arm/boot/dts/usb_a9263.dts                 |    8 +
 arch/arm/boot/dts/vf610.dtsi                    |   25 +-
 arch/arm/boot/dts/zynq-7000.dtsi                |   90 +-
 arch/arm/boot/dts/zynq-parallella.dts           |   64 +
 arch/arm/boot/dts/zynq-zc702.dts                |    4 +
 arch/arm/configs/omap2plus_defconfig            |    2 +
 arch/arm/mach-at91/Kconfig                      |    4 -
 arch/arm/mach-at91/at91rm9200.c                 |    6 +-
 arch/arm/mach-at91/at91sam9260.c                |    6 +-
 arch/arm/mach-at91/at91sam9263.c                |    6 +-
 arch/arm/mach-at91/at91sam9g45.c                |    6 +-
 arch/arm/mach-exynos/exynos.c                   |    2 +
 arch/arm/mach-omap2/Makefile                    |    6 +-
 arch/arm/mach-omap2/cclock2420_data.c           | 1931 -----------------
 arch/arm/mach-omap2/cclock2430_data.c           | 2048 ------------------
 arch/arm/mach-omap2/clkt2xxx_osc.c              |   69 -
 arch/arm/mach-omap2/clkt2xxx_sys.c              |   47 -
 arch/arm/mach-omap2/clock.c                     |   21 -
 arch/arm/mach-omap2/clock.h                     |    3 -
 arch/arm/mach-omap2/clock2xxx.h                 |    2 -
 arch/arm/mach-omap2/cm-regbits-24xx.h           |    1 +
 arch/arm/mach-omap2/io.c                        |    7 +-
 arch/arm/mach-omap2/pm24xx.c                    |    4 +
 arch/arm/mach-omap2/prm_common.c                |    2 +
 arch/arm/mach-rockchip/Kconfig                  |    1 +
 arch/arm/mach-rockchip/rockchip.c               |    1 +
 arch/arm/mach-shmobile/clock-r8a73a4.c          |    1 +
 arch/arm/mach-shmobile/clock-r8a7740.c          |    3 +
 arch/arm/mach-shmobile/clock-r8a7778.c          |    2 +
 arch/arm/mach-shmobile/clock-sh73a0.c           |    1 +
 arch/arm/mach-shmobile/setup-r8a73a4.c          |   12 +-
 arch/arm/mach-shmobile/setup-r8a7740.c          |    8 +-
 arch/arm/mach-shmobile/setup-r8a7778.c          |   12 +-
 arch/arm/mach-shmobile/setup-sh73a0.c           |    8 +-
 drivers/pinctrl/Kconfig                         |    6 +
 drivers/pinctrl/Makefile                        |    1 +
 drivers/pinctrl/pinctrl-tegra-xusb.c            |  973 +++++++++
 include/dt-bindings/clock/r8a7790-clock.h       |   27 +
 include/dt-bindings/clock/r8a7791-clock.h       |   27 +
 .../dt-bindings/pinctrl/pinctrl-tegra-xusb.h    |    7 +
 297 files changed, 20682 insertions(+), 6825 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/adapteva.txt
 create mode 100644 Documentation/devicetree/bindings/arm/armada-380-mpcore-soc-ctrl.txt
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351-cpu-method
 create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,berlin-smp
 create mode 100644 Documentation/devicetree/bindings/arm/omap/prcm.txt
 create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
 create mode 100644 Documentation/devicetree/bindings/serial/cdns,uart.txt
 create mode 100644 arch/arm/boot/dts/am335x-pepper.dts
 create mode 100644 arch/arm/boot/dts/am437x-sk-evm.dts
 create mode 100644 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
 create mode 100644 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
 create mode 100644 arch/arm/boot/dts/bcm7445.dtsi
 create mode 100644 arch/arm/boot/dts/cros-ec-keyboard.dtsi
 create mode 100644 arch/arm/boot/dts/dove-cubox-es.dts
 create mode 100644 arch/arm/boot/dts/exynos4412-odroid-common.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4412-odroidu3.dts
 create mode 100644 arch/arm/boot/dts/exynos4412-odroidx2.dts
 create mode 100644 arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts
 create mode 100644 arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts
 create mode 100644 arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts
 create mode 100644 arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
 create mode 100644 arch/arm/boot/dts/imx27-eukrea-mbimxsd27-baseboard.dts
 create mode 100644 arch/arm/boot/dts/imx28-m28.dtsi
 create mode 100644 arch/arm/boot/dts/imx53-m53.dtsi
 create mode 100644 arch/arm/boot/dts/imx6dl-aristainetos_4.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-aristainetos_7.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-rex-basic.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-tx6dl-comtft.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-tx6u-801x.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-tx6u-811x.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-wandboard-revb1.dts
 create mode 100644 arch/arm/boot/dts/imx6q-rex-pro.dts
 create mode 100644 arch/arm/boot/dts/imx6q-tx6q-1010-comtft.dts
 create mode 100644 arch/arm/boot/dts/imx6q-tx6q-1010.dts
 create mode 100644 arch/arm/boot/dts/imx6q-tx6q-1020-comtft.dts
 create mode 100644 arch/arm/boot/dts/imx6q-tx6q-1020.dts
 create mode 100644 arch/arm/boot/dts/imx6q-tx6q-1110.dts
 create mode 100644 arch/arm/boot/dts/imx6q-wandboard-revb1.dts
 create mode 100644 arch/arm/boot/dts/imx6qdl-aristainetos.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-rex.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-tx6.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-wandboard-revb1.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-wandboard-revc1.dtsi
 create mode 100644 arch/arm/boot/dts/imx6sx-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx6sx-sdb.dts
 create mode 100644 arch/arm/boot/dts/imx6sx.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-d2net.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-net2big.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-net5big.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-netxbig.dtsi
 delete mode 100644 arch/arm/boot/dts/rk3066a-clocks.dtsi
 delete mode 100644 arch/arm/boot/dts/rk3188-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/rk3288-evb-act8846.dts
 create mode 100644 arch/arm/boot/dts/rk3288-evb-rk808.dts
 create mode 100644 arch/arm/boot/dts/rk3288-evb.dtsi
 create mode 100644 arch/arm/boot/dts/rk3288.dtsi
 create mode 100644 arch/arm/boot/dts/sun4i-a10-ba10-tvbox.dts
 create mode 100644 arch/arm/boot/dts/sun6i-a31-hummingbird.dts
 create mode 100644 arch/arm/boot/dts/sun7i-a20-pcduino3.dts
 create mode 100644 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
 create mode 100644 arch/arm/boot/dts/sun8i-a23.dtsi
 create mode 100644 arch/arm/boot/dts/tegra30-apalis-eval.dts
 create mode 100644 arch/arm/boot/dts/tegra30-apalis.dtsi
 create mode 100644 arch/arm/boot/dts/zynq-parallella.dts
 delete mode 100644 arch/arm/mach-omap2/cclock2420_data.c
 delete mode 100644 arch/arm/mach-omap2/cclock2430_data.c
 delete mode 100644 arch/arm/mach-omap2/clkt2xxx_osc.c
 delete mode 100644 arch/arm/mach-omap2/clkt2xxx_sys.c
 create mode 100644 drivers/pinctrl/pinctrl-tegra-xusb.c
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h
