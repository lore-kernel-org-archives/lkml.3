Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaC1MDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:03:53 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:50306 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaC1MDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:03:51 -0400
From: Srikanth Thokala <sthokal@xilinx.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: levex@linux.com, lars@metafoo.de, andriy.shevchenko@linux.intel.com,
        jaswinder.singh@linaro.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH v7 0/2] Add Xilinx AXI Video DMA Engine driver
Date: Fri, 28 Mar 2014 17:33:40 +0530
Message-Id: <1396008222-7058-1-git-send-email-sthokal@xilinx.com>
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

Use cases:
++++++++++
1. Xilinx Video Targeted Reference design
   http://www.wiki.xilinx.com/Zynq+Base+TRD+14.5
2. Common Display Framework
   http://events.linuxfoundation.org/sites/events/files/slides/20131024-elce.pdf

Regards,
Srikanth

Changes in v7:
- Fixed minor comments suggested by Jaswinder, Thanks.

Changes in v6:
- Fixed minor comments suggested by Andy, Thanks.

Changes in v5:
- Modified to accept only 1 frame per interleaved_dma() call, as
  suggested by Jaswinder, Thanks.

Changes in v4:
- Rebased on v3.14.0-rc5
- Reverted the changes that were done for the earlier patch series,
  1/3 - 'Support multiple interleaved frames with non-contiguous memory' as
  suggested by Jaswinder, Thanks.

Changes in v3:
- Created a separate patch for the DT binding documentation as suggested by
  Vinod, Thanks.
- Added support for interleaved frames with non-contiguous memory as suggested
  by Lars, Thanks.
- Rebased on v3.14.0-rc2

Srikanth Thokala (2):
  dma: Add Xilinx Video DMA DT Binding Documentation
  dma: Add Xilinx AXI Video Direct Memory Access Engine driver support

 .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   75 ++
 drivers/dma/Kconfig                                |   14 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/xilinx/Makefile                        |    1 +
 drivers/dma/xilinx/xilinx_vdma.c                   | 1380 ++++++++++++++++++++
 include/linux/amba/xilinx_dma.h                    |   47 +
 6 files changed, 1518 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
 create mode 100644 drivers/dma/xilinx/Makefile
 create mode 100644 drivers/dma/xilinx/xilinx_vdma.c
 create mode 100644 include/linux/amba/xilinx_dma.h

-- 
1.7.9.5

