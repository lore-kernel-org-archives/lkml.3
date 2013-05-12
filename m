Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3ELPrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:47:35 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35627 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3ELPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:47:34 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: davem@davemloft.net
Cc: cernekee@gmail.com, jogo@openwrt.org, joe@perches.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: net: ethernet: broadcom: bcm63xx: use devm_ioremap_resource()
Date: Sun, 12 May 2013 17:56:05 +0200
Message-Id: <1368374165-3228-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_ioremap_resource.cocci

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 0b3e23e..9de4217 100644
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
 
-- 
1.7.10.4

