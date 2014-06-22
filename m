Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaFVIwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:52:15 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55809 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaFVIwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:52:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 32/42] staging: rtl8188eu: Use cpu_to_le16() insted of RTW_PUT_LE16()
Date: Sun, 22 Jun 2014 14:21:36 +0530
Message-Id: <1403427107-12744-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c    |    7 +++---
 drivers/staging/rtl8188eu/core/rtw_p2p.c          |   24 +++++++--------------
 drivers/staging/rtl8188eu/include/osdep_service.h |    6 ------
 3 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
index d264847..54ebf34 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
@@ -206,8 +206,8 @@ inline u8 *rtw_set_ie_mesh_ch_switch_parm(u8 *buf, u32 *buf_len, u8 ttl,
 
 	ie_data[0] = ttl;
 	ie_data[1] = flags;
-	RTW_PUT_LE16((u8 *)&ie_data[2], reason);
-	RTW_PUT_LE16((u8 *)&ie_data[4], precedence);
+	*(u16 *)(ie_data+2) = cpu_to_le16(reason);
+	*(u16 *)(ie_data+4) = cpu_to_le16(precedence);
 
 	return rtw_set_ie(buf, 0x118,  6, ie_data, buf_len);
 }
@@ -1310,8 +1310,7 @@ u32 rtw_set_p2p_attr_content(u8 *pbuf, u8 attr_id, u16 attr_len, u8 *pdata_attr)
 
 	*pbuf = attr_id;
 
-	/* u16*)(pbuf + 1) = cpu_to_le16(attr_len); */
-	RTW_PUT_LE16(pbuf + 1, attr_len);
+	*(u16 *)(pbuf + 1) = cpu_to_le16(attr_len);
 
 	if (pdata_attr)
 		memcpy(pbuf + 3, pdata_attr, attr_len);
diff --git a/drivers/staging/rtl8188eu/core/rtw_p2p.c b/drivers/staging/rtl8188eu/core/rtw_p2p.c
index c7bceae..6023a85 100644
--- a/drivers/staging/rtl8188eu/core/rtw_p2p.c
+++ b/drivers/staging/rtl8188eu/core/rtw_p2p.c
@@ -487,8 +487,7 @@ u32 build_probe_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
 	p2pie[p2pielen++] = P2P_ATTR_CAPABILITY;
 
 	/*	Length: */
-	/* u16*) (p2pie + p2pielen) = cpu_to_le16(0x0002); */
-	RTW_PUT_LE16(p2pie + p2pielen, 0x0002);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0x0002);
 	p2pielen += 2;
 
 	/*	Value: */
@@ -516,19 +515,16 @@ u32 build_probe_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
 	p2pie[p2pielen++] = P2P_ATTR_EX_LISTEN_TIMING;
 
 	/*	Length: */
-	/* u16*) (p2pie + p2pielen) = cpu_to_le16(0x0004); */
-	RTW_PUT_LE16(p2pie + p2pielen, 0x0004);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0x0004);
 	p2pielen += 2;
 
 	/*	Value: */
 	/*	Availability Period */
-	/* u16*) (p2pie + p2pielen) = cpu_to_le16(0xFFFF); */
-	RTW_PUT_LE16(p2pie + p2pielen, 0xFFFF);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0xFFFF);
 	p2pielen += 2;
 
 	/*	Availability Interval */
-	/* u16*) (p2pie + p2pielen) = cpu_to_le16(0xFFFF); */
-	RTW_PUT_LE16(p2pie + p2pielen, 0xFFFF);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0xFFFF);
 	p2pielen += 2;
 
 
@@ -544,8 +540,7 @@ u32 build_probe_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
 	/*	Length: */
 	/*	21 -> P2P Device Address (6bytes) + Config Methods (2bytes) + Primary Device Type (8bytes) */
 	/*	+ NumofSecondDevType (1byte) + WPS Device Name ID field (2bytes) + WPS Device Name Len field (2bytes) */
-	/* u16*) (p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len); */
-	RTW_PUT_LE16(p2pie + p2pielen, 21 + pwdinfo->device_name_len);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len);
 	p2pielen += 2;
 
 	/*	Value: */
@@ -624,8 +619,7 @@ u32 build_prov_disc_request_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf, u8
 	p2pie[p2pielen++] = P2P_ATTR_CAPABILITY;
 
 	/*	Length: */
-	/* u16*) (p2pie + p2pielen) = cpu_to_le16(0x0002); */
-	RTW_PUT_LE16(p2pie + p2pielen, 0x0002);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0x0002);
 	p2pielen += 2;
 
 	/*	Value: */
@@ -646,8 +640,7 @@ u32 build_prov_disc_request_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf, u8
 	/*	Length: */
 	/*	21 -> P2P Device Address (6bytes) + Config Methods (2bytes) + Primary Device Type (8bytes) */
 	/*	+ NumofSecondDevType (1byte) + WPS Device Name ID field (2bytes) + WPS Device Name Len field (2bytes) */
-	/* u16*) (p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len); */
-	RTW_PUT_LE16(p2pie + p2pielen, 21 + pwdinfo->device_name_len);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len);
 	p2pielen += 2;
 
 	/*	Value: */
@@ -703,8 +696,7 @@ u32 build_prov_disc_request_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf, u8
 		p2pie[p2pielen++] = P2P_ATTR_GROUP_ID;
 
 		/*	Length: */
-		/* u16*) (p2pie + p2pielen) = cpu_to_le16(ETH_ALEN + ussidlen); */
-		RTW_PUT_LE16(p2pie + p2pielen, ETH_ALEN + ussidlen);
+		*(u16 *) (p2pie + p2pielen) = cpu_to_le16(ETH_ALEN + ussidlen);
 		p2pielen += 2;
 
 		/*	Value: */
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index bbb46cb..1fb92c6 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -242,12 +242,6 @@ u64 rtw_modular64(u64 x, u64 y);
 
 /* Macros for handling unaligned memory accesses */
 
-#define RTW_PUT_LE16(a, val)			\
-	do {					\
-		(a)[1] = ((u16) (val)) >> 8;	\
-		(a)[0] = ((u16) (val)) & 0xff;	\
-	} while (0)
-
 #define RTW_GET_BE24(a) ((((u32) (a)[0]) << 16) | (((u32) (a)[1]) << 8) | \
 			 ((u32) (a)[2]))
 
-- 
1.7.10.4

