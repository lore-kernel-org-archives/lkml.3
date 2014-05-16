Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaEPWci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:32:38 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:51826 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755701AbaEPWch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:32:37 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org, tklauser@distanz.ch
Cc: himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging/wlan-ng: add prefix to function name
Date: Sat, 17 May 2014 00:30:16 +0200
Message-Id: <1400279416-2510-1-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140516072653.GA14932@distanz.ch>
References: <20140516072653.GA14932@distanz.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renamed convert_frame_to_ether() to p80211_convert_to_ether().

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 61a3092..64dd935 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -244,7 +244,7 @@ void p80211netdev_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 #define CONV_TO_ETHER_FAILED	0x02
 
 /**
- * convert_frame_to_ether - conversion from 802.11 frame to ethernet frame
+ * p80211_convert_to_ether - conversion from 802.11 frame to ethernet frame
  * @wlandev: pointer to WLAN device
  * @skb: pointer to socket buffer
  *
@@ -252,7 +252,7 @@ void p80211netdev_rx(wlandevice_t *wlandev, struct sk_buff *skb)
  *	    CONV_TO_ETHER_FAILED if conversion failed
  *	    CONV_TO_ETHER_SKIPPED if frame is ignored
  */
-static int convert_frame_to_ether(wlandevice_t *wlandev, struct sk_buff *skb)
+static int p80211_convert_to_ether(wlandevice_t *wlandev, struct sk_buff *skb)
 {
 	struct p80211_hdr_a3 *hdr;
 
@@ -314,7 +314,7 @@ static void p80211netdev_rx_bh(unsigned long arg)
 				netif_rx_ni(skb);
 				continue;
 			} else {
-				if (!convert_frame_to_ether(wlandev, skb))
+				if (!p80211_convert_to_ether(wlandev, skb))
 					continue;
 			}
 		}
-- 
1.9.0

