Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaEWMvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:51:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43301 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaEWMvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:51:20 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 03/13] mmc: mmci: Add Qualcomm Id to amba id table
Date: Fri, 23 May 2014 13:51:14 +0100
Message-Id: <1400849474-7177-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
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

