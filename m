Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaEOJh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:37:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61500 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbaEOJhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:37:53 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 12/14] mmc: mmci: add support for fbclk to latch data and cmd.
Date: Thu, 15 May 2014 10:37:49 +0100
Message-Id: <1400146669-30302-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds support to fbclk that is used to latch data and
cmd on some controllers like SD Card controller in Qcom SOC.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 05ae654..bc7b80d 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -54,6 +54,8 @@ static unsigned int fmax = 515633;
  * @clkreg_enable: enable value for MMCICLOCK register
  * @clkreg_8bit_bus_enable: enable value for 8 bit bus
  * @clkreg_neg_edge_enable: enable value for inverted data/cmd output
+ * @clkreg_fbclk_latch: enable value to select feedback clock to
+ *			latch data and command comming in.
  * @datalength_bits: number of bits in the MMCIDATALENGTH register
  * @fifosize: number of bytes that can be written when MMCI_TXFIFOEMPTY
  *	      is asserted (likewise for RX)
@@ -79,6 +81,7 @@ struct variant_data {
 	unsigned int		clkreg_enable;
 	unsigned int		clkreg_8bit_bus_enable;
 	unsigned int		clkreg_neg_edge_enable;
+	unsigned int		clkreg_fbclk_latch;
 	unsigned int		datalength_bits;
 	unsigned int		fifosize;
 	unsigned int		fifohalfsize;
@@ -189,6 +192,7 @@ static struct variant_data variant_qcom = {
 	.clkreg			= MCI_CLK_ENABLE,
 	.clkreg_enable		= MCI_QCOM_CLK_FLOWENA,
 	.clkreg_8bit_bus_enable = MCI_QCOM_CLK_WIDEBUS_8,
+	.clkreg_fbclk_latch	= MCI_QCOM_CLK_FEEDBACK_CLK,
 	.datactrl_mask_ddrmode	= MCI_QCOM_CLK_DDR_MODE,
 	.data_cmd_enable	= MCI_QCOM_CSPM_DATCMD,
 	.blksz_datactrl4	= true,
@@ -343,6 +347,7 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
 			host->cclk = host->mclk / (2 * (clk + 1));
 		}
 
+		clk |= variant->clkreg_fbclk_latch;
 		clk |= variant->clkreg_enable;
 		clk |= MCI_CLK_ENABLE;
 		/* This hasn't proven to be worthwhile */
-- 
1.9.1

