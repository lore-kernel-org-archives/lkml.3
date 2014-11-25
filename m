Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaKYMPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:15:49 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37685 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaKYMPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:15:45 -0500
From: Athira Lekshmi C V <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: forest@alittletooquiet.net, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Athira Lekshmi C V <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:vt6656: Fixed checkpatch warning
Date: Tue, 25 Nov 2014 17:45:40 +0530
Message-Id: <1416917740-5001-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning:
WARNING: Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)

Signed-off-by: Athira Lekshmi C V <andnlnbn18@gmail.com>
---
 drivers/staging/vt6656/rxtx.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ea5140a..ede71a4 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -392,8 +392,8 @@ static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
 	rts->frame_control =
 		cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
 
-	memcpy(rts->ra, hdr->addr1, ETH_ALEN);
-	memcpy(rts->ta, hdr->addr2, ETH_ALEN);
+	ether_addr_copy(rts->ra, hdr->addr1);
+	ether_addr_copy(rts->ta, hdr->addr2);
 
 	return 0;
 }
@@ -552,7 +552,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
+		ether_addr_copy(buf->data.ra, priv->current_net_addr);
 
 		return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
 	} else {
@@ -570,7 +570,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
+		ether_addr_copy(buf->data.ra, priv->current_net_addr);
 
 		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
 	}
@@ -739,7 +739,7 @@ static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
 
 		mic_hdr->id = 0x59;
 		mic_hdr->payload_len = cpu_to_be16(payload_len);
-		memcpy(mic_hdr->mic_addr2, hdr->addr2, ETH_ALEN);
+		ether_addr_copy(mic_hdr->mic_addr2, hdr->addr2);
 
 		ieee80211_get_key_tx_seq(tx_key, &seq);
 
@@ -750,9 +750,9 @@ static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
 		else
 			mic_hdr->hlen = cpu_to_be16(22);
 
-		memcpy(mic_hdr->addr1, hdr->addr1, ETH_ALEN);
-		memcpy(mic_hdr->addr2, hdr->addr2, ETH_ALEN);
-		memcpy(mic_hdr->addr3, hdr->addr3, ETH_ALEN);
+		ether_addr_copy(mic_hdr->addr1, hdr->addr1);
+		ether_addr_copy(mic_hdr->addr2, hdr->addr2);
+		ether_addr_copy(mic_hdr->addr3, hdr->addr3);
 
 		mic_hdr->frame_control = cpu_to_le16(
 			le16_to_cpu(hdr->frame_control) & 0xc78f);
@@ -760,7 +760,7 @@ static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
 				le16_to_cpu(hdr->seq_ctrl) & 0xf);
 
 		if (ieee80211_has_a4(hdr->frame_control))
-			memcpy(mic_hdr->addr4, hdr->addr4, ETH_ALEN);
+			ether_addr_copy(mic_hdr->addr4, hdr->addr4);
 
 
 		memcpy(key_buffer, tx_key->key, WLAN_KEY_LEN_CCMP);
-- 
1.7.9.5

