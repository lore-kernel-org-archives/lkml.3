Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaDUVti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:49:38 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:45890 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaDUVte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:49:34 -0400
From: srinivas.kandagatla@linaro.org
To: linux-mmc@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        agross@quicinc.com, linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 11/12] mmc: mmci: Add Qcom variations to MCICommand register.
Date: Mon, 21 Apr 2014 22:49:25 +0100
Message-Id: <1398116965-31732-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Some bits which control Command Path State Machine (CPSM) are new in Qcom
integration, so this patch adds support to those bits.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |    4 ++++
 drivers/mmc/host/mmci.h |    7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 2cd3a8f..8fcd8ef 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -910,6 +910,10 @@ mmci_start_command(struct mmci_host *host, struct mmc_command *cmd, u32 c)
 	if (/*interrupt*/0)
 		c |= MCI_CPSM_INTERRUPT;
 
+	if (host->hw_designer == AMBA_VENDOR_QCOM &&
+	    mmc_cmd_type(cmd) == MMC_CMD_ADTC)
+		c |= MCI_CSPM_QCOM_DATCMD;
+
 	host->cmd = cmd;
 
 	mmci_writel(host, cmd->arg, MMCIARGUMENT);
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 0a6de1c..2ba0834 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -64,6 +64,13 @@
 #define MCI_ST_ENCMD_COMPL	(1 << 12)
 #define MCI_ST_NIEN		(1 << 13)
 #define MCI_ST_CE_ATACMD	(1 << 14)
+/* Modified on Qualcomm Integrations */
+#define MCI_CSPM_QCOM_DATCMD		(1 << 12)
+#define MCI_CSPM_QCOM_MCIABORT		(1 << 13)
+#define MCI_CSPM_QCOM_CCSENABLE		(1 << 14)
+#define MCI_CSPM_QCOM_CCSDISABLE	(1 << 15)
+#define MCI_CSPM_QCOM_AUTO_CMD19	(1 << 16)
+#define MCI_CSPM_QCOM_AUTO_CMD21	(1 << 21)
 
 #define MMCIRESPCMD		0x010
 #define MMCIRESPONSE0		0x014
-- 
1.7.9.5

