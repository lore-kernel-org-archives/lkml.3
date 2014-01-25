Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaAYSe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:34:29 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60098 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaAYSe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:34:28 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] pinctrl: mvebu: remove hardcoded addresses from Dove pinctrl
Date: Sat, 25 Jan 2014 19:34:05 +0100
Message-Id: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is one required step for Dove to hop into mach-mvebu.
Until now, pinctrl-dove was hardcoding some registers that do not
directly belong to MPP core registers. This is not compatible with
what we want for mach-mvebu.

This patch set removes all hardcoded addresses from pinctrl-dove
by either requesting additional resources or requesting a syscon
provided regmap for global config registers. As this changes existing
driver to DT binding relationship, all additional resources are
probed in a backward compatible way. If the corresponding resource
cannot be found, we derive it from the existing pinctrl resource
and warn about the old DTB firmware.

Patch 1 and 2 add or update binding documentation for dove, global
config syscon, and pinctrl-dove. The latter also documents missing reg
property requirement for other mvebu pinctrl nodes.

Patch 3 and 4 add the new pinctrl reg property values and global config
register syscon to exisiting dove.dtsi.

Patch 5 fixes a misdesign of common mvebu pinctrl driver, that
requested the resource instead of getting it from the SoC specific
driver stub.

Patches 6 and 7 now add requests to the new resources in a backward
compatible way, while patches 8-11 make use of those resources.

At the end, there is no more hardcoded addresses in pinctrl-dove.

The patch set is based on pre-v3.14-rc1 mainline. I suggest to take
this in as v3.15 stuff. Since more Dove/mach-mvebu related patches
will likely follow, Jason should prepare a topic branch for LinusW
to pull from?

It has been boot tested on Dove and compile tested only for Kirkwood,
Armada 370 and XP.

Sebastian Hesselbarth (11):
  devicetree: binding: add missing Marvell Dove SoC documentation
  devicetree: bindings: update MVEBU pinctrl binding documentation
  ARM: dove: add additional pinctrl registers
  ARM: dove: add global-config register node
  pinctrl: mvebu: fix misdesigned resource allocation
  pinctrl: mvebu: dove: request additional resources
  pinctrl: mvebu: dove: request syscon regmap for global registers
  pinctrl: mvebu: dove: use remapped mpp base registers
  pinctrl: mvebu: dove: use remapped mpp4 register
  pinctrl: mvebu: dove: use remapped pmu_mpp registers
  pinctrl: mvebu: dove: use global register regmap

 .../devicetree/bindings/arm/marvell,dove.txt       |  22 ++
 .../pinctrl/marvell,armada-370-pinctrl.txt         |   1 +
 .../bindings/pinctrl/marvell,armada-xp-pinctrl.txt |   1 +
 .../bindings/pinctrl/marvell,dove-pinctrl.txt      |   1 +
 .../bindings/pinctrl/marvell,kirkwood-pinctrl.txt  |   1 +
 .../bindings/pinctrl/marvell,mvebu-pinctrl.txt     |   2 +-
 arch/arm/boot/dts/dove.dtsi                        |  10 +-
 drivers/pinctrl/mvebu/Kconfig                      |   1 +
 drivers/pinctrl/mvebu/pinctrl-armada-370.c         |   9 +-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c          |   9 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c               | 298 +++++++++++++--------
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c           |  10 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c              |  14 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.h              |   2 +-
 14 files changed, 254 insertions(+), 127 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,dove.txt

---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.8.5.2

