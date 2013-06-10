Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3FJLxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:53:19 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48580 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3FJLuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:15 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 06/15] net: bcm63xx_enet: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:04 +0530
Message-Id: <1370864113-17895-7-git-send-email-tushar.behera@linaro.org>
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
CC: netdev@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>
---
* Not compile tested.

 drivers/net/ethernet/broadcom/bcm63xx_enet.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index e46466c..d690308 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1641,9 +1641,9 @@ static int bcm_enet_probe(struct platform_device *pdev)
 	if (ret)
 		goto out;
 
-	priv->base = devm_request_and_ioremap(&pdev->dev, res_mem);
-	if (priv->base == NULL) {
-		ret = -ENOMEM;
+	priv->base = devm_ioremap_resource(&pdev->dev, res_mem);
+	if (IS_ERR(priv->base)) {
+		ret = PTR_ERR(priv->base);
 		goto out;
 	}
 
@@ -1871,9 +1871,9 @@ static int bcm_enet_shared_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	bcm_enet_shared_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!bcm_enet_shared_base)
-		return -ENOMEM;
+	bcm_enet_shared_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(bcm_enet_shared_base))
+		return PTR_ERR(bcp_enet_shared_base);
 
 	return 0;
 }
-- 
1.7.9.5

