Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3ILPkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:40:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49602 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab3ILPkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:40:43 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <tglx@linutronix.de>, <linus.walleij@linaro.org>,
        <santosh.shilimkar@ti.com>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <r.sricharan@ti.com>
Subject: [RFC PATCH 0/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
Date: Thu, 12 Sep 2013 21:09:07 +0530
Message-ID: <1379000351-15672-1-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some socs have a large number of interrupts requests to service
the needs of its many peripherals and subsystems. All of the interrupt
requests lines from the subsystems are not needed at the same
time, so they have to be muxed to the controllers appropriately.
In such places a interrupt controllers are preceded by an
IRQ CROSSBAR that provides flexibility in muxing the device interrupt
requests to the controller inputs.

This series models the crossbar IP as a cascaded irqchip controller.
The peripheral crossbar inputs are mapped on to the crossbar irq-domain.
The driver then allocates a 'free' irq line and maps that to the
actual interrupt controller's domain. So every external peripheral interrupt
is routed through the crossbar handler.

This series adds a crossbar driver and the DT bindings for the
same. Also the DT nodes for DRA7xx SOC which has a IRQ
crossbar has been added here.

Sricharan R (4):
  DRIVERS: IRQCHIP: Add crossbar irqchip driver
  ARM: DTS: DRA: Add crossbar device binding
  ARM: DTS: DRA: Replace peripheral interrupt numbers with crossbar
    inputs.
  ARM: DRA: Kconfig: Enable crossbar irqchip driver for DRA7xx

 .../devicetree/bindings/arm/omap/irq-crossbar.txt  |   39 ++
 arch/arm/boot/dts/dra7.dtsi                        |  104 ++---
 arch/arm/mach-omap2/Kconfig                        |    1 +
 drivers/irqchip/Kconfig                            |    9 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-crossbar.c                     |  407 ++++++++++++++++++++
 6 files changed, 517 insertions(+), 44 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/irq-crossbar.txt
 create mode 100644 drivers/irqchip/irq-crossbar.c

-- 
1.7.9.5

