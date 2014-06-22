Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaFVIv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:51:58 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64963 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaFVIvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:51:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 29/42] staging: rtl8188eu: Use get_unaligned_be16() instead of RTW_GET_BE16()
Date: Sun, 22 Jun 2014 14:21:33 +0530
Message-Id: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c    |    8 ++++----
 drivers/staging/rtl8188eu/core/rtw_recv.c         |    4 ++--
 drivers/staging/rtl8188eu/include/osdep_service.h |    2 --
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
index ae8895e..9eb198a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
@@ -807,8 +807,8 @@ u8 *rtw_get_wps_attr(u8 *wps_ie, uint wps_ielen, u16 target_attr_id , u8 *buf_at
 
 	while (attr_ptr - wps_ie < wps_ielen) {
 		/*  4 = 2(Attribute ID) + 2(Length) */
-		u16 attr_id = RTW_GET_BE16(attr_ptr);
-		u16 attr_data_len = RTW_GET_BE16(attr_ptr + 2);
+		u16 attr_id = get_unaligned_be16(attr_ptr);
+		u16 attr_data_len = get_unaligned_be16(attr_ptr + 2);
 		u16 attr_len = attr_data_len + 4;
 
 		if (attr_id == target_attr_id) {
@@ -1156,8 +1156,8 @@ void dump_wps_ie(u8 *ie, u32 ie_len)
 
 	pos += 6;
 	while (pos-ie < ie_len) {
-		id = RTW_GET_BE16(pos);
-		len = RTW_GET_BE16(pos + 2);
+		id = get_unaligned_be16(pos);
+		len = get_unaligned_be16(pos + 2);
 		DBG_88E("%s ID:0x%04x, LEN:%u\n", __func__, id, len);
 		pos += (4+len);
 	}
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 56aa886..e0f0765 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -1644,7 +1644,7 @@ static int amsdu_to_msdu(struct adapter *padapter, struct recv_frame *prframe)
 
 	while (a_len > ETH_HLEN) {
 		/* Offset 12 denote 2 mac address */
-		nSubframe_Length = RTW_GET_BE16(pdata + 12);
+		nSubframe_Length = get_unaligned_be16(pdata + 12);
 
 		if (a_len < (ETHERNET_HEADER_SIZE + nSubframe_Length)) {
 			DBG_88E("nRemain_Length is %d and nSubframe_Length is : %d\n", a_len, nSubframe_Length);
@@ -1699,7 +1699,7 @@ static int amsdu_to_msdu(struct adapter *padapter, struct recv_frame *prframe)
 	for (i = 0; i < nr_subframes; i++) {
 		sub_skb = subframes[i];
 		/* convert hdr + possible LLC headers into Ethernet header */
-		eth_type = RTW_GET_BE16(&sub_skb->data[6]);
+		eth_type = get_unaligned_be16(&sub_skb->data[6]);
 		if (sub_skb->len >= 8 &&
 		    ((!memcmp(sub_skb->data, rtw_rfc1042_header, SNAP_SIZE) &&
 			  eth_type != ETH_P_AARP && eth_type != ETH_P_IPX) ||
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 2a5cb20..ca0957b 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -252,8 +252,6 @@ u64 rtw_modular64(u64 x, u64 y);
 
 /* Macros for handling unaligned memory accesses */
 
-#define RTW_GET_BE16(a) ((u16) (((a)[0] << 8) | (a)[1]))
-
 #define RTW_GET_LE16(a) ((u16) (((a)[1] << 8) | (a)[0]))
 #define RTW_PUT_LE16(a, val)			\
 	do {					\
-- 
1.7.10.4

