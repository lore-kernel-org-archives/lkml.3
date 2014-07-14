Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbaGNTQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:16:40 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46699 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbaGNTQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:16:04 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V4 3/6] staging: vt6556: Remove uneeded return statements
Date: Mon, 14 Jul 2014 21:15:30 +0200
Message-Id: <1405365333-17170-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405365333-17170-1-git-send-email-peter.senna@gmail.com>
References: <1405365333-17170-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove uneeded return statements reported by checkpatch
and fixes the indentation of a multi-line call.

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Cahnges from V3:
 - Splitted the patches by change type

 drivers/staging/vt6656/card.c     |  6 +-----
 drivers/staging/vt6656/main_usb.c | 13 -------------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 37cd96b..f469d68 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -674,9 +674,7 @@ void vnt_reset_next_tbtt(struct vnt_private *priv, u16 beacon_interval)
 	data[7] = (u8)(next_tbtt >> 56);
 
 	vnt_control_out(priv, MESSAGE_TYPE_SET_TSFTBTT,
-		MESSAGE_REQUEST_TBTT, 0, 8, data);
-
-	return;
+			MESSAGE_REQUEST_TBTT, 0, 8, data);
 }
 
 /*
@@ -714,8 +712,6 @@ void vnt_update_next_tbtt(struct vnt_private *priv, u64 tsf,
 			MESSAGE_REQUEST_TBTT, 0, 8, data);
 
 	dev_dbg(&priv->usb->dev, "%s TBTT: %8llx\n", __func__, tsf);
-
-	return;
 }
 
 /*
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 8e05f04..553a8e9 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -493,8 +493,6 @@ static void device_free_tx_bufs(struct vnt_private *priv)
 
 		kfree(tx_context);
 	}
-
-	return;
 }
 
 static void device_free_rx_bufs(struct vnt_private *priv)
@@ -519,8 +517,6 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 
 		kfree(rcb);
 	}
-
-	return;
 }
 
 static void usb_device_reset(struct vnt_private *pDevice)
@@ -530,14 +526,11 @@ static void usb_device_reset(struct vnt_private *pDevice)
 	status = usb_reset_device(pDevice->usb);
 	if (status)
             printk("usb_device_reset fail status=%d\n",status);
-	return ;
 }
 
 static void device_free_int_bufs(struct vnt_private *priv)
 {
 	kfree(priv->int_buf.data_buf);
-
-	return;
 }
 
 static bool device_alloc_bufs(struct vnt_private *priv)
@@ -718,8 +711,6 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	usb_kill_urb(priv->pInterruptURB);
 	usb_free_urb(priv->pInterruptURB);
-
-	return;
 }
 
 static int vnt_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
@@ -785,8 +776,6 @@ static void vnt_remove_interface(struct ieee80211_hw *hw,
 
 	/* LED slow blink */
 	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_SLOW);
-
-	return;
 }
 
 static int vnt_config(struct ieee80211_hw *hw, u32 changed)
@@ -966,8 +955,6 @@ static void vnt_configure(struct ieee80211_hw *hw,
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG, MAC_REG_RCR, rx_mode);
 
 	dev_dbg(&priv->usb->dev, "rx mode out= %x\n", rx_mode);
-
-	return;
 }
 
 static int vnt_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-- 
1.9.3

