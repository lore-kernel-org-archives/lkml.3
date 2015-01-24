Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbbAXXTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 18:19:32 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59160 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbAXXTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 18:19:30 -0500
Date: Sat, 24 Jan 2015 15:19:30 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes
Message-ID: <20150124231930.GA19897@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 966903a98fd80ae5f5c4a7ca121d36ea0ba23143:

  Merge tag 'samsung-fixes-3.19' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2015-01-16 19:11:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/armsoc-for-linus

for you to fetch changes up to 4b3415c9363f828e7f1e45edecb57930849d5d5b:

  Merge tag 'imx-fixes-3.19-2' of git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux into fixes (2015-01-23 14:23:40 -0800)

----------------------------------------------------------------
ARM: SoC fixes

A week's worth of fixes for various ARM platforms. Diff wise, the
largest fix is for OMAP to deal with how GIC now registers interrupts
(irq_domain_add_legacy() -> irq_domain_add_linear() changes).

Besides this, a few more renesas platforms needed the GIC instatiation
done for legacy boards. There's also a fix that disables coherency of
mvebu due to issues, and a few other smaller fixes.

----------------------------------------------------------------
Andrew Lunn (1):
      bus: mvebu-mbus: fix support of MBus window 13

Fabio Estevam (1):
      ARM: dts: imx25: Fix PWM "per" clocks

Felipe Balbi (1):
      arm: boot: dts: dra7: enable dwc3 suspend PHY quirk

Magnus Damm (2):
      ARM: shmobile: r8a7778: Instantiate GIC from C board code in legacy builds
      ARM: shmobile: r8a7779: Instantiate GIC from C board code in legacy builds

Marc Zyngier (1):
      ARM: OMAP: Work around hardcoded interrupts

Olof Johansson (5):
      Merge tag 'mvebu-fixes-3.19-3' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'omap-for-v3.19/gic-regression-v2' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'renesas-soc-fixes2-for-v3.19' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'mvebu-fixes-3.19-4' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'imx-fixes-3.19-2' of git://git.kernel.org/.../shawnguo/linux into fixes

Robin Murphy (1):
      arm64: dts: add baud rate to Juno stdout-path

Thomas Petazzoni (1):
      ARM: mvebu: completely disable hardware I/O coherency

 arch/arm/boot/dts/dra7.dtsi                |  6 ++++++
 arch/arm/boot/dts/imx25.dtsi               |  8 ++++----
 arch/arm/mach-mvebu/coherency.c            |  7 ++++++-
 arch/arm/mach-omap2/common.h               |  1 +
 arch/arm/mach-omap2/omap4-common.c         | 32 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod.c           | 10 ++++++++--
 arch/arm/mach-omap2/omap_hwmod.h           |  1 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  5 +++++
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c |  1 +
 arch/arm/mach-omap2/prcm-common.h          |  1 +
 arch/arm/mach-omap2/prm44xx.c              |  5 ++++-
 arch/arm/mach-omap2/prm_common.c           | 14 +++++++++++--
 arch/arm/mach-omap2/twl-common.c           |  7 ++++++-
 arch/arm/mach-shmobile/setup-r8a7778.c     |  9 ++++++++-
 arch/arm/mach-shmobile/setup-r8a7779.c     |  9 ++++++++-
 arch/arm64/boot/dts/arm/juno.dts           |  2 +-
 drivers/bus/mvebu-mbus.c                   | 13 ++++++++++++
 17 files changed, 117 insertions(+), 14 deletions(-)
