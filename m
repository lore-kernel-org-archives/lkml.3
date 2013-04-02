Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab3DBSsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:48:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58595 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933039Ab3DBSsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:48:14 -0400
X-Sasl-enc: J4tA45Ebi0pv+Q9XN9HeBC0xImyxFNocLfIQtksDN6Vr 1364928493
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 5/6] 6lowpan: handle dev_queue_xmit error code properly
Date: Tue,  2 Apr 2013 14:48:00 -0400
Message-Id: <1364928481-1813-6-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1364928481-1813-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_queue_xmit() can return positive error codes, so check for nonzero.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/ieee802154/6lowpan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index e1b4580..a68c792 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1139,7 +1139,7 @@ static netdev_tx_t lowpan_xmit(struct sk_buff *skb, struct net_device *dev)
 error:
 	dev_kfree_skb(skb);
 out:
-	if (err < 0)
+	if (err)
 		pr_debug("ERROR: xmit failed\n");
 
 	return (err < 0 ? NETDEV_TX_BUSY : NETDEV_TX_OK);
-- 
1.7.11.2

