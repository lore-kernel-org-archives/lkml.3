Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967925Ab3DRKNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:13:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53893 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967878Ab3DRKNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 22/32] dmaengine: ste_dma40: Allocate plat_data on declaration
Date: Thu, 18 Apr 2013 11:12:04 +0100
Message-Id: <1366279934-30761-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's the way that most other drivers do it.

Very trivial clean-up which reduces line count and simplifies code.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 805049c..6f9f801 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3119,7 +3119,7 @@ static int __init d40_phy_res_init(struct d40_base *base)
 
 static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 {
-	struct stedma40_platform_data *plat_data;
+	struct stedma40_platform_data *plat_data = pdev->dev.platform_data;
 	struct clk *clk = NULL;
 	void __iomem *virtbase = NULL;
 	struct resource *res = NULL;
@@ -3190,8 +3190,6 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		goto failure;
 	}
 
-	plat_data = pdev->dev.platform_data;
-
 	/* The number of physical channels on this HW */
 	if (plat_data->num_of_phy_chans)
 		num_phy_chans = plat_data->num_of_phy_chans;
-- 
1.7.10.4

