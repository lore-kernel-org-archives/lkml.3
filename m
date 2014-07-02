Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbaGBQuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:50:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40244 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaGBQuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:50:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/48] staging: rtl8188eu: Remove unused function rtw_c2h_wk_cmd()
Date: Wed,  2 Jul 2014 22:17:05 +0530
Message-Id: <1404319664-8327-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   33 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    2 --
 2 files changed, 35 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 294c9e2..ec0990f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -1741,39 +1741,6 @@ exit:
 }
 #endif
 
-u8 rtw_c2h_wk_cmd(struct adapter *padapter, u8 *c2h_evt)
-{
-	struct cmd_obj *ph2c;
-	struct drvextra_cmd_parm *pdrvextra_cmd_parm;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
-	if (pdrvextra_cmd_parm == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	pdrvextra_cmd_parm->ec_id = C2H_WK_CID;
-	pdrvextra_cmd_parm->type_size = c2h_evt ? 16 : 0;
-	pdrvextra_cmd_parm->pbuf = c2h_evt;
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, pdrvextra_cmd_parm, GEN_CMD_CODE(_Set_Drv_Extra));
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-
-exit:
-
-	return res;
-}
-
 u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf)
 {
 	struct drvextra_cmd_parm *pdrvextra_cmd;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index bb1f8f0..ca17145 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -776,8 +776,6 @@ u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue);
 u8 rtw_set_csa_cmd(struct adapter *padapter, u8 new_ch_no);
 u8 rtw_tdls_cmd(struct adapter *padapter, u8 *addr, u8 option);
 
-u8 rtw_c2h_wk_cmd(struct adapter *padapter, u8 *c2h_evt);
-
 u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf);
 
 void rtw_survey_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd);
-- 
1.7.10.4

