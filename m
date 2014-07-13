Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaGMTM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:12:29 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44478 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaGMTME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:12:04 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 3/4] staging: vt6556: Cleanup coding style issues
Date: Sun, 13 Jul 2014 21:11:20 +0200
Message-Id: <1405278681-3348-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
References: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup coding style issues reported by checkpatch.

Additionally this typedef was removed from card.h:

typedef enum _CARD_PHY_TYPE {
    PHY_TYPE_AUTO = 0,
    PHY_TYPE_11B,
    PHY_TYPE_11G,
    PHY_TYPE_11A
} CARD_PHY_TYPE, *PCARD_PHY_TYPE;

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Cahnges from V1:
 - Sent all patches in a series

Made against latest staging-next.

 drivers/staging/vt6656/card.c | 19 ++++++++-----------
 drivers/staging/vt6656/card.h | 13 +++----------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index ea06b63..f469d68 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -55,11 +55,12 @@
 #include "key.h"
 #include "usbpipe.h"
 
-//const u16 cwRXBCNTSFOff[MAX_RATE] =
-//{17, 34, 96, 192, 34, 23, 17, 11, 8, 5, 4, 3};
+/* const u16 cwRXBCNTSFOff[MAX_RATE] =
+   {17, 34, 96, 192, 34, 23, 17, 11, 8, 5, 4, 3}; */
 
-static const u16 cwRXBCNTSFOff[MAX_RATE] =
-{192, 96, 34, 17, 34, 23, 17, 11, 8, 5, 4, 3};
+static const u16 cwRXBCNTSFOff[MAX_RATE] = {
+	192, 96, 34, 17, 34, 23, 17, 11, 8, 5, 4, 3
+};
 
 /*
  * Description: Set NIC media channel
@@ -477,7 +478,7 @@ void vnt_update_top_rates(struct vnt_private *priv)
 	}
 
 	priv->byTopCCKBasicRate = top_cck;
- }
+}
 
 int vnt_ofdm_min_rate(struct vnt_private *priv)
 {
@@ -673,9 +674,7 @@ void vnt_reset_next_tbtt(struct vnt_private *priv, u16 beacon_interval)
 	data[7] = (u8)(next_tbtt >> 56);
 
 	vnt_control_out(priv, MESSAGE_TYPE_SET_TSFTBTT,
-		MESSAGE_REQUEST_TBTT, 0, 8, data);
-
-	return;
+			MESSAGE_REQUEST_TBTT, 0, 8, data);
 }
 
 /*
@@ -710,11 +709,9 @@ void vnt_update_next_tbtt(struct vnt_private *priv, u64 tsf,
 	data[7] = (u8)(tsf >> 56);
 
 	vnt_control_out(priv, MESSAGE_TYPE_SET_TSFTBTT,
-		MESSAGE_REQUEST_TBTT, 0, 8, data);
+			MESSAGE_REQUEST_TBTT, 0, 8, data);
 
 	dev_dbg(&priv->usb->dev, "%s TBTT: %8llx\n", __func__, tsf);
-
-	return;
 }
 
 /*
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 5b7cc5a..03fc167 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -32,16 +32,9 @@
 
 /* init card type */
 
-typedef enum _CARD_PHY_TYPE {
-    PHY_TYPE_AUTO = 0,
-    PHY_TYPE_11B,
-    PHY_TYPE_11G,
-    PHY_TYPE_11A
-} CARD_PHY_TYPE, *PCARD_PHY_TYPE;
-
-#define CB_MAX_CHANNEL_24G  14
-#define CB_MAX_CHANNEL_5G       42 /* add channel9(5045MHz), 41==>42 */
-#define CB_MAX_CHANNEL      (CB_MAX_CHANNEL_24G+CB_MAX_CHANNEL_5G)
+#define CB_MAX_CHANNEL_24G	14
+#define CB_MAX_CHANNEL_5G	42 /* add channel9(5045MHz), 41==>42 */
+#define CB_MAX_CHANNEL		(CB_MAX_CHANNEL_24G + CB_MAX_CHANNEL_5G)
 
 struct vnt_private;
 
-- 
1.9.3

