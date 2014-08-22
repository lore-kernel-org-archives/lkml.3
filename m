Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbaHVRVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:21:40 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44127 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVRVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:21:39 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: Fix "(foo*)" should be "(foo *)" errors
Date: Fri, 22 Aug 2014 12:20:56 -0500
Message-Id: <1408728056-17306-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "(foo*)" should be "(foo *)" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c        |  8 ++++----
 drivers/staging/rtl8723au/core/rtw_cmd.c       |  6 +++---
 drivers/staging/rtl8723au/core/rtw_mlme.c      |  4 ++--
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c  | 12 ++++++------
 drivers/staging/rtl8723au/core/rtw_wlan_util.c |  2 +-
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index 4d2880a..c2e190e 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -143,7 +143,7 @@ static void update_BCNTIM(struct rtw_adapter *padapter)
 		*dst_ie++ = 0;
 
 	if (tim_ielen == 4) {
-		*dst_ie++ = *(u8*)&tim_bitmap_le;
+		*dst_ie++ = *(u8 *)&tim_bitmap_le;
 	} else if (tim_ielen == 5) {
 		memcpy(dst_ie, &tim_bitmap_le, 2);
 		dst_ie+= 2;
@@ -599,7 +599,7 @@ void update_sta_info23a_apmode23a(struct rtw_adapter *padapter, struct sta_info
 
 	/* todo: init other variables */
 
-	memset((void*)&psta->sta_stats, 0, sizeof(struct stainfo_stats));
+	memset((void *)&psta->sta_stats, 0, sizeof(struct stainfo_stats));
 
 	spin_lock_bh(&psta->lock);
 	psta->state |= _FW_LINKED;
@@ -1021,7 +1021,7 @@ int rtw_check_beacon_data23a(struct rtw_adapter *padapter,
 	pbss_network->Length = get_wlan_bssid_ex_sz(pbss_network);
 
 	/* issue beacon to start bss network */
-	start_bss_network(padapter, (u8*)pbss_network);
+	start_bss_network(padapter, (u8 *)pbss_network);
 
 	/* alloc sta_info for ap itself */
 	psta = rtw_get_stainfo23a(&padapter->stapriv, pbss_network->MacAddress);
@@ -1829,7 +1829,7 @@ void rtw_ap_restore_network(struct rtw_adapter *padapter)
 
 	set_channel_bwmode23a(padapter, pmlmeext->cur_channel, pmlmeext->cur_ch_offset, pmlmeext->cur_bwmode);
 
-	start_bss_network(padapter, (u8*)&mlmepriv->cur_network.network);
+	start_bss_network(padapter, (u8 *)&mlmepriv->cur_network.network);
 
 	if (padapter->securitypriv.dot11PrivacyAlgrthm ==
 	    WLAN_CIPHER_SUITE_TKIP ||
diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 7241a5a..c95946c 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -677,7 +677,7 @@ int rtw_setstakey_cmd23a(struct rtw_adapter *padapter, u8 *psta, u8 unicast_key)
 	struct set_stakey_rsp *psetstakey_rsp = NULL;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
-	struct sta_info *sta = (struct sta_info*)psta;
+	struct sta_info *sta = (struct sta_info *)psta;
 	int res = _SUCCESS;
 
 	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
@@ -1493,7 +1493,7 @@ void rtw_setstaKey_cmdrsp_callback23a(struct rtw_adapter *padapter,
 	struct sta_info *psta;
 
 	pstapriv = &padapter->stapriv;
-	psetstakey_rsp = (struct set_stakey_rsp*) (pcmd->rsp);
+	psetstakey_rsp = (struct set_stakey_rsp *) (pcmd->rsp);
 	psta = rtw_get_stainfo23a(pstapriv, psetstakey_rsp->addr);
 
 	if (!psta) {
@@ -1518,7 +1518,7 @@ void rtw_setassocsta_cmdrsp_callback23a(struct rtw_adapter *padapter,
 	struct sta_info *psta;
 
 	passocsta_parm = (struct set_assocsta_parm *)(pcmd->parmbuf);
-	passocsta_rsp = (struct set_assocsta_rsp*) (pcmd->rsp);
+	passocsta_rsp = (struct set_assocsta_rsp *) (pcmd->rsp);
 	psta = rtw_get_stainfo23a(pstapriv, passocsta_parm->addr);
 
 	if (psta == NULL) {
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index c475b79..dddc5b2 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -1256,7 +1256,7 @@ void rtw_stassoc_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 {
 	struct sta_info *psta;
 	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
-	struct stassoc_event *pstassoc = (struct stassoc_event*)pbuf;
+	struct stassoc_event *pstassoc = (struct stassoc_event *)pbuf;
 	struct wlan_network *cur_network = &pmlmepriv->cur_network;
 	struct wlan_network *ptarget_wlan;
 
@@ -2187,7 +2187,7 @@ bool rtw_restructure_ht_ie23a(struct rtw_adapter *padapter, u8 *in_ie,
 
 		pframe = rtw_set_ie23a(out_ie + out_len, WLAN_EID_HT_CAPABILITY,
 				    sizeof(struct ieee80211_ht_cap),
-				    (unsigned char*)&ht_capie, pout_len);
+				    (unsigned char *)&ht_capie, pout_len);
 
 		phtpriv->ht_option = true;
 
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index c5fdcb8..03a1f01 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -2436,7 +2436,7 @@ void issue_beacon23a(struct rtw_adapter *padapter, int timeout_ms)
 		if (wps_ie && wps_ie[1] > 0) {
 			rtw_get_wps_attr_content23a(wps_ie, wps_ie[1],
 						    WPS_ATTR_SELECTED_REGISTRAR,
-						    (u8*)&sr);
+						    (u8 *)&sr);
 		}
 		if (sr != 0)
 			set_fwstate(pmlmepriv, WIFI_UNDER_WPS);
@@ -4763,7 +4763,7 @@ void report_survey_event23a(struct rtw_adapter *padapter,
 	pcmd_obj->rsp = NULL;
 	pcmd_obj->rspsz  = 0;
 
-	pc2h_evt_hdr = (struct C2HEvent_Header*)(pevtcmd);
+	pc2h_evt_hdr = (struct C2HEvent_Header *)(pevtcmd);
 	pc2h_evt_hdr->len = sizeof(struct survey_event);
 	pc2h_evt_hdr->ID = GEN_EVT_CODE(_Survey);
 	pc2h_evt_hdr->seq = atomic_inc_return(&pmlmeext->event_seq);
@@ -4814,7 +4814,7 @@ void report_surveydone_event23a(struct rtw_adapter *padapter)
 	pcmd_obj->rsp = NULL;
 	pcmd_obj->rspsz  = 0;
 
-	pc2h_evt_hdr = (struct C2HEvent_Header*)(pevtcmd);
+	pc2h_evt_hdr = (struct C2HEvent_Header *)(pevtcmd);
 	pc2h_evt_hdr->len = sizeof(struct surveydone_event);
 	pc2h_evt_hdr->ID = GEN_EVT_CODE(_SurveyDone);
 	pc2h_evt_hdr->seq = atomic_inc_return(&pmlmeext->event_seq);
@@ -4858,7 +4858,7 @@ void report_join_res23a(struct rtw_adapter *padapter, int res)
 	pcmd_obj->rsp = NULL;
 	pcmd_obj->rspsz  = 0;
 
-	pc2h_evt_hdr = (struct C2HEvent_Header*)(pevtcmd);
+	pc2h_evt_hdr = (struct C2HEvent_Header *)(pevtcmd);
 	pc2h_evt_hdr->len = sizeof(struct joinbss_event);
 	pc2h_evt_hdr->ID = GEN_EVT_CODE(_JoinBss);
 	pc2h_evt_hdr->seq = atomic_inc_return(&pmlmeext->event_seq);
@@ -4908,7 +4908,7 @@ void report_del_sta_event23a(struct rtw_adapter *padapter,
 	pcmd_obj->rsp = NULL;
 	pcmd_obj->rspsz  = 0;
 
-	pc2h_evt_hdr = (struct C2HEvent_Header*)(pevtcmd);
+	pc2h_evt_hdr = (struct C2HEvent_Header *)(pevtcmd);
 	pc2h_evt_hdr->len = sizeof(struct stadel_event);
 	pc2h_evt_hdr->ID = GEN_EVT_CODE(_DelSTA);
 	pc2h_evt_hdr->seq = atomic_inc_return(&pmlmeext->event_seq);
@@ -4962,7 +4962,7 @@ void report_add_sta_event23a(struct rtw_adapter *padapter,
 	pcmd_obj->rsp = NULL;
 	pcmd_obj->rspsz  = 0;
 
-	pc2h_evt_hdr = (struct C2HEvent_Header*)(pevtcmd);
+	pc2h_evt_hdr = (struct C2HEvent_Header *)(pevtcmd);
 	pc2h_evt_hdr->len = sizeof(struct stassoc_event);
 	pc2h_evt_hdr->ID = GEN_EVT_CODE(_AddSTA);
 	pc2h_evt_hdr->seq = atomic_inc_return(&pmlmeext->event_seq);
diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index 32f3603..bc587b3 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -1537,7 +1537,7 @@ void process_addba_req23a(struct rtw_adapter *padapter,
 	u16 tid, start_seq, param;
 	struct recv_reorder_ctrl *preorder_ctrl;
 	struct sta_priv *pstapriv = &padapter->stapriv;
-	struct ADDBA_request *preq = (struct ADDBA_request*)paddba_req;
+	struct ADDBA_request *preq = (struct ADDBA_request *)paddba_req;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
 
-- 
1.9.1

