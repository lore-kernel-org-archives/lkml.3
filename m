Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbaGBQxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:53:12 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61119 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbaGBQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:53:03 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 29/48] staging: rtl8188eu: Remove wrapper function power_saving_wk_hdl()
Date: Wed,  2 Jul 2014 22:17:25 +0530
Message-Id: <1404319664-8327-29-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 5a1ee87..b9c61e3 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -1191,11 +1191,6 @@ exit:
 	return res;
 }
 
-static void power_saving_wk_hdl(struct adapter *padapter, u8 *pbuf, int sz)
-{
-	 rtw_ps_processor(padapter);
-}
-
 u8 rtw_ps_cmd(struct adapter *padapter)
 {
 	struct cmd_obj		*ppscmd;
@@ -1317,7 +1312,7 @@ u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf)
 		dynamic_chk_wk_hdl(padapter, pdrvextra_cmd->pbuf, pdrvextra_cmd->type_size);
 		break;
 	case POWER_SAVING_CTRL_WK_CID:
-		power_saving_wk_hdl(padapter, pdrvextra_cmd->pbuf, pdrvextra_cmd->type_size);
+		rtw_ps_processor(padapter);
 		break;
 	case LPS_CTRL_WK_CID:
 		lps_ctrl_wk_hdl(padapter, (u8)pdrvextra_cmd->type_size);
-- 
1.7.10.4

