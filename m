Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaEOJhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:37:31 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57855 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbaEOJhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:37:21 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 08/14] mmc: mmci: add 8bit bus support in variant data
Date: Thu, 15 May 2014 10:37:16 +0100
Message-Id: <1400146636-30138-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds 8bit bus enable to variant structure giving more flexibility
to the driver to support more SOCs which have different clock register layout.

Without this patch other new SOCs like Qcom will have to add more code
to special case them.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index dec70d2..a81f303 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -52,6 +52,7 @@ static unsigned int fmax = 515633;
  * struct variant_data - MMCI variant-specific quirks
  * @clkreg: default value for MCICLOCK register
  * @clkreg_enable: enable value for MMCICLOCK register
+ * @clkreg_8bit_bus_enable: enable value for 8 bit bus
  * @datalength_bits: number of bits in the MMCIDATALENGTH register
  * @fifosize: number of bytes that can be written when MMCI_TXFIFOEMPTY
  *	      is asserted (likewise for RX)
@@ -74,6 +75,7 @@ static unsigned int fmax = 515633;
 struct variant_data {
 	unsigned int		clkreg;
 	unsigned int		clkreg_enable;
+	unsigned int		clkreg_8bit_bus_enable;
 	unsigned int		datalength_bits;
 	unsigned int		fifosize;
 	unsigned int		fifohalfsize;
@@ -116,6 +118,7 @@ static struct variant_data variant_u300 = {
 	.fifosize		= 16 * 4,
 	.fifohalfsize		= 8 * 4,
 	.clkreg_enable		= MCI_ST_U300_HWFCEN,
+	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
 	.datactrl_mask_ddrmode	= MCI_ST_DPSM_DDRMODE,
 	.datalength_bits	= 16,
 	.sdio			= true,
@@ -144,6 +147,7 @@ static struct variant_data variant_ux500 = {
 	.fifohalfsize		= 8 * 4,
 	.clkreg			= MCI_CLK_ENABLE,
 	.clkreg_enable		= MCI_ST_UX500_HWFCEN,
+	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
 	.datactrl_mask_ddrmode	= MCI_ST_DPSM_DDRMODE,
 	.datalength_bits	= 24,
 	.sdio			= true,
@@ -160,6 +164,7 @@ static struct variant_data variant_ux500v2 = {
 	.fifohalfsize		= 8 * 4,
 	.clkreg			= MCI_CLK_ENABLE,
 	.clkreg_enable		= MCI_ST_UX500_HWFCEN,
+	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
 	.datactrl_mask_ddrmode	= MCI_ST_DPSM_DDRMODE,
 	.datalength_bits	= 24,
 	.sdio			= true,
@@ -340,7 +345,7 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
 	if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_4)
 		clk |= MCI_4BIT_BUS;
 	if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_8)
-		clk |= MCI_ST_8BIT_BUS;
+		clk |= variant->clkreg_8bit_bus_enable;
 
 	if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
 		clk |= MCI_ST_UX500_NEG_EDGE;
-- 
1.9.1

