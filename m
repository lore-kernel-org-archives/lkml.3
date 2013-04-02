Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782Ab3DBWRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:17:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933864Ab3DBWOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Franke <dan.franke@schneider-electric.com>,
        Sriramakrishnan A G <srk@ti.com>, Mugunthan V N <mugunthanvnm@ti.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 56/68] drivers: net: ethernet: davinci_emac: use netif_wake_queue() while restarting tx queue
Date: Tue,  2 Apr 2013 15:13:45 -0700
Message-Id: <20130402221336.452379651@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


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
 drivers/net/ethernet/ti/davinci_emac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1052,7 +1052,7 @@ static void emac_tx_handler(void *token,
 	atomic_dec(&priv->cur_tx);
 
 	if (unlikely(netif_queue_stopped(ndev)))
-		netif_start_queue(ndev);
+		netif_wake_queue(ndev);
 	ndev->stats.tx_packets++;
 	ndev->stats.tx_bytes += len;
 	dev_kfree_skb_any(skb);


