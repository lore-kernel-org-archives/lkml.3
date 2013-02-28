Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3B1WzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:55:20 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56599 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab3B1WzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:55:15 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 3/3] arm-soc: mvebu platform changes (rebased)
Date: Thu, 28 Feb 2013 14:54:53 -0800
Message-Id: <1362092093-4839-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1362092093-4839-1-git-send-email-olof@lixom.net>
References: <1362092093-4839-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains changes for the Marvell EBU platforms (mvebu,
orion, kirkwood, dove) that were not part of the first set of pull
requests because of dependencies on the MMC tree, and being submitted
a little late.

Notable changes are:

* More devices get moved out of board files into device tree
descriptions. The remaining devices listed in there have patches
that will get sent for 3.10, after which we can remove a lot of the
board files entirely. We are doing the pinctrl and mmc drivers here,
ethernet and PCI still remain.

* SMP support for mvebu is improved with support for the
local interrupt controller.

* The Guruplug board file gets replaced with a DT description.


----------------------------------------------------------------

The following changes since commit 280c50ec3b6e801b59311823fcd7d9c679354b6a:

  Merge tag 'late-omap' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/late-mvebu-rebased

for you to fetch changes up to 564991205956d869db0e45dfabe23a31b596fa15:

  arm: mvebu: enable the SD card slot on Armada 370 Reference Design board

----------------------------------------------------------------

Andrew Lunn (7):
      ARM: Kirkwood: Remove redundent USB clock alias
      ARM: Kirkwood: Remove redundent SDIO clock alias
      ARM: Kirkwood: Convert NSA310 to DT based regulators.
      ARM: Kirkwood: Convert NSA310 to use gpio-poweroff driver
      ARM: Kirkwood: Convert NSA310 I2C to device tree
      ARM: Kirkwood: Convert NS2 to gpio-poweroff.
      ARM: Kirkwood: topkick: Enable i2c bus.

Arnd Bergmann (3):
      Merge 'mmc/upstream' into late/mvebu2
      Merge branch 'timer/cleanup' into late/mvebu2
      ARM: Dove: split legacy and DT setup

Ezequiel Garcia (7):
      arm: mvebu: Update defconfig to select USB support
      ARM: mvebu: Update defconfig to select SPI support
      ARM: mvebu: Update defconfig to select SPI flash and MTD support
      arm: mvebu: Add support for USB host controllers in Armada 370/XP
      arm: mvebu: Enable USB controllers on Armada 370/XP boards
      arm: mvebu: Add support for SPI controller in Armada 370/XP
      arm: mvebu: Add SPI flash on Armada XP-GP board

Florian Fainelli (2):
      arm: mvebu: add DTS file for Marvell RD-A370-A1 board
      arm: mvebu: enable the SD card slot on Armada 370 Reference Design board

Gregory CLEMENT (12):
      arm: mvebu: Update defconfig with Marvell RTC support
      arm: mvebu: Improve the SMP support of the interrupt controller
      arm: mvebu: Add support for local interrupt
      clocksource: time-armada-370-xp: add local timer support
      arm: mvebu: update defconfig with local timer support
      arm: mvebu: support for the new Armada XP development board(DB-MV784MP-GP)
      arm: mvebu: update defconfig with ATAG support when using DT
      arm: mvebu: Add RTC support for Armada 370 and Armada XP
      arm: mvebu: update DT to support local timers
      clocksource: update and move armada-370-xp-timer documentation to timer directory
      arm: mvebu: Add SPI flash on Armada XP-DB board
      arm: mvebu: Add SPI flash on Armada 370 DB board

Jason Cooper (7):
      Merge tag 'tags/mvebu_fixes_for_v3.8-rc6' into mvebu/boards
      Merge tag 'tags/cleanup_for_v3.9_round2' into mvebu/boards
      Merge tag 'tags/drivers_for_v3.9' into mvebu/boards
      Merge commit 'd293875' into mvebu/boards
      ARM: kirkwood: topkick: convert to pinctrl
      ARM: kirkwood: nsa310: convert to pinctrl
      ARM: kirkwood: topkick: init mvsdio via DT

Nobuhiro Iwamatsu (3):
      ARM: Kirkwood: Add pinctrl of TWSI1 to 88f6282
      ARM: Kirkwood: Add pinctrl of NAND to 88f6282
      ARM: Kirkwood: Convert openblocks A6 board to pinctrl

Olof Johansson (1):
      ARM: dove: update dove_defconfig with a few useful options

Sebastian Hesselbarth (4):
      ARM: Dove: move CuBox led pinctrl to gpio-leds node
      ARM: Dove: add fixed regulator for CuBox USB power
      ARM: Dove: convert usb host controller to DT
      ARM: dove: convert serial DT nodes to clocks property

Thomas Petazzoni (16):
      mmc: mvsdio: implement a Device Tree binding
      arm: mvebu: enable SDIO support in mvebu_defconfig
      arm: mvebu: enable mwifiex driver in mvebu_defconfig
      arm: mvebu: enable btmrvl driver in mvebu_defconfig
      arm: mvebu: add LEDs support to defconfig file
      arm: mvebu: add DT information for the SDIO interface of Armada 370/XP
      arm: mvebu: add pin muxing options for the SDIO interface on Armada 370
      arm: mvebu: add pin muxing options for the SDIO interface on Armada XP
      arm: mvebu: enable the SD card slot on Armada XP DB board
      arm: mvebu: enable the SD card slot on Armada 370 DB board
      arm: mvebu: enable the SDIO interface on the Globalscale Mirabox
      arm: kirkwood: add Device Tree informations for the SDIO controller
      arm: kirkwood: dreamplug: use Device Tree to probe SDIO
      arm: kirkwood: mplcec4: use Device Tree to probe SDIO
      arm: kirkwood: add pinmux option for the SDIO interface on 88F6282
      arm: mvebu: add button for OpenBlocks AX3-4

Willy Tarreau (1):
      ARM: kirkwood: convert Guruplug Server Plus to use the device tree

 .../marvell,armada-370-xp-timer.txt}            |  11 +-
 arch/arm/boot/dts/Makefile                      |   3 +
 arch/arm/boot/dts/armada-370-db.dts             |  35 +++++
 arch/arm/boot/dts/armada-370-mirabox.dts        |  18 +++
 arch/arm/boot/dts/armada-370-rd.dts             |  68 +++++++++
 arch/arm/boot/dts/armada-370-xp.dtsi            |  49 +++++-
 arch/arm/boot/dts/armada-370.dtsi               |  21 +++
 arch/arm/boot/dts/armada-xp-db.dts              |  31 ++++
 arch/arm/boot/dts/armada-xp-gp.dts              | 113 ++++++++++++++
 arch/arm/boot/dts/armada-xp-mv78230.dtsi        |   6 +
 arch/arm/boot/dts/armada-xp-mv78260.dtsi        |   6 +
 arch/arm/boot/dts/armada-xp-mv78460.dtsi        |   6 +
 .../arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  18 +++
 arch/arm/boot/dts/armada-xp.dtsi                |  19 ++-
 arch/arm/boot/dts/dove-cubox.dts                |  28 +++-
 arch/arm/boot/dts/dove.dtsi                     |  24 ++-
 arch/arm/boot/dts/kirkwood-6282.dtsi            |  17 +++
 arch/arm/boot/dts/kirkwood-dreamplug.dts        |   7 +
 .../boot/dts/kirkwood-guruplug-server-plus.dts  |  94 ++++++++++++
 arch/arm/boot/dts/kirkwood-mplcec4.dts          |  11 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi      |   6 +
 arch/arm/boot/dts/kirkwood-nsa310.dts           | 126 ++++++++++++++++
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts    | 116 ++++++++++++++
 arch/arm/boot/dts/kirkwood-topkick.dts          | 102 +++++++++++++
 arch/arm/boot/dts/kirkwood.dtsi                 |   8 +
 arch/arm/configs/dove_defconfig                 |  28 +---
 arch/arm/configs/mvebu_defconfig                |  26 +++-
 arch/arm/mach-dove/Kconfig                      |   7 +
 arch/arm/mach-dove/Makefile                     |   4 +-
 arch/arm/mach-dove/board-dt.c                   |  92 ++++++++++++
 arch/arm/mach-dove/common.c                     |  85 -----------
 arch/arm/mach-kirkwood/Kconfig                  |   7 +
 arch/arm/mach-kirkwood/Makefile                 |   1 +
 arch/arm/mach-kirkwood/board-dreamplug.c        |   6 -
 arch/arm/mach-kirkwood/board-dt.c               |  16 +-
 arch/arm/mach-kirkwood/board-guruplug.c         |  39 +++++
 arch/arm/mach-kirkwood/board-mplcec4.c          |   7 -
 arch/arm/mach-kirkwood/board-ns2.c              |  14 --
 arch/arm/mach-kirkwood/board-nsa310.c           |  69 ---------
 arch/arm/mach-kirkwood/board-openblocks_a6.c    |  44 ------
 arch/arm/mach-kirkwood/board-usi_topkick.c      |  48 ------
 arch/arm/mach-kirkwood/common.h                 |  11 +-
 arch/arm/mach-mvebu/irq-armada-370-xp.c         |  87 ++++++++++-
 drivers/clocksource/time-armada-370-xp.c        | 150 ++++++++++++++-----
 44 files changed, 1314 insertions(+), 370 deletions(-)
 rename Documentation/devicetree/bindings/{arm/armada-370-xp-timer.txt => timer/marvell,armada-370-xp-timer.txt} (55%)
 create mode 100644 arch/arm/boot/dts/armada-370-rd.dts
 create mode 100644 arch/arm/boot/dts/armada-xp-gp.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
 create mode 100644 arch/arm/mach-dove/board-dt.c
 create mode 100644 arch/arm/mach-kirkwood/board-guruplug.c
