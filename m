Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbaGBQu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:50:58 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:32916 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029AbaGBQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:50:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/48] staging: rtl8188eu: Remove unused function rtw_setrttbl_cmd()
Date: Wed,  2 Jul 2014 22:17:11 +0530
Message-Id: <1404319664-8327-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   29 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    9 ---------
 2 files changed, 38 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index c62db33..51f624d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -890,35 +890,6 @@ exit:
 	return res;
 }
 
-u8 rtw_setrttbl_cmd(struct adapter  *padapter, struct setratable_parm *prate_table)
-{
-	struct cmd_obj *ph2c;
-	struct setratable_parm *psetrttblparm;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-	psetrttblparm = kzalloc(sizeof(struct setratable_parm), GFP_KERNEL);
-
-	if (psetrttblparm == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, psetrttblparm, GEN_CMD_CODE(_SetRaTable));
-
-	memcpy(psetrttblparm, prate_table, sizeof(struct setratable_parm));
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-exit:
-	return res;
-}
-
 u8 rtw_setassocsta_cmd(struct adapter  *padapter, u8 *mac_addr)
 {
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 432fbd2..af18c75 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -590,13 +590,6 @@ struct	getcountjudge_rsp {
 	u8	count_judge[MAX_RATES_LENGTH];
 };
 
-struct setratable_parm {
-	u8 ss_ForceUp[NumRates];
-	u8 ss_ULevel[NumRates];
-	u8 ss_DLevel[NumRates];
-	u8 count_judge[NumRates];
-};
-
 struct getratable_parm {
 	uint rsvd;
 };
@@ -743,8 +736,6 @@ u8 rtw_setopmode_cmd(struct adapter *padapter,
 		     enum ndis_802_11_network_infra networktype);
 u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset);
 u8 rtw_setrfintfs_cmd(struct adapter *padapter, u8 mode);
-u8 rtw_setrttbl_cmd(struct adapter *padapter,
-		    struct setratable_parm *prate_table);
 
 u8 rtw_gettssi_cmd(struct adapter *padapter, u8 offset, u8 *pval);
 u8 rtw_setfwdig_cmd(struct adapter *padapter, u8 type);
-- 
1.7.10.4

