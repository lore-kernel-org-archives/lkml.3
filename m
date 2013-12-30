Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3L3RT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 12:19:26 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:37280 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756051Ab3L3RTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:19:07 -0500
X-IronPort-AV: E=Sophos;i="4.95,574,1384297200"; 
   d="scan'208";a="51019971"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/11] mwl8k: use ether_addr_equal_64bits
Date: Mon, 30 Dec 2013 19:15:01 +0100
Message-Id: <1388427307-8691-6-git-send-email-Julia.Lawall@lip6.fr>
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
mwl8k_priv defined in drivers/net/wireless/mwl8k.c

This was done using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch used is rather long and can be found in message 0 of
this patch series.

 drivers/net/wireless/mwl8k.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b953ad6..13c9ac5 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1258,7 +1258,7 @@ mwl8k_capture_bssid(struct mwl8k_priv *priv, struct ieee80211_hdr *wh)
 {
 	return priv->capture_beacon &&
 		ieee80211_is_beacon(wh->frame_control) &&
-		ether_addr_equal(wh->addr3, priv->capture_bssid);
+		ether_addr_equal_64bits(wh->addr3, priv->capture_bssid);
 }
 
 static inline void mwl8k_save_beacon(struct ieee80211_hw *hw,

