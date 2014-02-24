Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaBXXMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:12:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46018 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbaBXXMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:12:42 -0500
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [Patch v7 0/2] Add Qualcomm BAM dmaengine driver
Date: Mon, 24 Feb 2014 17:11:38 -0600
Message-Id: <1393283500-18599-1-git-send-email-agross@codeaurora.org>
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

Changes from v6:
	- Changed KConfig dependency from ARCH_MSM_DT to ARCH_QCOM.
	- Incorporated comments on DT binding.
	- Changed driver source file to accomodate DT changes.

Changes from v5:
        - Separated copyright from BAM description
        - Removed usage of slave dma direction
        - Reworked slave config interface
        - Removed max segment size restriction in slave_sg
        - Added acked-by on DT patch
        - Fixed nit comments

Changes from v4:
        - Add devm_free_irq() to .remove to avoid race condition
        - Free FIFO memory in .remove

Changes from v3:
        - Remove unused bam_channel_dir.
        - Remove incorrect write to BAM_IRQ_SRCS_EE (read only).
        - Remove dma direction from DT binding and revise driver to use
          direction from prep_slave_sg.
        - Remove unnecessary channel reset from channel_init.  This could affect
          channels controlled from other execution environments.
        - Change terminate_all to also take care of the current active
          descriptor.
        - Rework .remove function to correctly mask interrupts and clean up
          resources and tasklets.

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
  dmaengine: qcom_bam_dma: Add device tree binding
  dmaengine: add Qualcomm BAM dma driver

 .../devicetree/bindings/dma/qcom_bam_dma.txt       |   41 +
 drivers/dma/Kconfig                                |    9 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/qcom_bam_dma.c                         | 1106 ++++++++++++++++++++
 4 files changed, 1157 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
 create mode 100644 drivers/dma/qcom_bam_dma.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

