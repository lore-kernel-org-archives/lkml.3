Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808Ab3DKVVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:21:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935412Ab3DKUst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:49 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wEtwyrxjTdoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Hd6TVcZMLBAA:10 a=sozttTNsAAAA:8 a=pMYVDHWHAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=x2szoZtqnggA:10 a=BT31R4TembEA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202612.309755060@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Franke <dan.franke@schneider-electric.com>,
        Sriramakrishnan A G <srk@ti.com>, Mugunthan V N <mugunthanvnm@ti.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 159/171 ] drivers: net: ethernet: cpsw: use netif_wake_queue() while
 restarting tx queue
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0159-drivers-net-ethernet-cpsw-use-netif_wake_queue-while.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mugunthan V N <mugunthanvnm@ti.com>

[ Upstream commit b56d6b3fca6d1214dbc9c5655f26e5d4ec04afc8 ]

To restart tx queue use netif_wake_queue() intead of netif_start_queue()
so that net schedule will restart transmission immediately which will
increase network performance while doing huge data transfers.

Reported-by: Dan Franke <dan.franke@schneider-electric.com>
Suggested-by: Sriramakrishnan A G <srk@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/ti/cpsw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 1e5d85b..0ab0a10 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -250,7 +250,7 @@ void cpsw_tx_handler(void *token, int len, int status)
 	struct cpsw_priv	*priv = netdev_priv(ndev);
 
 	if (unlikely(netif_queue_stopped(ndev)))
-		netif_start_queue(ndev);
+		netif_wake_queue(ndev);
 	priv->stats.tx_packets++;
 	priv->stats.tx_bytes += len;
 	dev_kfree_skb_any(skb);
-- 
1.7.10.4


