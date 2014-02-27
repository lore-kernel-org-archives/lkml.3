Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaB0V2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:28:20 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:39864 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaB0V2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:28:17 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] ARM: dove: move Dove DT to MVEBU
Date: Thu, 27 Feb 2014 22:28:01 +0100
Message-Id: <1393536486-3827-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to DT conversion effort, Marvell Dove with DT support is now
ready to leave mach-dove and hop into mach-mvebu. As discussed with
MVEBU maintainers, we first add dove.c now and keep on migrating
it with Armada 3xx SoCs the next cycle.

Patch 1 adds a DT node for the system controller found on Marvell
MVEBU SoCs.

Patch 2 copies an approach taken by Andrew Lunn for Kirkwood-to-MVEBU
patches, that add MACH_DOVE for Dove in mach-mvebu to distinguish it
from ARCH_DOVE in mach-dove, where drivers still support both non-DT
and DT.

Patch 3 then moves mach-dove/board-dt.c to mach-mvebu/dove.c with
minor cleanups and converts drivers/phy/Kconfig to MACH_DOVE for
a DT-only driver.

Patch 4 finally adds MACH_DOVE and some of its drivers to multi_v7
defconfig.

The patches are based on v3.14-rc4, recently posted mvebu/pinctrl-cleanup
and mvebu/pinctrl-dove branches: v3.14-rc4 is required for a irqchip
driver fix when SPARSE_IRQ is set, the pinctrl branches remove hard-coded
addresses from Dove's pinctrl driver.

An unstable branch with above dependencies met, is available at

https://github.com/shesselba/linux-dove.git unstable/dove-mvebu-for-3.15_v1

Sebastian Hesselbarth (4):
  ARM: dove: add system controller node
  ARM: dove: prepare new Dove DT Kconfig variable
  ARM: mvebu: move DT Dove to MVEBU
  ARM: add Marvell Dove and some drivers to multi_v7 defconfig

 arch/arm/boot/dts/Makefile                           | 12 ++++++------
 arch/arm/boot/dts/dove.dtsi                          |  5 +++++
 arch/arm/configs/multi_v7_defconfig                  |  4 ++++
 arch/arm/mach-dove/Kconfig                           | 12 ------------
 arch/arm/mach-dove/Makefile                          |  1 -
 arch/arm/mach-mvebu/Kconfig                          | 12 ++++++++++++
 arch/arm/mach-mvebu/Makefile                         |  1 +
 arch/arm/{mach-dove/board-dt.c => mach-mvebu/dove.c} | 20 ++++++++------------
 drivers/mmc/host/Kconfig                             |  2 +-
 drivers/phy/Kconfig                                  |  2 +-
 drivers/thermal/Kconfig                              |  2 +-
 drivers/watchdog/Kconfig                             |  2 +-
 sound/soc/kirkwood/Kconfig                           |  2 +-
 13 files changed, 41 insertions(+), 36 deletions(-)
 rename arch/arm/{mach-dove/board-dt.c => mach-mvebu/dove.c} (61%)

---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.8.5.3

