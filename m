Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3G2McH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:32:07 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:51388 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3G2McE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:32:04 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ARM: dove: switch to DT MBus
Date: Mon, 29 Jul 2013 14:31:49 +0200
Message-Id: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set converts DT based Dove boards to DT probed MBus to be
introduced with v3.12.

The first two patches prepare Dove DT nodes for MBus ID remapping by using
preprocessor includes and adding the MBUS_ID macro. The third patch adds a
MBus DT node to Dove SoC dtsi with required ranges for internal MBus and
AXI registers, and PCIe mem and I/O apertures. The forth patch relocates
the nodes for the internal devices to the new MBus node. Also, internal-regs
ranges are updated to allow proper translation of MBus children's reg
properties. Finally, legacy MBus init is replaced by DT based MBus init
for DT based Dove.

The patch set depends on the MBus device tree patches that should appear
in v3.12. Currently, it is based on v3.11-rc2 with Dove DT cleanup patches
and MBus patch set v8 applied.

The patch set is _not_ sent to devicetree mainling list, because the MBus
binding will be discussed there on the MBus patches itself.

Sebastian Hesselbarth (5):
  ARM: dove: use preprocessor on device tree files
  ARM: dove: add MBUS_ID macro to Dove DT
  ARM: dove: add MBus DT node
  ARM: dove: relocate internal registers device nodes
  ARM: dove: switch to DT probed mbus address windows

 arch/arm/boot/dts/dove-cm-a510.dts |    2 +-
 arch/arm/boot/dts/dove-cubox.dts   |    2 +-
 arch/arm/boot/dts/dove-d2plug.dts  |    2 +-
 arch/arm/boot/dts/dove-dove-db.dts |    2 +-
 arch/arm/boot/dts/dove.dtsi        |  958 ++++++++++++++++++------------------
 arch/arm/mach-dove/board-dt.c      |   10 +-
 6 files changed, 491 insertions(+), 485 deletions(-)

---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4

