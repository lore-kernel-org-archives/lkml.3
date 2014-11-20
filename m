Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbaKTNus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:50:48 -0500
Received: from mout.web.de ([212.227.15.4]:65297 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaKTNuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:50:46 -0500
Message-ID: <546DF1A2.8090208@users.sourceforge.net>
Date: Thu, 20 Nov 2014 14:50:26 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] net: Xilinx: Deletion of unnecessary checks before two
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:n0PztaUpBi4SWcCFw1tqJxkfHqeZZO6MHyAbeBbeoWKkGcC3wik
 55IiRPjJ9SwTE/OXLJ7nI4fMXHk1ICQZdRz38MceP8Io4ZmOWeGeqowA7bB/7D0IX0ieSDT
 j3F8CtGQFbFStRJCwNYtvra49trAQM62yCjE2g3eD5Od3bEmH8QwxDXpR+RayAhMPj3jUjB
 uOHL3yYqTZxPfXaNduXFQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 14:47:12 +0100

The functions kfree() and of_node_put() test whether their argument is NULL
and then return immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 3 +--
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index fda5891..af60867 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -224,8 +224,7 @@ static void temac_dma_bd_release(struct net_device *ndev)
 		dma_free_coherent(ndev->dev.parent,
 				sizeof(*lp->tx_bd_v) * TX_BD_NUM,
 				lp->tx_bd_v, lp->tx_bd_p);
-	if (lp->rx_skb)
-		kfree(lp->rx_skb);
+	kfree(lp->rx_skb);
 }
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 28dbbdc..2485879 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1200,8 +1200,7 @@ static int xemaclite_of_remove(struct platform_device *of_dev)
 
 	unregister_netdev(ndev);
 
-	if (lp->phy_node)
-		of_node_put(lp->phy_node);
+	of_node_put(lp->phy_node);
 	lp->phy_node = NULL;
 
 	xemaclite_remove_ndev(ndev);
-- 
2.1.3

