Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3GLI0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:26:37 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:47023 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab3GLI0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:26:32 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6C8QQR2027486, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <gregkh@linuxfoundation.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 1/2] usb/net/r8152: fix integer overflow in expression
Date: Fri, 12 Jul 2013 16:26:15 +0800
Message-ID: <1373617576-2272-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config: make ARCH=avr32 allyesconfig
drivers/net/usb/r8152.c: In function 'rtl8152_start_xmit':
drivers/net/usb/r8152.c:956: warning: integer overflow in expression

   955	memset(tx_desc, 0, sizeof(*tx_desc));
 > 956	tx_desc->opts1 = cpu_to_le32((len & TX_LEN_MASK) | TX_FS | TX_LS);
   957	tp->tx_skb = skb;

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Spotted-by: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/net/usb/r8152.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d02bac8..ee13f9e 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -934,7 +934,8 @@ static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
 	struct r8152 *tp = netdev_priv(netdev);
 	struct net_device_stats *stats = rtl8152_get_stats(netdev);
 	struct tx_desc *tx_desc;
-	int len, res;
+	unsigned int len;
+	int res;
 
 	netif_stop_queue(netdev);
 	len = skb->len;
-- 
1.8.3.1

