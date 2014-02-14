Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaBNVxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:53:15 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:42168 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaBNVxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:53:13 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: [GIT PULL] ARM: SoC: fixes for v3.14-rc3
Date: Fri, 14 Feb 2014 13:53:10 -0800
Message-ID: <7hlhxd5pkp.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following arm-soc fixes for v3.14-rc.  Thanks.

Kevin



The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 31fd8f5b89f22a88940a9838dfd1564f3d440247:

  dma: mv_xor: Silence a bunch of LPAE-related warnings (2014-02-12 16:21:17 -0800)

----------------------------------------------------------------
A collection of ARM SoC fixes for v3.14-rc1.

Mostly a collection of Kconfig, device tree data and compilation fixes
along with fix to drivers/phy that fixes a boot regression on some
Marvell mvebu platforms.

----------------------------------------------------------------
Andrew Lunn (3):
      drivers: phy: Make NULL a valid phy reference
      drivers: phy: Add support for optional phys
      ata: sata_mv: Fix probe failures with optional phys

Bo Shen (1):
      ARM: at91: enable USB host on at91sam9n12ek board

Boris BREZILLON (3):
      ARM: at91/dt: fix sama5d3 ohci hclk clock reference
      mmc: atmel-mci: document clock properties
      spi/atmel: document clock properties

Jean-Jacques Hiblot (1):
      ARM: at91/dt: sam9263: fix compatibility string for the I2C

Kevin Hilman (2):
      Merge tag 'mvebu-phy_ata-fixes-3.14' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes

Linus Walleij (3):
      ARM: pxa: fix compilation problem on AM300EPD board
      ARM: pxa: fix various compilation problems
      ARM: ux500: disable msp2 device tree node

Michal Simek (1):
      ARM: zynq: Reserve not DMAable space in front of the kernel

Nicolas Ferre (1):
      ARM: at91: add Atmel's SAMA5D3 Xplained board

Nishanth Menon (1):
      ARM: multi_v7_defconfig: Select CONFIG_SOC_DRA7XX

Olof Johansson (1):
      dma: mv_xor: Silence a bunch of LPAE-related warnings

Philipp Zabel (1):
      ARM: imx6: Initialize low-power mode early again

Rob Herring (3):
      ARM: hisi: fix kconfig warning on HAVE_ARM_TWD
      ARM: moxart: move DMA_OF selection to driver
      ARM: fix HAVE_ARM_TWD selection for OMAP and shmobile

 Documentation/devicetree/bindings/mmc/atmel-hsmci.txt |   5 ++
 Documentation/devicetree/bindings/spi/spi_atmel.txt   |   5 ++
 Documentation/phy.txt                                 |  26 +++++++---
 arch/arm/boot/dts/Makefile                            |   1 +
 arch/arm/boot/dts/at91-sama5d3_xplained.dts           | 229 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi                    |   2 +-
 arch/arm/boot/dts/at91sam9n12ek.dts                   |   4 ++
 arch/arm/boot/dts/sama5d3.dtsi                        |   2 +-
 arch/arm/boot/dts/ste-href.dtsi                       |   1 -
 arch/arm/configs/multi_v7_defconfig                   |   1 +
 arch/arm/mach-hisi/Kconfig                            |   2 +-
 arch/arm/mach-imx/clk-imx6q.c                         |   3 ++
 arch/arm/mach-imx/clk-imx6sl.c                        |   3 ++
 arch/arm/mach-imx/pm-imx6q.c                          |   2 -
 arch/arm/mach-moxart/Kconfig                          |   1 -
 arch/arm/mach-omap2/Kconfig                           |   2 +-
 arch/arm/mach-pxa/am300epd.c                          |   1 +
 arch/arm/mach-pxa/include/mach/balloon3.h             |   2 +
 arch/arm/mach-pxa/include/mach/corgi.h                |   1 +
 arch/arm/mach-pxa/include/mach/csb726.h               |   2 +
 arch/arm/mach-pxa/include/mach/gumstix.h              |   1 +
 arch/arm/mach-pxa/include/mach/idp.h                  |   1 +
 arch/arm/mach-pxa/include/mach/palmld.h               |   2 +
 arch/arm/mach-pxa/include/mach/palmt5.h               |   2 +
 arch/arm/mach-pxa/include/mach/palmtc.h               |   2 +
 arch/arm/mach-pxa/include/mach/palmtx.h               |   2 +
 arch/arm/mach-pxa/include/mach/pcm027.h               |   2 +
 arch/arm/mach-pxa/include/mach/pcm990_baseboard.h     |   1 +
 arch/arm/mach-pxa/include/mach/poodle.h               |   2 +
 arch/arm/mach-pxa/include/mach/spitz.h                |   2 +-
 arch/arm/mach-pxa/include/mach/tosa.h                 |   2 +
 arch/arm/mach-pxa/include/mach/trizeps4.h             |   2 +
 arch/arm/mach-shmobile/Kconfig                        |   2 +-
 arch/arm/mach-zynq/common.c                           |  14 ++++++
 drivers/ata/sata_mv.c                                 |   8 ++--
 drivers/dma/Kconfig                                   |   1 +
 drivers/dma/mv_xor.c                                  |  24 +++++-----
 drivers/phy/phy-core.c                                |  62 +++++++++++++++++++++++-
 include/linux/phy/phy.h                               |  14 ++++++
 39 files changed, 408 insertions(+), 33 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91-sama5d3_xplained.dts
