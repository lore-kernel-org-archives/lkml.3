Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaFVIwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:52:12 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61840 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaFVIwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:52:07 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 31/42] staging: rtl8188eu: Use get_unaligned_le16() instead of RTW_GET_LE16()
Date: Sun, 22 Jun 2014 14:21:35 +0530
Message-Id: <1403427107-12744-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c           |    4 ++--
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c    |    8 ++++----
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |    6 +++---
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index 1987185..768a359 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -900,10 +900,10 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 
 	/* beacon interval */
 	p = rtw_get_beacon_interval_from_ie(ie);/* 8: TimeStamp, 2: Beacon Interval 2:Capability */
-	pbss_network->Configuration.BeaconPeriod = RTW_GET_LE16(p);
+	pbss_network->Configuration.BeaconPeriod = get_unaligned_le16(p);
 
 	/* capability */
-	cap = RTW_GET_LE16(ie);
+	cap = get_unaligned_le16(ie);
 
 	/* SSID */
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, _SSID_IE_, &ie_len, (pbss_network->IELength - _BEACON_IE_OFFSET_));
diff --git a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
index 9eb198a..d264847 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
@@ -551,7 +551,7 @@ int rtw_parse_wpa_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher, int *pairwis
 
 	/* pairwise_cipher */
 	if (left >= 2) {
-		count = RTW_GET_LE16(pos);
+		count = get_unaligned_le16(pos);
 		pos += 2;
 		left -= 2;
 
@@ -619,7 +619,7 @@ int rtw_parse_wpa2_ie(u8 *rsn_ie, int rsn_ie_len, int *group_cipher, int *pairwi
 
 	/* pairwise_cipher */
 	if (left >= 2) {
-		count = RTW_GET_LE16(pos);
+		count = get_unaligned_le16(pos);
 		pos += 2;
 		left -= 2;
 
@@ -1179,7 +1179,7 @@ void dump_p2p_ie(u8 *ie, u32 ie_len)
 	pos += 6;
 	while (pos-ie < ie_len) {
 		id = *pos;
-		len = RTW_GET_LE16(pos+1);
+		len = get_unaligned_le16(pos+1);
 		DBG_88E("%s ID:%u, LEN:%u\n", __func__, id, len);
 		pos += (3+len);
 	}
@@ -1253,7 +1253,7 @@ u8 *rtw_get_p2p_attr(u8 *p2p_ie, uint p2p_ielen, u8 target_attr_id , u8 *buf_att
 	while (attr_ptr - p2p_ie < p2p_ielen) {
 		/*  3 = 1(Attribute ID) + 2(Length) */
 		u8 attr_id = *attr_ptr;
-		u16 attr_data_len = RTW_GET_LE16(attr_ptr + 1);
+		u16 attr_data_len = get_unaligned_le16(attr_ptr + 1);
 		u16 attr_len = attr_data_len + 3;
 
 		if (attr_id == target_attr_id) {
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 1b855b4..dc194324 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -1053,7 +1053,7 @@ unsigned int OnAssocReq(struct adapter *padapter, struct recv_frame *precv_frame
 		goto asoc_class2_error;
 	}
 
-	capab_info = RTW_GET_LE16(pframe + WLAN_HDR_A3_LEN);
+	capab_info = get_unaligned_le16(pframe + WLAN_HDR_A3_LEN);
 
 	left = pkt_len - (IEEE80211_3ADDR_LEN + ie_offset);
 	pos = pframe + (IEEE80211_3ADDR_LEN + ie_offset);
@@ -1788,7 +1788,7 @@ unsigned int OnAction_back(struct adapter *padapter, struct recv_frame *precv_fr
 				issue_action_BA(padapter, addr, RTW_WLAN_ACTION_ADDBA_RESP, 37);/* reject ADDBA Req */
 			break;
 		case RTW_WLAN_ACTION_ADDBA_RESP: /* ADDBA response */
-			status = RTW_GET_LE16(&frame_body[3]);
+			status = get_unaligned_le16(&frame_body[3]);
 			tid = ((frame_body[5] >> 2) & 0x7);
 			if (status == 0) {	/* successful */
 				DBG_88E("agg_enable for TID=%d\n", tid);
@@ -1802,7 +1802,7 @@ unsigned int OnAction_back(struct adapter *padapter, struct recv_frame *precv_fr
 			if ((frame_body[3] & BIT(3)) == 0) {
 				psta->htpriv.agg_enable_bitmap &= ~(1 << ((frame_body[3] >> 4) & 0xf));
 				psta->htpriv.candidate_tid_bitmap &= ~(1 << ((frame_body[3] >> 4) & 0xf));
-				reason_code = RTW_GET_LE16(&frame_body[4]);
+				reason_code = get_unaligned_le16(&frame_body[4]);
 			} else if ((frame_body[3] & BIT(3)) == BIT(3)) {
 				tid = (frame_body[3] >> 4) & 0x0F;
 				preorder_ctrl =  &psta->recvreorder_ctrl[tid];
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 0b54856..bbb46cb 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -242,7 +242,6 @@ u64 rtw_modular64(u64 x, u64 y);
 
 /* Macros for handling unaligned memory accesses */
 
-#define RTW_GET_LE16(a) ((u16) (((a)[1] << 8) | (a)[0]))
 #define RTW_PUT_LE16(a, val)			\
 	do {					\
 		(a)[1] = ((u16) (val)) >> 8;	\
-- 
1.7.10.4

