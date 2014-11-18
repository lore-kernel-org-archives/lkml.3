Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaKRFUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 00:20:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaKRFUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 00:20:50 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH net-next] tun: return NET_XMIT_DROP for dropped packets
Date: Tue, 18 Nov 2014 13:20:41 +0800
Message-Id: <1416288041-30921-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 5d097109257c03a71845729f8db6b5770c4bbedc
("tun: only queue packets on device"), NETDEV_TX_OK was returned for
dropped packets. This will confuse pktgen since dropped packets were
counted as sent ones.

Fixing this by returning NET_XMIT_DROP to let pktgen count it as error
packet.

Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e3fa65a..ac53a73 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -819,7 +819,7 @@ drop:
 	skb_tx_error(skb);
 	kfree_skb(skb);
 	rcu_read_unlock();
-	return NETDEV_TX_OK;
+	return NET_XMIT_DROP;
 }
 
 static void tun_net_mclist(struct net_device *dev)
-- 
1.9.1

