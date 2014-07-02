Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaGBQve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:51:34 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53558 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaGBQva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:51:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 19/48] staging: rtl8188eu: Remove unused function rtw_setassocsta_cmd()
Date: Wed,  2 Jul 2014 22:17:15 +0530
Message-Id: <1404319664-8327-19-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   44 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 45 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index de62902..bf7a81d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -890,50 +890,6 @@ exit:
 	return res;
 }
 
-u8 rtw_setassocsta_cmd(struct adapter  *padapter, u8 *mac_addr)
-{
-	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
-	struct cmd_obj *ph2c;
-	struct set_assocsta_parm *psetassocsta_para;
-	struct set_stakey_rsp *psetassocsta_rsp = NULL;
-
-	u8	res = _SUCCESS;
-
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	psetassocsta_para = kzalloc(sizeof(struct set_assocsta_parm), GFP_KERNEL);
-	if (psetassocsta_para == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	psetassocsta_rsp = kzalloc(sizeof(struct set_assocsta_rsp), GFP_KERNEL);
-	if (psetassocsta_rsp == NULL) {
-		kfree(ph2c);
-		kfree(psetassocsta_para);
-		return _FAIL;
-	}
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, psetassocsta_para, _SetAssocSta_CMD_);
-	ph2c->rsp = (u8 *)psetassocsta_rsp;
-	ph2c->rspsz = sizeof(struct set_assocsta_rsp);
-
-	ether_addr_copy(psetassocsta_para->addr, mac_addr);
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-
-exit:
-
-
-	return res;
-}
-
 u8 rtw_addbareq_cmd(struct adapter *padapter, u8 tid, u8 *addr)
 {
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index fa9d5f7..278208df 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -718,7 +718,6 @@ Result:
 #define H2C_CMD_OVERFLOW	0x06
 #define H2C_RESERVED		0x07
 
-u8 rtw_setassocsta_cmd(struct adapter *padapter, u8 *mac_addr);
 u8 rtw_setstandby_cmd(struct adapter *padapter, uint action);
 u8 rtw_sitesurvey_cmd(struct adapter *padapter, struct ndis_802_11_ssid *ssid,
 		      int ssid_num, struct rtw_ieee80211_channel *ch,
-- 
1.7.10.4

