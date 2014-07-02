Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbaGBQwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:52:49 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57081 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbaGBQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:52:46 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 27/48] staging: rtl8188eu: rtw_cmd.h: Remove struct Tx_Beacon_param
Date: Wed,  2 Jul 2014 22:17:23 +0530
Message-Id: <1404319664-8327-27-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct Tx_Beacon_param has only one member.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |   12 ++++++------
 drivers/staging/rtl8188eu/include/rtw_cmd.h      |    4 ----
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 3bd3962..b4dd14e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -5416,7 +5416,7 @@ u8 add_ba_hdl(struct adapter *padapter, unsigned char *pbuf)
 u8 set_tx_beacon_cmd(struct adapter *padapter)
 {
 	struct cmd_obj	*ph2c;
-	struct Tx_Beacon_param	*ptxBeacon_parm;
+	struct wlan_bssid_ex	*ptxBeacon_parm;
 	struct cmd_priv	*pcmdpriv = &(padapter->cmdpriv);
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
@@ -5430,19 +5430,19 @@ u8 set_tx_beacon_cmd(struct adapter *padapter)
 		goto exit;
 	}
 
-	ptxBeacon_parm = kzalloc(sizeof(struct Tx_Beacon_param), GFP_KERNEL);
+	ptxBeacon_parm = kzalloc(sizeof(struct wlan_bssid_ex), GFP_KERNEL);
 	if (ptxBeacon_parm == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
 	}
 
-	memcpy(&(ptxBeacon_parm->network), &(pmlmeinfo->network), sizeof(struct wlan_bssid_ex));
+	memcpy(ptxBeacon_parm, &(pmlmeinfo->network), sizeof(struct wlan_bssid_ex));
 
-	len_diff = update_hidden_ssid(ptxBeacon_parm->network.IEs+_BEACON_IE_OFFSET_,
-				      ptxBeacon_parm->network.IELength-_BEACON_IE_OFFSET_,
+	len_diff = update_hidden_ssid(ptxBeacon_parm->IEs+_BEACON_IE_OFFSET_,
+				      ptxBeacon_parm->IELength-_BEACON_IE_OFFSET_,
 				      pmlmeinfo->hidden_ssid_mode);
-	ptxBeacon_parm->network.IELength += len_diff;
+	ptxBeacon_parm->IELength += len_diff;
 
 	init_h2fwcmd_w_parm_no_rsp(ph2c, ptxBeacon_parm, GEN_CMD_CODE(_TX_Beacon));
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 6ff500c..d6b8724 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -353,10 +353,6 @@ struct	getphy_parm {
 
 };
 
-struct Tx_Beacon_param {
-	struct wlan_bssid_ex network;
-};
-
 /*
 	Notes: This command is used for H2C/C2H loopback testing
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 1fdd1f8..2a32caa 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -764,7 +764,7 @@ static struct cmd_hdl wlancmds[] = {
 	GEN_MLME_EXT_HANDLER(0, NULL)
 	GEN_MLME_EXT_HANDLER(0, NULL)
 	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(sizeof(struct Tx_Beacon_param),
+	GEN_MLME_EXT_HANDLER(sizeof(struct wlan_bssid_ex),
 			     tx_beacon_hdl) /*55*/
 
 	GEN_MLME_EXT_HANDLER(0, mlme_evt_hdl) /*56*/
-- 
1.7.10.4

