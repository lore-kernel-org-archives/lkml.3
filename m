Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbaFQT2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:28:55 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:28325 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932657AbaFQT2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:28:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQJABeWoFNbsl1t/2dsb2JhbABagw2rKgUBAQEBAQEFAZkmgQ0XdYQxLyOBGjeIRgHLQBeFY4kTHYQtBJpDizCIKIF+gUQ7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 1/1] drivers/net/ethernet/xilinx/ll_temac_main.c: remove null test before kfree
Date: Tue, 17 Jun 2014 21:27:33 +0200
Message-Id: <1403033253-7011-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 4ef818a..21b6e297 100644
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
-- 
1.8.4.5

