Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaHCW5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 18:57:38 -0400
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:45964 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751203AbaHCW5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 18:57:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:69:355:379:541:960:966:968:973:981:982:988:989:1042:1260:1345:1437:1605:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2559:2562:2693:2729:2894:2895:2898:2902:2904:2924:2925:2926:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3874:4037:4225:4250:4321:4384:4385:4395:4423:4605:5007:6261:7208:7576:7862:7875:7903:7904:8603:8829:8957:9010:9038:9121:9164:10004:10026:10848:11026:11232:11233:11657:11914:12043:12294:12296:12438:12517:12519:12555:12663:12679:12681:12698:12737:12740:13972:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tray12_5e3c1ff742729
X-Filterd-Recvd-Size: 162232
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Martin Kepplinger <martink@posteo.de>,
        Larry Finger <larry.finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: rtl8192ee: Fix RT_TRACE #define and uses
Date: Sun,  3 Aug 2014 15:57:26 -0700
Message-Id: <35c4bc55e7a9d8ca74fbc1924e21ebb3b54e2668.1407106168.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RT_TRACE uses require unnecessary parentheses.

Fix the #define and remove the uses.

Neaten the RT_TRACE lines and multi-line argument wrapping.

dynamic debug can add KBUILD_MODNAME and __func__ so remove those
from the #define.

Use a single statement pr_debug instead of pr_debug and pr_cont
which doesn't support dynamic debug anyway.

Miscellaneous grammar and spelling fixes on the RT_TRACE uses.

Compile tested only.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rtl8192ee/base.c                |  76 +++----
 drivers/staging/rtl8192ee/btcoexist/rtl_btc.c   |   9 +-
 drivers/staging/rtl8192ee/cam.c                 |  75 +++----
 drivers/staging/rtl8192ee/core.c                | 154 ++++++-------
 drivers/staging/rtl8192ee/debug.c               |  88 ++++----
 drivers/staging/rtl8192ee/debug.h               |  20 +-
 drivers/staging/rtl8192ee/efuse.c               |  29 ++-
 drivers/staging/rtl8192ee/pci.c                 | 223 +++++++++----------
 drivers/staging/rtl8192ee/ps.c                  |  61 +++---
 drivers/staging/rtl8192ee/rc.c                  |   2 +-
 drivers/staging/rtl8192ee/regd.c                |  12 +-
 drivers/staging/rtl8192ee/rtl8192ee/dm.c        |  46 ++--
 drivers/staging/rtl8192ee/rtl8192ee/fw.c        | 128 ++++++-----
 drivers/staging/rtl8192ee/rtl8192ee/hw.c        | 180 ++++++++-------
 drivers/staging/rtl8192ee/rtl8192ee/led.c       |  16 +-
 drivers/staging/rtl8192ee/rtl8192ee/phy.c       | 279 +++++++++++-------------
 drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.c |  31 ++-
 drivers/staging/rtl8192ee/rtl8192ee/rf.c        |  10 +-
 drivers/staging/rtl8192ee/rtl8192ee/sw.c        |   9 +-
 drivers/staging/rtl8192ee/rtl8192ee/trx.c       |  26 +--
 20 files changed, 693 insertions(+), 781 deletions(-)

diff --git a/drivers/staging/rtl8192ee/base.c b/drivers/staging/rtl8192ee/base.c
index f7c3c8b..2f0fea5 100644
--- a/drivers/staging/rtl8192ee/base.c
+++ b/drivers/staging/rtl8192ee/base.c
@@ -206,7 +206,7 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
 	 *highest supported RX rate
 	 */
 	if (rtlpriv->dm.supp_phymode_switch) {
-		RT_TRACE(COMP_INIT, DBG_EMERG, ("Support phy mode switch\n"));
+		RT_TRACE(COMP_INIT, DBG_EMERG, "Support phy mode switch\n");
 
 		ht_cap->mcs.rx_mask[0] = 0xFF;
 		ht_cap->mcs.rx_mask[1] = 0xFF;
@@ -216,7 +216,7 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
 	} else {
 		if (get_rf_type(rtlphy) == RF_1T2R ||
 		    get_rf_type(rtlphy) == RF_2T2R) {
-			RT_TRACE(COMP_INIT, DBG_DMESG, ("1T2R or 2T2R\n"));
+			RT_TRACE(COMP_INIT, DBG_DMESG, "1T2R or 2T2R\n");
 
 			ht_cap->mcs.rx_mask[0] = 0xFF;
 			ht_cap->mcs.rx_mask[1] = 0xFF;
@@ -224,7 +224,7 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
 
 			ht_cap->mcs.rx_highest = cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS15);
 		} else if (get_rf_type(rtlphy) == RF_1T1R) {
-			RT_TRACE(COMP_INIT, DBG_DMESG, ("1T1R\n"));
+			RT_TRACE(COMP_INIT, DBG_DMESG, "1T1R\n");
 
 			ht_cap->mcs.rx_mask[0] = 0xFF;
 			ht_cap->mcs.rx_mask[1] = 0x00;
@@ -388,7 +388,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
 		} else {
 			RT_TRACE(COMP_INIT, DBG_EMERG,
-				 ("Err BAND %d\n", rtlhal->current_bandtype));
+				 "Err BAND %d\n", rtlhal->current_bandtype);
 		}
 	}
 	/* <5> set hw caps */
@@ -556,7 +556,7 @@ int rtl92e_init_core(struct ieee80211_hw *hw)
 	 * mac80211 hw  in _rtl_init_mac80211.
 	 */
 	if (rtl92e_regd_init(hw, rtl92e_reg_notifier)) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("REGD init failed\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "REGD init failed\n");
 		return 1;
 	}
 
@@ -952,7 +952,7 @@ bool rtl92e_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb)
 			rtlpriv->cfg->ops->check_switch_to_dmdp(hw);
 	}
 	if (ieee80211_is_auth(fc)) {
-		RT_TRACE(COMP_SEND, DBG_DMESG, ("MAC80211_LINKING\n"));
+		RT_TRACE(COMP_SEND, DBG_DMESG, "MAC80211_LINKING\n");
 		rtl92e_ips_nic_on(hw);
 
 		mac->link_state = MAC80211_LINKING;
@@ -987,8 +987,8 @@ bool rtl92e_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 				return false;
 
 			RT_TRACE((COMP_SEND | COMP_RECV), DBG_DMESG,
-				 ("%s ACT_ADDBAREQ From:%pM\n",
-				is_tx ? "Tx" : "Rx", hdr->addr2));
+				 "%s ACT_ADDBAREQ From:%pM\n",
+				 is_tx ? "Tx" : "Rx", hdr->addr2);
 			RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "req\n",
 				      skb->data, skb->len);
 			if (!is_tx) {
@@ -1004,7 +1004,7 @@ bool rtl92e_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 				sta = rtl_find_sta(hw, hdr->addr3);
 				if (sta == NULL) {
 					RT_TRACE((COMP_SEND | COMP_RECV),
-						 DBG_TRACE, ("sta is NULL\n"));
+						 DBG_TRACE, "sta is NULL\n");
 					rcu_read_unlock();
 					return true;
 				}
@@ -1047,12 +1047,12 @@ bool rtl92e_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 			break;
 		case ACT_ADDBARSP:
 			RT_TRACE((COMP_SEND | COMP_RECV), DBG_DMESG,
-				 ("%s ACT_ADDBARSP From :%pM\n",
-				  is_tx ? "Tx" : "Rx", hdr->addr2));
+				 "%s ACT_ADDBARSP From :%pM\n",
+				 is_tx ? "Tx" : "Rx", hdr->addr2);
 			break;
 		case ACT_DELBA:
 			RT_TRACE((COMP_SEND | COMP_RECV), DBG_DMESG,
-				 ("ACT_ADDBADEL From :%pM\n", hdr->addr2));
+				 "ACT_ADDBADEL From :%pM\n", hdr->addr2);
 			break;
 		}
 		break;
@@ -1094,9 +1094,8 @@ u8 rtl92e_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb,
 				 * 68 : UDP BOOTP client
 				 * 67 : UDP BOOTP server
 				 */
-				RT_TRACE((COMP_SEND | COMP_RECV),
-					 DBG_DMESG, ("dhcp %s !!\n",
-						     (is_tx) ? "Tx" : "Rx"));
+				RT_TRACE((COMP_SEND | COMP_RECV), DBG_DMESG,
+					 "dhcp %s !!\n", is_tx ? "Tx" : "Rx");
 
 				if (is_tx) {
 					rtlpriv->ra.is_special_data = true;
@@ -1124,7 +1123,7 @@ u8 rtl92e_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return true;
 	} else if (ETH_P_PAE == ether_type) {
 		RT_TRACE((COMP_SEND | COMP_RECV), DBG_DMESG,
-			 ("802.1X %s EAPOL pkt!!\n", (is_tx) ? "Tx" : "Rx"));
+			 "802.1X %s EAPOL pkt!!\n", is_tx ? "Tx" : "Rx");
 
 		if (is_tx) {
 			rtlpriv->ra.is_special_data = true;
@@ -1165,9 +1164,8 @@ int rtl92e_tx_agg_start(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		return -ENXIO;
 	tid_data = &sta_entry->tids[tid];
 
-	RT_TRACE(COMP_SEND, DBG_DMESG,
-		 ("on ra = %pM tid = %d seq:%d\n", sta->addr, tid,
-		  tid_data->seq_number));
+	RT_TRACE(COMP_SEND, DBG_DMESG, "on ra = %pM tid = %d seq:%d\n",
+		 sta->addr, tid, tid_data->seq_number);
 
 	*ssn = tid_data->seq_number;
 	tid_data->agg.agg_state = RTL_AGG_START;
@@ -1188,12 +1186,12 @@ int rtl92e_tx_agg_stop(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	/* Comparing an array to null is not useful */
 	/*if (!sta->addr) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("ra = NULL\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "ra = NULL\n");
 		return -EINVAL;
 	}*/
 
-	RT_TRACE(COMP_SEND, DBG_DMESG,
-		 ("on ra = %pM tid = %d\n", sta->addr, tid));
+	RT_TRACE(COMP_SEND, DBG_DMESG, "on ra = %pM tid = %d\n",
+		 sta->addr, tid);
 
 	if (unlikely(tid >= MAX_TID_COUNT))
 		return -EINVAL;
@@ -1224,9 +1222,8 @@ int rtl92e_rx_agg_start(struct ieee80211_hw *hw,
 		return -ENXIO;
 	tid_data = &sta_entry->tids[tid];
 
-	RT_TRACE(COMP_RECV, DBG_DMESG,
-		 ("on ra = %pM tid = %d seq:%d\n", sta->addr, tid,
-		 tid_data->seq_number));
+	RT_TRACE(COMP_RECV, DBG_DMESG, "on ra = %pM tid = %d seq:%d\n",
+		 sta->addr, tid, tid_data->seq_number);
 
 	tid_data->agg.rx_agg_state = RTL_RX_AGG_START;
 	return 0;
@@ -1244,12 +1241,12 @@ int rtl92e_rx_agg_stop(struct ieee80211_hw *hw,
 
 	/* Comparing an array to null is not useful */
 	/*if (!sta->addr) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("ra = NULL\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "ra = NULL\n");
 		return -EINVAL;
 	}*/
 
-	RT_TRACE(COMP_SEND, DBG_DMESG,
-		 ("on ra = %pM tid = %d\n", sta->addr, tid));
+	RT_TRACE(COMP_SEND, DBG_DMESG, "on ra = %pM tid = %d\n",
+		 sta->addr, tid);
 
 	if (unlikely(tid >= MAX_TID_COUNT))
 		return -EINVAL;
@@ -1273,12 +1270,12 @@ int rtl92e_tx_agg_oper(struct ieee80211_hw *hw,
 
 	/* Comparing an array to null is not useful */
 	/*if (!sta->addr) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("ra = NULL\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "ra = NULL\n");
 		return -EINVAL;
 	}*/
 
-	RT_TRACE(COMP_SEND, DBG_DMESG,
-		 ("on ra = %pM tid = %d\n", sta->addr, tid));
+	RT_TRACE(COMP_SEND, DBG_DMESG, "on ra = %pM tid = %d\n",
+		 sta->addr, tid);
 
 	if (unlikely(tid >= MAX_TID_COUNT))
 		return -EINVAL;
@@ -1454,15 +1451,14 @@ void rtl92e_watchdog_wq_callback(void *data)
 		if ((rtlpriv->link_info.bcn_rx_inperiod +
 			rtlpriv->link_info.num_rx_inperiod) == 0) {
 			rtlpriv->link_info.roam_times++;
-			RT_TRACE(COMP_ERR, DBG_DMESG,
-				 ("AP off for %d s\n",
-				  (rtlpriv->link_info.roam_times * 2)));
+			RT_TRACE(COMP_ERR, DBG_DMESG, "AP off for %d s\n",
+				 rtlpriv->link_info.roam_times * 2);
 
 			/* if we can't recv beacon for 10s,
 			* we should reconnect this AP */
 			if (rtlpriv->link_info.roam_times >= 5) {
 				RT_TRACE(COMP_ERR, DBG_EMERG,
-					 ("AP off, try to reconnect now\n"));
+					 "AP off, try to reconnect now\n");
 				rtlpriv->link_info.roam_times = 0;
 				ieee80211_connection_loss(
 					rtlpriv->mac80211.vif);
@@ -1793,29 +1789,29 @@ void rtl92e_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len)
 	    (memcmp(mac->bssid, ap5_6, 3) == 0) ||
 		vendor == PEER_ATH) {
 		vendor = PEER_ATH;
-		RT_TRACE(COMP_MAC80211, DBG_LOUD, ("=>ath find\n"));
+		RT_TRACE(COMP_MAC80211, DBG_LOUD, "=>ath find\n");
 	} else if ((memcmp(mac->bssid, ap4_4, 3) == 0) ||
 		   (memcmp(mac->bssid, ap4_5, 3) == 0) ||
 		   (memcmp(mac->bssid, ap4_1, 3) == 0) ||
 		   (memcmp(mac->bssid, ap4_2, 3) == 0) ||
 		   (memcmp(mac->bssid, ap4_3, 3) == 0) ||
 		vendor == PEER_RAL) {
-		RT_TRACE(COMP_MAC80211, DBG_LOUD, ("=>ral findn\n"));
+		RT_TRACE(COMP_MAC80211, DBG_LOUD, "=>ral findn\n");
 		vendor = PEER_RAL;
 	} else if (memcmp(mac->bssid, ap6_1, 3) == 0 ||
 		vendor == PEER_CISCO) {
 		vendor = PEER_CISCO;
-		RT_TRACE(COMP_MAC80211, DBG_LOUD, ("=>cisco find\n"));
+		RT_TRACE(COMP_MAC80211, DBG_LOUD, "=>cisco find\n");
 	} else if ((memcmp(mac->bssid, ap3_1, 3) == 0) ||
 		(memcmp(mac->bssid, ap3_2, 3) == 0) ||
 		(memcmp(mac->bssid, ap3_3, 3) == 0) ||
 		vendor == PEER_BROAD) {
-		RT_TRACE(COMP_MAC80211, DBG_LOUD, ("=>broad find\n"));
+		RT_TRACE(COMP_MAC80211, DBG_LOUD, "=>broad find\n");
 		vendor = PEER_BROAD;
 	} else if (memcmp(mac->bssid, ap7_1, 3) == 0 ||
 		vendor == PEER_MARV) {
 		vendor = PEER_MARV;
-		RT_TRACE(COMP_MAC80211, DBG_LOUD, ("=>marv find\n"));
+		RT_TRACE(COMP_MAC80211, DBG_LOUD, "=>marv find\n");
 	}
 
 	mac->vendor = vendor;
diff --git a/drivers/staging/rtl8192ee/btcoexist/rtl_btc.c b/drivers/staging/rtl8192ee/btcoexist/rtl_btc.c
index 50c012a..e2e3864 100644
--- a/drivers/staging/rtl8192ee/btcoexist/rtl_btc.c
+++ b/drivers/staging/rtl8192ee/btcoexist/rtl_btc.c
@@ -57,17 +57,14 @@ void rtl92e_btc_init_hal_vars(struct rtl_priv *rtlpriv)
 	u8 bt_exist;
 	u8 bt_type;
 	ant_num = rtl92e_get_hwpg_ant_num(rtlpriv);
-	RT_TRACE(COMP_INIT, DBG_DMESG,
-		 ("%s, antNum is %d\n", __func__, ant_num));
+	RT_TRACE(COMP_INIT, DBG_DMESG, "antNum is %d\n", ant_num);
 
 	bt_exist = rtl92e_get_hwpg_bt_exist(rtlpriv);
-	RT_TRACE(COMP_INIT, DBG_DMESG,
-		 ("%s, bt_exist is %d\n", __func__, bt_exist));
+	RT_TRACE(COMP_INIT, DBG_DMESG, "bt_exist is %d\n", bt_exist);
 	exhalbtc92e_set_bt_exist(bt_exist);
 
 	bt_type = rtl92e_get_hwpg_bt_type(rtlpriv);
-	RT_TRACE(COMP_INIT, DBG_DMESG,
-		 ("%s, bt_type is %d\n", __func__, bt_type));
+	RT_TRACE(COMP_INIT, DBG_DMESG, "bt_type is %d\n", bt_type);
 	exhalbtc92e_set_chip_type(bt_type);
 
 	exhalbtc92e_set_ant_num(BT_COEX_ANT_TYPE_PG, ant_num);
diff --git a/drivers/staging/rtl8192ee/cam.c b/drivers/staging/rtl8192ee/cam.c
index e32c329..26f6f90 100644
--- a/drivers/staging/rtl8192ee/cam.c
+++ b/drivers/staging/rtl8192ee/cam.c
@@ -62,14 +62,12 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
 					target_command);
 
-			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE %x: %x\n",
-				  rtlpriv->cfg->maps[WCAMI], target_content));
-			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("The Key ID is %d\n", entry_no));
-			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE %x: %x\n",
-				  rtlpriv->cfg->maps[RWCAM], target_command));
+			RT_TRACE(COMP_SEC, DBG_LOUD, "WRITE %x: %x\n",
+				 rtlpriv->cfg->maps[WCAMI], target_content);
+			RT_TRACE(COMP_SEC, DBG_LOUD, "The Key ID is %d\n",
+				 entry_no);
+			RT_TRACE(COMP_SEC, DBG_LOUD, "WRITE %x: %x\n",
+				 rtlpriv->cfg->maps[RWCAM], target_command);
 		} else if (entry_i == 1) {
 			target_content = (u32) (*(mac_addr + 5)) << 24 |
 			    (u32) (*(mac_addr + 4)) << 16 |
@@ -81,10 +79,10 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
 					target_command);
 
-			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE A4: %x\n", target_content));
-			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE A0: %x\n", target_command));
+			RT_TRACE(COMP_SEC, DBG_LOUD, "WRITE A4: %x\n",
+				 target_content);
+			RT_TRACE(COMP_SEC, DBG_LOUD, "WRITE A0: %x\n",
+				 target_command);
 		} else {
 			target_content =
 			    (u32) (*(key_cont_128 + (entry_i * 4 - 8) + 3)) <<
@@ -99,15 +97,14 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 					target_command);
 			udelay(100);
 
-			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE A4: %x\n", target_content));
-			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE A0: %x\n", target_command));
+			RT_TRACE(COMP_SEC, DBG_LOUD, "WRITE A4: %x\n",
+				 target_content);
+			RT_TRACE(COMP_SEC, DBG_LOUD, "WRITE A0: %x\n",
+				 target_command);
 		}
 	}
 
-	RT_TRACE(COMP_SEC, DBG_LOUD,
-		 ("after set key, usconfig:%x\n", us_config));
+	RT_TRACE(COMP_SEC, DBG_LOUD, "after set key, usconfig:%x\n", us_config);
 }
 
 u8 stg_rtl_cam_add_one_entry(struct ieee80211_hw *hw, u8 *mac_addr,
@@ -118,13 +115,11 @@ u8 stg_rtl_cam_add_one_entry(struct ieee80211_hw *hw, u8 *mac_addr,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("EntryNo:%x, ulKeyId=%x, ulEncAlg=%x, ulUseDK=%x MacAddr %pM\n",
-		  ul_entry_idx, ul_key_id, ul_enc_alg,
-		  ul_default_key, mac_addr));
+		 "EntryNo:%x, ulKeyId=%x, ulEncAlg=%x, ulUseDK=%x MacAddr %pM\n",
+		 ul_entry_idx, ul_key_id, ul_enc_alg, ul_default_key, mac_addr);
 
 	if (ul_key_id == TOTAL_CAM_ENTRY) {
-		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("ulKeyId exceed!\n"));
+		RT_TRACE(COMP_ERR, DBG_WARNING, "ulKeyId exceed!\n");
 		return 0;
 	}
 
@@ -136,7 +131,7 @@ u8 stg_rtl_cam_add_one_entry(struct ieee80211_hw *hw, u8 *mac_addr,
 	rtl_cam_program_entry(hw, ul_entry_idx, mac_addr,
 			      (u8 *)key_content, us_config);
 
-	RT_TRACE(COMP_SEC, DBG_DMESG, ("end\n"));
+	RT_TRACE(COMP_SEC, DBG_DMESG, "end\n");
 
 	return 1;
 }
@@ -148,7 +143,7 @@ int stg_rtl_cam_delete_one_entry(struct ieee80211_hw *hw,
 	u32 ul_command;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	RT_TRACE(COMP_SEC, DBG_DMESG, ("key_idx:%d\n", ul_key_id));
+	RT_TRACE(COMP_SEC, DBG_DMESG, "key_idx:%d\n", ul_key_id);
 
 	ul_command = ul_key_id * CAM_CONTENT_COUNT;
 	ul_command = ul_command | BIT(31) | BIT(16);
@@ -157,10 +152,10 @@ int stg_rtl_cam_delete_one_entry(struct ieee80211_hw *hw,
 	rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("stg_rtl_cam_delete_one_entry(): WRITE A4: %x\n", 0));
+		 "stg_rtl_cam_delete_one_entry(): WRITE A4: %x\n", 0);
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("stg_rtl_cam_delete_one_entry(): WRITE A0: %x\n",
-		  ul_command));
+		 "stg_rtl_cam_delete_one_entry(): WRITE A0: %x\n",
+		 ul_command);
 	return 0;
 }
 EXPORT_SYMBOL(stg_rtl_cam_delete_one_entry);
@@ -210,9 +205,9 @@ void stg_rtl_cam_mark_invalid(struct ieee80211_hw *hw, u8 uc_index)
 	rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("stg_rtl_cam_mark_invalid(): WRITE A4: %x\n", ul_content));
+		 "stg_rtl_cam_mark_invalid(): WRITE A4: %x\n", ul_content);
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("stg_rtl_cam_mark_invalid(): WRITE A0: %x\n", ul_command));
+		 "stg_rtl_cam_mark_invalid(): WRITE A0: %x\n", ul_command);
 }
 EXPORT_SYMBOL(stg_rtl_cam_mark_invalid);
 
@@ -259,11 +254,11 @@ void stg_rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
 		rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 
 		RT_TRACE(COMP_SEC, DBG_LOUD,
-			 ("stg_rtl_cam_empty_entry(): WRITE A4: %x\n",
-			  ul_content));
+			 "stg_rtl_cam_empty_entry(): WRITE A4: %x\n",
+			  ul_content);
 		RT_TRACE(COMP_SEC, DBG_LOUD,
-			 ("stg_rtl_cam_empty_entry(): WRITE A0: %x\n",
-			  ul_command));
+			 "stg_rtl_cam_empty_entry(): WRITE A0: %x\n",
+			 ul_command);
 	}
 }
 EXPORT_SYMBOL(stg_rtl_cam_empty_entry);
@@ -276,8 +271,7 @@ u8 stg_rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 	u8 i, *addr;
 
 	if (!sta_addr) {
-		RT_TRACE(COMP_SEC, DBG_EMERG,
-			 ("sta_addr is NULL\n"));
+		RT_TRACE(COMP_SEC, DBG_EMERG, "sta_addr is NULL\n");
 		return TOTAL_CAM_ENTRY;
 	}
 	/* Does STA already exist? */
@@ -290,8 +284,8 @@ u8 stg_rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 	for (entry_idx = 4; entry_idx < TOTAL_CAM_ENTRY; entry_idx++) {
 		if ((bitmap & BIT(0)) == 0) {
 			RT_TRACE(COMP_SEC, DBG_EMERG,
-				 ("-----hwsec_cam_bitmap: 0x%x entry_idx=%d\n",
-					  rtlpriv->sec.hwsec_cam_bitmap, entry_idx));
+				 "-----hwsec_cam_bitmap: 0x%x entry_idx=%d\n",
+				 rtlpriv->sec.hwsec_cam_bitmap, entry_idx);
 			rtlpriv->sec.hwsec_cam_bitmap |= BIT(0) << entry_idx;
 			memcpy(rtlpriv->sec.hwsec_cam_sta_addr[entry_idx],
 			       sta_addr, ETH_ALEN);
@@ -310,14 +304,13 @@ void stg_rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 	u8 i, *addr;
 
 	if (NULL == sta_addr) {
-		RT_TRACE(COMP_SEC, DBG_EMERG,
-			 ("sta_addr is NULL.\n"));
+		RT_TRACE(COMP_SEC, DBG_EMERG, "sta_addr is NULL\n");
 		return;
 	}
 
 	if (is_zero_ether_addr(sta_addr)) {
 		RT_TRACE(COMP_SEC, DBG_EMERG,
-			 ("sta_addr is 00:00:00:00:00:00.\n"));
+			 "sta_addr is 00:00:00:00:00:00\n");
 		return;
 	}
 	/* Does STA already exist? */
diff --git a/drivers/staging/rtl8192ee/core.c b/drivers/staging/rtl8192ee/core.c
index 7f6accd..71aa241 100644
--- a/drivers/staging/rtl8192ee/core.c
+++ b/drivers/staging/rtl8192ee/core.c
@@ -124,7 +124,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 
 	if (mac->vif) {
 		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("vif has been set!! mac->vif = 0x%p\n", mac->vif));
+			 "vif has been set!! mac->vif = 0x%p\n", mac->vif);
 		return -EOPNOTSUPP;
 	}
 
@@ -140,15 +140,14 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_STATION:
 		if (mac->beacon_enabled == 1) {
 			RT_TRACE(COMP_MAC80211, DBG_LOUD,
-				 ("NL80211_IFTYPE_STATION\n"));
+				 "NL80211_IFTYPE_STATION\n");
 			mac->beacon_enabled = 0;
 			rtlpriv->cfg->ops->update_interrupt_mask(hw, 0,
 					rtlpriv->cfg->maps[RTL_IBSS_INT_MASKS]);
 		}
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		RT_TRACE(COMP_MAC80211, DBG_LOUD,
-			 ("NL80211_IFTYPE_ADHOC\n"));
+		RT_TRACE(COMP_MAC80211, DBG_LOUD, "NL80211_IFTYPE_ADHOC\n");
 		mac->link_state = MAC80211_LINKED;
 		rtlpriv->cfg->ops->set_bcn_reg(hw);
 		if (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G)
@@ -162,8 +161,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 		mac->p2p = P2P_ROLE_GO;
 		/*fall through*/
 	case NL80211_IFTYPE_AP:
-		RT_TRACE(COMP_MAC80211, DBG_LOUD,
-			 ("NL80211_IFTYPE_AP\n"));
+		RT_TRACE(COMP_MAC80211, DBG_LOUD, "NL80211_IFTYPE_AP\n");
 
 		mac->link_state = MAC80211_LINKED;
 		rtlpriv->cfg->ops->set_bcn_reg(hw);
@@ -176,7 +174,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		RT_TRACE(COMP_MAC80211, DBG_LOUD,
-			 ("NL80211_IFTYPE_MESH_POINT\n"));
+			 "NL80211_IFTYPE_MESH_POINT\n");
 
 		mac->link_state = MAC80211_LINKED;
 		rtlpriv->cfg->ops->set_bcn_reg(hw);
@@ -189,7 +187,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 		break;
 	default:
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("operation mode %d is not support!\n", vif->type));
+			 "operation mode %d is not support!\n", vif->type);
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -200,8 +198,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 #endif
 
 	if (mac->p2p) {
-		RT_TRACE(COMP_MAC80211, DBG_LOUD,
-			 ("p2p role %x\n", vif->type));
+		RT_TRACE(COMP_MAC80211, DBG_LOUD, "p2p role %x\n", vif->type);
 		mac->basic_rates = 0xff0;/*disable cck rate for p2p*/
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 				(u8 *)(&mac->basic_rates));
@@ -262,8 +259,7 @@ static int rtl_op_change_interface(struct ieee80211_hw *hw,
 	vif->type = new_type;
 	vif->p2p = p2p;
 	ret = rtl_op_add_interface(hw, vif);
-	RT_TRACE(COMP_MAC80211, DBG_LOUD,
-		 (" p2p  %x\n", p2p));
+	RT_TRACE(COMP_MAC80211, DBG_LOUD, " p2p  %x\n", p2p);
 	return ret;
 }
 
@@ -336,7 +332,7 @@ static void _rtl_add_wowlan_patterns(struct ieee80211_hw *hw,
 		memset(mask, 0, MAX_WOL_BIT_MASK_SIZE);
 		if (patterns[i].pattern_len > MAX_WOL_PATTERN_SIZE) {
 			RT_TRACE(COMP_POWER, DBG_WARNING,
-				 ("Pattern[%d] is too long\n", i));
+				 "Pattern[%d] is too long\n", i);
 			continue;
 		}
 		pattern_os = patterns[i].pattern;
@@ -414,8 +410,8 @@ static void _rtl_add_wowlan_patterns(struct ieee80211_hw *hw,
 			      "pattern to hw\n", content, len);
 		/* 3. calculate crc */
 		rtl_pattern.crc = _calculate_wol_pattern_crc(content, len);
-		RT_TRACE(COMP_POWER, DBG_TRACE,
-			 ("CRC_Remainder = 0x%x", rtl_pattern.crc));
+		RT_TRACE(COMP_POWER, DBG_TRACE, "CRC_Remainder = 0x%x\n",
+			 rtl_pattern.crc);
 
 		/* 4. write crc & mask_for_hw to hw */
 		rtlpriv->cfg->ops->add_wowlan_pattern(hw, &rtl_pattern, i);
@@ -431,7 +427,7 @@ static int rtl_op_suspend(struct ieee80211_hw *hw,
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct timeval ts;
 
-	RT_TRACE(COMP_POWER, DBG_DMESG, ("\n"));
+	RT_TRACE(COMP_POWER, DBG_DMESG, "\n");
 	if (WARN_ON(!wow))
 		return -EINVAL;
 
@@ -458,7 +454,7 @@ static int rtl_op_resume(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct timeval ts;
 
-	RT_TRACE(COMP_POWER, DBG_DMESG, ("\n"));
+	RT_TRACE(COMP_POWER, DBG_DMESG, "\n");
 	rtlhal->driver_is_goingto_unload = false;
 	rtlhal->b_enter_pnp_sleep = false;
 	rtlhal->b_wake_from_pnp_sleep = true;
@@ -491,7 +487,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&rtlpriv->locks.conf_mutex);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {	/* BIT(2) */
 		RT_TRACE(COMP_MAC80211, DBG_LOUD,
-			 ("IEEE80211_CONF_CHANGE_LISTEN_INTERVAL\n"));
+			 "IEEE80211_CONF_CHANGE_LISTEN_INTERVAL\n");
 	}
 
 	/*For IPS */
@@ -534,8 +530,8 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
 		RT_TRACE(COMP_MAC80211, DBG_LOUD,
-			 ("IEEE80211_CONF_CHANGE_RETRY_LIMITS %x\n",
-			  hw->conf.long_frame_max_tx_count));
+			 "IEEE80211_CONF_CHANGE_RETRY_LIMITS %x\n",
+			 hw->conf.long_frame_max_tx_count);
 		mac->retry_long = hw->conf.long_frame_max_tx_count;
 		mac->retry_short = hw->conf.long_frame_max_tx_count;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
@@ -650,7 +646,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 				mac->bw_40 = false;
 				mac->bw_80 = false;
 				RT_TRACE(COMP_ERR, DBG_EMERG,
-					 ("switch case not processed\n"));
+					 "switch case not processed\n");
 				break;
 			}
 		}
@@ -700,12 +696,12 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_AM] |
 			    rtlpriv->cfg->maps[MAC_RCR_AB];
 			RT_TRACE(COMP_MAC80211, DBG_LOUD,
-				 ("Enable receive multicast frame.\n"));
+				 "Enable receive multicast frame\n");
 		} else {
 			mac->rx_conf &= ~(rtlpriv->cfg->maps[MAC_RCR_AM] |
 					  rtlpriv->cfg->maps[MAC_RCR_AB]);
 			RT_TRACE(COMP_MAC80211, DBG_LOUD,
-				 ("Disable receive multicast frame.\n"));
+				 "Disable receive multicast frame\n");
 		}
 	}
 
@@ -713,11 +709,11 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 		if (*new_flags & FIF_FCSFAIL) {
 			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_ACRC32];
 			RT_TRACE(COMP_MAC80211, DBG_LOUD,
-				 ("Enable receive FCS error frame.\n"));
+				 "Enable receive FCS error frame\n");
 		} else {
 			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACRC32];
 			RT_TRACE(COMP_MAC80211, DBG_LOUD,
-				 ("Disable receive FCS error frame.\n"));
+				 "Disable receive FCS error frame\n");
 		}
 	}
 
@@ -740,11 +736,11 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_ACF];
 
 			RT_TRACE(COMP_MAC80211, DBG_LOUD,
-				 ("Enable receive control frame.\n"));
+				 "Enable receive control frame\n");
 		} else {
 			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACF];
 			RT_TRACE(COMP_MAC80211, DBG_LOUD,
-				 ("Disable receive control frame.\n"));
+				 "Disable receive control frame\n");
 		}
 	}
 
@@ -752,11 +748,11 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 		if (*new_flags & FIF_OTHER_BSS) {
 			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_AAP];
 			RT_TRACE(COMP_MAC80211, DBG_LOUD,
-				 ("Enable receive other BSS's frame.\n"));
+				 "Enable receive other BSS's frame\n");
 		} else {
 			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_AAP];
 			RT_TRACE(COMP_MAC80211, DBG_LOUD,
-				 ("Disable receive other BSS's frame.\n"));
+				 "Disable receive other BSS's frame\n");
 		}
 	}
 }
@@ -798,8 +794,8 @@ static int rtl_op_sta_add(struct ieee80211_hw *hw,
 			sta->supp_rates[0] &= 0xfffffff0;
 
 		ether_addr_copy(sta_entry->mac_addr, sta->addr);
-		RT_TRACE(COMP_MAC80211, DBG_DMESG,
-			 ("Add sta addr is %pM\n", sta->addr));
+		RT_TRACE(COMP_MAC80211, DBG_DMESG, "Add sta addr is %pM\n",
+			 sta->addr);
 		rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
 	}
 
@@ -813,8 +809,8 @@ static int rtl_op_sta_remove(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_sta_info *sta_entry;
 	if (sta) {
-		RT_TRACE(COMP_MAC80211, DBG_DMESG,
-			 ("Remove sta addr is %pM\n", sta->addr));
+		RT_TRACE(COMP_MAC80211, DBG_DMESG, "Remove sta addr is %pM\n",
+			 sta->addr);
 		sta_entry = (struct rtl_sta_info *)sta->drv_priv;
 		sta_entry->wireless_mode = 0;
 		sta_entry->ratr_index = 0;
@@ -862,7 +858,7 @@ static int rtl_op_conf_tx(struct ieee80211_hw *hw,
 
 	if (queue >= AC_MAX) {
 		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("queue number %d is incorrect!\n", queue));
+			 "queue number %d is incorrect!\n", queue);
 		return -EINVAL;
 	}
 
@@ -895,7 +891,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		     bss_conf->enable_beacon)) {
 			if (mac->beacon_enabled == 0) {
 				RT_TRACE(COMP_MAC80211, DBG_DMESG,
-					 ("BSS_CHANGED_BEACON_ENABLED\n"));
+					 "BSS_CHANGED_BEACON_ENABLED\n");
 
 				/*start hw beacon interrupt. */
 				/*rtlpriv->cfg->ops->set_bcn_reg(hw); */
@@ -912,7 +908,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		    !bss_conf->enable_beacon) {
 			if (mac->beacon_enabled == 1) {
 				RT_TRACE(COMP_MAC80211, DBG_DMESG,
-					 ("ADHOC DISABLE BEACON\n"));
+					 "ADHOC DISABLE BEACON\n");
 
 				mac->beacon_enabled = 0;
 				rtlpriv->cfg->ops->update_interrupt_mask(hw, 0,
@@ -922,7 +918,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 		if (changed & BSS_CHANGED_BEACON_INT) {
 			RT_TRACE(COMP_BEACON, DBG_TRACE,
-				 ("BSS_CHANGED_BEACON_INT\n"));
+				 "BSS_CHANGED_BEACON_INT\n");
 			mac->beacon_interval = bss_conf->beacon_int;
 			rtlpriv->cfg->ops->set_bcn_intv(hw);
 		}
@@ -965,7 +961,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 			if (vif->type == NL80211_IFTYPE_STATION && sta)
 				rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
 			RT_TRACE(COMP_EASY_CONCURRENT, DBG_LOUD,
-				 ("send PS STATIC frame\n"));
+				 "send PS STATIC frame\n");
 			if (rtlpriv->dm.supp_phymode_switch) {
 				if (sta->ht_cap.ht_supported)
 					stg_rtl_send_smps_action(hw, sta,
@@ -1003,7 +999,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 						      (u8 *)(&keep_alive));
 
 			RT_TRACE(COMP_MAC80211, DBG_DMESG,
-				 ("BSS_CHANGED_ASSOC\n"));
+				 "BSS_CHANGED_ASSOC\n");
 		} else {
 			mstatus = RT_MEDIA_DISCONNECT;
 
@@ -1021,7 +1017,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 					rtlpriv->cfg->ops->check_switch_to_dmdp(hw);
 			}
 			RT_TRACE(COMP_MAC80211, DBG_DMESG,
-				 ("BSS_CHANGED_UN_ASSOC\n"));
+				 "BSS_CHANGED_UN_ASSOC\n");
 		}
 		rtlpriv->cfg->ops->set_network_type(hw, vif->type);
 		/* For FW LPS:
@@ -1039,14 +1035,14 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
 		RT_TRACE(COMP_MAC80211, DBG_TRACE,
-			 ("BSS_CHANGED_ERP_CTS_PROT\n"));
+			 "BSS_CHANGED_ERP_CTS_PROT\n");
 		mac->use_cts_protect = bss_conf->use_cts_prot;
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		RT_TRACE(COMP_MAC80211, DBG_LOUD,
-			 ("BSS_CHANGED_ERP_PREAMBLE use short preamble:%x\n",
-			  bss_conf->use_short_preamble));
+			 "BSS_CHANGED_ERP_PREAMBLE use short preamble:%x\n",
+			 bss_conf->use_short_preamble);
 
 		mac->short_preamble = bss_conf->use_short_preamble;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ACK_PREAMBLE,
@@ -1054,8 +1050,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
-		RT_TRACE(COMP_MAC80211, DBG_TRACE,
-			 ("BSS_CHANGED_ERP_SLOT\n"));
+		RT_TRACE(COMP_MAC80211, DBG_TRACE, "BSS_CHANGED_ERP_SLOT\n");
 
 		if (bss_conf->use_short_slot)
 			mac->slot_time = RTL_SLOT_TIME_9;
@@ -1069,8 +1064,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_HT) {
 		struct ieee80211_sta *sta = NULL;
 
-		RT_TRACE(COMP_MAC80211, DBG_TRACE,
-			 ("BSS_CHANGED_HT\n"));
+		RT_TRACE(COMP_MAC80211, DBG_TRACE, "BSS_CHANGED_HT\n");
 
 		rcu_read_lock();
 		sta = ieee80211_find_sta(vif, (u8 *)bss_conf->bssid);
@@ -1101,8 +1095,8 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BSSID,
 					      (u8 *)bss_conf->bssid);
 
-		RT_TRACE(COMP_MAC80211, DBG_DMESG,
-			 ("bssid: %pM\n", bss_conf->bssid));
+		RT_TRACE(COMP_MAC80211, DBG_DMESG, "bssid: %pM\n",
+			 bss_conf->bssid);
 
 		mac->vendor = PEER_UNKNOWN;
 		memcpy(mac->bssid, bss_conf->bssid, 6);
@@ -1231,34 +1225,34 @@ static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
 		RT_TRACE(COMP_MAC80211, DBG_TRACE,
-			 ("IEEE80211_AMPDU_TX_START: TID:%d\n", tid));
+			 "IEEE80211_AMPDU_TX_START: TID:%d\n", tid);
 		return rtl92e_tx_agg_start(hw, vif, sta, tid, ssn);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		RT_TRACE(COMP_MAC80211, DBG_TRACE,
-			 ("IEEE80211_AMPDU_TX_STOP: TID:%d\n", tid));
+			 "IEEE80211_AMPDU_TX_STOP: TID:%d\n", tid);
 		return rtl92e_tx_agg_stop(hw, vif, sta, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		RT_TRACE(COMP_MAC80211, DBG_TRACE,
-			 ("IEEE80211_AMPDU_TX_OPERATIONAL:TID:%d\n", tid));
+			 "IEEE80211_AMPDU_TX_OPERATIONAL:TID:%d\n", tid);
 		rtl92e_tx_agg_oper(hw, sta, tid);
 		break;
 	case IEEE80211_AMPDU_RX_START:
 		RT_TRACE(COMP_MAC80211, DBG_TRACE,
-			 ("IEEE80211_AMPDU_RX_START:TID:%d\n", tid));
+			 "IEEE80211_AMPDU_RX_START:TID:%d\n", tid);
 		return rtl92e_rx_agg_start(hw, sta, tid);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		RT_TRACE(COMP_MAC80211, DBG_TRACE,
-			 ("IEEE80211_AMPDU_RX_STOP:TID:%d\n", tid));
+			 "IEEE80211_AMPDU_RX_STOP:TID:%d\n", tid);
 		return rtl92e_rx_agg_stop(hw, sta, tid);
 		break;
 	default:
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("IEEE80211_AMPDU_ERR!!!!:\n"));
+			 "IEEE80211_AMPDU_ERR!!!!:\n");
 		return -EOPNOTSUPP;
 	}
 	return 0;
@@ -1269,7 +1263,7 @@ static void rtl_op_sw_scan_start(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
-	RT_TRACE(COMP_MAC80211, DBG_LOUD, ("\n"));
+	RT_TRACE(COMP_MAC80211, DBG_LOUD, "\n");
 	mac->act_scanning = true;
 	if (rtlpriv->link_info.b_higher_busytraffic) {
 		mac->skip_scan = true;
@@ -1303,7 +1297,7 @@ static void rtl_op_sw_scan_complete(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
-	RT_TRACE(COMP_MAC80211, DBG_LOUD, ("\n"));
+	RT_TRACE(COMP_MAC80211, DBG_LOUD, "\n");
 	mac->act_scanning = false;
 	mac->skip_scan = false;
 	if (rtlpriv->link_info.b_higher_busytraffic)
@@ -1345,8 +1339,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	if (rtlpriv->cfg->mod_params->sw_crypto || rtlpriv->sec.use_sw_sec) {
-		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("not open hw encryption\n"));
+		RT_TRACE(COMP_ERR, DBG_WARNING, "not open hw encryption\n");
 		return -ENOSPC;	/*User disabled HW-crypto */
 	}
 	/* To support IBSS, use sw-crypto for GTK */
@@ -1355,9 +1348,9 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	     !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
 		return -ENOSPC;
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("%s hardware based encryption for keyidx: %d, mac: %pM\n",
-		  cmd == SET_KEY ? "Using" : "Disabling", key->keyidx,
-		  sta ? sta->addr : bcast_addr));
+		 "%s hardware based encryption for keyidx: %d, mac: %pM\n",
+		 cmd == SET_KEY ? "Using" : "Disabling", key->keyidx,
+		 sta ? sta->addr : bcast_addr);
 	rtlpriv->sec.being_setkey = true;
 	rtl92e_ips_nic_on(hw);
 	mutex_lock(&rtlpriv->locks.conf_mutex);
@@ -1366,32 +1359,31 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 		key_type = WEP40_ENCRYPTION;
-		RT_TRACE(COMP_SEC, DBG_DMESG, ("alg:WEP40\n"));
+		RT_TRACE(COMP_SEC, DBG_DMESG, "alg:WEP40\n");
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
-		RT_TRACE(COMP_SEC, DBG_DMESG, ("alg:WEP104\n"));
+		RT_TRACE(COMP_SEC, DBG_DMESG, "alg:WEP104\n");
 		key_type = WEP104_ENCRYPTION;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		key_type = TKIP_ENCRYPTION;
-		RT_TRACE(COMP_SEC, DBG_DMESG, ("alg:TKIP\n"));
+		RT_TRACE(COMP_SEC, DBG_DMESG, "alg:TKIP\n");
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key_type = AESCCMP_ENCRYPTION;
-		RT_TRACE(COMP_SEC, DBG_DMESG, ("alg:CCMP\n"));
+		RT_TRACE(COMP_SEC, DBG_DMESG, "alg:CCMP\n");
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		/* HW don't support CMAC encryption,
 		 * use software CMAC encryption */
 		key_type = AESCMAC_ENCRYPTION;
-		RT_TRACE(COMP_SEC, DBG_DMESG, ("alg:CMAC\n"));
+		RT_TRACE(COMP_SEC, DBG_DMESG, "alg:CMAC\n");
 		RT_TRACE(COMP_SEC, DBG_DMESG,
-			 ("HW don't support CMAC encrypiton, use software CMAC encryption\n"));
+			 "HW don't support CMAC encrypiton, use software CMAC encryption\n");
 		err = -EOPNOTSUPP;
 		goto out_unlock;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("alg_err:%x!!!!:\n", key->cipher));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "alg_err:%x!!!!:\n", key->cipher);
 		goto out_unlock;
 	}
 	if (key_type == WEP40_ENCRYPTION ||
@@ -1434,8 +1426,8 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 				wep_only = true;
 			rtlpriv->sec.pairwise_enc_algorithm = key_type;
 			RT_TRACE(COMP_SEC, DBG_DMESG,
-				 ("set enable_hw_sec, key_type:%x(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)\n",
-				  key_type));
+				 "set enable_hw_sec, key_type:%x(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)\n",
+				 key_type);
 			rtlpriv->cfg->ops->enable_hw_sec(hw);
 		}
 	}
@@ -1444,7 +1436,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case SET_KEY:
 		if (wep_only) {
 			RT_TRACE(COMP_SEC, DBG_DMESG,
-				 ("set WEP(group/pairwise) key\n"));
+				 "set WEP(group/pairwise) key\n");
 			/* Pairwise key with an assigned MAC address. */
 			rtlpriv->sec.pairwise_enc_algorithm = key_type;
 			rtlpriv->sec.group_enc_algorithm = key_type;
@@ -1454,8 +1446,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			rtlpriv->sec.key_len[key_idx] = key->keylen;
 			eth_zero_addr(mac_addr);
 		} else if (group_key) {	/* group key */
-			RT_TRACE(COMP_SEC, DBG_DMESG,
-				 ("set group key\n"));
+			RT_TRACE(COMP_SEC, DBG_DMESG, "set group key\n");
 			/* group key */
 			rtlpriv->sec.group_enc_algorithm = key_type;
 			/*set local buf about group key. */
@@ -1464,8 +1455,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			rtlpriv->sec.key_len[key_idx] = key->keylen;
 			ether_addr_copy(mac_addr, bcast_addr);
 		} else {	/* pairwise key */
-			RT_TRACE(COMP_SEC, DBG_DMESG,
-				 ("set pairwise key\n"));
+			RT_TRACE(COMP_SEC, DBG_DMESG, "set pairwise key\n");
 			if (!sta) {
 				RT_ASSERT(false,
 					  ("pairwise key without mac_addr\n"));
@@ -1497,8 +1487,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
 		break;
 	case DISABLE_KEY:
-		RT_TRACE(COMP_SEC, DBG_DMESG,
-			 ("disable key delete one entry\n"));
+		RT_TRACE(COMP_SEC, DBG_DMESG, "disable key delete one entry\n");
 		/*set local buf about wep key. */
 		if (vif->type == NL80211_IFTYPE_AP ||
 		    vif->type == NL80211_IFTYPE_MESH_POINT) {
@@ -1516,8 +1505,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		stg_rtl_cam_delete_one_entry(hw, mac_addr, key_idx);
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("cmd_err:%x!!!!:\n", cmd));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "cmd_err:%x!!!!:\n", cmd);
 	}
 out_unlock:
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
@@ -1546,8 +1534,8 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
 			rtlpriv->rfkill.rfkill_state = radio_state;
 
 			RT_TRACE(COMP_RF, DBG_DMESG,
-				 (KERN_INFO "wireless radio switch turned %s\n",
-				  radio_state ? "on" : "off"));
+				 "wireless radio switch turned %s\n",
+				 radio_state ? "on" : "off");
 
 			blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;
 			wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
diff --git a/drivers/staging/rtl8192ee/debug.c b/drivers/staging/rtl8192ee/debug.c
index feec394..d32730c 100644
--- a/drivers/staging/rtl8192ee/debug.c
+++ b/drivers/staging/rtl8192ee/debug.c
@@ -779,9 +779,9 @@ void rtl_proc_add_one(struct ieee80211_hw *hw)
 	rtlpriv->dbg.proc_dir = proc_mkdir(rtlpriv->dbg.proc_name, proc_topdir);
 	if (!rtlpriv->dbg.proc_dir) {
 		RT_TRACE(COMP_INIT, DBG_EMERG,
-			 ("Unable to init /proc/net/%s/%s\n",
+			 "Unable to init /proc/net/%s/%s\n",
 			  rtlpriv->cfg->name,
-			  rtlpriv->dbg.proc_name));
+			  rtlpriv->dbg.proc_name);
 		return;
 	}
 
@@ -789,148 +789,148 @@ void rtl_proc_add_one(struct ieee80211_hw *hw)
 				 rtlpriv->dbg.proc_dir, &file_ops_mac_0, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, DBG_EMERG,
-			 ("Unable to initialize /proc/net/%s/%s/mac-0\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/mac-0\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("mac-1", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_mac_1, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/mac-1\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/mac-1\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("mac-2", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_mac_2, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/mac-2\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/mac-2\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("mac-3", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_mac_3, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/mac-3\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/mac-3\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("mac-4", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_mac_4, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/mac-4\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/mac-4\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("mac-5", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_mac_5, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/mac-5\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/mac-5\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("mac-6", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_mac_6, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/mac-6\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/mac-6\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("mac-7", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_mac_7, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/mac-7\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/mac-7\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("bb-8", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_bb_8, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/bb-8\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/bb-8\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("bb-9", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_bb_9, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/bb-9\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/bb-9\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("bb-a", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_bb_a, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/bb-a\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/bb-a\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("bb-b", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_bb_b, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/bb-b\n",
-		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/bb-b\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("bb-c", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_bb_c, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/bb-c\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/bb-c\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("bb-d", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_bb_d, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/bb-d\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/bb-d\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("bb-e", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_bb_e, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/bb-e\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/bb-e\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("bb-f", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_bb_f, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/bb-f\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/bb-f\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("rf-a", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_rf_a, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/rf-a\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/rf-a\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("rf-b", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_rf_b, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/rf-b\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/rf-b\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("cam-1", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_cam_1, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/cam-1\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/cam-1\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("cam-2", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_cam_2, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/cam-2\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/cam-2\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 
 	entry = proc_create_data("cam-3", S_IFREG | S_IRUGO,
 				 rtlpriv->dbg.proc_dir, &file_ops_cam_3, hw);
 	if (!entry)
 		RT_TRACE(COMP_INIT, COMP_ERR,
-			 ("Unable to initialize /proc/net/%s/%s/cam-3\n",
-			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+			 "Unable to initialize /proc/net/%s/%s/cam-3\n",
+			  rtlpriv->cfg->name, rtlpriv->dbg.proc_name);
 }
 
 void rtl_proc_remove_one(struct ieee80211_hw *hw)
diff --git a/drivers/staging/rtl8192ee/debug.h b/drivers/staging/rtl8192ee/debug.h
index 093128d..26857b7 100644
--- a/drivers/staging/rtl8192ee/debug.h
+++ b/drivers/staging/rtl8192ee/debug.h
@@ -171,17 +171,15 @@ enum dbgp_flag_e {
 		} \
 	} while (0)
 
-#define RT_TRACE(comp, level, fmt)\
-	do { \
-		if (unlikely(((comp) & rtlpriv->dbg.global_debugcomponents) && \
-			((level) <= rtlpriv->dbg.global_debuglevel))) {\
-			pr_debug("%s-%d:%s():<%lx> ", \
-			KBUILD_MODNAME, \
-			rtlpriv->rtlhal.interfaceindex, __func__, \
-			in_interrupt());	\
-			pr_cont fmt;			\
-		} \
-	} while (0)
+#define RT_TRACE(comp, level, fmt, ...)					\
+do {									\
+	if (unlikely(((comp) & rtlpriv->dbg.global_debugcomponents) &&	\
+		     ((level) <= rtlpriv->dbg.global_debuglevel))) {	\
+		pr_debug("%d:<%lx> " fmt,				\
+			 rtlpriv->rtlhal.interfaceindex,		\
+			 in_interrupt(), ##__VA_ARGS__);		\
+	}								\
+} while (0)
 
 #define RTPRINT(rtlpriv, dbgtype, dbgflag, fmt, ...)			\
 do {									\
diff --git a/drivers/staging/rtl8192ee/efuse.c b/drivers/staging/rtl8192ee/efuse.c
index 3fae183..ba39f10 100644
--- a/drivers/staging/rtl8192ee/efuse.c
+++ b/drivers/staging/rtl8192ee/efuse.c
@@ -151,8 +151,7 @@ void efuse92e_write_1byte(struct ieee80211_hw *hw, u16 address, u8 value)
 	const u32 efuse_real_content_len =
 		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
 
-	RT_TRACE(COMP_EFUSE, DBG_LOUD,
-		 ("Addr=%x Data =%x\n", address, value));
+	RT_TRACE(COMP_EFUSE, DBG_LOUD, "Addr=%x Data =%x\n", address, value);
 
 	if (address < efuse_real_content_len) {
 		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL], value);
@@ -242,8 +241,8 @@ void read92e_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte,
 
 	if ((_offset + _size_byte) > rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]) {
 		RT_TRACE(COMP_EFUSE, DBG_LOUD,
-			 ("read92e_efuse(): Invalid offset(%#x) with read bytes(%#x)!!\n",
-			 _offset, _size_byte));
+			 "read92e_efuse(): Invalid offset(%#x) with read bytes(%#x)!!\n",
+			 _offset, _size_byte);
 		return;
 	}
 
@@ -411,8 +410,8 @@ bool efuse92e_shadow_update_chk(struct ieee80211_hw *hw)
 		bresult = false;
 
 	RT_TRACE(COMP_EFUSE, DBG_LOUD,
-		 ("efuse92e_shadow_update_chk(): totalbytes(%#x), hdr_num(%#x), words_need(%#x), efuse_used(%d)\n",
-		  totalbytes, hdr_num, words_need, efuse_used));
+		 "efuse92e_shadow_update_chk(): totalbytes(%#x), hdr_num(%#x), words_need(%#x), efuse_used(%d)\n",
+		 totalbytes, hdr_num, words_need, efuse_used);
 
 	return bresult;
 }
@@ -448,7 +447,7 @@ bool efuse92e_shadow_update(struct ieee80211_hw *hw)
 	u8 word_en = 0x0F;
 	u8 first_pg = false;
 
-	RT_TRACE(COMP_EFUSE, DBG_LOUD, ("\n"));
+	RT_TRACE(COMP_EFUSE, DBG_LOUD, "\n");
 
 	if (!efuse92e_shadow_update_chk(hw)) {
 		efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
@@ -456,8 +455,7 @@ bool efuse92e_shadow_update(struct ieee80211_hw *hw)
 		       &rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 		       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
-		RT_TRACE(COMP_EFUSE, DBG_LOUD,
-			 ("efuse out of capacity!!\n"));
+		RT_TRACE(COMP_EFUSE, DBG_LOUD, "efuse out of capacity!!\n");
 		return false;
 	}
 	efuse_power_switch(hw, true, true);
@@ -494,7 +492,7 @@ bool efuse92e_shadow_update(struct ieee80211_hw *hw)
 			if (!efuse_pg_packet_write(hw, (u8) offset, word_en,
 						   tmpdata)) {
 				RT_TRACE(COMP_ERR, DBG_WARNING,
-					 ("PG section(%#x) fail!!\n", offset));
+					 "PG section(%#x) fail!!\n", offset);
 				break;
 			}
 		}
@@ -507,7 +505,7 @@ bool efuse92e_shadow_update(struct ieee80211_hw *hw)
 	       &rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 	       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
-	RT_TRACE(COMP_EFUSE, DBG_LOUD, ("\n"));
+	RT_TRACE(COMP_EFUSE, DBG_LOUD, "\n");
 	return true;
 }
 
@@ -640,8 +638,7 @@ static int efuse_one_byte_write(struct ieee80211_hw *hw, u16 addr, u8 data)
 	u8 tmpidx = 0;
 	bool bresult;
 
-	RT_TRACE(COMP_EFUSE, DBG_LOUD,
-		 ("Addr = %x Data=%x\n", addr, data));
+	RT_TRACE(COMP_EFUSE, DBG_LOUD, "Addr = %x Data=%x\n", addr, data);
 
 	rtl_write_byte(rtlpriv,
 		       rtlpriv->cfg->maps[EFUSE_CTRL] + 1, (u8) (addr & 0xff));
@@ -1021,7 +1018,7 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 	if (efuse_addr >= (EFUSE_MAX_SIZE -
 		rtlpriv->cfg->maps[EFUSE_OOB_PROTECT_BYTES_LEN])) {
 		RT_TRACE(COMP_EFUSE, DBG_LOUD,
-			 ("efuse_addr(%#x) Out of size!!\n", efuse_addr));
+			 "efuse_addr(%#x) Out of size!!\n", efuse_addr);
 	}
 
 	return true;
@@ -1061,8 +1058,8 @@ static u8 efuse_word_enable_data_write(struct ieee80211_hw *hw,
 	u8 tmpdata[8];
 
 	memset(tmpdata, 0xff, PGPKT_DATA_SIZE);
-	RT_TRACE(COMP_EFUSE, DBG_LOUD,
-		 ("word_en = %x efuse_addr=%x\n", word_en, efuse_addr));
+	RT_TRACE(COMP_EFUSE, DBG_LOUD, "word_en = %x efuse_addr=%x\n",
+		 word_en, efuse_addr);
 
 	if (!(word_en & BIT(0))) {
 		tmpaddr = start_addr;
diff --git a/drivers/staging/rtl8192ee/pci.c b/drivers/staging/rtl8192ee/pci.c
index 0215aef..4b895b3 100644
--- a/drivers/staging/rtl8192ee/pci.c
+++ b/drivers/staging/rtl8192ee/pci.c
@@ -164,8 +164,7 @@ static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 		}
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("switch case not process\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "switch case not process\n");
 		break;
 	}
 
@@ -228,8 +227,7 @@ static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 		return;
 
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
-		RT_TRACE(COMP_POWER, DBG_TRACE,
-			 ("PCI(Bridge) UNKNOWN.\n"));
+		RT_TRACE(COMP_POWER, DBG_TRACE, "PCI(Bridge) UNKNOWN\n");
 
 		return;
 	}
@@ -284,8 +282,7 @@ static void rtl_pci_enable_aspm(struct ieee80211_hw *hw)
 		return;
 
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
-		RT_TRACE(COMP_POWER, DBG_TRACE,
-			 ("PCI(Bridge) UNKNOWN.\n"));
+		RT_TRACE(COMP_POWER, DBG_TRACE, "PCI(Bridge) UNKNOWN\n");
 		return;
 	}
 
@@ -303,9 +300,9 @@ static void rtl_pci_enable_aspm(struct ieee80211_hw *hw)
 	rtl_pci_raw_write_port_uchar(PCI_CONF_DATA, u_pcibridge_aspmsetting);
 
 	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("PlatformEnableASPM(): Write reg[%x] = %x\n",
-		  (pcipriv->ndis_adapter.pcibridge_pciehdr_offset + 0x10),
-		  u_pcibridge_aspmsetting));
+		 "PlatformEnableASPM(): Write reg[%x] = %x\n",
+		 pcipriv->ndis_adapter.pcibridge_pciehdr_offset + 0x10,
+		 u_pcibridge_aspmsetting);
 
 	udelay(50);
 
@@ -371,11 +368,11 @@ static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
 
 			tpcipriv = (struct rtl_pci_priv *)tpriv->priv;
 			RT_TRACE(COMP_INIT, DBG_LOUD,
-				 ("pcipriv->ndis_adapter.funcnumber %x\n",
-				  pcipriv->ndis_adapter.funcnumber));
+				 "pcipriv->ndis_adapter.funcnumber %x\n",
+				 pcipriv->ndis_adapter.funcnumber);
 			RT_TRACE(COMP_INIT, DBG_LOUD,
-				 ("tpcipriv->ndis_adapter.funcnumber %x\n",
-				  tpcipriv->ndis_adapter.funcnumber));
+				 "tpcipriv->ndis_adapter.funcnumber %x\n",
+				 tpcipriv->ndis_adapter.funcnumber);
 
 			if ((pcipriv->ndis_adapter.busnumber ==
 			     tpcipriv->ndis_adapter.busnumber) &&
@@ -389,8 +386,7 @@ static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
 		}
 	}
 
-	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("find_buddy_priv %d\n", find_buddy_priv));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "find_buddy_priv %d\n", find_buddy_priv);
 
 	if (find_buddy_priv)
 		*buddy_priv = tpriv;
@@ -431,9 +427,8 @@ static void rtl_pci_parse_configuration(struct pci_dev *pdev,
 	pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &linkctrl_reg);
 	pcipriv->ndis_adapter.linkctrl_reg = linkctrl_reg;
 
-	RT_TRACE(COMP_INIT, DBG_TRACE,
-		 ("Link Control Register =%x\n",
-		  pcipriv->ndis_adapter.linkctrl_reg));
+	RT_TRACE(COMP_INIT, DBG_TRACE, "Link Control Register = %x\n",
+		 pcipriv->ndis_adapter.linkctrl_reg);
 
 	pci_read_config_byte(pdev, 0x98, &tmp);
 	tmp |= BIT(4);
@@ -601,10 +596,10 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 			skb_pull(skb, EM_HDR_LEN);
 
 		RT_TRACE((COMP_INTR | COMP_SEND), DBG_TRACE,
-			 ("new ring->idx:%d, free: skb_queue_len:%d, free: seq:%d\n",
-			  ring->idx,
-			  skb_queue_len(&ring->queue),
-			  *(u16 *)(skb->data + 22)));
+			 "new ring->idx:%d, free: skb_queue_len:%d, free: seq:%d\n",
+			 ring->idx,
+			 skb_queue_len(&ring->queue),
+			 *(u16 *)(skb->data + 22));
 
 		if (prio == TXCMD_QUEUE) {
 			dev_kfree_skb(skb);
@@ -649,9 +644,8 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 
 		if ((ring->entries - skb_queue_len(&ring->queue)) == 2) {
 			RT_TRACE(COMP_ERR, DBG_LOUD,
-				 ("more desc left, wake skb_queue@%d,ring->idx = %d, skb_queue_len = 0x%d\n",
-					 prio, ring->idx,
-					 skb_queue_len(&ring->queue)));
+				 "more desc left, wake skb_queue@%d,ring->idx = %d, skb_queue_len = 0x%d\n",
+				 prio, ring->idx, skb_queue_len(&ring->queue));
 
 			ieee80211_wake_queue(hw, skb_get_queue_mapping
 					     (skb));
@@ -972,59 +966,59 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 		goto done;
 	/*<1> beacon related */
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_TBDOK])
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("beacon ok interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "beacon ok interrupt!\n");
 
 	if (unlikely(inta & rtlpriv->cfg->maps[RTL_IMR_TBDER]))
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("beacon err interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "beacon err interrupt!\n");
 
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_BDOK])
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("beacon interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "beacon interrupt!\n");
 
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_BcnInt]) {
 		RT_TRACE(COMP_INTR, DBG_TRACE,
-			 ("prepare beacon for interrupt!\n"));
+			 "prepare beacon for interrupt!\n");
 		tasklet_schedule(&rtlpriv->works.irq_prepare_bcn_tasklet);
 	}
 
 	/*<2> tx related */
 	if (unlikely(intb & rtlpriv->cfg->maps[RTL_IMR_TXFOVW]))
-		RT_TRACE(COMP_ERR, DBG_TRACE, ("IMR_TXFOVW!\n"));
+		RT_TRACE(COMP_ERR, DBG_TRACE, "IMR_TXFOVW!\n");
 
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_MGNTDOK]) {
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("Manage ok interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "Manage ok interrupt!\n");
 		_rtl_pci_tx_isr(hw, MGNT_QUEUE);
 	}
 
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_HIGHDOK]) {
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("HIGH_QUEUE ok interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "HIGH_QUEUE ok interrupt!\n");
 		_rtl_pci_tx_isr(hw, HIGH_QUEUE);
 	}
 
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_BKDOK]) {
 		rtlpriv->link_info.num_tx_inperiod++;
 
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("BK Tx OK interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "BK Tx OK interrupt!\n");
 		_rtl_pci_tx_isr(hw, BK_QUEUE);
 	}
 
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_BEDOK]) {
 		rtlpriv->link_info.num_tx_inperiod++;
 
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("BE TX OK interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "BE TX OK interrupt!\n");
 		_rtl_pci_tx_isr(hw, BE_QUEUE);
 	}
 
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_VIDOK]) {
 		rtlpriv->link_info.num_tx_inperiod++;
 
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("VI TX OK interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "VI TX OK interrupt!\n");
 		_rtl_pci_tx_isr(hw, VI_QUEUE);
 	}
 
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_VODOK]) {
 		rtlpriv->link_info.num_tx_inperiod++;
 
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("Vo TX OK interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "Vo TX OK interrupt!\n");
 		_rtl_pci_tx_isr(hw, VO_QUEUE);
 	}
 
@@ -1033,25 +1027,25 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 			rtlpriv->link_info.num_tx_inperiod++;
 
 			RT_TRACE(COMP_INTR, DBG_TRACE,
-				 ("CMD TX OK interrupt!\n"));
+				 "CMD TX OK interrupt!\n");
 			_rtl_pci_tx_isr(hw, TXCMD_QUEUE);
 		}
 	}
 
 	/*<3> rx related */
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_ROK]) {
-		RT_TRACE(COMP_INTR, DBG_TRACE, ("Rx ok interrupt!\n"));
+		RT_TRACE(COMP_INTR, DBG_TRACE, "Rx ok interrupt!\n");
 		_rtl_pci_rx_interrupt(hw);
 	}
 
 	if (unlikely(inta & rtlpriv->cfg->maps[RTL_IMR_RDU])) {
 		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("rx descriptor unavailable!\n"));
+			 "rx descriptor unavailable!\n");
 		_rtl_pci_rx_interrupt(hw);
 	}
 
 	if (unlikely(intb & rtlpriv->cfg->maps[RTL_IMR_RXFOVW])) {
-		RT_TRACE(COMP_ERR, DBG_WARNING, ("rx overflow !\n"));
+		RT_TRACE(COMP_ERR, DBG_WARNING, "rx overflow !\n");
 		_rtl_pci_rx_interrupt(hw);
 	}
 
@@ -1059,7 +1053,7 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723AE) {
 		if (inta & rtlpriv->cfg->maps[RTL_IMR_C2HCMD]) {
 			RT_TRACE(COMP_INTR, DBG_TRACE,
-				 ("firmware interrupt!\n"));
+				 "firmware interrupt!\n");
 			queue_delayed_work(rtlpriv->works.rtl_wq,
 					   &rtlpriv->works.fwevt_wq, 0);
 		}
@@ -1073,8 +1067,7 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8188EE ||
 	    rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE) {
 		if (unlikely(inta & rtlpriv->cfg->maps[RTL_IMR_HSISR_IND])) {
-			RT_TRACE(COMP_INTR, DBG_TRACE,
-				 ("hsisr interrupt!\n"));
+			RT_TRACE(COMP_INTR, DBG_TRACE, "hsisr interrupt!\n");
 			_rtl_pci_hs_interrupt(hw);
 		}
 	}
@@ -1230,8 +1223,8 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 					      &buffer_desc_dma);
 		if (!buffer_desc || (unsigned long)buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("Cannot allocate TX ring (prio = %d)\n",
-				 prio));
+				 "Cannot allocate TX ring (prio = %d)\n",
+				 prio);
 			return -ENOMEM;
 		}
 
@@ -1248,7 +1241,7 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 				     &desc_dma);
 	if (!desc || (unsigned long)desc & 0xFF) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Cannot allocate TX ring (prio = %d)\n", prio));
+			 "Cannot allocate TX ring (prio = %d)\n", prio);
 		return -ENOMEM;
 	}
 
@@ -1258,8 +1251,7 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	rtlpci->tx_ring[prio].idx = 0;
 	rtlpci->tx_ring[prio].entries = entries;
 	skb_queue_head_init(&rtlpci->tx_ring[prio].queue);
-	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("queue:%d, ring_addr:%p\n", prio, desc));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "queue:%d, ring_addr:%p\n", prio, desc);
 
 	/* init every desc in this ring */
 	if (!rtlpriv->use_new_trx_flow) {
@@ -1293,7 +1285,7 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 		if (!rtlpci->rx_ring[rxring_idx].buffer_desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("Cannot allocate RX ring\n"));
+				 "Cannot allocate RX ring\n");
 			return -ENOMEM;
 		}
 
@@ -1317,7 +1309,7 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 		if (!rtlpci->rx_ring[rxring_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("Cannot allocate RX ring\n"));
+				 "Cannot allocate RX ring\n");
 			return -ENOMEM;
 		}
 
@@ -1628,9 +1620,9 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 
 		if ((own == 1) && (hw_queue != BEACON_QUEUE)) {
 			RT_TRACE(COMP_ERR, DBG_WARNING,
-				 ("No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
-				  hw_queue, ring->idx, idx,
-				  skb_queue_len(&ring->queue)));
+				 "No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
+				 hw_queue, ring->idx, idx,
+				 skb_queue_len(&ring->queue));
 
 			spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock,
 					       flags);
@@ -1670,9 +1662,9 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 	if ((ring->entries - skb_queue_len(&ring->queue)) < 2 &&
 	    hw_queue != BEACON_QUEUE) {
 		RT_TRACE(COMP_ERR, DBG_LOUD,
-			 ("less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
-			  hw_queue, ring->idx, idx,
-			  skb_queue_len(&ring->queue)));
+			 "less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
+			 hw_queue, ring->idx, idx,
+			 skb_queue_len(&ring->queue));
 
 		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
 	}
@@ -1745,7 +1737,7 @@ static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 	err = _rtl_pci_init_trx_ring(hw);
 	if (err) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("tx ring initialization failed"));
+			 "tx ring initialization failed\n");
 		return err;
 	}
 
@@ -1759,7 +1751,7 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	int err = 0;
 
-	RT_TRACE(COMP_INIT, DBG_DMESG, (" rtl_pci_start\n"));
+	RT_TRACE(COMP_INIT, DBG_DMESG, " rtl_pci_start\n");
 	rtl92e_pci_reset_trx_ring(hw);
 
 	rtlpriv->rtlhal.driver_is_goingto_unload = false;
@@ -1771,12 +1763,12 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 	err = rtlpriv->cfg->ops->hw_init(hw);
 	if (err) {
 		RT_TRACE(COMP_INIT, DBG_DMESG,
-			 ("Failed to config hardware err %x!\n" , err));
+			 "Failed to config hardware err %x!\n" , err);
 		return err;
 	}
 
 	rtlpriv->cfg->ops->enable_interrupt(hw);
-	RT_TRACE(COMP_INIT, DBG_LOUD, ("enable_interrupt OK\n"));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "enable_interrupt OK\n");
 
 	rtl92e_init_rx_config(hw);
 
@@ -1787,7 +1779,7 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 
 	rtlpriv->rtlhal.up_first_time = false;
 
-	RT_TRACE(COMP_INIT, DBG_DMESG, ("rtl_pci_start OK\n"));
+	RT_TRACE(COMP_INIT, DBG_DMESG, "rtl_pci_start OK\n");
 	return 0;
 }
 
@@ -1863,67 +1855,67 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		switch (revisionid) {
 		case RTL_PCI_REVISION_ID_8192PCIE:
 			RT_TRACE(COMP_INIT, DBG_DMESG,
-				 ("8192E is found but not supported now-vid/did=%x/%x\n",
-				  venderid, deviceid));
+				 "8192E is found but not supported now-vid/did=%x/%x\n",
+				 venderid, deviceid);
 			rtlhal->hw_type = HARDWARE_TYPE_RTL8192E;
 			return false;
 			break;
 		case RTL_PCI_REVISION_ID_8192SE:
 			RT_TRACE(COMP_INIT, DBG_DMESG,
-				 ("8192SE is found - vid/did=%x/%x\n",
-				  venderid, deviceid));
+				 "8192SE is found - vid/did=%x/%x\n",
+				 venderid, deviceid);
 			rtlhal->hw_type = HARDWARE_TYPE_RTL8192SE;
 			break;
 		default:
 			RT_TRACE(COMP_ERR, DBG_WARNING,
-				 ("Err: Unknown device - vid/did=%x/%x\n",
-				  venderid, deviceid));
+				 "Err: Unknown device - vid/did=%x/%x\n",
+				 venderid, deviceid);
 			rtlhal->hw_type = HARDWARE_TYPE_RTL8192SE;
 			break;
 		}
 	} else if (deviceid == RTL_PCI_8723AE_DID) {
 		rtlhal->hw_type = HARDWARE_TYPE_RTL8723AE;
 		RT_TRACE(COMP_INIT, DBG_DMESG,
-			 ("8723AE PCI-E is found - vid/did=%x/%x\n",
-			  venderid, deviceid));
+			 "8723AE PCI-E is found - vid/did=%x/%x\n",
+			 venderid, deviceid);
 	} else if (deviceid == RTL_PCI_8192CET_DID ||
 		   deviceid == RTL_PCI_8192CE_DID ||
 		   deviceid == RTL_PCI_8191CE_DID ||
 		   deviceid == RTL_PCI_8188CE_DID) {
 		rtlhal->hw_type = HARDWARE_TYPE_RTL8192CE;
 		RT_TRACE(COMP_INIT, DBG_DMESG,
-			 ("8192C PCI-E is found - vid/did=%x/%x\n",
-			  venderid, deviceid));
+			 "8192C PCI-E is found - vid/did=%x/%x\n",
+			 venderid, deviceid);
 	} else if (deviceid == RTL_PCI_8192DE_DID ||
 		   deviceid == RTL_PCI_8192DE_DID2) {
 		rtlhal->hw_type = HARDWARE_TYPE_RTL8192DE;
 		RT_TRACE(COMP_INIT, DBG_DMESG,
-			 ("8192D PCI-E is found - vid/did=%x/%x\n",
-			  venderid, deviceid));
+			 "8192D PCI-E is found - vid/did=%x/%x\n",
+			 venderid, deviceid);
 	} else if (deviceid == RTL_PCI_8188EE_DID) {
 			rtlhal->hw_type = HARDWARE_TYPE_RTL8188EE;
-			RT_TRACE(COMP_INIT , DBG_LOUD,
-				 ("Find adapter, Hardware type is 8188EE\n"));
+			RT_TRACE(COMP_INIT, DBG_LOUD,
+				 "Find adapter, Hardware type is 8188EE\n");
 	} else if (deviceid == RTL_PCI_8723BE_DID) {
 			rtlhal->hw_type = HARDWARE_TYPE_RTL8723BE;
-			RT_TRACE(COMP_INIT , DBG_LOUD,
-				 ("Find adapter, Hardware type is 8723BE\n"));
+			RT_TRACE(COMP_INIT, DBG_LOUD,
+				 "Find adapter, Hardware type is 8723BE\n");
 	} else if (deviceid == RTL_PCI_8192EE_DID) {
 			rtlhal->hw_type = HARDWARE_TYPE_RTL8192EE;
-			RT_TRACE(COMP_INIT , DBG_LOUD,
-				 ("Find adapter, Hardware type is 8192EE\n"));
+			RT_TRACE(COMP_INIT, DBG_LOUD,
+				 "Find adapter, Hardware type is 8192EE\n");
 	} else if (deviceid == RTL_PCI_8821AE_DID) {
 			rtlhal->hw_type = HARDWARE_TYPE_RTL8821AE;
-			RT_TRACE(COMP_INIT , DBG_LOUD,
-				 ("Find adapter, Hardware type is 8821AE\n"));
+			RT_TRACE(COMP_INIT, DBG_LOUD,
+				 "Find adapter, Hardware type is 8821AE\n");
 	} else if (deviceid == RTL_PCI_8812AE_DID) {
 			rtlhal->hw_type = HARDWARE_TYPE_RTL8812AE;
-			RT_TRACE(COMP_INIT , DBG_LOUD,
-				 ("Find adapter, Hardware type is 8812AE\n"));
+			RT_TRACE(COMP_INIT, DBG_LOUD,
+				 "Find adapter, Hardware type is 8812AE\n");
 	} else {
 		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("Err: Unknown device - vid/did=%x/%x\n",
-			  venderid, deviceid));
+			 "Err: Unknown device - vid/did=%x/%x\n",
+			 venderid, deviceid);
 
 		rtlhal->hw_type = RTL_DEFAULT_HARDWARE_TYPE;
 	}
@@ -1932,17 +1924,17 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		if (revisionid == 0 || revisionid == 1) {
 			if (revisionid == 0) {
 				RT_TRACE(COMP_INIT, DBG_LOUD,
-					 ("Find 92DE MAC0.\n"));
+					 "Find 92DE MAC0\n");
 				rtlhal->interfaceindex = 0;
 			} else if (revisionid == 1) {
 				RT_TRACE(COMP_INIT, DBG_LOUD,
-					 ("Find 92DE MAC1.\n"));
+					 "Find 92DE MAC1\n");
 				rtlhal->interfaceindex = 1;
 			}
 		} else {
 			RT_TRACE(COMP_INIT, DBG_LOUD,
-				 ("Unknown device - VendorID/DeviceID=%x/%x, Revision=%x\n",
-				  venderid, deviceid, revisionid));
+				 "Unknown device - VendorID/DeviceID=%x/%x, Revision=%x\n",
+				 venderid, deviceid, revisionid);
 			rtlhal->interfaceindex = 0;
 		}
 	}
@@ -1968,8 +1960,8 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 			if (bridge_pdev->vendor == pcibridge_vendors[tmp]) {
 				pcipriv->ndis_adapter.pcibridge_vendor = tmp;
 				RT_TRACE(COMP_INIT, DBG_DMESG,
-					 ("Pci Bridge Vendor is found index: %d\n",
-					  tmp));
+					 "Pci Bridge Vendor is found index: %d\n",
+					 tmp);
 				break;
 			}
 		}
@@ -2002,21 +1994,21 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 	}
 
 	RT_TRACE(COMP_INIT, DBG_DMESG,
-		 ("pcidev busnumber:devnumber:funcnumber:vendor:link_ctl %d:%d:%d:%x:%x\n",
-		  pcipriv->ndis_adapter.busnumber,
-		  pcipriv->ndis_adapter.devnumber,
-		  pcipriv->ndis_adapter.funcnumber,
-		  pdev->vendor, pcipriv->ndis_adapter.linkctrl_reg));
+		 "pcidev busnumber:devnumber:funcnumber:vendor:link_ctl %d:%d:%d:%x:%x\n",
+		 pcipriv->ndis_adapter.busnumber,
+		 pcipriv->ndis_adapter.devnumber,
+		 pcipriv->ndis_adapter.funcnumber,
+		 pdev->vendor, pcipriv->ndis_adapter.linkctrl_reg);
 
 	RT_TRACE(COMP_INIT, DBG_DMESG,
-		 ("pci_bridge busnumber:devnumber:funcnumber:vendor:pcie_cap:link_ctl_reg:amd %d:%d:%d:%x:%x:%x:%x\n",
-		  pcipriv->ndis_adapter.pcibridge_busnum,
-		  pcipriv->ndis_adapter.pcibridge_devnum,
+		 "pci_bridge busnumber:devnumber:funcnumber:vendor:pcie_cap:link_ctl_reg:amd %d:%d:%d:%x:%x:%x:%x\n",
+		 pcipriv->ndis_adapter.pcibridge_busnum,
+		 pcipriv->ndis_adapter.pcibridge_devnum,
 		  pcipriv->ndis_adapter.pcibridge_funcnum,
-		  pcibridge_vendors[pcipriv->ndis_adapter.pcibridge_vendor],
-		  pcipriv->ndis_adapter.pcibridge_pciehdr_offset,
-		  pcipriv->ndis_adapter.pcibridge_linkctrlreg,
-		  pcipriv->ndis_adapter.amd_l1_patch));
+		 pcibridge_vendors[pcipriv->ndis_adapter.pcibridge_vendor],
+		 pcipriv->ndis_adapter.pcibridge_pciehdr_offset,
+		 pcipriv->ndis_adapter.pcibridge_linkctrlreg,
+		 pcipriv->ndis_adapter.amd_l1_patch);
 
 	rtl_pci_parse_configuration(pdev, hw);
 	list_add_tail(&rtlpriv->list, &rtlpriv->glb_var->glb_priv_list);
@@ -2042,7 +2034,7 @@ static int rtl_pci_intr_mode_msi(struct ieee80211_hw *hw)
 
 	rtlpci->using_msi = true;
 
-	RT_TRACE(COMP_INIT|COMP_INTR, DBG_DMESG, ("MSI Interrupt Mode!\n"));
+	RT_TRACE(COMP_INIT|COMP_INTR, DBG_DMESG, "MSI Interrupt Mode!\n");
 	return 0;
 }
 
@@ -2059,8 +2051,7 @@ static int rtl_pci_intr_mode_legacy(struct ieee80211_hw *hw)
 		return ret;
 
 	rtlpci->using_msi = false;
-	RT_TRACE(COMP_INIT|COMP_INTR, DBG_DMESG,
-		 ("Pin-based Interrupt Mode!\n"));
+	RT_TRACE(COMP_INIT|COMP_INTR, DBG_DMESG, "Pin-based Interrupt Mode!\n");
 	return 0;
 }
 
@@ -2166,9 +2157,8 @@ int stg_rtl_pci_probe(struct pci_dev *pdev,
 	}
 
 	RT_TRACE(COMP_INIT, DBG_DMESG,
-		 ("mem mapped space: start: 0x%08lx len:%08lx flags:%08lx, after map:0x%08lx\n",
-		  pmem_start, pmem_len, pmem_flags,
-		  rtlpriv->io.pci_mem_start));
+		 "mem mapped space: start: 0x%08lx len:%08lx flags:%08lx, after map:0x%08lx\n",
+		 pmem_start, pmem_len, pmem_flags, rtlpriv->io.pci_mem_start);
 
 	/* Disable Clk Request */
 	pci_write_config_byte(pdev, 0x81, 0);
@@ -2192,7 +2182,7 @@ int stg_rtl_pci_probe(struct pci_dev *pdev,
 	rtlpriv->cfg->ops->read_eeprom_info(hw);
 
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("Can't init_sw_vars.\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
 		goto fail3;
 	}
 
@@ -2205,21 +2195,20 @@ int stg_rtl_pci_probe(struct pci_dev *pdev,
 	err = rtl92e_init_core(hw);
 	if (err) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Can't allocate sw for mac80211.\n"));
+			 "Can't allocate sw for mac80211\n");
 		goto fail3;
 	}
 
 	/* Init PCI sw */
 	err = !rtl_pci_init(hw, pdev);
 	if (err) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("Failed to init PCI.\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Failed to init PCI\n");
 		goto fail3;
 	}
 
 	err = ieee80211_register_hw(hw);
 	if (err) {
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Can't register mac80211 hw.\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Can't register mac80211 hw\n");
 		goto fail3;
 	} else {
 		rtlpriv->mac80211.mac80211_registered = 1;
@@ -2227,7 +2216,7 @@ int stg_rtl_pci_probe(struct pci_dev *pdev,
 	/* the wiphy must have been registed to
 	 * cfg80211 prior to regulatory_hint */
 	if (regulatory_hint(hw->wiphy, rtlpriv->regd.alpha2))
-		RT_TRACE(COMP_ERR, DBG_WARNING, ("regulatory_hint fail\n"));
+		RT_TRACE(COMP_ERR, DBG_WARNING, "regulatory_hint fail\n");
 
 	/* add for prov */
 	rtl_proc_add_one(hw);
@@ -2239,8 +2228,8 @@ int stg_rtl_pci_probe(struct pci_dev *pdev,
 	err = rtl_pci_intr_mode_decide(hw);
 	if (err) {
 		RT_TRACE(COMP_INIT, DBG_DMESG,
-			 ("%s: failed to register IRQ handler\n",
-			  wiphy_name(hw->wiphy)));
+			 "%s: failed to register IRQ handler\n",
+			 wiphy_name(hw->wiphy));
 		goto fail3;
 	} else {
 		rtlpci->irq_alloc = 1;
diff --git a/drivers/staging/rtl8192ee/ps.c b/drivers/staging/rtl8192ee/ps.c
index 90c3fc2..1a547b3 100644
--- a/drivers/staging/rtl8192ee/ps.c
+++ b/drivers/staging/rtl8192ee/ps.c
@@ -40,7 +40,7 @@ bool stg_rtl_ps_enable_nic(struct ieee80211_hw *hw)
 		rtlpriv->intf_ops->reset_trx_ring(hw);
 
 	if (is_hal_stop(rtlhal))
-		RT_TRACE(COMP_ERR, DBG_WARNING, ("Driver is already down!\n"));
+		RT_TRACE(COMP_ERR, DBG_WARNING, "Driver is already down!\n");
 
 	/*<2> Enable Adapter */
 	rtlpriv->cfg->ops->hw_init(hw);
@@ -101,8 +101,8 @@ bool stg_rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 			spin_unlock(&rtlpriv->locks.rf_ps_lock);
 
 			RT_TRACE(COMP_ERR, DBG_WARNING,
-				 ("RF Change in progress! Wait to set..state_toset(%d)\n",
-				  state_toset));
+				 "RF Change in progress! Wait to set..state_toset(%d)\n",
+				 state_toset);
 
 			/* Set RF after the previous action is done.  */
 			while (ppsc->rfchange_inprogress) {
@@ -151,7 +151,7 @@ no_protect:
 		b_actionallowed = true;
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("switch case not process\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "switch case not process\n");
 		break;
 	}
 
@@ -212,7 +212,7 @@ void rtl92e_ips_nic_off_wq_callback(void *data)
 	enum rf_pwrstate rtstate;
 
 	if (mac->opmode != NL80211_IFTYPE_STATION) {
-		RT_TRACE(COMP_ERR, DBG_WARNING, ("not station return\n"));
+		RT_TRACE(COMP_ERR, DBG_WARNING, "not station return\n");
 		return;
 	}
 
@@ -249,7 +249,7 @@ void rtl92e_ips_nic_off_wq_callback(void *data)
 		    (mac->link_state == MAC80211_NOLINK) &&
 		    !mac->act_scanning) {
 			RT_TRACE(COMP_RF, DBG_LOUD,
-				 ("IPSEnter(): Turn off RF.\n"));
+				 "IPSEnter(): Turn off RF\n");
 
 			ppsc->inactive_pwrstate = ERFOFF;
 			ppsc->b_in_powersavemode = true;
@@ -326,7 +326,7 @@ static bool rtl_get_fwlps_doze(struct ieee80211_hw *hw)
 
 	if (ps_timediff < 2000) {
 		RT_TRACE(COMP_POWER, DBG_LOUD,
-			 ("Delay enter Fw LPS for DHCP, ARP, or EAPOL exchanging state\n"));
+			 "Delay enter Fw LPS for DHCP, ARP, or EAPOL exchanging state\n");
 		return false;
 	}
 
@@ -372,8 +372,8 @@ void rtl_lps_set_psmode(struct ieee80211_hw *hw, u8 rt_psmode)
 	if ((ppsc->b_fwctrl_lps) && ppsc->report_linked) {
 		if (ppsc->dot11_psmode == EACTIVE) {
 			RT_TRACE(COMP_RF, DBG_DMESG,
-				 ("FW LPS leave ps_mode:%x\n",
-				  FW_PS_ACTIVE_MODE));
+				 "FW LPS leave ps_mode:%x\n",
+				  FW_PS_ACTIVE_MODE);
 			enter_fwlps = false;
 			ppsc->pwr_mode = FW_PS_ACTIVE_MODE;
 			ppsc->smart_ps = 0;
@@ -387,8 +387,8 @@ void rtl_lps_set_psmode(struct ieee80211_hw *hw, u8 rt_psmode)
 		} else {
 			if (rtl_get_fwlps_doze(hw)) {
 				RT_TRACE(COMP_RF, DBG_DMESG,
-					 ("FW LPS enter ps_mode:%x\n",
-					 ppsc->fwctrl_psmode));
+					 "FW LPS enter ps_mode:%x\n",
+					 ppsc->fwctrl_psmode);
 				if (rtlpriv->cfg->ops->get_btc_status())
 					rtlpriv->btcoexist.btc_ops->btc_lps_notify(rtlpriv, rt_psmode);
 				enter_fwlps = true;
@@ -439,7 +439,7 @@ void rtl92e_lps_enter(struct ieee80211_hw *hw)
 	if (mac->cnt_after_linked >= 2) {
 		if (ppsc->dot11_psmode == EACTIVE) {
 			RT_TRACE(COMP_POWER, DBG_LOUD,
-				 ("Enter 802.11 power save mode...\n"));
+				 "Enter 802.11 power save mode...\n");
 
 			rtl_lps_set_psmode(hw, EAUTOPS);
 		}
@@ -469,7 +469,7 @@ void rtl92e_lps_leave(struct ieee80211_hw *hw)
 			}
 
 			RT_TRACE(COMP_POWER, DBG_LOUD,
-				 ("Busy Traffic,Leave 802.11 power save..\n"));
+				 "Busy Traffic,Leave 802.11 power save..\n");
 
 			rtl_lps_set_psmode(hw, EACTIVE);
 		}
@@ -555,8 +555,8 @@ void rtl92e_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len)
 				   &rtlpriv->works.ps_work, MSECS(5));
 	} else {
 		RT_TRACE(COMP_POWER, DBG_DMESG,
-			 ("u_bufferd: %x, m_buffered: %x\n",
-			  u_buffed, m_buffed));
+			 "u_bufferd: %x, m_buffered: %x\n",
+			  u_buffed, m_buffed);
 	}
 }
 
@@ -653,8 +653,8 @@ void rtl92e_swlps_rf_sleep(struct ieee80211_hw *hw)
 	 * sleep  = dtim_period, that meaons, we should
 	 * awake before every dtim */
 	RT_TRACE(COMP_POWER, DBG_DMESG,
-		 ("dtim_counter:%x will sleep :%d beacon_intv\n",
-		  rtlpriv->psc.dtim_counter, sleep_intv));
+		 "dtim_counter:%x will sleep :%d beacon_intv\n",
+		  rtlpriv->psc.dtim_counter, sleep_intv);
 
 	/* we tested that 40ms is enough for sw & hw sw delay */
 	queue_delayed_work(rtlpriv->works.rtl_wq, &rtlpriv->works.ps_rfon_wq,
@@ -731,8 +731,8 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 			find_p2p_ps_ie = true;
 			if ((noa_len - 2) % 13 != 0) {
 				RT_TRACE(COMP_INIT, DBG_LOUD,
-					 ("P2P notice of absence: invalid length%d\n",
-					 noa_len));
+					 "P2P notice of absence: invalid length%d\n",
+					 noa_len);
 				return;
 			} else {
 				noa_num = (noa_len - 2) / 13;
@@ -740,8 +740,7 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 			noa_index = ie[3];
 			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
 			    P2P_PS_NONE || noa_index != p2pinfo->noa_index) {
-				RT_TRACE(COMP_FW, DBG_LOUD,
-					 ("update NOA ie.\n"));
+				RT_TRACE(COMP_FW, DBG_LOUD, "update NOA ie\n");
 				p2pinfo->noa_index = noa_index;
 				p2pinfo->opp_ps = (ie[4] >> 7);
 				p2pinfo->ctwindow = ie[4] & 0x7F;
@@ -815,7 +814,7 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
 		return;
 	find_p2p_ie = true;
 
-	RT_TRACE(COMP_FW, DBG_LOUD, ("action frame find P2P IE.\n"));
+	RT_TRACE(COMP_FW, DBG_LOUD, "action frame find P2P IE.\n");
 	/*to find noa ie*/
 	while (ie + 1 < end) {
 		noa_len = READEF2BYTE((__le16 *)&ie[1]);
@@ -823,14 +822,14 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
 			return;
 
 		if (ie[0] == 12) {
-			RT_TRACE(COMP_FW, DBG_LOUD, ("find NOA IE\n"));
+			RT_TRACE(COMP_FW, DBG_LOUD, "find NOA IE\n");
 			RT_PRINT_DATA(rtlpriv, COMP_FW, DBG_LOUD, "noa ie ",
 				      ie, noa_len);
 			find_p2p_ps_ie = true;
 			if ((noa_len - 2) % 13 != 0) {
 				RT_TRACE(COMP_FW, DBG_LOUD,
-					 ("P2P notice of absence: invalid length%d\n",
-					 noa_len));
+					 "P2P notice of absence: invalid length%d\n",
+					 noa_len);
 				return;
 			} else {
 				noa_num = (noa_len - 2) / 13;
@@ -887,7 +886,7 @@ void rtl92e_p2p_ps_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state)
 	struct rtl_ps_ctl *rtlps = rtl_psc(rtl_priv(hw));
 	struct rtl_p2p_ps_info  *p2pinfo = &(rtlpriv->psc.p2p_ps_info);
 
-	RT_TRACE(COMP_FW, DBG_LOUD, ("p2p state %x\n", p2p_ps_state));
+	RT_TRACE(COMP_FW, DBG_LOUD, "p2p state %x\n", p2p_ps_state);
 	switch (p2p_ps_state) {
 	case P2P_PS_DISABLE:
 		p2pinfo->p2p_ps_state = p2p_ps_state;
@@ -939,17 +938,17 @@ void rtl92e_p2p_ps_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state)
 	default:
 		break;
 	}
-	RT_TRACE(COMP_FW, DBG_LOUD, (" ctwindow %x oppps %x\n",
-				     p2pinfo->ctwindow , p2pinfo->opp_ps));
+	RT_TRACE(COMP_FW, DBG_LOUD, " ctwindow %x oppps %x\n",
+		 p2pinfo->ctwindow , p2pinfo->opp_ps);
 	RT_TRACE(COMP_FW, DBG_LOUD,
-		 ("count %x duration %x index %x interval %x start time %x noa num %x\n",
+		 "count %x duration %x index %x interval %x start time %x noa num %x\n",
 		 p2pinfo->noa_count_type[0],
 		 p2pinfo->noa_duration[0],
 		 p2pinfo->noa_index,
 		 p2pinfo->noa_interval[0],
 		 p2pinfo->noa_start_time[0],
-		 p2pinfo->noa_num));
-	RT_TRACE(COMP_FW, DBG_LOUD, ("end\n"));
+		 p2pinfo->noa_num);
+	RT_TRACE(COMP_FW, DBG_LOUD, "end\n");
 }
 
 void rtl92e_p2p_info(struct ieee80211_hw *hw, void *data, unsigned int len)
diff --git a/drivers/staging/rtl8192ee/rc.c b/drivers/staging/rtl8192ee/rc.c
index c4c34dd..31146a5 100644
--- a/drivers/staging/rtl8192ee/rc.c
+++ b/drivers/staging/rtl8192ee/rc.c
@@ -250,7 +250,7 @@ static void *rtl_rate_alloc_sta(void *ppriv,
 	rate_priv = kzalloc(sizeof(*rate_priv), gfp);
 	if (!rate_priv) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Unable to allocate private rc structure\n"));
+			 "Unable to allocate private rc structure\n");
 		return NULL;
 	}
 
diff --git a/drivers/staging/rtl8192ee/regd.c b/drivers/staging/rtl8192ee/regd.c
index 7272fae..58b1d9f 100644
--- a/drivers/staging/rtl8192ee/regd.c
+++ b/drivers/staging/rtl8192ee/regd.c
@@ -407,12 +407,12 @@ int rtl92e_regd_init(struct ieee80211_hw *hw,
 	rtlpriv->regd.country_code = rtlpriv->efuse.channel_plan;
 
 	RT_TRACE(COMP_REGD, DBG_TRACE,
-		 (KERN_DEBUG "rtl: EEPROM regdomain: 0x%0x\n",
-		  rtlpriv->regd.country_code));
+		 KERN_DEBUG "rtl: EEPROM regdomain: 0x%0x\n",
+		  rtlpriv->regd.country_code);
 
 	if (rtlpriv->regd.country_code >= COUNTRY_CODE_MAX) {
 		RT_TRACE(COMP_REGD, DBG_DMESG,
-			 ("rtl: EEPROM indicates invalid contry code world wide 13 should be used\n"));
+			 "rtl: EEPROM indicates invalid contry code world wide 13 should be used\n");
 
 		rtlpriv->regd.country_code = COUNTRY_CODE_WORLD_WIDE_13;
 	}
@@ -428,8 +428,8 @@ int rtl92e_regd_init(struct ieee80211_hw *hw,
 	}
 
 	RT_TRACE(COMP_REGD, DBG_TRACE,
-		 (KERN_DEBUG "rtl: Country alpha2 being used: %c%c\n",
-		  rtlpriv->regd.alpha2[0], rtlpriv->regd.alpha2[1]));
+		 KERN_DEBUG "rtl: Country alpha2 being used: %c%c\n",
+		  rtlpriv->regd.alpha2[0], rtlpriv->regd.alpha2[1]);
 
 	_rtl92e_regd_init_wiphy(&rtlpriv->regd, wiphy, reg_notifier);
 
@@ -442,7 +442,7 @@ void rtl92e_reg_notifier(struct wiphy *wiphy,
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	RT_TRACE(COMP_REGD, DBG_LOUD, ("\n"));
+	RT_TRACE(COMP_REGD, DBG_LOUD, "\n");
 
 	_rtl92e_reg_notifier_apply(wiphy, request, &rtlpriv->regd);
 }
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/dm.c b/drivers/staging/rtl8192ee/rtl8192ee/dm.c
index 41c2d98..64254c4 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/dm.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/dm.c
@@ -256,16 +256,15 @@ static void rtl92ee_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 
 
 	RT_TRACE(COMP_DIG, DBG_TRACE,
-		 ("cnt_parity_fail = %d, cnt_rate_illegal = %d, "
-		  "cnt_crc8_fail = %d, cnt_mcs_fail = %d\n",
-		  falsealm_cnt->cnt_parity_fail,
-		  falsealm_cnt->cnt_rate_illegal,
-		  falsealm_cnt->cnt_crc8_fail, falsealm_cnt->cnt_mcs_fail));
+		 "cnt_parity_fail = %d, cnt_rate_illegal = %d, cnt_crc8_fail = %d, cnt_mcs_fail = %d\n",
+		 falsealm_cnt->cnt_parity_fail,
+		 falsealm_cnt->cnt_rate_illegal,
+		 falsealm_cnt->cnt_crc8_fail, falsealm_cnt->cnt_mcs_fail);
 
 	RT_TRACE(COMP_DIG, DBG_TRACE,
-		 ("cnt_ofdm_fail = %x, cnt_cck_fail = %x, cnt_all = %x\n",
-		  falsealm_cnt->cnt_ofdm_fail,
-		  falsealm_cnt->cnt_cck_fail, falsealm_cnt->cnt_all));
+		 "cnt_ofdm_fail = %x, cnt_cck_fail = %x, cnt_all = %x\n",
+		 falsealm_cnt->cnt_ofdm_fail,
+		 falsealm_cnt->cnt_cck_fail, falsealm_cnt->cnt_all);
 }
 
 static void rtl92ee_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
@@ -341,7 +340,7 @@ static void rtl92ee_dm_dig(struct ieee80211_hw *hw)
 	} else {
 		dm_dig.rx_gain_range_max = dm_dig_max;
 		dig_dynamic_min = dm_dig_min;
-		RT_TRACE(COMP_DIG, DBG_LOUD, ("no link\n"));
+		RT_TRACE(COMP_DIG, DBG_LOUD, "no link\n");
 	}
 
 	if (rtlpriv->falsealm_cnt.cnt_all > 10000) {
@@ -496,7 +495,7 @@ static void rtl92ee_dm_find_minimum_rssi(struct ieee80211_hw *hw)
 	    (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb == 0)) {
 		rtl_dm_dig->min_undecorated_pwdb_for_dm = 0;
 		RT_TRACE(COMP_BB_POWERSAVING, DBG_LOUD,
-			 ("Not connected to any\n"));
+			 "Not connected to any\n");
 	}
 	if (mac->link_state >= MAC80211_LINKED) {
 		if (mac->opmode == NL80211_IFTYPE_AP ||
@@ -504,24 +503,24 @@ static void rtl92ee_dm_find_minimum_rssi(struct ieee80211_hw *hw)
 			rtl_dm_dig->min_undecorated_pwdb_for_dm =
 				rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
 			RT_TRACE(COMP_BB_POWERSAVING, DBG_LOUD,
-			      ("AP Client PWDB = 0x%lx\n",
-			       rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb));
+				 "AP Client PWDB = 0x%lx\n",
+				 rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb);
 		} else {
 			rtl_dm_dig->min_undecorated_pwdb_for_dm =
 			    rtlpriv->dm.undecorated_smoothed_pwdb;
 			RT_TRACE(COMP_BB_POWERSAVING, DBG_LOUD,
-				("STA Default Port PWDB = 0x%x\n",
-				rtl_dm_dig->min_undecorated_pwdb_for_dm));
+				 "STA Default Port PWDB = 0x%x\n",
+				 rtl_dm_dig->min_undecorated_pwdb_for_dm);
 		}
 	} else {
 		rtl_dm_dig->min_undecorated_pwdb_for_dm =
 			rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
 		RT_TRACE(COMP_BB_POWERSAVING, DBG_LOUD,
-			("AP Ext Port or disconnet PWDB = 0x%x\n",
-			rtl_dm_dig->min_undecorated_pwdb_for_dm));
+			 "AP Ext Port or disconnet PWDB = 0x%x\n",
+			 rtl_dm_dig->min_undecorated_pwdb_for_dm);
 	}
-	RT_TRACE(COMP_DIG, DBG_LOUD, ("MinUndecoratedPWDBForDM =%d\n",
-		rtl_dm_dig->min_undecorated_pwdb_for_dm));
+	RT_TRACE(COMP_DIG, DBG_LOUD, "MinUndecoratedPWDBForDM =%d\n",
+		 rtl_dm_dig->min_undecorated_pwdb_for_dm);
 }
 
 static void rtl92ee_dm_check_rssi_monitor(struct ieee80211_hw *hw)
@@ -842,8 +841,7 @@ static void rtl92ee_dm_dynamic_atc_switch(struct ieee80211_hw *hw)
 		if (rtlpriv->cfg->ops->get_btc_status()) {
 			if (!rtlpriv->btcoexist.btc_ops->btc_is_bt_disabled(rtlpriv)) {
 				RT_TRACE(COMP_BT_COEXIST, DBG_LOUD,
-					("odm_DynamicATCSwitch(): "
-					"Disable CFO tracking for BT!!\n"));
+					 "odm_DynamicATCSwitch(): Disable CFO tracking for BT!!\n");
 				return;
 			}
 		}
@@ -1003,7 +1001,8 @@ static bool _rtl92ee_dm_ra_state_check(struct ieee80211_hw *hw,
 
 	default:
 			RT_TRACE(COMP_RATR, DBG_DMESG,
-				("wrong rssi level setting %d !", *ratr_state));
+				 "wrong rssi level setting %d !\n",
+				 *ratr_state);
 			break;
 	}
 
@@ -1032,14 +1031,13 @@ static void rtl92ee_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 	struct ieee80211_sta *sta = NULL;
 
 	if (is_hal_stop(rtlhal)) {
-		RT_TRACE(COMP_RATE, DBG_LOUD,
-			 ("driver is going to unload\n"));
+		RT_TRACE(COMP_RATE, DBG_LOUD, "driver is going to unload\n");
 		return;
 	}
 
 	if (!rtlpriv->dm.b_useramask) {
 		RT_TRACE(COMP_RATE, DBG_LOUD,
-			 ("driver does not control rate adaptive mask\n"));
+			 "driver does not control rate adaptive mask\n");
 		return;
 	}
 
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/fw.c b/drivers/staging/rtl8192ee/rtl8192ee/fw.c
index ea6cafa..5b98c50 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/fw.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/fw.c
@@ -115,7 +115,7 @@ static void _rtl92ee_write_fw(struct ieee80211_hw *hw,
 	u32 pageNums, remainSize;
 	u32 page, offset;
 
-	RT_TRACE(COMP_FW, DBG_LOUD , ("FW size is %d bytes,\n", size));
+	RT_TRACE(COMP_FW, DBG_LOUD , "FW size is %d bytes\n", size);
 
 	_rtl92ee_fill_dummy(bufferPtr, &size);
 
@@ -124,7 +124,7 @@ static void _rtl92ee_write_fw(struct ieee80211_hw *hw,
 
 	if (pageNums > 8) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Page numbers should not greater then 8\n"));
+			 "Page numbers should not greater then 8\n");
 	}
 
 	for (page = 0; page < pageNums; page++) {
@@ -157,13 +157,13 @@ static int _rtl92ee_fw_free_to_go(struct ieee80211_hw *hw)
 
 	if (counter >= FW_8192C_POLLING_TIMEOUT_COUNT) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("chksum report faill ! REG_MCUFWDL:0x%08x .\n",
-			  value32));
+			 "chksum report faill ! REG_MCUFWDL:0x%08x\n",
+			 value32);
 		goto exit;
 	}
 
 	RT_TRACE(COMP_FW, DBG_TRACE,
-		 ("Checksum report OK ! REG_MCUFWDL:0x%08x .\n", value32));
+		 "Checksum report OK ! REG_MCUFWDL:0x%08x\n", value32);
 
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
@@ -176,9 +176,9 @@ static int _rtl92ee_fw_free_to_go(struct ieee80211_hw *hw)
 	do {
 		value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 		if (value32 & WINTINI_RDY) {
-			RT_TRACE(COMP_FW, DBG_LOUD ,
-				("Polling FW ready success!! REG_MCUFWDL:"
-				"0x%08x. count = %d\n", value32, counter));
+			RT_TRACE(COMP_FW, DBG_LOUD,
+				 "Polling FW ready success!! REG_MCUFWDL:0x%08x. count = %d\n",
+				 value32, counter);
 			err = 0;
 			goto exit;
 		}
@@ -188,8 +188,8 @@ static int _rtl92ee_fw_free_to_go(struct ieee80211_hw *hw)
 	} while (counter++ < FW_8192C_POLLING_TIMEOUT_COUNT);
 
 	RT_TRACE(COMP_ERR, DBG_EMERG,
-		 ("Polling FW ready fail!! REG_MCUFWDL:0x%08x. count = %d\n",
-		 value32, counter));
+		 "Polling FW ready fail!! REG_MCUFWDL:0x%08x. count = %d\n",
+		 value32, counter);
 
 exit:
 	return err;
@@ -213,21 +213,20 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 	rtlhal->fw_subversion = pfwheader->subversion;
 	pfwdata = (u8 *) rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
-	RT_TRACE(COMP_FW, DBG_DMESG,
-		 ("normal Firmware SIZE %d\n" , fwsize));
+	RT_TRACE(COMP_FW, DBG_DMESG, "normal Firmware SIZE %d\n", fwsize);
 
 	if (IS_FW_HEADER_EXIST(pfwheader)) {
 		RT_TRACE(COMP_FW, DBG_DMESG,
-			 ("Firmware Version(%d), Signature(%#x), Size(%d)\n",
-			  pfwheader->version, pfwheader->signature,
-			  (int)sizeof(struct rtl92c_firmware_header)));
+			 "Firmware Version(%d), Signature(%#x), Size(%d)\n",
+			 pfwheader->version, pfwheader->signature,
+			 (int)sizeof(struct rtl92c_firmware_header));
 
 		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
 		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
 	} else {
 		RT_TRACE(COMP_FW, DBG_DMESG,
-			 ("Firmware no Header, Signature(%#x)\n",
-			  pfwheader->signature));
+			 "Firmware no Header, Signature(%#x)\n",
+			 pfwheader->signature);
 	}
 
 	if (rtlhal->b_mac_func_enable) {
@@ -243,10 +242,9 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 	err = _rtl92ee_fw_free_to_go(hw);
 	if (err) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Firmware is not ready to run!\n"));
+			 "Firmware is not ready to run!\n");
 	} else {
-		RT_TRACE(COMP_FW, DBG_LOUD ,
-			 ("Firmware is ready to run!\n"));
+		RT_TRACE(COMP_FW, DBG_LOUD, "Firmware is ready to run!\n");
 	}
 
 	return 0;
@@ -284,13 +282,12 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 
 	if (ppsc->dot11_psmode != EACTIVE ||
 		ppsc->inactive_pwrstate == ERFOFF) {
-		RT_TRACE(COMP_CMD, DBG_LOUD ,
-			("FillH2CCommand8192E(): "
-			"Return because RF is off!!!\n"));
+		RT_TRACE(COMP_CMD, DBG_LOUD,
+			 "FillH2CCommand8192E(): Return because RF is off!!!\n");
 		return;
 	}
 
-	RT_TRACE(COMP_CMD, DBG_LOUD , ("come in\n"));
+	RT_TRACE(COMP_CMD, DBG_LOUD, "come in\n");
 
 	/* 1. Prevent race condition in setting H2C cmd.
 	 * (copy from MgntActSet_RF_State().)
@@ -299,16 +296,16 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 		spin_lock_irqsave(&rtlpriv->locks.h2c_lock, flag);
 		if (rtlhal->b_h2c_setinprogress) {
 			RT_TRACE(COMP_CMD, DBG_LOUD ,
-				 ("H2C set in progress! Wait to set.."
-				  "element_id(%d).\n", element_id));
+				 "H2C set in progress! Wait to set..element_id(%d)\n",
+				 element_id);
 
 			while (rtlhal->b_h2c_setinprogress) {
 				spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock,
 						       flag);
 				h2c_waitcounter++;
-				RT_TRACE(COMP_CMD, DBG_LOUD ,
-					 ("Wait 100 us (%d times)...\n",
-					  h2c_waitcounter));
+				RT_TRACE(COMP_CMD, DBG_LOUD,
+					 "Wait 100 us (%d times)...\n",
+					 h2c_waitcounter);
 				udelay(100);
 
 				if (h2c_waitcounter > 1000)
@@ -329,8 +326,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 		/*wait_writeh2c_limmit--;
 		if (wait_writeh2c_limmit == 0) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("Write H2C fail because no trigger "
-				  "for FW INT!\n"));
+				 "Write H2C fail because no trigger for FW INT!\n");
 			break;
 		}
 		*/
@@ -355,7 +351,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 			break;
 		default:
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("switch case not process\n"));
+				 "switch case not processed\n");
 			break;
 		}
 
@@ -377,19 +373,18 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 			while (!isfw_read) {
 				wait_h2c_limmit--;
 				if (wait_h2c_limmit == 0) {
-					RT_TRACE(COMP_CMD, DBG_LOUD ,
-						("Wating too long for FW"
-						"read clear HMEBox(%d)!!!\n",
-						boxnum));
+					RT_TRACE(COMP_CMD, DBG_LOUD,
+						 "Wating too long for FW read clear HMEBox(%d)!!!\n",
+						 boxnum);
 					break;
 				}
 				udelay(10);
 				isfw_read = _rtl92ee_check_fw_read_last_h2c(hw,
 									boxnum);
 				u1b_tmp = rtl_read_byte(rtlpriv, 0x130);
-				RT_TRACE(COMP_CMD, DBG_LOUD ,
-					 ("Wating for FW read clear HMEBox(%d)!!! 0x130 = %2x\n",
-					 boxnum, u1b_tmp));
+				RT_TRACE(COMP_CMD, DBG_LOUD,
+					 "Waiting for FW read clear HMEBox(%d)!!! 0x130 = %2x\n",
+					 boxnum, u1b_tmp);
 			}
 		}
 
@@ -397,17 +392,17 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 		 H2C cmd, break and give up this H2C. */
 		if (!isfw_read) {
 			RT_TRACE(COMP_CMD, DBG_LOUD ,
-				 ("Write H2C reg BOX[%d] fail, Fw don't read.\n",
-				 boxnum));
+				 "Write H2C reg BOX[%d] fail, Fw doesn't read\n",
+				 boxnum);
 			break;
 		}
 		/* 4. Fill the H2C cmd into box */
 		memset(boxcontent, 0, sizeof(boxcontent));
 		memset(boxextcontent, 0, sizeof(boxextcontent));
 		boxcontent[0] = element_id;
-		RT_TRACE(COMP_CMD, DBG_LOUD ,
-			 ("Write element_id box_reg(%4x) = %2x\n",
-			  box_reg, element_id));
+		RT_TRACE(COMP_CMD, DBG_LOUD,
+			 "Write element_id box_reg(%4x) = %2x\n",
+			 box_reg, element_id);
 
 		switch (cmd_len) {
 		case 1:
@@ -444,7 +439,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 			break;
 		default:
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("switch case not process\n"));
+				 "switch case not processed\n");
 			break;
 		}
 
@@ -454,16 +449,15 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 		if (rtlhal->last_hmeboxnum == 4)
 			rtlhal->last_hmeboxnum = 0;
 
-		RT_TRACE(COMP_CMD, DBG_LOUD ,
-			 ("pHalData->last_hmeboxnum  = %d\n",
-			  rtlhal->last_hmeboxnum));
+		RT_TRACE(COMP_CMD, DBG_LOUD, "pHalData->last_hmeboxnum  = %d\n",
+			 rtlhal->last_hmeboxnum);
 	}
 
 	spin_lock_irqsave(&rtlpriv->locks.h2c_lock, flag);
 	rtlhal->b_h2c_setinprogress = false;
 	spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
 
-	RT_TRACE(COMP_CMD, DBG_LOUD , ("go out\n"));
+	RT_TRACE(COMP_CMD, DBG_LOUD, "go out\n");
 }
 
 void rtl92ee_fill_h2c_cmd(struct ieee80211_hw *hw,
@@ -504,8 +498,8 @@ void rtl92ee_firmware_selfreset(struct ieee80211_hw *hw)
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, (u1b_tmp | BIT(2)));
 
-	RT_TRACE(COMP_INIT, DBG_LOUD ,
-		 ("  _8051Reset92E(): 8051 reset success .\n"));
+	RT_TRACE(COMP_INIT, DBG_LOUD,
+		 "  _8051Reset92E(): 8051 reset success\n");
 }
 
 void rtl92ee_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
@@ -514,7 +508,7 @@ void rtl92ee_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	u8 u1_h2c_set_pwrmode[H2C_92E_PWEMODE_LENGTH] = { 0 };
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	u8 rlbm , power_state = 0;
-	RT_TRACE(COMP_POWER, DBG_LOUD , ("FW LPS mode = %d\n", mode));
+	RT_TRACE(COMP_POWER, DBG_LOUD, "FW LPS mode = %d\n", mode);
 
 	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, ((mode) ? 1 : 0));
 	rlbm = 0;/*YJ, temp, 120316. FW now not support RLBM = 2.*/
@@ -776,15 +770,15 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		b_dlok = true;
 
 	if (b_dlok) {
-		RT_TRACE(COMP_POWER, DBG_LOUD ,
-			 ("Set RSVD page location to Fw.\n"));
+		RT_TRACE(COMP_POWER, DBG_LOUD,
+			 "Set RSVD page location to Fw\n");
 		RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD ,
 			      "H2C_RSVDPAGE:\n", u1RsvdPageLoc, 3);
 		rtl92ee_fill_h2c_cmd(hw, H2C_92E_RSVDPAGE,
 				     sizeof(u1RsvdPageLoc), u1RsvdPageLoc);
 	} else
 		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("Set RSVD page location to Fw FAIL!!!!!!.\n"));
+			 "Set RSVD page location to Fw FAIL!!!!!!\n");
 }
 
 /*Shoud check FW support p2p or not.*/
@@ -809,11 +803,11 @@ void rtl92ee_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state)
 
 	switch (p2p_ps_state) {
 	case P2P_PS_DISABLE:
-		RT_TRACE(COMP_FW, DBG_LOUD , ("P2P_PS_DISABLE\n"));
+		RT_TRACE(COMP_FW, DBG_LOUD, "P2P_PS_DISABLE\n");
 		memset(p2p_ps_offload, 0, 1);
 		break;
 	case P2P_PS_ENABLE:
-		RT_TRACE(COMP_FW, DBG_LOUD , ("P2P_PS_ENABLE\n"));
+		RT_TRACE(COMP_FW, DBG_LOUD, "P2P_PS_ENABLE\n");
 		/* update CTWindow value. */
 		if (p2pinfo->ctwindow > 0) {
 			p2p_ps_offload->CTWindow_En = 1;
@@ -864,11 +858,11 @@ void rtl92ee_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state)
 		}
 		break;
 	case P2P_PS_SCAN:
-		RT_TRACE(COMP_FW, DBG_LOUD , ("P2P_PS_SCAN\n"));
+		RT_TRACE(COMP_FW, DBG_LOUD, "P2P_PS_SCAN\n");
 		p2p_ps_offload->discovery = 1;
 		break;
 	case P2P_PS_SCAN_DONE:
-		RT_TRACE(COMP_FW, DBG_LOUD , ("P2P_PS_SCAN_DONE\n"));
+		RT_TRACE(COMP_FW, DBG_LOUD, "P2P_PS_SCAN_DONE\n");
 		p2p_ps_offload->discovery = 0;
 		p2pinfo->p2p_ps_state = P2P_PS_ENABLE;
 		break;
@@ -897,28 +891,28 @@ static void _rtl92ee_c2h_content_parsing(struct ieee80211_hw *hw, u8 c2h_cmd_id,
 
 	switch (c2h_cmd_id) {
 	case C2H_8192E_DBG:
-		RT_TRACE(COMP_FW, DBG_TRACE , ("[C2H], C2H_8723BE_DBG!!\n"));
+		RT_TRACE(COMP_FW, DBG_TRACE, "[C2H], C2H_8723BE_DBG!!\n");
 		break;
 	case C2H_8192E_TXBF:
-		RT_TRACE(COMP_FW, DBG_TRACE , ("[C2H], C2H_8192E_TXBF!!\n"));
+		RT_TRACE(COMP_FW, DBG_TRACE, "[C2H], C2H_8192E_TXBF!!\n");
 		break;
 	case C2H_8192E_TX_REPORT:
-		RT_TRACE(COMP_FW, DBG_TRACE , ("[C2H], C2H_8723BE_TX_REPORT!\n"));
+		RT_TRACE(COMP_FW, DBG_TRACE, "[C2H], C2H_8723BE_TX_REPORT!\n");
 		break;
 	case C2H_8192E_BT_INFO:
-		RT_TRACE(COMP_FW, DBG_TRACE , ("[C2H], C2H_8723BE_BT_INFO!!\n"));
+		RT_TRACE(COMP_FW, DBG_TRACE, "[C2H], C2H_8723BE_BT_INFO!!\n");
 		rtlpriv->btcoexist.btc_ops->btc_btinfo_notify(rtlpriv, tmp_buf,
 							      c2h_cmd_len);
 		break;
 	case C2H_8192E_BT_MP:
-		RT_TRACE(COMP_FW, DBG_TRACE, ("[C2H], C2H_8723BE_BT_MP!!\n"));
+		RT_TRACE(COMP_FW, DBG_TRACE, "[C2H], C2H_8723BE_BT_MP!!\n");
 		break;
 	case C2H_8192E_RA_RPT:
 		_rtl92ee_c2h_ra_report_handler(hw, tmp_buf, c2h_cmd_len);
 		break;
 	default:
 		RT_TRACE(COMP_FW, DBG_TRACE,
-			 ("[C2H], Unkown packet!! CmdId(%#X)!\n", c2h_cmd_id));
+			 "[C2H], Unkown packet!! CmdId(%#X)!\n", c2h_cmd_id);
 		break;
 	}
 }
@@ -935,8 +929,8 @@ void rtl92ee_c2h_packet_handler(struct ieee80211_hw *hw, u8 *buffer, u8 len)
 	tmp_buf = buffer + 2;
 
 	RT_TRACE(COMP_FW, DBG_TRACE,
-		("[C2H packet], c2hCmdId = 0x%x, c2hCmdSeq = 0x%x, c2hCmdLen =%d\n",
-		c2h_cmd_id, c2h_cmd_seq, c2h_cmd_len));
+		 "[C2H packet], c2hCmdId = 0x%x, c2hCmdSeq = 0x%x, c2hCmdLen =%d\n",
+		 c2h_cmd_id, c2h_cmd_seq, c2h_cmd_len);
 
 	RT_PRINT_DATA(rtlpriv, COMP_FW, DBG_TRACE,
 		      "[C2H packet], Content Hex:\n", tmp_buf, c2h_cmd_len);
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/hw.c b/drivers/staging/rtl8192ee/rtl8192ee/hw.c
index 26af119..780f617 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/hw.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/hw.c
@@ -161,8 +161,8 @@ static void _rtl92ee_set_fw_clock_on(struct ieee80211_hw *hw,
 				rtl_write_word(rtlpriv , isr_regaddr, 0x0100);
 				rtlhal->fw_ps_state = FW_PS_STATE_RF_ON_92E;
 				RT_TRACE(COMP_POWER, DBG_LOUD,
-					 ("Receive CPWM INT!!! PSState = %X\n",
-					 rtlhal->fw_ps_state));
+					 "Receive CPWM INT!!! PSState = %X\n",
+					 rtlhal->fw_ps_state);
 			}
 		}
 
@@ -357,8 +357,8 @@ void rtl92ee_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 
 		break; }
 	default:
-		RT_TRACE(COMP_ERR, DBG_LOUD,
-			 ("switch case not process %x\n", variable));
+		RT_TRACE(COMP_ERR, DBG_LOUD, "switch case not processed %x\n",
+			 variable);
 		break;
 	}
 }
@@ -430,7 +430,7 @@ static void _rtl92ee_download_rsvd_page(struct ieee80211_hw *hw)
 	} while (!(bcnvalid_reg & BIT(0)) && dlbcn_count < 5);
 
 	if (!(bcnvalid_reg & BIT(0)))
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("Download RSVD page failed!\n"));
+		RT_TRACE(COMP_INIT, DBG_LOUD, "Download RSVD page failed!\n");
 
 	/* Enable Bcn */
 	_rtl92ee_set_bcn_ctrl_reg(hw, BIT(3), 0);
@@ -488,8 +488,7 @@ void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_SLOT_TIME:{
 		u8 e_aci;
 
-		RT_TRACE(COMP_MLME, DBG_TRACE,
-			 ("HW_VAR_SLOT_TIME %x\n", val[0]));
+		RT_TRACE(COMP_MLME, DBG_TRACE, "HW_VAR_SLOT_TIME %x\n", val[0]);
 
 		rtl_write_byte(rtlpriv, REG_SLOT, val[0]);
 
@@ -533,7 +532,7 @@ void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 						       reg[i]);
 				}
 				RT_TRACE(COMP_MLME, DBG_LOUD,
-					("Set HW_VAR_AMPDU_FACTOR:%#x\n", fac));
+					 "Set HW_VAR_AMPDU_FACTOR:%#x\n", fac);
 		}
 		break; }
 	case HW_VAR_AC_PARAM:{
@@ -565,8 +564,8 @@ void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 				break;
 			default:
 				RT_TRACE(COMP_ERR, DBG_WARNING,
-					 ("HW_VAR_ACM_CTRL acm set "
-					  "failed: eACI is %d\n", acm));
+					 "HW_VAR_ACM_CTRL acm set failed: eACI is %d\n",
+					 acm);
 				break;
 			}
 		} else {
@@ -582,14 +581,14 @@ void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 				break;
 			default:
 				RT_TRACE(COMP_ERR, DBG_LOUD,
-					 ("switch case not process \n"));
+					 "switch case not processed\n");
 				break;
 			}
 		}
 
 		RT_TRACE(COMP_QOS, DBG_TRACE,
-			 ("SetHwReg8190pci(): [HW_VAR_ACM_CTRL] Write 0x%X\n",
-			  acm_ctrl));
+			 "SetHwReg8190pci(): [HW_VAR_ACM_CTRL] Write 0x%X\n",
+			 acm_ctrl);
 		rtl_write_byte(rtlpriv, REG_ACMHWCTRL, acm_ctrl);
 		break; }
 	case HW_VAR_RCR:{
@@ -689,8 +688,8 @@ void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		rtl92ee_fill_h2c_cmd(hw, H2C_92E_KEEP_ALIVE_CTRL, 2, array);
 		break; }
 	default:
-		RT_TRACE(COMP_ERR, DBG_LOUD,
-			 ("switch case not process %x\n", variable));
+		RT_TRACE(COMP_ERR, DBG_LOUD, "switch case not processed %x\n",
+			 variable);
 		break;
 	}
 }
@@ -795,7 +794,7 @@ static bool _rtl92ee_init_mac(struct ieee80211_hw *hw)
 	if (!rtl92e_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
 		PWR_INTF_PCI_MSK, Rtl8192E_NIC_ENABLE_FLOW)) {
 		RT_TRACE(COMP_INIT, DBG_LOUD,
-			 ("init MAC Fail as rtl92e_hal_pwrseqcmdparsing\n"));
+			 "init MAC Fail as rtl92e_hal_pwrseqcmdparsing\n");
 		return false;
 	}
 
@@ -818,8 +817,7 @@ static bool _rtl92ee_init_mac(struct ieee80211_hw *hw)
 
 	if (!rtlhal->b_mac_func_enable) {
 		if (_rtl92ee_llt_table_init(hw) == false) {
-			RT_TRACE(COMP_INIT, DBG_LOUD,
-				 ("LLT table init fail \n"));
+			RT_TRACE(COMP_INIT, DBG_LOUD, "LLT table init fail\n");
 			return false;
 		}
 	}
@@ -1112,12 +1110,12 @@ void rtl92ee_enable_hw_security_config(struct ieee80211_hw *hw)
 	u8 tmp;
 
 	RT_TRACE(COMP_INIT, DBG_DMESG,
-		 ("PairwiseEncAlgorithm = %d GroupEncAlgorithm = %d\n",
-		  rtlpriv->sec.pairwise_enc_algorithm,
-		  rtlpriv->sec.group_enc_algorithm));
+		 "PairwiseEncAlgorithm = %d GroupEncAlgorithm = %d\n",
+		 rtlpriv->sec.pairwise_enc_algorithm,
+		 rtlpriv->sec.group_enc_algorithm);
 
 	if (rtlpriv->cfg->mod_params->sw_crypto || rtlpriv->sec.use_sw_sec) {
-		RT_TRACE(COMP_SEC, DBG_DMESG, ("not open hw encryption\n"));
+		RT_TRACE(COMP_SEC, DBG_DMESG, "not open hw encryption\n");
 		return;
 	}
 
@@ -1133,8 +1131,7 @@ void rtl92ee_enable_hw_security_config(struct ieee80211_hw *hw)
 	tmp = rtl_read_byte(rtlpriv, REG_CR + 1);
 	rtl_write_byte(rtlpriv, REG_CR + 1, tmp | BIT(1));
 
-	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("The SECR-value %x \n", sec_reg_value));
+	RT_TRACE(COMP_SEC, DBG_DMESG, "The SECR-value %x\n", sec_reg_value);
 
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_WPA_CONFIG, &sec_reg_value);
 
@@ -1152,7 +1149,7 @@ int rtl92ee_hw_init(struct ieee80211_hw *hw)
 	u8 tmp_u1b , u1byte;
 	u32 tmp_u4b;
 
-	RT_TRACE(COMP_INIT , DBG_LOUD , (" Rtl8192EE hw init\n"));
+	RT_TRACE(COMP_INIT, DBG_LOUD, " Rtl8192EE hw init\n");
 	rtlpriv->rtlhal.being_init_adapter = true;
 	rtlpriv->intf_ops->disable_aspm(hw);
 
@@ -1180,7 +1177,7 @@ int rtl92ee_hw_init(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, 0x65, 1);
 	}
 	if (rtstatus != true) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("Init MAC failed\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Init MAC failed\n");
 		err = 1;
 		return err;
 	}
@@ -1189,7 +1186,7 @@ int rtl92ee_hw_init(struct ieee80211_hw *hw)
 	err = rtl92ee_download_fw(hw , false);
 	if (err) {
 		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("Failed to download FW. Init HW without FW now..\n"));
+			 "Failed to download FW. Init HW without FW now..\n");
 		err = 1;
 		rtlhal->bfw_ready = false;
 		return err;
@@ -1267,12 +1264,12 @@ int rtl92ee_hw_init(struct ieee80211_hw *hw)
 	stg_efuse_one_byte_read(hw, 0x1FA, &tmp_u1b);
 	if (!(tmp_u1b & BIT(0))) {
 		rtl_set_rfreg(hw, RF90_PATH_A, 0x15, 0x0F, 0x05);
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("PA BIAS path A\n"));
+		RT_TRACE(COMP_INIT, DBG_LOUD, "PA BIAS path A\n");
 	}
 
 	if ((!(tmp_u1b & BIT(1))) && (rtlphy->rf_type == RF_2T2R)) {
 		rtl_set_rfreg(hw, RF90_PATH_B, 0x15, 0x0F, 0x05);
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("PA BIAS path B\n"));
+		RT_TRACE(COMP_INIT, DBG_LOUD, "PA BIAS path B\n");
 	}
 
 	rtl_write_byte(rtlpriv, REG_NAV_UPPER, ((30000 + 127) / 128));
@@ -1287,7 +1284,7 @@ int rtl92ee_hw_init(struct ieee80211_hw *hw)
 
 	rtl_write_dword(rtlpriv, 0x4fc, 0);
 
-	RT_TRACE(COMP_INIT , DBG_LOUD , ("end of Rtl8192EE hw init %x\n" , err));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "end of Rtl8192EE hw init %x\n", err);
 	return 0;
 }
 
@@ -1306,9 +1303,8 @@ static enum version_8192e _rtl92ee_read_chip_version(struct ieee80211_hw *hw)
 	else
 		version = (enum version_8192e) VERSION_NORMAL_CHIP_2T2R_8192E;
 
-	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("Chip RF Type: %s\n", (rtlphy->rf_type == RF_2T2R) ?
-		  "RF_2T2R" : "RF_1T1R"));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "Chip RF Type: %s\n",
+		 rtlphy->rf_type == RF_2T2R ? "RF_2T2R" : "RF_1T1R");
 
 	return version;
 }
@@ -1326,29 +1322,26 @@ static int _rtl92ee_set_media_status(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_UNSPECIFIED:
 		mode = MSR_NOLINK;
 		RT_TRACE(COMP_INIT, DBG_TRACE,
-			 ("Set Network type to NO LINK!\n"));
+			 "Set Network type to NO LINK!\n");
 		break;
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
 		mode = MSR_ADHOC;
-		RT_TRACE(COMP_INIT, DBG_TRACE,
-			 ("Set Network type to Ad Hoc!\n"));
+		RT_TRACE(COMP_INIT, DBG_TRACE, "Set Network type to Ad Hoc!\n");
 		break;
 	case NL80211_IFTYPE_STATION:
 		mode = MSR_INFRA;
 		ledaction = LED_CTL_LINK;
-		RT_TRACE(COMP_INIT, DBG_TRACE,
-			 ("Set Network type to STA!\n"));
+		RT_TRACE(COMP_INIT, DBG_TRACE, "Set Network type to STA!\n");
 		break;
 	case NL80211_IFTYPE_AP:
 		mode = MSR_AP;
 		ledaction = LED_CTL_LINK;
-		RT_TRACE(COMP_INIT, DBG_TRACE,
-			 ("Set Network type to AP!\n"));
+		RT_TRACE(COMP_INIT, DBG_TRACE, "Set Network type to AP!\n");
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Network type %d not support!\n", type));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Network type %d not support!\n",
+			 type);
 		return 1;
 		break;
 	}
@@ -1372,8 +1365,8 @@ static int _rtl92ee_set_media_status(struct ieee80211_hw *hw,
 		_rtl92ee_disable_bcn_sub_func(hw);
 	} else {
 		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("Set HW_VAR_MEDIA_STATUS: "
-			  "No such media status(%x).\n", mode));
+			 "Set HW_VAR_MEDIA_STATUS: No such media status(%x)\n",
+			 mode);
 	}
 
 	rtl_write_byte(rtlpriv, (MSR), bt_msr | mode);
@@ -1494,7 +1487,7 @@ static void _rtl92ee_poweroff_adapter(struct ieee80211_hw *hw)
 	u8 u1b_tmp;
 	rtlhal->b_mac_func_enable = false;
 
-	RT_TRACE(COMP_INIT , DBG_LOUD , ("POWER OFF adapter \n"));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "POWER OFF adapter\n");
 
 	/* Run LPS WL RFOFF flow */
 	rtl92e_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
@@ -1534,7 +1527,7 @@ void rtl92ee_card_disable(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	enum nl80211_iftype opmode;
 
-	RT_TRACE(COMP_INIT , DBG_LOUD , ("RTL8192ee card disable\n"));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "RTL8192ee card disable\n");
 
 	RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
@@ -1593,8 +1586,7 @@ void rtl92ee_set_beacon_interval(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	u16 bcn_interval = mac->beacon_interval;
 
-	RT_TRACE(COMP_BEACON, DBG_DMESG,
-		 ("beacon_interval:%d\n", bcn_interval));
+	RT_TRACE(COMP_BEACON, DBG_DMESG, "beacon_interval:%d\n", bcn_interval);
 	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
 }
 
@@ -1604,8 +1596,8 @@ void rtl92ee_update_interrupt_mask(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
-	RT_TRACE(COMP_INTR, DBG_LOUD,
-		 ("add_msr:%x, rm_msr:%x\n", add_msr, rm_msr));
+	RT_TRACE(COMP_INTR, DBG_LOUD, "add_msr:%x, rm_msr:%x\n",
+		 add_msr, rm_msr);
 
 	if (add_msr)
 		rtlpci->irq_mask[0] |= add_msr;
@@ -1672,14 +1664,14 @@ static void _rtl8192ee_read_power_value_fromprom(struct ieee80211_hw *hw,
 	u32 rf, addr = EEPROM_TX_PWR_INX, group, i = 0;
 
 	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("hal_ReadPowerValueFromPROM92E(): PROMContent[0x%x]= 0x%x\n",
-		 (addr + 1), hwinfo[addr + 1]));
+		 "hal_ReadPowerValueFromPROM92E(): PROMContent[0x%x]= 0x%x\n",
+		 (addr + 1), hwinfo[addr + 1]);
 	if (0xFF == hwinfo[addr+1])  /*YJ, add, 120316*/
 		autoload_fail = true;
 
 	if (autoload_fail) {
 		RT_TRACE(COMP_INIT, DBG_LOUD,
-			 ("auto load fail : Use Default value!\n"));
+			 "auto load fail : Use Default value!\n");
 		for (rf = 0 ; rf < MAX_RF_PATH ; rf++) {
 			/* 2.4G default value */
 			for (group = 0 ; group < MAX_CHNL_GROUP_24G; group++) {
@@ -1999,11 +1991,11 @@ static void _rtl92ee_read_adapter_info(struct ieee80211_hw *hw)
 		       HWSET_MAX_SIZE);
 	} else if (rtlefuse->epromtype == EEPROM_93C46) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("RTL819X Not boot from eeprom, check it !!"));
+			 "RTL819X Not boot from eeprom, check it !!\n");
 		return;
 	}  else {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("boot from neither eeprom nor efuse, check it !!"));
+			 "boot from neither eeprom nor efuse, check it !!\n");
 		return;
 	}
 
@@ -2012,11 +2004,11 @@ static void _rtl92ee_read_adapter_info(struct ieee80211_hw *hw)
 
 	eeprom_id = *((u16 *) &hwinfo[0]);
 	if (eeprom_id != RTL8192E_EEPROM_ID) {
-		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("EEPROM ID(%#x) is invalid!!\n", eeprom_id));
+		RT_TRACE(COMP_ERR, DBG_WARNING, "EEPROM ID(%#x) is invalid!!\n",
+			 eeprom_id);
 		rtlefuse->autoload_failflag = true;
 	} else {
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("Autoload OK\n"));
+		RT_TRACE(COMP_INIT, DBG_LOUD, "Autoload OK\n");
 		rtlefuse->autoload_failflag = false;
 	}
 
@@ -2027,22 +2019,22 @@ static void _rtl92ee_read_adapter_info(struct ieee80211_hw *hw)
 	rtlefuse->eeprom_did = *(u16 *) &hwinfo[EEPROM_DID];
 	rtlefuse->eeprom_svid = *(u16 *) &hwinfo[EEPROM_SVID];
 	rtlefuse->eeprom_smid = *(u16 *) &hwinfo[EEPROM_SMID];
-	RT_TRACE(COMP_INIT, DBG_LOUD, ("EEPROMId = 0x%4x\n", eeprom_id));
-	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("EEPROM VID = 0x%4x\n", rtlefuse->eeprom_vid));
-	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("EEPROM DID = 0x%4x\n", rtlefuse->eeprom_did));
-	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("EEPROM SVID = 0x%4x\n", rtlefuse->eeprom_svid));
-	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("EEPROM SMID = 0x%4x\n", rtlefuse->eeprom_smid));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "EEPROMId = 0x%4x\n", eeprom_id);
+	RT_TRACE(COMP_INIT, DBG_LOUD, "EEPROM VID = 0x%4x\n",
+		 rtlefuse->eeprom_vid);
+	RT_TRACE(COMP_INIT, DBG_LOUD, "EEPROM DID = 0x%4x\n",
+		 rtlefuse->eeprom_did);
+	RT_TRACE(COMP_INIT, DBG_LOUD, "EEPROM SVID = 0x%4x\n",
+		 rtlefuse->eeprom_svid);
+	RT_TRACE(COMP_INIT, DBG_LOUD, "EEPROM SMID = 0x%4x\n",
+		 rtlefuse->eeprom_smid);
 	/*customer ID*/
 	rtlefuse->eeprom_oemid = *(u8 *) &hwinfo[EEPROM_CUSTOMER_ID];
 	if (rtlefuse->eeprom_oemid == 0xFF)
 		rtlefuse->eeprom_oemid = 0;
 
-	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("EEPROM Customer ID: 0x%2x\n", rtlefuse->eeprom_oemid));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "EEPROM Customer ID: 0x%2x\n",
+		 rtlefuse->eeprom_oemid);
 	/*EEPROM version*/
 	rtlefuse->eeprom_version = *(u8 *) &hwinfo[EEPROM_VERSION];
 	/*mac address*/
@@ -2051,8 +2043,7 @@ static void _rtl92ee_read_adapter_info(struct ieee80211_hw *hw)
 		*((u16 *) (&rtlefuse->dev_addr[i])) = usvalue;
 	}
 
-	RT_TRACE(COMP_INIT, DBG_DMESG,
-		 ("dev_addr: %pM\n", rtlefuse->dev_addr));
+	RT_TRACE(COMP_INIT, DBG_DMESG, "dev_addr: %pM\n", rtlefuse->dev_addr);
 	/*channel plan */
 	rtlefuse->eeprom_channelplan = *(u8 *) &hwinfo[EEPROM_CHANNELPLAN];
 	/* set channel paln to world wide 13 */
@@ -2106,8 +2097,8 @@ static void _rtl92ee_hal_customized_behavior(struct ieee80211_hw *hw)
 
 	pcipriv->ledctl.bled_opendrain = true;
 
-	RT_TRACE(COMP_INIT, DBG_DMESG,
-		 ("RT Customized ID: 0x%02X\n", rtlhal->oem_id));
+	RT_TRACE(COMP_INIT, DBG_DMESG, "RT Customized ID: 0x%02X\n",
+		 rtlhal->oem_id);
 }
 
 void rtl92ee_read_eeprom_info(struct ieee80211_hw *hw)
@@ -2124,22 +2115,22 @@ void rtl92ee_read_eeprom_info(struct ieee80211_hw *hw)
 	else
 		rtlpriv->dm.brfpath_rxenable[0] =
 		    rtlpriv->dm.brfpath_rxenable[1] = true;
-	RT_TRACE(COMP_INIT, DBG_LOUD, ("VersionID = 0x%4x\n",
-						rtlhal->version));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "VersionID = 0x%4x\n",
+		 rtlhal->version);
 	tmp_u1b = rtl_read_byte(rtlpriv, REG_9346CR);
 	if (tmp_u1b & BIT(4)) {
-		RT_TRACE(COMP_INIT, DBG_DMESG, ("Boot from EEPROM\n"));
+		RT_TRACE(COMP_INIT, DBG_DMESG, "Boot from EEPROM\n");
 		rtlefuse->epromtype = EEPROM_93C46;
 	} else {
-		RT_TRACE(COMP_INIT, DBG_DMESG, ("Boot from EFUSE\n"));
+		RT_TRACE(COMP_INIT, DBG_DMESG, "Boot from EFUSE\n");
 		rtlefuse->epromtype = EEPROM_BOOT_EFUSE;
 	}
 	if (tmp_u1b & BIT(5)) {
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("Autoload OK\n"));
+		RT_TRACE(COMP_INIT, DBG_LOUD, "Autoload OK\n");
 		rtlefuse->autoload_failflag = false;
 		_rtl92ee_read_adapter_info(hw);
 	} else {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("Autoload ERR!!\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
 	}
 	_rtl92ee_hal_customized_behavior(hw);
 
@@ -2295,8 +2286,7 @@ static void rtl92ee_update_hal_rate_mask(struct ieee80211_hw *hw,
 	ratr_index = _rtl92ee_mrate_idx_to_arfr_id(hw, ratr_index);
 	sta_entry->ratr_index = ratr_index;
 
-	RT_TRACE(COMP_RATR, DBG_DMESG,
-		 ("ratr_bitmap :%x\n", ratr_bitmap));
+	RT_TRACE(COMP_RATR, DBG_DMESG, "ratr_bitmap:%x\n", ratr_bitmap);
 	*(u32 *) &rate_mask = (ratr_bitmap & 0x0fffffff) |
 				       (ratr_index << 28);
 	rate_mask[0] = macid;
@@ -2307,10 +2297,10 @@ static void rtl92ee_update_hal_rate_mask(struct ieee80211_hw *hw,
 	rate_mask[5] = (u8)((ratr_bitmap & 0x00ff0000) >> 16);
 	rate_mask[6] = (u8)((ratr_bitmap & 0xff000000) >> 24);
 	RT_TRACE(COMP_RATR, DBG_DMESG,
-		 ("Rate_index:%x, ratr_val:%x, %x:%x:%x:%x:%x:%x:%x\n",
-		  ratr_index, ratr_bitmap, rate_mask[0], rate_mask[1],
-		  rate_mask[2], rate_mask[3], rate_mask[4],
-		  rate_mask[5], rate_mask[6]));
+		 "Rate_index:%x, ratr_val:%x, %x:%x:%x:%x:%x:%x:%x\n",
+		 ratr_index, ratr_bitmap, rate_mask[0], rate_mask[1],
+		 rate_mask[2], rate_mask[3], rate_mask[4],
+		 rate_mask[5], rate_mask[6]);
 	rtl92ee_fill_h2c_cmd(hw, H2C_92E_RA_MASK, 7, rate_mask);
 	_rtl92ee_set_bcn_ctrl_reg(hw, BIT(3), 0);
 }
@@ -2372,7 +2362,7 @@ void rtl92ee_set_key(struct ieee80211_hw *hw, u32 key_index,
 		u8 cam_offset = 0;
 		u8 clear_number = 5;
 
-		RT_TRACE(COMP_SEC, DBG_DMESG, ("clear_all\n"));
+		RT_TRACE(COMP_SEC, DBG_DMESG, "clear_all\n");
 
 		for (idx = 0; idx < clear_number; idx++) {
 			stg_rtl_cam_mark_invalid(hw, cam_offset + idx);
@@ -2401,7 +2391,7 @@ void rtl92ee_set_key(struct ieee80211_hw *hw, u32 key_index,
 			break;
 		default:
 			RT_TRACE(COMP_ERR, DBG_LOUD,
-				 ("switch case not process \n"));
+				 "switch case not processed\n");
 			enc_algo = CAM_TKIP;
 			break;
 		}
@@ -2420,7 +2410,7 @@ void rtl92ee_set_key(struct ieee80211_hw *hw, u32 key_index,
 								     p_macaddr);
 					if (entry_id >=  TOTAL_CAM_ENTRY) {
 						RT_TRACE(COMP_SEC, DBG_EMERG,
-							 ("Can not find free hw security cam entry\n"));
+							 "Can not find free hw security cam entry\n");
 						return;
 					}
 				} else {
@@ -2434,17 +2424,17 @@ void rtl92ee_set_key(struct ieee80211_hw *hw, u32 key_index,
 
 		if (rtlpriv->sec.key_len[key_index] == 0) {
 			RT_TRACE(COMP_SEC, DBG_DMESG,
-				 ("delete one entry, entry_id is %d\n",
-				 entry_id));
+				 "delete one entry, entry_id is %d\n",
+				 entry_id);
 			if (mac->opmode == NL80211_IFTYPE_AP ||
 			    mac->opmode == NL80211_IFTYPE_MESH_POINT)
 				stg_rtl_cam_del_entry(hw, p_macaddr);
 			stg_rtl_cam_delete_one_entry(hw, p_macaddr, entry_id);
 		} else {
-			RT_TRACE(COMP_SEC, DBG_DMESG, ("add one entry\n"));
+			RT_TRACE(COMP_SEC, DBG_DMESG, "add one entry\n");
 			if (is_pairwise) {
 				RT_TRACE(COMP_SEC, DBG_DMESG,
-					 ("set Pairwiase key\n"));
+					 "set Pairwise key\n");
 
 				stg_rtl_cam_add_one_entry(hw, macaddr, key_index,
 					       entry_id, enc_algo,
@@ -2452,7 +2442,7 @@ void rtl92ee_set_key(struct ieee80211_hw *hw, u32 key_index,
 					       rtlpriv->sec.key_buf[key_index]);
 			} else {
 				RT_TRACE(COMP_SEC, DBG_DMESG,
-					 ("set group key\n"));
+					 "set group key\n");
 
 				if (mac->opmode == NL80211_IFTYPE_ADHOC) {
 					stg_rtl_cam_add_one_entry(hw,
@@ -2539,6 +2529,6 @@ void rtl92ee_allow_all_destaddr(struct ieee80211_hw *hw,
 		rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
 
 	RT_TRACE(COMP_TURBO | COMP_INIT, DBG_LOUD,
-		 ("receive_config = 0x%08X, write_into_reg =%d\n",
-		  rtlpci->receive_config, write_into_reg));
+		 "receive_config = 0x%08X, write_into_reg =%d\n",
+		 rtlpci->receive_config, write_into_reg);
 }
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/led.c b/drivers/staging/rtl8192ee/rtl8192ee/led.c
index 3b459c9..aa471bb 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/led.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/led.c
@@ -41,8 +41,8 @@ void rtl92ee_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 	u32 ledcfg;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	RT_TRACE(COMP_LED, DBG_LOUD,
-		 ("LedAddr:%X ledpin =%d\n", REG_LEDCFG2, pled->ledpin));
+	RT_TRACE(COMP_LED, DBG_LOUD, "LedAddr:%X ledpin =%d\n",
+		 REG_LEDCFG2, pled->ledpin);
 
 	switch (pled->ledpin) {
 	case LED_PIN_GPIO0:
@@ -55,8 +55,7 @@ void rtl92ee_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 	case LED_PIN_LED1:
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("switch case not process\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "switch case not processed\n");
 		break;
 	}
 	pled->b_ledon = true;
@@ -67,8 +66,8 @@ void rtl92ee_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 ledcfg;
 
-	RT_TRACE(COMP_LED, DBG_LOUD,
-		 ("LedAddr:%X ledpin =%d\n", REG_LEDCFG2, pled->ledpin));
+	RT_TRACE(COMP_LED, DBG_LOUD, "LedAddr:%X ledpin =%d\n",
+		 REG_LEDCFG2, pled->ledpin);
 
 	switch (pled->ledpin) {
 	case LED_PIN_GPIO0:
@@ -81,8 +80,7 @@ void rtl92ee_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 	case LED_PIN_LED1:
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_LOUD,
-			 ("switch case not process\n"));
+		RT_TRACE(COMP_ERR, DBG_LOUD, "switch case not processed\n");
 		break;
 	}
 	pled->b_ledon = false;
@@ -129,6 +127,6 @@ void rtl92ee_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction)
 	     ledaction == LED_CTL_POWER_ON)) {
 		return;
 	}
-	RT_TRACE(COMP_LED, DBG_TRACE, ("ledaction %d,\n", ledaction));
+	RT_TRACE(COMP_LED, DBG_TRACE, "ledaction %d\n", ledaction);
 	_rtl92ee_sw_led_control(hw, ledaction);
 }
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/phy.c b/drivers/staging/rtl8192ee/rtl8192ee/phy.c
index beef284..1c5c0e8 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/phy.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/phy.c
@@ -65,15 +65,14 @@ u32 rtl92ee_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 returnvalue, originalvalue, bitshift;
 
-	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("regaddr(%#x), bitmask(%#x)\n", regaddr, bitmask));
+	RT_TRACE(COMP_RF, DBG_TRACE, "regaddr(%#x), bitmask(%#x)\n",
+		 regaddr, bitmask);
 	originalvalue = rtl_read_dword(rtlpriv, regaddr);
 	bitshift = _rtl92ee_phy_calculate_bit_shift(bitmask);
 	returnvalue = (originalvalue & bitmask) >> bitshift;
 
-	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("BBR MASK = 0x%x Addr[0x%x]= 0x%x\n",
-		  bitmask, regaddr, originalvalue));
+	RT_TRACE(COMP_RF, DBG_TRACE, "BBR MASK = 0x%x Addr[0x%x]= 0x%x\n",
+		 bitmask, regaddr, originalvalue);
 
 	return returnvalue;
 }
@@ -84,9 +83,8 @@ void rtl92ee_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 originalvalue, bitshift;
 
-	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("regaddr(%#x), bitmask(%#x), data(%#x)\n",
-		  regaddr, bitmask, data));
+	RT_TRACE(COMP_RF, DBG_TRACE, "regaddr(%#x), bitmask(%#x), data(%#x)\n",
+		 regaddr, bitmask, data);
 
 	if (bitmask != MASKDWORD) {
 		originalvalue = rtl_read_dword(rtlpriv, regaddr);
@@ -96,9 +94,8 @@ void rtl92ee_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr,
 
 	rtl_write_dword(rtlpriv, regaddr, data);
 
-	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("regaddr(%#x), bitmask(%#x), data(%#x)\n",
-		  regaddr, bitmask, data));
+	RT_TRACE(COMP_RF, DBG_TRACE, "regaddr(%#x), bitmask(%#x), data(%#x)\n",
+		 regaddr, bitmask, data);
 }
 
 u32 rtl92ee_phy_query_rf_reg(struct ieee80211_hw *hw,
@@ -109,8 +106,8 @@ u32 rtl92ee_phy_query_rf_reg(struct ieee80211_hw *hw,
 	unsigned long flags;
 
 	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("regaddr(%#x), rfpath(%#x), bitmask(%#x)\n",
-		  regaddr, rfpath, bitmask));
+		 "regaddr(%#x), rfpath(%#x), bitmask(%#x)\n",
+		 regaddr, rfpath, bitmask);
 
 	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
 
@@ -122,8 +119,8 @@ u32 rtl92ee_phy_query_rf_reg(struct ieee80211_hw *hw,
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
 
 	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("regaddr(%#x), rfpath(%#x), bitmask(%#x), original_value(%#x)\n",
-		  regaddr, rfpath, bitmask, original_value));
+		 "regaddr(%#x), rfpath(%#x), bitmask(%#x), original_value(%#x)\n",
+		 regaddr, rfpath, bitmask, original_value);
 
 	return readback_value;
 }
@@ -137,8 +134,8 @@ void rtl92ee_phy_set_rf_reg(struct ieee80211_hw *hw,
 	unsigned long flags;
 
 	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("regaddr(%#x), bitmask(%#x), data(%#x), rfpath(%#x)\n",
-		  addr, bitmask, data, rfpath));
+		 "regaddr(%#x), bitmask(%#x), data(%#x), rfpath(%#x)\n",
+		 addr, bitmask, data, rfpath);
 
 	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
 
@@ -153,8 +150,8 @@ void rtl92ee_phy_set_rf_reg(struct ieee80211_hw *hw,
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
 
 	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("regaddr(%#x), bitmask(%#x), data(%#x), rfpath(%#x)\n",
-		  addr, bitmask, data, rfpath));
+		 "regaddr(%#x), bitmask(%#x), data(%#x), rfpath(%#x)\n",
+		 addr, bitmask, data, rfpath);
 }
 
 static u32 _rtl92ee_phy_rf_serial_read(struct ieee80211_hw *hw,
@@ -171,7 +168,7 @@ static u32 _rtl92ee_phy_rf_serial_read(struct ieee80211_hw *hw,
 	offset &= 0xff;
 	newoffset = offset;
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("return all one\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "return all one\n");
 		return 0xFFFFFFFF;
 	}
 	tmplong = rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD);
@@ -199,9 +196,8 @@ static u32 _rtl92ee_phy_rf_serial_read(struct ieee80211_hw *hw,
 	else
 		retvalue = rtl_get_bbreg(hw, pphyreg->rflssi_readback,
 					 BLSSIREADBACKDATA);
-	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("RFR-%d Addr[0x%x]= 0x%x\n",
-		  rfpath, pphyreg->rflssi_readback, retvalue));
+	RT_TRACE(COMP_RF, DBG_TRACE, "RFR-%d Addr[0x%x]= 0x%x\n",
+		 rfpath, pphyreg->rflssi_readback, retvalue);
 	return retvalue;
 }
 
@@ -216,16 +212,15 @@ static void _rtl92ee_phy_rf_serial_write(struct ieee80211_hw *hw,
 	struct bb_reg_def *pphyreg = &rtlphy->phyreg_def[rfpath];
 
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("stop\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "stop\n");
 		return;
 	}
 	offset &= 0xff;
 	newoffset = offset;
 	data_and_addr = ((newoffset << 20) | (data & 0x000fffff)) & 0x0fffffff;
 	rtl_set_bbreg(hw, pphyreg->rf3wire_offset, MASKDWORD, data_and_addr);
-	RT_TRACE(COMP_RF, DBG_TRACE,
-		 ("RFW-%d Addr[0x%x]= 0x%x\n", rfpath,
-		  pphyreg->rf3wire_offset, data_and_addr));
+	RT_TRACE(COMP_RF, DBG_TRACE, "RFW-%d Addr[0x%x]= 0x%x\n",
+		 rfpath, pphyreg->rf3wire_offset, data_and_addr);
 }
 
 static u32 _rtl92ee_phy_calculate_bit_shift(u32 bitmask)
@@ -423,7 +418,7 @@ static void _rtl92ee_phy_set_txpower_by_rate_base(struct ieee80211_hw *hw,
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 
 	if (path > RF90_PATH_D) {
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("Invalid Rf Path %d\n", path));
+		RT_TRACE(COMP_INIT, DBG_LOUD, "Invalid Rf Path %d\n", path);
 		return;
 	}
 	if (band == BAND_ON_2_4G) {
@@ -442,12 +437,12 @@ static void _rtl92ee_phy_set_txpower_by_rate_base(struct ieee80211_hw *hw,
 			break;
 		default:
 			RT_TRACE(COMP_INIT, DBG_LOUD,
-				 ("Invalid RateSection %d in 2.4G, Rf %d,%dTx\n",
-				  rate_section, path, txnum));
+				 "Invalid RateSection %d in 2.4G, Rf %d,%dTx\n",
+				 rate_section, path, txnum);
 			break;
 		};
 	} else {
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("Invalid Band %d\n", band));
+		RT_TRACE(COMP_INIT, DBG_LOUD, "Invalid Band %d\n", band);
 	}
 }
 
@@ -458,7 +453,7 @@ static u8 _rtl92ee_phy_get_txpower_by_rate_base(struct ieee80211_hw *hw, u8 band
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	u8 value = 0;
 	if (path > RF90_PATH_D) {
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("Invalid Rf Path %d\n", path));
+		RT_TRACE(COMP_INIT, DBG_LOUD, "Invalid Rf Path %d\n", path);
 		return 0;
 	}
 	if (band == BAND_ON_2_4G) {
@@ -477,12 +472,12 @@ static u8 _rtl92ee_phy_get_txpower_by_rate_base(struct ieee80211_hw *hw, u8 band
 			break;
 		default:
 			RT_TRACE(COMP_INIT, DBG_LOUD,
-				 ("Invalid RateSection %d in 2.4G, Rf %d,%dTx\n",
-				  rate_section, path, txnum));
+				 "Invalid RateSection %d in 2.4G, Rf %d,%dTx\n",
+				 rate_section, path, txnum);
 			break;
 		};
 	} else {
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("Invalid Band %d()\n", band));
+		RT_TRACE(COMP_INIT, DBG_LOUD, "Invalid Band %d()\n", band);
 	}
 	return value;
 }
@@ -608,7 +603,7 @@ static void _rtl92ee_phy_convert_txpower_dbm_to_relative_value(struct ieee80211_
 			0, 3, base);
 	}
 	RT_TRACE(COMP_POWER, DBG_TRACE,
-		 ("<== _rtl92ee_phy_convert_txpower_dbm_to_relative_value()\n"));
+		 "<== _rtl92ee_phy_convert_txpower_dbm_to_relative_value()\n");
 }
 
 static void _rtl92ee_phy_txpower_by_rate_configuration(struct ieee80211_hw *hw)
@@ -627,7 +622,7 @@ static bool _rtl92ee_phy_bb8192ee_config_parafile(struct ieee80211_hw *hw)
 	rtstatus = _rtl92ee_phy_config_bb_with_headerfile(hw,
 						       BASEBAND_CONFIG_PHY_REG);
 	if (!rtstatus) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("Write BB Reg Fail!!"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Write BB Reg Fail!!\n");
 		return false;
 	}
 
@@ -639,13 +634,13 @@ static bool _rtl92ee_phy_bb8192ee_config_parafile(struct ieee80211_hw *hw)
 	}
 	_rtl92ee_phy_txpower_by_rate_configuration(hw);
 	if (!rtstatus) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("BB_PG Reg Fail!!"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "BB_PG Reg Fail!!\n");
 		return false;
 	}
 	rtstatus = _rtl92ee_phy_config_bb_with_headerfile(hw,
 						       BASEBAND_CONFIG_AGC_TAB);
 	if (!rtstatus) {
-		RT_TRACE(COMP_ERR, DBG_EMERG, ("AGC Table Fail\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "AGC Table Fail\n");
 		return false;
 	}
 	rtlphy->bcck_high_power = (bool) (rtl_get_bbreg(hw,
@@ -662,11 +657,11 @@ static bool _rtl92ee_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 	u32 arraylength;
 	u32 *ptrarray;
 
-	RT_TRACE(COMP_INIT, DBG_TRACE, ("Read Rtl8192EMACPHY_Array\n"));
+	RT_TRACE(COMP_INIT, DBG_TRACE, "Read Rtl8192EMACPHY_Array\n");
 	arraylength = RTL8192EE_MAC_ARRAY_LEN;
 	ptrarray = RTL8192EE_MAC_ARRAY;
-	RT_TRACE(COMP_INIT, DBG_LOUD,
-		 ("Img:RTL8192EE_MAC_ARRAY LEN %d\n" , arraylength));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "Img:RTL8192EE_MAC_ARRAY LEN %d\n",
+		 arraylength);
 	for (i = 0; i < arraylength; i = i + 2)
 		rtl_write_byte(rtlpriv, ptrarray[i], (u8) ptrarray[i + 1]);
 	return true;
@@ -773,9 +768,9 @@ static bool _rtl92ee_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 					}
 				}
 				RT_TRACE(COMP_INIT, DBG_TRACE,
-					 ("The agctab_array_table[0] is %x Rtl818EEPHY_REGArray[1] is %x\n",
+					 "The agctab_array_table[0] is %x Rtl818EEPHY_REGArray[1] is %x\n",
 					  array[i],
-					  array[i + 1]));
+					  array[i + 1]);
 		}
 	}
 	return true;
@@ -853,16 +848,16 @@ static void _rtl92ee_store_tx_power_by_rate(struct ieee80211_hw *hw,
 	u8 section = _rtl92ee_get_rate_section_index(regaddr);
 
 	if (band != BAND_ON_2_4G && band != BAND_ON_5G) {
-		RT_TRACE(FPHY, PHY_TXPWR, ("Invalid Band %d\n", band));
+		RT_TRACE(FPHY, PHY_TXPWR, "Invalid Band %d\n", band);
 		return;
 	}
 
 	if (rfpath > MAX_RF_PATH - 1) {
-		RT_TRACE(FPHY, PHY_TXPWR, ("Invalid RfPath %d\n", rfpath));
+		RT_TRACE(FPHY, PHY_TXPWR, "Invalid RfPath %d\n", rfpath);
 		return;
 	}
 	if (txnum > MAX_RF_PATH - 1) {
-		RT_TRACE(FPHY, PHY_TXPWR, ("Invalid TxNum %d\n", txnum));
+		RT_TRACE(FPHY, PHY_TXPWR, "Invalid TxNum %d\n", txnum);
 		return;
 	}
 
@@ -898,7 +893,7 @@ static bool _rtl92ee_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 		}
 	} else {
 		RT_TRACE(COMP_SEND, DBG_TRACE,
-			 ("configtype != BaseBand_Config_PHY_REG\n"));
+			 "configtype != BaseBand_Config_PHY_REG\n");
 	}
 	return true;
 }
@@ -924,8 +919,8 @@ bool rtl92ee_phy_config_rf_with_headerfile(struct ieee80211_hw  *hw,
 		len = RTL8192EE_RADIOA_ARRAY_LEN;
 		array = RTL8192EE_RADIOA_ARRAY;
 		RT_TRACE(COMP_INIT, DBG_LOUD,
-			 ("Radio_A:RTL8192EE_RADIOA_ARRAY %d\n" , len));
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("Radio No %x\n", rfpath));
+			 "Radio_A:RTL8192EE_RADIOA_ARRAY %d\n", len);
+		RT_TRACE(COMP_INIT, DBG_LOUD, "Radio No %x\n", rfpath);
 		for (i = 0; i < len; i = i + 2) {
 			v1 = array[i];
 			v2 = array[i+1];
@@ -968,8 +963,8 @@ bool rtl92ee_phy_config_rf_with_headerfile(struct ieee80211_hw  *hw,
 		len = RTL8192EE_RADIOB_ARRAY_LEN;
 		array = RTL8192EE_RADIOB_ARRAY;
 		RT_TRACE(COMP_INIT, DBG_LOUD,
-			 ("Radio_A:RTL8192EE_RADIOB_ARRAY %d\n" , len));
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("Radio No %x\n", rfpath));
+			 "Radio_A:RTL8192EE_RADIOB_ARRAY %d\n", len);
+		RT_TRACE(COMP_INIT, DBG_LOUD, "Radio No %x\n", rfpath);
 		for (i = 0; i < len; i = i + 2) {
 			v1 = array[i];
 			v2 = array[i+1];
@@ -1008,12 +1003,10 @@ bool rtl92ee_phy_config_rf_with_headerfile(struct ieee80211_hw  *hw,
 		}
 		break;
 	case RF90_PATH_C:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("switch case not process\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "switch case not processed\n");
 		break;
 	case RF90_PATH_D:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("switch case not process\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "switch case not processed\n");
 		break;
 	}
 	return true;
@@ -1034,20 +1027,19 @@ void rtl92ee_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw)
 		(u8) rtl_get_bbreg(hw, ROFDM0_XDAGCCORE1, MASKBYTE0);
 
 	RT_TRACE(COMP_INIT, DBG_TRACE,
-		 ("Default initial gain (c50 = 0x%x, c58 = 0x%x, c60 = 0x%x, c68 = 0x%x\n",
-		  rtlphy->default_initialgain[0],
-		  rtlphy->default_initialgain[1],
-		  rtlphy->default_initialgain[2],
-		  rtlphy->default_initialgain[3]));
+		 "Default initial gain (c50 = 0x%x, c58 = 0x%x, c60 = 0x%x, c68 = 0x%x\n",
+		 rtlphy->default_initialgain[0],
+		 rtlphy->default_initialgain[1],
+		 rtlphy->default_initialgain[2],
+		 rtlphy->default_initialgain[3]);
 
 	rtlphy->framesync = (u8) rtl_get_bbreg(hw,
 					       ROFDM0_RXDETECTOR3, MASKBYTE0);
 	rtlphy->framesync_c34 = rtl_get_bbreg(hw,
 					      ROFDM0_RXDETECTOR2, MASKDWORD);
 
-	RT_TRACE(COMP_INIT, DBG_TRACE,
-		 ("Default framesync (0x%x) = 0x%x\n",
-		  ROFDM0_RXDETECTOR3, rtlphy->framesync));
+	RT_TRACE(COMP_INIT, DBG_TRACE, "Default framesync (0x%x) = 0x%x\n",
+		 ROFDM0_RXDETECTOR3, rtlphy->framesync);
 }
 
 static void _rtl92ee_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw)
@@ -1313,8 +1305,7 @@ static u8 _rtl92ee_get_txpower_index(struct ieee80211_hw *hw,
 
 	if (channel < 1 || channel > 14) {
 		index = 0;
-		RT_TRACE(COMP_POWER_TRACKING, DBG_DMESG,
-			 ("Illegal channel!!\n"));
+		RT_TRACE(COMP_POWER_TRACKING, DBG_DMESG, "Illegal channel!!\n");
 	}
 
 	if (IS_CCK_RATE(rate))
@@ -1472,7 +1463,7 @@ static void _rtl92ee_set_txpower_index(struct ieee80211_hw *hw, u8 pwr_idx,
 				      MASKBYTE3, pwr_idx);
 			break;
 		default:
-			RT_TRACE(COMP_POWER, DBG_LOUD, ("Invalid Rate!!\n"));
+			RT_TRACE(COMP_POWER, DBG_LOUD, "Invalid Rate!!\n");
 			break;
 		}
 	} else if (rfpath == RF90_PATH_B) {
@@ -1590,11 +1581,11 @@ static void _rtl92ee_set_txpower_index(struct ieee80211_hw *hw, u8 pwr_idx,
 				      MASKBYTE3, pwr_idx);
 			break;
 		default:
-			RT_TRACE(COMP_POWER, DBG_LOUD, ("Invalid Rate!!\n"));
+			RT_TRACE(COMP_POWER, DBG_LOUD, "Invalid Rate!!\n");
 			break;
 		}
 	} else {
-		RT_TRACE(COMP_POWER, DBG_LOUD, ("Invalid RFPath!!\n"));
+		RT_TRACE(COMP_POWER, DBG_LOUD, "Invalid RFPath!!\n");
 	}
 }
 
@@ -1652,8 +1643,7 @@ static void rtl92ee_phy_set_txpower_index_by_rate_section(struct ieee80211_hw *h
 							rtlphy->current_chan_bw,
 							channel, ht_rates2t, 8);
 	} else
-		RT_TRACE(FPHY, PHY_TXPWR,
-			 ("Invalid RateSection %d\n", section));
+		RT_TRACE(FPHY, PHY_TXPWR, "Invalid RateSection %d\n", section);
 }
 
 void rtl92ee_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel)
@@ -1724,7 +1714,7 @@ void rtl92ee_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation)
 			break;
 		default:
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("Unknown Scan Backup operation.\n"));
+				 "Unknown Scan Backup operation\n");
 			break;
 		}
 	}
@@ -1739,10 +1729,8 @@ void rtl92ee_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 	u8 reg_bw_opmode;
 	u8 reg_prsr_rsc;
 
-	RT_TRACE(COMP_SCAN, DBG_TRACE,
-		 ("Switch to %s bandwidth\n",
-		  rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20 ?
-		  "20MHz" : "40MHz"));
+	RT_TRACE(COMP_SCAN, DBG_TRACE, "Switch to %sMHz bandwidth\n",
+		 rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20 ? "20" : "40");
 
 	if (is_hal_stop(rtlhal)) {
 		rtlphy->set_bwmode_inprogress = false;
@@ -1765,8 +1753,8 @@ void rtl92ee_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "unknown bandwidth: %#X\n",
+			 rtlphy->current_chan_bw);
 		break;
 	}
 
@@ -1790,13 +1778,13 @@ void rtl92ee_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 			       HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "unknown bandwidth: %#X\n",
+			 rtlphy->current_chan_bw);
 		break;
 	}
 	rtl92ee_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
 	rtlphy->set_bwmode_inprogress = false;
-	RT_TRACE(COMP_SCAN, DBG_LOUD, ("\n"));
+	RT_TRACE(COMP_SCAN, DBG_LOUD, "\n");
 }
 
 void rtl92ee_phy_set_bw_mode(struct ieee80211_hw *hw,
@@ -1814,7 +1802,7 @@ void rtl92ee_phy_set_bw_mode(struct ieee80211_hw *hw,
 		rtl92ee_phy_set_bw_mode_callback(hw);
 	} else {
 		RT_TRACE(COMP_ERR, DBG_WARNING,
-			 ("false driver sleep or unload\n"));
+			 "false driver sleep or unload\n");
 		rtlphy->set_bwmode_inprogress = false;
 		rtlphy->current_chan_bw = tmp_bw;
 	}
@@ -1827,8 +1815,8 @@ void rtl92ee_phy_sw_chnl_callback(struct ieee80211_hw *hw)
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	u32 delay;
 
-	RT_TRACE(COMP_SCAN, DBG_TRACE,
-		 ("switch to channel%d\n", rtlphy->current_channel));
+	RT_TRACE(COMP_SCAN, DBG_TRACE, "switch to channel%d\n",
+		 rtlphy->current_channel);
 	if (is_hal_stop(rtlhal))
 		return;
 	do {
@@ -1846,7 +1834,7 @@ void rtl92ee_phy_sw_chnl_callback(struct ieee80211_hw *hw)
 		}
 		break;
 	} while (true);
-	RT_TRACE(COMP_SCAN, DBG_TRACE, ("\n"));
+	RT_TRACE(COMP_SCAN, DBG_TRACE, "\n");
 }
 
 u8 rtl92ee_phy_sw_chnl(struct ieee80211_hw *hw)
@@ -1867,12 +1855,12 @@ u8 rtl92ee_phy_sw_chnl(struct ieee80211_hw *hw)
 	if (!(is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
 		rtl92ee_phy_sw_chnl_callback(hw);
 		RT_TRACE(COMP_CHAN, DBG_LOUD,
-			 ("sw_chnl_inprogress false schdule workitem current channel %d\n",
-			 rtlphy->current_channel));
+			 "sw_chnl_inprogress false schedule workitem current channel %d\n",
+			 rtlphy->current_channel);
 		rtlphy->sw_chnl_inprogress = false;
 	} else {
 		RT_TRACE(COMP_CHAN, DBG_LOUD,
-			 ("sw_chnl_inprogress false driver sleep or unload\n"));
+			 "sw_chnl_inprogress false driver sleep or unload\n");
 		rtlphy->sw_chnl_inprogress = false;
 	}
 	return 1;
@@ -1933,8 +1921,7 @@ static bool _rtl92ee_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 			break;
 		default:
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("Invalid 'stage' = %d, Check it!\n" ,
-				  *stage));
+				 "Invalid 'stage' = %d, Check it!\n", *stage);
 			return true;
 			break;
 		}
@@ -1979,7 +1966,7 @@ static bool _rtl92ee_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 			break;
 		default:
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("switch case not process\n"));
+				 "switch case not processed\n");
 			break;
 		}
 
@@ -2325,7 +2312,7 @@ static u8 _rtl92ee_phy_path_b_rx_iqk(struct ieee80211_hw *hw, bool config_pathb)
 	    (((reg_ecc & 0x03FF0000) >> 16) != 0x36))
 		result |= 0x02;
 	else
-		RT_TRACE(COMP_RF, DBG_LOUD, ("Path B Rx IQK fail!!\n"));
+		RT_TRACE(COMP_RF, DBG_LOUD, "Path B Rx IQK fail!!\n");
 
 	return result;
 }
@@ -2637,7 +2624,7 @@ static void _rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw,
 
 		if (patha_ok == 0x01) {
 			RT_TRACE(COMP_RF, DBG_LOUD,
-				 ("Path A Tx IQK Success!!\n"));
+				 "Path A Tx IQK Success!!\n");
 			result[t][0] = (rtl_get_bbreg(hw,
 						      RTx_Power_Before_IQK_A,
 						      MASKDWORD) & 0x3FF0000)
@@ -2648,8 +2635,8 @@ static void _rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw,
 			break;
 		} else {
 			RT_TRACE(COMP_RF, DBG_LOUD,
-				 ("Path A Tx IQK Fail!!, ret = 0x%x\n",
-				  patha_ok));
+				 "Path A Tx IQK Fail!!, ret = 0x%x\n",
+				 patha_ok);
 		}
 	}
 
@@ -2658,7 +2645,7 @@ static void _rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw,
 
 		if (patha_ok == 0x03) {
 			RT_TRACE(COMP_RF, DBG_LOUD,
-				 ("Path A Rx IQK Success!!\n"));
+				 "Path A Rx IQK Success!!\n");
 			result[t][2] = (rtl_get_bbreg(hw,
 						      RRx_Power_Before_IQK_A_2,
 						      MASKDWORD) & 0x3FF0000)
@@ -2670,13 +2657,13 @@ static void _rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw,
 			break;
 		} else {
 			RT_TRACE(COMP_RF, DBG_LOUD,
-				 ("Path A Rx IQK Fail!!, ret = 0x%x\n",
-				  patha_ok));
+				 "Path A Rx IQK Fail!!, ret = 0x%x\n",
+				 patha_ok);
 		}
 	}
 
 	if (0x00 == patha_ok)
-		RT_TRACE(COMP_RF, DBG_LOUD, ("Path A IQK failed!!, ret = 0\n"));
+		RT_TRACE(COMP_RF, DBG_LOUD, "Path A IQK failed!!, ret = 0\n");
 
 	if (is2t) {
 		_rtl92ee_phy_path_a_standby(hw);
@@ -2692,7 +2679,7 @@ static void _rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw,
 			pathb_ok = _rtl92ee_phy_path_b_iqk(hw);
 			if (pathb_ok == 0x01) {
 				RT_TRACE(COMP_RF, DBG_LOUD,
-					 ("Path B Tx IQK Success!!\n"));
+					 "Path B Tx IQK Success!!\n");
 				result[t][4] = (rtl_get_bbreg(hw,
 							RTx_Power_Before_IQK_B,
 							MASKDWORD) & 0x3FF0000)
@@ -2704,8 +2691,8 @@ static void _rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw,
 				break;
 			} else {
 				RT_TRACE(COMP_RF, DBG_LOUD,
-					 ("Path B Tx IQK Fail!!, ret = 0x%x\n",
-					   pathb_ok));
+					 "Path B Tx IQK Fail!!, ret = 0x%x\n",
+					 pathb_ok);
 			}
 		}
 
@@ -2713,7 +2700,7 @@ static void _rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw,
 			pathb_ok = _rtl92ee_phy_path_b_rx_iqk(hw, is2t);
 			if (pathb_ok == 0x03) {
 				RT_TRACE(COMP_RF, DBG_LOUD,
-					 ("Path B Rx IQK Success!!\n"));
+					 "Path B Rx IQK Success!!\n");
 				result[t][6] = (rtl_get_bbreg(hw,
 						       RRx_Power_Before_IQK_B_2,
 						       MASKDWORD) & 0x3FF0000)
@@ -2725,18 +2712,18 @@ static void _rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw,
 				break;
 			} else {
 				RT_TRACE(COMP_RF, DBG_LOUD,
-					 ("Path B Rx IQK Fail!!, ret = 0x%x\n",
-					 pathb_ok));
+					 "Path B Rx IQK Fail!!, ret = 0x%x\n",
+					 pathb_ok);
 			}
 		}
 
 		if (0x00 == pathb_ok)
 			RT_TRACE(COMP_RF, DBG_LOUD,
-				 ("Path B IQK failed!!, ret = 0\n"));
+				 "Path B IQK failed!!, ret = 0\n");
 	}
 	/* Back to BB mode, load original value */
 	RT_TRACE(COMP_RF, DBG_LOUD,
-		 ("IQK:Back to BB mode, load original value!\n"));
+		 "IQK:Back to BB mode, load original value!\n");
 	rtl_set_bbreg(hw, RFPGA0_IQK, MASKDWORD, 0);
 
 	if (t != 0) {
@@ -2765,7 +2752,7 @@ static void _rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw,
 		rtl_set_bbreg(hw, RTx_IQK_Tone_A, MASKDWORD, 0x01008c00);
 		rtl_set_bbreg(hw, RRx_IQK_Tone_A, MASKDWORD, 0x01008c00);
 	}
-	RT_TRACE(COMP_RF, DBG_LOUD, ("_rtl92ee_phy_iq_calibrate() <==\n"));
+	RT_TRACE(COMP_RF, DBG_LOUD, "_rtl92ee_phy_iq_calibrate() <==\n");
 }
 
 static void _rtl92ee_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
@@ -2811,7 +2798,7 @@ static void _rtl92ee_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 	} else {
 		rtl_write_byte(rtlpriv, REG_TXPAUSE, 0x00);
 	}
-	RT_TRACE(COMP_INIT , DBG_LOUD , ("\n"));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "\n");
 }
 
 static void _rtl92ee_phy_set_rfpath_switch(struct ieee80211_hw *hw,
@@ -2820,7 +2807,7 @@ static void _rtl92ee_phy_set_rfpath_switch(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	RT_TRACE(COMP_INIT , DBG_LOUD , ("\n"));
+	RT_TRACE(COMP_INIT, DBG_LOUD, "\n");
 
 	if (is_hal_stop(rtlhal)) {
 		u8 u1btmp;
@@ -3059,24 +3046,23 @@ bool rtl92ee_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype)
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	bool b_postprocessing = false;
 
-	RT_TRACE(COMP_CMD, DBG_TRACE,
-		 ("-->IO Cmd(%#x), set_io_inprogress(%d)\n",
-		  iotype, rtlphy->set_io_inprogress));
+	RT_TRACE(COMP_CMD, DBG_TRACE, "-->IO Cmd(%#x), set_io_inprogress(%d)\n",
+		 iotype, rtlphy->set_io_inprogress);
 	do {
 		switch (iotype) {
 		case IO_CMD_RESUME_DM_BY_SCAN:
 			RT_TRACE(COMP_CMD, DBG_TRACE,
-				 ("[IO CMD] Resume DM after scan.\n"));
+				 "[IO CMD] Resume DM after scan\n");
 			b_postprocessing = true;
 			break;
 		case IO_CMD_PAUSE_BAND0_DM_BY_SCAN:
 			RT_TRACE(COMP_CMD, DBG_TRACE,
-				 ("[IO CMD] Pause DM before scan.\n"));
+				 "[IO CMD] Pause DM before scan\n");
 			b_postprocessing = true;
 			break;
 		default:
 			RT_TRACE(COMP_ERR, DBG_EMERG,
-				 ("switch case not process\n"));
+				 "switch case not processed\n");
 			break;
 		}
 	} while (false);
@@ -3087,7 +3073,7 @@ bool rtl92ee_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype)
 		return false;
 	}
 	rtl92ee_phy_set_io(hw);
-	RT_TRACE(COMP_CMD, DBG_TRACE, ("IO Type(%#x)\n", iotype));
+	RT_TRACE(COMP_CMD, DBG_TRACE, "IO Type(%#x)\n", iotype);
 	return true;
 }
 
@@ -3097,13 +3083,13 @@ static void rtl92ee_phy_set_io(struct ieee80211_hw *hw)
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 
 	RT_TRACE(COMP_CMD, DBG_TRACE,
-		 ("--->Cmd(%#x), set_io_inprogress(%d)\n",
-		  rtlphy->current_io_type, rtlphy->set_io_inprogress));
+		 "--->Cmd(%#x), set_io_inprogress(%d)\n",
+		 rtlphy->current_io_type, rtlphy->set_io_inprogress);
 	switch (rtlphy->current_io_type) {
 	case IO_CMD_RESUME_DM_BY_SCAN:
 		rtl92ee_dm_write_dig(hw , rtlphy->initgain_backup.xaagccore1);
 		rtl92ee_dm_write_cck_cca_thres(hw, rtlphy->initgain_backup.cca);
-		RT_TRACE(COMP_CMD, DBG_TRACE , ("no set txpower\n"));
+		RT_TRACE(COMP_CMD, DBG_TRACE, "no set txpower\n");
 		rtl92ee_phy_set_txpower_level(hw, rtlphy->current_channel);
 		break;
 	case IO_CMD_PAUSE_BAND0_DM_BY_SCAN:
@@ -3114,13 +3100,11 @@ static void rtl92ee_phy_set_io(struct ieee80211_hw *hw)
 		rtl92ee_dm_write_cck_cca_thres(hw, 0x40);
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("switch case not process\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "switch case not processed\n");
 		break;
 	}
 	rtlphy->set_io_inprogress = false;
-	RT_TRACE(COMP_CMD, DBG_TRACE,
-		 ("(%#x)\n", rtlphy->current_io_type));
+	RT_TRACE(COMP_CMD, DBG_TRACE, "(%#x)\n", rtlphy->current_io_type);
 }
 
 static void rtl92ee_phy_set_rf_on(struct ieee80211_hw *hw)
@@ -3166,15 +3150,15 @@ static bool _rtl92ee_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			do {
 				init_count++;
 				RT_TRACE(COMP_RF, DBG_DMESG,
-					 ("IPS Set eRf nic enable\n"));
+					 "IPS Set eRf nic enable\n");
 				rtstatus = stg_rtl_ps_enable_nic(hw);
 			} while (!rtstatus && (init_count < 10));
 			RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			RT_TRACE(COMP_RF, DBG_DMESG,
-				 ("Set ERFON sleeped:%d ms\n",
-				  jiffies_to_msecs(jiffies -
-						   ppsc->last_sleep_jiffies)));
+				 "Set ERFON sleeped:%d ms\n",
+				 jiffies_to_msecs(jiffies -
+						  ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
 			rtl92ee_phy_set_rf_on(hw);
 		}
@@ -3192,26 +3176,26 @@ static bool _rtl92ee_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				continue;
 			} else {
 				RT_TRACE(COMP_ERR, DBG_WARNING,
-					 ("eRf Off/Sleep: %d times TcbBusyQueue[%d] =%d before "
-					  "doze!\n", (i + 1), queue_id,
-					  skb_queue_len(&ring->queue)));
+					 "eRf Off/Sleep: %d times TcbBusyQueue[%d] =%d before doze!\n",
+					 i + 1, queue_id,
+					 skb_queue_len(&ring->queue));
 
 				udelay(10);
 				i++;
 			}
 			if (i >= MAX_DOZE_WAITING_TIMES_9x) {
 				RT_TRACE(COMP_ERR, DBG_WARNING,
-					 ("\n ERFSLEEP: %d times TcbBusyQueue[%d] = %d !\n",
-					  MAX_DOZE_WAITING_TIMES_9x,
-					  queue_id,
-					  skb_queue_len(&ring->queue)));
+					 "ERFSLEEP: %d times TcbBusyQueue[%d] = %d !\n",
+					 MAX_DOZE_WAITING_TIMES_9x,
+					 queue_id,
+					 skb_queue_len(&ring->queue));
 				break;
 			}
 		}
 
 		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_HALT_NIC) {
 			RT_TRACE(COMP_RF, DBG_DMESG,
-				 ("IPS Set eRf nic disable\n"));
+				 "IPS Set eRf nic disable\n");
 			stg_rtl_ps_disable_nic(hw);
 			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
@@ -3235,31 +3219,28 @@ static bool _rtl92ee_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				continue;
 			} else {
 				RT_TRACE(COMP_ERR, DBG_WARNING,
-					 ("eRf Off/Sleep: %d times TcbBusyQueue[%d] =%d before doze!\n",
-					  (i + 1), queue_id,
-					  skb_queue_len(&ring->queue)));
+					 "eRf Off/Sleep: %d times TcbBusyQueue[%d] =%d before doze!\n",
+					 i + 1, queue_id,
+					 skb_queue_len(&ring->queue));
 				udelay(10);
 				i++;
 			}
 			if (i >= MAX_DOZE_WAITING_TIMES_9x) {
 				RT_TRACE(COMP_ERR, DBG_WARNING,
-					 ("\n ERFSLEEP: %d times TcbBusyQueue[%d] = %d !\n",
-					  MAX_DOZE_WAITING_TIMES_9x,
-					  queue_id,
-					  skb_queue_len(&ring->queue)));
+					 "ERFSLEEP: %d times TcbBusyQueue[%d] = %d !\n",
+					 MAX_DOZE_WAITING_TIMES_9x,
+					 queue_id,
+					 skb_queue_len(&ring->queue));
 				break;
 			}
 		}
-		RT_TRACE(COMP_RF, DBG_DMESG,
-			 ("Set ERFSLEEP awaked:%d ms\n",
-			  jiffies_to_msecs(jiffies -
-					   ppsc->last_awake_jiffies)));
+		RT_TRACE(COMP_RF, DBG_DMESG, "Set ERFSLEEP awaked:%d ms\n",
+			 jiffies_to_msecs(jiffies - ppsc->last_awake_jiffies));
 		ppsc->last_sleep_jiffies = jiffies;
 		_rtl92ee_phy_set_rf_sleep(hw);
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("switch case not process\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "switch case not processed\n");
 		bresult = false;
 		break;
 	}
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.c b/drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.c
index efb00f6..d552346 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.c
@@ -51,15 +51,15 @@ bool rtl92e_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 	do {
 		pwr_cfg_cmd = pwrcfgcmd[ary_idx];
 		RT_TRACE(COMP_INIT, DBG_TRACE,
-			 ("offset(%#x), cut_msk(%#x), fab_msk(%#x), interface_msk(%#x), base(%#x), cmd(%#x), msk(%#x), value(%#x)\n",
-			  GET_PWR_CFG_OFFSET(pwr_cfg_cmd),
-			  GET_PWR_CFG_CUT_MASK(pwr_cfg_cmd),
-			  GET_PWR_CFG_FAB_MASK(pwr_cfg_cmd),
-			  GET_PWR_CFG_INTF_MASK(pwr_cfg_cmd),
-			  GET_PWR_CFG_BASE(pwr_cfg_cmd),
-			  GET_PWR_CFG_CMD(pwr_cfg_cmd),
-			  GET_PWR_CFG_MASK(pwr_cfg_cmd),
-			  GET_PWR_CFG_VALUE(pwr_cfg_cmd)));
+			 "offset(%#x), cut_msk(%#x), fab_msk(%#x), interface_msk(%#x), base(%#x), cmd(%#x), msk(%#x), value(%#x)\n",
+			 GET_PWR_CFG_OFFSET(pwr_cfg_cmd),
+			 GET_PWR_CFG_CUT_MASK(pwr_cfg_cmd),
+			 GET_PWR_CFG_FAB_MASK(pwr_cfg_cmd),
+			 GET_PWR_CFG_INTF_MASK(pwr_cfg_cmd),
+			 GET_PWR_CFG_BASE(pwr_cfg_cmd),
+			 GET_PWR_CFG_CMD(pwr_cfg_cmd),
+			 GET_PWR_CFG_MASK(pwr_cfg_cmd),
+			 GET_PWR_CFG_VALUE(pwr_cfg_cmd));
 
 		if ((GET_PWR_CFG_FAB_MASK(pwr_cfg_cmd)&fab_version) &&
 		    (GET_PWR_CFG_CUT_MASK(pwr_cfg_cmd)&cut_version) &&
@@ -67,12 +67,12 @@ bool rtl92e_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 			switch (GET_PWR_CFG_CMD(pwr_cfg_cmd)) {
 			case PWR_CMD_READ:
 				RT_TRACE(COMP_INIT, DBG_TRACE,
-					 ("PWR_CMD_READ\n"));
+					 "PWR_CMD_READ\n");
 				break;
 
 			case PWR_CMD_WRITE:
 				RT_TRACE(COMP_INIT, DBG_TRACE,
-					 ("PWR_CMD_WRITE\n"));
+					 "PWR_CMD_WRITE\n");
 				offset = GET_PWR_CFG_OFFSET(pwr_cfg_cmd);
 
 				/*Read the value from system register*/
@@ -87,7 +87,7 @@ bool rtl92e_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 
 			case PWR_CMD_POLLING:
 				RT_TRACE(COMP_INIT, DBG_TRACE,
-					 ("PWR_CMD_POLLING\n"));
+					 "PWR_CMD_POLLING\n");
 				b_polling_bit = false;
 				offset = GET_PWR_CFG_OFFSET(pwr_cfg_cmd);
 
@@ -104,7 +104,7 @@ bool rtl92e_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 
 					if (polling_count++ > max_polling_cnt) {
 						RT_TRACE(COMP_INIT, DBG_LOUD,
-							 ("polling fail\n"));
+							 "polling fail\n");
 						return false;
 					}
 				} while (!b_polling_bit);
@@ -113,7 +113,7 @@ bool rtl92e_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 
 			case PWR_CMD_DELAY:
 				RT_TRACE(COMP_INIT, DBG_TRACE,
-					 ("PWR_CMD_DELAY\n"));
+					 "PWR_CMD_DELAY\n");
 				if (GET_PWR_CFG_VALUE(pwr_cfg_cmd) ==
 				    PWRSEQ_DELAY_US)
 					udelay(GET_PWR_CFG_OFFSET(pwr_cfg_cmd));
@@ -122,8 +122,7 @@ bool rtl92e_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 				break;
 
 			case PWR_CMD_END:
-				RT_TRACE(COMP_INIT, DBG_TRACE,
-					 ("PWR_CMD_END\n"));
+				RT_TRACE(COMP_INIT, DBG_TRACE, "PWR_CMD_END\n");
 				return true;
 				break;
 
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/rf.c b/drivers/staging/rtl8192ee/rtl8192ee/rf.c
index 4f5a49e..5dcb911 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/rf.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/rf.c
@@ -55,8 +55,8 @@ void rtl92ee_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 			      rtlphy->rfreg_chnlval[0]);
 		break;
 	default:
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("unknown bandwidth: %#X\n", bandwidth));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "unknown bandwidth: %#X\n",
+			 bandwidth);
 		break;
 	}
 }
@@ -139,12 +139,12 @@ static bool _rtl92ee_phy_rf6052_config_parafile(struct ieee80211_hw *hw)
 			break;
 		}
 		if (!rtstatus) {
-			RT_TRACE(COMP_INIT, DBG_TRACE,
-				 ("Radio[%d] Fail!!", rfpath));
+			RT_TRACE(COMP_INIT, DBG_TRACE, "Radio[%d] Fail!!\n",
+				 rfpath);
 			return false;
 		}
 	}
 
-	RT_TRACE(COMP_INIT, DBG_TRACE, ("\n"));
+	RT_TRACE(COMP_INIT, DBG_TRACE, "\n");
 	return rtstatus;
 }
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/sw.c b/drivers/staging/rtl8192ee/rtl8192ee/sw.c
index f9c5729..74f402d 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/sw.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/sw.c
@@ -171,8 +171,7 @@ int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vmalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Can't alloc buffer for fw.\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Can't alloc buffer for fw\n");
 		return 1;
 	}
 
@@ -180,13 +179,11 @@ int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 	err = request_firmware(&firmware, fw_name, rtlpriv->io.dev);
 
 	if (err) {
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Failed to request firmware!\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Failed to request firmware!\n");
 		return 1;
 	}
 	if (firmware->size > 0x8000) {
-		RT_TRACE(COMP_ERR, DBG_EMERG,
-			 ("Firmware is too big!\n"));
+		RT_TRACE(COMP_ERR, DBG_EMERG, "Firmware is too big!\n");
 		release_firmware(firmware);
 		return 1;
 	}
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/trx.c b/drivers/staging/rtl8192ee/rtl8192ee/trx.c
index 1190c8b..71f1b9f 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/trx.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/trx.c
@@ -531,9 +531,9 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 	else
 		status->wake_match = 0;
 	if (status->wake_match)
-		RT_TRACE(COMP_RXDESC , DBG_LOUD,
-			 ("GGGGGGGGGGGGGet Wakeup Packet!! WakeMatch =%d\n",
-			 status->wake_match));
+		RT_TRACE(COMP_RXDESC, DBG_LOUD,
+			 "GGGGGGGGGGGGGet Wakeup Packet!! WakeMatch =%d\n",
+			 status->wake_match);
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
 
@@ -645,8 +645,8 @@ u16 rtl92ee_rx_desc_buff_remained_cnt(struct ieee80211_hw *hw , u8 queue_index)
 
 	if (write_point != rtlpci->rx_ring[queue_index].next_rx_rp) {
 		RT_TRACE(COMP_RXDESC, DBG_DMESG,
-			 ("!!!write point is 0x%x, reg 0x3B4 value is 0x%x\n",
-			  write_point, tmp_4byte));
+			 "!!!write point is 0x%x, reg 0x3B4 value is 0x%x\n",
+			 write_point, tmp_4byte);
 		tmp_4byte = rtl_read_dword(rtlpriv, REG_RXQ_TXBD_IDX);
 		read_point = (u16)((tmp_4byte>>16) & 0x7ff);
 		write_point = (u16)(tmp_4byte & 0x7ff);
@@ -868,8 +868,7 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 	mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
 				 PCI_DMA_TODEVICE);
 	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
-		RT_TRACE(COMP_SEND, DBG_TRACE,
-			 ("DMA mapping error"));
+		RT_TRACE(COMP_SEND, DBG_TRACE, "DMA mapping error\n");
 		return;
 	}
 	if (pbd_desc_tx != NULL)
@@ -887,8 +886,8 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 					   USB_HWDESC_HEADER_LEN + EM_HDR_LEN);
 			if (ptcb_desc->empkt_num) {
 				RT_TRACE(COMP_SEND, DBG_TRACE,
-					 ("Insert 8 byte.pTcb->EMPktNum:%d\n",
-					  ptcb_desc->empkt_num));
+					 "Insert 8 byte.pTcb->EMPktNum:%d\n",
+					 ptcb_desc->empkt_num);
 				_rtl92ee_insert_emcontent(ptcb_desc,
 							  (u8 *)(skb->data));
 			}
@@ -990,7 +989,7 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 		if (ieee80211_is_data_qos(fc)) {
 			if (mac->rdg_en) {
 				RT_TRACE(COMP_SEND, DBG_TRACE,
-					 ("Enable RDG function.\n"));
+					 "Enable RDG function\n");
 				SET_TX_DESC_RDG_ENABLE(pdesc, 1);
 				SET_TX_DESC_HTC(pdesc, 1);
 			}
@@ -1013,7 +1012,7 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 	    is_broadcast_ether_addr(ieee80211_get_DA(hdr))) {
 		SET_TX_DESC_BMC(pdesc, 1);
 	}
-	RT_TRACE(COMP_SEND, DBG_TRACE, ("\n"));
+	RT_TRACE(COMP_SEND, DBG_TRACE, "\n");
 }
 
 void rtl92ee_tx_fill_cmddesc(struct ieee80211_hw *hw,
@@ -1032,8 +1031,7 @@ void rtl92ee_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	u8 txdesc_len = 40;
 
 	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
-		RT_TRACE(COMP_SEND, DBG_TRACE,
-			 ("DMA mapping error"));
+		RT_TRACE(COMP_SEND, DBG_TRACE, "DMA mapping error\n");
 		return;
 	}
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, txdesc_len);
@@ -1278,7 +1276,7 @@ u32 rtl92ee_rx_command_packet(struct ieee80211_hw *hw,
 		result = 1;
 		break;
 	default:
-		RT_TRACE(COMP_RECV, DBG_TRACE, ("No this packet type!!\n"));
+		RT_TRACE(COMP_RECV, DBG_TRACE, "No this packet type!!\n");
 		break;
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

