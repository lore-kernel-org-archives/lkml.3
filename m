Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaHaRdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 13:33:14 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60298 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaHaRcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 13:32:54 -0400
Date: Sun, 31 Aug 2014 10:32:42 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.17
Message-ID: <20140831173242.GA4955@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to e160cc17688cc6f24211cbc2e2a6e872e08dd4d6:

  vexpress/spc: fix a build warning on array bounds (2014-08-31 10:22:10 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.17-rc

Here's the weekly batch of fixes from arm-soc.

The delta is a largeish negative delta, due to revert of SMP support for Broadcom's
STB SoC -- it was accidentally merged before some issues had been addressed, so they
will make a new attempt for 3.18. I didn't see a need for a full revert of the whole
platform due to this, we're keeping the rest enabled.

The rest is mostly:

* A handful of DT fixes for i.MX (Hummingboard/Cubox-i in particular)
* Some MTD/NAND fixes for OMAP
* Minor DT fixes for shmobile
* Warning fix for UP builds on vexpress/spc

There's also a couple of patches that wires up hwmod on TI's DRA7 SoC
so it can boot. Drivers and the rest had landed for 3.17, and it's small
and isolated so it made sense to pick up now even if it's not a bugfix.

----------------------------------------------------------------
Alex Shi (1):
      vexpress/spc: fix a build warning on array bounds

Brian Norris (1):
      ARM: brcmstb: revert SMP support

Fabio Estevam (1):
      ARM: dts: imx53-qsrb: Fix suspend/resume

Hans Wennborg (1):
      ARM: OMAP: fix %d confusingly prefixed with 0x in format string

Heiko Stübner (1):
      MAINTAINERS: catch special Rockchip code locations

Kuninori Morimoto (2):
      ARM: shmobile: r8a7790: add missing 0x0100 for SDCKCR
      ARM: shmobile: r8a7791: add missing 0x0100 for SDCKCR

Mark Brown (1):
      ARM: dts: Remove twl6030 clk32g "regulator"

Markus Pargmann (1):
      ARM: OMAP2+: omap_device: remove warning that clk alias already exists

Nishanth Menon (1):
      ARM: dts: DRA7: fix interrupt-cells for GPIO

Olof Johansson (4):
      Merge tag 'omap-for-v3.17/fixes-against-rc2' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'imx-fixes-3.17-2' of git://git.kernel.org/.../shawnguo/linux into fixes
      Merge tag 'renesas-clock-fixes-for-v3.17' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'for-v3.17-rc/omap-dra72x-d74x-support-a' of git://git.kernel.org/.../pjw/omap-pending into fixes

Rabeeh Khoury (1):
      ARM: dts: microsom-ar8035: MDIO pad must be set open drain

Rajendra Nayak (2):
      ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x() variants
      ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists

Roger Quadros (4):
      mtd: nand: omap: Revert to using software ECC by default
      ARM: OMAP2+: GPMC: Support Software ECC scheme via DT
      ARM: dts: omap3430-sdp: Revert to using software ECC for NAND
      mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()

Russell King (2):
      ARM: dts: hummingboard/cubox-i: add USB OC pinctrl configuration
      ARM: dts: hummingboard/cubox-i: change SPDIF output to be more descriptive

Simon Horman (1):
      ARM: shmobile: sh73a0: Remove spurious 0x from SCIFB clock name

Tero Kristo (1):
      ARM: dts: omap54xx-clocks: Fix the l3 and l4 clock rates

Tony Lindgren (2):
      ARM: dts: Enable UART wake-up events for beagleboard
      ARM: OMAP2+: hwmod: Rearm wake-up interrupts for DT when MUSB is idled

 .../devicetree/bindings/mtd/gpmc-nand.txt          |    2 +-
 MAINTAINERS                                        |    5 +
 arch/arm/boot/dts/dra7.dtsi                        |   16 +-
 arch/arm/boot/dts/imx53-qsrb.dts                   |    8 +
 arch/arm/boot/dts/imx6dl-hummingboard.dts          |    4 +-
 arch/arm/boot/dts/imx6qdl-cubox-i.dtsi             |   19 +-
 arch/arm/boot/dts/imx6qdl-microsom-ar8035.dtsi     |    2 +-
 arch/arm/boot/dts/omap3-beagle.dts                 |    1 +
 arch/arm/boot/dts/omap3430-sdp.dts                 |    2 +-
 arch/arm/boot/dts/omap54xx-clocks.dtsi             |   16 +-
 arch/arm/boot/dts/twl6030.dtsi                     |    4 -
 arch/arm/mach-bcm/Makefile                         |    1 -
 arch/arm/mach-bcm/brcmstb.h                        |   19 -
 arch/arm/mach-bcm/headsmp-brcmstb.S                |   33 --
 arch/arm/mach-bcm/platsmp-brcmstb.c                |  363 --------------------
 arch/arm/mach-omap2/board-flash.c                  |    2 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |    3 +-
 arch/arm/mach-omap2/gpmc.c                         |    7 +-
 arch/arm/mach-omap2/id.c                           |    2 +-
 arch/arm/mach-omap2/omap_device.c                  |    2 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |    7 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |   22 +-
 arch/arm/mach-omap2/soc.h                          |    6 +
 arch/arm/mach-shmobile/clock-r8a7790.c             |    4 +-
 arch/arm/mach-shmobile/clock-r8a7791.c             |    2 +-
 arch/arm/mach-shmobile/clock-sh73a0.c              |    2 +-
 arch/arm/mach-vexpress/spc.c                       |   14 +-
 drivers/mtd/nand/omap2.c                           |   16 +-
 include/linux/platform_data/mtd-nand-omap2.h       |   13 +-
 29 files changed, 133 insertions(+), 464 deletions(-)
 delete mode 100644 arch/arm/mach-bcm/brcmstb.h
 delete mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
 delete mode 100644 arch/arm/mach-bcm/platsmp-brcmstb.c
