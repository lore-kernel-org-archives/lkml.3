Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbaELRgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:36:35 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:59421 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759195AbaELRge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:36:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8KAJwFcVNbsHLF/2dsb2JhbABZgwasagkBBQGaG4EaF3SCUxMcIxiBAiQTiEUBz0aFVoh8hEcBA48liiIBiwSIA4M4Ow
Date: Mon, 12 May 2014 19:36:31 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] net/wireless/mlme.c: replace memcpy by ether_addr_copy
Message-Id: <20140512193631.248a7ed5ede5537fd973a501@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also fixes some checkpatch warnings.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/wireless/mlme.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index c52ff59..4c43eed 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -31,8 +31,7 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 
 	trace_cfg80211_send_rx_assoc(dev, bss);
 
-	/*
-	 * This is a bit of a hack, we don't notify userspace of
+	/* This is a bit of a hack, we don't notify userspace of
 	 * a (re-)association reply if we tried to send a reassoc
 	 * and got a reject -- we only try again with an assoc
 	 * frame instead of reassoc.
@@ -256,9 +255,9 @@ void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
 		return;
 	}
 
-	p1 = (u8*)(ht_capa);
-	p2 = (u8*)(ht_capa_mask);
-	for (i = 0; i<sizeof(*ht_capa); i++)
+	p1 = (u8 *)(ht_capa);
+	p2 = (u8 *)(ht_capa_mask);
+	for (i = 0; i < sizeof(*ht_capa); i++)
 		p1[i] &= p2[i];
 }
 
@@ -273,8 +272,8 @@ void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
 		return;
 	}
 
-	p1 = (u8*)(vht_capa);
-	p2 = (u8*)(vht_capa_mask);
+	p1 = (u8 *)(vht_capa);
+	p2 = (u8 *)(vht_capa_mask);
 	for (i = 0; i < sizeof(*vht_capa); i++)
 		p1[i] &= p2[i];
 }
@@ -392,7 +391,7 @@ void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 	if (!wdev->current_bss)
 		return;
 
-	memcpy(bssid, wdev->current_bss->pub.bssid, ETH_ALEN);
+	ether_addr_copy(bssid, wdev->current_bss->pub.bssid);
 	cfg80211_mlme_deauth(rdev, dev, bssid, NULL, 0,
 			     WLAN_REASON_DEAUTH_LEAVING, false);
 }
@@ -564,8 +563,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 				break;
 			}
 
-			/*
-			 * check for IBSS DA must be done by driver as
+			/* check for IBSS DA must be done by driver as
 			 * cfg80211 doesn't track the stations
 			 */
 			if (wdev->iftype == NL80211_IFTYPE_ADHOC)
@@ -589,14 +587,12 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 				err = -EINVAL;
 				break;
 			}
-			/*
-			 * check for mesh DA must be done by driver as
+			/* check for mesh DA must be done by driver as
 			 * cfg80211 doesn't track the stations
 			 */
 			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
-			/*
-			 * fall through, P2P device only supports
+			/* fall through, P2P device only supports
 			 * public action frames
 			 */
 		default:
-- 
1.9.1
