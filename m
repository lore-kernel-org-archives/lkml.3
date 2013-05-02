Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496Ab3EBXs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:48:59 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:48306 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3EBXs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:48:57 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] ARM: orion: add orion irqchip driver
Date: Fri,  3 May 2013 01:48:34 +0200
Message-Id: <1367538519-23940-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds an irqchip driver for the main interrupt controller
found on Marvell Orion SoCs (Kirkwood, Dove, Orion5x, Discovery Innovation)
and the corresponding device tree documentation.

It also moves Dove as the first Orion SoC to this irqchip driver. 
As legacy non-DT drivers don't know about virtual irqs provided by irqchip
drivers, init code for timer and mv643xx_eth is added until true DT enabled
drivers are available. Finally, DT enabled boards for Dove are moved to the
orion irqchip driver.

*Note:*
This patch set is _not_ feature complete. There has been a request for
irqdomain support for generic irq and perhaps even a DT enabled generic
irq chip driver.

The patch set still can be used to port other Orion SoCs as I did with Dove.
It also merges irqchip driver patches with Dove patches to use this driver.

Sebastian Hesselbarth (5):
  irqchip: add support for Marvell Orion SoCs
  ARM: dove: add DT parsing for legacy mv643xx_eth
  ARM: dove: add DT parsing for legacy timer
  ARM: dove: move DT boards to orion irqchip driver
  ARM: dove: add DT nodes for irqchip conversion

 .../interrupt-controller/marvell,orion-intc.txt    |   22 ++++
 arch/arm/boot/dts/dove.dtsi                        |   16 ++-
 arch/arm/mach-dove/Kconfig                         |    1 +
 arch/arm/mach-dove/Makefile                        |    4 +-
 arch/arm/mach-dove/board-dt.c                      |   77 ++++++++++--
 drivers/irqchip/Kconfig                            |    5 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-orion.c                        |  133 ++++++++++++++++++++
 8 files changed, 247 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt
 create mode 100644 drivers/irqchip/irq-orion.c
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4

