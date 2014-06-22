Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaFVIip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:38:45 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48784 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaFVIik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:38:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 28/42] staging: rtl8188eu: Use cpu_to_be16() instead of RTW_PUT_BE16()
Date: Sun, 22 Jun 2014 14:06:34 +0530
Message-Id: <1403426208-12413-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_p2p.c          |   48 ++++++++-------------
 drivers/staging/rtl8188eu/include/osdep_service.h |    5 ---
 2 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_p2p.c b/drivers/staging/rtl8188eu/core/rtw_p2p.c
index 5bc1937..c7bceae 100644
--- a/drivers/staging/rtl8188eu/core/rtw_p2p.c
+++ b/drivers/staging/rtl8188eu/core/rtw_p2p.c
@@ -82,8 +82,7 @@ static u32 go_add_group_info_attr(struct wifidirect_info *pwdinfo, u8 *pbuf)
 			*pcur = psta->dev_cap;
 			pcur++;
 
-			/* u16*)(pcur) = cpu_to_be16(psta->config_methods); */
-			RTW_PUT_BE16(pcur, psta->config_methods);
+			*((u16 *)(pcur)) = cpu_to_be16(psta->config_methods);
 			pcur += 2;
 
 			memcpy(pcur, psta->primary_dev_type, 8);
@@ -96,12 +95,10 @@ static u32 go_add_group_info_attr(struct wifidirect_info *pwdinfo, u8 *pbuf)
 			pcur += psta->num_of_secdev_type*8;
 
 			if (psta->dev_name_len > 0) {
-				/* u16*)(pcur) = cpu_to_be16(WPS_ATTR_DEVICE_NAME); */
-				RTW_PUT_BE16(pcur, WPS_ATTR_DEVICE_NAME);
+				*(u16 *)(pcur) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
 				pcur += 2;
 
-				/* u16*)(pcur) = cpu_to_be16(psta->dev_name_len); */
-				RTW_PUT_BE16(pcur, psta->dev_name_len);
+				*(u16 *)(pcur) = cpu_to_be16(psta->dev_name_len);
 				pcur += 2;
 
 				memcpy(pcur, psta->dev_name, psta->dev_name_len);
@@ -315,15 +312,15 @@ static void issue_p2p_provision_resp(struct wifidirect_info *pwdinfo, u8 *raddr,
 
 	/*	Config Method */
 	/*	Type: */
-	RTW_PUT_BE16(wpsie + wpsielen, WPS_ATTR_CONF_METHOD);
+	*(u16 *)(wpsie+wpsielen) = cpu_to_be16(WPS_ATTR_CONF_METHOD);
 	wpsielen += 2;
 
 	/*	Length: */
-	RTW_PUT_BE16(wpsie + wpsielen, 0x0002);
+	*(u16 *)(wpsie+wpsielen) = cpu_to_be16(0x0002);
 	wpsielen += 2;
 
 	/*	Value: */
-	RTW_PUT_BE16(wpsie + wpsielen, config_method);
+	*(u16 *)(wpsie+wpsielen) = cpu_to_be16(config_method);
 	wpsielen += 2;
 
 	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, wpsielen, (unsigned char *)wpsie, &pattrib->pktlen);
@@ -558,14 +555,12 @@ u32 build_probe_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
 
 	/*	Config Method */
 	/*	This field should be big endian. Noted by P2P specification. */
-	/* u16*) (p2pie + p2pielen) = cpu_to_be16(pwdinfo->supported_wps_cm); */
-	RTW_PUT_BE16(p2pie + p2pielen, pwdinfo->supported_wps_cm);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(pwdinfo->supported_wps_cm);
 	p2pielen += 2;
 
 	/*	Primary Device Type */
 	/*	Category ID */
-	/* u16*) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA); */
-	RTW_PUT_BE16(p2pie + p2pielen, WPS_PDT_CID_MULIT_MEDIA);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
 	p2pielen += 2;
 
 	/*	OUI */
@@ -573,8 +568,7 @@ u32 build_probe_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
 	p2pielen += 4;
 
 	/*	Sub Category ID */
-	/* u16*) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER); */
-	RTW_PUT_BE16(p2pie + p2pielen, WPS_PDT_SCID_MEDIA_SERVER);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
 	p2pielen += 2;
 
 	/*	Number of Secondary Device Types */
@@ -582,13 +576,11 @@ u32 build_probe_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
 
 	/*	Device Name */
 	/*	Type: */
-	/* u16*) (p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME); */
-	RTW_PUT_BE16(p2pie + p2pielen, WPS_ATTR_DEVICE_NAME);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
 	p2pielen += 2;
 
 	/*	Length: */
-	/* u16*) (p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len); */
-	RTW_PUT_BE16(p2pie + p2pielen, pwdinfo->device_name_len);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len);
 	p2pielen += 2;
 
 	/*	Value: */
@@ -666,19 +658,16 @@ u32 build_prov_disc_request_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf, u8
 	/*	Config Method */
 	/*	This field should be big endian. Noted by P2P specification. */
 	if (pwdinfo->ui_got_wps_info == P2P_GOT_WPSINFO_PBC) {
-		/* u16*) (p2pie + p2pielen) = cpu_to_be16(WPS_CONFIG_METHOD_PBC); */
-		RTW_PUT_BE16(p2pie + p2pielen, WPS_CONFIG_METHOD_PBC);
+		*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_CONFIG_METHOD_PBC);
 	} else {
-		/* u16*) (p2pie + p2pielen) = cpu_to_be16(WPS_CONFIG_METHOD_DISPLAY); */
-		RTW_PUT_BE16(p2pie + p2pielen, WPS_CONFIG_METHOD_DISPLAY);
+		*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_CONFIG_METHOD_DISPLAY);
 	}
 
 	p2pielen += 2;
 
 	/*	Primary Device Type */
 	/*	Category ID */
-	/* u16*) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA); */
-	RTW_PUT_BE16(p2pie + p2pielen, WPS_PDT_CID_MULIT_MEDIA);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
 	p2pielen += 2;
 
 	/*	OUI */
@@ -686,8 +675,7 @@ u32 build_prov_disc_request_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf, u8
 	p2pielen += 4;
 
 	/*	Sub Category ID */
-	/* u16*) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER); */
-	RTW_PUT_BE16(p2pie + p2pielen, WPS_PDT_SCID_MEDIA_SERVER);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
 	p2pielen += 2;
 
 	/*	Number of Secondary Device Types */
@@ -695,13 +683,11 @@ u32 build_prov_disc_request_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf, u8
 
 	/*	Device Name */
 	/*	Type: */
-	/* u16*) (p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME); */
-	RTW_PUT_BE16(p2pie + p2pielen, WPS_ATTR_DEVICE_NAME);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
 	p2pielen += 2;
 
 	/*	Length: */
-	/* u16*) (p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len); */
-	RTW_PUT_BE16(p2pie + p2pielen, pwdinfo->device_name_len);
+	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len);
 	p2pielen += 2;
 
 	/*	Value: */
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 30613fc..2a5cb20 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -253,11 +253,6 @@ u64 rtw_modular64(u64 x, u64 y);
 /* Macros for handling unaligned memory accesses */
 
 #define RTW_GET_BE16(a) ((u16) (((a)[0] << 8) | (a)[1]))
-#define RTW_PUT_BE16(a, val)			\
-	do {					\
-		(a)[0] = ((u16) (val)) >> 8;	\
-		(a)[1] = ((u16) (val)) & 0xff;	\
-	} while (0)
 
 #define RTW_GET_LE16(a) ((u16) (((a)[1] << 8) | (a)[0]))
 #define RTW_PUT_LE16(a, val)			\
-- 
1.7.10.4

