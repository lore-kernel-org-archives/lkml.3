Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbaGBQvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:51:09 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45296 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbaGBQvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:51:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/48] staging: rtl8188eu: Remove unused function rtw_set_ch_cmd()
Date: Wed,  2 Jul 2014 22:17:12 +0530
Message-Id: <1404319664-8327-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   53 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    2 -
 2 files changed, 55 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 51f624d..3762fa6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -1005,59 +1005,6 @@ exit:
 	return res;
 }
 
-u8 rtw_set_ch_cmd(struct adapter *padapter, u8 ch, u8 bw, u8 ch_offset, u8 enqueue)
-{
-	struct cmd_obj *pcmdobj;
-	struct set_ch_parm *set_ch_parm;
-	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
-
-	u8 res = _SUCCESS;
-
-
-	DBG_88E(FUNC_NDEV_FMT" ch:%u, bw:%u, ch_offset:%u\n",
-		FUNC_NDEV_ARG(padapter->pnetdev), ch, bw, ch_offset);
-
-	/* check input parameter */
-
-	/* prepare cmd parameter */
-	set_ch_parm = kzalloc(sizeof(*set_ch_parm), GFP_KERNEL);
-	if (set_ch_parm == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-	set_ch_parm->ch = ch;
-	set_ch_parm->bw = bw;
-	set_ch_parm->ch_offset = ch_offset;
-
-	if (enqueue) {
-		/* need enqueue, prepare cmd_obj and enqueue */
-		pcmdobj = kzalloc(sizeof(struct	cmd_obj), GFP_KERNEL);
-		if (pcmdobj == NULL) {
-			kfree(set_ch_parm);
-			res = _FAIL;
-			goto exit;
-		}
-
-		init_h2fwcmd_w_parm_no_rsp(pcmdobj, set_ch_parm, GEN_CMD_CODE(_SetChannel));
-		res = rtw_enqueue_cmd(pcmdpriv, pcmdobj);
-	} else {
-		/* no need to enqueue, do the cmd hdl directly and free cmd parameter */
-		if (H2C_SUCCESS != set_ch_hdl(padapter, (u8 *)set_ch_parm))
-			res = _FAIL;
-
-		kfree(set_ch_parm);
-	}
-
-	/* do something based on res... */
-
-exit:
-
-	DBG_88E(FUNC_NDEV_FMT" res:%u\n", FUNC_NDEV_ARG(padapter->pnetdev), res);
-
-
-	return res;
-}
-
 u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue)
 {
 	struct	cmd_obj *pcmdobj;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index af18c75..6ed4a90 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -755,8 +755,6 @@ u8 rtw_ps_cmd(struct adapter *padapter);
 u8 rtw_chk_hi_queue_cmd(struct adapter *padapter);
 #endif
 
-u8 rtw_set_ch_cmd(struct adapter *padapter, u8 ch, u8 bw, u8 ch_offset,
-		  u8 enqueue);
 u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue);
 u8 rtw_set_csa_cmd(struct adapter *padapter, u8 new_ch_no);
 u8 rtw_tdls_cmd(struct adapter *padapter, u8 *addr, u8 option);
-- 
1.7.10.4

