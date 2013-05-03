Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536Ab3ECOqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:46:25 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38266 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab3ECOeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:34:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/63] dmaengine: ste_dma40: Allocate plat_data on declaration
Date: Fri,  3 May 2013 15:32:10 +0100
Message-Id: <1367591569-32197-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's the way that most other drivers do it.

Very trivial clean-up which reduces line count and simplifies code.

Acked-by: Vinod Koul <vnod.koul@intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 6d81f44..ba50561 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3132,7 +3132,7 @@ static int __init d40_phy_res_init(struct d40_base *base)
 
 static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 {
-	struct stedma40_platform_data *plat_data;
+	struct stedma40_platform_data *plat_data = pdev->dev.platform_data;
 	struct clk *clk = NULL;
 	void __iomem *virtbase = NULL;
 	struct resource *res = NULL;
@@ -3203,8 +3203,6 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		goto failure;
 	}
 
-	plat_data = pdev->dev.platform_data;
-
 	/* The number of physical channels on this HW */
 	if (plat_data->num_of_phy_chans)
 		num_phy_chans = plat_data->num_of_phy_chans;
-- 
1.7.10.4

