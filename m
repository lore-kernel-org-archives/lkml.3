Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3L3RTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 12:19:30 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:37280 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756214Ab3L3RTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:19:08 -0500
X-IronPort-AV: E=Sophos;i="4.95,574,1384297200"; 
   d="scan'208";a="51019974"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/11]  use ether_addr_equal_64bits
Date: Mon, 30 Dec 2013 19:15:04 +0100
Message-Id: <1388427307-8691-9-git-send-email-Julia.Lawall@lip6.fr>
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
ieee80211_hdr defined in include/linux/ieee80211.h
ath_common defined in drivers/net/wireless/ath/ath.h

This was done using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch used is rather long and can be found in message 0 of
this patch series.

 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index c028df7..b41e008 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1077,7 +1077,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 
 	if (ieee80211_is_beacon(hdr->frame_control) &&
 	    !is_zero_ether_addr(common->curbssid) &&
-	    ether_addr_equal(hdr->addr3, common->curbssid)) {
+	    ether_addr_equal_64bits(hdr->addr3, common->curbssid)) {
 		s8 rssi = rxbuf->rxstatus.rs_rssi;
 
 		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 3692b2a..0152318 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -982,7 +982,7 @@ static bool ath9k_is_mybeacon(struct ath_softc *sc, struct ieee80211_hdr *hdr)
 	if (ieee80211_is_beacon(hdr->frame_control)) {
 		RX_STAT_INC(rx_beacons);
 		if (!is_zero_ether_addr(common->curbssid) &&
-		    ether_addr_equal(hdr->addr3, common->curbssid))
+		    ether_addr_equal_64bits(hdr->addr3, common->curbssid))
 			return true;
 	}
 

