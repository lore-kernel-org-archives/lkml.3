Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaHXSlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 14:41:13 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39299 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaHXSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 14:40:54 -0400
Date: Sun, 24 Aug 2014 11:40:35 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, kgene.kim@gmail.com, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.17-rc
Message-ID: <20140824184035.GA13254@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

for you to fetch changes up to bf87bb12bd7062bf577163f3f6d765debbae6200:

  bus: arm-ccn: Fix warning message (2014-08-24 11:28:30 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.17-rc

A collection of fixes from this week, it's been pretty quiet and nothing
really stands out as particularly noteworthy here -- mostly minor fixes
across the field:

- ODROID booting was fixed due to PMIC interrupts missing in DT
- A collection of i.MX fixes
- Minor Tegra fix for regulators
- Rockchip fix and addition of SoC-specific mailing list to make it
  easier to find posted patches.

----------------------------------------------------------------
Anson Huang (1):
      ARM: imx: correct gpu2d_axi and gpu3d_axi clock setting

Arnd Bergmann (1):
      ARM: imx6: fix SMP compilation again

Bill Pringlemeir (1):
      ARM: dts: vf610-twr: Fix pinctrl_esdhc1 pin definitions.

Chen-Yu Tsai (1):
      ARM: dt: sun6i: Add #address-cells and #size-cells to i2c controller nodes

Daniel Drake (2):
      ARM: dts: Enable PMIC interrupts on ODROID
      ARM: dts: ODROID i2c improvements

Fugang Duan (1):
      ARM: dts: imx6sx: fix the pad setting for uart CTS_B

Geert Uytterhoeven (1):
      ARM: shmobile: koelsch: Remove non-existent i2c6 pinmux

Heiko Stuebner (2):
      ARM: dts: rockchip: readd missing mmc0 pinctrl settings
      MAINTAINERS: add new Rockchip SoC list

Lothar Waßmann (1):
      ARM: dts: i.MX53: fix apparent bug in VPU clks

Marcel Ziswiler (1):
      ARM: tegra: apalis/colibri t30: fix on-module 5v0 supplies

Olof Johansson (3):
      Merge tag 'imx-fixes-3.17' of git://git.kernel.org/.../shawnguo/linux into fixes
      Merge tag 'sunxi-dt-for-3.17-2' of git://git.kernel.org/.../mripard/linux into fixes
      Merge tag 'v3.17-rockchip-fixes1' of git://git.kernel.org/.../mmind/linux-rockchip into fixes

Pawel Moll (1):
      bus: arm-ccn: Fix warning message

Shawn Guo (2):
      ARM: imx: fix TLB missing of IOMUXC base address during suspend
      ARM: imx: remove unnecessary ARCH_HAS_OPP select

Silvio Fricke (1):
      ARM: dts: imx6: edmqmx6: change enet reset pin

 MAINTAINERS                                     |    1 +
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi |   13 ++++++++++++
 arch/arm/boot/dts/imx53.dtsi                    |    2 +-
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts         |    3 ++-
 arch/arm/boot/dts/imx6sx-pinfunc.h              |   26 +++++++++++------------
 arch/arm/boot/dts/r8a7791-koelsch.dts           |    7 ------
 arch/arm/boot/dts/rk3066a-bqcurie2.dts          |    2 ++
 arch/arm/boot/dts/rk3188-radxarock.dts          |    2 ++
 arch/arm/boot/dts/sun6i-a31.dtsi                |    8 +++++++
 arch/arm/boot/dts/tegra30-apalis.dtsi           |   11 +++++++++-
 arch/arm/boot/dts/tegra30-colibri.dtsi          |   11 +++++++++-
 arch/arm/boot/dts/vf610-twr.dts                 |    2 +-
 arch/arm/mach-imx/Kconfig                       |    2 --
 arch/arm/mach-imx/Makefile                      |    2 ++
 arch/arm/mach-imx/clk-imx6q.c                   |   10 +++++++--
 arch/arm/mach-imx/suspend-imx6.S                |    2 ++
 drivers/bus/arm-ccn.c                           |    2 +-
 17 files changed, 76 insertions(+), 30 deletions(-)
