Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbbARF5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 00:57:41 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64158 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbbARF5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 00:57:40 -0500
Date: Sat, 17 Jan 2015 21:57:36 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes
Message-ID: <20150118055736.GA24081@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/armsoc-for-linus

for you to fetch changes up to 966903a98fd80ae5f5c4a7ca121d36ea0ba23143:

  Merge tag 'samsung-fixes-3.19' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2015-01-16 19:11:37 -0800)

----------------------------------------------------------------
ARM: SoC fixes

We've been sitting on our fixes branch for a while, so this batch is
unfortunately on the large side.

A lot of these are tweaks and fixes to device trees, fixing various bugs
around clocks, reg ranges, etc. There's also a few defconfig updates
(which are on the late side, no more of those).

All in all the diffstat is bigger than ideal at this time, but the nothing
in here seems particularly risky.

----------------------------------------------------------------
Abhilash Kesavan (2):
      drivers: bus: check cci device tree node status
      ARM: dts: disable CCI on exynos5420 based arndale-octa

Alexander Stein (1):
      ARM: at91/dt: sam9263: Add missing clocks to lcdc node

Andreas Faerber (1):
      ARM: exynos_defconfig: Enable LM90 driver

Bo Shen (2):
      ARM: at91/dt: sama5d4: fix the timer reg length
      ARM: at91: sama5d3: dt: correct the sound route

Doug Anderson (1):
      ARM: dts: rockchip: bump sd card pin drive strength up on rk3288-evb

Fabio Estevam (3):
      ARM: dts: imx25: Fix the SPI1 clocks
      ARM: imx6sx: Set PLL2 as parent of QSPI clocks
      ARM: dts: imx51-babbage: Fix ULPI PHY reset modelling

Gary Bisson (1):
      ARM: clk-imx6q: fix video divider for rev T0 1.0

Geert Uytterhoeven (2):
      ARM: shmobile: r8a7740: Instantiate GIC from C board code in legacy builds
      ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin instances

Heiko Stübner (1):
      ARM: rockchip: disable jtag/sdmmc autoswitching on rk3288

Javier Martinez Canillas (1):
      ARM: exynos_defconfig: Enable options for display panel support

Jisheng Zhang (3):
      ARM: dts: berlin: fix io clk and add missing core clk for BG2Q sdhci2 host
      ARM: dts: berlin: add broken-cd and set bus width for eMMC in Marvell DMP DT
      ARM: dts: berlin: correct BG2Q's SM GPIO location.

Lennart Sorensen (3):
      ARM: omap5/dra7xx: Fix frequency typos
      ARM: dra7xx: Fix counter frequency drift for AM572x errata i856
      ARM: omap5/dra7xx: Enable booting secondary CPU in HYP mode

Linus Walleij (1):
      ARM: nomadik: fix up leftover device tree pins

Mugunthan V N (1):
      ARM: dts: dra7-evm: fix qspi device tree partition size

Nishanth Menon (1):
      ARM: omap2plus_defconfig: use CONFIG_CPUFREQ_DT

Olof Johansson (7):
      Merge tag 'v3.19-rockchip-dtsfixes1' of git://git.kernel.org/.../mmind/linux-rockchip into fixes
      Merge tag 'imx-fixes-3.19' of git://git.kernel.org/.../shawnguo/linux into fixes
      Merge tag 'omap-for-v3.19/fixes-rc1' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'berlin-fixes-for-3.19-1' of git://git.infradead.org/users/hesselba/linux-berlin into fixes
      Merge tag 'at91-fixes' of git://git.kernel.org/.../nferre/linux-at91 into fixes
      Merge tag 'renesas-soc-fixes-for-v3.19' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'samsung-fixes-3.19' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Philipp Zabel (1):
      ARM: dts: imx6qdl: Fix CODA960 interrupt order

Tony Lindgren (2):
      ARM: OMAP2+: Fix n900 board name for legacy user space
      ARM: dts: Revert disabling of smc91x for n900

Tyler Baker (1):
      reset: sunxi: fix spinlock initialization

Vivek Gautam (1):
      arm: dts: Use pmu_system_controller phandle for dp phy

Wenyou Yang (1):
      ARM: at91: board-dt-sama5: add phy_fixup to override NAND_Tree

Xiubo Li (1):
      ARM: ls1021a: dtsi: add 'big-endian' property for scfg node

 arch/arm/boot/dts/at91sam9263.dtsi            |  2 +
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts    |  2 +
 arch/arm/boot/dts/berlin2q.dtsi               | 63 ++++++++++++++-------------
 arch/arm/boot/dts/dra7-evm.dts                | 10 ++---
 arch/arm/boot/dts/exynos5250.dtsi             |  2 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts |  4 ++
 arch/arm/boot/dts/exynos5420.dtsi             |  6 +--
 arch/arm/boot/dts/imx25.dtsi                  |  2 +-
 arch/arm/boot/dts/imx51-babbage.dts           | 22 +++-------
 arch/arm/boot/dts/imx6qdl.dtsi                |  4 +-
 arch/arm/boot/dts/ls1021a.dtsi                |  1 +
 arch/arm/boot/dts/omap3-n900.dts              |  4 +-
 arch/arm/boot/dts/rk3288-evb.dtsi             | 30 +++++++++++++
 arch/arm/boot/dts/sama5d3xmb.dtsi             |  2 +-
 arch/arm/boot/dts/sama5d4.dtsi                |  2 +-
 arch/arm/boot/dts/ste-nomadik-nhk15.dts       |  8 ++--
 arch/arm/configs/exynos_defconfig             | 18 +++++++-
 arch/arm/configs/omap2plus_defconfig          |  2 +-
 arch/arm/mach-at91/board-dt-sama5.c           | 18 ++++++++
 arch/arm/mach-imx/clk-imx6q.c                 |  2 +-
 arch/arm/mach-imx/clk-imx6sx.c                |  3 ++
 arch/arm/mach-omap2/board-generic.c           | 18 ++++++++
 arch/arm/mach-omap2/common.h                  |  1 +
 arch/arm/mach-omap2/control.h                 |  4 ++
 arch/arm/mach-omap2/omap-headsmp.S            | 21 +++++++++
 arch/arm/mach-omap2/omap-smp.c                | 13 +++++-
 arch/arm/mach-omap2/timer.c                   | 44 ++++++++++++++++---
 arch/arm/mach-rockchip/rockchip.c             | 27 ++++++++++++
 arch/arm/mach-shmobile/setup-r8a7740.c        |  7 +++
 arch/arm/mach-shmobile/setup-sh73a0.c         |  3 ++
 drivers/bus/arm-cci.c                         |  3 ++
 drivers/reset/reset-sunxi.c                   |  4 ++
 32 files changed, 272 insertions(+), 80 deletions(-)
