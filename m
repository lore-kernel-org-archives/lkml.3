Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbaCDHPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:15:01 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33669 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbaCDHNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:13:09 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 4/9] drivers: staging: rtl8187se: wrap excessively long lines
Date: Tue,  4 Mar 2014 00:12:52 -0700
Message-Id: <da160b06b24177628a1b7c6d8d5872bc3c67084f.1393916553.git.axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <cover.1393916553.git.axel.rasmussen1@gmail.com>
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com> <cover.1393916553.git.axel.rasmussen1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c | 73 ++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 344ef74..8681099 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1021,7 +1021,8 @@ inline u16 ieeerate2rtlrate(int rate)
 	}
 }
 
-static u16 rtl_rate[] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540, 720};
+static u16 rtl_rate[] = {10, 20, 55, 110, 60,
+	90, 120, 180, 240, 360, 480, 540, 720};
 
 inline u16 rtl8180_rate2rate(short rate)
 {
@@ -1236,7 +1237,8 @@ static void rtl8180_rx(struct net_device *dev)
 		tmp = priv->rxringtail;
 		do {
 			if (tmp == priv->rxring)
-				tmp  = priv->rxring + (priv->rxringcount - 1)*rx_desc_size;
+				tmp  = priv->rxring + (priv->rxringcount - 1) *
+					rx_desc_size;
 			else
 				tmp -= rx_desc_size;
 
@@ -1322,21 +1324,26 @@ static void rtl8180_rx(struct net_device *dev)
 			priv->rx_skb_complete = 1;
 		}
 
-		signal = (unsigned char)(((*(priv->rxringtail+3)) & (0x00ff0000))>>16);
+		signal = (unsigned char)(*(priv->rxringtail + 3) &
+			0x00ff0000) >> 16;
 		signal = (signal & 0xfe) >> 1;
 
 		quality = (unsigned char)((*(priv->rxringtail+3)) & (0xff));
 
 		stats.mac_time[0] = *(priv->rxringtail+1);
 		stats.mac_time[1] = *(priv->rxringtail+2);
-		rxpower = ((char)(((*(priv->rxringtail+4)) & (0x00ff0000))>>16))/2 - 42;
-		RSSI = ((u8)(((*(priv->rxringtail+3)) & (0x0000ff00))>>8)) & (0x7f);
+
+		rxpower = ((char)((*(priv->rxringtail + 4) &
+			0x00ff0000) >> 16)) / 2 - 42;
+
+		RSSI = ((u8)((*(priv->rxringtail + 3) &
+			0x0000ff00) >> 8)) & 0x7f;
 
 		rate = ((*(priv->rxringtail)) &
 			((1<<23)|(1<<22)|(1<<21)|(1<<20)))>>20;
 
 		stats.rate = rtl8180_rate2rate(rate);
-		Antenna = (((*(priv->rxringtail+3)) & (0x00008000)) == 0) ? 0 : 1;
+		Antenna = (*(priv->rxringtail + 3) & 0x00008000) == 0 ? 0 : 1;
 		if (!rtl8180_IsWirelessBMode(stats.rate)) { /* OFDM rate. */
 			RxAGC_dBm = rxpower+1;	/* bias */
 		} else { /* CCK rate. */
@@ -1345,7 +1352,8 @@ static void rtl8180_rx(struct net_device *dev)
 			LNA = (u8) (RxAGC_dBm & 0x60) >> 5; /* bit 6~ bit 5 */
 			BB  = (u8) (RxAGC_dBm & 0x1F); /* bit 4 ~ bit 0 */
 
-			RxAGC_dBm = -(LNA_gain[LNA] + (BB*2)); /* Pin_11b=-(LNA_gain+BB_gain) (dBm) */
+			/* Pin_11b=-(LNA_gain+BB_gain) (dBm) */
+			RxAGC_dBm = -(LNA_gain[LNA] + (BB * 2));
 
 			RxAGC_dBm += 4; /* bias */
 		}
@@ -1373,23 +1381,25 @@ static void rtl8180_rx(struct net_device *dev)
 		priv->RSSI = RSSI;
 		/* SQ translation formula is provided by SD3 DZ. 2006.06.27 */
 		if (quality >= 127)
-			quality = 1; /*0; */ /* 0 will cause epc to show signal zero , walk around now; */
+			/* 0 causes epc to show signal zero, walk around now */
+			quality = 1;
 		else if (quality < 27)
 			quality = 100;
 		else
 			quality = 127 - quality;
 		priv->SignalQuality = quality;
 
-		stats.signal = (u8)quality; /* priv->wstats.qual.level = priv->
-					     * SignalStrength;
-					     */
+		/*priv->wstats.qual.level = priv->SignalStrength; */
+		stats.signal = (u8) quality;
+
 		stats.signalstrength = RXAGC;
 		if (stats.signalstrength > 100)
 			stats.signalstrength = 100;
-		stats.signalstrength = (stats.signalstrength * 70)/100 + 30;
+		stats.signalstrength = (stats.signalstrength * 70) / 100 + 30;
 		/* printk("==========================>rx : RXAGC is %d,signalstrength is %d\n",RXAGC,stats.signalstrength); */
 		stats.rssi = priv->wstats.qual.qual = priv->SignalQuality;
-		stats.noise = priv->wstats.qual.noise = 100 - priv->wstats.qual.qual;
+		stats.noise = priv->wstats.qual.noise =
+			100 - priv->wstats.qual.qual;
 		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) |
 			   (((*(priv->rxringtail)) & (0x04000000)) != 0) |
 			   (((*(priv->rxringtail)) & (0x08000000)) != 0) |
@@ -1422,19 +1432,28 @@ static void rtl8180_rx(struct net_device *dev)
 				priv->SignalStrength);
 
 			priv->LastSignalStrengthInPercent = SignalStrengthIndex;
-			priv->Stats_SignalStrength = TranslateToDbm8185((u8)SignalStrengthIndex);
+			priv->Stats_SignalStrength =
+				TranslateToDbm8185((u8)SignalStrengthIndex);
+
 			/*
 			 * We need more correct power of received packets and
-			 * the "SignalStrength" of RxStats is beautified,
-			 * so we record the correct power here.
+			 * the "SignalStrength" of RxStats is beautified, so we
+			 * record the correct power here.
 			 */
-			priv->Stats_SignalQuality = (long)(priv->Stats_SignalQuality * 5 + (long)priv->SignalQuality + 5) / 6;
-			priv->Stats_RecvSignalPower = (long)(priv->Stats_RecvSignalPower * 5 + priv->RecvSignalPower - 1) / 6;
 
-			/* Figure out which antenna that received the last
-			 * packet.
+			priv->Stats_SignalQuality = (long)(
+				priv->Stats_SignalQuality * 5 +
+				(long)priv->SignalQuality + 5) / 6;
+
+			priv->Stats_RecvSignalPower = (long)(
+				priv->Stats_RecvSignalPower * 5 +
+				priv->RecvSignalPower - 1) / 6;
+
+			/*
+			 * Figure out which antenna received the last packet.
+			 * 0: aux, 1: main
 			 */
-			priv->LastRxPktAntenna = Antenna ? 1 : 0; /* 0: aux, 1: main. */
+			priv->LastRxPktAntenna = Antenna ? 1 : 0;
 			SwAntennaDiversityRxOk8185(dev, priv->SignalStrength);
 		}
 
@@ -1461,7 +1480,8 @@ static void rtl8180_rx(struct net_device *dev)
 			 */
 			if (!priv->rx_skb_complete) {
 
-				tmp_skb = dev_alloc_skb(priv->rx_skb->len+len+2);
+				tmp_skb = dev_alloc_skb(
+					priv->rx_skb->len + len + 2);
 
 				if (!tmp_skb)
 					goto drop;
@@ -1479,13 +1499,8 @@ static void rtl8180_rx(struct net_device *dev)
 		}
 
 		if (!priv->rx_skb_complete) {
-			if (padding) {
-				memcpy(skb_put(priv->rx_skb, len),
-					(((unsigned char *)priv->rxbuffer->buf) + 2), len);
-			} else {
-				memcpy(skb_put(priv->rx_skb, len),
-					priv->rxbuffer->buf, len);
-			}
+			memcpy(skb_put(priv->rx_skb, len), ((unsigned char *)
+				priv->rxbuffer->buf) + (padding ? 2 : 0), len);
 		}
 
 		if (last && !priv->rx_skb_complete) {
-- 
1.8.3.2

