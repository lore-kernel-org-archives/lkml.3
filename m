Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaKYNf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:35:56 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39206 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaKYNfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:35:54 -0500
From: Athira Lekshmi C V <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: forest@alittletooquiet.net, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Athira Lekshmi C V <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:Staging:vt6656: Fixed checkpatch warning
Date: Tue, 25 Nov 2014 19:05:51 +0530
Message-Id: <1416922551-7401-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning:
WARNING: else is not generally useful after a break or return

Signed-off-by: Athira Lekshmi C V <andnlnbn18@gmail.com>
---
 drivers/staging/vt6656/rxtx.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ea5140a..af79be8 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -555,27 +555,24 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
-	} else {
-		struct vnt_cts *buf = &head->cts_g;
-		/* Get SignalField,ServiceField,Length */
-		vnt_get_phy_field(priv, cts_frame_len,
-			priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
-		/* Get CTSDuration_ba */
-		buf->duration_ba =
-			vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA,
-						   tx_context->pkt_type,
-						   current_rate);
-		/*Get CTS Frame body*/
-		buf->data.duration = buf->duration_ba;
-		buf->data.frame_control =
-			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
-
-		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
-
-		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
 	}
+	struct vnt_cts *buf = &head->cts_g;
+	/* Get SignalField,ServiceField,Length */
+	vnt_get_phy_field(priv, cts_frame_len,
+		priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
+	/* Get CTSDuration_ba */
+	buf->duration_ba =
+		vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA,
+					   tx_context->pkt_type,
+					   current_rate);
+	/*Get CTS Frame body*/
+	buf->data.duration = buf->duration_ba;
+	buf->data.frame_control =
+		cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-	return 0;
+	memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
+
+	return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
 }
 
 static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
-- 
1.7.9.5

