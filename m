Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbaGBQtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:49:07 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33792 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300AbaGBQtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:49:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/48] staging: rtl8188eu: Remove function c2h_evt_hdl()
Date: Wed,  2 Jul 2014 22:16:58 +0530
Message-Id: <1404319664-8327-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c2h_evt_hdl() calls a dummy function rtw_hal_c2h_handler() to handle events,
so no use of keeping it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 293fda4..a2b355c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -1808,31 +1808,6 @@ exit:
 	return res;
 }
 
-static s32 c2h_evt_hdl(struct adapter *adapter, struct c2h_evt_hdr *c2h_evt, c2h_id_filter filter)
-{
-	s32 ret = _FAIL;
-	u8 buf[16];
-
-	if (!c2h_evt) {
-		/* No c2h event in cmd_obj, read c2h event before handling*/
-		if (c2h_evt_read(adapter, buf) == _SUCCESS) {
-			c2h_evt = (struct c2h_evt_hdr *)buf;
-
-			if (filter && filter(c2h_evt->id) == false)
-				goto exit;
-
-			ret = rtw_hal_c2h_handler(adapter, c2h_evt);
-		}
-	} else {
-		if (filter && filter(c2h_evt->id) == false)
-			goto exit;
-
-		ret = rtw_hal_c2h_handler(adapter, c2h_evt);
-	}
-exit:
-	return ret;
-}
-
 u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf)
 {
 	struct drvextra_cmd_parm *pdrvextra_cmd;
@@ -1863,9 +1838,6 @@ u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf)
 		rtw_chk_hi_queue_hdl(padapter);
 		break;
 #endif /* CONFIG_88EU_AP_MODE */
-	case C2H_WK_CID:
-		c2h_evt_hdl(padapter, (struct c2h_evt_hdr *)pdrvextra_cmd->pbuf, NULL);
-		break;
 	default:
 		break;
 	}
-- 
1.7.10.4

