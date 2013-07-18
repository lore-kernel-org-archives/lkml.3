Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab3GRQo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:44:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33847 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab3GRQo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:44:26 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <nm@ti.com>, <rnayak@ti.com>,
        <balbi@ti.com>, <r.sricharan@ti.com>
Subject: [PATCH 0/3] Add crossbar driver
Date: Thu, 18 Jul 2013 22:13:47 +0530
Message-ID: <1374165830-6367-1-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some socs have a large number of interrupts/dma requests to service
the needs of its many peripherals and subsystems. All of the
requests lines from the subsystems are not needed at the same
time, so they have to be muxed to the controllers appropriately.
In such places a interrupt/dma controllers are preceded by an
IRQ/DMA CROSSBAR that provides flexibility in muxing the device
requests to the controller inputs.

This series adds a crossbar driver and the DT bindings for the
same. Also the DT nodes for DRA7xx SOC which has a IRQ/DMA
crossbar has been added here.

This series is on top of the basic DRA support from Rajendra [1][2]

[1] http://comments.gmane.org/gmane.linux.ports.arm.omap/100763
[2] http://comments.gmane.org/gmane.linux.ports.arm.omap/100773

Sricharan R (3):
  misc: Add crossbar driver
  ARM: dts: DRA: Add crossbar device binding
  ARM: DRA: Enable crossbar driver for dra soc

 .../devicetree/bindings/arm/omap/crossbar.txt      |   24 ++
 arch/arm/boot/dts/dra7.dtsi                        |   19 ++
 arch/arm/mach-omap2/Kconfig                        |    1 +
 drivers/misc/Kconfig                               |    8 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/crossbar.c                            |  258 ++++++++++++++++++++
 include/linux/crossbar.h                           |   71 ++++++
 7 files changed, 382 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/crossbar.txt
 create mode 100644 drivers/misc/crossbar.c
 create mode 100644 include/linux/crossbar.h

-- 
1.7.9.5

