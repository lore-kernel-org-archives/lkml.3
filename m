Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaDANGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:06:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54318 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbaDANGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:06:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 00/14] dma: edma: Fixes for cyclic (audio) operation
Date: Tue, 1 Apr 2014 16:06:01 +0300
Message-ID: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is basically a resend of the previous series:
https://lkml.org/lkml/2014/3/13/119
with removed ASoC patches (most of them are applied already).

Changes since v1:
- ASoC patches removed
- Comments from Andriy Shevchenko addressed
- patch added to fix cases when src/dst_maxburst is set to 0

Adding support for DMA pause/resume
Possibility to select non default event queue/TC for cyclic (audio) dma
channels: all devices using the eDMA via dmaengine was assigned to the default
EQ/TC (mmc, i2c, spi, etc, and audio). This is not optimal from system
performance point of view since sharing the same EQ/TC can cause latency spikes
for cyclic channels (long DMA transfers for MMC for example).

While debugging the edma to get things sorted out I noticed that the debug was
too verbose and the important information was hidden even when the we did not
asked for verbose dmaengine debug.
I have included some debug cleanups for the edma dmaengine driver also.

Regards,
Peter
---
Peter Ujfalusi (14):
  platform_data: edma: Be precise with the paRAM struct
  dma: edma: Correct the handling of src/dst_maxburst == 0
  dma: edma: Add support for DMA_PAUSE/RESUME operation
  dma: edma: Set DMA_CYCLIC capability flag
  arm: common: edma: Select event queue 1 as default when booted with DT
  arm: common: edma: Save the number of event queues/TCs
  arm: common: edma: API to request non default queue for a channel
  DMA: edma: Use different eventq for cyclic channels
  dma: edma: Implement device_slave_caps callback
  dma: edma: Simplify direction configuration in edma_config_pset()
  dma: edma: Reduce debug print verbosity for non verbose debugging
  dma: edma: Prefix debug prints where the text were identical in prep
    callbacks
  dma: edma: Add channel number to debug prints
  dma: edma: Print the direction value as well when it is not supported

 arch/arm/common/edma.c             | 34 +++++++++++++-
 drivers/dma/edma.c                 | 96 +++++++++++++++++++++++++++++---------
 include/linux/platform_data/edma.h | 20 ++++----
 3 files changed, 119 insertions(+), 31 deletions(-)

-- 
1.9.1

