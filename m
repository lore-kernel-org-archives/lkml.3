Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaAWSsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:48:38 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41184 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaAWSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:47:23 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 5/6] ARM: SoC board updates for 3.14
Date: Thu, 23 Jan 2014 10:36:27 -0800
Message-Id: <1390502188-16896-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1390502188-16896-1-git-send-email-olof@lixom.net>
References: <1390502188-16896-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch is reducing in size for every release since most board-related
changes have started happening in devicetrees now. Still, we have some things
going on here.

* Renesas platforms are still adding a bit more legacy device support, something
that should trail off shortly as they move to full DT.
* We group most defconfig updates into this branch out of old habits
* Removal of legacy OMAP2 platforms over to DT continues, and a handful of old
code is being removed here.

Conflicts:

arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c:                             

Bugfix in later -rc conflicts with code removal. Remove both irqs[]
arrays.

----------------------------------------------------------------

The following changes since commit aef07284ff26becdff4ac000f05ab020a5cfe29c:

  Merge branch 'next/dt' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards-for-linus

for you to fetch changes up to e41006c22eab8eb7763995e8a0be089b900b620b:

  Merge tag 'omap-for-v3.14/dt-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into next/boards

----------------------------------------------------------------

Aaro Koskinen (1):
      ARM: OMAP2+: dts: add n8x0 onenand

Bartlomiej Zolnierkiewicz (1):
      ARM: exynos_defconfig: increase CONFIG_NR_CPUS value to 8

Ezequiel Garcia (2):
      ARM: mvebu: config: Add GPIO connected LEDs support to defconfig
      ARM: mvebu: config: Enable NAND support

Hiep Cao Minh (1):
      ARM: shmobile: Lager:add SPI FLASH support on QSPI

Kevin Hilman (1):
      Merge tag 'omap-for-v3.14/board-removal-safe' of git://git.kernel.org/.../tmlind/linux-omap into next/boards

Kuninori Morimoto (9):
      ARM: shmobile: bockw: enable CONFIG_REGULATOR
      ARM: shmobile: lager: add gpio regulator support on defconfig
      ARM: shmobile: lager: fixup I2C device on defconfig
      ARM: shmobile: bockw: use regulator for MMCIF
      ARM: shmobile: bockw: fixup FPGA ioremap area
      ARM: shmobile: bockw: add pin pull-up setting for SDHI
      ARM: shmobile: armadillo: fixup FSI address size
      ARM: shmobile: bockw: remove unused RSND_SSI_CLK_FROM_ADG
      ARM: shmobile: lager: add gpio/fixed regulator for SDHI

Laurent Pinchart (16):
      ARM: shmobile: genmai: Rename ARCH_SHMOBILE to ARCH_SHMOBILE_LEGACY
      ARM: shmobile: mackerel: Use pinconf API to configure pin pull-down
      ARM: Kconfig: Mention Renesas ARM SoCs instead of SH-Mobile
      ARM: shmobile: armadillo800eva: Enable backlight control in defconfig
      ARM: shmobile: koelsch: Add DU device
      ARM: shmobile: armadillo: Set backlight enable GPIO
      ARM: shmobile: lager-reference: Enable multiplaform kernel support
      ARM: shmobile: koelsch-reference: Remove duplicate CCF initialization
      ARM: shmobile: lager-reference: Instantiate clkdevs for SCIF and CMT
      ARM: shmobile: koelsch-reference: Instantiate clkdevs for SCIF and CMT
      ARM: shmobile: Remove non-multiplatform Lager reference support
      ARM: shmobile: Remove non-multiplatform Koelsch reference support
      ARM: shmobile: Let Lager multiplatform boot with Lager DTB
      ARM: shmobile: Let Koelsch multiplatform boot with Koelsch DTB
      ARM: shmobile: mackerel: Fix USBHS pinconf entry
      ARM: dts: Split omap3 pinmux core device

Magnus Damm (14):
      ARM: shmobile: Genmai defconfig
      ARM: shmobile: Enable PFC/GPIO on the Koelsch board
      ARM: shmobile: Add Koelsch LED6, LED7 and LED8 support
      ARM: shmobile: Add Koelsch SW2 support
      ARM: shmobile: r8a7791 Koelsch DT reference C bits
      ARM: shmobile: Initial r8a7791 and Koelsch multiplatform support
      ARM: shmobile: r7s72100 Genmai DT reference DTS bits
      ARM: shmobile: r7s72100 Genmai DT reference C bits
      ARM: shmobile: r7s72100 Genmai Multiplatform
      ARM: shmobile: Use ->init_late() on Koelsch
      ARM: shmobile: koelsch: mark GPIO keys as wake-up sources
      ARM: shmobile: Hook up SW30-SW36 on Koelsch
      ARM: shmobile: Use ->init_late() on Lager
      ARM: shmobile: Add pinctrl_register_mappings() for Koelsch

Olof Johansson (13):
      Merge tag 'renesas-defconfig-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'mvebu-defconfig-3.14' of git://git.infradead.org/linux-mvebu into next/boards
      Merge tag 'samsung-defconfig' of git://git.kernel.org/.../kgene/linux-samsung into next/boards
      Merge tag 'mvebu-defconfig-3.14-2' of git://git.infradead.org/linux-mvebu into next/boards
      Merge tag 'tegra-for-3.14-defconfig' of git://git.kernel.org/.../tegra/linux into next/boards
      Merge tag 'tegra-for-3.14-defconfig-2' of git://git.kernel.org/.../tegra/linux into next/boards
      Merge tag 'v3.13-rc5' into next/boards
      Merge tag 'samsung-defconfig-2' of git://git.kernel.org/.../kgene/linux-samsung into next/boards
      Merge tag 'renesas-boards-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-defconfig2-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge branch 'qcom/boards' into next/boards
      Merge tag 'renesas-boards2-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'omap-for-v3.14/dt-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/boards

Paul Walmsley (1):
      ARM: shmobile: mackerel: clk_round_rate() can return a zero to indicate an error

Rohit Vaswani (2):
      ARM: msm: Add support for APQ8074 Dragonboard
      defconfig: msm_defconfig: Enable CONFIG_ARCH_MSM8974

Sachin Kamat (1):
      ARM: exynos_defconfig: Enable S2MPS11 voltage regulator

Sergei Shtylyov (4):
      ARM: shmobile: marzen: enable HPB-DMAC in defconfig
      ARM: shmobile: bockw: enable HPB-DMAC in defconfig
      ARM: shmobile: Koelsch: enable Ether in defconfig
      ARM: shmobile: Koelsch: add Ether support

Shinya Kuribayashi (2):
      ARM: shmobile: lager: set .debounce_interval
      ARM: shmobile: lager: mark GPIO keys as wake-up sources

Simon Horman (17):
      ARM: shmobile: bockw: Do not set command line in defconfig
      ARM: shmobile: marzen: Do not set command line in defconfig
      ARM: shmobile: bockw: Do not disable CONFIG_INOTIFY_USER in defconfig
      ARM: shmobile: marzen: Do not disable CONFIG_INOTIFY_USER in defconfig
      ARM: shmobile: bockw: Enable CONFIG_VFP in defconfig
      ARM: shmobile: marzen: Enable CONFIG_VFP in defconfig
      ARM: shmobile: bockw: Do not enable CONFIG_DEVTMPFS defconfig
      ARM: shmobile: marzen: Do not enable CONFIG_DEVTMPFS defconfig
      ARM: shmobile: bockw: Enable CONFIG_PACKET in defconfig
      ARM: shmobile: marzen: Enable CONFIG_PACKET in defconfig
      ARM: shmobile: marzen: Do not enable CONFIG_SMC911X in defconfig
      ARM: shmobile: kzm9d: Enable AUTO_ZRELADDR in defconfig
      Merge tag 'renesas-cleanup-for-v3.14' into boards-base
      ARM: shmobile: koelsch: set .debounce_interval
      ARM: shmobile: koelsch: Enable CONFIG_PACKET in defconfig
      ARM: shmobile: koelsch: Do not disable CONFIG_{INOTIFY_USER,UNIX} in defconfig
      Merge branch 'heads/soc2' into boards2-base

Srinivas Kandagatla (1):
      ARM: multi_v7_defconfig: Fix STi support

Stephen Boyd (1):
      ARM: msm_defconfig: Enable restart driver

Stephen Warren (2):
      ARM: tegra: tegra_defconfig updates
      ARM: bcm2835: bcm2835_defconfig updates

Suman Anna (1):
      ARM: dts: OMAP2: fix interrupt number for rng

Thierry Reding (1):
      ARM: tegra: Enable DRM panel support

Thomas Petazzoni (1):
      ARM: kirkwood: enable HIGHMEM in defconfig

Tony Lindgren (22):
      mfd: twl-core: Fix passing of platform data in the device tree case
      Merge branch 'dt-regressions' into omap-for-v3.13/fixes-take4
      ARM: dts: Add basic device tree support for omap2430 sdp
      ARM: dts: Add basic Nokia N8X0 support
      ARM: dts: Add basic support for omap3 LDP zoom1 labrador
      Merge branch 'omap-for-v3.13/fixes-take4' into omap-for-v3.14/board-removal
      Merge branch 'omap-for-v3.14/dt' into omap-for-v3.14/board-removal
      ARM: OMAP2+: Add support for board specific auxdata quirks
      ARM: OMAP2+: Add device tree compatible revision checks for n8x0
      ARM: OMAP2+: Make n8x0 behave better with device tree based booting
      ARM: OMAP2+: Add quirks support for n8x0
      ARM: OMAP2+: Remove legacy booting support for n8x0
      ARM: OMAP2+: Remove board file for H4
      ARM: OMAP2+: Remove legacy board file for 2430sdp
      ARM: OMAP2+: Remove legacy mux code for omap2
      ARM: OMAP2+: Remove legacy hwmod entries for omap2
      Merge branch 'omap-for-v3.14/board-removal' into omap-for-v3.14/omap3-board-removal
      ARM: OMAP2+: Add support for legacy auxdata for twl
      ARM: OMAP2+: Use pdata quirks for emac on am3517
      ARM: dts: Add basic devices on am3517-evm
      ARM: dts: Add support for sbc-3xxx with cm-t3730
      ARM: dts: Add omap specific pinctrl defines to use padconf addresses


 arch/arm/Kconfig                                |   7 +-
 arch/arm/boot/dts/Makefile                      |  17 +-
 arch/arm/boot/dts/am3517-evm.dts                |  29 +
 arch/arm/boot/dts/omap2.dtsi                    |   2 +-
 arch/arm/boot/dts/omap2420-n800.dts             |   8 +
 arch/arm/boot/dts/omap2420-n810-wimax.dts       |   8 +
 arch/arm/boot/dts/omap2420-n810.dts             |   8 +
 arch/arm/boot/dts/omap2420-n8x0-common.dtsi     |  99 +++
 arch/arm/boot/dts/omap2430-sdp.dts              |  49 ++
 arch/arm/boot/dts/omap3-beagle-xm.dts           |  40 +-
 arch/arm/boot/dts/omap3-beagle.dts              |  40 +-
 arch/arm/boot/dts/omap3-cm-t3730.dts            | 104 +++
 arch/arm/boot/dts/omap3-cm-t3x30.dtsi           |  95 +++
 arch/arm/boot/dts/omap3-igep.dtsi               |   2 -
 arch/arm/boot/dts/omap3-igep0020.dts            |  52 +-
 arch/arm/boot/dts/omap3-igep0030.dts            |  10 +-
 arch/arm/boot/dts/omap3-ldp.dts                 | 231 ++++++
 arch/arm/boot/dts/omap3-sb-t35.dtsi             |  40 +
 arch/arm/boot/dts/omap3-sbc-t3730.dts           |  30 +
 arch/arm/boot/dts/omap3-zoom3.dts               |  23 +-
 arch/arm/boot/dts/omap3.dtsi                    |   2 +-
 arch/arm/boot/dts/omap34xx.dtsi                 |  13 +
 arch/arm/boot/dts/omap36xx.dtsi                 |  11 +
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts  |   6 +
 arch/arm/boot/dts/r7s72100-genmai-reference.dts |  31 +
 arch/arm/configs/armadillo800eva_defconfig      |   3 +
 arch/arm/configs/bcm2835_defconfig              |  37 +-
 arch/arm/configs/bockw_defconfig                |  10 +-
 arch/arm/configs/exynos_defconfig               |   3 +-
 arch/arm/configs/genmai_defconfig               | 116 +++
 arch/arm/configs/kirkwood_defconfig             |   1 +
 arch/arm/configs/koelsch_defconfig              |  25 +-
 arch/arm/configs/kzm9d_defconfig                |   1 +
 arch/arm/configs/lager_defconfig                |   3 +-
 arch/arm/configs/marzen_defconfig               |  10 +-
 arch/arm/configs/msm_defconfig                  |   3 +
 arch/arm/configs/multi_v7_defconfig             |   3 +
 arch/arm/configs/mvebu_defconfig                |   3 +
 arch/arm/configs/tegra_defconfig                |  22 +-
 arch/arm/mach-msm/board-dt.c                    |   9 +
 arch/arm/mach-omap2/Kconfig                     |  13 -
 arch/arm/mach-omap2/Makefile                    |   4 -
 arch/arm/mach-omap2/board-2430sdp.c             | 273 -------
 arch/arm/mach-omap2/board-h4.c                  | 365 ---------
 arch/arm/mach-omap2/board-n8x0.c                | 234 ++----
 arch/arm/mach-omap2/common-board-devices.h      |   1 +
 arch/arm/mach-omap2/common.h                    |   1 +
 arch/arm/mach-omap2/msdi.c                      |  69 --
 arch/arm/mach-omap2/mux.h                       |   2 -
 arch/arm/mach-omap2/mux2420.c                   | 690 ----------------
 arch/arm/mach-omap2/mux2420.h                   | 282 -------
 arch/arm/mach-omap2/mux2430.c                   | 793 -------------------
 arch/arm/mach-omap2/mux2430.h                   | 370 ---------
 arch/arm/mach-omap2/omap_device.c               |   2 +
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      | 137 ----
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      | 266 -------
 .../omap_hwmod_2xxx_interconnect_data.c         | 165 +---
 .../mach-omap2/omap_hwmod_2xxx_ipblock_data.c   |  72 +-
 arch/arm/mach-omap2/omap_hwmod_common_data.h    |   5 -
 arch/arm/mach-omap2/pdata-quirks.c              | 138 +++-
 arch/arm/mach-shmobile/Kconfig                  |  63 +-
 arch/arm/mach-shmobile/Makefile                 |   5 +-
 arch/arm/mach-shmobile/Makefile.boot            |   4 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c  |   7 +-
 arch/arm/mach-shmobile/board-bockw-reference.c  |  19 +-
 arch/arm/mach-shmobile/board-bockw.c            |  17 +-
 arch/arm/mach-shmobile/board-genmai-reference.c |  49 ++
 .../arm/mach-shmobile/board-koelsch-reference.c |  79 ++
 arch/arm/mach-shmobile/board-koelsch.c          | 190 ++++-
 arch/arm/mach-shmobile/board-lager-reference.c  |  34 +
 arch/arm/mach-shmobile/board-lager.c            | 151 +++-
 arch/arm/mach-shmobile/board-mackerel.c         |  21 +-
 arch/arm/mach-shmobile/sh-gpio.h                |  19 -
 include/dt-bindings/pinctrl/omap.h              |  20 +
 include/sound/rcar_snd.h                        |   1 -
 75 files changed, 1899 insertions(+), 3868 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap2420-n800.dts
 create mode 100644 arch/arm/boot/dts/omap2420-n810-wimax.dts
 create mode 100644 arch/arm/boot/dts/omap2420-n810.dts
 create mode 100644 arch/arm/boot/dts/omap2420-n8x0-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap2430-sdp.dts
 create mode 100644 arch/arm/boot/dts/omap3-cm-t3730.dts
 create mode 100644 arch/arm/boot/dts/omap3-cm-t3x30.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-ldp.dts
 create mode 100644 arch/arm/boot/dts/omap3-sb-t35.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-sbc-t3730.dts
 create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
 create mode 100644 arch/arm/boot/dts/r7s72100-genmai-reference.dts
 create mode 100644 arch/arm/configs/genmai_defconfig
 delete mode 100644 arch/arm/mach-omap2/board-2430sdp.c
 delete mode 100644 arch/arm/mach-omap2/board-h4.c
 delete mode 100644 arch/arm/mach-omap2/mux2420.c
 delete mode 100644 arch/arm/mach-omap2/mux2420.h
 delete mode 100644 arch/arm/mach-omap2/mux2430.c
 delete mode 100644 arch/arm/mach-omap2/mux2430.h
 create mode 100644 arch/arm/mach-shmobile/board-genmai-reference.c
 create mode 100644 arch/arm/mach-shmobile/board-koelsch-reference.c
