Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3FFQ1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:27:42 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58964 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3FFQ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:27:38 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Marvell Orion SoC irqchip and clocksource
Date: Thu,  6 Jun 2013 18:27:08 +0200
Message-Id: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces DT-aware irqchip and clocksource drivers for
Marvell Orion SoCs (Kirkwood, Dove, Orion5x, MV78x00) and corresponding
patches for Dove and Kirkwood to enable them for DT-boards.

The irqchip driver, of course, depends on Thomas Gleixner's work on
irqdomain support for generic chip (tip irq/core).

The ARM part of this patch set has a quite ridiculuous dependency havoc
of mv643xx_eth DT support (current net-next) that will add to both irqchip
and clocksource branches respectively. Therefore, I suggest that irq
and clocksource maintainers take in the mere drivers (Patches 1+2) and
Jason Cooper handles the remaining patches when all three drivers have
surfaced on mainline linux.

I prepared a branch for anyone to test on Kirkwood and Dove which takes
care of the above dependencies based on v3.10-rc4 plus tip irq/core,
net-next, and arm-soc for-next (I know it is unstable but contains latest
mvebu related patches already). When Thomas, John, and Jason agree the
dependencies will vanish and only Jason has to take care of ARM patches
for enabling DT-based mv643xx_eth, irqchip, and clocksource.

The branch can be found at

git://github.com/shesselba/linux-dove.git orion-irqchip-for-v3.11

and has been tested on Dove/CuBox and compile tested for Kirkwood.

Sebastian Hesselbarth (6):
  irqchip: add support for Marvell Orion SoCs
  clocksource: add Marvell Orion SoC timer
  ARM: dove: move device tree nodes to DT irqchip and clocksource
  ARM: kirkwood: move device tree nodes to DT irqchip and clocksource
  ARM: dove: convert to DT irqchip and clocksource
  ARM: kirkwood: convert to DT irqchip and clocksource

 .../interrupt-controller/marvell,orion-intc.txt    |   48 +++++
 .../bindings/timer/marvell,orion-timer.txt         |   17 ++
 arch/arm/boot/dts/dove.dtsi                        |   21 ++-
 arch/arm/boot/dts/kirkwood.dtsi                    |   35 +++-
 arch/arm/mach-dove/Kconfig                         |    2 +
 arch/arm/mach-dove/Makefile                        |    4 +-
 arch/arm/mach-dove/board-dt.c                      |   23 ++-
 arch/arm/mach-kirkwood/Kconfig                     |   24 +++
 arch/arm/mach-kirkwood/Makefile                    |    4 +-
 arch/arm/mach-kirkwood/board-dt.c                  |   28 ++-
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/time-orion.c                   |  143 +++++++++++++++
 drivers/irqchip/Kconfig                            |    5 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-orion.c                        |  193 ++++++++++++++++++++
 16 files changed, 522 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt
 create mode 100644 Documentation/devicetree/bindings/timer/marvell,orion-timer.txt
 create mode 100644 drivers/clocksource/time-orion.c
 create mode 100644 drivers/irqchip/irq-orion.c
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.2.5

