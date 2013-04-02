Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab3DBSuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:50:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44350 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab3DBSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:48:13 -0400
X-Sasl-enc: J4tD+oUVh0pw4gxCKtnCEDwxImyxFNocLfIQtksDN6Vr 1364928493
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 4/6] mac802154: Increase tx_buffer_len
Date: Tue,  2 Apr 2013 14:47:59 -0400
Message-Id: <1364928481-1813-5-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1364928481-1813-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the buffer length from 10 to 300 packets. Consider that traffic on
mac802154 devices will often be 6LoWPAN, and a full-length (1280 octet)
IPv6 packet will fragment into 15 6LoWPAN fragments (because the MTU of
IEEE 802.15.4 is 127).  A 300-packet queue is really 20 full-length IPv6
packets.

With a queue length of 10, an entire IPv6 packet was unable to get queued
at one time, causing fragments to be dropped, and making reassembly
impossible.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/mac802154/wpan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/wpan.c b/net/mac802154/wpan.c
index 7d3f659..2ca2f4d 100644
--- a/net/mac802154/wpan.c
+++ b/net/mac802154/wpan.c
@@ -360,7 +360,7 @@ void mac802154_wpan_setup(struct net_device *dev)
 	dev->header_ops		= &mac802154_header_ops;
 	dev->needed_tailroom	= 2; /* FCS */
 	dev->mtu		= IEEE802154_MTU;
-	dev->tx_queue_len	= 10;
+	dev->tx_queue_len	= 300;
 	dev->type		= ARPHRD_IEEE802154;
 	dev->flags		= IFF_NOARP | IFF_BROADCAST;
 	dev->watchdog_timeo	= 0;
-- 
1.7.11.2

