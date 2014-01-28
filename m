Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaA1G2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:28:19 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58004 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaA1G2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:28:16 -0500
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [Patch v3 0/2] Add Qualcomm BAM dmaengine driver
Date: Tue, 28 Jan 2014 00:27:49 -0600
Message-Id: <1390890471-14882-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces the dmaengine driver for the Qualcomm Bus Access
Manager (BAM) DMA controller present on MSM 8x74 devices.  A number of the
on-chip devices have their own BAM DMA controller and use it to move data
between system memory and peripherals or between two peripherals.

The initial version of this driver will only support slave DMA operations
between system memory and peripherals.

Changes from v2:
	- Corrected Kconfig dependencies
	- Moved execution environment ID to controller DT binding.  The EE is
	  a global setting across all of the channels on the controller.
	- Combined header into source file.
	- Corrected copyright date.
	- Moved channel hardware initialization to occur when channel is used
	  for the first time.
	- Converted dma_alloc_coherent to dma_alloc_writecombine
	- Removed unecessary reset of channel from the dma terminate_all
	- Corrected usage of EE in irq handler and channel configuration
	  functions.
	- Changed resource functions inside probe to use correct APIs.
	- Removed dma filter function and modified dma_xlate to use
	  dma_get_slave_channel API
	- Fixed various nit comments

Changes from v1:
        - Converted driver to use virt-dma
        - Reworked probe function per review comments
        - tx_status function now computes and returns residuals
        - Removed proprietary slave config.  Removed associated include file.
        - Renamed files to reflect vendor name instead of specific device
        - Converted to use (readl|writel)_relaxed w/ appropriate barriers
        - Removed unions in favor of standard types.

Andy Gross (2):
  dmaengine: add Qualcomm BAM dma driver
  dmaengine: qcom_bam_dma: Add device tree binding

 .../devicetree/bindings/dma/qcom_bam_dma.txt       |   52 +
 drivers/dma/Kconfig                                |    9 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/qcom_bam_dma.c                         | 1083 ++++++++++++++++++++
 4 files changed, 1145 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
 create mode 100644 drivers/dma/qcom_bam_dma.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

