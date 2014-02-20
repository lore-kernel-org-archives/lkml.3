Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaBTIFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:05:41 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:62296 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaBTIFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:05:39 -0500
From: axel.rasmussen1@gmail.com
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8187se: fix checkpatch.pl issues
Date: Thu, 20 Feb 2014 01:05:31 -0700
Message-ID: <3159008.9WafSrHc87@celine>
User-Agent: KMail/4.11.5 (Linux/3.12.9-gentoo; KDE/4.12.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Rasmussen <axel.rasmussen1@gmail.com>
Date: Mon, 17 Feb 2014 23:50:05 -0700
Subject: [PATCH] staging: rtl8187se: fix checkpatch.pl issues

Reformatted many lines which were too long, replaced various printk
calls with appropriate netdev_* calls, and fixed some spelling errors.

Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c | 551 +++++++++++++++++++++------------
 1 file changed, 350 insertions(+), 201 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 6cafee2..dc1d647 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -258,7 +258,8 @@ static int proc_get_stats_tx(struct seq_file *m, void *v)
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	unsigned long totalOK;
 
-	totalOK = priv->stats.txnpokint+priv->stats.txhpokint+priv->stats.txlpokint;
+	totalOK = priv->stats.txnpokint + priv->stats.txhpokint +
+			priv->stats.txlpokint;
 	seq_printf(m,
 		"TX OK: %lu\n"
 		"TX Error: %lu\n"
@@ -470,7 +471,8 @@ static short check_nic_enought_desc(struct net_device *dev, int priority)
 	struct ieee80211_device *ieee = netdev_priv(dev);
 	int requiredbyte, required;
 
-	requiredbyte = priv->ieee80211->fts + sizeof(struct ieee80211_header_data);
+	requiredbyte = priv->ieee80211->fts +
+			sizeof(struct ieee80211_header_data);
 
 	if (ieee->current_network.QoS_Enable)
 		requiredbyte += 2;
@@ -484,7 +486,7 @@ static short check_nic_enought_desc(struct net_device *dev, int priority)
 	 * between the tail and the head
 	 */
 
-	return (required+2 < get_curr_tx_free_desc(dev, priority));
+	return required+2 < get_curr_tx_free_desc(dev, priority);
 }
 
 void fix_tx_fifo(struct net_device *dev)
@@ -649,7 +651,7 @@ void rtl8180_set_chan(struct net_device *dev, short ch)
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
 	if ((ch > 14) || (ch < 1)) {
-		printk("In %s: Invalid chnanel %d\n", __func__, ch);
+		netdev_err(dev, "In %s: Invalid channel %d\n", __func__, ch);
 		return;
 	}
 
@@ -742,43 +744,50 @@ static short alloc_tx_desc_ring(struct net_device *dev, int bufsize, int count,
 
 		switch (addr) {
 		case TX_MANAGEPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txmapbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txmapbufs),
+					buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer NP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_BKPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txbkpbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txbkpbufs),
+					buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer LP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_BEPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txbepbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txbepbufs),
+					buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer NP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_VIPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txvipbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txvipbufs),
+					buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer LP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_VOPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txvopbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txvopbufs),
+					buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer NP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_HIGHPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txhpbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txhpbufs),
+					buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer HP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_BEACON_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txbeaconbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txbeaconbufs),
+					buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer BP");
 				return -ENOMEM;
 			}
@@ -897,8 +906,8 @@ static short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 		return -1;
 	}
 
-	desc = (u32 *)pci_alloc_consistent(pdev, sizeof(u32)*rx_desc_size*count+256,
-					  &dma_desc);
+	desc = (u32 *)pci_alloc_consistent(pdev, sizeof(u32) *
+			rx_desc_size*count+256, &dma_desc);
 
 	if (dma_desc & 0xff)
 		/*
@@ -935,7 +944,8 @@ static short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 		tmp = tmp+rx_desc_size;
 	}
 
-	*(tmp-rx_desc_size) = *(tmp-rx_desc_size) | (1<<30); /* this is the last descriptor */
+	/* this is the last descriptor */
+	*(tmp-rx_desc_size) = *(tmp-rx_desc_size) | (1<<30);
 
 	return 0;
 }
@@ -1009,7 +1019,8 @@ inline u16 ieeerate2rtlrate(int rate)
 	}
 }
 
-static u16 rtl_rate[] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540, 720};
+static u16 rtl_rate[] = {10, 20, 55, 110, 60, 90, 120,
+		180, 240, 360, 480, 540, 720};
 
 inline u16 rtl8180_rate2rate(short rate)
 {
@@ -1149,17 +1160,24 @@ static long TranslateToDbm8185(u8 SignalStrengthIndex)
 static void PerformUndecoratedSignalSmoothing8185(struct r8180_priv *priv,
 						  bool bCckRate)
 {
-	/* Determin the current packet is CCK rate. */
+	long smoothedSS;
+	long smoothedRx;
+
+	/* Determine the current packet is CCK rate. */
 	priv->bCurCCKPkt = bCckRate;
 
+	smoothedSS = priv->SignalStrength * 10;
+
 	if (priv->UndecoratedSmoothedSS >= 0)
-		priv->UndecoratedSmoothedSS = ((priv->UndecoratedSmoothedSS * 5) +
-					       (priv->SignalStrength * 10)) / 6;
-	else
-		priv->UndecoratedSmoothedSS = priv->SignalStrength * 10;
+		smoothedSS = ((priv->UndecoratedSmoothedSS * 5) +
+				smoothedSS) / 6;
+
+	priv->UndecoratedSmoothedSS = smoothedSS;
+
+	smoothedRx = ((priv->UndercorateSmoothedRxPower * 50) +
+			(priv->RxPower * 11)) / 60;
 
-	priv->UndercorateSmoothedRxPower = ((priv->UndercorateSmoothedRxPower * 50) +
-					    (priv->RxPower * 11)) / 60;
+	priv->UndercorateSmoothedRxPower = smoothedRx;
 
 	if (bCckRate)
 		priv->CurCCKRSSI = priv->RSSI;
@@ -1216,7 +1234,9 @@ static void rtl8180_rx(struct net_device *dev)
 		tmp = priv->rxringtail;
 		do {
 			if (tmp == priv->rxring)
-				tmp  = priv->rxring + (priv->rxringcount - 1)*rx_desc_size;
+				tmp  = priv->rxring +
+						(priv->rxringcount - 1) *
+						rx_desc_size;
 			else
 				tmp -= rx_desc_size;
 
@@ -1237,7 +1257,10 @@ static void rtl8180_rx(struct net_device *dev)
 
 		if (*(priv->rxringtail) & (1<<27)) {
 			priv->stats.rxdmafail++;
-			/* DMESG("EE: RX DMA FAILED at buffer pointed by descriptor %x",(u32)priv->rxringtail); */
+			/*
+			DMESG("EE: RX DMA FAILED at buffer pointed by descriptor %x",
+					(u32)priv->rxringtail);
+			*/
 			goto drop;
 		}
 
@@ -1303,21 +1326,25 @@ static void rtl8180_rx(struct net_device *dev)
 			priv->rx_skb_complete = 1;
 		}
 
-		signal = (unsigned char)(((*(priv->rxringtail+3)) & (0x00ff0000))>>16);
+		signal = (unsigned char)(((*(priv->rxringtail+3)) &
+				(0x00ff0000))>>16);
 		signal = (signal & 0xfe) >> 1;
 
 		quality = (unsigned char)((*(priv->rxringtail+3)) & (0xff));
 
 		stats.mac_time[0] = *(priv->rxringtail+1);
 		stats.mac_time[1] = *(priv->rxringtail+2);
-		rxpower = ((char)(((*(priv->rxringtail+4)) & (0x00ff0000))>>16))/2 - 42;
-		RSSI = ((u8)(((*(priv->rxringtail+3)) & (0x0000ff00))>>8)) & (0x7f);
+		rxpower = ((char)(((*(priv->rxringtail+4)) &
+				(0x00ff0000))>>16))/2 - 42;
+		RSSI = ((u8)(((*(priv->rxringtail+3)) &
+				(0x0000ff00))>>8)) & (0x7f);
 
 		rate = ((*(priv->rxringtail)) &
 			((1<<23)|(1<<22)|(1<<21)|(1<<20)))>>20;
 
 		stats.rate = rtl8180_rate2rate(rate);
-		Antenna = (((*(priv->rxringtail+3)) & (0x00008000)) == 0) ? 0 : 1;
+		Antenna = (((*(priv->rxringtail+3)) &
+				(0x00008000)) == 0) ? 0 : 1;
 		if (!rtl8180_IsWirelessBMode(stats.rate)) { /* OFDM rate. */
 			RxAGC_dBm = rxpower+1;	/* bias */
 		} else { /* CCK rate. */
@@ -1326,7 +1353,8 @@ static void rtl8180_rx(struct net_device *dev)
 			LNA = (u8) (RxAGC_dBm & 0x60) >> 5; /* bit 6~ bit 5 */
 			BB  = (u8) (RxAGC_dBm & 0x1F); /* bit 4 ~ bit 0 */
 
-			RxAGC_dBm = -(LNA_gain[LNA] + (BB*2)); /* Pin_11b=-(LNA_gain+BB_gain) (dBm) */
+			/* Pin_11b=-(LNA_gain+BB_gain) (dBm) */
+			RxAGC_dBm = -(LNA_gain[LNA] + (BB*2));
 
 			RxAGC_dBm += 4; /* bias */
 		}
@@ -1354,21 +1382,25 @@ static void rtl8180_rx(struct net_device *dev)
 		priv->RSSI = RSSI;
 		/* SQ translation formula is provided by SD3 DZ. 2006.06.27 */
 		if (quality >= 127)
-			quality = 1; /*0; */ /* 0 will cause epc to show signal zero , walk around now; */
+			/* 0 will cause epc to show signal
+			 * zero, walk around now; */
+			quality = 1; /*0;*/
 		else if (quality < 27)
 			quality = 100;
 		else
 			quality = 127 - quality;
 		priv->SignalQuality = quality;
 
-		stats.signal = (u8)quality; /*priv->wstats.qual.level = priv->SignalStrength; */
+		stats.signal = (u8)quality; /*priv->wstats.qual.level =
+						priv->SignalStrength; */
 		stats.signalstrength = RXAGC;
 		if (stats.signalstrength > 100)
 			stats.signalstrength = 100;
 		stats.signalstrength = (stats.signalstrength * 70)/100 + 30;
 		/* printk("==========================>rx : RXAGC is %d,signalstrength is %d\n",RXAGC,stats.signalstrength); */
 		stats.rssi = priv->wstats.qual.qual = priv->SignalQuality;
-		stats.noise = priv->wstats.qual.noise = 100 - priv->wstats.qual.qual;
+		stats.noise = priv->wstats.qual.noise =
+				100 - priv->wstats.qual.qual;
 		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) |
 			   (((*(priv->rxringtail)) & (0x04000000)) != 0) |
 			   (((*(priv->rxringtail)) & (0x08000000)) != 0) |
@@ -1397,20 +1429,29 @@ static void rtl8180_rx(struct net_device *dev)
 
 			/* For good-looking singal strength. */
 			SignalStrengthIndex = NetgearSignalStrengthTranslate(
-							priv->LastSignalStrengthInPercent,
-							priv->SignalStrength);
+					priv->LastSignalStrengthInPercent,
+					priv->SignalStrength);
 
 			priv->LastSignalStrengthInPercent = SignalStrengthIndex;
-			priv->Stats_SignalStrength = TranslateToDbm8185((u8)SignalStrengthIndex);
+			priv->Stats_SignalStrength = TranslateToDbm8185(
+					(u8)SignalStrengthIndex);
 		/*
-		 * We need more correct power of received packets and the  "SignalStrength" of RxStats is beautified,
-		 * so we record the correct power here.
+		 * We need more correct power of received packets and the
+		 * "SignalStrength" of RxStats is beautified, so we record
+		 * the correct power here.
 		 */
-			priv->Stats_SignalQuality = (long)(priv->Stats_SignalQuality * 5 + (long)priv->SignalQuality + 5) / 6;
-			priv->Stats_RecvSignalPower = (long)(priv->Stats_RecvSignalPower * 5 + priv->RecvSignalPower - 1) / 6;
+			priv->Stats_SignalQuality = (long)(priv->
+					Stats_SignalQuality * 5 +
+					(long)priv->SignalQuality + 5) / 6;
+			priv->Stats_RecvSignalPower = (long)(priv->
+					Stats_RecvSignalPower * 5 +
+					priv->RecvSignalPower - 1) / 6;
 
-		/* Figure out which antenna that received the last packet. */
-			priv->LastRxPktAntenna = Antenna ? 1 : 0; /* 0: aux, 1: main. */
+		/*
+		 * Figure out which antenna that received the last packet.
+		 * 0: aux, 1: main.
+		 */
+			priv->LastRxPktAntenna = Antenna ? 1 : 0;
 			SwAntennaDiversityRxOk8185(dev, priv->SignalStrength);
 		}
 
@@ -1435,8 +1476,8 @@ static void rtl8180_rx(struct net_device *dev)
 			* and we are still rxing garbage....
 			*/
 			if (!priv->rx_skb_complete) {
-
-				tmp_skb = dev_alloc_skb(priv->rx_skb->len+len+2);
+				tmp_skb = dev_alloc_skb(priv->rx_skb->len +
+					len + 2);
 
 				if (!tmp_skb)
 					goto drop;
@@ -1456,7 +1497,8 @@ static void rtl8180_rx(struct net_device *dev)
 		if (!priv->rx_skb_complete) {
 			if (padding) {
 				memcpy(skb_put(priv->rx_skb, len),
-					(((unsigned char *)priv->rxbuffer->buf) + 2), len);
+					((unsigned char *)priv->rxbuffer->buf +
+					2), len);
 			} else {
 				memcpy(skb_put(priv->rx_skb, len),
 					priv->rxbuffer->buf, len);
@@ -1538,7 +1580,7 @@ static void rtl8180_hard_data_xmit(struct sk_buff *skb, struct net_device *dev,
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	int mode;
-	struct ieee80211_hdr_3addr *h = (struct ieee80211_hdr_3addr *) skb->data;
+	struct ieee80211_hdr_3addr *h = (struct ieee80211_hdr_3addr *)skb->data;
 	short morefrag = (h->frame_control) & IEEE80211_FCTL_MOREFRAGS;
 	unsigned long flags;
 	int priority;
@@ -1669,7 +1711,8 @@ static void rtl8180_prepare_beacon(struct net_device *dev)
 
 	u16 word  = read_nic_word(dev, BcnItv);
 	word &= ~BcnItv_BcnItv; /* clear Bcn_Itv */
-	word |= cpu_to_le16(priv->ieee80211->current_network.beacon_interval); /* 0x64; */
+	word |= cpu_to_le16(priv->ieee80211->current_network
+			.beacon_interval); /* 0x64; */
 	write_nic_word(dev, BcnItv, word);
 
 	skb = ieee80211_get_beacon(priv->ieee80211);
@@ -1697,16 +1740,17 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 	int buflen;
 	int count;
 	struct buffer *buflist;
-	struct ieee80211_hdr_3addr *frag_hdr = (struct ieee80211_hdr_3addr *)txbuf;
+	struct ieee80211_hdr_3addr *frag_hdr =
+			(struct ieee80211_hdr_3addr *)txbuf;
 	u8 dest[ETH_ALEN];
-	u8			bUseShortPreamble = 0;
-	u8			bCTSEnable = 0;
-	u8			bRTSEnable = 0;
-	u16			Duration = 0;
-	u16			RtsDur = 0;
-	u16			ThisFrameTime = 0;
-	u16			TxDescDuration = 0;
-	bool			ownbit_flag = false;
+	u8 bUseShortPreamble = 0;
+	u8 bCTSEnable = 0;
+	u8 bRTSEnable = 0;
+	u16 Duration = 0;
+	u16 RtsDur = 0;
+	u16 ThisFrameTime = 0;
+	u16 TxDescDuration = 0;
+	bool ownbit_flag = false;
 
 	switch (priority) {
 	case MANAGE_PRIORITY:
@@ -1763,8 +1807,9 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 			bRTSEnable = 0;
 			bCTSEnable = 0;
 
-			ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate),
-						      0, bUseShortPreamble);
+			ThisFrameTime = ComputeTxTime(len + sCrcLng,
+					rtl8180_rate2rate(rate),
+					0, bUseShortPreamble);
 			TxDescDuration = ThisFrameTime;
 		} else { /* Unicast packet */
 			u16 AckTime;
@@ -1773,28 +1818,36 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 			priv->NumTxUnicast++;
 
 			/* Figure out ACK rate according to BSS basic rate
-			 * and Tx rate. */
-			AckTime = ComputeTxTime(14, 10, 0, 0);	/* AckCTSLng = 14 use 1M bps send */
+			 * and Tx rate. AckCTSLng = 14 use 1M bps send */
+			AckTime = ComputeTxTime(14, 10, 0, 0);
+
+			if (((len + sCrcLng) > priv->rts) && priv->rts) {
+				/* RTS/CTS. */
 
-			if (((len + sCrcLng) > priv->rts) && priv->rts) { /* RTS/CTS. */
 				u16 RtsTime, CtsTime;
 				/* u16 CtsRate; */
 				bRTSEnable = 1;
 				bCTSEnable = 0;
 
 				/* Rate and time required for RTS. */
-				RtsTime = ComputeTxTime(sAckCtsLng/8, priv->ieee80211->basic_rate, 0, 0);
-				/* Rate and time required for CTS. */
-				CtsTime = ComputeTxTime(14, 10, 0, 0);	/* AckCTSLng = 14 use 1M bps send */
+				RtsTime = ComputeTxTime(sAckCtsLng/8,
+						priv->ieee80211->basic_rate,
+						0, 0);
 
-				/* Figure out time required to transmit this frame. */
+				/* Rate and time required for CTS.
+				 * AckCTSLng = 14 use 1M bps send */
+				CtsTime = ComputeTxTime(14, 10, 0, 0);
+
+				/* Figure out time required to
+				 * transmit this frame. */
 				ThisFrameTime = ComputeTxTime(len + sCrcLng,
 						rtl8180_rate2rate(rate),
 						0,
 						bUseShortPreamble);
 
 				/* RTS-CTS-ThisFrame-ACK. */
-				RtsDur = CtsTime + ThisFrameTime + AckTime + 3*aSifsTime;
+				RtsDur = CtsTime + ThisFrameTime +
+						AckTime + 3*aSifsTime;
 
 				TxDescDuration = RtsTime + RtsDur;
 			} else { /* Normal case. */
@@ -1802,23 +1855,30 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 				bRTSEnable = 0;
 				RtsDur = 0;
 
-				ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate),
-							      0, bUseShortPreamble);
-				TxDescDuration = ThisFrameTime + aSifsTime + AckTime;
+				ThisFrameTime = ComputeTxTime(len + sCrcLng,
+						rtl8180_rate2rate(rate),
+						0, bUseShortPreamble);
+
+				TxDescDuration = ThisFrameTime +
+						aSifsTime + AckTime;
 			}
 
-			if (!(frag_hdr->frame_control & IEEE80211_FCTL_MOREFRAGS)) {
+			if (!(frag_hdr->frame_control &
+					IEEE80211_FCTL_MOREFRAGS)) {
 				/* ThisFrame-ACK. */
 				Duration = aSifsTime + AckTime;
 			} else { /* One or more fragments remained. */
 				u16 NextFragTime;
-				NextFragTime = ComputeTxTime(len + sCrcLng, /* pretend following packet length equal current packet */
+
+				/* pretend following packet length
+				 * equal current packet */
+				NextFragTime = ComputeTxTime(len + sCrcLng,
 						rtl8180_rate2rate(rate),
-						0,
-						bUseShortPreamble);
+						0, bUseShortPreamble);
 
 				/* ThisFrag-ACk-NextFrag-ACK. */
-				Duration = NextFragTime + 3*aSifsTime + 2*AckTime;
+				Duration = NextFragTime + 3*aSifsTime +
+						2*AckTime;
 			}
 
 		} /* End of Unicast packet */
@@ -1832,7 +1892,8 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 	while (remain != 0) {
 		mb();
 		if (!buflist) {
-			DMESGE("TX buffer error, cannot TX frames. pri %d.", priority);
+			DMESGE("TX buffer error, cannot TX frames. pri %d.",
+					priority);
 			return -1;
 		}
 		buf = buflist->buf;
@@ -1851,19 +1912,23 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 		*(tail+6) = 0;
 		*(tail+7) = 0;
 
-		/* FIXME: this should be triggered by HW encryption parameters.*/
+		/* FIXME: this should be triggered by
+		 * HW encryption parameters. */
 		*tail |= (1<<15); /* no encrypt */
 
 		if (remain == len && !descfrag) {
 			ownbit_flag = false;
-			*tail = *tail | (1<<29); /* fist segment of the packet */
+
+			/* first segment of the packet */
+			*tail = *tail | (1<<29);
 			*tail = *tail | (len);
 		} else {
 			ownbit_flag = true;
 		}
 
 		for (i = 0; i < buflen && remain > 0; i++, remain--) {
-			((u8 *)buf)[i] = txbuf[i]; /* copy data into descriptor pointed DMAble buffer */
+			/* copy data into descriptor pointed DMAble buffer */
+			((u8 *)buf)[i] = txbuf[i];
 			if (remain == 4 && i+4 >= buflen)
 				break;
 			/* ensure the last desc has at least 4 bytes payload */
@@ -1873,21 +1938,26 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 		*(tail+3) = *(tail+3) & ~0xfff;
 		*(tail+3) = *(tail+3) | i; /* buffer length */
 		/* Use short preamble or not */
-		if (priv->ieee80211->current_network.capability&WLAN_CAPABILITY_SHORT_PREAMBLE)
-			if (priv->plcp_preamble_mode == 1 && rate != 0)	/*  short mode now, not long! */
-			; /* *tail |= (1<<16); */				/* enable short preamble mode. */
+		if (priv->ieee80211->current_network.capability &
+				WLAN_CAPABILITY_SHORT_PREAMBLE)
+			/* short mode now, not long! */
+			if (priv->plcp_preamble_mode == 1 && rate != 0)
+				/* enable short preamble mode. */
+				; /* *tail |= (1<<16); */
 
 		if (bCTSEnable)
 			*tail |= (1<<18);
 
 		if (bRTSEnable) { /* rts enable */
-			*tail |= ((ieeerate2rtlrate(priv->ieee80211->basic_rate))<<19); /* RTS RATE */
+			/* RTS RATE */
+			*tail |= ((ieeerate2rtlrate(
+				priv->ieee80211->basic_rate)) << 19);
 			*tail |= (1<<23); /* rts enable */
 			*(tail+1) |= (RtsDur&0xffff); /* RTS Duration */
 		}
 		*(tail+3) |= ((TxDescDuration&0xffff)<<16); /* DURATION */
 		/* *(tail+3) |= (0xe6<<16); */
-		*(tail+5) |= (11<<8); /* (priv->retry_data<<8); */ /* retry lim; */
+		*(tail+5) |= (11<<8); /* (priv->retry_data<<8); - retry lim; */
 
 		*tail = *tail | ((rate&0xf) << 24);
 
@@ -1901,7 +1971,8 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 
 		wmb();
 		if (ownbit_flag)
-			*tail = *tail | (1<<31); /* descriptor ready to be txed */
+			/* descriptor ready to be txed */
+			*tail = *tail | (1<<31);
 
 		if ((tail - begin)/8 == count-1)
 			tail = begin;
@@ -1983,7 +2054,8 @@ static void rtl8180_rq_tx_ack(struct net_device *dev)
 
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
-	write_nic_byte(dev, CONFIG4, read_nic_byte(dev, CONFIG4) | CONFIG4_PWRMGT);
+	write_nic_byte(dev, CONFIG4, read_nic_byte(dev, CONFIG4) |
+			CONFIG4_PWRMGT);
 	priv->ack_tx_to_ieee = 1;
 }
 
@@ -2031,7 +2103,8 @@ static void rtl8180_hw_wakeup(struct net_device *dev)
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 	spin_lock_irqsave(&priv->ps_lock, flags);
-	write_nic_byte(dev, CONFIG4, read_nic_byte(dev, CONFIG4) & ~CONFIG4_PWRMGT);
+	write_nic_byte(dev, CONFIG4, read_nic_byte(dev, CONFIG4) &
+			~CONFIG4_PWRMGT);
 	if (priv->rf_wakeup)
 		priv->rf_wakeup(dev);
 	spin_unlock_irqrestore(&priv->ps_lock, flags);
@@ -2063,13 +2136,13 @@ static void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 	tl -= MSECS(4+16+7);
 
 	/*
-	 * If the interval in witch we are requested to sleep is too
+	 * If the interval in which we are requested to sleep is too
 	 * short then give up and remain awake
 	 */
 	if (((tl >= rb) && (tl-rb) <= MSECS(MIN_SLEEP_TIME))
 		|| ((rb > tl) && (rb-tl) < MSECS(MIN_SLEEP_TIME))) {
 		spin_unlock_irqrestore(&priv->ps_lock, flags);
-		printk("too short to sleep\n");
+		netdev_warn(dev, "too short to sleep\n");
 		return;
 	}
 
@@ -2078,7 +2151,8 @@ static void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 		priv->DozePeriodInPast2Sec += jiffies_to_msecs(tmp);
 		/* as tl may be less than rb */
-		queue_delayed_work(priv->ieee80211->wq, &priv->ieee80211->hw_wakeup_wq, tmp);
+		queue_delayed_work(priv->ieee80211->wq,
+				&priv->ieee80211->hw_wakeup_wq, tmp);
 	}
 	/*
 	 * If we suspect the TimerInt is gone beyond tl
@@ -2097,7 +2171,8 @@ static void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 static void rtl8180_wmm_param_update(struct work_struct *work)
 {
-	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, wmm_param_update_wq);
+	struct ieee80211_device *ieee = container_of(work,
+			struct ieee80211_device, wmm_param_update_wq);
 	struct net_device *dev = ieee->dev;
 	u8 *ac_param = (u8 *)(ieee->current_network.wmm_param);
 	u8 mode = ieee->current_network.mode;
@@ -2121,23 +2196,33 @@ static void rtl8180_wmm_param_update(struct work_struct *work)
 				u32		u4bAcParam;
 				pAcParam = (PAC_PARAM)(&AcParam);
 				/* Retrieve parameters to update. */
-				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
-				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<AC_PARAM_TXOP_LIMIT_OFFSET)|
-					      (((u32)(pAcParam->f.Ecw.f.ECWmax))<<AC_PARAM_ECW_MAX_OFFSET)|
-					      (((u32)(pAcParam->f.Ecw.f.ECWmin))<<AC_PARAM_ECW_MIN_OFFSET)|
-					       (((u32)u1bAIFS) << AC_PARAM_AIFS_OFFSET));
+				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN *
+						(((mode&IEEE_G) == IEEE_G) ?
+						9 : 20) + aSifsTime;
+
+				u4bAcParam = (((u32)pAcParam->f.TXOPLimit <<
+						AC_PARAM_TXOP_LIMIT_OFFSET) |
+					((u32)pAcParam->f.Ecw.f.ECWmax <<
+						AC_PARAM_ECW_MAX_OFFSET) |
+					((u32)pAcParam->f.Ecw.f.ECWmin <<
+						AC_PARAM_ECW_MIN_OFFSET) |
+					((u32)u1bAIFS << AC_PARAM_AIFS_OFFSET));
 				switch (eACI) {
 				case AC1_BK:
-					write_nic_dword(dev, AC_BK_PARAM, u4bAcParam);
+					write_nic_dword(dev, AC_BK_PARAM,
+							u4bAcParam);
 					break;
 				case AC0_BE:
-					write_nic_dword(dev, AC_BE_PARAM, u4bAcParam);
+					write_nic_dword(dev, AC_BE_PARAM,
+							u4bAcParam);
 					break;
 				case AC2_VI:
-					write_nic_dword(dev, AC_VI_PARAM, u4bAcParam);
+					write_nic_dword(dev, AC_VI_PARAM,
+							u4bAcParam);
 					break;
 				case AC3_VO:
-					write_nic_dword(dev, AC_VO_PARAM, u4bAcParam);
+					write_nic_dword(dev, AC_VO_PARAM,
+							u4bAcParam);
 					break;
 				default:
 					pr_warn("SetHwReg8185():invalid ACI: %d!\n",
@@ -2160,11 +2245,17 @@ static void rtl8180_wmm_param_update(struct work_struct *work)
 			/* Retrieve parameters to update. */
 			eACI = pAcParam->f.AciAifsn.f.ACI;
 			/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
-			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
-			u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit)) << AC_PARAM_TXOP_LIMIT_OFFSET)	|
-					(((u32)(pAcParam->f.Ecw.f.ECWmax)) << AC_PARAM_ECW_MAX_OFFSET)	|
-					(((u32)(pAcParam->f.Ecw.f.ECWmin)) << AC_PARAM_ECW_MIN_OFFSET)	|
-					(((u32)u1bAIFS) << AC_PARAM_AIFS_OFFSET));
+			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN *
+					(((mode&IEEE_G) == IEEE_G) ?
+					9 : 20) + aSifsTime;
+
+			u4bAcParam = (((u32)pAcParam->f.TXOPLimit <<
+					AC_PARAM_TXOP_LIMIT_OFFSET) |
+				((u32)pAcParam->f.Ecw.f.ECWmax <<
+					AC_PARAM_ECW_MAX_OFFSET) |
+				((u32)pAcParam->f.Ecw.f.ECWmin <<
+					AC_PARAM_ECW_MIN_OFFSET) |
+				((u32)u1bAIFS << AC_PARAM_AIFS_OFFSET));
 
 			switch (eACI) {
 			case AC1_BK:
@@ -2208,7 +2299,8 @@ static void watch_dog_adaptive(unsigned long data)
 
 	/* Tx High Power Mechanism. */
 	if (CheckHighPower((struct net_device *)data))
-		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->tx_pw_wq);
+		queue_work(priv->ieee80211->wq,
+				(void *)&priv->ieee80211->tx_pw_wq);
 
 	/* Tx Power Tracking on 87SE. */
 	if (CheckTxPwrTracking((struct net_device *)data))
@@ -2216,27 +2308,57 @@ static void watch_dog_adaptive(unsigned long data)
 
 	/* Perform DIG immediately. */
 	if (CheckDig((struct net_device *)data))
-		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->hw_dig_wq);
+		queue_work(priv->ieee80211->wq,
+				(void *)&priv->ieee80211->hw_dig_wq);
 	rtl8180_watch_dog((struct net_device *)data);
 
-	queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->GPIOChangeRFWorkItem);
+	queue_work(priv->ieee80211->wq,
+			(void *)&priv->ieee80211->GPIOChangeRFWorkItem);
 
-	priv->watch_dog_timer.expires = jiffies + MSECS(IEEE80211_WATCH_DOG_TIME);
+	priv->watch_dog_timer.expires = jiffies +
+			MSECS(IEEE80211_WATCH_DOG_TIME);
 	add_timer(&priv->watch_dog_timer);
 }
 
 static CHANNEL_LIST ChannelPlan[] = {
-	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64},19},		/* FCC */
-	{{1,2,3,4,5,6,7,8,9,10,11},11},					/* IC */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* ETSI */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* Spain. Change to ETSI. */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* France. Change to ETSI. */
-	{{14,36,40,44,48,52,56,60,64},9},				/* MKK */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14, 36,40,44,48,52,56,60,64},22},/* MKK1 */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* Israel. */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,34,38,42,46},17},		/* For 11a , TELEC */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14},  /* For Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626 */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13} /* world wide 13: ch1~ch11 active scan, ch12~13 passive //lzm add 080826 */
+	/* FCC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40,
+			44, 48, 52, 56, 60, 64}, 19},
+
+	/* IC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},
+
+	/* ETSI */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36,
+			40, 44, 48, 52, 56, 60, 64}, 21},
+
+	/* Spain. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36,
+			40, 44, 48, 52, 56, 60, 64}, 21},
+
+	/* France. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36,
+			40, 44, 48, 52, 56, 60, 64}, 21},
+
+	/* MKK */
+	{{14, 36, 40, 44, 48, 52, 56, 60, 64}, 9},
+
+	/* MKK1 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36,
+			40, 44, 48, 52, 56, 60, 64}, 22},
+
+	/* Israel. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36,
+			40, 44, 48, 52, 56, 60, 64}, 21},
+
+	/* For 11a, TELEC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 34, 38, 42, 46}, 17},
+
+	/* Global Domain. 1-11:active, 12-14 passive. //+YJ, 080626 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14},
+
+	/* world wide 13: ch1-ch11:active, ch12-13 passive //lzm add 080826 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13}
 };
 
 static void rtl8180_set_channel_map(u8 channel_plan,
@@ -2257,43 +2379,43 @@ static void rtl8180_set_channel_map(u8 channel_plan,
 	case COUNTRY_CODE_MKK:
 	case COUNTRY_CODE_MKK1:
 	case COUNTRY_CODE_ISRAEL:
-	case COUNTRY_CODE_TELEC:
-		{
-			Dot11d_Init(ieee);
-			ieee->bGlobalDomain = false;
-			if (ChannelPlan[channel_plan].Len != 0) {
-				/* Clear old channel map */
-				memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(GET_DOT11D_INFO(ieee)->channel_map));
-				/* Set new channel map */
-				for (i = 0; i < ChannelPlan[channel_plan].Len; i++) {
-					if (ChannelPlan[channel_plan].Channel[i] <= 14)
-						GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan[channel_plan].Channel[i]] = 1;
-				}
+	case COUNTRY_CODE_TELEC: {
+		Dot11d_Init(ieee);
+		ieee->bGlobalDomain = false;
+		if (ChannelPlan[channel_plan].Len != 0) {
+			/* Clear old channel map */
+			memset(GET_DOT11D_INFO(ieee)->channel_map, 0,
+				sizeof(GET_DOT11D_INFO(ieee)->channel_map));
+			/* Set new channel map */
+			for (i = 0; i < ChannelPlan[channel_plan].Len; i++) {
+				if (ChannelPlan[channel_plan].Channel[i] <= 14)
+					GET_DOT11D_INFO(ieee)->channel_map[
+						ChannelPlan[channel_plan]
+						.Channel[i]] = 1;
 			}
-			break;
-		}
-	case COUNTRY_CODE_GLOBAL_DOMAIN:
-		{
-			GET_DOT11D_INFO(ieee)->bEnabled = false;
-			Dot11d_Reset(ieee);
-			ieee->bGlobalDomain = true;
-			break;
-		}
-	case COUNTRY_CODE_WORLD_WIDE_13_INDEX:/* lzm add 080826 */
-		{
-			ieee->MinPassiveChnlNum = 12;
-			ieee->IbssStartChnl = 10;
-			break;
-		}
-	default:
-		{
-			Dot11d_Init(ieee);
-			ieee->bGlobalDomain = false;
-			memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(GET_DOT11D_INFO(ieee)->channel_map));
-			for (i = 1; i <= 14; i++)
-				GET_DOT11D_INFO(ieee)->channel_map[i] = 1;
-			break;
 		}
+		break;
+	}
+	case COUNTRY_CODE_GLOBAL_DOMAIN: {
+		GET_DOT11D_INFO(ieee)->bEnabled = false;
+		Dot11d_Reset(ieee);
+		ieee->bGlobalDomain = true;
+		break;
+	}
+	case COUNTRY_CODE_WORLD_WIDE_13_INDEX: { /* lzm add 080826 */
+		ieee->MinPassiveChnlNum = 12;
+		ieee->IbssStartChnl = 10;
+		break;
+	}
+	default: {
+		Dot11d_Init(ieee);
+		ieee->bGlobalDomain = false;
+		memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(
+				GET_DOT11D_INFO(ieee)->channel_map));
+		for (i = 1; i <= 14; i++)
+			GET_DOT11D_INFO(ieee)->channel_map[i] = 1;
+		break;
+	}
 	}
 }
 
@@ -2385,7 +2507,8 @@ static short rtl8180_init(struct net_device *dev)
 	rtl8180_link_detect_init(&priv->link_detect);
 
 	priv->ack_tx_to_ieee = 0;
-	priv->ieee80211->current_network.beacon_interval = DEFAULT_BEACONINTERVAL;
+	priv->ieee80211->current_network
+			.beacon_interval = DEFAULT_BEACONINTERVAL;
 	priv->ieee80211->iw_mode = IW_MODE_INFRA;
 	priv->ieee80211->softmac_features  = IEEE_SOFTMAC_SCAN |
 		IEEE_SOFTMAC_ASSOCIATE | IEEE_SOFTMAC_PROBERQ |
@@ -2431,7 +2554,8 @@ static short rtl8180_init(struct net_device *dev)
 	priv->AdRxSsBeforeSwitched = 0;
 	init_timer(&priv->SwAntennaDiversityTimer);
 	priv->SwAntennaDiversityTimer.data = (unsigned long)dev;
-	priv->SwAntennaDiversityTimer.function = (void *)SwAntennaDiversityTimerCallback;
+	priv->SwAntennaDiversityTimer.function =
+			(void *)SwAntennaDiversityTimerCallback;
 	priv->bDigMechanism = true;
 	priv->InitialGain = 6;
 	priv->bXtalCalibration = false;
@@ -2440,7 +2564,8 @@ static short rtl8180_init(struct net_device *dev)
 	priv->bTxPowerTrack = false;
 	priv->ThermalMeter = 0;
 	priv->FalseAlarmRegValue = 0;
-	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threshold of OFDM false alarm, which is used in DIG. */
+	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threshold of OFDM false alarm,
+					which is used in DIG. */
 	priv->DIG_NumberFallbackVote = 0;
 	priv->DIG_NumberUpgradeVote = 0;
 	priv->LastSignalStrengthInPercent = 0;
@@ -2585,7 +2710,8 @@ static short rtl8180_init(struct net_device *dev)
 		priv->bSwAntennaDiverity = priv->EEPROMSwAntennaDiversity;
 	else
 		/* 1:disable antenna diversity, 2: enable antenna diversity. */
-		priv->bSwAntennaDiverity = priv->RegSwAntennaDiversityMechanism == 2;
+		priv->bSwAntennaDiverity = priv->RegSwAntennaDiversityMechanism
+				== 2;
 
 	if (priv->RegDefaultAntenna == 0)
 		/* 0: default from EEPROM. */
@@ -2669,7 +2795,8 @@ static short rtl8180_init(struct net_device *dev)
 				  TX_BEACON_RING_ADDR))
 		return -ENOMEM;
 
-	if (request_irq(dev->irq, rtl8180_interrupt, IRQF_SHARED, dev->name, dev)) {
+	if (request_irq(dev->irq, rtl8180_interrupt,
+			IRQF_SHARED, dev->name, dev)) {
 		DMESGE("Error allocating IRQ %d", dev->irq);
 		return -1;
 	} else {
@@ -2768,16 +2895,20 @@ static void rtl8185_write_phy(struct net_device *dev, u8 adr, u32 data)
 
 	phyw = ((data<<8) | adr);
 
-	/* Note that, we must write 0xff7c after 0x7d-0x7f to write BB register. */
+	/* Note that, we must write 0xff7c after
+	 * 0x7d-0x7f to write BB register. */
 	write_nic_byte(dev, 0x7f, ((phyw & 0xff000000) >> 24));
 	write_nic_byte(dev, 0x7e, ((phyw & 0x00ff0000) >> 16));
 	write_nic_byte(dev, 0x7d, ((phyw & 0x0000ff00) >> 8));
 	write_nic_byte(dev, 0x7c, ((phyw & 0x000000ff)));
 
-	/* this is ok to fail when we write AGC table. check for AGC table might be
-	 * done by masking with 0x7f instead of 0xff
-	 */
-	/* if (phyr != (data&0xff)) DMESGW("Phy write timeout %x %x %x", phyr, data, adr); */
+	/* this is ok to fail when we write AGC table. check for AGC
+	 * table might be done by masking with 0x7f instead of 0xff */
+
+	/*
+	if (phyr != (data&0xff))
+		DMESGW("Phy write timeout %x %x %x", phyr, data, adr);
+	*/
 }
 
 inline void write_phy_ofdm(struct net_device *dev, u8 adr, u32 data)
@@ -2846,25 +2977,23 @@ static bool MgntActSet_802_11_PowerSaveMode(struct r8180_priv *priv,
 
 static void LeisurePSEnter(struct r8180_priv *priv)
 {
-	if (priv->bLeisurePs) {
-		if (priv->ieee80211->ps == IEEE80211_PS_DISABLED)
-			/* IEEE80211_PS_ENABLE */
-			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_MBCAST|IEEE80211_PS_UNICAST);
-	}
+	if (priv->bLeisurePs && priv->ieee80211->ps == IEEE80211_PS_DISABLED)
+		/* IEEE80211_PS_ENABLE */
+		MgntActSet_802_11_PowerSaveMode(priv,
+				IEEE80211_PS_MBCAST|IEEE80211_PS_UNICAST);
 }
 
 static void LeisurePSLeave(struct r8180_priv *priv)
 {
-	if (priv->bLeisurePs) {
-		if (priv->ieee80211->ps != IEEE80211_PS_DISABLED)
-			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_DISABLED);
-	}
+	if (priv->bLeisurePs && priv->ieee80211->ps != IEEE80211_PS_DISABLED)
+		MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_DISABLED);
 }
 
 void rtl8180_hw_wakeup_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, hw_wakeup_wq);
+	struct ieee80211_device *ieee = container_of(dwork,
+			struct ieee80211_device, hw_wakeup_wq);
 	struct net_device *dev = ieee->dev;
 
 	rtl8180_hw_wakeup(dev);
@@ -2873,7 +3002,8 @@ void rtl8180_hw_wakeup_wq(struct work_struct *work)
 void rtl8180_hw_sleep_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, hw_sleep_wq);
+	struct ieee80211_device *ieee = container_of(dwork,
+			struct ieee80211_device, hw_sleep_wq);
 	struct net_device *dev = ieee->dev;
 
 	rtl8180_hw_sleep_down(dev);
@@ -2881,6 +3011,9 @@ void rtl8180_hw_sleep_wq(struct work_struct *work)
 
 static void MgntLinkKeepAlive(struct r8180_priv *priv)
 {
+	bool tx;
+	bool rx;
+
 	if (priv->keepAliveLevel == 0)
 		return;
 
@@ -2889,24 +3022,29 @@ static void MgntLinkKeepAlive(struct r8180_priv *priv)
 		 * Keep-Alive.
 		 */
 
-		if ((priv->keepAliveLevel == 2) ||
-			(priv->link_detect.LastNumTxUnicast == priv->NumTxUnicast &&
-			priv->link_detect.LastNumRxUnicast == priv->ieee80211->NumRxUnicast)
-			) {
+		tx = priv->link_detect.LastNumTxUnicast == priv->NumTxUnicast;
+		rx = priv->link_detect.LastNumRxUnicast ==
+			priv->ieee80211->NumRxUnicast;
+
+		if ((priv->keepAliveLevel == 2) || (tx && rx)) {
 			priv->link_detect.IdleCount++;
 
 			/*
-			 * Send a Keep-Alive packet packet to AP if we had been idle for a while.
+			 * Send a Keep-Alive packet packet to AP
+			 * if we had been idle for a while.
 			 */
-			if (priv->link_detect.IdleCount >= ((KEEP_ALIVE_INTERVAL / CHECK_FOR_HANG_PERIOD)-1)) {
+			if (priv->link_detect.IdleCount >= ((KEEP_ALIVE_INTERVAL
+					/ CHECK_FOR_HANG_PERIOD)-1)) {
 				priv->link_detect.IdleCount = 0;
-				ieee80211_sta_ps_send_null_frame(priv->ieee80211, false);
+				ieee80211_sta_ps_send_null_frame(
+						priv->ieee80211, false);
 			}
 		} else {
 			priv->link_detect.IdleCount = 0;
 		}
 		priv->link_detect.LastNumTxUnicast = priv->NumTxUnicast;
-		priv->link_detect.LastNumRxUnicast = priv->ieee80211->NumRxUnicast;
+		priv->link_detect.LastNumRxUnicast =
+				priv->ieee80211->NumRxUnicast;
 	}
 }
 
@@ -2926,15 +3064,24 @@ void rtl8180_watch_dog(struct net_device *dev)
 			IPSEnter(dev);
 	}
 	/* YJ,add,080828,for link state check */
-	if ((priv->ieee80211->state == IEEE80211_LINKED) && (priv->ieee80211->iw_mode == IW_MODE_INFRA)) {
-		SlotIndex = (priv->link_detect.SlotIndex++) % priv->link_detect.SlotNum;
-		priv->link_detect.RxFrameNum[SlotIndex] = priv->ieee80211->NumRxDataInPeriod + priv->ieee80211->NumRxBcnInPeriod;
+	if ((priv->ieee80211->state == IEEE80211_LINKED) &&
+			(priv->ieee80211->iw_mode == IW_MODE_INFRA)) {
+
+		SlotIndex = (priv->link_detect.SlotIndex++) %
+				priv->link_detect.SlotNum;
+
+		priv->link_detect.RxFrameNum[SlotIndex] =
+				priv->ieee80211->NumRxDataInPeriod +
+				priv->ieee80211->NumRxBcnInPeriod;
+
 		for (i = 0; i < priv->link_detect.SlotNum; i++)
 			TotalRxNum += priv->link_detect.RxFrameNum[i];
 
 		if (TotalRxNum == 0) {
 			priv->ieee80211->state = IEEE80211_ASSOCIATING;
-			queue_work(priv->ieee80211->wq, &priv->ieee80211->associate_procedure_wq);
+
+			queue_work(priv->ieee80211->wq,
+				&priv->ieee80211->associate_procedure_wq);
 		}
 	}
 
@@ -2945,12 +3092,14 @@ void rtl8180_watch_dog(struct net_device *dev)
 	LeisurePSLeave(priv);
 
 	if (priv->ieee80211->state == IEEE80211_LINKED) {
-		priv->link_detect.NumRxOkInPeriod = priv->ieee80211->NumRxDataInPeriod;
+		priv->link_detect.NumRxOkInPeriod =
+				priv->ieee80211->NumRxDataInPeriod;
 		if (priv->link_detect.NumRxOkInPeriod > 666 ||
 			priv->link_detect.NumTxOkInPeriod > 666) {
 			bBusyTraffic = true;
 		}
-		if (((priv->link_detect.NumRxOkInPeriod + priv->link_detect.NumTxOkInPeriod) > 8)
+		if (((priv->link_detect.NumRxOkInPeriod +
+			priv->link_detect.NumTxOkInPeriod) > 8)
 			|| (priv->link_detect.NumRxOkInPeriod > 2)) {
 			bEnterPS = false;
 		} else
@@ -3048,14 +3197,16 @@ int rtl8180_down(struct net_device *dev)
 	cancel_delayed_work(&priv->ieee80211->tx_pw_wq);
 	del_timer_sync(&priv->SwAntennaDiversityTimer);
 	SetZebraRFPowerState8185(dev, eRfOff);
-	memset(&(priv->ieee80211->current_network), 0, sizeof(struct ieee80211_network));
+	memset(&(priv->ieee80211->current_network), 0,
+			sizeof(struct ieee80211_network));
 	priv->ieee80211->state = IEEE80211_NOLINK;
 	return 0;
 }
 
 void rtl8180_restart_wq(struct work_struct *work)
 {
-	struct r8180_priv *priv = container_of(work, struct r8180_priv, reset_wq);
+	struct r8180_priv *priv = container_of(work,
+			struct r8180_priv, reset_wq);
 	struct net_device *dev = priv->dev;
 
 	down(&priv->wx_sem);
@@ -3116,7 +3267,8 @@ static int r8180_set_mac_adr(struct net_device *dev, void *mac)
 	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
 
 	if (priv->ieee80211->iw_mode == IW_MODE_MASTER)
-		memcpy(priv->ieee80211->current_network.bssid, dev->dev_addr, ETH_ALEN);
+		memcpy(priv->ieee80211->current_network.bssid,
+				dev->dev_addr, ETH_ALEN);
 
 	if (priv->up) {
 		rtl8180_down(dev);
@@ -3133,15 +3285,10 @@ static int rtl8180_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	struct iwreq *wrq = (struct iwreq *) rq;
-	int ret = -1;
 
-	switch (cmd) {
-	case RTL_IOCTL_WPA_SUPPLICANT:
-		ret = ieee80211_wpa_supplicant_ioctl(priv->ieee80211, &wrq->u.data);
-		return ret;
-	default:
-		return -EOPNOTSUPP;
-	}
+	if (cmd == RTL_IOCTL_WPA_SUPPLICANT)
+		return ieee80211_wpa_supplicant_ioctl(priv->ieee80211,
+				&wrq->u.data);
 
 	return -EOPNOTSUPP;
 }
@@ -3688,7 +3835,8 @@ void rtl8180_irq_rx_tasklet(struct r8180_priv *priv)
 
 void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 {
-	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, GPIOChangeRFWorkItem.work);
+	struct ieee80211_device *ieee = container_of(work,
+			struct ieee80211_device, GPIOChangeRFWorkItem.work);
 	struct net_device *dev = ieee->dev;
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u8 btPSR;
@@ -3698,7 +3846,8 @@ void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 
 	char *argv[3];
 	static char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
-	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin", NULL};
+	static char *envp[] = {"HOME=/", "TERM=linux",
+			"PATH=/usr/bin:/bin", NULL};
 	static int readf_count;
 
 	readf_count = (readf_count+1)%0xffff;
-- 
1.8.3.2


