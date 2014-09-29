Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaI2Edq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:33:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50262 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaI2Edn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:33:43 -0400
From: Archit Taneja <architt@codeaurora.org>
To: vinod.koul@intel.com, agross@codeaurora.org
Cc: galak@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, Archit Taneja <architt@codeaurora.org>
Subject: [PATCH v2 2/3] dmaengine: qcom_bam_dma: Add BAM v1.3.0 support
Date: Mon, 29 Sep 2014 10:03:08 +0530
Message-Id: <1411965189-24499-2-git-send-email-architt@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1411965189-24499-1-git-send-email-architt@codeaurora.org>
References: <1411037575-13153-1-git-send-email-architt@codeaurora.org>
 <1411965189-24499-1-git-send-email-architt@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have register offset information only for BAM IPs with revision
1.4.0. We add register offset table entries for the legacy (v1.3.0) version
of BAM IPs found on SoCs like APQ8064 and MSM8960.

The register offset table pointers are stored in DT data corresponding to the
BAM IP version specified in the compatible string.

Reviewed-by: Kumar Gala <galak@codeaurora.org>
Reviewed-by: Andy Gross <agross@codeaurora.org>
Signed-off-by: Archit Taneja <architt@codeaurora.org>
---
 drivers/dma/qcom_bam_dma.c | 58 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index b5a1662..777afd2 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -113,7 +113,36 @@ struct reg_offset_data {
 	unsigned int pipe_mult, evnt_mult, ee_mult;
 };
 
-static const struct reg_offset_data reg_info[] = {
+static const struct reg_offset_data bam_v1_3_reg_info[] = {
+	[BAM_CTRL]		= { 0x0F80, 0x00, 0x00, 0x00 },
+	[BAM_REVISION]		= { 0x0F84, 0x00, 0x00, 0x00 },
+	[BAM_NUM_PIPES]		= { 0x0FBC, 0x00, 0x00, 0x00 },
+	[BAM_DESC_CNT_TRSHLD]	= { 0x0F88, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS]		= { 0x0F8C, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS_MSK]	= { 0x0F90, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS_UNMASKED]	= { 0x0FB0, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_STTS]		= { 0x0F94, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_CLR]		= { 0x0F98, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_EN]		= { 0x0F9C, 0x00, 0x00, 0x00 },
+	[BAM_CNFG_BITS]		= { 0x0FFC, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS_EE]	= { 0x1800, 0x00, 0x00, 0x80 },
+	[BAM_IRQ_SRCS_MSK_EE]	= { 0x1804, 0x00, 0x00, 0x80 },
+	[BAM_P_CTRL]		= { 0x0000, 0x80, 0x00, 0x00 },
+	[BAM_P_RST]		= { 0x0004, 0x80, 0x00, 0x00 },
+	[BAM_P_HALT]		= { 0x0008, 0x80, 0x00, 0x00 },
+	[BAM_P_IRQ_STTS]	= { 0x0010, 0x80, 0x00, 0x00 },
+	[BAM_P_IRQ_CLR]		= { 0x0014, 0x80, 0x00, 0x00 },
+	[BAM_P_IRQ_EN]		= { 0x0018, 0x80, 0x00, 0x00 },
+	[BAM_P_EVNT_DEST_ADDR]	= { 0x102C, 0x00, 0x40, 0x00 },
+	[BAM_P_EVNT_REG]	= { 0x1018, 0x00, 0x40, 0x00 },
+	[BAM_P_SW_OFSTS]	= { 0x1000, 0x00, 0x40, 0x00 },
+	[BAM_P_DATA_FIFO_ADDR]	= { 0x1024, 0x00, 0x40, 0x00 },
+	[BAM_P_DESC_FIFO_ADDR]	= { 0x101C, 0x00, 0x40, 0x00 },
+	[BAM_P_EVNT_GEN_TRSHLD]	= { 0x1028, 0x00, 0x40, 0x00 },
+	[BAM_P_FIFO_SIZES]	= { 0x1020, 0x00, 0x40, 0x00 },
+};
+
+static const struct reg_offset_data bam_v1_4_reg_info[] = {
 	[BAM_CTRL]		= { 0x0000, 0x00, 0x00, 0x00 },
 	[BAM_REVISION]		= { 0x0004, 0x00, 0x00, 0x00 },
 	[BAM_NUM_PIPES]		= { 0x003C, 0x00, 0x00, 0x00 },
@@ -330,6 +359,8 @@ struct bam_device {
 	/* execution environment ID, from DT */
 	u32 ee;
 
+	const struct reg_offset_data *layout;
+
 	struct clk *bamclk;
 	int irq;
 
@@ -346,7 +377,7 @@ struct bam_device {
 static inline void __iomem *bam_addr(struct bam_device *bdev, u32 pipe,
 		enum bam_reg reg)
 {
-	const struct reg_offset_data r = reg_info[reg];
+	const struct reg_offset_data r = bdev->layout[reg];
 
 	return bdev->regs + r.base_offset +
 		r.pipe_mult * pipe +
@@ -1019,9 +1050,18 @@ static void bam_channel_init(struct bam_device *bdev, struct bam_chan *bchan,
 	bchan->vc.desc_free = bam_dma_free_desc;
 }
 
+static const struct of_device_id bam_of_match[] = {
+	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_reg_info },
+	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_reg_info },
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, bam_of_match);
+
 static int bam_dma_probe(struct platform_device *pdev)
 {
 	struct bam_device *bdev;
+	const struct of_device_id *match;
 	struct resource *iores;
 	int ret, i;
 
@@ -1031,6 +1071,14 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 	bdev->dev = &pdev->dev;
 
+	match = of_match_node(bam_of_match, pdev->dev.of_node);
+	if (!match) {
+		dev_err(&pdev->dev, "Unsupported BAM module\n");
+		return -ENODEV;
+	}
+
+	bdev->layout = match->data;
+
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	bdev->regs = devm_ioremap_resource(&pdev->dev, iores);
 	if (IS_ERR(bdev->regs))
@@ -1154,12 +1202,6 @@ static int bam_dma_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id bam_of_match[] = {
-	{ .compatible = "qcom,bam-v1.4.0", },
-	{}
-};
-MODULE_DEVICE_TABLE(of, bam_of_match);
-
 static struct platform_driver bam_dma_driver = {
 	.probe = bam_dma_probe,
 	.remove = bam_dma_remove,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

