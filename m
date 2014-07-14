Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaGNI76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:59:58 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:46621 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaGNI7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:59:49 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
X-Google-Original-From: Peter Senna Tschudin <peter@hp-peter.rsr.lip6.fr>
Date: Mon, 14 Jul 2014 10:59:32 +0200
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>, forest@alittletooquiet.net,
        tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V2 1/4] staging: vt6556: Cleanup coding style issues
Message-ID: <20140714085932.GA2958@hp-peter.rsr.lip6.fr>
References: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
 <20140713193647.GA31010@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20140713193647.GA31010@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 13, 2014 at 12:36:47PM -0700, Greg KH wrote:
> On Sun, Jul 13, 2014 at 09:11:18PM +0200, Peter Senna Tschudin wrote:
> > This patch cleanup coding style issues reported by checkpatch.
> > 
> > Tested by compilation only.
> > 
> > Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> > ---
> > Cahnges from V1:
> >  - Sent all patches in a series
> 
> Why did you forget the other thing that I asked you to change?
> 
> I can't take these as-is, sorry, please go back and re-read what I
> wrote...

Actually I was trying to do what you asked me on this E-mail:

-- // --
You just sent me 4 patches, all with the same subject (but at least 2 of
them had the order in which to apply them in, which is nice.)

Please redo these such that they have a unique subject, and I can tell
which order to apply them in, as I really have no idea about the second
two.
-- // --

I'm sending V3 as a single patch.


> 
> greg k-h

--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-staging-vt6556-Cleanup-coding-style-issues.patch"

>From 69cd87aca39730c0578592d1296b738f7f223f29 Mon Sep 17 00:00:00 2001
From: Peter Senna Tschudin <peter.senna@gmail.com>
Date: Mon, 14 Jul 2014 10:28:42 +0200
Subject: [PATCH V3] staging: vt6556: Cleanup coding style issues

This patch cleanup coding style issues reported by checkpatch.

This typedef, reported by checkpatch, was removed from card.h:
typedef enum _CARD_PHY_TYPE {
    PHY_TYPE_AUTO = 0,
    PHY_TYPE_11B,
    PHY_TYPE_11G,
    PHY_TYPE_11A
} CARD_PHY_TYPE, *PCARD_PHY_TYPE;

The following typedefs were removed, but enums were kept at device.h:
 - typedef enum __device_msg_level
 - typedef enum __DEVICE_NDIS_STATUS

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V2:
 - Single patch instead of a series

Made against staging-next.

 drivers/staging/vt6656/baseband.c |  28 +++++----
 drivers/staging/vt6656/card.c     |  19 +++---
 drivers/staging/vt6656/card.h     |  13 +----
 drivers/staging/vt6656/channel.c  |   5 +-
 drivers/staging/vt6656/device.h   |  27 +++++----
 drivers/staging/vt6656/main_usb.c | 118 +++++++++++++++++---------------------
 6 files changed, 97 insertions(+), 113 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index c1675d5..040b232 100644
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
@@ -450,8 +452,9 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 		/* Fix VT3226 DFC system timing issue */
-		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
-	} else if ((priv->byRFType == RF_VT3342A0)) {
+		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
+				    SOFTPWRCTL_RFLEOPT);
+	} else if (priv->byRFType == RF_VT3342A0) {
 		priv->byBBRxConf = vnt_vt3184_vt3226d0[10];
 		length = sizeof(vnt_vt3184_vt3226d0);
 		addr = vnt_vt3184_vt3226d0;
@@ -467,7 +470,8 @@ int BBbVT3184Init(struct vnt_private *priv)
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
index 789c55d..e3acf2f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -187,13 +187,13 @@
 
 #define DBG_PRT(l, p, args...) { if (l <= msglevel) printk(p, ##args); }
 
-typedef enum __device_msg_level {
+enum {
 	MSG_LEVEL_ERR = 0,            /* Errors causing abnormal operation */
 	MSG_LEVEL_NOTICE = 1,         /* Errors needing user notification */
 	MSG_LEVEL_INFO = 2,           /* Normal message. */
 	MSG_LEVEL_VERBOSE = 3,        /* Will report all trival errors. */
 	MSG_LEVEL_DEBUG = 4           /* Only for debug purpose. */
-} DEVICE_MSG_LEVEL, *PDEVICE_MSG_LEVEL;
+};
 
 #define DEVICE_INIT_COLD	0x0 /* cold init */
 #define DEVICE_INIT_RESET	0x1 /* reset init or Dx to D0 power remain */
@@ -268,13 +268,12 @@ struct vnt_interrupt_buffer {
 
 /*++ NDIS related */
 
-typedef enum __DEVICE_NDIS_STATUS {
-    STATUS_SUCCESS = 0,
-    STATUS_FAILURE,
-    STATUS_RESOURCES,
-    STATUS_PENDING,
-} DEVICE_NDIS_STATUS, *PDEVICE_NDIS_STATUS;
-
+enum {
+	STATUS_SUCCESS = 0,
+	STATUS_FAILURE,
+	STATUS_RESOURCES,
+	STATUS_PENDING,
+};
 
 /* flags for options */
 #define     DEVICE_FLAGS_UNPLUG          0x00000001UL
@@ -443,11 +442,11 @@ struct vnt_private {
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


--dDRMvlgZJXvWKvBx--
