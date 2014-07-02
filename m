Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbaGBQvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:51:18 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45891 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147AbaGBQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:51:14 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 17/48] staging: rtl8188eu: Remove unused function rtw_set_csa_cmd()
Date: Wed,  2 Jul 2014 22:17:13 +0530
Message-Id: <1404319664-8327-17-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   35 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 36 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 3762fa6..7141ab4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -1059,41 +1059,6 @@ exit:
 	return res;
 }
 
-u8 rtw_set_csa_cmd(struct adapter *padapter, u8 new_ch_no)
-{
-	struct	cmd_obj *pcmdobj;
-	struct	SetChannelSwitch_param *setChannelSwitch_param;
-	struct	cmd_priv   *pcmdpriv = &padapter->cmdpriv;
-
-	u8	res = _SUCCESS;
-
-
-	RT_TRACE(_module_rtl871x_cmd_c_, _drv_notice_, ("+rtw_set_csa_cmd\n"));
-
-	pcmdobj = kzalloc(sizeof(struct	cmd_obj), GFP_KERNEL);
-	if (pcmdobj == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	setChannelSwitch_param = kzalloc(sizeof(struct	SetChannelSwitch_param), GFP_KERNEL);
-	if (setChannelSwitch_param == NULL) {
-		kfree(pcmdobj);
-		res = _FAIL;
-		goto exit;
-	}
-
-	setChannelSwitch_param->new_ch_no = new_ch_no;
-
-	init_h2fwcmd_w_parm_no_rsp(pcmdobj, setChannelSwitch_param, GEN_CMD_CODE(_SetChannelSwitch));
-	res = rtw_enqueue_cmd(pcmdpriv, pcmdobj);
-
-exit:
-
-
-	return res;
-}
-
 u8 rtw_tdls_cmd(struct adapter *padapter, u8 *addr, u8 option)
 {
 	return _SUCCESS;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 6ed4a90..108cf30 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -756,7 +756,6 @@ u8 rtw_chk_hi_queue_cmd(struct adapter *padapter);
 #endif
 
 u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue);
-u8 rtw_set_csa_cmd(struct adapter *padapter, u8 new_ch_no);
 u8 rtw_tdls_cmd(struct adapter *padapter, u8 *addr, u8 option);
 
 u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf);
-- 
1.7.10.4

