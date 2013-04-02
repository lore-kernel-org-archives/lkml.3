Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110Ab3DBWUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:20:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933728Ab3DBWOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Franke <dan.franke@schneider-electric.com>,
        Sriramakrishnan A G <srk@ti.com>, Mugunthan V N <mugunthanvnm@ti.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 57/68] drivers: net: ethernet: cpsw: use netif_wake_queue() while restarting tx queue
Date: Tue,  2 Apr 2013 15:13:46 -0700
Message-Id: <20130402221336.562573566@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -249,7 +249,7 @@ void cpsw_tx_handler(void *token, int le
 	struct cpsw_priv	*priv = netdev_priv(ndev);
 
 	if (unlikely(netif_queue_stopped(ndev)))
-		netif_start_queue(ndev);
+		netif_wake_queue(ndev);
 	priv->stats.tx_packets++;
 	priv->stats.tx_bytes += len;
 	dev_kfree_skb_any(skb);


