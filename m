Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3L3RTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 12:19:23 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:25199 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756199Ab3L3RTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:19:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,574,1384297200"; 
   d="scan'208";a="51019969"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/11] mac80211: use ether_addr_equal_64bits
Date: Mon, 30 Dec 2013 19:14:59 +0100
Message-Id: <1388427307-8691-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Ether_addr_equal_64bits is more efficient than ether_addr_equal, and can be
used when each argument is an array within a structure that contains at
least two bytes of data beyond the array.

The structures involved are:
ieee80211_hdr defined in include/linux/ieee80211.h and
p54_common defined in drivers/net/wireless/p54/p54.h

This was done using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch used is rather long and can be found in message 0 of
this patch series.

 drivers/net/wireless/p54/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index f95de0d..b7cc7c2 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -308,7 +308,7 @@ static void p54_pspoll_workaround(struct p54_common *priv, struct sk_buff *skb)
 		return;
 
 	/* only consider beacons from the associated BSSID */
-	if (!ether_addr_equal(hdr->addr3, priv->bssid))
+	if (!ether_addr_equal_64bits(hdr->addr3, priv->bssid))
 		return;
 
 	tim = p54_find_ie(skb, WLAN_EID_TIM);

