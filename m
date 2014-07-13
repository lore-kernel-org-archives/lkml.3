Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbaGMTMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:12:18 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:37352 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaGMTL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:11:59 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 2/4] staging: vt6556: Cleanup coding style issues
Date: Sun, 13 Jul 2014 21:11:19 +0200
Message-Id: <1405278681-3348-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
References: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup coding style issues reported by checkpatch.

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Cahnges from V1:
 - Sent all patches in a series

Made against latest staging-next.

 drivers/staging/vt6656/main_usb.c | 118 +++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4cdf29e..13be8b2 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -62,7 +62,7 @@
 #include "int.h"
 
 /* static int msglevel = MSG_LEVEL_DEBUG; */
-static int          msglevel                =MSG_LEVEL_INFO;
+static int msglevel = MSG_LEVEL_INFO;
 
 /*
  * define module options
@@ -75,18 +75,18 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(DEVICE_FULL_DRV_NAM);
 
-#define DEVICE_PARAM(N,D) \
-        static int N[MAX_UINTS]=OPTION_DEFAULT;\
-        module_param_array(N, int, NULL, 0);\
-        MODULE_PARM_DESC(N, D);
+#define DEVICE_PARAM(N, D) \
+	static int N[MAX_UINTS] = OPTION_DEFAULT;	\
+	module_param_array(N, int, NULL, 0);		\
+	MODULE_PARM_DESC(N, D)
 
-#define RX_DESC_DEF0     64
-DEVICE_PARAM(RxDescriptors0,"Number of receive usb desc buffer");
+#define RX_DESC_DEF0 64
+DEVICE_PARAM(RxDescriptors0, "Number of receive usb desc buffer");
 
-#define TX_DESC_DEF0     64
-DEVICE_PARAM(TxDescriptors0,"Number of transmit usb desc buffer");
+#define TX_DESC_DEF0 64
+DEVICE_PARAM(TxDescriptors0, "Number of transmit usb desc buffer");
 
-#define CHANNEL_DEF     6
+#define CHANNEL_DEF 6
 DEVICE_PARAM(Channel, "Channel number");
 
 /* PreambleType[] is the preamble length used for transmit.
@@ -177,13 +177,12 @@ static struct usb_device_id vt6656_table[] = {
 /* frequency list (map channels to frequencies) */
 /*
 static const long frequency_list[] = {
-    2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
-    4915, 4920, 4925, 4935, 4940, 4945, 4960, 4980,
-    5035, 5040, 5045, 5055, 5060, 5080, 5170, 5180, 5190, 5200, 5210, 5220, 5230, 5240,
-    5260, 5280, 5300, 5320, 5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640, 5660, 5680,
-    5700, 5745, 5765, 5785, 5805, 5825
-	};
-
+	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467,
+	2472, 2484, 4915, 4920, 4925, 4935, 4940, 4945, 4960, 4980, 5035, 5040,
+	5045, 5055, 5060, 5080, 5170, 5180, 5190, 5200, 5210, 5220, 5230, 5240,
+	5260, 5280, 5300, 5320, 5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640,
+	5660, 5680, 5700, 5745, 5765, 5785, 5805, 5825
+};
 */
 
 static int vt6656_probe(struct usb_interface *intf,
@@ -206,16 +205,16 @@ static void usb_device_reset(struct vnt_private *pDevice);
 
 static void
 device_set_options(struct vnt_private *pDevice) {
-    pDevice->cbTD = TX_DESC_DEF0;
-    pDevice->cbRD = RX_DESC_DEF0;
-    pDevice->byShortRetryLimit = SHORT_RETRY_DEF;
-    pDevice->byLongRetryLimit = LONG_RETRY_DEF;
-    pDevice->op_mode = NL80211_IFTYPE_UNSPECIFIED;
-    pDevice->byBBType = BBP_TYPE_DEF;
-    pDevice->byPacketType = pDevice->byBBType;
-    pDevice->byAutoFBCtrl = AUTO_FB_0;
-    pDevice->byPreambleType = 0;
-    pDevice->bExistSWNetAddr = false;
+	pDevice->cbTD = TX_DESC_DEF0;
+	pDevice->cbRD = RX_DESC_DEF0;
+	pDevice->byShortRetryLimit = SHORT_RETRY_DEF;
+	pDevice->byLongRetryLimit = LONG_RETRY_DEF;
+	pDevice->op_mode = NL80211_IFTYPE_UNSPECIFIED;
+	pDevice->byBBType = BBP_TYPE_DEF;
+	pDevice->byPacketType = pDevice->byBBType;
+	pDevice->byAutoFBCtrl = AUTO_FB_0;
+	pDevice->byPreambleType = 0;
+	pDevice->bExistSWNetAddr = false;
 }
 
 /*
@@ -383,38 +382,40 @@ static int device_init_registers(struct vnt_private *pDevice)
 	/* load vt3266 calibration parameters in EEPROM */
 	if (pDevice->byRFType == RF_VT3226D0) {
 		if ((pDevice->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
-			(pDevice->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
+		   (pDevice->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
 
 			byCalibTXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_IQ];
 			byCalibTXDC = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_DC];
 			byCalibRXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_RX_IQ];
 			if (byCalibTXIQ || byCalibTXDC || byCalibRXIQ) {
-			/* CR255, enable TX/RX IQ and DC compensation mode */
+				/* CR255, enable TX/RX IQ and
+				   DC compensation mode */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xff,
-					0x03);
-			/* CR251, TX I/Q Imbalance Calibration */
+						   MESSAGE_REQUEST_BBREG,
+						   0xff,
+						   0x03);
+				/* CR251, TX I/Q Imbalance Calibration */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xfb,
-					byCalibTXIQ);
-			/* CR252, TX DC-Offset Calibration */
+						   MESSAGE_REQUEST_BBREG,
+						   0xfb,
+						   byCalibTXIQ);
+				/* CR252, TX DC-Offset Calibration */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xfC,
-					byCalibTXDC);
-			/* CR253, RX I/Q Imbalance Calibration */
+						   MESSAGE_REQUEST_BBREG,
+						   0xfC,
+						   byCalibTXDC);
+				/* CR253, RX I/Q Imbalance Calibration */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xfd,
-					byCalibRXIQ);
+						   MESSAGE_REQUEST_BBREG,
+						   0xfd,
+						   byCalibRXIQ);
 			} else {
-			/* CR255, turn off BB Calibration compensation */
+				/* CR255, turn off
+				   BB Calibration compensation */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xff,
-					0x0);
+						   MESSAGE_REQUEST_BBREG,
+						   0xff,
+						   0x0);
 			}
 		}
 	}
@@ -494,8 +495,6 @@ static void device_free_tx_bufs(struct vnt_private *priv)
 
 		kfree(tx_context);
 	}
-
-	return;
 }
 
 static void device_free_rx_bufs(struct vnt_private *priv)
@@ -520,24 +519,20 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 
 		kfree(rcb);
 	}
-
-	return;
 }
 
 static void usb_device_reset(struct vnt_private *pDevice)
 {
- int status;
- status = usb_reset_device(pDevice->usb);
+	int status;
+
+	status = usb_reset_device(pDevice->usb);
 	if (status)
-            printk("usb_device_reset fail status=%d\n",status);
-	return ;
+		pr_warn("usb_device_reset fail status=%d\n", status);
 }
 
 static void device_free_int_bufs(struct vnt_private *priv)
 {
 	kfree(priv->int_buf.data_buf);
-
-	return;
 }
 
 static bool device_alloc_bufs(struct vnt_private *priv)
@@ -718,8 +713,6 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	usb_kill_urb(priv->pInterruptURB);
 	usb_free_urb(priv->pInterruptURB);
-
-	return;
 }
 
 static int vnt_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
@@ -785,8 +778,6 @@ static void vnt_remove_interface(struct ieee80211_hw *hw,
 
 	/* LED slow blink */
 	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_SLOW);
-
-	return;
 }
 
 static int vnt_config(struct ieee80211_hw *hw, u32 changed)
@@ -836,6 +827,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		u32 changed)
 {
 	struct vnt_private *priv = hw->priv;
+
 	priv->current_aid = conf->aid;
 
 	if (changed & BSS_CHANGED_BSSID)
@@ -965,8 +957,6 @@ static void vnt_configure(struct ieee80211_hw *hw,
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG, MAC_REG_RCR, rx_mode);
 
 	dev_dbg(&priv->usb->dev, "rx mode out= %x\n", rx_mode);
-
-	return;
 }
 
 static int vnt_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-- 
1.9.3

