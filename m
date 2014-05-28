Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaE1PNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:13:16 -0400
Received: from isis.lip6.fr ([132.227.60.2]:50523 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbaE1PNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:13:14 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: netdev@vger.kernel.org
Cc: benoit.taine@lip6.fr, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] lpc_eth: Use resource_size instead of computation
Date: Wed, 28 May 2014 17:14:07 +0200
Message-Id: <1401290047-30005-3-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401290047-30005-1-git-send-email-benoit.taine@lip6.fr>
References: <1401290047-30005-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Wed, 28 May 2014 17:13:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/resource_size.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Not compile tested, due incompatible architecture.

 drivers/net/ethernet/nxp/lpc_eth.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 422d9b5..dc2f15c 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1361,7 +1361,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	__lpc_eth_clock_enable(pldat, true);
 
 	/* Map IO space */
-	pldat->net_base = ioremap(res->start, res->end - res->start + 1);
+	pldat->net_base = ioremap(res->start, resource_size(res));
 	if (!pldat->net_base) {
 		dev_err(&pdev->dev, "failed to map registers\n");
 		ret = -ENOMEM;
@@ -1419,8 +1419,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 
 	netdev_dbg(ndev, "IO address start     :0x%08x\n",
 			res->start);
-	netdev_dbg(ndev, "IO address size      :%d\n",
-			res->end - res->start + 1);
+	netdev_dbg(ndev, "IO address size      :%d\n", resource_size(res));
 	netdev_dbg(ndev, "IO address (mapped)  :0x%p\n",
 			pldat->net_base);
 	netdev_dbg(ndev, "IRQ number           :%d\n", ndev->irq);

