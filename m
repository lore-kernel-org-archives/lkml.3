Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaGETtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:49:12 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59634 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaGETtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:49:10 -0400
Date: Sat, 5 Jul 2014 12:49:30 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.16-rc
Message-ID: <20140705194930.GA26880@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 6c9d16178870315846faa1f59697b801e3fe0531:

  Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes (2014-06-25 20:27:15 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to bc6aa56680b07984dc1443ef1a5a1a0fac0e20be:

  MAINTAINERS: Add few more Keystone drivers (2014-07-04 21:53:13 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.16-rc

This week's arm-soc fixes:

- A set of of OMAP patches that we had missed Tony's pull request of:
  - Reset fix for am43xx
  - Proper OPP table for omap5
  - Fix for SoC detection of one of the DRA7 SoCs
  - hwmod updates to get SATA and OCP to work on omap5 (drivers merged in 3.16)
  - ... plus a handful of smaller fixes
- sunxi needed to re-add machine specific restart code that was removed in
  anticipation of a watchdog driver being merged for 3.16, and it didn't make
  it in.
- Marvell fixes for PCIe on SMP and a big-endian fix.
- A trivial defconfig update to make my capri test board boot with
  bcm_defconfig again.

... and a couple of MAINTAINERS updates, one to claim new Keystone
drivers that have been merged, and one to merge MXS and i.MX (both
Freescale platforms).

The largest diffs come from the hwmod code for omap5 and the re-add of
the restart code on sunxi. The hwmod stuff is quite late at this point
but it slipped through cracks repeatedly while coming up the maintainer
chain and only affects the one SoC so risk is low.

----------------------------------------------------------------
Brian Norris (1):
      ARM: OMAP2+: drop unused function

Dave Gerlach (1):
      ARM: OMAP2+: hwmod: Change hardreset soc_ops for AM43XX

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code

George Cherian (1):
      ARM: dts: am43x-epos-evm: Add Missing cpsw-phy-sel for am43x-epos-evm

Keshava Munegowda (1):
      ARM: OMAP5: hwmod: Add ocp2scp3 and sata hwmods

Maxime Ripard (1):
      ARM: sunxi: Reintroduce the restart code for A10/A20 SoCs

Nishanth Menon (2):
      ARM: DRA722: add detection of SoC information
      ARM: dts: omap5: Update CPU OPP table as per final production Manual

Olof Johansson (3):
      ARM: bcm: Fix bcm and multi_v7 defconfigs
      Merge tag 'omap-for-v3.16/fixes-against-rc1' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'mvebu-fixes-3.16-2' of git://git.infradead.org/linux-mvebu into fixes

Peter Ujfalusi (1):
      ARM: DTS: dra7/dra7xx-clocks: ATL related changes

Santosh Shilimkar (1):
      MAINTAINERS: Add few more Keystone drivers

Shawn Guo (1):
      MAINTAINERS: merge MXS entry into IMX one

Sourav Poddar (1):
      ARM: dts: dra7-evm: remove interrupt binding

Thomas Petazzoni (3):
      ARM: mvebu: move Armada 375 external abort logic as a quirk
      ARM: mvebu: update L2/PCIe deadlock workaround after L2CC cleanup
      ARM: mvebu: fix cpuidle implementation to work on big-endian systems

Tony Lindgren (2):
      ARM: dts: Enable twl4030 off-idle configuration for selected omaps
      Merge tag 'for-v3.16-rc/omap-fixes-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.16/fixes

 MAINTAINERS                                | 34 +++++++++----
 arch/arm/boot/dts/am43x-epos-evm.dts       |  4 ++
 arch/arm/boot/dts/dra7.dtsi                | 12 ++++-
 arch/arm/boot/dts/dra7xx-clocks.dtsi       | 16 +++----
 arch/arm/boot/dts/omap3-beagle-xm.dts      |  6 +++
 arch/arm/boot/dts/omap3-evm-common.dtsi    |  7 +++
 arch/arm/boot/dts/omap3-n900.dts           |  5 ++
 arch/arm/boot/dts/omap5.dtsi               |  1 -
 arch/arm/configs/bcm_defconfig             |  2 +-
 arch/arm/configs/multi_v7_defconfig        |  3 +-
 arch/arm/mach-mvebu/Makefile               |  2 +-
 arch/arm/mach-mvebu/board-v7.c             | 29 +++++++----
 arch/arm/mach-mvebu/pmsu.c                 |  9 +---
 arch/arm/mach-mvebu/pmsu_ll.S              | 25 ++++++++++
 arch/arm/mach-omap2/Makefile               |  6 ++-
 arch/arm/mach-omap2/cm33xx.h               |  2 +-
 arch/arm/mach-omap2/common.h               |  1 -
 arch/arm/mach-omap2/id.c                   | 12 +++++
 arch/arm/mach-omap2/mux.c                  |  6 ++-
 arch/arm/mach-omap2/omap4-common.c         | 20 --------
 arch/arm/mach-omap2/omap_hwmod.c           |  6 +--
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c | 73 ++++++++++++++++++++++++++++
 arch/arm/mach-omap2/soc.h                  |  1 +
 arch/arm/mach-sunxi/sunxi.c                | 77 ++++++++++++++++++++++++++++++
 24 files changed, 292 insertions(+), 67 deletions(-)
 create mode 100644 arch/arm/mach-mvebu/pmsu_ll.S
