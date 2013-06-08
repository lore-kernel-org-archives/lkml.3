Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3FHRrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 13:47:22 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61568 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3FHRrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 13:47:20 -0400
Date: Sat, 8 Jun 2013 10:47:23 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.10-rc
Message-ID: <20130608174723.GA12346@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 090878aa951628143f40a1acc19ec074a5ae9200:

  Merge tag 'mxs-fixes-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes (2013-06-07 18:19:40 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.10-rc

Another week, another batch of fixes for arm-soc platforms.

Nothing controversial here, a handful of fixes for regressions and/or
serious problems across several of the platforms. Things are slowing
down nicely on fix rates for 3.10.

----------------------------------------------------------------
Andrew Lunn (1):
      ARM: Kirkwood: TS219: Fix crash by double PCIe instantiation

Anson Huang (1):
      ARM: imx: clk-imx6q: AXI clock select index is incorrect

Doug Anderson (1):
      ARM: exynos: add debug_ll_io_init() call in exynos_init_io()

Jiada Wang (1):
      ARM i.MX6q: fix for ldb_di_sels

Jonas Andersson (1):
      ARM: dts: imx: fix clocks for cspi

Jongsung Kim (1):
      ARM: bcm2835: override the HW UART periphid

Laurent Pinchart (1):
      sh-pfc: r8a7779: Don't group USB OVC and PENC pins

Lee Jones (2):
      ARM: ux500: Only configure wake-up reasons on ux500 based platforms
      ARM: ux500: Provide supplies for AUX1, AUX2 and AUX3

Markus Pargmann (1):
      ARM: mxs: icoll: Fix interrupts gpio bank 0

Nadav Haklai (1):
      ARM: mvebu: Fix bug in coherency fabric low level init function

Olof Johansson (5):
      Merge tag 'fixes-3.10-3' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'ux500-arm-soc-v3.10-fixes-2' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge tag 'renesas-fixes-for-v3.10' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'imx-fixes-3.10-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'mxs-fixes-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes

Simon Horman (1):
      ARM: shmobile: sh73a0: Update CMT clockevent rating to 80

Tushar Behera (1):
      ARM: EXYNOS: uncompress - print debug messages if DEBUG_LL is defined

 arch/arm/boot/dts/bcm2835.dtsi                  |  1 +
 arch/arm/boot/dts/imx25.dtsi                    | 12 +++----
 arch/arm/boot/dts/imx27.dtsi                    |  6 ++--
 arch/arm/boot/dts/imx51.dtsi                    |  2 +-
 arch/arm/boot/dts/imx53.dtsi                    |  2 +-
 arch/arm/mach-exynos/common.c                   |  2 ++
 arch/arm/mach-imx/clk-imx6q.c                   |  4 +--
 arch/arm/mach-kirkwood/board-ts219.c            | 10 ------
 arch/arm/mach-mvebu/coherency_ll.S              | 16 ++++++---
 arch/arm/mach-shmobile/setup-sh73a0.c           |  2 +-
 arch/arm/mach-ux500/board-mop500-regulators.c   |  3 ++
 arch/arm/mach-ux500/cpuidle.c                   |  4 +++
 arch/arm/plat-samsung/include/plat/uncompress.h | 10 +++++-
 drivers/irqchip/irq-mxs.c                       | 14 +++-----
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c            | 45 ++++++++++++++++++++-----
 15 files changed, 84 insertions(+), 49 deletions(-)
