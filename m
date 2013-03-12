Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3CLXEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:04:05 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51224 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3CLWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:16 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, stigge@antcom.de, edumazet@google.com,
        gregkh@linuxfoundation.org, jiri@resnulli.us,
        linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] net: lpc_eth: fix coccicheck warnings
Date: Wed, 13 Mar 2013 00:33:05 +0200
Message-Id: <1363127585-7925-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() instead of explicit calculation and change the way
debugging for struct resource is done.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/net/ethernet/nxp/lpc_eth.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index c4122c8..7862f96 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1362,7 +1362,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	__lpc_eth_clock_enable(pldat, true);
 
 	/* Map IO space */
-	pldat->net_base = ioremap(res->start, res->end - res->start + 1);
+	pldat->net_base = ioremap(res->start, resource_size(res));
 	if (!pldat->net_base) {
 		dev_err(&pdev->dev, "failed to map registers\n");
 		ret = -ENOMEM;
@@ -1418,10 +1418,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	}
 	pldat->dma_buff_base_p = dma_handle;
 
-	netdev_dbg(ndev, "IO address start     :0x%08x\n",
-			res->start);
-	netdev_dbg(ndev, "IO address size      :%d\n",
-			res->end - res->start + 1);
+	netdev_dbg(ndev, "IO resource          :%pR\n", res);
 	netdev_dbg(ndev, "IO address (mapped)  :0x%p\n",
 			pldat->net_base);
 	netdev_dbg(ndev, "IRQ number           :%d\n", ndev->irq);
-- 
1.7.9.5

