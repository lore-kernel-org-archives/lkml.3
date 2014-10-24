Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaJXXWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 19:22:44 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64214 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbaJXXWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 19:22:42 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
        Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
Subject: [PATCH] Staging:rtl8723au:core brace issue
Date: Sat, 25 Oct 2014 00:22:32 +0100
Message-Id: <1414192952-11977-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: that open brace { should be on the previous line

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c | 137 ++++++++++----------------------
 1 file changed, 43 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index 6b4092f..fd36be4 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -231,12 +231,10 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 			psta->expire_to--;
 		}
 
-		if (psta->expire_to <= 0)
-		{
+		if (psta->expire_to <= 0) {
 			struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 
-			if (padapter->registrypriv.wifi_spec == 1)
-			{
+			if (padapter->registrypriv.wifi_spec == 1) {
 				psta->expire_to = pstapriv->expire_to;
 				continue;
 			}
@@ -308,15 +306,13 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 			ret = issue_nulldata23a(padapter, psta->hwaddr, 0, 3, 50);
 
 		psta->keep_alive_trycnt++;
-		if (ret == _SUCCESS)
-		{
+		if (ret == _SUCCESS) {
 			DBG_8723A("asoc check, sta(" MAC_FMT ") is alive\n", MAC_ARG(psta->hwaddr));
 			psta->expire_to = pstapriv->expire_to;
 			psta->keep_alive_trycnt = 0;
 			continue;
- 		}
-		else if (psta->keep_alive_trycnt <= 3)
-		{
+		} else if (psta->keep_alive_trycnt <= 3) {
 			DBG_8723A("ack check for asoc expire, keep_alive_trycnt =%d\n", psta->keep_alive_trycnt);
 			psta->expire_to = 1;
 			continue;
@@ -363,8 +359,7 @@ void add_RATid23a(struct rtw_adapter *padapter, struct sta_info *psta, u8 rssi_l
 		return;
 
 	/* b/g mode ra_bitmap */
-	for (i = 0; i < sizeof(psta->bssrateset); i++)
-	{
+	for (i = 0; i < sizeof(psta->bssrateset); i++) {
 		if (psta->bssrateset[i])
 			tx_ra_bitmap |= rtw_get_bit_value_from_ieee_value23a(psta->bssrateset[i]&0x7f);
 	}
@@ -406,8 +401,7 @@ void add_RATid23a(struct rtw_adapter *padapter, struct sta_info *psta, u8 rssi_l
 	raid = networktype_to_raid23a(sta_band);
 	init_rate = get_highest_rate_idx23a(tx_ra_bitmap&0x0fffffff)&0x3f;
 
-	if (psta->aid < NUM_STA)
-	{
+	if (psta->aid < NUM_STA) {
 		u8 arg = 0;
 
 		arg = psta->mac_id&0x1f;
@@ -436,9 +430,7 @@ void add_RATid23a(struct rtw_adapter *padapter, struct sta_info *psta, u8 rssi_l
 		psta->raid = raid;
 		psta->init_rate = init_rate;
 
-	}
-	else
-	{
+	} else {
 		DBG_8723A("station aid %d exceed the max number\n", psta->aid);
 	}
 }
@@ -453,8 +445,7 @@ static void update_bmc_sta(struct rtw_adapter *padapter)
 	struct wlan_bssid_ex *pcur_network = &pmlmepriv->cur_network.network;
 	struct sta_info *psta = rtw_get_bcmc_stainfo23a(padapter);
 
-	if (psta)
-	{
+	if (psta) {
 		psta->aid = 0;/* default set to 0 */
 		psta->mac_id = psta->aid + 1;
 
@@ -474,8 +465,7 @@ static void update_bmc_sta(struct rtw_adapter *padapter)
 		psta->bssratelen = supportRateNum;
 
 		/* b/g mode ra_bitmap */
-		for (i = 0; i < supportRateNum; i++)
-		{
+		for (i = 0; i < supportRateNum; i++) {
 			if (psta->bssrateset[i])
 				tx_ra_bitmap |= rtw_get_bit_value_from_ieee_value23a(psta->bssrateset[i]&0x7f);
 		}
@@ -522,9 +512,7 @@ static void update_bmc_sta(struct rtw_adapter *padapter)
 		psta->state = _FW_LINKED;
 		spin_unlock_bh(&psta->lock);
 
-	}
-	else
-	{
+	} else {
 		DBG_8723A("add_RATid23a_bmc_sta error!\n");
 	}
 }
@@ -561,8 +549,7 @@ void update_sta_info23a_apmode23a(struct rtw_adapter *padapter, struct sta_info
 	/* ERP */
 	VCS_update23a(padapter, psta);
 	/* HT related cap */
-	if (phtpriv_sta->ht_option)
-	{
+	if (phtpriv_sta->ht_option) {
 		/* check if sta supports rx ampdu */
 		phtpriv_sta->ampdu_enable = phtpriv_ap->ampdu_enable;
 
@@ -580,9 +567,7 @@ void update_sta_info23a_apmode23a(struct rtw_adapter *padapter, struct sta_info
 
 		psta->qos_option = true;
 
-	}
-	else
-	{
+	} else {
 		phtpriv_sta->ampdu_enable = false;
 
 		phtpriv_sta->sgi = false;
@@ -1261,8 +1246,7 @@ void update_beacon23a(struct rtw_adapter *padapter, u8 ie_id, u8 *oui, u8 tx)
 
 	spin_lock_bh(&pmlmepriv->bcn_update_lock);
 
-	switch (ie_id)
-	{
+	switch (ie_id) {
 	case 0xFF:
 		/* 8: TimeStamp, 2: Beacon Interval 2:Capability */
 		update_bcn_fixed_ie(padapter);
@@ -1389,8 +1373,7 @@ static int rtw_ht_operation_update(struct rtw_adapter *padapter)
 void associated_clients_update23a(struct rtw_adapter *padapter, u8 updated)
 {
 	/* update associated stations cap. */
-	if (updated == true)
-	{
+	if (updated == true) {
 		struct list_head *phead, *plist, *ptmp;
 		struct sta_info *psta;
 		struct sta_priv *pstapriv = &padapter->stapriv;
@@ -1416,34 +1399,27 @@ void bss_cap_update_on_sta_join23a(struct rtw_adapter *padapter, struct sta_info
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 
-	if (!(psta->flags & WLAN_STA_SHORT_PREAMBLE))
-	{
-		if (!psta->no_short_preamble_set)
-		{
+	if (!(psta->flags & WLAN_STA_SHORT_PREAMBLE)) {
+		if (!psta->no_short_preamble_set) {
 			psta->no_short_preamble_set = 1;
 
 			pmlmepriv->num_sta_no_short_preamble++;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				(pmlmepriv->num_sta_no_short_preamble == 1))
-			{
+				(pmlmepriv->num_sta_no_short_preamble == 1)) {
 				beacon_updated = true;
 				update_beacon23a(padapter, 0xFF, NULL, true);
 			}
 
 		}
-	}
-	else
-	{
-		if (psta->no_short_preamble_set)
-		{
+	} else {
+		if (psta->no_short_preamble_set) {
 			psta->no_short_preamble_set = 0;
 
 			pmlmepriv->num_sta_no_short_preamble--;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				(pmlmepriv->num_sta_no_short_preamble == 0))
-			{
+				(pmlmepriv->num_sta_no_short_preamble == 0)) {
 				beacon_updated = true;
 				update_beacon23a(padapter, 0xFF, NULL, true);
 			}
@@ -1451,32 +1427,25 @@ void bss_cap_update_on_sta_join23a(struct rtw_adapter *padapter, struct sta_info
 		}
 	}
 
-	if (psta->flags & WLAN_STA_NONERP)
-	{
-		if (!psta->nonerp_set)
-		{
+	if (psta->flags & WLAN_STA_NONERP) {
+		if (!psta->nonerp_set) {
 			psta->nonerp_set = 1;
 
 			pmlmepriv->num_sta_non_erp++;
 
-			if (pmlmepriv->num_sta_non_erp == 1)
-			{
+			if (pmlmepriv->num_sta_non_erp == 1) {
 				beacon_updated = true;
 				update_beacon23a(padapter, WLAN_EID_ERP_INFO, NULL, true);
 			}
 		}
 
-	}
-	else
-	{
-		if (psta->nonerp_set)
-		{
+	} else {
+		if (psta->nonerp_set) {
 			psta->nonerp_set = 0;
 
 			pmlmepriv->num_sta_non_erp--;
 
-			if (pmlmepriv->num_sta_non_erp == 0)
-			{
+			if (pmlmepriv->num_sta_non_erp == 0) {
 				beacon_updated = true;
 				update_beacon23a(padapter, WLAN_EID_ERP_INFO, NULL, true);
 			}
@@ -1484,42 +1453,34 @@ void bss_cap_update_on_sta_join23a(struct rtw_adapter *padapter, struct sta_info
 
 	}
 
-	if (!(psta->capability & WLAN_CAPABILITY_SHORT_SLOT_TIME))
-	{
-		if (!psta->no_short_slot_time_set)
-		{
+	if (!(psta->capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)) {
+		if (!psta->no_short_slot_time_set) {
 			psta->no_short_slot_time_set = 1;
 
 			pmlmepriv->num_sta_no_short_slot_time++;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				 (pmlmepriv->num_sta_no_short_slot_time == 1))
-			{
+				 (pmlmepriv->num_sta_no_short_slot_time == 1)) {
 				beacon_updated = true;
 				update_beacon23a(padapter, 0xFF, NULL, true);
 			}
 
 		}
-	}
-	else
-	{
-		if (psta->no_short_slot_time_set)
-		{
+	} else {
+		if (psta->no_short_slot_time_set) {
 			psta->no_short_slot_time_set = 0;
 
 			pmlmepriv->num_sta_no_short_slot_time--;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				 (pmlmepriv->num_sta_no_short_slot_time == 0))
-			{
+				 (pmlmepriv->num_sta_no_short_slot_time == 0)) {
 				beacon_updated = true;
 				update_beacon23a(padapter, 0xFF, NULL, true);
 			}
 		}
 	}
 
-	if (psta->flags & WLAN_STA_HT)
-	{
+	if (psta->flags & WLAN_STA_HT) {
 		u16 ht_capab = le16_to_cpu(psta->htpriv.ht_cap.cap_info);
 
 		DBG_8723A("HT: STA " MAC_FMT " HT Capabilities "
@@ -1552,9 +1513,7 @@ void bss_cap_update_on_sta_join23a(struct rtw_adapter *padapter, struct sta_info
 				   pmlmepriv->num_sta_ht_20mhz);
 		}
 
-	}
-	else
-	{
+	} else {
 		if (!psta->no_ht_set) {
 			psta->no_ht_set = 1;
 			pmlmepriv->num_sta_no_ht++;
@@ -1567,8 +1526,7 @@ void bss_cap_update_on_sta_join23a(struct rtw_adapter *padapter, struct sta_info
 		}
 	}
 
-	if (rtw_ht_operation_update(padapter) > 0)
-	{
+	if (rtw_ht_operation_update(padapter) > 0) {
 		update_beacon23a(padapter, WLAN_EID_HT_CAPABILITY, NULL, false);
 		update_beacon23a(padapter, WLAN_EID_HT_OPERATION, NULL, true);
 	}
@@ -1592,8 +1550,7 @@ u8 bss_cap_update_on_sta_leave23a(struct rtw_adapter *padapter, struct sta_info
 		psta->no_short_preamble_set = 0;
 		pmlmepriv->num_sta_no_short_preamble--;
 		if (pmlmeext->cur_wireless_mode > WIRELESS_11B
-		    && pmlmepriv->num_sta_no_short_preamble == 0)
-		{
+		    && pmlmepriv->num_sta_no_short_preamble == 0) {
 			beacon_updated = true;
 			update_beacon23a(padapter, 0xFF, NULL, true);
 		}
@@ -1602,8 +1559,7 @@ u8 bss_cap_update_on_sta_leave23a(struct rtw_adapter *padapter, struct sta_info
 	if (psta->nonerp_set) {
 		psta->nonerp_set = 0;
 		pmlmepriv->num_sta_non_erp--;
-		if (pmlmepriv->num_sta_non_erp == 0)
-		{
+		if (pmlmepriv->num_sta_non_erp == 0) {
 			beacon_updated = true;
 			update_beacon23a(padapter, WLAN_EID_ERP_INFO,
 					 NULL, true);
@@ -1614,8 +1570,7 @@ u8 bss_cap_update_on_sta_leave23a(struct rtw_adapter *padapter, struct sta_info
 		psta->no_short_slot_time_set = 0;
 		pmlmepriv->num_sta_no_short_slot_time--;
 		if (pmlmeext->cur_wireless_mode > WIRELESS_11B
-		    && pmlmepriv->num_sta_no_short_slot_time == 0)
-		{
+		    && pmlmepriv->num_sta_no_short_slot_time == 0) {
 			beacon_updated = true;
 			update_beacon23a(padapter, 0xFF, NULL, true);
 		}
@@ -1636,8 +1591,7 @@ u8 bss_cap_update_on_sta_leave23a(struct rtw_adapter *padapter, struct sta_info
 		pmlmepriv->num_sta_ht_20mhz--;
 	}
 
-	if (rtw_ht_operation_update(padapter) > 0)
-	{
+	if (rtw_ht_operation_update(padapter) > 0) {
 		update_beacon23a(padapter, WLAN_EID_HT_CAPABILITY, NULL, false);
 		update_beacon23a(padapter, WLAN_EID_HT_OPERATION, NULL, true);
 	}
@@ -1657,8 +1611,7 @@ u8 ap_free_sta23a(struct rtw_adapter *padapter, struct sta_info *psta, bool acti
 	if (!psta)
 		return beacon_updated;
 
-	if (active == true)
-	{
+	if (active == true) {
 		/* tear down Rx AMPDU */
 		send_delba23a(padapter, 0, psta->hwaddr);/*  recipient */
 
@@ -1788,13 +1741,10 @@ void sta_info_update23a(struct rtw_adapter *padapter, struct sta_info *psta)
 		psta->qos_option = 0;
 
 	/* update 802.11n ht cap. */
-	if (WLAN_STA_HT&flags)
-	{
+	if (WLAN_STA_HT&flags) {
 		psta->htpriv.ht_option = true;
 		psta->qos_option = 1;
-	}
-	else
-	{
+	} else {
 		psta->htpriv.ht_option = false;
 	}
 
@@ -1807,8 +1757,7 @@ void sta_info_update23a(struct rtw_adapter *padapter, struct sta_info *psta)
 /* called >= TSR LEVEL for USB or SDIO Interface*/
 void ap_sta_info_defer_update23a(struct rtw_adapter *padapter, struct sta_info *psta)
 {
-	if (psta->state & _FW_LINKED)
-	{
+	if (psta->state & _FW_LINKED) {
 		/* add ratid */
 		add_RATid23a(padapter, psta, 0);/* DM_RATR_STA_INIT */
 	}
-- 
1.9.1

