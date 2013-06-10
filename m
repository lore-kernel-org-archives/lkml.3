Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3FJLt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:49:59 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62318 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3FJLtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:49:55 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: [PATCH 02/15] sudmac: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:00 +0530
Message-Id: <1370864113-17895-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <djbw@fb.com>
---
 drivers/dma/sh/sudmac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index e7c94bb..0a81e30 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -360,9 +360,9 @@ static int sudmac_probe(struct platform_device *pdev)
 
 	dma_dev = &su_dev->shdma_dev.dma_dev;
 
-	su_dev->chan_reg = devm_request_and_ioremap(&pdev->dev, chan);
-	if (!su_dev->chan_reg)
-		return err;
+	su_dev->chan_reg = devm_ioremap_resource(&pdev->dev, chan);
+	if (IS_ERR(su_dev->chan_reg))
+		return PTR_ERR(su_dev->chan_reg);
 
 	dma_cap_set(DMA_SLAVE, dma_dev->cap_mask);
 
-- 
1.7.9.5

