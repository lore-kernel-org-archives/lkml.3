Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaE1Nq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:46:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56106 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbaE1NqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:46:24 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v4 03/13] mmc: mmci: Add Qualcomm Id to amba id table
Date: Wed, 28 May 2014 14:46:19 +0100
Message-Id: <1401284779-16563-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds a fake Qualcomm ID 0x00051180 to the amba_ids, as Qualcomm
SDCC controller is pl180, but amba id registers read 0x0's.
The plan is to remove SDCC driver totally and use mmci as the main SD
controller driver for Qualcomm SOCs.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index a38e714..86f25a9 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -160,6 +160,14 @@ static struct variant_data variant_ux500v2 = {
 	.pwrreg_nopower		= true,
 };
 
+static struct variant_data variant_qcom = {
+	.fifosize		= 16 * 4,
+	.fifohalfsize		= 8 * 4,
+	.clkreg			= MCI_CLK_ENABLE,
+	.datalength_bits	= 24,
+	.pwrreg_powerup		= MCI_PWR_UP,
+};
+
 static int mmci_card_busy(struct mmc_host *mmc)
 {
 	struct mmci_host *host = mmc_priv(mmc);
@@ -1750,6 +1758,12 @@ static struct amba_id mmci_ids[] = {
 		.mask   = 0xf0ffffff,
 		.data	= &variant_ux500v2,
 	},
+	/* Qualcomm variants */
+	{
+		.id     = 0x00051180,
+		.mask	= 0x000fffff,
+		.data	= &variant_qcom,
+	},
 	{ 0, 0 },
 };
 
-- 
1.9.1

