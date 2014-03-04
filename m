Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbaCDHNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:13:14 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63743 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbaCDHNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:13:09 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 5/9] drivers: staging: rtl8187se: wrap excessively long lines
Date: Tue,  4 Mar 2014 00:12:53 -0700
Message-Id: <7c4b4b80bd335e176891e835367e587b7213e2f3.1393916553.git.axel.rasmussen1@gmail.com>
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
 drivers/staging/rtl8187se/r8180_core.c | 63 +++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 8681099..fc0b6d3 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1578,7 +1578,7 @@ static void rtl8180_hard_data_xmit(struct sk_buff *skb, struct net_device *dev,
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	int mode;
-	struct ieee80211_hdr_3addr *h = (struct ieee80211_hdr_3addr *) skb->data;
+	struct ieee80211_hdr_3addr *h = (struct ieee80211_hdr_3addr *)skb->data;
 	short morefrag = (h->frame_control) & IEEE80211_FCTL_MOREFRAGS;
 	unsigned long flags;
 	int priority;
@@ -1659,7 +1659,10 @@ static void rtl8180_prepare_beacon(struct net_device *dev)
 
 	u16 word  = read_nic_word(dev, BcnItv);
 	word &= ~BcnItv_BcnItv; /* clear Bcn_Itv */
-	word |= cpu_to_le16(priv->ieee80211->current_network.beacon_interval); /* 0x64; */
+
+	/* word |= 0x64; */
+	word |= cpu_to_le16(priv->ieee80211->current_network.beacon_interval);
+
 	write_nic_word(dev, BcnItv, word);
 
 	skb = ieee80211_get_beacon(priv->ieee80211);
@@ -1687,16 +1690,17 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 	int buflen;
 	int count;
 	struct buffer *buflist;
-	struct ieee80211_hdr_3addr *frag_hdr = (struct ieee80211_hdr_3addr *)txbuf;
+	struct ieee80211_hdr_3addr *frag_hdr =
+		(struct ieee80211_hdr_3addr *)txbuf;
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
@@ -1822,7 +1826,8 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 	while (remain != 0) {
 		mb();
 		if (!buflist) {
-			DMESGE("TX buffer error, cannot TX frames. pri %d.", priority);
+			DMESGE("TX buffer error, cannot TX frames. pri %d.",
+				priority);
 			return -1;
 		}
 		buf = buflist->buf;
@@ -1841,43 +1846,54 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 		*(tail+6) = 0;
 		*(tail+7) = 0;
 
-		/* FIXME: this should be triggered by HW encryption parameters.*/
+		/* FIXME: should be triggered by HW encryption parameters.*/
 		*tail |= (1<<15); /* no encrypt */
 
 		if (remain == len && !descfrag) {
 			ownbit_flag = false;
-			*tail = *tail | (1<<29); /* fist segment of the packet */
+			*tail = *tail | (1 << 29); /* first segment of packet */
 			*tail = *tail | (len);
 		} else {
 			ownbit_flag = true;
 		}
 
 		for (i = 0; i < buflen && remain > 0; i++, remain--) {
-			((u8 *)buf)[i] = txbuf[i]; /* copy data into descriptor pointed DMAble buffer */
+			/* copy data into descriptor pointed DMAble buffer */
+			((u8 *)buf)[i] = txbuf[i];
+
 			if (remain == 4 && i+4 >= buflen)
 				break;
 			/* ensure the last desc has at least 4 bytes payload */
-
 		}
 		txbuf = txbuf + i;
 		*(tail+3) = *(tail+3) & ~0xfff;
 		*(tail+3) = *(tail+3) | i; /* buffer length */
-		/* Use short preamble or not */
-		if (priv->ieee80211->current_network.capability&WLAN_CAPABILITY_SHORT_PREAMBLE)
-			if (priv->plcp_preamble_mode == 1 && rate != 0)	/*  short mode now, not long! */
-			; /* *tail |= (1<<16); */				/* enable short preamble mode. */
+
+		/* Use short preamble or not - if true, enable short preamble */
+		/*
+		if (priv->ieee80211->current_network.capability &
+			WLAN_CAPABILITY_SHORT_PREAMBLE &&
+			priv->plcp_preamble_mode == 1 && rate != 0) {
+			*tail |= (1 << 16);
+		}
+		*/
 
 		if (bCTSEnable)
 			*tail |= (1<<18);
 
 		if (bRTSEnable) { /* rts enable */
-			*tail |= ((ieeerate2rtlrate(priv->ieee80211->basic_rate))<<19); /* RTS RATE */
+			/* RTS RATE */
+			*tail |= (ieeerate2rtlrate(
+				priv->ieee80211->basic_rate) << 19);
+
 			*tail |= (1<<23); /* rts enable */
 			*(tail+1) |= (RtsDur&0xffff); /* RTS Duration */
 		}
 		*(tail+3) |= ((TxDescDuration&0xffff)<<16); /* DURATION */
 		/* *(tail+3) |= (0xe6<<16); */
-		*(tail+5) |= (11<<8); /* (priv->retry_data<<8); */ /* retry lim; */
+
+		/* (priv->retry_data<<8); */
+		*(tail + 5) |= (11 << 8); /* retry lim; */
 
 		*tail = *tail | ((rate&0xf) << 24);
 
@@ -1891,7 +1907,8 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 
 		wmb();
 		if (ownbit_flag)
-			*tail = *tail | (1<<31); /* descriptor ready to be txed */
+			/* descriptor ready to be txed */
+			*tail |= (1 << 31);
 
 		if ((tail - begin)/8 == count-1)
 			tail = begin;
-- 
1.8.3.2

