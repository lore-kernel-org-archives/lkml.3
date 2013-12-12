Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab3LLIpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:45:30 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50309 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3LLIp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:45:27 -0500
Date: Thu, 12 Dec 2013 00:43:13 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] ARM: SoC fixes for 3.13-rc
Message-ID: <20131212084313.GA20698@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 6f97dc8d4663abed96fa30e3ea4a1d4cfd1c4276:

  ARM: sun6i: dt: Fix interrupt trigger types (2013-12-11 17:15:24 -0800)

----------------------------------------------------------------
ARM: SoC fixes for 3.13-rc

Another week, another batch of fixes.

Again, OMAP regressions due to move to DT is the bulk of the changes here,
but this should be the last of it for 3.13. There are also a handful of
OMAP hwmod changes (power management, reset handling) for USB on OMAP3
that fixes some longish-standing bugs around USB resets.

There are a couple of other changes that also add up line count a bit:
One is a long-standing bug with the keyboard layout on one of the
PXA platforms. The other is a fix for highbank that moves their
power-off/reset button handling to be done in-kernel since relying on
userspace to handle it was fragile and awkward.

----------------------------------------------------------------
Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping

Kevin Hilman (2):
      Merge tag 'omap-for-v3.13/yet-more-dt-regressions-take2' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'for-v3.13-rc/hwmod-fixes-a' of git://git.kernel.org/.../pjw/omap-pending into fixes

Lad, Prabhakar (2):
      gpio: davinci: fix check for unbanked gpio
      ARM: davinci: fix number of resources passed to davinci_gpio_register()

Maxime Ripard (2):
      ARM: sun7i: dt: Fix interrupt trigger types
      ARM: sun6i: dt: Fix interrupt trigger types

Nishanth Menon (3):
      ARM: OMAP2+: Fix the machine entry for am3517
      ARM: OMAP2+: hwmod: Fix usage of invalid iclk / oclk when clock node is not present
      ARM: OMAP2+: omap_device: add fail hook for runtime_pm when bad data is detected

Olof Johansson (2):
      Merge tag 'davinci-fixes-for-v3.13-rc1' of git://git.kernel.org/.../nsekhar/linux-davinci into fixes
      Merge tag 'davinci-fixes-for-v3.13-rc3' of git://git.kernel.org/.../nsekhar/linux-davinci into fixes

Peter Ujfalusi (1):
      ARM: davinci: Fix McASP mem resource names

Rob Herring (1):
      ARM: highbank: handle soft poweroff and reset key events

Roger Quadros (3):
      ARM: OMAP4+: hwmod data: Don't prevent RESET of USB Host module
      ARM: OMAP2+: hwmod: Fix SOFTRESET logic
      ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes

Shawn Guo (1):
      MAINTAINERS: merge IMX6 entry into IMX

Stephen Warren (1):
      ARM: tegra: add missing break to fuse initialization code

Tony Lindgren (3):
      ARM: OMAP2+: Fix overwriting hwmod data with data from device tree
      ARM: dts: Fix missing entries for am3517
      ARM: dts: Fix booting for secure omaps

 MAINTAINERS                                |  11 +--
 arch/arm/boot/dts/am3517-evm.dts           |   6 +-
 arch/arm/boot/dts/am3517.dtsi              |  63 +++++++++++++
 arch/arm/boot/dts/omap3-n900.dts           |   2 +-
 arch/arm/boot/dts/omap3-n950-n9.dtsi       |   2 +-
 arch/arm/boot/dts/omap34xx-hs.dtsi         |  16 ++++
 arch/arm/boot/dts/omap36xx-hs.dtsi         |  16 ++++
 arch/arm/boot/dts/sun6i-a31.dtsi           |  27 +++---
 arch/arm/boot/dts/sun7i-a20.dtsi           |  42 ++++-----
 arch/arm/mach-davinci/devices-da8xx.c      |   4 +-
 arch/arm/mach-davinci/dm355.c              |   3 +-
 arch/arm/mach-davinci/dm365.c              |   3 +-
 arch/arm/mach-davinci/dm644x.c             |   3 +-
 arch/arm/mach-davinci/dm646x.c             |   6 +-
 arch/arm/mach-highbank/highbank.c          |  23 +++++
 arch/arm/mach-omap2/board-generic.c        |  18 ++++
 arch/arm/mach-omap2/omap_device.c          |  24 +++++
 arch/arm/mach-omap2/omap_device.h          |   1 +
 arch/arm/mach-omap2/omap_hwmod.c           | 143 ++++++++++++++++++++++++-----
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  13 +--
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  12 +--
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c |  13 +--
 arch/arm/mach-pxa/reset.c                  |   8 +-
 arch/arm/mach-pxa/tosa.c                   | 102 ++++++++++----------
 arch/arm/mach-tegra/fuse.c                 |   2 +
 drivers/gpio/gpio-davinci.c                |   4 +-
 26 files changed, 409 insertions(+), 158 deletions(-)
 create mode 100644 arch/arm/boot/dts/am3517.dtsi
 create mode 100644 arch/arm/boot/dts/omap34xx-hs.dtsi
 create mode 100644 arch/arm/boot/dts/omap36xx-hs.dtsi
