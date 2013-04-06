Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422947Ab3DFNno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:43:44 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:62189 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422914Ab3DFNnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:43:43 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: cjb@laptop.org, shawn.guo@linaro.org, marex@denx.de,
        fabio.estevam@freescale.com, otavio@ossystems.com.br,
        broonie@opensource.wolfsonmicro.com, mkl@pengutronix.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [PATCH] mmc: mxs-mmc: Add broken-cd devicetree property
Date: Sat,  6 Apr 2013 10:43:48 -0300
Message-Id: <1365255828-6416-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: 1365166070-9370-3-git-send-email-mkl@pengutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of broken card detect support, assume the card is non-removable

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---

This patch depends on Marc Kleine-Budde series adding support for non-removable.

 drivers/mmc/host/mxs-mmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index c231881..8418928 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -689,7 +689,8 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 	else if (bus_width == 8)
 		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
-	host->non_removable = of_property_read_bool(np, "non-removable");
+	host->non_removable = of_property_read_bool(np, "non-removable") |
+		of_property_read_bool(np, "broken-cd");
 	if (host->non_removable)
 		mmc->caps |= MMC_CAP_NONREMOVABLE;
 	host->wp_gpio = of_get_named_gpio_flags(np, "wp-gpios", 0, &flags);
-- 
1.7.10

