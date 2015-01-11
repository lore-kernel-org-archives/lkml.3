Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbbAKQbM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:31:12 -0500
Received: from smtp-out14.tpgi.com.au ([220.244.226.124]:40032 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751230AbbAKQbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:31:08 -0500
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Mon, 12 Jan 2015 03:21:09 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
From: Emrys Bayliss <emrys@paradise.net.nz>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Emrys Bayliss <emrys@paradise.net.nz>
Subject: [PATCH] Staging: vt6656: Checkpatch fix: else after break or return
Date: Mon, 12 Jan 2015 03:19:34 +1100
Message-Id: <1420993174-24908-1-git-send-email-emrys@paradise.net.nz>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
rxtx.c:588: WARNING: else is not generally useful after a break or return

Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
---
 drivers/staging/vt6656/rxtx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ea5140a..cc34704 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -553,8 +553,6 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
-
-		return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
 	} else {
 		struct vnt_cts *buf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
@@ -571,11 +569,9 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
-
-		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
 	}
 
-	return 0;
+	return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
 }
 
 static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
-- 
2.2.1

