Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbaGBQwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:52:38 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58573 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaGBQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:52:36 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 26/48] staging: rtl8188eu: rtw_cmd.h: Remove struct [join,create]bss_parm
Date: Wed,  2 Jul 2014 22:17:22 +0530
Message-Id: <1404319664-8327-26-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two structures have only one member.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |   10 +++++-----
 drivers/staging/rtl8188eu/include/rtw_cmd.h      |   23 ----------------------
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    4 ++--
 3 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index c4888b1..3bd3962 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -4959,11 +4959,11 @@ u8 createbss_hdl(struct adapter *padapter, u8 *pbuf)
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	struct wlan_bssid_ex *pnetwork = (struct wlan_bssid_ex *)(&(pmlmeinfo->network));
-	struct joinbss_parm *pparm = (struct joinbss_parm *)pbuf;
+	struct wlan_bssid_ex *pparm = (struct wlan_bssid_ex *)pbuf;
 	/* u32	initialgain; */
 
 
-	if (pparm->network.InfrastructureMode == Ndis802_11APMode) {
+	if (pparm->InfrastructureMode == Ndis802_11APMode) {
 #ifdef CONFIG_88EU_AP_MODE
 
 		if (pmlmeinfo->state == WIFI_FW_AP_STATE) {
@@ -4974,7 +4974,7 @@ u8 createbss_hdl(struct adapter *padapter, u8 *pbuf)
 	}
 
 	/* below is for ad-hoc master */
-	if (pparm->network.InfrastructureMode == Ndis802_11IBSS) {
+	if (pparm->InfrastructureMode == Ndis802_11IBSS) {
 		rtw_joinbss_reset(padapter);
 
 		pmlmeext->cur_bwmode = HT_CHANNEL_WIDTH_20;
@@ -5023,7 +5023,7 @@ u8 join_cmd_hdl(struct adapter *padapter, u8 *pbuf)
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	struct wlan_bssid_ex *pnetwork = (struct wlan_bssid_ex *)(&(pmlmeinfo->network));
-	struct joinbss_parm	*pparm = (struct joinbss_parm *)pbuf;
+	struct wlan_bssid_ex *pparm = (struct wlan_bssid_ex *)pbuf;
 	u32 i;
 
 	/* check already connecting to AP or not */
@@ -5045,7 +5045,7 @@ u8 join_cmd_hdl(struct adapter *padapter, u8 *pbuf)
 		rtw_hal_set_hwreg(padapter, HW_VAR_MLME_DISCONNECT, NULL);
 	}
 
-	rtw_antenna_select_cmd(padapter, pparm->network.PhyInfo.Optimum_antenna, false);
+	rtw_antenna_select_cmd(padapter, pparm->PhyInfo.Optimum_antenna, false);
 
 	rtw_joinbss_reset(padapter);
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index bfd7eaf..6ff500c 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -111,18 +111,6 @@ enum RFINTFS {
 };
 
 /*
-Caller Mode: Infra, Ad-Hoc
-
-Notes: To join the specified bss
-
-Command Event Mode
-
-*/
-struct joinbss_parm {
-	struct wlan_bssid_ex network;
-};
-
-/*
 Caller Mode: Infra, Ad-HoC(C)
 
 Notes: To disconnect the current associated BSS
@@ -134,17 +122,6 @@ struct disconnect_parm {
 	u32 deauth_timeout_ms;
 };
 
-/*
-Caller Mode: AP, Ad-HoC(M)
-
-Notes: To create a BSS
-
-Command Mode
-*/
-struct createbss_parm {
-	struct wlan_bssid_ex network;
-};
-
 struct	setopmode_parm {
 	u8	mode;
 	u8	rsvd[3];
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 17c680f..1fdd1f8 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -722,9 +722,9 @@ static struct cmd_hdl wlancmds[] = {
 	GEN_MLME_EXT_HANDLER(0, NULL)
 	GEN_MLME_EXT_HANDLER(0, NULL)
 	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct joinbss_parm), join_cmd_hdl) /*14*/
+	GEN_MLME_EXT_HANDLER(sizeof (struct wlan_bssid_ex), join_cmd_hdl) /*14*/
 	GEN_MLME_EXT_HANDLER(sizeof (struct disconnect_parm), disconnect_hdl)
-	GEN_MLME_EXT_HANDLER(sizeof (struct createbss_parm), createbss_hdl)
+	GEN_MLME_EXT_HANDLER(sizeof (struct wlan_bssid_ex), createbss_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof (struct setopmode_parm), setopmode_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof (struct sitesurvey_parm),
 			     sitesurvey_cmd_hdl) /*18*/
-- 
1.7.10.4

