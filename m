Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaG3BaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:30:17 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:44617 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaG3BaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:30:16 -0400
From: Fabio Estevam <festevam@gmail.com>
To: lee.jones@linaro.org
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] mfd: ab8500-core: Use 'ifdef' for config options
Date: Tue, 29 Jul 2014 22:29:48 -0300
Message-Id: <1406683788-7776-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

The config symbol 'CONFIG_DEBUG_FS' should be protected by a 'ifdef' instead
of a plain 'if'.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/ab8500-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index ce48aa7..bde2fc0 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1754,7 +1754,7 @@ static int ab8500_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-#if CONFIG_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 	/* Pass to debugfs */
 	ab8500_debug_resources[0].start = ab8500->irq;
 	ab8500_debug_resources[0].end = ab8500->irq;
-- 
1.9.1

