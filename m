Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaHXJ6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 05:58:36 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:35926 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaHXJ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 05:58:33 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>, Ana Rey <anarey@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Chaitanya Hazarey <c@24.io>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8192u: Fix space required after that ',' errors
Date: Sun, 24 Aug 2014 04:57:36 -0500
Message-Id: <1408874256-10059-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl space required after that ',' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |  4 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |  2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  | 20 ++---
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c | 92 +++++++++++-----------
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |  8 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  | 12 +--
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |  4 +-
 drivers/staging/rtl8192u/r8192U_dm.c               | 24 +++---
 drivers/staging/rtl8192u/r819xU_firmware.c         |  6 +-
 9 files changed, 86 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index c118551..125c5ab 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -2118,7 +2118,7 @@ struct ieee80211_device {
 	 * This function can't sleep.
 	 */
 	void (*softmac_data_hard_start_xmit)(struct sk_buff *skb,
-			       struct net_device *dev,int rate);
+			       struct net_device *dev, int rate);
 
 	/* stops the HW queue for DATA frames. Useful to avoid
 	 * waste time to TX data frame when we are reassociating
@@ -2133,7 +2133,7 @@ struct ieee80211_device {
 	 * This function can sleep. the driver should ensure
 	 * the radio has been swithced before return.
 	 */
-	void (*set_chan)(struct net_device *dev,short ch);
+	void (*set_chan)(struct net_device *dev, short ch);
 
 	/* These are not used if the ieee stack takes care of
 	 * scanning (IEEE_SOFTMAC_SCAN feature set).
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
index 4b036a8..afbd09d 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -99,7 +99,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 {
 	struct ieee80211_device *ieee;
 	struct net_device *dev;
-	int i,err;
+	int i, err;
 
 	IEEE80211_DEBUG_INFO("Initializing...\n");
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 73410cc..40da37f 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -65,7 +65,7 @@ static inline void ieee80211_monitor_rx(struct ieee80211_device *ieee,
 /* Called only as a tasklet (software IRQ) */
 static struct ieee80211_frag_entry *
 ieee80211_frag_cache_find(struct ieee80211_device *ieee, unsigned int seq,
-			  unsigned int frag, u8 tid,u8 *src, u8 *dst)
+			  unsigned int frag, u8 tid, u8 *src, u8 *dst)
 {
 	struct ieee80211_frag_entry *entry;
 	int i;
@@ -188,7 +188,7 @@ static int ieee80211_frag_cache_invalidate(struct ieee80211_device *ieee,
 	  tid = 0;
 	}
 
-	entry = ieee80211_frag_cache_find(ieee, seq, -1, tid,hdr->addr2,
+	entry = ieee80211_frag_cache_find(ieee, seq, -1, tid, hdr->addr2,
 					  hdr->addr1);
 
 	if (entry == NULL) {
@@ -767,7 +767,7 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 
 static u8 parse_subframe(struct sk_buff *skb,
 			 struct ieee80211_rx_stats *rx_stats,
-			 struct ieee80211_rxb *rxb,u8 *src,u8 *dst)
+			 struct ieee80211_rxb *rxb, u8 *src, u8 *dst)
 {
 	struct ieee80211_hdr_3addr  *hdr = (struct ieee80211_hdr_3addr *)skb->data;
 	u16		fc = le16_to_cpu(hdr->frame_ctl);
@@ -830,7 +830,7 @@ static u8 parse_subframe(struct sk_buff *skb,
 
 			if(skb->len<(ETHERNET_HEADER_SIZE + nSubframe_Length)) {
 				printk("%s: A-MSDU parse error!! pRfd->nTotalSubframe : %d\n",\
-						__func__,rxb->nr_subframes);
+						__func__, rxb->nr_subframes);
 				printk("%s: A-MSDU parse error!! Subframe Length: %d\n",__func__, nSubframe_Length);
 				printk("nRemain_Length is %d and nSubframe_Length is : %d\n",skb->len,nSubframe_Length);
 				printk("The Packet SeqNum is %d\n",SeqNum);
@@ -849,14 +849,14 @@ static u8 parse_subframe(struct sk_buff *skb,
 			sub_skb = dev_alloc_skb(nSubframe_Length + 12);
 			skb_reserve(sub_skb, 12);
 			data_ptr = (u8 *)skb_put(sub_skb, nSubframe_Length);
-			memcpy(data_ptr,skb->data,nSubframe_Length);
+			memcpy(data_ptr, skb->data, nSubframe_Length);
 #endif
 			rxb->subframes[rxb->nr_subframes++] = sub_skb;
 			if(rxb->nr_subframes >= MAX_SUBFRAME_COUNT) {
 				IEEE80211_DEBUG_RX("ParseSubframe(): Too many Subframes! Packets dropped!\n");
 				break;
 			}
-			skb_pull(skb,nSubframe_Length);
+			skb_pull(skb, nSubframe_Length);
 
 			if(skb->len != 0) {
 				nPadding_Length = 4 - ((nSubframe_Length + ETHERNET_HEADER_SIZE) % 4);
@@ -868,7 +868,7 @@ static u8 parse_subframe(struct sk_buff *skb,
 					return 0;
 				}
 
-				skb_pull(skb,nPadding_Length);
+				skb_pull(skb, nPadding_Length);
 			}
 		}
 #ifdef JOHN_NOCPY
@@ -1297,7 +1297,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	}
 	/* to parse amsdu packets */
 	/* qos data packets & reserved bit is 1 */
-	if(parse_subframe(skb,rx_stats,rxb,src,dst) == 0) {
+	if (parse_subframe(skb, rx_stats, rxb, src, dst) == 0) {
 		/* only to free rxb, and not submit the packets to upper layer */
 		for(i =0; i < rxb->nr_subframes; i++) {
 			dev_kfree_skb(rxb->subframes[i]);
@@ -2384,11 +2384,11 @@ static inline void update_network(struct ieee80211_network *dst,
 	//added by amy for LEAP
 	dst->bWithAironetIE = src->bWithAironetIE;
 	dst->bCkipSupported = src->bCkipSupported;
-	memcpy(dst->CcxRmState,src->CcxRmState,2);
+	memcpy(dst->CcxRmState, src->CcxRmState, 2);
 	dst->bCcxRmEnable = src->bCcxRmEnable;
 	dst->MBssidMask = src->MBssidMask;
 	dst->bMBssidValid = src->bMBssidValid;
-	memcpy(dst->MBssid,src->MBssid,6);
+	memcpy(dst->MBssid, src->MBssid, 6);
 	dst->bWithCcxVerNum = src->bWithCcxVerNum;
 	dst->BssCcxVerNumber = src->BssCcxVerNumber;
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index c5a0a5d..0841239 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -228,7 +228,7 @@ inline void softmac_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *ieee
 	spin_lock_irqsave(&ieee->lock, flags);
 
 	/* called with 2nd param 0, no mgmt lock required */
-	ieee80211_sta_wakeup(ieee,0);
+	ieee80211_sta_wakeup(ieee, 0);
 
 	tcb_desc->queue_index = MGNT_QUEUE;
 	tcb_desc->data_rate = MgntQuery_MgntFrameTxRate(ieee);
@@ -238,7 +238,7 @@ inline void softmac_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *ieee
 
 	if(single){
 		if(ieee->queue_stop){
-			enqueue_mgmt(ieee,skb);
+			enqueue_mgmt(ieee, skb);
 		}else{
 			header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0]<<4);
 
@@ -277,7 +277,7 @@ inline void softmac_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *ieee
 			skb_queue_tail(&ieee->skb_waitQ[tcb_desc->queue_index], skb);
 		} else {
 			//printk("TX packet!\n");
-			ieee->softmac_hard_start_xmit(skb,ieee->dev);
+			ieee->softmac_hard_start_xmit(skb, ieee->dev);
 			//dev_kfree_skb_any(skb);//edit by thomas
 		}
 		spin_unlock_irqrestore(&ieee->mgmt_tx_lock, flags);
@@ -314,7 +314,7 @@ inline void softmac_ps_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *i
 		else
 			ieee->seq_ctrl[0]++;
 
-		ieee->softmac_hard_start_xmit(skb,ieee->dev);
+		ieee->softmac_hard_start_xmit(skb, ieee->dev);
 
 	}
 	//dev_kfree_skb_any(skb);//edit by thomas
@@ -322,7 +322,7 @@ inline void softmac_ps_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *i
 
 inline struct sk_buff *ieee80211_probe_req(struct ieee80211_device *ieee)
 {
-	unsigned int len,rate_len;
+	unsigned int len, rate_len;
 	u8 *tag;
 	struct sk_buff *skb;
 	struct ieee80211_probe_request *req;
@@ -542,19 +542,19 @@ static void ieee80211_beacons_start(struct ieee80211_device *ieee)
 	ieee->beacon_txing = 1;
 	ieee80211_send_beacon(ieee);
 
-	spin_unlock_irqrestore(&ieee->beacon_lock,flags);
+	spin_unlock_irqrestore(&ieee->beacon_lock, flags);
 }
 
 static void ieee80211_beacons_stop(struct ieee80211_device *ieee)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ieee->beacon_lock,flags);
+	spin_lock_irqsave(&ieee->beacon_lock, flags);
 
 	ieee->beacon_txing = 0;
 	del_timer_sync(&ieee->beacon_timer);
 
-	spin_unlock_irqrestore(&ieee->beacon_lock,flags);
+	spin_unlock_irqrestore(&ieee->beacon_lock, flags);
 
 }
 
@@ -571,7 +571,7 @@ EXPORT_SYMBOL(ieee80211_stop_send_beacons);
 void ieee80211_start_send_beacons(struct ieee80211_device *ieee)
 {
 	if(ieee->start_send_beacons)
-		ieee->start_send_beacons(ieee->dev,ieee->basic_rate);
+		ieee->start_send_beacons(ieee->dev, ieee->basic_rate);
 	if(ieee->softmac_features & IEEE_SOFTMAC_BEACONS)
 		ieee80211_beacons_start(ieee);
 }
@@ -693,7 +693,7 @@ static struct sk_buff *ieee80211_probe_resp(struct ieee80211_device *ieee, u8 *d
 	struct ieee80211_probe_response *beacon_buf;
 	struct sk_buff *skb = NULL;
 	int encrypt;
-	int atim_len,erp_len;
+	int atim_len, erp_len;
 	struct ieee80211_crypt_data *crypt;
 
 	char *ssid = ieee->current_network.ssid;
@@ -795,7 +795,7 @@ static struct sk_buff *ieee80211_probe_resp(struct ieee80211_device *ieee, u8 *d
 
 	*(tag++) = MFIE_TYPE_RATES;
 	*(tag++) = rate_len-2;
-	memcpy(tag,ieee->current_network.rates,rate_len-2);
+	memcpy(tag, ieee->current_network.rates, rate_len-2);
 	tag+=rate_len-2;
 
 	*(tag++) = MFIE_TYPE_DS_SET;
@@ -820,7 +820,7 @@ static struct sk_buff *ieee80211_probe_resp(struct ieee80211_device *ieee, u8 *d
 	if(rate_ex_len){
 		*(tag++) = MFIE_TYPE_RATES_EX;
 		*(tag++) = rate_ex_len-2;
-		memcpy(tag,ieee->current_network.rates_ex,rate_ex_len-2);
+		memcpy(tag, ieee->current_network.rates_ex, rate_ex_len-2);
 		tag+=rate_ex_len-2;
 	}
 
@@ -860,7 +860,7 @@ static struct sk_buff *ieee80211_assoc_resp(struct ieee80211_device *ieee,
 	skb_reserve(skb, ieee->tx_headroom);
 
 	assoc = (struct ieee80211_assoc_response_frame *)
-		skb_put(skb,sizeof(struct ieee80211_assoc_response_frame));
+		skb_put(skb, sizeof(struct ieee80211_assoc_response_frame));
 
 	assoc->header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP);
 	memcpy(assoc->header.addr1, dest,ETH_ALEN);
@@ -1123,7 +1123,7 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 		u8	CcxAironetBuf[30];
 		OCTET_STRING	osCcxAironetIE;
 
-		memset(CcxAironetBuf, 0,30);
+		memset(CcxAironetBuf, 0, 30);
 		osCcxAironetIE.Octet = CcxAironetBuf;
 		osCcxAironetIE.Length = sizeof(CcxAironetBuf);
 		//
@@ -1139,7 +1139,7 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 		tag = skb_put(skb, ckip_ie_len);
 		*tag++ = MFIE_TYPE_AIRONET;
 		*tag++ = osCcxAironetIE.Length;
-		memcpy(tag,osCcxAironetIE.Octet,osCcxAironetIE.Length);
+		memcpy(tag, osCcxAironetIE.Octet, osCcxAironetIE.Length);
 		tag += osCcxAironetIE.Length;
 	}
 
@@ -1150,10 +1150,10 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 
 		osCcxRmCap.Octet = CcxRmCapBuf;
 		osCcxRmCap.Length = sizeof(CcxRmCapBuf);
-		tag = skb_put(skb,ccxrm_ie_len);
+		tag = skb_put(skb, ccxrm_ie_len);
 		*tag++ = MFIE_TYPE_GENERIC;
 		*tag++ = osCcxRmCap.Length;
-		memcpy(tag,osCcxRmCap.Octet,osCcxRmCap.Length);
+		memcpy(tag, osCcxRmCap.Octet, osCcxRmCap.Length);
 		tag += osCcxRmCap.Length;
 	}
 
@@ -1164,10 +1164,10 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 		CcxVerNumBuf[4] = beacon->BssCcxVerNumber;
 		osCcxVerNum.Octet = CcxVerNumBuf;
 		osCcxVerNum.Length = sizeof(CcxVerNumBuf);
-		tag = skb_put(skb,cxvernum_ie_len);
+		tag = skb_put(skb, cxvernum_ie_len);
 		*tag++ = MFIE_TYPE_GENERIC;
 		*tag++ = osCcxVerNum.Length;
-		memcpy(tag,osCcxVerNum.Octet,osCcxVerNum.Length);
+		memcpy(tag, osCcxVerNum.Octet, osCcxVerNum.Length);
 		tag += osCcxVerNum.Length;
 	}
 	//HT cap element
@@ -1189,12 +1189,12 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 		memcpy(tag, ieee->wpa_ie, ieee->wpa_ie_len);
 	}
 
-	tag = skb_put(skb,wmm_info_len);
+	tag = skb_put(skb, wmm_info_len);
 	if(wmm_info_len) {
 	  ieee80211_WMM_Info(ieee, &tag);
 	}
 #ifdef THOMAS_TURBO
-	tag = skb_put(skb,turbo_info_len);
+	tag = skb_put(skb, turbo_info_len);
 	if(turbo_info_len) {
 		ieee80211_TURBO_Info(ieee, &tag);
 	}
@@ -1206,7 +1206,7 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 			tag = skb_put(skb, ht_cap_len);
 			*tag++ = MFIE_TYPE_GENERIC;
 			*tag++ = ht_cap_len - 2;
-			memcpy(tag, ht_cap_buf,ht_cap_len - 2);
+			memcpy(tag, ht_cap_buf, ht_cap_len - 2);
 			tag += ht_cap_len -2;
 		}
 
@@ -1418,7 +1418,7 @@ inline void ieee80211_softmac_new_net(struct ieee80211_device *ieee, struct ieee
 	u8 tmp_ssid[IW_ESSID_MAX_SIZE+1];
 	int tmp_ssid_len = 0;
 
-	short apset,ssidset,ssidbroad,apmatch,ssidmatch;
+	short apset, ssidset, ssidbroad, apmatch, ssidmatch;
 
 	/* we are interested in new new only if we are not associated
 	 * and we are not associating / authenticating
@@ -1778,10 +1778,10 @@ static short ieee80211_sta_ps_sleep(struct ieee80211_device *ieee, u32 *time_h,
 static inline void ieee80211_sta_ps(struct ieee80211_device *ieee)
 {
 
-	u32 th,tl;
+	u32 th, tl;
 	short sleep;
 
-	unsigned long flags,flags2;
+	unsigned long flags, flags2;
 
 	spin_lock_irqsave(&ieee->lock, flags);
 
@@ -1805,7 +1805,7 @@ static inline void ieee80211_sta_ps(struct ieee80211_device *ieee)
 	if(sleep == 1){
 
 		if(ieee->sta_sleep == 1)
-			ieee->enter_sleep_state(ieee->dev,th,tl);
+			ieee->enter_sleep_state(ieee->dev, th, tl);
 
 		else if(ieee->sta_sleep == 0){
 		//	printk("send null 1\n");
@@ -1818,7 +1818,7 @@ static inline void ieee80211_sta_ps(struct ieee80211_device *ieee)
 
 				ieee->ps_request_tx_ack(ieee->dev);
 
-				ieee80211_sta_ps_send_null_frame(ieee,1);
+				ieee80211_sta_ps_send_null_frame(ieee, 1);
 
 				ieee->ps_th = th;
 				ieee->ps_tl = tl;
@@ -1832,7 +1832,7 @@ static inline void ieee80211_sta_ps(struct ieee80211_device *ieee)
 //#warning CHECK_LOCK_HERE
 		spin_lock_irqsave(&ieee->mgmt_tx_lock, flags2);
 
-		ieee80211_sta_wakeup(ieee,1);
+		ieee80211_sta_wakeup(ieee, 1);
 
 		spin_unlock_irqrestore(&ieee->mgmt_tx_lock, flags2);
 	}
@@ -1867,7 +1867,7 @@ void ieee80211_sta_wakeup(struct ieee80211_device *ieee, short nl)
 
 void ieee80211_ps_tx_ack(struct ieee80211_device *ieee, short success)
 {
-	unsigned long flags,flags2;
+	unsigned long flags, flags2;
 
 	spin_lock_irqsave(&ieee->lock, flags);
 
@@ -2109,7 +2109,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 		}
 		break;
 	case IEEE80211_STYPE_MANAGE_ACT:
-		ieee80211_process_action(ieee,skb);
+		ieee80211_process_action(ieee, skb);
 		break;
 	default:
 		return -1;
@@ -2146,10 +2146,10 @@ void ieee80211_softmac_xmit(struct ieee80211_txb *txb, struct ieee80211_device *
 	int  i;
 	cb_desc *tcb_desc = NULL;
 
-	spin_lock_irqsave(&ieee->lock,flags);
+	spin_lock_irqsave(&ieee->lock, flags);
 
 	/* called with 2nd parm 0, no tx mgmt lock required */
-	ieee80211_sta_wakeup(ieee,0);
+	ieee80211_sta_wakeup(ieee, 0);
 
 	/* update the tx status */
 	ieee->stats.tx_bytes += txb->payload_size;
@@ -2181,7 +2181,7 @@ void ieee80211_softmac_xmit(struct ieee80211_txb *txb, struct ieee80211_device *
 		}else{
 			ieee->softmac_data_hard_start_xmit(
 					txb->fragments[i],
-					ieee->dev,ieee->rate);
+					ieee->dev, ieee->rate);
 			//ieee->stats.tx_packets++;
 			//ieee->stats.tx_bytes += txb->fragments[i]->len;
 			//ieee->dev->trans_start = jiffies;
@@ -2190,7 +2190,7 @@ void ieee80211_softmac_xmit(struct ieee80211_txb *txb, struct ieee80211_device *
 	ieee80211_txb_free(txb);
 
 //exit:
-	spin_unlock_irqrestore(&ieee->lock,flags);
+	spin_unlock_irqrestore(&ieee->lock, flags);
 
 }
 EXPORT_SYMBOL(ieee80211_softmac_xmit);
@@ -2208,7 +2208,7 @@ static void ieee80211_resume_tx(struct ieee80211_device *ieee)
 
 			ieee->softmac_data_hard_start_xmit(
 				ieee->tx_pending.txb->fragments[i],
-				ieee->dev,ieee->rate);
+				ieee->dev, ieee->rate);
 				//(i+1)<ieee->tx_pending.txb->nr_frags);
 			ieee->stats.tx_packets++;
 			ieee->dev->trans_start = jiffies;
@@ -2225,14 +2225,14 @@ void ieee80211_reset_queue(struct ieee80211_device *ieee)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ieee->lock,flags);
+	spin_lock_irqsave(&ieee->lock, flags);
 	init_mgmt_queue(ieee);
 	if (ieee->tx_pending.txb){
 		ieee80211_txb_free(ieee->tx_pending.txb);
 		ieee->tx_pending.txb = NULL;
 	}
 	ieee->queue_stop = 0;
-	spin_unlock_irqrestore(&ieee->lock,flags);
+	spin_unlock_irqrestore(&ieee->lock, flags);
 
 }
 EXPORT_SYMBOL(ieee80211_reset_queue);
@@ -2244,7 +2244,7 @@ void ieee80211_wake_queue(struct ieee80211_device *ieee)
 	struct sk_buff *skb;
 	struct ieee80211_hdr_3addr  *header;
 
-	spin_lock_irqsave(&ieee->lock,flags);
+	spin_lock_irqsave(&ieee->lock, flags);
 	if (! ieee->queue_stop) goto exit;
 
 	ieee->queue_stop = 0;
@@ -2274,7 +2274,7 @@ void ieee80211_wake_queue(struct ieee80211_device *ieee)
 	}
 
 exit :
-	spin_unlock_irqrestore(&ieee->lock,flags);
+	spin_unlock_irqrestore(&ieee->lock, flags);
 }
 EXPORT_SYMBOL(ieee80211_wake_queue);
 
@@ -2355,7 +2355,7 @@ static void ieee80211_start_ibss_wq(struct work_struct *work)
 	down(&ieee->wx_sem);
 
 	if (ieee->current_network.ssid_len == 0){
-		strcpy(ieee->current_network.ssid,IEEE80211_DEFAULT_TX_ESSID);
+		strcpy(ieee->current_network.ssid, IEEE80211_DEFAULT_TX_ESSID);
 		ieee->current_network.ssid_len = strlen(IEEE80211_DEFAULT_TX_ESSID);
 		ieee->ssid_set = 1;
 	}
@@ -2554,7 +2554,7 @@ exit:
 
 struct sk_buff *ieee80211_get_beacon_(struct ieee80211_device *ieee)
 {
-	u8 broadcast_addr[] = {0xff,0xff,0xff,0xff,0xff,0xff};
+	u8 broadcast_addr[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 	struct sk_buff *skb;
 	struct ieee80211_probe_response *b;
@@ -2735,12 +2735,12 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
 
 	ieee->wq = create_workqueue(DRV_NAME);
 
-	INIT_DELAYED_WORK(&ieee->start_ibss_wq,ieee80211_start_ibss_wq);
+	INIT_DELAYED_WORK(&ieee->start_ibss_wq, ieee80211_start_ibss_wq);
 	INIT_WORK(&ieee->associate_complete_wq, ieee80211_associate_complete_wq);
 	INIT_WORK(&ieee->associate_procedure_wq, ieee80211_associate_procedure_wq);
-	INIT_DELAYED_WORK(&ieee->softmac_scan_wq,ieee80211_softmac_scan_wq);
+	INIT_DELAYED_WORK(&ieee->softmac_scan_wq, ieee80211_softmac_scan_wq);
 	INIT_DELAYED_WORK(&ieee->associate_retry_wq, ieee80211_associate_retry_wq);
-	INIT_WORK(&ieee->wx_sync_scan_wq,ieee80211_wx_sync_scan_wq);
+	INIT_WORK(&ieee->wx_sync_scan_wq, ieee80211_wx_sync_scan_wq);
 
 
 	sema_init(&ieee->wx_sem, 1);
@@ -2939,10 +2939,10 @@ static int ieee80211_wpa_set_param(struct ieee80211_device *ieee, u8 name, u32 v
 		break;
 	case IEEE_PARAM_WPAX_SELECT:
 		// added for WPA2 mixed mode
-		spin_lock_irqsave(&ieee->wpax_suitlist_lock,flags);
+		spin_lock_irqsave(&ieee->wpax_suitlist_lock, flags);
 		ieee->wpax_type_set = 1;
 		ieee->wpax_type_notify = value;
-		spin_unlock_irqrestore(&ieee->wpax_suitlist_lock,flags);
+		spin_unlock_irqrestore(&ieee->wpax_suitlist_lock, flags);
 		break;
 
 	default:
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index 935a8f4..82ea533 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -181,7 +181,7 @@ EXPORT_SYMBOL(ieee80211_wx_set_wap);
 
  int ieee80211_wx_get_essid(struct ieee80211_device *ieee, struct iw_request_info *a,union iwreq_data *wrqu,char *b)
 {
-	int len,ret = 0;
+	int len, ret = 0;
 	unsigned long flags;
 
 	if (ieee->iw_mode == IW_MODE_MONITOR)
@@ -204,7 +204,7 @@ EXPORT_SYMBOL(ieee80211_wx_set_wap);
 	}
 	len = ieee->current_network.ssid_len;
 	wrqu->essid.length = len;
-	strncpy(b,ieee->current_network.ssid,len);
+	strncpy(b, ieee->current_network.ssid, len);
 	wrqu->essid.flags = 1;
 
 out:
@@ -319,7 +319,7 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 
 	ieee->state = IEEE80211_LINKED_SCANNING;
 	ieee->link_change(ieee->dev);
-	ieee->InitialGainHandler(ieee->dev,IG_Backup);
+	ieee->InitialGainHandler(ieee->dev, IG_Backup);
 	if (ieee->pHTInfo->bCurrentHTSupport && ieee->pHTInfo->bEnableHT && ieee->pHTInfo->bCurBW40MHz) {
 		b40M = 1;
 		chan_offset = ieee->pHTInfo->CurSTAExtChnlOffset;
@@ -341,7 +341,7 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 		ieee->set_chan(ieee->dev, chan);
 	}
 
-	ieee->InitialGainHandler(ieee->dev,IG_Restore);
+	ieee->InitialGainHandler(ieee->dev, IG_Restore);
 	ieee->state = IEEE80211_LINKED;
 	ieee->link_change(ieee->dev);
 	// To prevent the immediately calling watch_dog after scan.
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
index 698507e..68f5ede 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -40,12 +40,12 @@ struct modes_unit {
 	int mode_size;
 };
 static struct modes_unit ieee80211_modes[] = {
-	{"a",1},
-	{"b",1},
-	{"g",1},
-	{"?",1},
-	{"N-24G",5},
-	{"N-5G",4},
+	{"a", 1},
+	{"b", 1},
+	{"g", 1},
+	{"?", 1},
+	{"N-24G", 5},
+	{"N-5G", 4},
 };
 
 #define iwe_stream_add_event_rsl iwe_stream_add_event
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
index b8cc6a5..cb66bb9 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
@@ -165,7 +165,7 @@ static struct sk_buff *ieee80211_ADDBA(struct ieee80211_device *ieee, u8 *Dst, P
 	if (ACT_ADDBAREQ == type)
 	{
 	// BA Start SeqCtrl
-		memcpy(tag,(u8 *)&(pBA->BaStartSeqCtrl), 2);
+		memcpy(tag, (u8 *)&(pBA->BaStartSeqCtrl), 2);
 		tag += 2;
 	}
 
@@ -564,7 +564,7 @@ OnADDBARsp_Reject:
  *  return:  0(pass), other(fail)
  *  notice:  As this function need support of QOS, I comment some code out. And when qos is ready, this code need to be support.
 ********************************************************************************************************************/
-int ieee80211_rx_DELBA(struct ieee80211_device *ieee,struct sk_buff *skb)
+int ieee80211_rx_DELBA(struct ieee80211_device *ieee, struct sk_buff *skb)
 {
 	 struct ieee80211_hdr_3addr *delba = NULL;
 	PDELBA_PARAM_SET	pDelBaParamSet = NULL;
diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index b4264e1..b0b66fba 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -1474,40 +1474,40 @@ static void dm_CCKTxPowerAdjust_TSSI(struct net_device *dev, bool  bInCH14)
 		TempVal =	priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[0] +
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[1]<<8) ;
 
-		rtl8192_setBBreg(dev, rCCK0_TxFilter1,bMaskHWord, TempVal);
+		rtl8192_setBBreg(dev, rCCK0_TxFilter1, bMaskHWord, TempVal);
 		//Write 0xa24 ~ 0xa27
 		TempVal = 0;
 		TempVal =	priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[2] +
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[3]<<8) +
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[4]<<16)+
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[5]<<24);
-		rtl8192_setBBreg(dev, rCCK0_TxFilter2,bMaskDWord, TempVal);
+		rtl8192_setBBreg(dev, rCCK0_TxFilter2, bMaskDWord, TempVal);
 		//Write 0xa28  0xa29
 		TempVal = 0;
 		TempVal =	priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[6] +
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[7]<<8) ;
 
-		rtl8192_setBBreg(dev, rCCK0_DebugPort,bMaskLWord, TempVal);
+		rtl8192_setBBreg(dev, rCCK0_DebugPort, bMaskLWord, TempVal);
 	}
 	else
 	{
 		TempVal =	priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[0] +
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[1]<<8) ;
 
-		rtl8192_setBBreg(dev, rCCK0_TxFilter1,bMaskHWord, TempVal);
+		rtl8192_setBBreg(dev, rCCK0_TxFilter1, bMaskHWord, TempVal);
 		//Write 0xa24 ~ 0xa27
 		TempVal = 0;
 		TempVal =	priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[2] +
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[3]<<8) +
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[4]<<16)+
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[5]<<24);
-		rtl8192_setBBreg(dev, rCCK0_TxFilter2,bMaskDWord, TempVal);
+		rtl8192_setBBreg(dev, rCCK0_TxFilter2, bMaskDWord, TempVal);
 		//Write 0xa28  0xa29
 		TempVal = 0;
 		TempVal =	priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[6] +
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[7]<<8) ;
 
-		rtl8192_setBBreg(dev, rCCK0_DebugPort,bMaskLWord, TempVal);
+		rtl8192_setBBreg(dev, rCCK0_DebugPort, bMaskLWord, TempVal);
 	}
 
 
@@ -1570,7 +1570,7 @@ static void dm_CCKTxPowerAdjust_ThermalMeter(struct net_device *dev,	bool  bInCH
 					(CCKSwingTable_Ch14[priv->CCK_index][7]<<8) ;
 
 		rtl8192_setBBreg(dev, rCCK0_DebugPort, bMaskLWord, TempVal);
-		RT_TRACE(COMP_POWER_TRACKING,"CCK chnl 14, reg 0x%x = 0x%x\n",
+		RT_TRACE(COMP_POWER_TRACKING, "CCK chnl 14, reg 0x%x = 0x%x\n",
 			rCCK0_DebugPort, TempVal);
 	}
 }
@@ -1601,7 +1601,7 @@ static void dm_txpower_reset_recovery(
 	RT_TRACE(COMP_POWER_TRACKING, "Reset Recovery: Fill in RFA_txPowerTrackingIndex is %x\n",priv->rfa_txpowertrackingindex);
 	RT_TRACE(COMP_POWER_TRACKING, "Reset Recovery : RF A I/Q Amplify Gain is %ld\n",priv->txbbgain_table[priv->rfa_txpowertrackingindex].txbb_iq_amplifygain);
 	RT_TRACE(COMP_POWER_TRACKING, "Reset Recovery: CCK Attenuation is %d dB\n",priv->cck_present_attentuation);
-	dm_cck_txpower_adjust(dev,priv->bcck_in_ch14);
+	dm_cck_txpower_adjust(dev, priv->bcck_in_ch14);
 
 	rtl8192_setBBreg(dev, rOFDM0_XCTxIQImbalance, bMaskDWord, priv->txbbgain_table[priv->rfc_txpowertrackingindex].txbbgain_value);
 	RT_TRACE(COMP_POWER_TRACKING, "Reset Recovery: Fill in 0xc90 is %08x\n",priv->txbbgain_table[priv->rfc_txpowertrackingindex].txbbgain_value);
@@ -2431,7 +2431,7 @@ static	void dm_cs_ratio(
 	struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	static u8				initialized,force_write;
+	static u8				initialized, force_write;
 	static u32			reset_cnt;
 
 	if(dm_digtable.dig_algorithm_switch)
@@ -3134,7 +3134,7 @@ void dm_fsync_timer_callback(unsigned long data)
 			priv->bswitch_fsync = !priv->bswitch_fsync;
 			if(priv->bswitch_fsync)
 			{
-				write_nic_byte(dev,0xC36, 0x1c);
+				write_nic_byte(dev, 0xC36, 0x1c);
 				write_nic_byte(dev, 0xC3e, 0x90);
 			}
 			else
@@ -3216,7 +3216,7 @@ static void dm_StartSWFsync(struct net_device *dev)
 	u32			rateIndex;
 	u32			rateBitmap;
 
-	RT_TRACE(COMP_HALDM,"%s\n", __func__);
+	RT_TRACE(COMP_HALDM, "%s\n", __func__);
 	// Initial rate record to zero, start to record.
 	priv->rate_record = 0;
 	// Initialize continue diff count to zero, start to record.
@@ -3251,7 +3251,7 @@ static void dm_StartSWFsync(struct net_device *dev)
 
 static void dm_EndHWFsync(struct net_device *dev)
 {
-	RT_TRACE(COMP_HALDM,"%s\n", __func__);
+	RT_TRACE(COMP_HALDM, "%s\n", __func__);
 	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c52cd);
 	write_nic_byte(dev, 0xc3b, 0x49);
 
diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index 04b8f5e..671cbe6 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -93,7 +93,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 			RT_TRACE(COMP_FIRMWARE,"=====================================================> tx full!\n");
 			skb_queue_tail(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index], skb);
 		} else {
-			priv->ieee80211->softmac_hard_start_xmit(skb,dev);
+			priv->ieee80211->softmac_hard_start_xmit(skb, dev);
 		}
 
 		code_virtual_address += frag_length;
@@ -257,7 +257,7 @@ bool init_firmware(struct net_device *dev)
 				mapped_file = pfirmware->firmware_buf;
 				file_length = fw_entry->size;
 			} else {
-				memset(pfirmware->firmware_buf,0,128);
+				memset(pfirmware->firmware_buf, 0, 128);
 				memcpy(&pfirmware->firmware_buf[128],fw_entry->data,fw_entry->size);
 				mapped_file = pfirmware->firmware_buf;
 				file_length = fw_entry->size + 128;
@@ -276,7 +276,7 @@ bool init_firmware(struct net_device *dev)
 		 * 3. each skb_buff packet data content will already include the firmware info
 		 *   and Tx descriptor info
 		 * */
-		rt_status = fw_download_code(dev,mapped_file,file_length);
+		rt_status = fw_download_code(dev, mapped_file, file_length);
 		if (rst_opt == OPT_SYSTEM_RESET)
 			release_firmware(fw_entry);
 
-- 
1.9.1

