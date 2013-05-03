Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058Ab3ECOgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:36:23 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48110 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933964Ab3ECOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:35:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 62/63] dmaengine: ste_dma40: Fetch the number of physical channels from DT
Date: Fri,  3 May 2013 15:32:48 +0100
Message-Id: <1367591569-32197-63-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms insist on obscure physical channel availability. This
information is currently passed though platform data in internal BSP
kernels. Once those platforms land, they'll need to configure them
appropriately, so we may as well add the infrastructure.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index bd5b156..ee96acb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3468,7 +3468,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 			       struct device_node *np)
 {
 	struct stedma40_platform_data *pdata;
-	int num_memcpy = 0;
+	int num_phy = 0, num_memcpy = 0;
 	const const __be32 *list;
 
 	pdata = devm_kzalloc(&pdev->dev,
@@ -3477,6 +3477,11 @@ static int __init d40_of_probe(struct platform_device *pdev,
 	if (!pdata)
 		return -ENOMEM;
 
+	/* If absent this value will be obtained from h/w. */
+	of_property_read_u32(np, "dma-channels", &num_phy);
+	if (num_phy > 0)
+		pdata->num_of_phy_chans = num_phy;
+
 	list = of_get_property(np, "memcpy-channels", &num_memcpy);
 	num_memcpy /= sizeof(*list);
 
-- 
1.7.10.4

