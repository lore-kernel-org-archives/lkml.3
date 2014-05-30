Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340AbaE3RNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:13:39 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44020 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934174AbaE3RNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:13:35 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v5 05/13] mmc: mmci: Add Qcom datactrl register variant
Date: Fri, 30 May 2014 18:13:29 +0100
Message-Id: <1401470009-27031-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401469918-26817-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401469918-26817-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Instance of this IP on Qualcomm's SOCs has bit different layout for datactrl
register. Bit position datactrl[16:4] hold the true block size instead of power
of 2.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index ed20bf5..72981f6 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -60,6 +60,8 @@ static unsigned int fmax = 515633;
  * @sdio: variant supports SDIO
  * @st_clkdiv: true if using a ST-specific clock divider algorithm
  * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
+ * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
+ *		     register
  * @pwrreg_powerup: power up value for MMCIPOWER register
  * @signal_direction: input/out direction of bus signals can be indicated
  * @pwrreg_clkgate: MMCIPOWER register must be used to gate the clock
@@ -75,6 +77,7 @@ struct variant_data {
 	bool			sdio;
 	bool			st_clkdiv;
 	bool			blksz_datactrl16;
+	bool			blksz_datactrl4;
 	u32			pwrreg_powerup;
 	bool			signal_direction;
 	bool			pwrreg_clkgate;
@@ -731,6 +734,8 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 
 	if (variant->blksz_datactrl16)
 		datactrl = MCI_DPSM_ENABLE | (data->blksz << 16);
+	else if (variant->blksz_datactrl4)
+		datactrl = MCI_DPSM_ENABLE | (data->blksz << 4);
 	else
 		datactrl = MCI_DPSM_ENABLE | blksz_bits << 4;
 
-- 
1.9.1

