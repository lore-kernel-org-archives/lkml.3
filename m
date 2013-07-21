Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3GURlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 13:41:51 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:63848 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab3GURlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 13:41:50 -0400
From: Fabio Estevam <festevam@gmail.com>
To: herbert@gondor.hengli.com.au
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] hw_random: mxc-rnga: Check the return value from clk_prepare_enable()
Date: Sun, 21 Jul 2013 14:41:38 -0300
Message-Id: <1374428498-14222-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/char/hw_random/mxc-rnga.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 19a12ac..6a86b6f 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -164,7 +164,9 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	clk_prepare_enable(mxc_rng->clk);
+	err = clk_prepare_enable(mxc_rng->clk);
+	if (err)
+		goto out;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mxc_rng->mem = devm_ioremap_resource(&pdev->dev, res);
-- 
1.8.1.2

