Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaIFXmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 19:42:15 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:33329 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaIFXmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 19:42:13 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8821ae: Fix '"(foo*)" should be "(foo *)"' errors
Date: Sat,  6 Sep 2014 18:40:29 -0500
Message-Id: <1410046829-5821-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl '"(foo*)" should be "(foo *)"' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8821ae/base.h                   | 26 +++++++++++-----------
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c |  8 +++----
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h |  4 ++--
 drivers/staging/rtl8821ae/core.c                   |  6 ++---
 drivers/staging/rtl8821ae/debug.h                  |  2 +-
 drivers/staging/rtl8821ae/pci.c                    |  6 ++---
 drivers/staging/rtl8821ae/rtl8821ae/def.h          |  2 +-
 drivers/staging/rtl8821ae/rtl8821ae/dm.c           |  2 +-
 8 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8821ae/base.h b/drivers/staging/rtl8821ae/base.h
index 629d14f..cf166f3 100644
--- a/drivers/staging/rtl8821ae/base.h
+++ b/drivers/staging/rtl8821ae/base.h
@@ -78,33 +78,33 @@ enum ap_peer {
 	SET_BITS_TO_LE_2BYTE(_hdr, 8, 1, _val)
 
 #define SET_80211_PS_POLL_AID(_hdr, _val)		\
-	WRITEEF2BYTE(((u8*)(_hdr))+2, _val)
+	WRITEEF2BYTE(((u8 *)(_hdr))+2, _val)
 #define SET_80211_PS_POLL_BSSID(_hdr, _val)		\
-	CP_MACADDR(((u8*)(_hdr))+4, (u8*)(_val))
+	CP_MACADDR(((u8 *)(_hdr))+4, (u8 *)(_val))
 #define SET_80211_PS_POLL_TA(_hdr, _val)		\
-	CP_MACADDR(((u8*)(_hdr))+10, (u8*)(_val))
+	CP_MACADDR(((u8 *)(_hdr))+10, (u8 *)(_val))
 
 #define SET_80211_HDR_DURATION(_hdr, _val)	\
-	WRITEEF2BYTE((u8*)(_hdr)+FRAME_OFFSET_DURATION, _val)
+	WRITEEF2BYTE((u8 *)(_hdr)+FRAME_OFFSET_DURATION, _val)
 #define SET_80211_HDR_ADDRESS1(_hdr, _val)	\
-	CP_MACADDR((u8*)(_hdr)+FRAME_OFFSET_ADDRESS1, (u8*)(_val))
+	CP_MACADDR((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS1, (u8 *)(_val))
 #define SET_80211_HDR_ADDRESS2(_hdr, _val) 	\
-	CP_MACADDR((u8*)(_hdr)+FRAME_OFFSET_ADDRESS2, (u8*)(_val))
+	CP_MACADDR((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS2, (u8 *)(_val))
 #define SET_80211_HDR_ADDRESS3(_hdr, _val) 	\
-	CP_MACADDR((u8*)(_hdr)+FRAME_OFFSET_ADDRESS3, (u8*)(_val))
+	CP_MACADDR((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS3, (u8 *)(_val))
 #define SET_80211_HDR_FRAGMENT_SEQUENCE(_hdr, _val)  \
-	WRITEEF2BYTE((u8*)(_hdr)+FRAME_OFFSET_SEQUENCE, _val)
+	WRITEEF2BYTE((u8 *)(_hdr)+FRAME_OFFSET_SEQUENCE, _val)
 
 #define SET_BEACON_PROBE_RSP_TIME_STAMP_LOW(__phdr, __val) 	\
-	WRITEEF4BYTE(((u8*)(__phdr)) + 24, __val)
+	WRITEEF4BYTE(((u8 *)(__phdr)) + 24, __val)
 #define SET_BEACON_PROBE_RSP_TIME_STAMP_HIGH(__phdr, __val) \
-	WRITEEF4BYTE(((u8*)(__phdr)) + 28, __val)
+	WRITEEF4BYTE(((u8 *)(__phdr)) + 28, __val)
 #define SET_BEACON_PROBE_RSP_BEACON_INTERVAL(__phdr, __val) \
-	WRITEEF2BYTE(((u8*)(__phdr)) + 32, __val)
+	WRITEEF2BYTE(((u8 *)(__phdr)) + 32, __val)
 #define GET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr) 		\
-	READEF2BYTE(((u8*)(__phdr)) + 34)
+	READEF2BYTE(((u8 *)(__phdr)) + 34)
 #define SET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr, __val) \
-	WRITEEF2BYTE(((u8*)(__phdr)) + 34, __val)
+	WRITEEF2BYTE(((u8 *)(__phdr)) + 34, __val)
 #define MASK_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr, __val) \
 	SET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr, \
 	(GET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr) & (~(__val))))
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
index 01f5a74..5fbdf33 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
@@ -285,10 +285,10 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtlpriv);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-	bool *bool_tmp = (bool*)out_buf;
-	int *s32_tmp = (int*)out_buf;
-	u32 *u32_tmp = (u32*)out_buf;
-	u8 *u8_tmp = (u8*)out_buf;
+	bool *bool_tmp = (bool *)out_buf;
+	int *s32_tmp = (int *)out_buf;
+	u32 *u32_tmp = (u32 *)out_buf;
+	u8 *u8_tmp = (u8 *)out_buf;
 	bool tmp = false;
 
 
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
index fd233cc..2d4b4ef 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
@@ -109,7 +109,7 @@ extern u32 btc_dbg_type[];
 	do { 							\
 		if(unlikely(btc_dbg_type[dbgtype] & dbgflag)) {	\
 			int __i;				\
-			u8* __ptr = (u8*)_Ptr;			\
+			u8 *__ptr = (u8 *)_Ptr;			\
 			printk printstr;			\
 			for( __i = 0; __i < 6; __i++ )		\
 				printk("%02X%s", __ptr[__i], (__i==5)?"":"-");\
@@ -121,7 +121,7 @@ extern u32 btc_dbg_type[];
 	do {								\
 		if(unlikely(btc_dbg_type[dbgtype] & dbgflag) )	{ 	\
 			int __i;					\
-			u8 *__ptr = (u8*)_hexdata;			\
+			u8 *__ptr = (u8 *)_hexdata;			\
 			printk(_titlestring);				\
 			for( __i = 0; __i < (int)_hexdatalen; __i++ ) {	\
 				printk("%02X%s", __ptr[__i], (((__i + 1) % 4) \
diff --git a/drivers/staging/rtl8821ae/core.c b/drivers/staging/rtl8821ae/core.c
index 046be2c..73c780b 100644
--- a/drivers/staging/rtl8821ae/core.c
+++ b/drivers/staging/rtl8821ae/core.c
@@ -691,7 +691,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 				rtlpriv->cfg->ops->linked_set_reg(hw);
 
 			rcu_read_lock();
-			sta = ieee80211_find_sta(vif, (u8*)bss_conf->bssid);
+			sta = ieee80211_find_sta(vif, (u8 *)bss_conf->bssid);
 
 			if (vif->type == NL80211_IFTYPE_STATION && sta)
 				rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
@@ -760,7 +760,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 			 ("BSS_CHANGED_HT\n"));
 
 		rcu_read_lock();
-		sta = ieee80211_find_sta(vif, (u8*)bss_conf->bssid);
+		sta = ieee80211_find_sta(vif, (u8 *)bss_conf->bssid);
 		if (sta) {
 			if (sta->ht_cap.ampdu_density >
 			    mac->current_ampdu_density)
@@ -796,7 +796,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		rtlpriv->cfg->ops->set_network_type(hw, vif->type);
 
 		rcu_read_lock();
-		sta = ieee80211_find_sta(vif, (u8*)bss_conf->bssid);
+		sta = ieee80211_find_sta(vif, (u8 *)bss_conf->bssid);
 		if (!sta) {
 			rcu_read_unlock();
 			goto out;
diff --git a/drivers/staging/rtl8821ae/debug.h b/drivers/staging/rtl8821ae/debug.h
index 6c0a553..c793f8c 100644
--- a/drivers/staging/rtl8821ae/debug.h
+++ b/drivers/staging/rtl8821ae/debug.h
@@ -203,7 +203,7 @@ enum dbgp_flag_e {
 		if(unlikely(((_comp) & rtlpriv->dbg.global_debugcomponents ) &&\
 			(_level <= rtlpriv->dbg.global_debuglevel )))	{ \
 			int __i;					\
-			u8*	ptr = (u8*)_hexdata;			\
+			u8 *ptr = (u8 *)_hexdata;			\
 			printk(KERN_DEBUG "%s: ", KBUILD_MODNAME);	\
 			printk(KERN_DEBUG "In process \"%s\" (pid %i):", \
 					current->comm, 	\
diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
index b818788..2995230 100644
--- a/drivers/staging/rtl8821ae/pci.c
+++ b/drivers/staging/rtl8821ae/pci.c
@@ -897,10 +897,10 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 
 			/* static bcn for roaming */
 			rtl_beacon_statistic(hw, skb);
-			rtl_p2p_info(hw, (void*)skb->data, skb->len);
+			rtl_p2p_info(hw, (void *)skb->data, skb->len);
 			/* for sw lps */
-			rtl_swlps_beacon(hw, (void*)skb->data, skb->len);
-			rtl_recognize_peer(hw, (void*)skb->data, skb->len);
+			rtl_swlps_beacon(hw, (void *)skb->data, skb->len);
+			rtl_recognize_peer(hw, (void *)skb->data, skb->len);
 			if ((rtlpriv->mac80211.opmode == NL80211_IFTYPE_AP) &&
 			    (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G)&&
 			    (ieee80211_is_beacon(fc) ||
diff --git a/drivers/staging/rtl8821ae/rtl8821ae/def.h b/drivers/staging/rtl8821ae/rtl8821ae/def.h
index 72ebdea..26644ae 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/def.h
+++ b/drivers/staging/rtl8821ae/rtl8821ae/def.h
@@ -182,7 +182,7 @@
 #define	GET_C2H_CMD_CONTINUE(__prxhdr)		\
 	LE_BITS_TO_4BYTE((__prxhdr), 31, 1)
 #define	GET_C2H_CMD_CONTENT(__prxhdr)		\
-	((u8*)(__prxhdr) + C2H_RX_CMD_HDR_LEN)
+	((u8 *)(__prxhdr) + C2H_RX_CMD_HDR_LEN)
 
 #define	GET_C2H_CMD_FEEDBACK_ELEMENT_ID(__pcmdfbhdr)	\
 	LE_BITS_TO_4BYTE((__pcmdfbhdr), 0, 8)
diff --git a/drivers/staging/rtl8821ae/rtl8821ae/dm.c b/drivers/staging/rtl8821ae/rtl8821ae/dm.c
index e0efcd2..cddf1b6 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/dm.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/dm.c
@@ -2733,7 +2733,7 @@ void rtl8821ae_dm_dynamic_edcca(struct ieee80211_hw *hw)
 	bool b_fw_current_in_ps_mode = false;
 
 	rtlpriv->cfg->ops->get_hw_reg(hw,HW_VAR_FW_PSMODE_STATUS, \
-		(u8*)(&b_fw_current_in_ps_mode));
+		(u8 *)(&b_fw_current_in_ps_mode));
 	if (b_fw_current_in_ps_mode)
 		return;
 }
-- 
1.9.1

