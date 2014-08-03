Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaHCT3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 15:29:54 -0400
Received: from mx02.posteo.de ([89.146.194.165]:33838 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751622AbaHCT3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 15:29:51 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: rtl8192u: checkpatch: do not use C99 // comments
Date: Sun,  3 Aug 2014 21:28:20 +0200
Message-Id: <1407094100-20107-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common kernel coding style, so don't use C99 // comments.
If too long, where reasonable, they are shortened as well.

Some old internal comments about date and author of changes are
removed.

This provides a more consistent view and hopefully encourages to
look at it.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
This changes only a part of rtl8192u's comments. When this is desired,
one can go about and change the rest of the driver.

build-tested. applies to -next20140801

 drivers/staging/rtl8192u/r8180_93cx6.c |   12 +-
 drivers/staging/rtl8192u/r8192U_core.c |  757 +++++++++++++++++---------------
 2 files changed, 414 insertions(+), 355 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index fb8a7a8..9f3f9dd 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -103,7 +103,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	u32 ret;
 
 	ret = 0;
-	//enable EPROM programming
+	/* enable EPROM programming */
 	write_nic_byte_E(dev, EPROM_CMD,
 		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	force_pci_posting(dev);
@@ -133,13 +133,13 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_send_bits_string(dev, read_cmd, 3);
 	eprom_send_bits_string(dev, addr_str, addr_len);
 
-	//keep chip pin D to low state while reading.
-	//I'm unsure if it is necessary, but anyway shouldn't hurt
+	/* keep chip pin D to low state while reading.
+	 * I'm unsure if it is necessary, but anyway shouldn't hurt */
 	eprom_w(dev, 0);
 
 	for (i = 0; i < 16; i++) {
-		//eeprom needs a clk cycle between writing opcode&adr
-		//and reading data. (eeprom outs a dummy 0)
+		/* eeprom needs a clk cycle between writing opcode&adr
+		 * and reading data. (eeprom outs a dummy 0) */
 		eprom_ck_cycle(dev);
 		ret |= (eprom_r(dev)<<(15-i));
 	}
@@ -147,7 +147,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_cs(dev, 0);
 	eprom_ck_cycle(dev);
 
-	//disable EPROM programming
+	/* disable EPROM programming */
 	write_nic_byte_E(dev, EPROM_CMD,
 		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	return ret;
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7640386..f97019d 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -87,7 +87,7 @@ double __extendsfdf2(float a)
 #include "r8190_rtl8256.h" /* RTL8225 Radio frontend */
 #include "r8180_93cx6.h"   /* Card EEPROM */
 #include "r8192U_wx.h"
-#include "r819xU_phy.h" //added by WB 4.30.2008
+#include "r819xU_phy.h"
 #include "r819xU_phyreg.h"
 #include "r819xU_cmdpkt.h"
 #include "r8192U_dm.h"
@@ -95,13 +95,13 @@ double __extendsfdf2(float a)
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-// FIXME: check if 2.6.7 is ok
+/* FIXME: check if 2.6.7 is ok */
 
 #include "dot11d.h"
-//set here to open your trace code. //WB
+/* set here to open your trace code. */
 u32 rt_global_debug_component = COMP_DOWN	|
 				COMP_SEC	|
-				COMP_ERR; //always open err flags on
+				COMP_ERR; /* always open err flags on */
 
 #define TOTAL_CAM_ENTRY 32
 #define CAM_CONTENT_COUNT 8
@@ -132,7 +132,7 @@ MODULE_DEVICE_TABLE(usb, rtl8192_usb_id_tbl);
 MODULE_DESCRIPTION("Linux driver for Realtek RTL8192 USB WiFi cards");
 
 static char *ifname = "wlan%d";
-static int hwwep = 1;  //default use hw. set 0 to use software security
+static int hwwep = 1;  /* default use hw. set 0 to use software security */
 static int channels = 0x3fff;
 
 
@@ -166,17 +166,17 @@ typedef struct _CHANNEL_LIST {
 } CHANNEL_LIST, *PCHANNEL_LIST;
 
 static CHANNEL_LIST ChannelPlan[] = {
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165}, 24},		//FCC
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},							//IC
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	//ETSI
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},    //Spain. Change to ETSI.
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},	//France. Change to ETSI.
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},	//MKK					//MKK
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},//MKK1
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},	//Israel.
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},			// For 11a , TELEC
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},    //MIC
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14}					//For Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165}, 24},	/* FCC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},						/* IC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/* ETSI */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},	/* Spain. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},	/* France. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},	/* MKK */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},	/* MKK1 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},	/* Israel. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},	/* For 11a , TELEC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},	/* MIC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14}	/* For Global Domain. 1-11:active scan, 12-14 passive scan.*/
 };
 
 static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
@@ -196,7 +196,7 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 	case COUNTRY_CODE_MIC:
 		Dot11d_Init(ieee);
 		ieee->bGlobalDomain = false;
-		//actually 8225 & 8256 rf chips only support B,G,24N mode
+		/* actually 8225 & 8256 rf chips only support B,G,24N mode */
 		if ((priv->rf_chip == RF_8225) || (priv->rf_chip == RF_8256)) {
 			min_chan = 1;
 			max_chan = 14;
@@ -204,9 +204,9 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 			RT_TRACE(COMP_ERR, "unknown rf chip, can't set channel map in function:%s()\n", __func__);
 		}
 		if (ChannelPlan[channel_plan].Len != 0) {
-			// Clear old channel map
+			/* Clear old channel map */
 			memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(GET_DOT11D_INFO(ieee)->channel_map));
-			// Set new channel map
+			/* Set new channel map */
 			for (i = 0; i < ChannelPlan[channel_plan].Len; i++) {
 				if (ChannelPlan[channel_plan].Channel[i] < min_chan || ChannelPlan[channel_plan].Channel[i] > max_chan)
 					break;
@@ -216,7 +216,9 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 		break;
 
 	case COUNTRY_CODE_GLOBAL_DOMAIN:
-		GET_DOT11D_INFO(ieee)->bEnabled = 0;//this flag enabled to follow 11d country IE setting, otherwise, it shall follow global domain settings.
+		/* this flag enabled to follow 11d country IE setting,
+		 * otherwise, it shall follow global domain settings. */
+		GET_DOT11D_INFO(ieee)->bEnabled = 0;//
 		Dot11d_Reset(ieee);
 		ieee->bGlobalDomain = true;
 		break;
@@ -232,12 +234,14 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 static void CamResetAllEntry(struct net_device *dev)
 {
 	u32 ulcommand = 0;
-	//2004/02/11  In static WEP, OID_ADD_KEY or OID_ADD_WEP are set before STA associate to AP.
-	// However, ResetKey is called on OID_802_11_INFRASTRUCTURE_MODE and MlmeAssociateRequest
-	// In this condition, Cam can not be reset because upper layer will not set this static key again.
+	/* In static WEP, OID_ADD_KEY or OID_ADD_WEP are set before STA
+	 * associate to AP. However, ResetKey is called on
+	 * OID_802_11_INFRASTRUCTURE_MODE and MlmeAssociateRequest
+	 * In this condition, Cam can not be reset because upper layer
+	 * will not set this static key again.
+	 */
 	ulcommand |= BIT31|BIT30;
 	write_nic_dword(dev, RWCAM, ulcommand);
-
 }
 
 
@@ -287,7 +291,7 @@ int read_nic_byte_E(struct net_device *dev, int indx, u8 *data)
 
 	return 0;
 }
-//as 92U has extend page from 4 to 16, so modify functions below.
+/* as 92U has extend page from 4 to 16, so modify functions below. */
 void write_nic_byte(struct net_device *dev, int indx, u8 data)
 {
 	int status;
@@ -712,7 +716,7 @@ void rtl8192_set_chan(struct net_device *dev, short ch)
 	/* this hack should avoid frame TX during channel setting*/
 
 #ifndef LOOP_TEST
-	//need to implement rf set channel here WB
+	/* need to implement rf set channel here WB */
 
 	if (priv->rf_set_chan)
 		priv->rf_set_chan(dev, priv->chan);
@@ -758,7 +762,7 @@ static int rtl8192_rx_initiate(struct net_device *dev)
 		info = (struct rtl8192_rx_info *) skb->cb;
 		info->urb = entry;
 		info->dev = dev;
-		info->out_pipe = 3; //denote rx normal packet queue
+		info->out_pipe = 3; /* denote rx normal packet queue */
 		skb_queue_tail(&priv->rx_queue, skb);
 		usb_submit_urb(entry, GFP_KERNEL);
 	}
@@ -779,7 +783,7 @@ static int rtl8192_rx_initiate(struct net_device *dev)
 		info = (struct rtl8192_rx_info *) skb->cb;
 		info->urb = entry;
 		info->dev = dev;
-		info->out_pipe = 9; //denote rx cmd packet queue
+		info->out_pipe = 9; /* denote rx cmd packet queue */
 		skb_queue_tail(&priv->rx_queue, skb);
 		usb_submit_urb(entry, GFP_KERNEL);
 	}
@@ -829,7 +833,7 @@ void rtl8192_set_rxconf(struct net_device *dev)
 
 	write_nic_dword(dev, RCR, rxconf);
 }
-//wait to be removed
+/* wait to be removed */
 void rtl8192_rx_enable(struct net_device *dev)
 {
 	rtl8192_rx_initiate(dev);
@@ -975,13 +979,13 @@ static u32 rtl819xusb_rx_command_packet(struct net_device *dev,
 
 static void rtl8192_data_hard_stop(struct net_device *dev)
 {
-	//FIXME !!
+	/* FIXME !! */
 }
 
 
 static void rtl8192_data_hard_resume(struct net_device *dev)
 {
-	// FIXME !!
+	/* FIXME !! */
 }
 
 /* this function TX data frames when the ieee80211 stack requires this.
@@ -1068,9 +1072,9 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 	tx_desc_819x_usb_aggr_subframe *tx_agg_desc = NULL;
 	tx_fwinfo_819x_usb	       *tx_fwinfo = NULL;
 
-	//
-	// Local variable initialization.
-	//
+	/*
+	 * Local variable initialization.
+	 */
 	/* first skb initialization */
 	skb = pSendList->tx_agg_frames[0];
 	TotalLength = skb->len;
@@ -1089,7 +1093,8 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 	memset(agg_skb->data, 0, agg_skb->len);
 	skb_reserve(agg_skb, ieee->tx_headroom);
 
-	/* reserve info for first subframe Tx descriptor to be set in the tx function */
+	/* reserve info for first subframe Tx descriptor to be set
+	 * in the tx function */
 	skb = pSendList->tx_agg_frames[0];
 	tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	tcb_desc->drv_agg_enable = 1;
@@ -1119,7 +1124,8 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 			tx_fwinfo->AllowAggregation = 1;
 			/* DWORD 1 */
 			tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
-			tx_fwinfo->RxAMD = tcb_desc->ampdu_density&0x07;//ampdudensity
+			/* ampdudensity */
+			tx_fwinfo->RxAMD = tcb_desc->ampdu_density&0x07;
 		} else {
 			tx_fwinfo->AllowAggregation = 0;
 			/* DWORD 1 */
@@ -1142,7 +1148,8 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		if (priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20_40) {
 			if (tcb_desc->bPacketBW) {
 				tx_fwinfo->TxBandwidth = 1;
-				tx_fwinfo->TxSubCarrier = 0;    //By SD3's Jerry suggestion, use duplicated mode
+				/* use duplicated mode */
+				tx_fwinfo->TxSubCarrier = 0;
 			} else {
 				tx_fwinfo->TxBandwidth = 0;
 				tx_fwinfo->TxSubCarrier = priv->nCur40MhzPrimeSC;
@@ -1195,7 +1202,7 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 
 		tx_agg_desc->OWN = 1;
 
-		//DWORD 2
+		/*DWORD 2*/
 		/* According windows driver, it seems that there no need to fill this field */
 
 		/* to fill next packet */
@@ -1263,16 +1270,16 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 		atomic_dec(&priv->tx_pending[queue_index]);
 	}
 
-	//
-	// Handle HW Beacon:
-	// We had transfer our beacon frame to host controller at this moment.
-	//
-	//
-	// Caution:
-	// Handling the wait queue of command packets.
-	// For Tx command packets, we must not do TCB fragment because it is not handled right now.
-	// We must cut the packets to match the size of TX_CMD_PKT before we send it.
-	//
+	/*
+	 * Handle HW Beacon:
+	 * We had transfer our beacon frame to host controller at this moment.
+	 *
+	 * Caution:
+	 * Handling the wait queue of command packets.
+	 * For Tx command packets, we must not do TCB fragment because it is
+	 * not handled right now. We must cut the packets to match the size of
+	 * TX_CMD_PKT before we send it.
+	 */
 
 	/* Handle MPDU in wait queue. */
 	if (queue_index != BEACON_QUEUE) {
@@ -1283,12 +1290,12 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 			if (skb)
 				priv->ieee80211->softmac_hard_start_xmit(skb, dev);
 
-			return; //modified by david to avoid further processing AMSDU
+			return; /* modified to avoid further processing AMSDU */
 		}
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
 		else if ((skb_queue_len(&priv->ieee80211->skb_drv_aggQ[queue_index]) != 0) &&
 			 (!(priv->ieee80211->queue_stop))) {
-			// Tx Driver Aggregation process
+			/* Tx Driver Aggregation process */
 			/* The driver will aggregation the packets according to the following stats
 			 * 1. check whether there's tx irq available, for it's a completion return
 			 *    function, it should contain enough tx irq;
@@ -1430,7 +1437,7 @@ static void rtl8192_update_cap(struct net_device *dev, u16 cap)
 		u8 slot_time = 0;
 		if ((cap & WLAN_CAPABILITY_SHORT_SLOT) && (!priv->ieee80211->pHTInfo->bCurrentRT2RTLongSlotTime)) /* short slot time */
 			slot_time = SHORT_SLOT_TIME;
-		else //long slot time
+		else /* long slot time */
 			slot_time = NON_SHORT_SLOT_TIME;
 		priv->slot_time = slot_time;
 		write_nic_byte(dev, SLOT_TIME, slot_time);
@@ -1460,7 +1467,7 @@ static void rtl8192_net_update(struct net_device *dev)
 		write_nic_word(dev, BCN_DRV_EARLY_INT, 1);
 		write_nic_byte(dev, BCN_ERR_THRESH, 100);
 		BcnTimeCfg |= (BcnCW<<BCN_TCFG_CW_SHIFT);
-		// TODO: BcnIFS may required to be changed on ASIC
+		/* TODO: BcnIFS may required to be changed on ASIC */
 		BcnTimeCfg |= BcnIFS<<BCN_TCFG_IFS;
 
 		write_nic_word(dev, BCN_TCFG, BcnTimeCfg);
@@ -1470,8 +1477,7 @@ static void rtl8192_net_update(struct net_device *dev)
 
 }
 
-//temporary hw beacon is not used any more.
-//open it when necessary
+/* temporary hw beacon is not used any more. open it when necessary */
 void rtl819xusb_beacon_tx(struct net_device *dev, u16  tx_rate)
 {
 
@@ -1496,11 +1502,11 @@ u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
 	if (rtl8192_IsWirelessBMode(DataRate)) {
 		if (bManagementFrame || !bShortPreamble || DataRate == 10) /* long preamble */
 			FrameTime = (u16)(144+48+(FrameLength*8/(DataRate/10)));
-		else // Short preamble
+		else /* Short preamble */
 			FrameTime = (u16)(72+24+(FrameLength*8/(DataRate/10)));
 		if ((FrameLength*8 % (DataRate/10)) != 0) /* Get the Ceilling */
 			FrameTime++;
-	} else {	//802.11g DSSS-OFDM PLCP length field calculation.
+	} else {	/* 802.11g DSSS-OFDM PLCP length field calculation. */
 		N_DBPS = N_DBPSOfRate(DataRate);
 		Ceiling = (16 + 8*FrameLength + 6) / N_DBPS
 			+ (((16 + 8*FrameLength + 6) % N_DBPS) ? 1 : 0);
@@ -1581,17 +1587,17 @@ short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 
 	memset(pdesc, 0, USB_HWDESC_HEADER_LEN);
 	/* Tx descriptor ought to be set according to the skb->cb */
-	pdesc->FirstSeg = 1;//bFirstSeg;
-	pdesc->LastSeg = 1;//bLastSeg;
+	pdesc->FirstSeg = 1; /* bFirstSeg; */
+	pdesc->LastSeg = 1; /* bLastSeg; */
 	pdesc->CmdInit = tcb_desc->bCmdOrInit;
 	pdesc->TxBufferSize = tcb_desc->txbuf_size;
 	pdesc->OWN = 1;
 	pdesc->LINIP = tcb_desc->bLastIniPkt;
 
-	//----------------------------------------------------------------------------
-	// Fill up USB_OUT_CONTEXT.
-	//----------------------------------------------------------------------------
-	// Get index to out pipe from specified QueueID.
+	/*----------------------------------------------------------------------
+	 * Fill up USB_OUT_CONTEXT.
+	 *--------------------------------------------------------------------*/
+	/* Get index to out pipe from specified QueueID. */
 #ifndef USE_ONE_PIPE
 	idx_pipe = txqueue2outpipe(priv, queue_index);
 #else
@@ -1619,7 +1625,7 @@ short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 */
 static u8 MapHwQueueToFirmwareQueue(u8 QueueID)
 {
-	u8 QueueSelect = 0x0;       //defualt set to
+	u8 QueueSelect = 0x0;	/*defualt set to*/
 
 	switch (QueueID) {
 	case BE_QUEUE:
@@ -1645,8 +1651,8 @@ static u8 MapHwQueueToFirmwareQueue(u8 QueueID)
 		QueueSelect = QSLT_BEACON;
 		break;
 
-		// TODO: 2006.10.30 mark other queue selection until we verify it is OK
-		// TODO: Remove Assertions
+		/* TODO: mark other queue selection until we verify it is OK */
+		/* TODO: Remove Assertions */
 	case TXCMD_QUEUE:
 		QueueSelect = QSLT_CMD;
 		break;
@@ -1703,7 +1709,7 @@ static u8 MRateToHwRate8190Pci(u8 rate)
 			ret = DESC90_RATE54M;
 			break;
 
-		// HT rate since here
+		/* HT rate since here */
 		case MGN_MCS0:
 			ret = DESC90_RATEMCS0;
 			break;
@@ -1824,7 +1830,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 		tx_fwinfo->AllowAggregation = 1;
 		/* DWORD 1 */
 		tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
-		tx_fwinfo->RxAMD = tcb_desc->ampdu_density&0x07;//ampdudensity
+		tx_fwinfo->RxAMD = tcb_desc->ampdu_density&0x07;/*ampdudensity*/
 	} else {
 		tx_fwinfo->AllowAggregation = 0;
 		/* DWORD 1 */
@@ -1847,7 +1853,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 	if (priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20_40) {
 		if (tcb_desc->bPacketBW) {
 			tx_fwinfo->TxBandwidth = 1;
-			tx_fwinfo->TxSubCarrier = 0;    //By SD3's Jerry suggestion, use duplicated mode
+			tx_fwinfo->TxSubCarrier = 0; /* use duplicated mode */
 		} else {
 			tx_fwinfo->TxBandwidth = 0;
 			tx_fwinfo->TxSubCarrier = priv->nCur40MhzPrimeSC;
@@ -1911,7 +1917,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 	tx_desc->USERATE = tcb_desc->bTxUseDriverAssingedRate;
 
 	/* Fill fields that are required to be initialized in all of the descriptors */
-	//DWORD 0
+	/*DWORD 0*/
 	tx_desc->FirstSeg = 1;
 	tx_desc->LastSeg = 1;
 	tx_desc->OWN = 1;
@@ -1922,7 +1928,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 	} else
 #endif
 	{
-		//DWORD 2
+		/*DWORD 2*/
 		tx_desc->TxBufferSize = (u32)(skb->len - USB_HWDESC_HEADER_LEN);
 	}
 	/* Get index to out pipe from specified QueueID */
@@ -1939,7 +1945,11 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 
 	status = usb_submit_urb(tx_urb, GFP_ATOMIC);
 	if (!status) {
-		//we need to send 0 byte packet whenever 512N bytes/64N(HIGN SPEED/NORMAL SPEED) bytes packet has been transmitted. Otherwise, it will be halt to wait for another packet. WB. 2008.08.27
+		/* we need to send 0 byte packet whenever
+		 * 512N bytes/64N(HIGN SPEED/NORMAL SPEED) bytes packet has
+		 * been transmitted. Otherwise, it will be halt to wait for
+		 * another packet.
+		 */
 		bool bSend0Byte = false;
 		u8 zero = 0;
 		if (udev->speed == USB_SPEED_HIGH) {
@@ -2093,7 +2103,10 @@ static void rtl8192_link_change(struct net_device *dev)
 	if (ieee->state == IEEE80211_LINKED) {
 		rtl8192_net_update(dev);
 		rtl8192_update_ratr_table(dev);
-		//add this as in pure N mode, wep encryption will use software way, but there is no chance to set this as wep will not set group key in wext. WB.2008.07.08
+		/* add this as in pure N mode, wep encryption will use software
+		 * way, but there is no chance to set this as wep will not set
+		 * group key in wext.
+		 */
 		if ((KEY_TYPE_WEP40 == ieee->pairwise_key_type) || (KEY_TYPE_WEP104 == ieee->pairwise_key_type))
 			EnableHWSecurityConfig8192(dev);
 	}
@@ -2152,7 +2165,7 @@ static void rtl8192_qos_activate(struct work_struct *work)
 	/* For we just support b/g mode at present, let the slot time at 9/20 selection */
 	/* update the ac parameter to related registers */
 	for (i = 0; i <  QOS_QUEUE_NUM; i++) {
-		//Mode G/A: slotTimeTimer = 9; Mode B: 20
+		/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
 		u1bAIFS = qos_parameters->aifs[i] * ((mode&(IEEE_G|IEEE_N_24G)) ? 9 : 20) + aSifsTime;
 		u4bAcParam = ((((u32)(qos_parameters->tx_op_limit[i]))<< AC_PARAM_TXOP_LIMIT_OFFSET)|
 			      (((u32)(qos_parameters->cw_max[i]))<< AC_PARAM_ECW_MAX_OFFSET)|
@@ -2339,7 +2352,9 @@ static bool GetNmodeSupportBySecCfg8192(struct net_device *dev)
 	int encrypt;
 
 	crypt = ieee->crypt[ieee->tx_keyidx];
-	//we use connecting AP's capability instead of only security config on our driver to distinguish whether it should use N mode or G mode
+	/* we use connecting AP's capability instead of only security config on
+	 * our driver to distinguish whether it should use N mode or G mode
+	 */
 	encrypt = (network->capability & WLAN_CAPABILITY_PRIVACY) || (ieee->host_encrypt && crypt && crypt->ops && (0 == strcmp(crypt->ops->name, "WEP")));
 
 	/* simply judge  */
@@ -2376,7 +2391,8 @@ static bool GetHalfNmodeSupportByAPs819xUsb(struct net_device *dev)
 static void rtl8192_refresh_supportrate(struct r8192_priv *priv)
 {
 	struct ieee80211_device *ieee = priv->ieee80211;
-	//we do not consider set support rate for ABG mode, only HT MCS rate is set here.
+	/* we do not consider set support rate for ABG mode, only HT MCS rate
+	 * is set here. */
 	if (ieee->mode == WIRELESS_MODE_N_24G || ieee->mode == WIRELESS_MODE_N_5G)
 		memcpy(ieee->Regdot11HTOperationalRateSet, ieee->RegHTSuppRateSet, 16);
 	else
@@ -2424,7 +2440,9 @@ static void rtl8192_SetWirelessMode(struct net_device *dev, u8 wireless_mode)
 			wireless_mode = WIRELESS_MODE_B;
 		}
 	}
-#ifdef TO_DO_LIST //// TODO: this function doesn't work well at this time, we should wait for FPGA
+#ifdef TO_DO_LIST
+	/* TODO: this function doesn't work well at this time,
+	 * we should wait for FPGA */
 	ActUpdateChannelAccessSetting(pAdapter, pHalData->CurrentWirelessMode, &pAdapter->MgntInfo.Info8185.ChannelAccessSetting);
 #endif
 	priv->ieee80211->mode = wireless_mode;
@@ -2437,43 +2455,43 @@ static void rtl8192_SetWirelessMode(struct net_device *dev, u8 wireless_mode)
 	rtl8192_refresh_supportrate(priv);
 
 }
-//init priv variables here. only non_zero value should be initialized here.
+/* init priv variables here. only non_zero value should be initialized here. */
 static void rtl8192_init_priv_variable(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8 i;
 	priv->card_8192 = NIC_8192U;
-	priv->chan = 1; //set to channel 1
-	priv->ieee80211->mode = WIRELESS_MODE_AUTO; //SET AUTO
+	priv->chan = 1; /*set to channel 1*/
+	priv->ieee80211->mode = WIRELESS_MODE_AUTO; /*SET AUTO*/
 	priv->ieee80211->iw_mode = IW_MODE_INFRA;
 	priv->ieee80211->ieee_up = 0;
 	priv->retry_rts = DEFAULT_RETRY_RTS;
 	priv->retry_data = DEFAULT_RETRY_DATA;
 	priv->ieee80211->rts = DEFAULT_RTS_THRESHOLD;
-	priv->ieee80211->rate = 110; //11 mbps
+	priv->ieee80211->rate = 110; /*11 mbps*/
 	priv->ieee80211->short_slot = 1;
 	priv->promisc = (dev->flags & IFF_PROMISC) ? 1 : 0;
 	priv->CckPwEnl = 6;
-	//for silent reset
+	/*for silent reset*/
 	priv->IrpPendingCount = 1;
 	priv->ResetProgress = RESET_TYPE_NORESET;
 	priv->bForcedSilentReset = 0;
 	priv->bDisableNormalResetCheck = false;
 	priv->force_reset = false;
-
-	priv->ieee80211->FwRWRF = 0;	//we don't use FW read/write RF until stable firmware is available.
+	/*we don't use FW read/write RF until stable firmware is available.*/
+	priv->ieee80211->FwRWRF = 0;
 	priv->ieee80211->current_network.beacon_interval = DEFAULT_BEACONINTERVAL;
 	priv->ieee80211->softmac_features  = IEEE_SOFTMAC_SCAN |
 		IEEE_SOFTMAC_ASSOCIATE | IEEE_SOFTMAC_PROBERQ |
 		IEEE_SOFTMAC_PROBERS | IEEE_SOFTMAC_TX_QUEUE |
-		IEEE_SOFTMAC_BEACONS;//added by amy 080604
+		IEEE_SOFTMAC_BEACONS;
 
 	priv->ieee80211->active_scan = 1;
 	priv->ieee80211->modulation = IEEE80211_CCK_MODULATION | IEEE80211_OFDM_MODULATION;
 	priv->ieee80211->host_encrypt = 1;
 	priv->ieee80211->host_decrypt = 1;
-	priv->ieee80211->start_send_beacons = NULL; //-by amy 080604
-	priv->ieee80211->stop_send_beacons = NULL;  //-by amy 080604
+	priv->ieee80211->start_send_beacons = NULL;
+	priv->ieee80211->stop_send_beacons = NULL;
 	priv->ieee80211->softmac_hard_start_xmit = rtl8192_hard_start_xmit;
 	priv->ieee80211->set_chan = rtl8192_set_chan;
 	priv->ieee80211->link_change = rtl8192_link_change;
@@ -2486,15 +2504,12 @@ static void rtl8192_init_priv_variable(struct net_device *dev)
 	priv->ieee80211->tx_headroom = TX_PACKET_SHIFT_BYTES;
 	priv->ieee80211->qos_support = 1;
 
-	//added by WB
 	priv->ieee80211->SetBWModeHandler = rtl8192_SetBWMode;
 	priv->ieee80211->handle_assoc_response = rtl8192_handle_assoc_response;
 	priv->ieee80211->handle_beacon = rtl8192_handle_beacon;
-	//added by david
 	priv->ieee80211->GetNmodeSupportBySecCfg = GetNmodeSupportBySecCfg8192;
 	priv->ieee80211->GetHalfNmodeSupportByAPsHandler = GetHalfNmodeSupportByAPs819xUsb;
 	priv->ieee80211->SetWirelessMode = rtl8192_SetWirelessMode;
-	//added by amy
 	priv->ieee80211->InitialGainHandler = InitialGain819xUsb;
 	priv->card_type = USB;
 #ifdef TO_DO_LIST
@@ -2508,30 +2523,48 @@ static void rtl8192_init_priv_variable(struct net_device *dev)
 	priv->EarlyRxThreshold = 7;
 	priv->enable_gpio0 = 0;
 	priv->TransmitConfig =
-		(TCR_MXDMA_2048<<TCR_MXDMA_OFFSET)|  // Max DMA Burst Size per Tx DMA Burst, 7: reserved.
-		(priv->ShortRetryLimit<<TCR_SRL_OFFSET)|	// Short retry limit
-		(priv->LongRetryLimit<<TCR_LRL_OFFSET) |	// Long retry limit
-		(false ? TCR_SAT : 0);	// FALSE: HW provides PLCP length and LENGEXT, TRUE: SW provides them
+		/* Max DMA Burst Size per Tx DMA Burst, 7: reserved.*/
+		(TCR_MXDMA_2048<<TCR_MXDMA_OFFSET)|
+		/* Short retry limit */
+		(priv->ShortRetryLimit<<TCR_SRL_OFFSET)|
+		/* Long retry limit */
+		(priv->LongRetryLimit<<TCR_LRL_OFFSET) |
+		/* FALSE: HW provides PLCP length and LENGEXT,
+		 * TRUE: SW provides them */
+		(false ? TCR_SAT : 0);
 #ifdef TO_DO_LIST
 	if (Adapter->bInHctTest)
 		pHalData->ReceiveConfig	=	pHalData->CSMethod |
-						RCR_AMF | RCR_ADF |	//accept management/data
-						//guangan200710
-						RCR_ACF |	//accept control frame for SW AP needs PS-poll, 2005.07.07, by rcnjko.
-						RCR_AB | RCR_AM | RCR_APM |		//accept BC/MC/UC
-						RCR_AICV | RCR_ACRC32 |			//accept ICV/CRC error packet
-						((u32)7<<RCR_MXDMA_OFFSET) | // Max DMA Burst Size per Rx DMA Burst, 7: unlimited.
-						(pHalData->EarlyRxThreshold<<RCR_FIFO_OFFSET) | // Rx FIFO Threshold, 7: No Rx threshold.
+						/* accept management/data */
+						RCR_AMF | RCR_ADF |
+						/* accept control frame for
+						 * SW AP needs PS-poll */
+						RCR_ACF |
+						/* accept BC/MC/UC */
+						RCR_AB | RCR_AM | RCR_APM |
+						/* accept ICV/CRC error packet*/
+						RCR_AICV | RCR_ACRC32 |
+						/* Max DMA Burst Size per
+						 * Rx DMA Burst, 7: unlimited */
+						((u32)7<<RCR_MXDMA_OFFSET) |
+						/* Rx FIFO Threshold,
+						 * 7: No Rx threshold. */
+						(pHalData->EarlyRxThreshold<<RCR_FIFO_OFFSET) |
 						(pHalData->EarlyRxThreshold == 7 ? RCR_OnlyErlPkt : 0);
 	else
 
 #endif
 	priv->ReceiveConfig	=
-		RCR_AMF | RCR_ADF |		//accept management/data
-		RCR_ACF |			//accept control frame for SW AP needs PS-poll, 2005.07.07, by rcnjko.
-		RCR_AB | RCR_AM | RCR_APM |	//accept BC/MC/UC
-		((u32)7<<RCR_MXDMA_OFFSET)| // Max DMA Burst Size per Rx DMA Burst, 7: unlimited.
-		(priv->EarlyRxThreshold<<RX_FIFO_THRESHOLD_SHIFT) | // Rx FIFO Threshold, 7: No Rx threshold.
+		/* accept management/data */
+		RCR_AMF | RCR_ADF |
+		/* accept control frame for SW AP needs PS-poll */
+		RCR_ACF |
+		/* accept BC/MC/UC */
+		RCR_AB | RCR_AM | RCR_APM |
+		/* Max DMA Burst Size per Rx DMA Burst, 7: unlimited. */
+		((u32)7<<RCR_MXDMA_OFFSET)|
+		/* Rx FIFO Threshold, 7: No Rx threshold. */
+		(priv->EarlyRxThreshold<<RX_FIFO_THRESHOLD_SHIFT) |
 		(priv->EarlyRxThreshold == 7 ? RCR_ONLYERLPKT : 0);
 
 	priv->AcmControl = 0;
@@ -2551,11 +2584,11 @@ static void rtl8192_init_priv_variable(struct net_device *dev)
 	priv->rf_set_chan = rtl8192_phy_SwChnl;
 }
 
-//init lock here
+/* init lock here */
 static void rtl8192_init_priv_lock(struct r8192_priv *priv)
 {
 	spin_lock_init(&priv->tx_lock);
-	spin_lock_init(&priv->irq_lock);//added by thomas
+	spin_lock_init(&priv->irq_lock);
 	sema_init(&priv->wx_sem, 1);
 	sema_init(&priv->rf_sem, 1);
 	mutex_init(&priv->mutex);
@@ -2564,7 +2597,7 @@ static void rtl8192_init_priv_lock(struct r8192_priv *priv)
 extern  void    rtl819x_watchdog_wqcallback(struct work_struct *work);
 
 void rtl8192_irq_rx_tasklet(struct r8192_priv *priv);
-//init tasklet and wait_queue here. only 2.6 above kernel is considered
+/* init tasklet and wait_queue here. */
 #define DRV_NAME "wlan0"
 static void rtl8192_init_priv_task(struct net_device *dev)
 {
@@ -2593,12 +2626,11 @@ static void rtl8192_get_eeprom_size(struct net_device *dev)
 	RT_TRACE(COMP_EPROM, "===========>%s()\n", __func__);
 	read_nic_word_E(dev, EPROM_CMD, &curCR);
 	RT_TRACE(COMP_EPROM, "read from Reg EPROM_CMD(%x):%x\n", EPROM_CMD, curCR);
-	//whether need I consider BIT5?
+	/* whether need I consider BIT5? */
 	priv->epromtype = (curCR & Cmd9346CR_9356SEL) ? EPROM_93c56 : EPROM_93c46;
 	RT_TRACE(COMP_EPROM, "<===========%s(), epromtype:%d\n", __func__, priv->epromtype);
 }
 
-//used to swap endian. as ntohl & htonl are not necessary to swap endian, so use this instead.
 static inline u16 endian_swap(u16 *data)
 {
 	u16 tmp = *data;
@@ -2614,7 +2646,7 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 	u16 tmpValue = 0;
 	int i;
 	RT_TRACE(COMP_EPROM, "===========>%s()\n", __func__);
-	wEPROM_ID = eprom_read(dev, 0); //first read EEPROM ID out;
+	wEPROM_ID = eprom_read(dev, 0); /* first read EEPROM ID out; */
 	RT_TRACE(COMP_EPROM, "EEPROM ID is 0x%x\n", wEPROM_ID);
 
 	if (wEPROM_ID != RTL8190_EEPROM_ID) {
@@ -2639,7 +2671,7 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 		priv->eeprom_CustomerID = 0;
 	}
 	RT_TRACE(COMP_EPROM, "vid:0x%4x, pid:0x%4x, CustomID:0x%2x, ChanPlan:0x%x\n", priv->eeprom_vid, priv->eeprom_pid, priv->eeprom_CustomerID, priv->eeprom_ChannelPlan);
-	//set channelplan from eeprom
+	/* set channelplan from eeprom */
 	priv->ChannelPlan = priv->eeprom_ChannelPlan;
 	if (bLoad_From_EEPOM) {
 		int i;
@@ -2650,40 +2682,40 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 		}
 	} else {
 		memcpy(dev->dev_addr, bMac_Tmp_Addr, 6);
-		//should I set IDR0 here?
+		/* should I set IDR0 here? */
 	}
 	RT_TRACE(COMP_EPROM, "MAC addr:%pM\n", dev->dev_addr);
-	priv->rf_type = RTL819X_DEFAULT_RF_TYPE; //default 1T2R
+	priv->rf_type = RTL819X_DEFAULT_RF_TYPE; /* default 1T2R */
 	priv->rf_chip = RF_8256;
 
 	if (priv->card_8192_version == (u8)VERSION_819xU_A) {
-		//read Tx power gain offset of legacy OFDM to HT rate
+		/* read Tx power gain offset of legacy OFDM to HT rate */
 		if (bLoad_From_EEPOM)
 			priv->EEPROMTxPowerDiff = (eprom_read(dev, (EEPROM_TxPowerDiff>>1))&0xff00) >> 8;
 		else
 			priv->EEPROMTxPowerDiff = EEPROM_Default_TxPower;
 		RT_TRACE(COMP_EPROM, "TxPowerDiff:%d\n", priv->EEPROMTxPowerDiff);
-		//read ThermalMeter from EEPROM
+		/* read ThermalMeter from EEPROM */
 		if (bLoad_From_EEPOM)
 			priv->EEPROMThermalMeter = (u8)(eprom_read(dev, (EEPROM_ThermalMeter>>1))&0x00ff);
 		else
 			priv->EEPROMThermalMeter = EEPROM_Default_ThermalMeter;
 		RT_TRACE(COMP_EPROM, "ThermalMeter:%d\n", priv->EEPROMThermalMeter);
-		//vivi, for tx power track
+		/* for tx power track */
 		priv->TSSI_13dBm = priv->EEPROMThermalMeter *100;
-		//read antenna tx power offset of B/C/D to A from EEPROM
+		/* read antenna tx power offset of B/C/D to A from EEPROM */
 		if (bLoad_From_EEPOM)
 			priv->EEPROMPwDiff = (eprom_read(dev, (EEPROM_PwDiff>>1))&0x0f00)>>8;
 		else
 			priv->EEPROMPwDiff = EEPROM_Default_PwDiff;
 		RT_TRACE(COMP_EPROM, "TxPwDiff:%d\n", priv->EEPROMPwDiff);
-		// Read CrystalCap from EEPROM
+		/* Read CrystalCap from EEPROM */
 		if (bLoad_From_EEPOM)
 			priv->EEPROMCrystalCap = (eprom_read(dev, (EEPROM_CrystalCap>>1))&0x0f);
 		else
 			priv->EEPROMCrystalCap = EEPROM_Default_CrystalCap;
 		RT_TRACE(COMP_EPROM, "CrystalCap = %d\n", priv->EEPROMCrystalCap);
-		//get per-channel Tx power level
+		/* get per-channel Tx power level */
 		if (bLoad_From_EEPOM)
 			priv->EEPROM_Def_Ver = (eprom_read(dev, (EEPROM_TxPwIndex_Ver>>1))&0xff00)>>8;
 		else
@@ -2733,10 +2765,9 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 			else
 				tmpValue = 0x10;
 			priv->EEPROMTxPowerLevelOFDM24G[2] = (u8)tmpValue;
-		}//endif EEPROM_Def_Ver == 1
+		} /* endif EEPROM_Def_Ver == 1 */
 
-		//update HAL variables
-		//
+		/* update HAL variables */
 		for (i = 0; i < 14; i++) {
 			if (i <= 3)
 				priv->TxPowerLevelOFDM24G[i] = priv->EEPROMTxPowerLevelOFDM24G[0];
@@ -2764,18 +2795,18 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 			}
 		}
 		priv->TxPowerDiff = priv->EEPROMPwDiff;
-		// Antenna B gain offset to antenna A, bit0~3
+		/* Antenna B gain offset to antenna A, bit0~3 */
 		priv->AntennaTxPwDiff[0] = (priv->EEPROMTxPowerDiff & 0xf);
-		// Antenna C gain offset to antenna A, bit4~7
+		/* Antenna C gain offset to antenna A, bit4~7 */
 		priv->AntennaTxPwDiff[1] = ((priv->EEPROMTxPowerDiff & 0xf0)>>4);
-		// CrystalCap, bit12~15
+		/* CrystalCap, bit12~15 */
 		priv->CrystalCap = priv->EEPROMCrystalCap;
-		// ThermalMeter, bit0~3 for RFIC1, bit4~7 for RFIC2
-		// 92U does not enable TX power tracking.
+		/* ThermalMeter, bit0~3 for RFIC1, bit4~7 for RFIC2 */
+		/* 92U does not enable TX power tracking. */
 		priv->ThermalMeter[0] = priv->EEPROMThermalMeter;
-	}//end if VersionID == VERSION_819xU_A
+	} /* end if VersionID == VERSION_819xU_A */
 
-	//added by vivi, for dlink led, 20080416
+	/* for dlink led */
 	switch (priv->eeprom_CustomerID) {
 	case EEPROM_CID_RUNTOP:
 		priv->CustomerID = RT_CID_819x_RUNTOP;
@@ -2813,10 +2844,10 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 		RT_TRACE(COMP_EPROM, "\n2T4R config\n");
 	}
 
-	// 2008/01/16 MH We can only know RF type in the function. So we have to init
-	// DIG RATR table again.
+	/* We can only know RF type in the function. So we have to init
+	 * DIG RATR table again. */
 	init_rate_adaptive(dev);
-	//we need init DIG RATR table here again.
+	/* we need init DIG RATR table here again. */
 
 	RT_TRACE(COMP_EPROM, "<===========%s()\n", __func__);
 	return;
@@ -2890,8 +2921,7 @@ static void rtl8192_hwconfig(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u32 ratr_value = 0;
 
-	// Set RRSR, RATR, and BW_OPMODE registers
-	//
+	/* Set RRSR, RATR, and BW_OPMODE registers */
 	switch (priv->ieee80211->mode) {
 	case WIRELESS_MODE_B:
 		regBwOpMode = BW_OPMODE_20MHZ;
@@ -2924,8 +2954,9 @@ static void rtl8192_hwconfig(struct net_device *dev)
 		}
 		break;
 	case WIRELESS_MODE_N_24G:
-		// It support CCK rate by default.
-		// CCK rate will be filtered out only when associated AP does not support it.
+		/* It support CCK rate by default.
+		 * CCK rate will be filtered out only when associated AP does
+		 * not support it. */
 		regBwOpMode = BW_OPMODE_20MHZ;
 		regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG | RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
 		regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
@@ -2947,25 +2978,23 @@ static void rtl8192_hwconfig(struct net_device *dev)
 	regRRSR = ((regTmp) << 24) | (regRRSR & 0x00ffffff);
 	write_nic_dword(dev, RRSR, regRRSR);
 
-	//
-	// Set Retry Limit here
-	//
+	/* Set Retry Limit here */
 	write_nic_word(dev, RETRY_LIMIT,
 		       priv->ShortRetryLimit << RETRY_LIMIT_SHORT_SHIFT |
 		       priv->LongRetryLimit << RETRY_LIMIT_LONG_SHIFT);
-	// Set Contention Window here
+	/* Set Contention Window here */
 
-	// Set Tx AGC
+	/* Set Tx AGC */
 
-	// Set Tx Antenna including Feedback control
+	/* Set Tx Antenna including Feedback control */
 
-	// Set Auto Rate fallback control
+	/* Set Auto Rate fallback control */
 
 
 }
 
 
-//InitializeAdapter and PhyCfg
+/* InitializeAdapter and PhyCfg */
 static bool rtl8192_adapter_start(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
@@ -2975,7 +3004,7 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 	u8 tmp;
 	RT_TRACE(COMP_INIT, "====>%s()\n", __func__);
 	priv->Rf_Mode = RF_OP_By_SW_3wire;
-	//for ASIC power on sequence
+	/* for ASIC power on sequence */
 	write_nic_byte_E(dev, 0x5f, 0x80);
 	mdelay(50);
 	write_nic_byte_E(dev, 0x5f, 0xf0);
@@ -2984,21 +3013,21 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 	write_nic_byte(dev, 0x17, 0x37);
 	mdelay(10);
 	priv->pFirmware->firmware_status = FW_STATUS_0_INIT;
-	//config CPUReset Register
-	//Firmware Reset or not?
+	/* config CPUReset Register */
+	/* Firmware Reset or not? */
 	read_nic_dword(dev, CPU_GEN, &dwRegRead);
 	if (priv->pFirmware->firmware_status == FW_STATUS_0_INIT)
-		dwRegRead |= CPU_GEN_SYSTEM_RESET; //do nothing here?
+		dwRegRead |= CPU_GEN_SYSTEM_RESET; /* do nothing here? */
 	else if (priv->pFirmware->firmware_status == FW_STATUS_5_READY)
 		dwRegRead |= CPU_GEN_FIRMWARE_RESET;
 	else
 		RT_TRACE(COMP_ERR, "ERROR in %s(): undefined firmware state(%d)\n", __func__,   priv->pFirmware->firmware_status);
 
 	write_nic_dword(dev, CPU_GEN, dwRegRead);
-	//config BB.
+	/* config BB. */
 	rtl8192_BBConfig(dev);
 
-	//Loopback mode or not
+	/* Loopback mode or not */
 	priv->LoopbackMode = RTL819xU_NO_LOOPBACK;
 
 	read_nic_dword(dev, CPU_GEN, &dwRegRead);
@@ -3011,27 +3040,27 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 
 	write_nic_dword(dev, CPU_GEN, dwRegRead);
 
-	//after reset cpu, we need wait for a seconds to write in register.
+	/* after reset cpu, we need wait for a seconds to write in register. */
 	udelay(500);
 
-	//xiong add for new bitfile:usb suspend reset pin set to 1. //do we need?
+	/* add for new bitfile:usb suspend reset pin set to 1. do we need? */
 	read_nic_byte_E(dev, 0x5f, &tmp);
 	write_nic_byte_E(dev, 0x5f, tmp|0x20);
 
-	//Set Hardware
+	/* Set Hardware */
 	rtl8192_hwconfig(dev);
 
-	//turn on Tx/Rx
+	/* turn on Tx/Rx */
 	write_nic_byte(dev, CMDR, CR_RE|CR_TE);
 
-	//set IDR0 here
+	/* set IDR0 here */
 	write_nic_dword(dev, MAC0, ((u32 *)dev->dev_addr)[0]);
 	write_nic_word(dev, MAC4, ((u16 *)(dev->dev_addr + 4))[0]);
 
-	//set RCR
+	/* set RCR */
 	write_nic_dword(dev, RCR, priv->ReceiveConfig);
 
-	//Initialize Number of Reserved Pages in Firmware Queue
+	/* Initialize Number of Reserved Pages in Firmware Queue */
 	write_nic_dword(dev, RQPN1,  NUM_OF_PAGE_IN_FW_QUEUE_BK << RSVD_FW_QUEUE_PAGE_BK_SHIFT |
 			NUM_OF_PAGE_IN_FW_QUEUE_BE << RSVD_FW_QUEUE_PAGE_BE_SHIFT |
 			NUM_OF_PAGE_IN_FW_QUEUE_VI << RSVD_FW_QUEUE_PAGE_VI_SHIFT |
@@ -3042,8 +3071,8 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 			NUM_OF_PAGE_IN_FW_QUEUE_BCN<<RSVD_FW_QUEUE_PAGE_BCN_SHIFT);
 	write_nic_dword(dev, RATR0+4*7, (RATE_ALL_OFDM_AG | RATE_ALL_CCK));
 
-	//Set AckTimeout
-	// TODO: (it value is only for FPGA version). need to be changed!!2006.12.18, by Emily
+	/* Set AckTimeout */
+	/* TODO: (it value is only for FPGA version). need to be changed!!*/
 	write_nic_byte(dev, ACK_TIMEOUT, 0x30);
 
 	if (priv->ResetProgress == RESET_TYPE_NORESET)
@@ -3056,7 +3085,7 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 		write_nic_byte(dev, SECR, SECR_value);
 	}
 
-	//Beacon related
+	/* Beacon related */
 	write_nic_word(dev, ATIMWND, 2);
 	write_nic_word(dev, BCN_INTERVAL, 100);
 
@@ -3067,7 +3096,7 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 			write_nic_dword(dev, WDCAPARA_ADD[i], DEFAULT_EDCA);
 	}
 #ifdef USB_RX_AGGREGATION_SUPPORT
-	//3 For usb rx firmware aggregation control
+	/* 3 For usb rx firmware aggregation control */
 	if (priv->ResetProgress == RESET_TYPE_NORESET) {
 		u32 ulValue;
 		PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;
@@ -3090,7 +3119,7 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 		rtl8192_phy_setTxPower(dev, priv->chan);
 	}
 
-	//Firmware download
+	/* Firmware download */
 	init_status = init_firmware(dev);
 	if (!init_status) {
 		RT_TRACE(COMP_ERR, "ERR!!! %s(): Firmware download is failed\n", __func__);
@@ -3103,10 +3132,12 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 		if (pMgntInfo->RegRfOff == TRUE) { /* User disable RF via registry. */
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RegRfOff ----------\n"));
 			MgntActSet_RF_State(Adapter, eRfOff, RF_CHANGE_BY_SW);
-			// Those actions will be discard in MgntActSet_RF_State because of the same state
+			/* Those actions will be discard in MgntActSet_RF_State
+			 * because of the same state */
 			for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++)
 				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
-		} else if (pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) { /* H/W or S/W RF OFF before sleep. */
+		/* H/W or S/W RF OFF before sleep. */
+		} else if (pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) {
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RfOffReason(%d) ----------\n", pMgntInfo->RfOffReason));
 			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
 		} else {
@@ -3123,7 +3154,7 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 		}
 	}
 #endif
-	//config RF.
+	/* config RF. */
 	if (priv->ResetProgress == RESET_TYPE_NORESET) {
 		rtl8192_phy_RFConfig(dev);
 		RT_TRACE(COMP_INIT, "%s():after phy RF config\n", __func__);
@@ -3131,7 +3162,7 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 
 
 	if (priv->ieee80211->FwRWRF)
-		// We can force firmware to do RF-R/W
+		/* We can force firmware to do RF-R/W */
 		priv->Rf_Mode = RF_OP_By_FW;
 	else
 		priv->Rf_Mode = RF_OP_By_SW_3wire;
@@ -3143,7 +3174,7 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 	rtl8192_setBBreg(dev, rFPGA0_RFMOD, bOFDMEn, 0x1);
 
 	if (priv->ResetProgress == RESET_TYPE_NORESET) {
-		//if D or C cut
+		/* if D or C cut */
 		u8 tmpvalue;
 		read_nic_byte(dev, 0x301, &tmpvalue);
 		if (tmpvalue == 0x03) {
@@ -3228,9 +3259,7 @@ static RESET_TYPE TxCheckStuck(struct net_device *dev)
 	u8			QueueID;
 	bool			bCheckFwTxCnt = false;
 
-	//
-	// Decide such threshold according to current power save mode
-	//
+	/* Decide such threshold according to current power save mode */
 
 	for (QueueID = 0; QueueID <= BEACON_QUEUE; QueueID++) {
 		if (QueueID == TXCMD_QUEUE)
@@ -3261,8 +3290,8 @@ static bool HalRxCheckStuck819xUsb(struct net_device *dev)
 	static u8	rx_chk_cnt;
 	read_nic_word(dev, 0x130, &RegRxCounter);
 	RT_TRACE(COMP_RESET, "%s(): RegRxCounter is %d,RxCounter is %d\n", __func__, RegRxCounter, priv->RxCounter);
-	// If rssi is small, we should check rx for long time because of bad rx.
-	// or maybe it will continuous silent reset every 2 seconds.
+	/* If rssi is small, we should check rx for long time because of bad rx.
+	 * or maybe it will continuous silent reset every 2 seconds. */
 	rx_chk_cnt++;
 	if (priv->undecorated_smoothed_pwdb >= (RateAdaptiveTH_High+5)) {
 		rx_chk_cnt = 0;	//high rssi, check rx stuck right now.
@@ -3337,14 +3366,17 @@ static RESET_TYPE rtl819x_ifcheck_resetornot(struct net_device *dev)
 	TxResetType = TxCheckStuck(dev);
 	if (rfState != eRfOff ||
 	    (priv->ieee80211->iw_mode != IW_MODE_ADHOC)) {
-		// If driver is in the status of firmware download failure , driver skips RF initialization and RF is
-		// in turned off state. Driver should check whether Rx stuck and do silent reset. And
-		// if driver is in firmware download failure status, driver should initialize RF in the following
-		// silent reset procedure Emily, 2008.01.21
-
-		// Driver should not check RX stuck in IBSS mode because it is required to
-		// set Check BSSID in order to send beacon, however, if check BSSID is
-		// set, STA cannot hear any packet at all. Emily, 2008.04.12
+		/* If driver is in the status of firmware download failure,
+		 * driver skips RF initialization and RF is in turned off state.
+		 * Driver should check whether Rx stuck and do silent reset.
+		 * And if driver is in firmware download failure status, driver
+		 * should initialize RF in the following silent reset procedure
+		 */
+
+		/* Driver should not check RX stuck in IBSS mode because it is
+		 * required to set Check BSSID in order to send beacon, however,
+		 * if check BSSID is set, STA cannot hear any packet at all.
+		 */
 		RxResetType = RxCheckStuck(dev);
 	}
 	if (TxResetType == RESET_TYPE_NORMAL || RxResetType == RESET_TYPE_NORMAL) {
@@ -3434,12 +3466,12 @@ static void CamRestoreAllEntry(struct net_device *dev)
 			       CAM_CONST_ADDR[0], 0, NULL);
 	}
 }
-//////////////////////////////////////////////////////////////
-// This function is used to fix Tx/Rx stop bug temporarily.
-// This function will do "system reset" to NIC when Tx or Rx is stuck.
-// The method checking Tx/Rx stuck of this function is supported by FW,
-// which reports Tx and Rx counter to register 0x128 and 0x130.
-//////////////////////////////////////////////////////////////
+/*------------------------------------------------------------------------------
+ * This function is used to fix Tx/Rx stop bug temporarily.
+ * This function will do "system reset" to NIC when Tx or Rx is stuck.
+ * The method checking Tx/Rx stuck of this function is supported by FW,
+ * which reports Tx and Rx counter to register 0x128 and 0x130.
+ *----------------------------------------------------------------------------*/
 static void rtl819x_ifsilentreset(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
@@ -3448,15 +3480,17 @@ static void rtl819x_ifsilentreset(struct net_device *dev)
 	struct ieee80211_device *ieee = priv->ieee80211;
 
 
-	// 2007.07.20. If we need to check CCK stop, please uncomment this line.
-	//bStuck = Adapter->HalFunc.CheckHWStopHandler(Adapter);
+	/* If we need to check CCK stop, please uncomment this line. */
+	/*
+	bStuck = Adapter->HalFunc.CheckHWStopHandler(Adapter);
+	*/
 
 	if (priv->ResetProgress == RESET_TYPE_NORESET) {
 RESET_START:
 
 		RT_TRACE(COMP_RESET, "=========>Reset progress!! \n");
 
-		// Set the variable for reset.
+		/* Set the variable for reset. */
 		priv->ResetProgress = RESET_TYPE_SILENT;
 		down(&priv->wx_sem);
 		if (priv->up == 0) {
@@ -3526,7 +3560,7 @@ RESET_START:
 		priv->bForcedSilentReset = false;
 		priv->bResetInProgress = false;
 
-		// For test --> force write UFWP.
+		/* For test --> force write UFWP. */
 		write_nic_byte(dev, UFWP, 1);
 		RT_TRACE(COMP_RESET, "Reset finished!! ====>[%d]\n", priv->reset_count);
 	}
@@ -3540,11 +3574,11 @@ void CAM_read_entry(struct net_device *dev, u32 iIndex)
 	u32 ulStatus;
 	s32 i = 100;
 	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
-		// polling bit, and No Write enable, and address
+		/* polling bit, and No Write enable, and address */
 		target_command = entry_i+CAM_CONTENT_COUNT*iIndex;
 		target_command = target_command | BIT31;
 
-		//Check polling bit is clear
+		/* Check polling bit is clear */
 		while ((i--) >= 0) {
 			read_nic_dword(dev, RWCAM, &ulStatus);
 			if (ulStatus & BIT31)
@@ -3595,7 +3629,7 @@ void rtl819x_watchdog_wqcallback(struct work_struct *work)
 		return;
 	hal_dm_watchdog(dev);
 
-	//to get busy traffic condition
+	/* to get busy traffic condition */
 	if (ieee->state == IEEE80211_LINKED) {
 		if (ieee->LinkDetectInfo.NumRxOkInPeriod > 666 ||
 		    ieee->LinkDetectInfo.NumTxOkInPeriod > 666 ) {
@@ -3605,7 +3639,7 @@ void rtl819x_watchdog_wqcallback(struct work_struct *work)
 		ieee->LinkDetectInfo.NumTxOkInPeriod = 0;
 		ieee->LinkDetectInfo.bBusyTraffic = bBusyTraffic;
 	}
-	//added by amy for AP roaming
+	/* added by amy for AP roaming */
 	if (priv->ieee80211->state == IEEE80211_LINKED && priv->ieee80211->iw_mode == IW_MODE_INFRA) {
 
 		rtl819x_update_rxcounts(priv, &TotalRxBcnNum, &TotalRxDataNum);
@@ -3625,7 +3659,7 @@ void rtl819x_watchdog_wqcallback(struct work_struct *work)
 	}
 	priv->ieee80211->LinkDetectInfo.NumRecvBcnInPeriod = 0;
 	priv->ieee80211->LinkDetectInfo.NumRecvDataInPeriod = 0;
-	//check if reset the driver
+	/* check if reset the driver */
 	if (check_reset_cnt++ >= 3) {
 		ResetType = rtl819x_ifcheck_resetornot(dev);
 		check_reset_cnt = 3;
@@ -3741,7 +3775,9 @@ int rtl8192_down(struct net_device *dev)
 	for (i = 0; i < MAX_QUEUE_SIZE; i++)
 		skb_queue_purge(&priv->ieee80211->skb_drv_aggQ[i]);
 
-	//as cancel_delayed_work will del work->timer, so if work is not defined as struct delayed_work, it will corrupt
+	/* as cancel_delayed_work will del work->timer, so if work is not
+	 * defined as struct delayed_work, it will corrupt
+	 */
 	rtl8192_cancel_deferred_work(priv);
 	deinit_hal_dm(dev);
 	del_timer_sync(&priv->watch_dog_timer);
@@ -3843,7 +3879,7 @@ static int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	switch (cmd) {
 	case RTL_IOCTL_WPA_SUPPLICANT:
-		//parse here for HW security
+		/* parse here for HW security */
 		if (ipw->cmd == IEEE_CMD_SET_ENCRYPTION) {
 			if (ipw->u.crypt.set_tx) {
 				if (strcmp(ipw->u.crypt.alg, "CCMP") == 0) {
@@ -3862,8 +3898,12 @@ static int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 				if (ieee->pairwise_key_type) {
 					memcpy((u8 *)key, ipw->u.crypt.key, 16);
 					EnableHWSecurityConfig8192(dev);
-					//we fill both index entry and 4th entry for pairwise key as in IPW interface, adhoc will only get here, so we need index entry for its default key serching!
-					//added by WB.
+					/* we fill both index entry and 4th
+					 * entry for pairwise key as in IPW
+					 * interface, adhoc will only get here,
+					 * so we need index entry for its
+					 * default key serching!
+					 */
 					setKey(dev, 4, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8 *)ieee->ap_mac_addr, 0, key);
 					if (ieee->auth_mode != 2)
 						setKey(dev, ipw->u.crypt.idx, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8 *)ieee->ap_mac_addr, 0, key);
@@ -3885,11 +3925,16 @@ static int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 				if (ieee->group_key_type) {
 					setKey(dev, ipw->u.crypt.idx,
-					       ipw->u.crypt.idx,		//KeyIndex
-					       ieee->group_key_type,	//KeyType
-					       broadcast_addr,	//MacAddr
-					       0,		//DefaultKey
-					       key);		//KeyContent
+						/* KeyIndex */
+					       ipw->u.crypt.idx,
+						/* KeyType */
+					       ieee->group_key_type,
+						/* MacAddr */
+					       broadcast_addr,
+						/* DefaultKey */
+					       0,
+						/* KeyContent */
+					       key);
 				}
 			}
 		}
@@ -4049,13 +4094,11 @@ static void UpdateRxPktTimeStamp8190(struct net_device *dev,
 	}
 }
 
-//by amy 080606
-
-static long rtl819x_translate_todbm(u8 signal_strength_index)// 0-100 index.
+static long rtl819x_translate_todbm(u8 signal_strength_index)/* 0-100 index. */
 {
-	long	signal_power; // in dBm.
+	long	signal_power; /* in dBm. */
 
-	// Translate to dBm (x=0.5y-95).
+	/* Translate to dBm (x=0.5y-95). */
 	signal_power = (long)((signal_strength_index + 1) >> 1);
 	signal_power -= 95;
 
@@ -4088,13 +4131,13 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 	sc = le16_to_cpu(hdr->seq_ctl);
 	frag = WLAN_GET_SEQ_FRAG(sc);
 	seq = WLAN_GET_SEQ_SEQ(sc);
-	//cosa add 04292008 to record the sequence number
+	/* to record the sequence number */
 	pcurrent_stats->Seq_Num = seq;
-	//
-	// Check whether we should take the previous packet into accounting
-	//
+	/*
+	 * Check whether we should take the previous packet into accounting
+	 */
 	if (!pprevious_stats->bIsAMPDU) {
-		// if previous packet is not aggregated packet
+		/* if previous packet is not aggregated packet */
 		bcheck = true;
 	}
 
@@ -4109,13 +4152,13 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 	if (slide_rssi_index >= PHY_RSSI_SLID_WIN_MAX)
 		slide_rssi_index = 0;
 
-	// <1> Showed on UI for user, in dbm
+	/* <1> Showed on UI for user, in dbm */
 	tmp_val = priv->stats.slide_rssi_total/slide_rssi_statistics;
 	priv->stats.signal_strength = rtl819x_translate_todbm((u8)tmp_val);
 	pcurrent_stats->rssi = priv->stats.signal_strength;
-	//
-	// If the previous packet does not match the criteria, neglect it
-	//
+	/*
+	 * If the previous packet does not match the criteria, neglect it
+	 */
 	if (!pprevious_stats->bPacketMatchBSSID) {
 		if (!pprevious_stats->bToSelfBA)
 			return;
@@ -4124,25 +4167,26 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 	if (!bcheck)
 		return;
 
+	/* only rtl8190 supported */
+	/*
+	rtl8190_process_cck_rxpathsel(priv,pprevious_stats);
+	*/
 
-	//rtl8190_process_cck_rxpathsel(priv,pprevious_stats);//only rtl8190 supported
-
-	//
-	// Check RSSI
-	//
+	/*
+	 * Check RSSI
+	 */
 	priv->stats.num_process_phyinfo++;
 
 	/* record the general signal strength to the sliding window. */
 
 
-	// <2> Showed on UI for engineering
-	// hardware does not provide rssi information for each rf path in CCK
+	/* <2> Showed on UI for engineering
+	 * hardware does not provide rssi information for each rf path in CCK */
 	if (!pprevious_stats->bIsCCK && (pprevious_stats->bPacketToSelf || pprevious_stats->bToSelfBA)) {
 		for (rfpath = RF90_PATH_A; rfpath < priv->NumTotalRFPath; rfpath++) {
 			if (!rtl8192_phy_CheckIsLegalRFPath(priv->ieee80211->dev, rfpath))
 				continue;
 
-			//Fixed by Jacken 2008-03-20
 			if (priv->stats.rx_rssi_percentage[rfpath] == 0)
 				priv->stats.rx_rssi_percentage[rfpath] = pprevious_stats->RxMIMOSignalStrength[rfpath];
 			if (pprevious_stats->RxMIMOSignalStrength[rfpath]  > priv->stats.rx_rssi_percentage[rfpath]) {
@@ -4160,9 +4204,9 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 	}
 
 
-	//
-	// Check PWDB.
-	//
+	/*
+	 * Check PWDB.
+	 */
 	RT_TRACE(COMP_RXDESC, "Smooth %s PWDB = %d\n",
 		 pprevious_stats->bIsCCK ? "CCK" : "OFDM",
 		 pprevious_stats->RxPWDBAll);
@@ -4205,9 +4249,9 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 
 	}
 
-	//
-	// Check EVM
-	//
+	/*
+	 * Check EVM
+	 */
 	/* record the general EVM to the sliding window. */
 	if (pprevious_stats->SignalQuality) {
 		if (pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA) {
@@ -4223,14 +4267,15 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 			if (slide_evm_index >= PHY_RSSI_SLID_WIN_MAX)
 				slide_evm_index = 0;
 
-			// <1> Showed on UI for user, in percentage.
+			/* <1> Showed on UI for user, in percentage. */
 			tmp_val = priv->stats.slide_evm_total/slide_evm_statistics;
 			priv->stats.signal_quality = tmp_val;
-			//cosa add 10/11/2007, Showed on UI for user in Windows Vista, for Link quality.
+			/* Showed on UI for user in Windows Vista,
+			 * for Link quality. */
 			priv->stats.last_signal_strength_inpercent = tmp_val;
 		}
 
-		// <2> Showed on UI for engineering
+		/* <2> Showed on UI for engineering */
 		if (pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA) {
 			for (nspatial_stream = 0; nspatial_stream < 2; nspatial_stream++) { /* 2 spatial stream */
 				if (pprevious_stats->RxMIMOSignalQuality[nspatial_stream] != -1) {
@@ -4290,16 +4335,15 @@ static u8 rtl819x_evm_dbtopercentage(char value)
 		ret_val = 100;
 	return ret_val;
 }
-//
-//	Description:
-//	We want good-looking for signal strength/quality
-//	2007/7/19 01:09, by cosa.
-//
+/*
+ *	Description:
+ *	We want good-looking for signal strength/quality
+ */
 static long rtl819x_signal_scale_mapping(long currsig)
 {
 	long retsig;
 
-	// Step 1. Scale mapping.
+	/* Step 1. Scale mapping. */
 	if (currsig >= 61 && currsig <= 100)
 		retsig = 90 + ((currsig - 60) / 4);
 	else if (currsig >= 41 && currsig <= 60)
@@ -4367,7 +4411,7 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 
 	is_cck_rate = rx_hal_is_cck_rate(pdrvinfo);
 
-	// Record it for next packet processing
+	/* Record it for next packet processing */
 	memset(precord_stats, 0, sizeof(struct ieee80211_rx_stats));
 	pstats->bPacketMatchBSSID = precord_stats->bPacketMatchBSSID = bpacket_match_bssid;
 	pstats->bPacketToSelf = precord_stats->bPacketToSelf = bpacket_toself;
@@ -4390,13 +4434,13 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 	precord_stats->RxMIMOSignalQuality[1] = -1;
 
 	if (is_cck_rate) {
-		//
-		// (1)Hardware does not provide RSSI for CCK
-		//
+		/*
+		 * (1)Hardware does not provide RSSI for CCK
+		 */
 
-		//
-		// (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive)
-		//
+		/*
+		 * (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive)
+		 */
 		u8 report;
 
 		priv->stats.numqry_phystatusCCK++;
@@ -4405,9 +4449,8 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 			report = pcck_buf->cck_agc_rpt & 0xc0;
 			report = report>>6;
 			switch (report) {
-				//Fixed by Jacken from Bryant 2008-03-20
-				//Original value is -38 , -26 , -14 , -2
-				//Fixed value is -35 , -23 , -11 , 6
+				/* Original value is -38 , -26 , -14 , -2*/
+				/* Fixed value is -35 , -23 , -11 , 6 */
 			case 0x3:
 				rx_pwr_all = -35 - (pcck_buf->cck_agc_rpt & 0x3e);
 				break;
@@ -4444,9 +4487,9 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 		pstats->RxPWDBAll = precord_stats->RxPWDBAll = pwdb_all;
 		pstats->RecvSignalPower = pwdb_all;
 
-		//
-		// (3) Get Signal Quality (EVM)
-		//
+		/*
+		 * (3) Get Signal Quality (EVM)
+		 */
 
 		if (pstats->RxPWDBAll > 40) {
 			sq = 100;
@@ -4466,11 +4509,11 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 
 	} else {
 		priv->stats.numqry_phystatusHT++;
-		//
-		// (1)Get RSSI for HT rate
-		//
+		/*
+		 * (1)Get RSSI for HT rate
+		 */
 		for (i = RF90_PATH_A; i < priv->NumTotalRFPath; i++) {
-			// 2008/01/30 MH we will judge RF RX path now.
+			/* we will judge RF RX path now. */
 			if (priv->brfpath_rxenable[i])
 				rf_rx_num++;
 			else
@@ -4479,11 +4522,10 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 			if (!rtl8192_phy_CheckIsLegalRFPath(priv->ieee80211->dev, i))
 				continue;
 
-			//Fixed by Jacken from Bryant 2008-03-20
-			//Original value is 106
+			/* Original value is 106 */
 			rx_pwr[i] = ((pofdm_buf->trsw_gain_X[i]&0x3F)*2) - 106;
 
-			//Get Rx snr value in DB
+			/* Get Rx snr value in DB */
 			tmp_rxsnr =	pofdm_buf->rxsnr_X[i];
 			rx_snrX = (char)(tmp_rxsnr);
 			rx_snrX /= 2;
@@ -4499,34 +4541,39 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 		}
 
 
-		//
-		// (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive)
-		//
-		//Fixed by Jacken from Bryant 2008-03-20
-		//Original value is 106
+		/*
+		 * (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive)
+		 */
+		/* Original value is 106 */
 		rx_pwr_all = (((pofdm_buf->pwdb_all) >> 1)& 0x7f) -106;
 		pwdb_all = rtl819x_query_rxpwrpercentage(rx_pwr_all);
 
 		pstats->RxPWDBAll = precord_stats->RxPWDBAll = pwdb_all;
 		pstats->RxPower = precord_stats->RxPower =  rx_pwr_all;
 
-		//
-		// (3)EVM of HT rate
-		//
+		/*
+		 * (3)EVM of HT rate
+		 */
 		if (pdrvinfo->RxHT && pdrvinfo->RxRate >= DESC90_RATEMCS8 &&
 		    pdrvinfo->RxRate <= DESC90_RATEMCS15)
-			max_spatial_stream = 2; //both spatial stream make sense
+			/* both spatial stream make sense */
+			max_spatial_stream = 2;
 		else
-			max_spatial_stream = 1; //only spatial stream 1 makes sense
+			/* only spatial stream 1 makes sense */
+			max_spatial_stream = 1;
 
 		for (i = 0; i < max_spatial_stream; i++) {
 			tmp_rxevm =	pofdm_buf->rxevm_X[i];
 			rx_evmX = (char)(tmp_rxevm);
 
-			// Do not use shift operation like "rx_evmX >>= 1" because the compiler of free build environment
-			// will set the most significant bit to "zero" when doing shifting operation which may change a negative
-			// value to positive one, then the dbm value (which is supposed to be negative)  is not correct anymore.
-			rx_evmX /= 2;	//dbm
+			/* Do not use shift operation like "rx_evmX >>= 1"
+			 * because the compiler of free build environment
+			 * will set the most significant bit to "zero" when
+			 * doing shifting operation which may change a negative
+			 * value to positive one, then the dbm value (which is
+			 * supposed to be negative)  is not correct anymore.
+			 */
+			rx_evmX /= 2;	/* dbm */
 
 			evm = rtl819x_evm_dbtopercentage(rx_evmX);
 			if (i == 0) /* Fill value in RFD, Get the first spatial stream only */
@@ -4540,16 +4587,18 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 		prxsc =	(phy_ofdm_rx_status_rxsc_sgien_exintfflag *)&rxsc_sgien_exflg;
 		if (pdrvinfo->BW)	/* 40M channel */
 			priv->stats.received_bwtype[1+prxsc->rxsc]++;
-		else				//20M channel
+		else			/* 20M channel */
 			priv->stats.received_bwtype[0]++;
 	}
 
-	//UI BSS List signal strength(in percentage), make it good looking, from 0~100.
-	//It is assigned to the BSS List in GetValueFromBeaconOrProbeRsp().
+	/* UI BSS List signal strength(in percentage), make it good looking,
+	 * from 0~100. It is assigned to the BSS List in
+	 * GetValueFromBeaconOrProbeRsp().
+	 */
 	if (is_cck_rate) {
 		pstats->SignalStrength = precord_stats->SignalStrength = (u8)(rtl819x_signal_scale_mapping((long)pwdb_all));
 	} else {
-		// We can judge RX path number now.
+		/* We can judge RX path number now. */
 		if (rf_rx_num != 0)
 			pstats->SignalStrength = precord_stats->SignalStrength = (u8)(rtl819x_signal_scale_mapping((long)(total_rssi /= rf_rx_num)));
 	}
@@ -4568,7 +4617,7 @@ static void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 					  struct ieee80211_rx_stats *pstats,
 					  rx_drvinfo_819x_usb  *pdrvinfo)
 {
-	// TODO: We must only check packet for current MAC address. Not finish
+	/* TODO: We must only check packet for current MAC address. Not finish*/
 	rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb;
 	struct net_device *dev = info->dev;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
@@ -4578,7 +4627,7 @@ static void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 	struct ieee80211_hdr_3addr *hdr;//by amy
 	u16 fc, type;
 
-	// Get Signal Quality for only RX data queue (but not command queue)
+	/* Get Signal Quality for only RX data queue (but not command queue) */
 
 	u8 *tmp_buf;
 	u8  *praddr;
@@ -4610,11 +4659,12 @@ static void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 		priv->stats.numpacket_matchbssid++;
 	if (bpacket_toself)
 		priv->stats.numpacket_toself++;
-	//
-	// Process PHY information for previous packet (RSSI/PWDB/EVM)
-	//
-	// Because phy information is contained in the last packet of AMPDU only, so driver
-	// should process phy information of previous packet
+	/*
+	 * Process PHY information for previous packet (RSSI/PWDB/EVM)
+	 *
+	 * Because phy information is contained in the last packet of AMPDU only, so driver
+	 * should process phy information of previous packet
+	 */
 	rtl8192_process_phyinfo(priv, tmp_buf, &previous_stats, pstats);
 	rtl8192_query_rxphystatus(priv, pstats, pdrvinfo, &previous_stats, bpacket_match_bssid, bpacket_toself, bPacketBeacon, bToSelfBA);
 	rtl8192_record_rxdesc_forlateruse(pstats, &previous_stats);
@@ -4640,9 +4690,11 @@ UpdateReceivedRateHistogramStatistics8190(struct net_device *dev,
 					  struct ieee80211_rx_stats *stats)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-	u32 rcvType = 1;   //0: Total, 1:OK, 2:CRC, 3:ICV
+	/* 0: Total, 1:OK, 2:CRC, 3:ICV */
+	u32 rcvType = 1;
 	u32 rateIndex;
-	u32 preamble_guardinterval;  //1: short preamble/GI, 0: long preamble/GI
+	/* 1: short preamble/GI, 0: long preamble/GI */
+	u32 preamble_guardinterval;
 
 
 	if (stats->bCRC)
@@ -4651,14 +4703,14 @@ UpdateReceivedRateHistogramStatistics8190(struct net_device *dev,
 		rcvType = 3;
 
 	if (stats->bShortPreamble)
-		preamble_guardinterval = 1;// short
+		preamble_guardinterval = 1;	/* short */
 	else
-		preamble_guardinterval = 0;// long
+		preamble_guardinterval = 0;	/* long */
 
 	switch (stats->rate) {
-		//
-		// CCK rate
-		//
+		/*
+		 * CCK rate
+		 */
 		case MGN_1M:
 			rateIndex = 0;
 			break;
@@ -4671,9 +4723,9 @@ UpdateReceivedRateHistogramStatistics8190(struct net_device *dev,
 		case MGN_11M:
 			rateIndex = 3;
 			break;
-		//
-		// Legacy OFDM rate
-		//
+		/*
+		 * Legacy OFDM rate
+		 */
 		case MGN_6M:
 			rateIndex = 4;
 			break;
@@ -4698,9 +4750,9 @@ UpdateReceivedRateHistogramStatistics8190(struct net_device *dev,
 		case MGN_54M:
 			rateIndex = 11;
 			break;
-		//
-		// 11n High throughput rate
-		//
+		/*
+		 * 11n High throughput rate
+		 */
 		case MGN_MCS0:
 			rateIndex = 12;
 			break;
@@ -4754,7 +4806,7 @@ UpdateReceivedRateHistogramStatistics8190(struct net_device *dev,
 			break;
 	}
 	priv->stats.received_preamble_GI[preamble_guardinterval][rateIndex]++;
-	priv->stats.received_rate_histogram[0][rateIndex]++; //total
+	priv->stats.received_rate_histogram[0][rateIndex]++; /* total */
 	priv->stats.received_rate_histogram[rcvType][rateIndex]++;
 }
 
@@ -4768,19 +4820,22 @@ static void query_rxdesc_status(struct sk_buff *skb,
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	rx_drvinfo_819x_usb  *driver_info = NULL;
 
-	//
-	//Get Rx Descriptor Information
-	//
+	/*
+	 *Get Rx Descriptor Information
+	 */
 #ifdef USB_RX_AGGREGATION_SUPPORT
 	if (bIsRxAggrSubframe) {
 		rx_desc_819x_usb_aggr_subframe *desc = (rx_desc_819x_usb_aggr_subframe *)skb->data;
 		stats->Length = desc->Length;
 		stats->RxDrvInfoSize = desc->RxDrvInfoSize;
-		stats->RxBufShift = 0; //RxBufShift = 2 in RxDesc, but usb didn't shift bytes in fact.
+		/* RxBufShift = 2 in RxDesc but usb didn't shift bytes in fact*/
+		stats->RxBufShift = 0;
 		stats->bICV = desc->ICV;
 		stats->bCRC = desc->CRC32;
 		stats->bHwError = stats->bCRC|stats->bICV;
-		stats->Decrypted = !desc->SWDec;//RTL8190 set this bit to indicate that Hw does not decrypt packet
+		/* RTL8190 set this bit to indicate that Hw does not decrypt
+		 * packet */
+		stats->Decrypted = !desc->SWDec;
 	} else
 #endif
 	{
@@ -4792,7 +4847,8 @@ static void query_rxdesc_status(struct sk_buff *skb,
 		stats->bICV = desc->ICV;
 		stats->bCRC = desc->CRC32;
 		stats->bHwError = stats->bCRC|stats->bICV;
-		//RTL8190 set this bit to indicate that Hw does not decrypt packet
+		/* RTL8190 set this bit to indicate that Hw does not decrypt
+		 * packet */
 		stats->Decrypted = !desc->SWDec;
 	}
 
@@ -4803,11 +4859,11 @@ static void query_rxdesc_status(struct sk_buff *skb,
 
 	if (stats->Length < 24 || stats->Length > MAX_8192U_RX_SIZE)
 		stats->bHwError |= 1;
-	//
-	//Get Driver Info
-	//
-	// TODO: Need to verify it on FGPA platform
-	//Driver info are written to the RxBuffer following rx desc
+	/*
+	 *Get Driver Info
+	 */
+	/* TODO: Need to verify it on FGPA platform */
+	/* Driver info are written to the RxBuffer following rx desc */
 	if (stats->RxDrvInfoSize != 0) {
 		driver_info = (rx_drvinfo_819x_usb *)(skb->data + sizeof(rx_desc_819x_usb) +
 						      stats->RxBufShift);
@@ -4817,11 +4873,13 @@ static void query_rxdesc_status(struct sk_buff *skb,
 			u8	ret_rate;
 			ret_rate = HwRateToMRate90(driver_info->RxHT, driver_info->RxRate);
 			if (ret_rate == 0xff) {
-				// Abnormal Case: Receive CRC OK packet with Rx descriptor indicating non supported rate.
-				// Special Error Handling here, 2008.05.16, by Emily
+				/* Abnormal Case: Receive CRC OK packet with Rx
+				 * descriptor indicating non supported rate.
+				 * Special Error Handling here */
 
 				stats->bHwError = 1;
-				stats->rate = MGN_1M;	//Set 1M rate by default
+				/* Set 1M rate by default */
+				stats->rate = MGN_1M;
 			} else {
 				stats->rate = ret_rate;
 			}
@@ -4837,13 +4895,13 @@ static void query_rxdesc_status(struct sk_buff *skb,
 		stats->bIsAMPDU = (driver_info->PartAggr == 1);
 		stats->bFirstMPDU = (driver_info->PartAggr == 1) && (driver_info->FirstAGGR == 1);
 		stats->TimeStampLow = driver_info->TSFL;
-		// xiong mask it, 070514
+		/* mask it */
 
 		UpdateRxPktTimeStamp8190(dev, stats);
 
-		//
-		// Rx A-MPDU
-		//
+		/*
+		 * Rx A-MPDU
+		 */
 		if (driver_info->FirstAGGR == 1 || driver_info->PartAggr == 1)
 			RT_TRACE(COMP_RXDESC, "driver_info->FirstAGGR = %d, driver_info->PartAggr = %d\n",
 				 driver_info->FirstAGGR, driver_info->PartAggr);
@@ -4851,9 +4909,9 @@ static void query_rxdesc_status(struct sk_buff *skb,
 	}
 
 	skb_pull(skb, sizeof(rx_desc_819x_usb));
-	//
-	// Get Total offset of MPDU Frame Body
-	//
+	/*
+	 * Get Total offset of MPDU Frame Body
+	 */
 	if ((stats->RxBufShift + stats->RxDrvInfoSize) > 0) {
 		stats->bShift = 1;
 		skb_pull(skb, stats->RxBufShift + stats->RxDrvInfoSize);
@@ -4864,9 +4922,6 @@ static void query_rxdesc_status(struct sk_buff *skb,
 	if (bIsRxAggrSubframe)
 		skb_pull(skb, 8);
 #endif
-	/* for debug 2008.5.29 */
-
-	//added by vivi, for MP, 20080108
 	stats->RxIs40MHzPacket = driver_info->BW;
 	if (stats->RxDrvInfoSize != 0)
 		TranslateRxSignalStuff819xUsb(skb, stats, driver_info);
@@ -4909,7 +4964,7 @@ static void rtl8192_rx_nomal(struct sk_buff *skb)
 	u32  PacketShiftBytes = 0;
 	rx_desc_819x_usb_aggr_subframe *RxDescr = NULL;
 	u8  PaddingBytes = 0;
-	//add just for testing
+	/* add just for testing */
 	u8   testing;
 
 #endif
@@ -4942,9 +4997,9 @@ static void rtl8192_rx_nomal(struct sk_buff *skb)
 		ieee80211_hdr = (struct ieee80211_hdr_1addr *)skb->data;
 		unicast_packet = false;
 		if (is_broadcast_ether_addr(ieee80211_hdr->addr1)) {
-			//TODO
+			/* TODO */
 		} else if (is_multicast_ether_addr(ieee80211_hdr->addr1)) {
-			//TODO
+			/* TODO */
 		} else {
 			/* unicast packet */
 			unicast_packet = true;
@@ -4998,9 +5053,9 @@ static void rtl8192_rx_nomal(struct sk_buff *skb)
 				ieee80211_hdr = (struct ieee80211_hdr_1addr *)skb->data;
 				unicast_packet = false;
 				if (is_broadcast_ether_addr(ieee80211_hdr->addr1)) {
-					//TODO
+					/* TODO */
 				} else if (is_multicast_ether_addr(ieee80211_hdr->addr1)) {
-					//TODO
+					/* TODO */
 				} else {
 					/* unicast packet */
 					unicast_packet = true;
@@ -5042,20 +5097,19 @@ static void rtl819xusb_process_received_packet(struct net_device *dev,
 	u16     frame_len = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	// Get shifted bytes of Starting address of 802.11 header. 2006.09.28, by Emily
-	//porting by amy 080508
+	/* Get shifted bytes of Starting address of 802.11 header. */
 	pstats->virtual_address += get_rxpacket_shiftbytes_819xusb(pstats);
 	frame = pstats->virtual_address;
 	frame_len = pstats->packetlength;
-#ifdef TODO	// by amy about HCT
+#ifdef TODO	/* about HCT */
 	if (!Adapter->bInHctTest)
 		CountRxErrStatistics(Adapter, pRfd);
 #endif
-#ifdef ENABLE_PS  //by amy for adding ps function in future
+#ifdef ENABLE_PS  /* for adding ps function in future */
 	RT_RF_POWER_STATE rtState;
-	// When RF is off, we should not count the packet for hw/sw synchronize
-	// reason, ie. there may be a duration while sw switch is changed and hw
-	// switch is being changed. 2006.12.04, by shien chang.
+	/* When RF is off, we should not count the packet for hw/sw synchronize
+	 * reason, ie. there may be a duration while sw switch is changed and hw
+	 * switch is being changed. 2006.12.04, by shien chang. */
 	Adapter->HalFunc.GetHwRegHandler(Adapter, HW_VAR_RF_STATE, (u8 *)(&rtState));
 	if (rtState == eRfOff)
 		return;
@@ -5082,9 +5136,9 @@ static void query_rx_cmdpkt_desc_status(struct sk_buff *skb,
 {
 	rx_desc_819x_usb *desc = (rx_desc_819x_usb *)skb->data;
 
-	//
-	//Get Rx Descriptor Information
-	//
+	/*
+	 *Get Rx Descriptor Information
+	 */
 	stats->virtual_address = (u8 *)skb->data;
 	stats->Length = desc->Length;
 	stats->RxDrvInfoSize = 0;
@@ -5111,12 +5165,12 @@ static void rtl8192_rx_cmd(struct sk_buff *skb)
 	if ((skb->len >= (20 + sizeof(rx_desc_819x_usb))) && (skb->len < RX_URB_SIZE)) {
 
 		query_rx_cmdpkt_desc_status(skb, &stats);
-		// this is to be done by amy 080508     prfd->queue_id = 1;
+		/* this is to be done by amy 080508     prfd->queue_id = 1; */
 
 
-		//
-		//  Process the command packet received.
-		//
+		/*
+		 *  Process the command packet received.
+		 */
 
 		rtl819xusb_process_received_packet(dev, &stats);
 
@@ -5199,7 +5253,7 @@ static int rtl8192_usb_probe(struct usb_interface *intf,
 
 	dev->type = ARPHRD_ETHER;
 
-	dev->watchdog_timeo = HZ*3;	//modified by john, 0805
+	dev->watchdog_timeo = HZ*3;
 
 	if (dev_alloc_name(dev, ifname) < 0) {
 		RT_TRACE(COMP_INIT, "Oops: devname already taken! Trying wlan%%d...\n");
@@ -5241,7 +5295,8 @@ fail:
 	return ret;
 }
 
-//detach all the work and timer structure declared or inititialize in r8192U_init function.
+/* detach all the work and timer structure declared or inititialize in
+ * r8192U_init function. */
 void rtl8192_cancel_deferred_work(struct r8192_priv *priv)
 {
 
@@ -5367,8 +5422,12 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 		SECR_value |= SCR_RxUseDK;
 		SECR_value |= SCR_TxUseDK;
 	}
-	//add HWSec active enable here.
-	//default using hwsec. when peer AP is in N mode only and pairwise_key_type is none_aes(which HT_IOT_ACT_PURE_N_MODE indicates it), use software security. when peer AP is in b,g,n mode mixed and pairwise_key_type is none_aes, use g mode hw security. WB on 2008.7.4
+	/* add HWSec active enable here.
+	 * default using hwsec. when peer AP is in N mode only and
+	 * pairwise_key_type is none_aes(which HT_IOT_ACT_PURE_N_MODE indicates
+	 * it), use software security. when peer AP is in b,g,n mode mixed and
+	 * pairwise_key_type is none_aes, use g mode hw security.
+	 */
 
 	ieee->hwsec_active = 1;
 
@@ -5419,7 +5478,7 @@ void setKey(struct net_device *dev, u8 EntryNo, u8 KeyIndex, u16 KeyType,
 			write_nic_dword(dev, WCAMI, TargetContent);
 			write_nic_dword(dev, RWCAM, TargetCommand);
 		} else {
-			//Key Material
+			/* Key Material */
 			if (KeyContent != NULL) {
 				write_nic_dword(dev, WCAMI, (u32)(*(KeyContent+i-2)));
 				write_nic_dword(dev, RWCAM, TargetCommand);
-- 
1.7.10.4

