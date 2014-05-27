Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaE0S0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:26:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34483 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaE0S0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:26:30 -0400
Date: Tue, 27 May 2014 11:26:35 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.15
Message-ID: <20140527182635.GA27315@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-3.15

for you to fetch changes up to 1b0fe6be858d47e7e80fe0adc47c7366f5924244:

  MAINTAINERS: Add reset controller framework entry (2014-05-27 10:59:58 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.15

A slightly larger set of fixes than we'd like at this point in the
release. Hopefully our very last batch before 3.15:

 - OMAP:
   * Fix boot regression with CPU_IDLE enabled
   * Fixes for audio playback on OMAP5
   * Clock rate setting fix for OMAP3
   * Misc idle/PM fixes
 - Exynos:
   * Removal of a couple of power domains to work around issues with access
     when they are powered down
   * Enabling missing highspeed-i2c driver to make MMC regulators work
   * Secondary CPU spin-up fix for 4212
   * Remove MDMA1 engine to avoid conflicts on secure mode platforms
   * A few other DT fixes
 - Marvell:
   * PCI-e fixes for clocks and resource allocation

 + a few other smaller fixes, add a MAINTAINERS entry for reset drivers, etc.

----------------------------------------------------------------
Alexandre Belloni (2):
      ARM: at91/dt: sam9260: correct external trigger value
      ARM: at91: sam9260: fix compilation issues

Alexandre Courbot (1):
      ARM: trusted_foundations: fix compile error on non-SMP

Arnd Bergmann (3):
      Merge tag 'mvebu-fixes-3.15-2' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'at91-fixes2' of git://github.com/at91linux/linux-at91 into fixes
      Merge tag 'samsung-fixes-2nd-tag' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Arun Kumar K (1):
      ARM: dts: Remove g2d_pd node for exynos5420

Beomho Seo (1):
      ARM: dts: fix incorrect ak8975 compatible for exynos4412-trats2 board

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration

Jason Cooper (1):
      Merge branch 'mvebu/dt-fixes' into mvebu/fixes

Kyungmin Park (1):
      ARM: EXYNOS: fix the secondary CPU boot of exynos4212

Laurent Pinchart (1):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms

Olof Johansson (2):
      Merge tag 'samsung-fixes' of http://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'omap-for-v3.15/fixes-v3-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Peter Ujfalusi (1):
      ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM

Philipp Zabel (1):
      MAINTAINERS: Add reset controller framework entry

Roger Quadros (1):
      ARM: OMAP2+: nand: Fix NAND on OMAP2 and OMAP3 boards

Sachin Kamat (3):
      ARM: exynos_defconfig: enable HS-I2C to fix for mmc partition mount
      ARM: dts: Fix SPI interrupt numbers for exynos5420
      ARM: dts: Keep LDO4 always ON for exynos5250-arndale board

Santosh Shilimkar (1):
      ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled

Seungwon Jeon (1):
      ARM: dts: disable MDMA1 node for exynos5420

Thomas Petazzoni (3):
      ARM: mvebu: mvebu-soc-id: add missing clk_put() call
      ARM: mvebu: mvebu-soc-id: keep clock enabled if PCIe unit is enabled
      ARM: mvebu: fix definitions of PCIe interfaces on Armada 38x

Tony Lindgren (2):
      Merge tag 'for-v3.15-rc/omap-fixes-b' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.15/fixes-v3
      ARM: OMAP2+: Fix DMA hang after off-idle

Tushar Behera (1):
      ARM: dts: Remove mau_pd node for exynos5420

 MAINTAINERS                                   |  8 ++++++++
 arch/arm/boot/dts/armada-380.dtsi             |  2 +-
 arch/arm/boot/dts/armada-385.dtsi             |  4 ++--
 arch/arm/boot/dts/at91sam9260.dtsi            |  2 +-
 arch/arm/boot/dts/exynos4412-trats2.dts       |  2 +-
 arch/arm/boot/dts/exynos5250-arndale.dts      |  1 +
 arch/arm/boot/dts/exynos5420-arndale-octa.dts | 12 ------------
 arch/arm/boot/dts/exynos5420.dtsi             | 24 ++++++++++--------------
 arch/arm/configs/exynos_defconfig             |  1 +
 arch/arm/include/asm/trusted_foundations.h    |  2 ++
 arch/arm/mach-at91/at91sam9260_devices.c      |  8 ++++----
 arch/arm/mach-exynos/firmware.c               | 15 ++++++++++++++-
 arch/arm/mach-imx/devices/platform-ipu-core.c |  2 +-
 arch/arm/mach-mvebu/mvebu-soc-id.c            | 13 ++++++++++++-
 arch/arm/mach-omap2/board-flash.c             |  2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c         |  3 ++-
 arch/arm/mach-omap2/cpuidle44xx.c             | 25 +++++++++++++++++++++----
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c    |  2 +-
 arch/arm/plat-omap/dma.c                      | 10 ++++++++++
 19 files changed, 93 insertions(+), 45 deletions(-)
