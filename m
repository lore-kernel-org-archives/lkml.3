Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3ILUBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:01:49 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54404 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab3ILUBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:01:46 -0400
Date: Thu, 12 Sep 2013 13:01:10 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.12-rc
Message-ID: <20130912200110.GA31255@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 640414171818c6293c23e74a28d1c69b2a1a7fe5:

  Merge tag 'late-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2013-09-09 16:35:29 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to f7ec00b3a5e6c18be350ce44dd8c03b36a8fda02:

  ARM: dts: sun7i: olinuxino-micro: Enable the EMAC (2013-09-12 12:22:48 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.12

A small batch of fixes that have trickled in over the last week of the
merge window.

Also included are few small devicetree updates for sunxi, since it
enables me to use one of their newer boards (cubieboard2) for additional
test coverage. The support for that SoC is new for 3.12, so there's no
exposure to new regressions due to it.

----------------------------------------------------------------
Maxime Ripard (4):
      ARM: dts: sun7i: Enable the Ethernet in the A20
      ARM: dts: sun7i: Add the muxing options for the EMAC
      ARM: dts: sun7i: cubieboard2: Enable the EMAC
      ARM: dts: sun7i: olinuxino-micro: Enable the EMAC

Nicolas Pitre (1):
      ARM: vexpress: allow dcscb and tc2_pm in a combined ARMv6+v7 build

Olof Johansson (5):
      ARM: pxa: ssp: Check return values from phandle lookups
      Merge tag 'renesas-fixes3-for-v3.12' of git://git.kernel.org/.../horms/renesas into fixes
      Merge branch 'versatile/fixes' into fixes
      i2c: davinci: Fix bad dev_get_platdata() conversion
      Merge tag 'ep93xx-fixes-for-3.12' of git://github.com/RyanMallon/linux-ep93xx into fixes

Peter Maydell (3):
      ARM: PCI: versatile: Fix map_irq function to match hardware
      ARM: PCI: versatile: Fix PCI I/O
      ARM: PCI: versatile: Fix SMAP register offsets

Petr Štetiar (1):
      ARM: ep93xx: Don't use modem interface on the second UART

Simon Horman (2):
      ARM: shmobile: r8a7779: Update early timer initialisation order
      ARM: shmobile: lager: Do not use register_type field of struct sh_eth_plat_data

 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts     | 15 ++++++++
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts | 15 ++++++++
 arch/arm/boot/dts/sun7i-a20.dtsi                | 27 ++++++++++++++
 arch/arm/mach-ep93xx/core.c                     |  2 +-
 arch/arm/mach-shmobile/board-lager.c            |  1 -
 arch/arm/mach-shmobile/setup-r8a7779.c          |  2 +-
 arch/arm/mach-versatile/include/mach/platform.h |  2 ++
 arch/arm/mach-versatile/pci.c                   | 47 ++++++++++++++++---------
 arch/arm/mach-vexpress/Makefile                 |  2 ++
 arch/arm/plat-pxa/ssp.c                         | 18 +++++++---
 drivers/i2c/busses/i2c-davinci.c                |  2 +-
 11 files changed, 108 insertions(+), 25 deletions(-)
