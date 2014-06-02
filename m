Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaFBJI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:08:59 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53849 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaFBJIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:08:54 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v6 02/12] mmc: mmci: Add Qualcomm specific register defines.
Date: Mon,  2 Jun 2014 10:08:48 +0100
Message-Id: <1401700128-11506-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds a Qualcomm SD Card controller specific register variations
to header file. Qualcomm SDCC controller is pl180, with slight changes in
the register layout from standard pl180 register set.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 347d942..d38a99d 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -41,6 +41,15 @@
 /* Modified PL180 on Versatile Express platform */
 #define MCI_ARM_HWFCEN		(1 << 12)
 
+/* Modified on Qualcomm Integrations */
+#define MCI_QCOM_CLK_WIDEBUS_8	(BIT(10) | BIT(11))
+#define MCI_QCOM_CLK_FLOWENA	BIT(12)
+#define MCI_QCOM_CLK_INVERTOUT	BIT(13)
+
+/* select in latch data and command in */
+#define MCI_QCOM_CLK_SELECT_IN_FBCLK	BIT(15)
+#define MCI_QCOM_CLK_SELECT_IN_DDR_MODE	(BIT(14) | BIT(15))
+
 #define MMCIARGUMENT		0x008
 #define MMCICOMMAND		0x00c
 #define MCI_CPSM_RESPONSE	(1 << 6)
@@ -54,6 +63,14 @@
 #define MCI_ST_NIEN		(1 << 13)
 #define MCI_ST_CE_ATACMD	(1 << 14)
 
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

