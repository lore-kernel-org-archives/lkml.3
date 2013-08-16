Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3HPILr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:11:47 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52635 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3HPIKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:10:52 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7G8AaMD017142, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>, <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 5/7] r8152: move some declearation of variables
Date: Fri, 16 Aug 2013 16:09:36 +0800
Message-ID: <1376640578-4258-5-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376640578-4258-1-git-send-email-hayeswang@realtek.com>
References: <1376640578-4258-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some declearation of variables in rx_bottom().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 4dee76b..0a88f64 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1133,25 +1133,19 @@ r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc, struct sk_buff *skb)
 
 static void rx_bottom(struct r8152 *tp)
 {
-	struct net_device_stats *stats;
-	struct net_device *netdev;
-	struct rx_agg *agg;
-	struct rx_desc *rx_desc;
 	unsigned long flags;
 	struct list_head *cursor, *next;
-	struct sk_buff *skb;
-	struct urb *urb;
-	unsigned pkt_len;
-	int len_used;
-	u8 *rx_data;
-	int ret;
-
-	netdev = tp->netdev;
-
-	stats = rtl8152_get_stats(netdev);
 
 	spin_lock_irqsave(&tp->rx_lock, flags);
 	list_for_each_safe(cursor, next, &tp->rx_done) {
+		struct rx_desc *rx_desc;
+		struct rx_agg *agg;
+		unsigned pkt_len;
+		int len_used = 0;
+		struct urb *urb;
+		u8 *rx_data;
+		int ret;
+
 		list_del_init(cursor);
 		spin_unlock_irqrestore(&tp->rx_lock, flags);
 
@@ -1160,16 +1154,21 @@ static void rx_bottom(struct r8152 *tp)
 		if (urb->actual_length < ETH_ZLEN)
 			goto submit;
 
-		len_used = 0;
 		rx_desc = agg->head;
 		rx_data = agg->head;
 		pkt_len = le32_to_cpu(rx_desc->opts1) & RX_LEN_MASK;
 		len_used += sizeof(struct rx_desc) + pkt_len;
 
 		while (urb->actual_length >= len_used) {
+			struct net_device *netdev = tp->netdev;
+			struct net_device_stats *stats;
+			struct sk_buff *skb;
+
 			if (pkt_len < ETH_ZLEN)
 				break;
 
+			stats = rtl8152_get_stats(netdev);
+
 			pkt_len -= 4; /* CRC */
 			rx_data += sizeof(struct rx_desc);
 
-- 
1.8.3.1

