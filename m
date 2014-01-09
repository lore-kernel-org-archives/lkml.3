Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaAIIy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:54:57 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53305 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaAIIyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:54:53 -0500
Date: Thu, 9 Jan 2014 00:52:51 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.13
Message-ID: <20140109085251.GA30534@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 7c06abcb16e1a03270f70725d0c62e8cf818cf48:

  Merge tag 'renesas-fixes3-for-v3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into fixes (2014-01-02 11:00:49 -0800)

----------------------------------------------------------------

ARM: SoC fixes for 3.13-rc

Hopefully the last set of arm-soc fixes for 3.13, or at least only a
few stray patches after this.

There are a few fixes for Renesas platforms to fixup DMA masks (this
started causing errors once the DMA API added checks for valid masks in
3.13). Two more dealing with resources for MMC and PWM setup.

There's also a few TI/OMAP/DRA fixes for smaller stuff and a fix for
compilation failures on a PXA platform.

----------------------------------------------------------------
Ben Dooks (1):
      ARM: shmobile: r8a7790: fix shdi resource sizes

Kuninori Morimoto (1):
      ARM: shmobile: bockw: fixup DMA mask

Laurent Pinchart (4):
      ARM: shmobile: armadillo: Add PWM backlight power supply
      ARM: shmobile: armadillo: Fix coherent DMA mask
      ARM: shmobile: kzm9g: Fix coherent DMA mask
      ARM: shmobile: mackerel: Fix coherent DMA mask

Linus Walleij (1):
      ARM: pxa: fix USB gadget driver compilation regression

Olof Johansson (3):
      Merge tag 'renesas-fixes2-for-v3.13' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'omap-for-v3.13/intc-ldp-fix' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'renesas-fixes3-for-v3.13' of git://git.kernel.org/.../horms/renesas into fixes

Rajendra Nayak (1):
      ARM: DRA7: hwmod: Fix boot crash with DEBUG_LL

Suman Anna (1):
      ARM: OMAP2+: hwmod_data: fix missing OMAP_INTC_START in irq data

Tony Lindgren (2):
      ARM: OMAP2+: Fix LCD panel backlight regression for LDP legacy booting
      Merge tag 'for-v3.13-rc/hwmod-fixes-b' of git://git.kernel.org/.../pjw/omap-pending into debug-ll-and-ldp-backlight-fix

 arch/arm/boot/dts/r8a7790.dtsi                     |  4 ++--
 arch/arm/mach-omap2/board-ldp.c                    |  7 ++++++-
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |  4 ++--
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  6 +++---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  2 +-
 arch/arm/mach-pxa/include/mach/lubbock.h           |  2 ++
 arch/arm/mach-shmobile/board-armadillo800eva.c     | 11 +++++++++--
 arch/arm/mach-shmobile/board-bockw.c               |  2 +-
 arch/arm/mach-shmobile/board-kzm9g.c               |  2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |  4 ++--
 10 files changed, 29 insertions(+), 15 deletions(-)
