Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaKIHJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 02:09:40 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57217 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaKIHJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 02:09:39 -0500
Date: Sat, 8 Nov 2014 23:09:37 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.18-rc4
Message-ID: <20141109070937.GA8754@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/armsoc-for-rc4

for you to fetch changes up to 92c9e0c780e61f821ab8a08f0d4d4fd33ba1197c:

  ARM: dts: zynq: Enable PL clocks for Parallella (2014-11-08 16:57:44 -0800)

----------------------------------------------------------------
ARM: SoC fixes for 3.18-rc4

Another quiet week:

- A fix to silence edma probe error on non-supported platforms from Arnd
- A fix to enable the PL clock for Parallella, to make mainline usable with
  the SDK.
- A somewhat verbose fix for the PLL clock tree on VF610
- Enabling of SD/MMC on one of the VF610-based boards (for testing)
- A fix for i.MX where CONFIG_SPI used to be implicitly enabled and now needs
  to be added to the defconfig instead
- Another maintainer added for bcm2835: Lee Jones

----------------------------------------------------------------
Andreas Färber (1):
      ARM: dts: zynq: Enable PL clocks for Parallella

Arnd Bergmann (1):
      dma: edma: move device registration to platform code

Fabio Estevam (1):
      ARM: imx: Fix the removal of CONFIG_SPI option

Olof Johansson (2):
      Merge tag 'imx-fixes-3.18-2' of git://git.kernel.org/.../shawnguo/linux into fixes
      ARM: dts: vf610: add SD node to cosmic dts

Stefan Agner (1):
      ARM: imx: clk-vf610: define PLL's clock tree

Stephen Warren (1):
      MAINTAINERS: update bcm2835 entry

 MAINTAINERS                             |   3 +-
 arch/arm/boot/dts/vf610-cosmic.dts      |  19 +++++
 arch/arm/boot/dts/zynq-parallella.dts   |   4 +
 arch/arm/common/edma.c                  |   9 +++
 arch/arm/configs/imx_v4_v5_defconfig    |   1 +
 arch/arm/configs/imx_v6_v7_defconfig    |   1 +
 arch/arm/mach-imx/clk-vf610.c           | 134 ++++++++++++++++++++++----------
 drivers/dma/edma.c                      |  40 +---------
 include/dt-bindings/clock/vf610-clock.h |  39 ++++++++--
 9 files changed, 160 insertions(+), 90 deletions(-)
