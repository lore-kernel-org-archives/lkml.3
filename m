Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab3CDJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:16:59 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:34925 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab3CDJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:16:57 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, sachin.kamat@linaro.org, patches@linaro.org,
        thierry.reding@avionic-design.de
Subject: [PATCH Resend] dma: pl330: Convert to devm_ioremap_resource()
Date: Mon,  4 Mar 2013 14:36:27 +0530
Message-Id: <1362387987-26718-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/dma/pl330.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 7181531..10005ec 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -26,6 +26,7 @@
 #include <linux/scatterlist.h>
 #include <linux/of.h>
 #include <linux/of_dma.h>
+#include <linux/err.h>
 
 #include "dmaengine.h"
 #define PL330_MAX_CHAN		8
@@ -2904,9 +2905,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pi->mcbufsz = pdat ? pdat->mcbuf_sz : 0;
 
 	res = &adev->res;
-	pi->base = devm_request_and_ioremap(&adev->dev, res);
-	if (!pi->base)
-		return -ENXIO;
+	pi->base = devm_ioremap_resource(&adev->dev, res);
+	if (IS_ERR(pi->base))
+		return PTR_ERR(pi->base);
 
 	amba_set_drvdata(adev, pdmac);
 
-- 
1.7.4.1

