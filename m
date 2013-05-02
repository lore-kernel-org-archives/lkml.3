Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3EBHGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:06:11 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39192 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3EBHFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:05:09 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 3/5] ARM: arm-soc device-tree updates for 3.10, part 1
Date: Wed,  1 May 2013 23:58:34 -0700
Message-Id: <1367477916-28399-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1367477916-28399-1-git-send-email-olof@lixom.net>
References: <1367477916-28399-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device-tree updates for 3.10. The bulk of the churn in this branch is due
to i.MX moving from C-defined pin control over to device tree, which is
a one-time conversion that will allow greater flexibility down the road.

Besides that, there's PCI-e bindings for Marvell mvebu platforms and a
handful of cleanups to tegra due to the new include file functionality
of the device tree compiler.


Conflicts:

arch/arm/boot/dts/at91sam9x5.dtsi: Two add/add conflicts. Keep both
sides on both, make sure that the upper entries have balanced close
braces. Also, on the last conflict, make sure spi1 has a 'status =
"disabled"' property.

drivers/pinctrl/Makefile: Add/remove. Keep imx6dl, remove pxa3xx.

----------------------------------------------------------------

The following changes since commit 22d9b30cebe1bc2a78f5a2db583f94f3300b97d6:

  Merge branch 'next/cleanup' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-linus

for you to fetch changes up to 88cf9c5e494795a53ec360d0b38f483a6d4e508f:

  Merge tag 'sunxi-dt-for-3.10-4' of git://github.com/mripard/linux into next/dt

----------------------------------------------------------------

Alexander Clouter (2):
      arm: orion5x: add ehci bindings to dtsi
      arm: orion5x: enable xor for orion5x platform

Alexander Shiyan (2):
      ARM: dts: Add NFC support for i.MX27 Phytec PCM038 module
      ARM: dts: Add missing imx27-phytec-phycore dtb target

Andrew Lunn (1):
      Dove: Thermal: Add DT node and enable in defconfig

Arnd Bergmann (8):
      Merge tag 'mvebu_dt_for_v3.10' of git://git.infradead.org/users/jcooper/linux into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'sunxi-dt-for-3.10' of git://github.com/mripard/linux into next/dt
      Merge branch 'zynq/core' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'bcm2835-for-3.10-dt' of git://git.kernel.org/.../swarren/linux-rpi into next/dt
      Merge tag 'sunxi-dt-for-3.10-2' of git://github.com/mripard/linux into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'tegra-for-3.10-fixes-for-mmc' of git://git.kernel.org/.../swarren/linux-tegra into next/dt

Dirk Behme (1):
      ARM: dts: imx6q: add PMU

Douglas Gilbert (2):
      ARM: at91: add Acme Systems Aria G25 board
      ARM: at91/at91sam9260.dtsi: fix u(s)art pinctrl encoding

Emilio López (8):
      sunxi: a10-cubieboard: Add user LEDs to the device tree
      arm: sunxi: Add clock definitions for the new clock driver
      arm: sunxi: rename clock compatible strings
      ARM: sunxi: cubieboard: Add UART muxing
      arm: sunxi: Add clock definitions for AXI, AHB, APB0, APB1 gates
      arm: sunxi: use the right clock phandles for UARTs
      arm: sunxi: Add clock to pinctrl node
      ARM: sunxi: unify osc24M_fixed and osc24M

Ezequiel Garcia (8):
      ARM: mvebu: Add button on Armada 370 Reference Design board
      ARM: mvebu: Add thermal support to Armada XP device tree
      ARM: mvebu: Add thermal support to Armada 370 device tree
      ARM: configs: Update mvebu defconfig for thermal
      ARM: mvebu: Add Device Bus support for Armada 370/XP SoC
      ARM: mvebu: Add support for NOR flash device on Armada XP-GP board
      ARM: mvebu: Add support for NOR flash device on Openblocks AX3 board
      ARM: mvebu: Add Device Bus and CFI flash memory support to defconfig

Fabio Estevam (3):
      ARM: mx27: Replace clk_register_clkdev with clock DT lookup
      ARM: dts: Add initial support for Wandboard Dual-Lite
      ARM: dts: imx6dl-wandboard: Add USB Host support

Gregory CLEMENT (1):
      arm: mvebu: enable gpio expander over i2c on Mirabox platform

Gwenhael Goavec-Merou (5):
      ARM: imx: Add support for the Armadeus Systems APF51Dev docking board
      ARM: imx51: Add pinctrl for ecspi2
      ARM: imx51: Add a second pinctrl group for i2c2
      ARM: imx: apf51dev: add ecspi1, ecspi2 and i2c2 support
      ARM: imx: Add support for the Armadeus Systems APF27Dev docking board

Joachim Eastwood (3):
      ARM: at91: add TWI bindings to RM9200 DT
      ARM: at91: add pinctrl nodes to i2c-gpio on RM92000 DT
      ARM: at91: add MPA 1600 DT board

Lior Amsalem (1):
      ARM: dts: Add a 64 bits version of the skeleton device tree

Lubomir Rintel (1):
      ARM: bcm2835: add Broadcom BCM2835 RNG to the device tree

Ludovic Desroches (1):
      ARM: at91: dts: add adc resolution stuff

Marek Vasut (1):
      ARM: dts: imx53: fix SD2_DATA1 pad AUDMUX_AUD4 configuration

Markus Pargmann (3):
      ARM: imx27 DT init cpufreq-cpu0 device
      ARM: imx5 DT init cpufreq-cpu0 device
      ARM: dts: imx51 cpu node

Maxime Ripard (13):
      sunxi: dts: Report the pinctrl nodes as gpio-controllers
      sunxi: a13-olinuxino: Add user LED to the device tree
      ARM: sunxi: dt: Add support for the PineRiver Mini X-plus
      ARM: sunxi: dt: Use clocks property instead of clock-frequency for the UARTs
      ARM: sunxi: Rename uart nodes to serial
      ARM: sunxi: dt: Move uart0 to sun4i-a10.dtsi
      ARM: sunxi: dt: Add uart3 dt node
      ARM: sunxi: dt: Add A10 UARTs to the dtsi.
      ARM: sunxi: hackberry: Add UART muxing
      ARM: sunxi: dt: Reorganize the dtsi
      ARM: sunxi: dt: Update timer compatible string
      ARM: sunxi: dt: Update interrupt controller compatible string
      ARM: sunxi: dt: Update watchdog compatible string

Michal Simek (1):
      arm: zynq: Add support for pmu

Nicolas Ferre (6):
      ARM: at91/dt: gpio-keys: remove address-cells and size-cells properties
      ARM: at91/at91sam9x5: add RTC node
      ARM: at91/trivial: typos in compatible property
      ARM: at91/trivial: fix model name for SAM9G15-EK
      ARM: at91: remove partial parameter in bootargs for at91sam9x5ek.dtsi
      ARM: at91/dt: fix macb node declaration

Nobuhiro Iwamatsu (1):
      ARM: Kirkwood: Add support thermal sensor for 88F6282 and 88F6283

Olof Johansson (4):
      Merge tag 'sunxi-dt-for-3.10-3' of git://github.com/mripard/linux into next/dt
      Merge tag 'dt-3.10-3' of git://git.infradead.org/users/jcooper/linux into next/dt
      Merge tag 'imx-dt-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'sunxi-dt-for-3.10-4' of git://github.com/mripard/linux into next/dt

Pavel Machek (1):
      ARM: dts: MicroSys sbc6x support (i.MX6)

Peter Chen (1):
      ARM: dts: imx6q-sabresd: Add USB support

Philipp Zabel (6):
      ARM i.MX5: Move IPU clock lookups into device tree
      ARM i.MX53: Add IOMUXC GPR to device tree
      ARM i.MX53: Add LDB device to device tree
      ARM i.MX6q: Link system reset controller (SRC) to IPU in DT
      ARM i.MX5: Add system reset controller (SRC) to i.MX51 and i.MX53 device tree
      ARM i.MX5: Add System Reset Controller (SRC) support for i.MX51 and i.MX53

Richard Genoud (4):
      ARM: at91: dt: at91sam9x5: add i2c pinctrl
      ARM: at91: dt: at91sam9x5: add i2c-gpio pinctrl
      ARM: at91/at91sam9x5ek: i2c1 and i2c2 conflict with macb and lcd
      ARM: at91/at91sam9x5cm: add 1-wire chip on CM board

Ryan Press (1):
      arm: mvebu: Add GPIO LEDs to Mirabox board

Sascha Hauer (8):
      ARM: i.MX: Add GPT devicetree Documentation
      ARM: i.MX27: Add GPT devicetree nodes
      ARM: i.MX31: Add GPT devicetree node
      ARM: i.MX51: Add GPT devicetree node
      ARM: i.MX53: Add GPT devicetree node
      ARM: i.MX6: Add clocks to GPT devicetree node
      ARM: i.MX27: Add clocks to GPT devicetree nodes
      ARM: i.MX51: Add PATA support

Sean Cross (3):
      ARM: dts: imx6q: Add pinctrl for ecspi3
      ARM: dts: imx6q: Add pinctrl for i2c2 and i2c3
      ARM: dts: imx6q: Add pinctrl for audmix on AUD3

Sebastian Hesselbarth (1):
      ARM: kirkwood: make use of DT mvsdio on guruplug board

Shawn Guo (9):
      Merge tag 'imx-cleanup-3.10' into imx/dt
      Merge remote-tracking branch 'swarren/for-3.10/dtc-cpp-chroot-std-headers' into imx/dt
      ARM: imx: use #include for all device trees
      pinctrl: imx: move hard-coding data into device tree
      pinctrl: add pinctrl driver for imx6dl
      pinctrl: add pinctrl driver for imx6sl
      ARM: dts: imx: make sabreauto and sabresd common
      ARM: dts: imx: add initial imx6dl-sabresd support
      ARM: dts: imx: add initial imx6dl-sabreauto support

Steffen Trumtrar (1):
      ARM i.MX6q: Add LDB device to device tree

Stephen Warren (8):
      ARM: bcm2835: add SPI device to DT
      kbuild: create an "include chroot" for DT bindings
      kbuild: fixdep: support concatenated dep files
      kbuild: cmd_dtc_cpp: extract deps from both gcc -E and dtc
      kbuild: always run gcc -E on *.dts, remove cmd_dtc_cpp
      ARM: dt: add header to define GPIO flags
      ARM: dt: add header to define IRQ flags
      ARM: dt: create a DT header for the GIC

Thomas Petazzoni (7):
      arm: mvebu: add PCIe Device Tree informations for Armada 370
      arm: mvebu: add PCIe Device Tree informations for Armada XP
      arm: mvebu: PCIe Device Tree informations for OpenBlocks AX3-4
      arm: mvebu: PCIe Device Tree informations for Armada XP DB
      arm: mvebu: PCIe Device Tree informations for Armada 370 Mirabox
      arm: mvebu: PCIe Device Tree informations for Armada 370 DB
      arm: mvebu: PCIe Device Tree informations for Armada XP GP

Tony Prisk (1):
      arm: vt8500: Add SDHC support to WM8505 DT


 .../devicetree/bindings/clock/imx27-clock.txt   |  117 +
 .../bindings/pinctrl/fsl,imx-pinctrl.txt        |    6 +-
 .../bindings/pinctrl/fsl,imx35-pinctrl.txt      |  955 +-------
 .../bindings/pinctrl/fsl,imx51-pinctrl.txt      |  759 +-----
 .../bindings/pinctrl/fsl,imx53-pinctrl.txt      | 1174 +--------
 .../bindings/pinctrl/fsl,imx6dl-pinctrl.txt     |   38 +
 .../bindings/pinctrl/fsl,imx6q-pinctrl.txt      | 1596 +-----------
 .../bindings/pinctrl/fsl,imx6sl-pinctrl.txt     |   39 +
 .../devicetree/bindings/timer/fsl,imxgpt.txt    |   18 +
 arch/arm/boot/dts/Makefile                      |   11 +-
 arch/arm/boot/dts/armada-370-db.dts             |   17 +
 arch/arm/boot/dts/armada-370-mirabox.dts        |   64 +
 arch/arm/boot/dts/armada-370-rd.dts             |   11 +
 arch/arm/boot/dts/armada-370-xp.dtsi            |   45 +
 arch/arm/boot/dts/armada-370.dtsi               |   58 +
 arch/arm/boot/dts/armada-xp-db.dts              |   33 +
 arch/arm/boot/dts/armada-xp-gp.dts              |   50 +
 arch/arm/boot/dts/armada-xp-mv78230.dtsi        |  104 +
 arch/arm/boot/dts/armada-xp-mv78260.dtsi        |  122 +
 arch/arm/boot/dts/armada-xp-mv78460.dtsi        |  188 ++
 .../arm/boot/dts/armada-xp-openblocks-ax3-4.dts |   38 +
 arch/arm/boot/dts/armada-xp.dtsi                |    6 +
 arch/arm/boot/dts/at91-ariag25.dts              |  171 ++
 arch/arm/boot/dts/at91rm9200.dtsi               |   28 +
 arch/arm/boot/dts/at91sam9260.dtsi              |   19 +-
 arch/arm/boot/dts/at91sam9263ek.dts             |    2 -
 arch/arm/boot/dts/at91sam9g15.dtsi              |    2 +-
 arch/arm/boot/dts/at91sam9g15ek.dts             |    2 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi     |    2 -
 arch/arm/boot/dts/at91sam9g25.dtsi              |    2 +-
 arch/arm/boot/dts/at91sam9g25ek.dts             |    9 +
 arch/arm/boot/dts/at91sam9g35.dtsi              |    2 +-
 arch/arm/boot/dts/at91sam9g35ek.dts             |    9 +
 arch/arm/boot/dts/at91sam9g45.dtsi              |    3 +
 arch/arm/boot/dts/at91sam9m10g45ek.dts          |    2 -
 arch/arm/boot/dts/at91sam9n12ek.dts             |    2 -
 arch/arm/boot/dts/at91sam9x25.dtsi              |    2 +-
 arch/arm/boot/dts/at91sam9x25ek.dts             |   14 +
 arch/arm/boot/dts/at91sam9x35.dtsi              |    2 +-
 arch/arm/boot/dts/at91sam9x35ek.dts             |    9 +
 arch/arm/boot/dts/at91sam9x5.dtsi               |   70 +
 arch/arm/boot/dts/at91sam9x5cm.dtsi             |   20 +
 arch/arm/boot/dts/at91sam9x5ek.dtsi             |   15 +-
 arch/arm/boot/dts/bcm2835.dtsi                  |   22 +
 arch/arm/boot/dts/dove.dtsi                     |    5 +
 arch/arm/boot/dts/imx25-karo-tx25.dts           |    2 +-
 arch/arm/boot/dts/imx25-pdk.dts                 |    2 +-
 arch/arm/boot/dts/imx25.dtsi                    |    2 +-
 arch/arm/boot/dts/imx27-apf27.dts               |    2 +-
 arch/arm/boot/dts/imx27-apf27dev.dts            |   60 +
 arch/arm/boot/dts/imx27-pdk.dts                 |    2 +-
 arch/arm/boot/dts/imx27-phytec-phycore.dts      |    8 +-
 arch/arm/boot/dts/imx27.dtsi                    |   82 +-
 arch/arm/boot/dts/imx31-bug.dts                 |    2 +-
 arch/arm/boot/dts/imx31.dtsi                    |   18 +-
 arch/arm/boot/dts/imx35-pinfunc.h               |  970 ++++++++
 arch/arm/boot/dts/imx51-apf51.dts               |    2 +-
 arch/arm/boot/dts/imx51-apf51dev.dts            |   97 +
 arch/arm/boot/dts/imx51-babbage.dts             |   16 +-
 arch/arm/boot/dts/imx51-pinfunc.h               |  773 ++++++
 arch/arm/boot/dts/imx51.dtsi                    |  343 ++-
 arch/arm/boot/dts/imx53-ard.dts                 |   70 +-
 arch/arm/boot/dts/imx53-evk.dts                 |   18 +-
 arch/arm/boot/dts/imx53-mba53.dts               |   82 +-
 arch/arm/boot/dts/imx53-pinfunc.h               | 1189 +++++++++
 arch/arm/boot/dts/imx53-qsb.dts                 |   22 +-
 arch/arm/boot/dts/imx53-smd.dts                 |   16 +-
 arch/arm/boot/dts/imx53-tqma53.dtsi             |   32 +-
 arch/arm/boot/dts/imx53.dtsi                    |  256 +-
 arch/arm/boot/dts/imx6dl-pinfunc.h              | 1085 +++++++++
 arch/arm/boot/dts/imx6dl-sabreauto.dts          |   31 +
 arch/arm/boot/dts/imx6dl-sabresd.dts            |   35 +
 arch/arm/boot/dts/imx6dl-wandboard.dts          |   44 +
 arch/arm/boot/dts/imx6dl.dtsi                   |  125 +-
 arch/arm/boot/dts/imx6q-arm2.dts                |    8 +-
 arch/arm/boot/dts/imx6q-pinfunc.h               | 1041 ++++++++
 arch/arm/boot/dts/imx6q-sabreauto.dts           |   33 +-
 arch/arm/boot/dts/imx6q-sabrelite.dts           |   18 +-
 arch/arm/boot/dts/imx6q-sabresd.dts             |   67 +-
 arch/arm/boot/dts/imx6q-sbc6x.dts               |   44 +
 arch/arm/boot/dts/imx6q.dtsi                    |  280 ++-
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi        |   38 +
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi          |   87 +
 arch/arm/boot/dts/imx6qdl.dtsi                  |   33 +-
 arch/arm/boot/dts/imx6sl-pinfunc.h              | 1077 ++++++++
 arch/arm/boot/dts/include/dt-bindings           |    1 +
 arch/arm/boot/dts/kirkwood-6282.dtsi            |    6 +
 .../boot/dts/kirkwood-guruplug-server-plus.dts  |    4 +
 arch/arm/boot/dts/mpa1600.dts                   |   69 +
 arch/arm/boot/dts/orion5x.dtsi                  |   33 +
 arch/arm/boot/dts/skeleton64.dtsi               |   13 +
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts      |   32 +-
 arch/arm/boot/dts/sun4i-a10-hackberry.dts       |    6 +-
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts      |   32 +
 arch/arm/boot/dts/sun4i-a10.dtsi                |  253 +-
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts       |   24 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                |  193 +-
 arch/arm/boot/dts/sunxi.dtsi                    |   82 -
 arch/arm/boot/dts/wm8505.dtsi                   |   31 +
 arch/arm/boot/dts/zynq-7000.dtsi                |    7 +
 arch/arm/configs/dove_defconfig                 |    2 +
 arch/arm/configs/kirkwood_defconfig             |    2 +
 arch/arm/configs/mvebu_defconfig                |    9 +
 arch/arm/mach-at91/at91rm9200.c                 |    1 +
 arch/arm/mach-imx/Kconfig                       |    2 +
 arch/arm/mach-imx/clk-imx27.c                   |   11 +-
 arch/arm/mach-imx/clk-imx51-imx53.c             |    9 +-
 arch/arm/mach-imx/imx27-dt.c                    |   22 +-
 arch/arm/mach-imx/imx51-dt.c                    |    3 +
 arch/arm/mach-imx/mm-imx5.c                     |    2 +
 arch/arm/mach-imx/src.c                         |    4 +-
 arch/arm/mach-kirkwood/board-guruplug.c         |    6 -
 drivers/pinctrl/Kconfig                         |   12 +-
 drivers/pinctrl/Makefile                        |    1 +
 drivers/pinctrl/pinctrl-imx.c                   |  126 +-
 drivers/pinctrl/pinctrl-imx.h                   |   29 +-
 drivers/pinctrl/pinctrl-imx35.c                 | 2088 ++++++----------
 drivers/pinctrl/pinctrl-imx51.c                 | 1532 ++++--------
 drivers/pinctrl/pinctrl-imx53.c                 | 1597 ++----------
 drivers/pinctrl/pinctrl-imx6dl.c                |  497 ++++
 drivers/pinctrl/pinctrl-imx6q.c                 | 2301 ++----------------
 drivers/pinctrl/pinctrl-imx6sl.c                |  403 +++
 include/dt-bindings/gpio/gpio.h                 |   15 +
 .../dt-bindings/interrupt-controller/arm-gic.h  |   22 +
 include/dt-bindings/interrupt-controller/irq.h  |   19 +
 scripts/Makefile.lib                            |   17 +-
 scripts/basic/fixdep.c                          |   93 +-
 127 files changed, 12434 insertions(+), 11152 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/imx27-clock.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx6dl-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx6sl-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/timer/fsl,imxgpt.txt
 create mode 100644 arch/arm/boot/dts/at91-ariag25.dts
 create mode 100644 arch/arm/boot/dts/imx27-apf27dev.dts
 create mode 100644 arch/arm/boot/dts/imx35-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx51-apf51dev.dts
 create mode 100644 arch/arm/boot/dts/imx51-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx53-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx6dl-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx6dl-sabreauto.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-sabresd.dts
 create mode 100644 arch/arm/boot/dts/imx6dl-wandboard.dts
 create mode 100644 arch/arm/boot/dts/imx6q-pinfunc.h
 create mode 100644 arch/arm/boot/dts/imx6q-sbc6x.dts
 create mode 100644 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl-sabresd.dtsi
 create mode 100644 arch/arm/boot/dts/imx6sl-pinfunc.h
 create mode 120000 arch/arm/boot/dts/include/dt-bindings
 create mode 100644 arch/arm/boot/dts/mpa1600.dts
 create mode 100644 arch/arm/boot/dts/skeleton64.dtsi
 create mode 100644 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts
 delete mode 100644 arch/arm/boot/dts/sunxi.dtsi
 create mode 100644 drivers/pinctrl/pinctrl-imx6dl.c
 create mode 100644 drivers/pinctrl/pinctrl-imx6sl.c
 create mode 100644 include/dt-bindings/gpio/gpio.h
 create mode 100644 include/dt-bindings/interrupt-controller/arm-gic.h
 create mode 100644 include/dt-bindings/interrupt-controller/irq.h
