Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbaCSHsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:48:37 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:61299 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaCSHsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 03:48:35 -0400
From: Bo Shen <voice.shen@atmel.com>
To: nicolas.ferre@atmel.com
Cc: linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bo Shen <voice.shen@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Video: atmel: avoid the id of fix screen info is overwritten
Date: Wed, 19 Mar 2014 15:47:55 +0800
Message-Id: <1395215275-14345-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct passing parameter sequence, which will avoid the id of
fix screen info is overwritten.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 drivers/video/atmel_lcdfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index cd96162..695f28a 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -1190,12 +1190,12 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	if (!sinfo->config)
 		goto free_info;
 
-	strcpy(info->fix.id, sinfo->pdev->name);
 	info->flags = ATMEL_LCDFB_FBINFO_DEFAULT;
 	info->pseudo_palette = sinfo->pseudo_palette;
 	info->fbops = &atmel_lcdfb_ops;
 
 	info->fix = atmel_lcdfb_fix;
+	strcpy(info->fix.id, sinfo->pdev->name);
 
 	/* Enable LCDC Clocks */
 	sinfo->bus_clk = clk_get(dev, "hclk");
-- 
1.8.5.2

