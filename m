Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3GBLDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:03:54 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:58262 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab3GBLDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:03:52 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/7] ARM: mvebu: switch to DT probed irqchip and clocksource
Date: Tue,  2 Jul 2013 13:03:36 +0200
Message-Id: <1372763023-12374-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set converts Marvell Dove and Kirkwood DT enabled boards
to probe irqchip and clocksource by DT. The corresponding irqchip and
clocksource drivers have been taken by Thomas Gleixner and Daniel Lezcano
respectively. This patch set is based on next-20130701 plus tip/core and
timers/clockevents. Also, mv643xx_eth DT patches sent earlier are applied.

Unfortunately, the same compatible string is used by irqchip driver and
irq DT stub in plat-orion/irq.c while reg layout is different. This patch
set should be applied as a whole only, as device tree conversion breaks
kernel boot until the corresponding second patch is applied. As this set
is Marvell SoC related only, I suggest to take it all through Jason
Cooper's branch.

Patch set version has been bumped to v4, but this only contains the
remaining Marvell related patches. irqchip and clocksource drivers from
v3 have already been taken by the respective maintainers.

The first three patches convert Dove, Kirkwood, and Orion5x DT files to
the new reg layout. Patch 4 and 5 add the new clocksource and irqchip
nodes. Patch 6 also removes an obsolete clock gate workaround from
Kirkwood DT board setup. Patch 7 then updates the irq driver DT stub in
plat-orion/irq to reflect the changed reg layout. The irq driver DT stub
is still used on Orion5x until proper DT clk provider is available.

The patch set has been tested on Dove, and compile-tested on Kirkwood
and Orion5x defconfig.

Sebastian Hesselbarth (7):
  ARM: dove: move device tree nodes to DT irqchip and clocksource
  ARM: kirkwood: move device tree nodes to DT irqchip and clocksource
  ARM: orion5x: update intc device tree node to new reg layout
  ARM: dove: convert to DT irqchip and clocksource
  ARM: kirkwood: convert to DT irqchip and clocksource
  ARM: kirkwood: remove obsolete SDIO clock gate workaround
  ARM: plat-orion: add reg offset to DT irq driver stub

 arch/arm/boot/dts/dove.dtsi       |   21 +++++++++++++++++++--
 arch/arm/boot/dts/kirkwood.dtsi   |   35 +++++++++++++++++++++++++++--------
 arch/arm/boot/dts/orion5x.dtsi    |    5 +++--
 arch/arm/mach-dove/Kconfig        |    2 ++
 arch/arm/mach-dove/Makefile       |    4 ++--
 arch/arm/mach-dove/board-dt.c     |   23 ++++++++++++++++-------
 arch/arm/mach-kirkwood/Kconfig    |   22 ++++++++++++++++++++++
 arch/arm/mach-kirkwood/Makefile   |    4 ++--
 arch/arm/mach-kirkwood/board-dt.c |   28 +++++++++++++++++-----------
 arch/arm/plat-orion/irq.c         |    2 +-
 10 files changed, 111 insertions(+), 35 deletions(-)

---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.2.5

