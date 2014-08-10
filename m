Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaHJOrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:47:49 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42944 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaHJOrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:47 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 17/22] staging: rtl8188eu: Remove unused function rtw_IOL_cmd_buf_dump()
Date: Sun, 10 Aug 2014 20:14:30 +0530
Message-Id: <1407681875-2611-17-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_iol.c    |   17 -----------------
 drivers/staging/rtl8188eu/include/rtw_iol.h |    2 --
 2 files changed, 19 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_iol.c b/drivers/staging/rtl8188eu/core/rtw_iol.c
index 5004b8f..7281bb6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_iol.c
+++ b/drivers/staging/rtl8188eu/core/rtw_iol.c
@@ -92,20 +92,3 @@ int rtw_IOL_append_END_cmd(struct xmit_frame *xmit_frame)
 
 	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, 4);
 }
-
-void rtw_IOL_cmd_buf_dump(struct adapter  *Adapter, int buf_len, u8 *pbuf)
-{
-	int i;
-	int j = 1;
-
-	pr_info("###### %s ######\n", __func__);
-	for (i = 0; i < buf_len; i++) {
-		printk("%02x-", *(pbuf+i));
-
-		if (j%32 == 0)
-			printk("\n");
-		j++;
-	}
-	printk("\n");
-	pr_info("=============ioreg_cmd len=%d===============\n", buf_len);
-}
diff --git a/drivers/staging/rtl8188eu/include/rtw_iol.h b/drivers/staging/rtl8188eu/include/rtw_iol.h
index 8c298ab..193f2eb 100644
--- a/drivers/staging/rtl8188eu/include/rtw_iol.h
+++ b/drivers/staging/rtl8188eu/include/rtw_iol.h
@@ -66,6 +66,4 @@ int _rtw_IOL_append_WRF_cmd(struct xmit_frame *xmit_frame, u8 rf_path,
 #define rtw_IOL_append_WRF_cmd(xmit_frame, rf_path, addr, value, mask)	\
 	_rtw_IOL_append_WRF_cmd((xmit_frame), (rf_path), (addr), (value), (mask))
 
-void  rtw_IOL_cmd_buf_dump(struct adapter  *Adapter, int buf_len, u8 *pbuf);
-
 #endif /* __RTW_IOL_H_ */
-- 
1.7.10.4

