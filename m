Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab3HQAFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:05:10 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62113 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3HPWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:58 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC v1 0/5] ARM: Initial support for Marvell Armada 1500
Date: Fri, 16 Aug 2013 21:41:33 +0200
Message-Id: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC adding initial support for the Marvell Armada 1500
(88DE3100) found on various consumer devices (Chromecast, GoogleTV).

Actually, it is a two-fold RFC also raising discussions on mach-mvebu
cleanup roadmap to allow other SoCs to hop into it. While mach-mvebu
originally was created to add support for Armada 370/XP and merge
existing Marvell Orion familiy into it, I am not so sure about
Armada 1500 fits that well (the mbus has gone!).

If you are brave enough to try this on any GoogleTV, hit Google for
instructions on how to get a unlocked u-boot and void your warranty :)
The patches are based on v3.11-rc5 directly.

This cover letter and the separate patches have also been Cc'd to the
respective maintainers to clear up some questions before posting a real
patch set.

Sebastian Hesselbarth (5):
  irqchip: add Armada 1500 APB interrupt controller
  ARM: mvebu: add Armada 1500 to defconfig
  ARM: mvebu: add Armada 150 uart to lowlevel debug
  ARM: mvebu: add Armada 1500 and Sony NSZ-GS7 device tree files
  ARM: mvebu: add board init for Armada 1500

 arch/arm/boot/dts/Makefile                     |    3 +-
 arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts |   29 +++
 arch/arm/boot/dts/armada-1500.dtsi             |  225 ++++++++++++++++++++++++
 arch/arm/configs/mvebu_defconfig               |    1 +
 arch/arm/include/debug/mvebu.S                 |   26 +--
 arch/arm/mach-mvebu/Kconfig                    |   15 ++
 arch/arm/mach-mvebu/Makefile                   |   13 +-
 arch/arm/mach-mvebu/armada-1500.c              |   63 +++++++
 drivers/irqchip/Makefile                       |    1 +
 drivers/irqchip/irq-armada-1500-apb.c          |  108 ++++++++++++
 10 files changed, 467 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts
 create mode 100644 arch/arm/boot/dts/armada-1500.dtsi
 create mode 100644 arch/arm/mach-mvebu/armada-1500.c
 create mode 100644 drivers/irqchip/irq-armada-1500-apb.c

---
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4

