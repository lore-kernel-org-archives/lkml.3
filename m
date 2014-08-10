Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaHJOrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:47:00 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46136 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaHJOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:46:58 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/22] staging: rtl8188eu: Remove unused function rtw_IOL_cmd_boundary_handle()
Date: Sun, 10 Aug 2014 20:14:25 +0530
Message-Id: <1407681875-2611-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_iol.c    |   13 -------------
 drivers/staging/rtl8188eu/include/rtw_iol.h |    1 -
 2 files changed, 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_iol.c b/drivers/staging/rtl8188eu/core/rtw_iol.c
index 5401f7a..cd2960c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_iol.c
+++ b/drivers/staging/rtl8188eu/core/rtw_iol.c
@@ -128,19 +128,6 @@ int rtw_IOL_append_END_cmd(struct xmit_frame *xmit_frame)
 	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, 4);
 }
 
-u8 rtw_IOL_cmd_boundary_handle(struct xmit_frame *pxmit_frame)
-{
-	u8 is_cmd_bndy = false;
-	if (((pxmit_frame->attrib.pktlen+32)%256) + 8 >= 256) {
-		rtw_IOL_append_END_cmd(pxmit_frame);
-		pxmit_frame->attrib.pktlen = ((((pxmit_frame->attrib.pktlen+32)/256)+1)*256);
-
-		pxmit_frame->attrib.last_txcmdsz = pxmit_frame->attrib.pktlen;
-		is_cmd_bndy = true;
-	}
-	return is_cmd_bndy;
-}
-
 void rtw_IOL_cmd_buf_dump(struct adapter  *Adapter, int buf_len, u8 *pbuf)
 {
 	int i;
diff --git a/drivers/staging/rtl8188eu/include/rtw_iol.h b/drivers/staging/rtl8188eu/include/rtw_iol.h
index bac4d7f..f8b05e3 100644
--- a/drivers/staging/rtl8188eu/include/rtw_iol.h
+++ b/drivers/staging/rtl8188eu/include/rtw_iol.h
@@ -75,7 +75,6 @@ int _rtw_IOL_append_WRF_cmd(struct xmit_frame *xmit_frame, u8 rf_path,
 #define rtw_IOL_append_WRF_cmd(xmit_frame, rf_path, addr, value, mask)	\
 	_rtw_IOL_append_WRF_cmd((xmit_frame), (rf_path), (addr), (value), (mask))
 
-u8 rtw_IOL_cmd_boundary_handle(struct xmit_frame *pxmit_frame);
 void  rtw_IOL_cmd_buf_dump(struct adapter  *Adapter, int buf_len, u8 *pbuf);
 
 #endif /* __RTW_IOL_H_ */
-- 
1.7.10.4

