Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaBWTiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 14:38:16 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60832 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaBWTiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 14:38:14 -0500
Date: Sun, 23 Feb 2014 11:38:17 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for v3.14-rc
Message-ID: <20140223193817.GA25097@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to a3db2bba6d1933a1398357ba6728c743bdab03e1:

  MAINTAINERS: add additional ARM BCM281xx/BCM11xxx maintainer (2014-02-23 05:57:03 -0800)

----------------------------------------------------------------
ARM: SoC fixes for 3.14-rc

A collection of fixes for ARM platforms. Most are for DTS file fixups.

- DT conversion on OMAP which is still finding a few issues here and
  there, but there's also a split of some of Gumstix Overo into 35xx and
  36xx platforms -- keeping them common was more hassle than splitting
  into separate DTs.

- There's a couple of small stale code removal patches that we usually
  queue for the next release instead, but they seemed harmless enough to
  bring in now.

- Also, a fix for backlight on some PXA platforms, and a cache configuration
  fix for Tegra, etc.

----------------------------------------------------------------
Aaro Koskinen (3):
      ARM: OMAP1: nokia770: enable tahvo-usb
      ARM: dts: N9/N950: fix boot hang with 3.14-rc1
      ARM: dts: N900: add missing compatible property

Florian Vaussard (4):
      ARM: dts: omap3-tobi: Fix boot with OMAP36xx-based Overo
      ARM: dts: omap3-tobi: Use the correct vendor prefix
      ARM: dts: Add support for both OMAP35xx and OMAP36xx Overo/Tobi
      Documentation: dt: OMAP: Update Overo/Tobi

Jason Cooper (1):
      ARM: dove: dt: revert PMU interrupt controller node

Marek Belisko (2):
      ARM: dts: omap3-gta04: Add EOC irq gpio line handling.
      ARM: dts: omap3-gta04: Fix mmc1 properties.

Matt Porter (1):
      MAINTAINERS: add additional ARM BCM281xx/BCM11xxx maintainer

NeilBrown (1):
      ARM: dts: omap3-gta04: Fix 'aux' gpio key flags.

Nishanth Menon (1):
      ARM: OMAP2+: add missing ARCH_HAS_OPP

Olof Johansson (3):
      Merge tag 'pwm_pxa_for_v3.14' of https://git.kernel.org/.../hzhuang1/linux into fixes
      Merge tag 'omap-for-v3.14/fixes-against-rc1' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'mvebu-dt-fixes-3.14' of git://git.infradead.org/linux-mvebu into fixes

Paul Bolle (2):
      ARM: OMAP2+: Remove MACH_NOKIA_N800
      ARM: OMAP2+: Remove legacy macros for zoom platforms

Pekon Gupta (2):
      ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when MTD_NAND is built as module
      ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when MTD_ONENAND is built as module

Peter Ujfalusi (2):
      ARM: DTS: am335x-evmsk: Correct audio clock frequency
      ARM: dts: am335x-evmsk: Fix mmc1 support

Shawn Guo (1):
      ARM: imx6: build pm-imx6q.c independently of CONFIG_PM

Stephen Warren (2):
      ARM: tegra: fix RTC0 alias for Cardhu
      ARM: tegra: only run PL310 init on systems with one

Thierry Reding (2):
      ARM: pxa: Add dummy backlight power supply on Mitac Mio A701
      ARM: tegra: Add head numbers to display controllers

Willy Tarreau (1):
      ARM: mvebu: dt: add missing alias 'eth3' on Armada XP mv78260

 .../devicetree/bindings/arm/omap/omap.txt          |  2 +-
 MAINTAINERS                                        |  1 +
 arch/arm/boot/dts/Makefile                         |  3 ++-
 arch/arm/boot/dts/am335x-evmsk.dts                 | 11 ++++++++++-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |  3 ++-
 arch/arm/boot/dts/dove.dtsi                        | 11 -----------
 arch/arm/boot/dts/omap3-gta04.dts                  |  6 ++++--
 arch/arm/boot/dts/omap3-n9.dts                     |  2 +-
 arch/arm/boot/dts/omap3-n900.dts                   |  4 ++--
 arch/arm/boot/dts/omap3-n950.dts                   |  2 +-
 arch/arm/boot/dts/omap3-overo-storm-tobi.dts       | 22 ++++++++++++++++++++++
 ...omap3-tobi.dts => omap3-overo-tobi-common.dtsi} |  3 ---
 arch/arm/boot/dts/omap3-overo-tobi.dts             | 22 ++++++++++++++++++++++
 arch/arm/boot/dts/omap3-overo.dtsi                 |  3 ---
 arch/arm/boot/dts/tegra114.dtsi                    |  4 ++++
 arch/arm/boot/dts/tegra20.dtsi                     |  4 ++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |  2 +-
 arch/arm/boot/dts/tegra30.dtsi                     |  4 ++++
 arch/arm/mach-imx/Makefile                         |  2 --
 arch/arm/mach-imx/common.h                         |  4 +---
 arch/arm/mach-omap1/board-nokia770.c               |  1 +
 arch/arm/mach-omap2/Kconfig                        |  8 ++++----
 arch/arm/mach-omap2/gpmc.c                         |  4 ++--
 arch/arm/mach-omap2/io.c                           |  9 ---------
 arch/arm/mach-pxa/mioa701.c                        |  9 +++++++++
 arch/arm/mach-tegra/tegra.c                        | 10 ++++++++++
 26 files changed, 108 insertions(+), 48 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap3-overo-storm-tobi.dts
 rename arch/arm/boot/dts/{omap3-tobi.dts => omap3-overo-tobi-common.dtsi} (94%)
 create mode 100644 arch/arm/boot/dts/omap3-overo-tobi.dts
