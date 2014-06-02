Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaFBJKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:10:44 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35489 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbaFBJKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:10:18 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v6 12/12] mmc: mmci: Add Qualcomm Id to amba id table
Date: Mon,  2 Jun 2014 10:10:13 +0100
Message-Id: <1401700213-11917-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds a fake Qualcomm ID 0x00051180 to the amba_ids, as Qualcomm
SDCC controller is pl180, but amba id registers read 0x0's.
The plan is to remove SDCC driver totally and use mmci as the main SD
controller driver for Qualcomm SOCs.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 08ff8d2..fa851d5 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -190,6 +190,23 @@ static struct variant_data variant_ux500v2 = {
 	.pwrreg_nopower		= true,
 };
 
+static struct variant_data variant_qcom = {
+	.fifosize		= 16 * 4,
+	.fifohalfsize		= 8 * 4,
+	.clkreg			= MCI_CLK_ENABLE,
+	.clkreg_enable		= MCI_QCOM_CLK_FLOWENA |
+				  MCI_QCOM_CLK_SELECT_IN_FBCLK,
+	.clkreg_8bit_bus_enable = MCI_QCOM_CLK_WIDEBUS_8,
+	.datactrl_mask_ddrmode	= MCI_QCOM_CLK_SELECT_IN_DDR_MODE,
+	.data_cmd_enable	= MCI_QCOM_CSPM_DATCMD,
+	.blksz_datactrl4	= true,
+	.datalength_bits	= 24,
+	.pwrreg_powerup		= MCI_PWR_UP,
+	.f_max			= 208000000,
+	.explicit_mclk_control	= true,
+	.qcom_fifo		= true,
+};
+
 static int mmci_card_busy(struct mmc_host *mmc)
 {
 	struct mmci_host *host = mmc_priv(mmc);
@@ -1831,6 +1848,12 @@ static struct amba_id mmci_ids[] = {
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

