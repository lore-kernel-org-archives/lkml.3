Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaEWMwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:52:43 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61277 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaEWMwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:52:41 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 10/13] mmc: mmci: add Qcom specifics of clk and datactrl registers.
Date: Fri, 23 May 2014 13:52:36 +0100
Message-Id: <1400849556-7501-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds specifics of clk and datactrl register on Qualcomm SD
Card controller. This patch also populates the Qcom variant data with
these new values specific to Qualcomm SD Card Controller.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c |  4 ++++
 drivers/mmc/host/mmci.h | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 17e7f6a..6434f5b1 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -185,6 +185,10 @@ static struct variant_data variant_qcom = {
 	.fifosize		= 16 * 4,
 	.fifohalfsize		= 8 * 4,
 	.clkreg			= MCI_CLK_ENABLE,
+	.clkreg_enable		= MCI_QCOM_CLK_FLOWENA |
+				  MCI_QCOM_CLK_FEEDBACK_CLK,
+	.clkreg_8bit_bus_enable = MCI_QCOM_CLK_WIDEBUS_8,
+	.datactrl_mask_ddrmode	= MCI_QCOM_CLK_DDR_MODE,
 	.blksz_datactrl4	= true,
 	.datalength_bits	= 24,
 	.blksz_datactrl4	= true,
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index cd83ca3..1b93ae7 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -41,6 +41,22 @@
 /* Modified PL180 on Versatile Express platform */
 #define MCI_ARM_HWFCEN		BIT(12)
 
+/* Modified on Qualcomm Integrations */
+#define MCI_QCOM_CLK_WIDEBUS_4	(2 << 10)
+#define MCI_QCOM_CLK_WIDEBUS_8	(3 << 10)
+#define MCI_QCOM_CLK_FLOWENA	BIT(12)
+#define MCI_QCOM_CLK_INVERTOUT	BIT(13)
+
+/* select in latch data and command */
+#define MCI_QCOM_CLK_SEL_IN_SHIFT	(14)
+#define MCI_QCOM_CLK_SEL_MASK		(0x3)
+#define MCI_QCOM_CLK_SEL_RISING_EDGE	(1)
+#define MCI_QCOM_CLK_FEEDBACK_CLK	(2 << 14)
+#define MCI_QCOM_CLK_DDR_MODE		(3 << 14)
+
+/* mclk selection */
+#define MCI_QCOM_CLK_SEL_MCLK		(2 << 23)
+
 #define MMCIARGUMENT		0x008
 #define MMCICOMMAND		0x00c
 #define MCI_CPSM_RESPONSE	BIT(6)
@@ -54,6 +70,14 @@
 #define MCI_ST_NIEN		BIT(13)
 #define MCI_ST_CE_ATACMD	BIT(14)
 
+/* Modified on Qualcomm Integrations */
+#define MCI_QCOM_CSPM_DATCMD		BIT(12)
+#define MCI_QCOM_CSPM_MCIABORT		BIT(13)
+#define MCI_QCOM_CSPM_CCSENABLE		BIT(14)
+#define MCI_QCOM_CSPM_CCSDISABLE	BIT(15)
+#define MCI_QCOM_CSPM_AUTO_CMD19	BIT(16)
+#define MCI_QCOM_CSPM_AUTO_CMD21	BIT(21)
+
 #define MMCIRESPCMD		0x010
 #define MMCIRESPONSE0		0x014
 #define MMCIRESPONSE1		0x018
-- 
1.9.1

