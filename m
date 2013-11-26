Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab3KZTJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:09:47 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35600 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3KZTJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:09:46 -0500
Date: Tue, 26 Nov 2013 11:07:26 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.13-rc
Message-ID: <20131126190726.GA28631@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to a31ab44ef5d07c6707df4a9ad2c8affd2d62ff4b:

  ARM: bcm2835: add missing #xxx-cells to I2C nodes (2013-11-25 21:56:00 -0800)

----------------------------------------------------------------
ARM: SoC fixes for 3.13-rc

Mostly bugfixes and a few small code removals. Worth pointing out is:

- A handful of more fixes to get DT enablement working properly on OMAP,
  finding new breakage of things that don't work quite right yet without
  the traditional board files. I expect a bit more of this to come in this
  release as people test on their hardware.
- Implementation of power_down_finish() on vexpress, to make kexec work and
  to stop the MCPM core to produce a warning (the warning was new to 3.13-rc1).
- A handful of minor fixes for various platforms.

----------------------------------------------------------------
Dave Martin (1):
      ARM: vexpress/TC2: Implement MCPM power_down_finish()

Doug Anderson (1):
      ARM: dts: Add max77686 RTC interrupt to cros5250-common

Kevin Hilman (1):
      Merge tag 'imx-fixes-3.13-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes

Olof Johansson (2):
      ARM: omap: fix warning with LPAE build
      Merge tag 'omap-for-v3.13/more-fixes-for-merge-window-take2' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Shawn Guo (1):
      ARM: dts: imx6qdl: disable spdif "rxtx5" clock option

Stephen Warren (1):
      ARM: bcm2835: add missing #xxx-cells to I2C nodes

Thierry Reding (1):
      ARM: tegra: Provide dummy powergate implementation

Tony Lindgren (9):
      i2c: omap: Fix missing device tree flags for omap2
      ARM: OMAP2+: Fix GPMC and simplify bootloader timings for 8250 and smc91x
      ARM: dts: Fix omap2 specific dtsi files by adding the missing entries
      ARM: OMAP2+: More randconfig fixes for reconfigure_io_chain
      gpio: twl4030: Fix regression for twl gpio output
      gpio: twl4030: Fix passing of pdata in the device tree case
      ARM: OMAP2+: Fix undefined reference to set_cntfreq
      ARM: OMAP2+: Remove legacy mux code for display.c
      ARM: OMAP2+: Remove legacy omap4_twl6030_hsmmc_init

 Documentation/devicetree/bindings/i2c/i2c-omap.txt |  3 +-
 arch/arm/boot/dts/bcm2835.dtsi                     |  4 +
 arch/arm/boot/dts/cros5250-common.dtsi             | 12 +++
 arch/arm/boot/dts/imx6qdl.dtsi                     |  2 +-
 arch/arm/boot/dts/omap-zoom-common.dtsi            |  2 +-
 arch/arm/boot/dts/omap2.dtsi                       | 96 ++++++++++++++++++++++
 arch/arm/boot/dts/omap2420.dtsi                    | 23 ++++++
 arch/arm/boot/dts/omap2430.dtsi                    | 49 +++++++++++
 arch/arm/mach-omap2/Makefile                       |  6 +-
 arch/arm/mach-omap2/common.h                       |  1 -
 arch/arm/mach-omap2/display.c                      | 78 ------------------
 arch/arm/mach-omap2/gpmc.c                         | 58 +++++--------
 arch/arm/mach-omap2/omap-secure.h                  |  7 ++
 arch/arm/mach-omap2/omap4-common.c                 | 57 -------------
 arch/arm/mach-omap2/pm34xx.c                       |  2 +-
 arch/arm/mach-omap2/prm44xx_54xx.h                 |  2 +-
 arch/arm/mach-vexpress/spc.c                       | 40 +++++++++
 arch/arm/mach-vexpress/spc.h                       |  1 +
 arch/arm/mach-vexpress/tc2_pm.c                    | 66 +++++++++++++--
 drivers/gpio/gpio-twl4030.c                        | 13 ++-
 drivers/i2c/busses/i2c-omap.c                      | 22 +++++
 include/linux/tegra-powergate.h                    | 27 ++++++
 22 files changed, 379 insertions(+), 192 deletions(-)
