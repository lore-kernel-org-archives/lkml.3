Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaDYLsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:48:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63464 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDYLsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:48:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: ARM: SoC fixes for 3.15-rc3
Date: Fri, 25 Apr 2014 13:47:30 +0200
Message-ID: <4155031.RfcDyB9VSV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:fRIpKcAu4QFk+Tl3Wlu55VJWyiH2KG9oSqEb3ARAnt9
 24Edmlgg3xYTfEp54Mtuv5uFVan4hcbuWWeipNjOaKHV93ZpGE
 mIUaWbsq9cVumo5jNz6VDCOqiYlLtyF8el1Tsb7/K5GpQQgE5K
 3WW7CXtwUc/Fb+2fB1OZe/yzHtHaNsghLFADC2UfXtEviGAD1t
 Bc0djeVvTXnUJCHHPuzJ7c65m00ZR2tQAK/5n7z8zURcEbSydC
 I5YidLcXql03l1wKWOuBFLOiTH0rzxWI9eRffDHNRWtMmzrn2d
 PBNp2/X9lpPlKX12ySiYQN34WiTaXIvG7VjJhRh7rbhXsc//e2
 5LGAm6DadGz9oS6lVBqc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-3.15-rc3

for you to fetch changes up to 76e7745e8e4330fdb30f049303d524261c0b7a2c:

  Merge tag 'zynq-dt-fixes-for-3.15' of git://git.xilinx.com/linux-xlnx into fixes (2014-04-25 11:22:20 +0200)

----------------------------------------------------------------

ARM: SoC fixes for 3.15-rc3:

Since we didn't get around to collect fixes in time for -rc2 over
the easter vacation, this one is unfortunately a bit larger than
we'd like for an -rc3 merge. A large set of the changes is in the
device tree sources, so I'm splitting out the description between
code changes and DT changes. Aside from omap and versatile express,
the actual code bugs are sporadic and trivial. Here is an overview:

  imx:
   - fix video clock settings
   - fix one clock refcounting bug

  omap:
   - update defconfig for renamed USB PHY driver
   - fix error handling in gpmc
   - fix N900 video initialization regression
   - fix reression in hwmod code from missing braces
   - fix am43xx and omap3 clocks
   - remove bogus write to voltage control register

  pxa:
   - fix build regression from 3.13 header cleanup

  rockchip:
   - fix a misleading printk string

  shmobile:
   - fix incorrect sound setting on multiple machines

  spear:
   - remove incorrect __init section annotation

  tegra:
   - remove a stale Kconfig entry

  u300:
   - update defconfig

  ux500:
   - enable common wireless and sensor drivers in defconfig
   - more defconfig updates

  vexpress:
   - fix voltage calculation for opp
   - fix reboot hang and warning
   - fix out-of-bounds array access
   - improve error handling in clock driver

  overall:
   - always select CLKSRC_OF in multiplatform builds

And these are the devicetree related changes:

  imx:
   - add missing #clock-cell properties
   - fix pinctrl setting in imx6sl-evk
   - fix video endpoint on imx53
   - remove obsolete lvds-channel nodes (multiple patches)
   - add missing second stmpe node
   - fix usb host mode on dmo-edmqmx6 (multiple patches)
   - fix gic node #address-cells to match usage
   - add missing legacy IRQ map for PCIe
   - fix microsom pincontrol setting for rgmii
   - fix fatal typo in touchscreen DT usage for mx5
   - list all RAM present on m53evk and mx53qsb

  omap:
   - fix bug in DT handling of gpmc external bus
   - add DT for older revision of beagleboard
   - fix regression after DT node name fixes
   - remove obsolete properties for gpmc
   - fix pinmux comment to match DT it refers to
   - fix newly added dra7xx clock node data
   - add missing clock for USB PHY

  mvebu:
   - add missing clock for mdio node
   - fix nonstandard vendor prefixes on i2c nodes

  rockchip:
   - fix pin control setting for uart

  shmobile:
   - fix typo in DT data for pin control (multiple patches)
   - fix gic node #address-cells to match usage

  tegra:
   - fix clock and uart DT representation to match hardware

  zynq:
   - add DT nodes for newly added driver
   - add DT properties required for cpufreq-ondemand

  overall:
   - restore alphabetic order in Makefile
   - grammar fixes in bindings

----------------------------------------------------------------
Alex Elder (1):
      ARM: spear: add __init to spear_clocksource_init()

Andrea Adami (1):
      ARM: pxa: hx4700.h: include "irqs.h" for PXA_NR_BUILTIN_GPIO

Andrew Lunn (2):
      ARM: Kirkwood: Fix Atmel vendor prefix
      ARM: Kirkwood: DT: Add missing vendor prefix

Arnd Bergmann (9):
      Merge tag 'mvebu-dt-fixes-non-crit-3.15' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'imx-fixes-3.15' of git://git.kernel.org/.../shawnguo/linux into fixes
      Merge tag 'v3.15-rockchip-fixes1' of git://git.kernel.org/.../mmind/linux-rockchip into fixes
      Merge tag 'renesas-dt5-for-v3.15' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'renesas-fixes-for-v3.15' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'ux500-defconfig-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge tag 'omap-for-v3.15/fixes-v2-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'vexpress/fixes-for-3.15' of git://git.linaro.org/people/pawel.moll/linux into fixes
      Merge tag 'zynq-dt-fixes-for-3.15' of git://git.xilinx.com/linux-xlnx into fixes

Dan Carpenter (1):
      clk: vexpress: NULL dereference on error path

Domenico Andreoli (1):
      ARM: Tidy up DTB Makefile entries

Fabio Estevam (3):
      ARM: dts: imx53-qsb-common: Fix memory region description
      ARM: dts: imx53-m53evk: Fix memory region description
      ARM: dts: imx6sl-evk: Add an entry for MX6SL_PAD_ECSPI1_SS0__GPIO4_IO11

Geert Uytterhoeven (2):
      ARM: dts: Grammar /is uses/ is used/
      ARM: dts: Grammar /that will/it will/

Heiko Stuebner (1):
      ARM: rockchip: fix copy'n'paste error in smp error messages

Heinrich Schuchardt (1):
      arm/mach-vexpress: array accessed out of bounds

Johan Hovold (1):
      ARM: dts: OMAP2+: remove uses of obsolete gpmc,device-nand

Kishon Vijay Abraham I (1):
      ARM: OMAP2+: Fix config name for USB3 PHY

Kuninori Morimoto (2):
      ARM: shmobile: lager: fixup SND_SOC_DAIFMT_CBx_CFx flags
      ARM: shmobile: armadillo800eva: fixup SND_SOC_DAIFMT_CBx_CFx flags

Leigh Brown (1):
      ARM: dts: am335x: update USB DT references

Linus Walleij (3):
      ARM: ux500: update defconfig
      ARM: ux500: configure in sensors
      ARM: ux500: configure for CW1200 WLAN chip

Lothar Waﬂmann (1):
      ARM: dts: imx53: fix apparent copy/paste error

Lucas Stach (9):
      ARM: dts: imx6: add PCIe interrupt mapping properties
      ARM: dts: imx: drop invalid size and address cells properties
      ARM: imx6q-clk: parent lvds_gate from lvds_sel
      ARM: dts: imx6: edmqmx6: Fix usbotg id pin
      ARM: dts: imx6: edmqmx6: USB H1 only supports host mode
      ARM: dts: imx6: edmqmx6: add second STMPE
      ARM: dts: vybrid: drop address and size cells from GIC node
      ARM: shmobile: sh73a0: drop address cells from GIC node
      ARM: shmobile: r8a7740: drop address cells from GIC node

Magnus Damm (1):
      ARM: shmobile: koelsch: correct renesas,gpios to renesas,groups in sd[012] pfc

Max Schwarz (1):
      ARM: rockchip: rk3188: enable pull-ups on UART RX pins

Paul Bolle (1):
      ARM: tegra: remove TEGRA_EMC_SCALING_ENABLE

Pawel Moll (1):
      power/reset: vexpress: Fix restart/power off operation

Peter Ujfalusi (1):
      ARM: dts: dra7xx-clocks: Correct mcasp2_ahclkx_mux bit-shift

Philipp Zabel (1):
      ARM: i.MX6: ipu_di_sel clocks can set parent rates

Punit Agrawal (1):
      ARM: vexpress/TC2: Convert OPP voltage to uV before storing

Rob Herring (1):
      ARM: fix missing CLKSRC_OF on multi-platform

Rob Taylor (1):
      ARM: shmobile: lager: correct renesas,gpios to renesas,groups in sd[02] pfc

Robert Nelson (1):
      ARM: dts: Add support for the BeagleBoard xM A/B

Roger Quadros (2):
      ARM: OMAP3: hwmod data: Correct clock domains for USB modules
      ARM: dts: omap5: Add clocks to USB3 PHY node

Russell King (1):
      ARM: dt: microsom: don't set bit 7 for ethernet mux settings

Sascha Hauer (2):
      ARM: dts: imx6: edmqmx6: Do not use the OTG switch as VBUS regulator
      ARM: imx6q: clk: Parent DI clocks to video PLL via di_pre_sel

Sebastian Reichel (1):
      ARM: OMAP2+: N900: remove omapdss init for DT boot

Shawn Guo (3):
      ARM: dts: imx53-tx53: add IPU DI ports and endpoints
      ARM: dts: imx6q-gw5xxx: remove dead 'crtcs' property
      ARM: dts: imx: add required #clock-cells for fixed-clock

Soren Brinkmann (2):
      ARM: zynq: DT: Add 'clock-latency' property
      ARM: zynq: dt: Add I2C nodes to Zynq device tree

Stefan Agner (1):
      ARM: dts: mx5: fix wrong stmpe-ts bindings

Stephen Warren (3):
      ARM: tegra: remove UART5/UARTE from tegra124.dtsi
      clk: tegra: remove non-existent clocks
      dt: tegra: remove non-existent clock IDs

Suman Anna (1):
      ARM: OMAP2+: hwmod: fix missing braces in _init()

Tero Kristo (1):
      ARM: OMAP3: PM: remove access to PRM_VOLTCTRL register

Thomas Petazzoni (2):
      ARM: mvebu: ensure the mdio node has a clock reference on Armada 370/XP
      ARM: mvebu: ensure the mdio node has a clock reference on Armada 38x

Tomi Valkeinen (1):
      ARM: AM43xx: fix dpll init in bypass mode

Tony Lindgren (4):
      Merge branch 'fixes-v3.15-rc1'; commit '390403fd79821bbd0c3a0d83307df2be87047b36' into omap-for-v3.15/fixes
      Merge tag 'for-v3.15-rc/omap-fixes-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.15/fixes
      ARM: OMAP2+: Fix oops for GPMC free
      ARM: OMAP2+: Fix GPMC remap for devices using an offset

Ulf Hansson (2):
      ARM: ux500: u8500_defconfig: Enable PARTITION_ADVANCED
      ARM: u300: u300_defconfig: Enable PARTITION_ADVANCED

Wolfram Sang (1):
      ARM: AM335X: EVM: fix pinmux documentation in devicetree

 arch/arm/Kconfig                               |  1 +
 arch/arm/boot/dts/Makefile                     | 20 +++----
 arch/arm/boot/dts/am335x-bone-common.dtsi      |  4 +-
 arch/arm/boot/dts/am335x-evm.dts               |  8 +--
 arch/arm/boot/dts/am335x-evmsk.dts             |  4 +-
 arch/arm/boot/dts/am335x-igep0033.dtsi         |  5 +-
 arch/arm/boot/dts/am33xx.dtsi                  |  6 +-
 arch/arm/boot/dts/armada-370-xp.dtsi           |  1 +
 arch/arm/boot/dts/armada-38x.dtsi              |  1 +
 arch/arm/boot/dts/dra7.dtsi                    |  4 +-
 arch/arm/boot/dts/dra7xx-clocks.dtsi           |  2 +-
 arch/arm/boot/dts/imx25.dtsi                   |  1 +
 arch/arm/boot/dts/imx27-apf27.dts              |  1 +
 arch/arm/boot/dts/imx27.dtsi                   |  1 +
 arch/arm/boot/dts/imx50.dtsi                   |  4 ++
 arch/arm/boot/dts/imx51.dtsi                   |  4 ++
 arch/arm/boot/dts/imx53-m53evk.dts             | 23 ++++----
 arch/arm/boot/dts/imx53-qsb-common.dtsi        |  3 +-
 arch/arm/boot/dts/imx53-tx53-x03x.dts          | 11 +++-
 arch/arm/boot/dts/imx53.dtsi                   |  6 +-
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts        | 48 +++++++++++-----
 arch/arm/boot/dts/imx6q-gw5400-a.dts           |  3 -
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi          |  3 -
 arch/arm/boot/dts/imx6qdl-microsom-ar8035.dtsi | 22 ++++----
 arch/arm/boot/dts/imx6qdl.dtsi                 | 13 ++++-
 arch/arm/boot/dts/imx6sl-evk.dts               |  1 +
 arch/arm/boot/dts/imx6sl.dtsi                  |  4 +-
 arch/arm/boot/dts/kirkwood-b3.dts              |  2 +-
 arch/arm/boot/dts/kirkwood-cloudbox.dts        |  2 +-
 arch/arm/boot/dts/kirkwood-dreamplug.dts       |  2 +-
 arch/arm/boot/dts/kirkwood-laplug.dts          |  2 +-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts |  2 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi     |  4 +-
 arch/arm/boot/dts/kirkwood-nsa310.dts          |  2 +-
 arch/arm/boot/dts/kirkwood-nsa310a.dts         |  2 +-
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts   |  2 +-
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts   |  2 +-
 arch/arm/boot/dts/omap3-beagle-xm-ab.dts       | 16 ++++++
 arch/arm/boot/dts/omap3-devkit8000.dts         |  1 -
 arch/arm/boot/dts/omap3-lilly-a83x.dtsi        |  1 -
 arch/arm/boot/dts/omap3.dtsi                   |  2 +-
 arch/arm/boot/dts/omap4.dtsi                   |  4 +-
 arch/arm/boot/dts/omap5.dtsi                   | 10 +++-
 arch/arm/boot/dts/r8a7740.dtsi                 |  1 -
 arch/arm/boot/dts/r8a7790-lager.dts            |  4 +-
 arch/arm/boot/dts/r8a7791-koelsch.dts          |  6 +-
 arch/arm/boot/dts/rk3188.dtsi                  |  8 +--
 arch/arm/boot/dts/sh73a0.dtsi                  |  1 -
 arch/arm/boot/dts/tegra124.dtsi                | 13 -----
 arch/arm/boot/dts/vf610-twr.dts                |  2 +
 arch/arm/boot/dts/vf610.dtsi                   |  4 +-
 arch/arm/boot/dts/zynq-7000.dtsi               | 23 ++++++++
 arch/arm/boot/dts/zynq-zc702.dts               | 76 ++++++++++++++++++++++++++
 arch/arm/boot/dts/zynq-zc706.dts               | 68 +++++++++++++++++++++++
 arch/arm/configs/omap2plus_defconfig           |  2 +-
 arch/arm/configs/u300_defconfig                |  4 +-
 arch/arm/configs/u8500_defconfig               | 24 +++++---
 arch/arm/mach-imx/clk-imx6q.c                  | 29 ++++++----
 arch/arm/mach-omap2/board-rx51-video.c         |  2 +-
 arch/arm/mach-omap2/clkt_dpll.c                |  4 +-
 arch/arm/mach-omap2/gpmc.c                     | 15 ++++-
 arch/arm/mach-omap2/omap_hwmod.c               |  3 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c     |  4 +-
 arch/arm/mach-omap2/pm34xx.c                   |  4 --
 arch/arm/mach-pxa/include/mach/hx4700.h        |  1 +
 arch/arm/mach-rockchip/platsmp.c               |  2 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c |  1 +
 arch/arm/mach-shmobile/board-lager.c           |  4 +-
 arch/arm/mach-spear/time.c                     |  2 +-
 arch/arm/mach-tegra/Kconfig                    |  3 -
 arch/arm/mach-vexpress/dcscb.c                 |  7 ++-
 arch/arm/mach-vexpress/spc.c                   |  4 +-
 drivers/clk/tegra/clk-tegra124.c               |  3 -
 drivers/clk/versatile/clk-vexpress-osc.c       |  2 +-
 drivers/power/reset/vexpress-poweroff.c        | 19 ++++---
 include/dt-bindings/clock/tegra124-car.h       |  6 +-
 76 files changed, 430 insertions(+), 181 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap3-beagle-xm-ab.dts

