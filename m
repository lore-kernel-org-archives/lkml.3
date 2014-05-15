Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaEOJgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:36:44 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55682 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaEOJgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:36:41 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 03/14] mmc: mmci: Add Qualcomm Id to amba id table
Date: Thu, 15 May 2014 10:36:36 +0100
Message-Id: <1400146596-29929-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
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
 drivers/mmc/host/mmci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index a38e714..7bdf4d3 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -160,6 +160,15 @@ static struct variant_data variant_ux500v2 = {
 	.pwrreg_nopower		= true,
 };
 
+static struct variant_data variant_qcom = {
+	.fifosize		= 16 * 4,
+	.fifohalfsize		= 8 * 4,
+	.clkreg			= MCI_CLK_ENABLE,
+	.datalength_bits	= 24,
+	.blksz_datactrl4	= true,
+	.pwrreg_powerup		= MCI_PWR_UP,
+};
+
 static int mmci_card_busy(struct mmc_host *mmc)
 {
 	struct mmci_host *host = mmc_priv(mmc);
@@ -1750,6 +1759,12 @@ static struct amba_id mmci_ids[] = {
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

