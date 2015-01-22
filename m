Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbbAVHFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:05:01 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60944 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbbAVHEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:04:34 -0500
From: Archit Taneja <architt@codeaurora.org>
To: vinod.koul@intel.com
Cc: agross@codeaurora.org, dmaengine@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, svarbanov@mm-sol.com,
        linux-kernel@vger.kernel.org, Archit Taneja <architt@codeaurora.org>
Subject: [PATCH] dmaengine: qcom_bam_dma: Add support for BAM v1.7.0
Date: Thu, 22 Jan 2015 12:34:26 +0530
Message-Id: <1421910266-8573-1-git-send-email-architt@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add register offset table entry for the newer (v1.7.0) version of the BAM IP
found on MSM8916. Update the DT bindings documentation.

Signed-off-by: Archit Taneja <architt@codeaurora.org>
---
 .../devicetree/bindings/dma/qcom_bam_dma.txt       |  1 +
 drivers/dma/qcom_bam_dma.c                         | 30 ++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
index f8c3311..1c9d48e 100644
--- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
@@ -4,6 +4,7 @@ Required properties:
 - compatible: must be one of the following:
  * "qcom,bam-v1.4.0" for MSM8974, APQ8074 and APQ8084
  * "qcom,bam-v1.3.0" for APQ8064, IPQ8064 and MSM8960
+ * "qcom,bam-v1.7.0" for MSM8916
 - reg: Address range for DMA registers
 - interrupts: Should contain the one interrupt shared by all channels
 - #dma-cells: must be <1>, the cell in the dmas property of the client device
diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index 3122a99..447ad12 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -171,6 +171,35 @@ static const struct reg_offset_data bam_v1_4_reg_info[] = {
 	[BAM_P_FIFO_SIZES]	= { 0x1820, 0x00, 0x1000, 0x00 },
 };
 
+static const struct reg_offset_data bam_v1_7_reg_info[] = {
+	[BAM_CTRL]		= { 0x00000, 0x00, 0x00, 0x00 },
+	[BAM_REVISION]		= { 0x01000, 0x00, 0x00, 0x00 },
+	[BAM_NUM_PIPES]		= { 0x01008, 0x00, 0x00, 0x00 },
+	[BAM_DESC_CNT_TRSHLD]	= { 0x00008, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS]		= { 0x03010, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS_MSK]	= { 0x03014, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS_UNMASKED]	= { 0x03018, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_STTS]		= { 0x00014, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_CLR]		= { 0x00018, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_EN]		= { 0x0001C, 0x00, 0x00, 0x00 },
+	[BAM_CNFG_BITS]		= { 0x0007C, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS_EE]	= { 0x03000, 0x00, 0x00, 0x80 },
+	[BAM_IRQ_SRCS_MSK_EE]	= { 0x03004, 0x00, 0x00, 0x80 },
+	[BAM_P_CTRL]		= { 0x13000, 0x1000, 0x00, 0x00 },
+	[BAM_P_RST]		= { 0x13004, 0x1000, 0x00, 0x00 },
+	[BAM_P_HALT]		= { 0x13008, 0x1000, 0x00, 0x00 },
+	[BAM_P_IRQ_STTS]	= { 0x13010, 0x1000, 0x00, 0x00 },
+	[BAM_P_IRQ_CLR]		= { 0x13014, 0x1000, 0x00, 0x00 },
+	[BAM_P_IRQ_EN]		= { 0x13018, 0x1000, 0x00, 0x00 },
+	[BAM_P_EVNT_DEST_ADDR]	= { 0x1382C, 0x00, 0x1000, 0x00 },
+	[BAM_P_EVNT_REG]	= { 0x13818, 0x00, 0x1000, 0x00 },
+	[BAM_P_SW_OFSTS]	= { 0x13800, 0x00, 0x1000, 0x00 },
+	[BAM_P_DATA_FIFO_ADDR]	= { 0x13824, 0x00, 0x1000, 0x00 },
+	[BAM_P_DESC_FIFO_ADDR]	= { 0x1381C, 0x00, 0x1000, 0x00 },
+	[BAM_P_EVNT_GEN_TRSHLD]	= { 0x13828, 0x00, 0x1000, 0x00 },
+	[BAM_P_FIFO_SIZES]	= { 0x13820, 0x00, 0x1000, 0x00 },
+};
+
 /* BAM CTRL */
 #define BAM_SW_RST			BIT(0)
 #define BAM_EN				BIT(1)
@@ -1053,6 +1082,7 @@ static void bam_channel_init(struct bam_device *bdev, struct bam_chan *bchan,
 static const struct of_device_id bam_of_match[] = {
 	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_reg_info },
 	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_reg_info },
+	{ .compatible = "qcom,bam-v1.7.0", .data = &bam_v1_7_reg_info },
 	{}
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

