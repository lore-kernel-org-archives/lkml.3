Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaJZRP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 13:15:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51628 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaJZRPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 13:15:25 -0400
Date: Sun, 26 Oct 2014 10:15:25 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL]: ARM: SoC fixes for -rc2
Message-ID: <20141026171525.GA8911@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/armsoc-for-rc2

for you to fetch changes up to efc176a8ee1f959b89292597bd8a99417475a79a:

  Merge tag 'imx-fixes-3.18' of git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux into fixes (2014-10-25 20:44:05 -0700)

----------------------------------------------------------------
ARM: SoC fixes for -rc2

Another week, another small batch of fixes.

Most of these make zynq, socfpga and sunxi platforms work a bit
better:

* Due to new requirements for regulators, DWMMC on socfpga broke past 3.17.
* SMP spinup fix for socfpga
* A few DT fixes for zynq
* Another option (FIXED_REGULATOR) for sunxi is needed that used to be selected
  by other options but no longer is.
* A couple of small DT fixes for at91
* ...and a couple for i.MX.

----------------------------------------------------------------
Alexandre Belloni (1):
      power: reset: at91-reset: fix power down register

Bo Shen (1):
      MAINTAINERS: add atmel ssc driver maintainer entry

Boris Brezillon (1):
      ARM: at91/dt: sam9263: fix PLLB frequencies

Dinh Nguyen (4):
      arm: socfpga: fix fetching cpu1start_addr for SMP
      ARM: dts: socfpga: rename gpio nodes
      ARM: dts: socfpga: Fix SD card detect
      ARM: dts: socfpga: Add a 3.3V fixed regulator node

Fabio Estevam (1):
      ARM: dts: imx28-evk: Let i2c0 run at 100kHz

Michal Simek (5):
      ARM: zynq: DT: Add missing address for L2 pl310
      ARM: zynq: DT: Add missing reference for ADC
      ARM: zynq: DT: Add missing reference for memory-controller
      ARM: zynq: DT: Add cadence watchdog node
      ARM: zynq: DT: trivial: Fix mc node

Olof Johansson (6):
      ARM: sunxi_defconfig: enable CONFIG_REGULATOR_FIXED_VOLTAGE
      ARM: multi_v7_defconfig: enable CONFIG_MMC_DW_ROCKCHIP
      Merge tag 'zynq-dt-fixes-for-3.18' of https://github.com/Xilinx/linux-xlnx into fixes
      Merge tag 'at91-fixes' of git://git.kernel.org/.../nferre/linux-at91 into fixes
      Merge tag 'socfpga_fixes_for_3.18' of git://git.rocketboards.org/linux-socfpga-next into fixes
      Merge tag 'imx-fixes-3.18' of git://git.kernel.org/.../shawnguo/linux into fixes

Soren Brinkmann (2):
      ARM: zynq: DT: Fix GEM register area size
      ARM: zynq: DT: Remove 222 MHz OPP

Steve Longerbeam (1):
      ARM: i.MX6: Fix "emi" clock name typo

 MAINTAINERS                                   |  7 +++++++
 arch/arm/boot/dts/at91sam9263.dtsi            |  5 +++--
 arch/arm/boot/dts/imx28-evk.dts               |  1 -
 arch/arm/boot/dts/socfpga.dtsi                | 12 ++++++------
 arch/arm/boot/dts/socfpga_arria5.dtsi         |  2 +-
 arch/arm/boot/dts/socfpga_arria5_socdk.dts    | 12 ++++++++++++
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts  | 15 ++++++++++++++-
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts | 12 ++++++++++++
 arch/arm/boot/dts/zynq-7000.dtsi              | 24 +++++++++++++++++-------
 arch/arm/configs/multi_v7_defconfig           |  1 +
 arch/arm/configs/sunxi_defconfig              |  1 +
 arch/arm/mach-imx/clk-imx6q.c                 | 14 +++++++-------
 arch/arm/mach-socfpga/core.h                  |  2 +-
 arch/arm/mach-socfpga/headsmp.S               | 25 +++++++++++++++----------
 arch/arm/mach-socfpga/platsmp.c               |  4 ++--
 arch/arm/mach-socfpga/socfpga.c               |  4 ++--
 drivers/power/reset/at91-reset.c              |  4 ++--
 include/dt-bindings/clock/imx6qdl-clock.h     |  8 ++++----
 18 files changed, 107 insertions(+), 46 deletions(-)
