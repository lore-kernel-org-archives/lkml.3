Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaGNTQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:16:08 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38237 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaGNTQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:16:01 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V4 1/6] staging: vt6556: Cleanup trivial coding style issues
Date: Mon, 14 Jul 2014 21:15:28 +0200
Message-Id: <1405365333-17170-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the following checkpatch issues:
 - tabs instead of spaces on the beginning of a line
 - use correct /* */ comment style
 - put { and } on the correct places
 - line over 80 chars
 - indentation style for multi-line calls / comments
 - space after semicolon ,
 - new line after declaration

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Cahnges from V3:
 - Splitted the patches by change type

 drivers/staging/vt6656/baseband.c | 23 ++++++++-------
 drivers/staging/vt6656/card.c     | 13 +++++----
 drivers/staging/vt6656/card.h     |  6 ++--
 drivers/staging/vt6656/channel.c  |  5 ++--
 drivers/staging/vt6656/device.h   | 10 +++----
 drivers/staging/vt6656/main_usb.c | 59 ++++++++++++++++++++-------------------
 6 files changed, 61 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index c1675d5..8678b41 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -26,9 +26,10 @@
  * Date: Jun. 5, 2002
  *
  * Functions:
- *      vnt_get_frame_time        - Calculate data frame transmitting time
- *      vnt_get_phy_field   - Calculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
- *      BBbVT3184Init          - VIA VT3184 baseband chip init code
+ *	vnt_get_frame_time	- Calculate data frame transmitting time
+ *	vnt_get_phy_field	- Calculate PhyLength, PhyService and Phy
+ *				  Signal parameter for baseband Tx
+ *	BBbVT3184Init		- VIA VT3184 baseband chip init code
  *
  * Revision History:
  *
@@ -86,7 +87,7 @@ static u8 vnt_vt3184_al2230[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  /* 0xff */
 };
 
-//{{RobertYu:20060515, new BB setting for VT3226D0
+/* {{RobertYu:20060515, new BB setting for VT3226D0 */
 static u8 vnt_vt3184_vt3226d0[] = {
 	0x31, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00,
 	0x70, 0x45, 0x2a, 0x76, 0x00, 0x00, 0x80, 0x00, /* 0x0f */
@@ -122,8 +123,9 @@ static u8 vnt_vt3184_vt3226d0[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  /* 0xff */
 };
 
-static const u16 awcFrameTime[MAX_RATE] =
-{10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216};
+static const u16 awcFrameTime[MAX_RATE] = {
+	10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216
+};
 
 /*
  * Description: Calculate data frame transmitting time
@@ -191,9 +193,9 @@ unsigned int vnt_get_frame_time(u8 preamble_type, u8 pkt_type,
  *      tx_rate           - Tx Rate
  *  Out:
  *	struct vnt_phy_field *phy
- * 			- pointer to Phy Length field
- *			- pointer to Phy Service field
- * 			- pointer to Phy Signal field
+ *		- pointer to Phy Length field
+ *		- pointer to Phy Service field
+ *		- pointer to Phy Signal field
  *
  * Return Value: none
  *
@@ -467,7 +469,8 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 		/* Fix VT3226 DFC system timing issue */
-		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
+		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
+				    SOFTPWRCTL_RFLEOPT);
 	} else {
 		return true;
 	}
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index ea06b63..37cd96b 100644
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
@@ -710,7 +711,7 @@ void vnt_update_next_tbtt(struct vnt_private *priv, u64 tsf,
 	data[7] = (u8)(tsf >> 56);
 
 	vnt_control_out(priv, MESSAGE_TYPE_SET_TSFTBTT,
-		MESSAGE_REQUEST_TBTT, 0, 8, data);
+			MESSAGE_REQUEST_TBTT, 0, 8, data);
 
 	dev_dbg(&priv->usb->dev, "%s TBTT: %8llx\n", __func__, tsf);
 
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 5b7cc5a..80fcd53 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -39,9 +39,9 @@ typedef enum _CARD_PHY_TYPE {
     PHY_TYPE_11A
 } CARD_PHY_TYPE, *PCARD_PHY_TYPE;
 
-#define CB_MAX_CHANNEL_24G  14
-#define CB_MAX_CHANNEL_5G       42 /* add channel9(5045MHz), 41==>42 */
-#define CB_MAX_CHANNEL      (CB_MAX_CHANNEL_24G+CB_MAX_CHANNEL_5G)
+#define CB_MAX_CHANNEL_24G	14
+#define CB_MAX_CHANNEL_5G	42 /* add channel9(5045MHz), 41==>42 */
+#define CB_MAX_CHANNEL		(CB_MAX_CHANNEL_24G + CB_MAX_CHANNEL_5G)
 
 struct vnt_private;
 
diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index fb1838e..4a53f1a 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -28,8 +28,9 @@
  *
  *
  * Revision History:
- *      01-18-2005      RobertYu:  remove the for loop searching in ChannelValid,
- *                                 change ChannelRuleTab to lookup-type, reorder table items.
+ *	01-18-2005	RobertYu:	remove the for loop searching in
+ *					ChannelValid, change ChannelRuleTab
+ *					to lookup-type, reorder table items.
  *
  *
  */
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 789c55d..50a6749 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -443,11 +443,11 @@ struct vnt_private {
 	struct ieee80211_low_level_stats low_stats;
 };
 
-#define ADD_ONE_WITH_WRAP_AROUND(uVar, uModulo) {   \
-    if ((uVar) >= ((uModulo) - 1))                  \
-        (uVar) = 0;                                 \
-    else                                            \
-        (uVar)++;                                   \
+#define ADD_ONE_WITH_WRAP_AROUND(uVar, uModulo) {	\
+	if ((uVar) >= ((uModulo) - 1))			\
+		(uVar) = 0;				\
+	else						\
+		(uVar)++;				\
 }
 
 #define fMP_DISCONNECTED                    0x00000002
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4cdf29e..8e05f04 100644
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
+#define DEVICE_PARAM(N, D)				\
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
@@ -526,8 +525,9 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 
 static void usb_device_reset(struct vnt_private *pDevice)
 {
- int status;
- status = usb_reset_device(pDevice->usb);
+	int status;
+
+	status = usb_reset_device(pDevice->usb);
 	if (status)
             printk("usb_device_reset fail status=%d\n",status);
 	return ;
@@ -836,6 +836,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		u32 changed)
 {
 	struct vnt_private *priv = hw->priv;
+
 	priv->current_aid = conf->aid;
 
 	if (changed & BSS_CHANGED_BSSID)
-- 
1.9.3

