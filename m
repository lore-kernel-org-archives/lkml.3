Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaHJOrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:47:12 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43959 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaHJOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:10 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/22] staging: rtl8188eu: Remove unused function rtw_IOL_append_WD_cmd()
Date: Sun, 10 Aug 2014 20:14:26 +0530
Message-Id: <1407681875-2611-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_iol.c    |   14 --------------
 drivers/staging/rtl8188eu/include/rtw_iol.h |    4 ----
 2 files changed, 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_iol.c b/drivers/staging/rtl8188eu/core/rtw_iol.c
index cd2960c..ebc228d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_iol.c
+++ b/drivers/staging/rtl8188eu/core/rtw_iol.c
@@ -77,20 +77,6 @@ int _rtw_IOL_append_WB_cmd(struct xmit_frame *xmit_frame, u16 addr, u8 value, u8
 	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, cmd.length);
 }
 
-int _rtw_IOL_append_WD_cmd(struct xmit_frame *xmit_frame, u16 addr, u32 value, u32 mask)
-{
-	struct ioreg_cfg cmd = {8, IOREG_CMD_WD_REG, 0x0, 0x0, 0x0};
-
-	cmd.address = cpu_to_le16(addr);
-	cmd.data = cpu_to_le32(value);
-
-	if (mask != 0xFFFFFFFF) {
-		cmd.length = 12;
-		cmd.mask =  cpu_to_le32(mask);
-	}
-	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, cmd.length);
-}
-
 int _rtw_IOL_append_WRF_cmd(struct xmit_frame *xmit_frame, u8 rf_path, u16 addr, u32 value, u32 mask)
 {
 	struct ioreg_cfg cmd = {8, IOREG_CMD_W_RF, 0x0, 0x0, 0x0};
diff --git a/drivers/staging/rtl8188eu/include/rtw_iol.h b/drivers/staging/rtl8188eu/include/rtw_iol.h
index f8b05e3..f53bceb 100644
--- a/drivers/staging/rtl8188eu/include/rtw_iol.h
+++ b/drivers/staging/rtl8188eu/include/rtw_iol.h
@@ -62,16 +62,12 @@ void read_efuse_from_txpktbuf(struct adapter *adapter, int bcnhead,
 
 int _rtw_IOL_append_WB_cmd(struct xmit_frame *xmit_frame, u16 addr,
 			   u8 value, u8 mask);
-int _rtw_IOL_append_WD_cmd(struct xmit_frame *xmit_frame, u16 addr,
-			   u32 value, u32 mask);
 int _rtw_IOL_append_WRF_cmd(struct xmit_frame *xmit_frame, u8 rf_path,
 			    u16 addr, u32 value, u32 mask);
 #define rtw_IOL_append_WB_cmd(xmit_frame, addr, value, mask)		\
 	_rtw_IOL_append_WB_cmd((xmit_frame), (addr), (value) , (mask))
 #define rtw_IOL_append_WW_cmd(xmit_frame, addr, value, mask)		\
 	_rtw_IOL_append_WW_cmd((xmit_frame), (addr), (value), (mask))
-#define rtw_IOL_append_WD_cmd(xmit_frame, addr, value, mask)		\
-	_rtw_IOL_append_WD_cmd((xmit_frame), (addr), (value), (mask))
 #define rtw_IOL_append_WRF_cmd(xmit_frame, rf_path, addr, value, mask)	\
 	_rtw_IOL_append_WRF_cmd((xmit_frame), (rf_path), (addr), (value), (mask))
 
-- 
1.7.10.4

