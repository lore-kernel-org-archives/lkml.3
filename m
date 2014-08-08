Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbaHHKMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:12:43 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7449 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756362AbaHHKLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:11:16 -0400
X-IronPort-AV: E=Sophos;i="5.01,824,1400018400"; 
   d="scan'208";a="88704760"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Michal Simek <michal.simek@xilinx.com>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: =?UTF-8?q?=5BPATCH=2012/14=5D=20ll=5Ftemac=3A=20delete=20unneeded=20test=20before=20of=5Fnode=5Fput?=
Date: Fri,  8 Aug 2014 12:07:53 +0200
Message-Id: <1407492475-26283-12-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Of_node_put supports NULL as its argument, so the initial test is not
necessary.

Suggested by Uwe Kleine-König.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

-if (e)
   of_node_put(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 8a6e5c2..36f4459 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1148,8 +1148,7 @@ static int temac_of_remove(struct platform_device *op)
 	temac_mdio_teardown(lp);
 	unregister_netdev(ndev);
 	sysfs_remove_group(&lp->dev->kobj, &temac_attr_group);
-	if (lp->phy_node)
-		of_node_put(lp->phy_node);
+	of_node_put(lp->phy_node);
 	lp->phy_node = NULL;
 	iounmap(lp->regs);
 	if (lp->sdma_regs)

