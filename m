Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaAPRxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:53:39 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:49867 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAPRxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:53:35 -0500
From: Srikanth Thokala <sthokal@xilinx.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH] Add Xilinx AXI Video DMA Engine driver
Date: Thu, 16 Jan 2014 23:23:22 +0530
Message-Id: <1389894803-4147-1-git-send-email-sthokal@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the driver for Xilinx AXI Video Direct Memory Access Engine.
It is a soft IP core, which provides high-bandwidth direct memory
access between memory and AXI4-Stream video type target peripherals 
including peripherals which support AXI4-Stream Video Protocol. The
core provides efficient two dimensional DMA operations with independent
asynchronous read and write channel operation.

For more information on the IP, please refer to
http://www.xilinx.com/support/documentation/ip_documentation/axi_vdma/v6_1/pg020_axi_vdma.pdf

This patch also provides a test client, which assumes read and write channels
of the core are configured in a back-to-back connection.  It transfers 
data on the write channel, read and verify the data on the read channel. 

Use cases:
++++++++++
1. Xilinx Video Targeted Reference design
   http://www.wiki.xilinx.com/Zynq+Base+TRD+14.5
2. Common Display Framework
   http://events.linuxfoundation.org/sites/events/files/slides/20131024-elce.pdf

Regards,
Srikanth

Srikanth Thokala (1):
  dma: Add Xilinx AXI Video Direct Memory Access Engine driver support

 .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   71 +
 .../bindings/dma/xilinx/xilinx_vdma_test.txt       |   39 +
 drivers/dma/Kconfig                                |   23 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/xilinx/Makefile                        |    2 +
 drivers/dma/xilinx/xilinx_vdma.c                   | 1497 ++++++++++++++++++++
 drivers/dma/xilinx/xilinx_vdma_test.c              |  629 ++++++++
 7 files changed, 2262 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
 create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma_test.txt
 create mode 100644 drivers/dma/xilinx/Makefile
 create mode 100644 drivers/dma/xilinx/xilinx_vdma.c
 create mode 100644 drivers/dma/xilinx/xilinx_vdma_test.c

-- 
1.7.9.5

