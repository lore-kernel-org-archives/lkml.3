Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbaBRNvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:51:46 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:48412 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbaBRNuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:50:07 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1IDo56X029699, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 12/14] r8152: replace netif_rx with netif_receive_skb
Date: Tue, 18 Feb 2014 21:49:09 +0800
Message-ID: <1392731351-25502-13-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
References: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace netif_rx with netif_receive_skb to avoid disabling irq frequently
for increasing the efficiency.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 3ff11ed..ff02d5d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1464,7 +1464,7 @@ static void rx_bottom(struct r8152 *tp)
 			memcpy(skb->data, rx_data, pkt_len);
 			skb_put(skb, pkt_len);
 			skb->protocol = eth_type_trans(skb, netdev);
-			netif_rx(skb);
+			netif_receive_skb(skb);
 			stats->rx_packets++;
 			stats->rx_bytes += pkt_len;
 
-- 
1.8.4.2

