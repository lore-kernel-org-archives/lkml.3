Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaCGMRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:17:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44347 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaCGMRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:17:21 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <dmaengine@vger.kernel.org>
CC: <santosh.shilimkar@ti.com>, <rnayak@ti.com>, <nsekhar@ti.com>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <nm@ti.com>
Subject: [RFC PATCH 0/9] drivers: dma: Add support for dma-channel router
Date: Fri, 7 Mar 2014 17:46:07 +0530
Message-ID: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some SoCs the dma request lines from the peripherals are
routed to the dma-controller through a crossbar. With this the
dma controller's available request lines are shared between the
peripherals.

This adds support to register the crossbar router associated with
a dma-channel and let the dma-controller driver map/unmap
the peripheral dma crossbar line to dma-controller's request
line.

This is on top of Russell's OMAP dma engine rework series

	http://www.spinics.net/lists/linux-omap/msg102969.html

Sricharan R (9):
  drivers: dma: omap-dma: Avoid hard-coding of the dma-request channels
  drivers: dma: of-dma: Add support for dma-request line routers
  drivers: dma: omap-dma: Add a seperate xlate function to get router
    data
  drivers: omap-dma: Add crossbar line as a resource to omap_chan
    structure
  drivers: dma: Add dma crossbar driver
  arm: dts: dra: Add dma crossbar node
  arm: dts: dra: Add dma-request router phandle to dma-specs
  arm: dra: Enable dma crossbar support on dra7xx
  arm: dts: dra7: Change the total dma-req numbers to crossbar channels

 .../devicetree/bindings/arm/omap/dma-crossbar.txt  |   26 +++
 arch/arm/boot/dts/dra7.dtsi                        |   47 +++--
 arch/arm/configs/omap2plus_defconfig               |    1 +
 drivers/dma/Kconfig                                |    7 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/of-dma.c                               |   82 +++++++-
 drivers/dma/omap-dma-xbar.c                        |  219 ++++++++++++++++++++
 drivers/dma/omap-dma-xbar.h                        |   32 +++
 drivers/dma/omap-dma.c                             |   72 ++++++-
 include/linux/of_dma.h                             |   22 ++
 10 files changed, 479 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/dma-crossbar.txt
 create mode 100644 drivers/dma/omap-dma-xbar.c
 create mode 100644 drivers/dma/omap-dma-xbar.h

-- 
1.7.9.5

