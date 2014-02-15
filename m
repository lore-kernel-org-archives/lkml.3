Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaBOMHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 07:07:47 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:54105 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaBOMHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 07:07:44 -0500
From: Srikanth Thokala <sthokal@xilinx.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: levex@linux.com, lars@metafoo.de, andriy.shevchenko@linux.intel.com,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH v3 0/3] Add Xilinx AXI Video DMA Engine driver
Date: Sat, 15 Feb 2014 17:30:16 +0530
Message-Id: <1392465619-27614-1-git-send-email-sthokal@xilinx.com>
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

Changes in v3:
- Created a separate patch for the DT binding documentation as suggested by
  Vinod, Thanks.
- Added support for interleaved frames with non-contiguous memory as suggested
  by Lars, Thanks.
- Rebased on v3.14.0-rc2 

Srikanth Thokala (3):
  dma: Support multiple interleaved frames with non-contiguous memory
  dma: Add Xilinx Video DMA DT Binding Documentation
  dma: Add Xilinx AXI Video Direct Memory Access Engine driver support

 .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   75 ++
 Documentation/dmaengine.txt                        |    2 +-
 drivers/dma/Kconfig                                |   14 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/imx-dma.c                              |    3 +-
 drivers/dma/sirf-dma.c                             |    3 +-
 drivers/dma/xilinx/Makefile                        |    1 +
 drivers/dma/xilinx/xilinx_vdma.c                   | 1388 ++++++++++++++++++++
 drivers/media/platform/m2m-deinterlace.c           |    2 +-
 include/linux/amba/xilinx_dma.h                    |   46 +
 include/linux/dmaengine.h                          |    6 +-
 11 files changed, 1534 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
 create mode 100644 drivers/dma/xilinx/Makefile
 create mode 100644 drivers/dma/xilinx/xilinx_vdma.c
 create mode 100644 include/linux/amba/xilinx_dma.h

-- 
1.7.9.5

