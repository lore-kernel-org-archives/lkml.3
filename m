Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaHJOrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:47:31 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46819 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHJOr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:27 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/22] staging: rtl8188eu: Remove unused functions rtw_IOL_append_DELAY_[US,MS]_cmd()
Date: Sun, 10 Aug 2014 20:14:28 +0530
Message-Id: <1407681875-2611-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_iol.c    |   16 ----------------
 drivers/staging/rtl8188eu/include/rtw_iol.h |    2 --
 2 files changed, 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_iol.c b/drivers/staging/rtl8188eu/core/rtw_iol.c
index 4527aaa..5004b8f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_iol.c
+++ b/drivers/staging/rtl8188eu/core/rtw_iol.c
@@ -86,22 +86,6 @@ int _rtw_IOL_append_WRF_cmd(struct xmit_frame *xmit_frame, u8 rf_path, u16 addr,
 	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, cmd.length);
 }
 
-int rtw_IOL_append_DELAY_US_cmd(struct xmit_frame *xmit_frame, u16 us)
-{
-	struct ioreg_cfg cmd = {4, IOREG_CMD_DELAY_US, 0x0, 0x0, 0x0};
-	cmd.address = cpu_to_le16(us);
-
-	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, 4);
-}
-
-int rtw_IOL_append_DELAY_MS_cmd(struct xmit_frame *xmit_frame, u16 ms)
-{
-	struct ioreg_cfg cmd = {4, IOREG_CMD_DELAY_US, 0x0, 0x0, 0x0};
-
-	cmd.address = cpu_to_le16(ms);
-	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, 4);
-}
-
 int rtw_IOL_append_END_cmd(struct xmit_frame *xmit_frame)
 {
 	struct ioreg_cfg cmd = {4, IOREG_CMD_END, cpu_to_le16(0xFFFF), cpu_to_le32(0xFF), 0x0};
diff --git a/drivers/staging/rtl8188eu/include/rtw_iol.h b/drivers/staging/rtl8188eu/include/rtw_iol.h
index fc5b916..8c298ab 100644
--- a/drivers/staging/rtl8188eu/include/rtw_iol.h
+++ b/drivers/staging/rtl8188eu/include/rtw_iol.h
@@ -50,8 +50,6 @@ int rtw_IOL_append_cmds(struct xmit_frame *xmit_frame, u8 *IOL_cmds,
 			u32 cmd_len);
 int rtw_IOL_append_LLT_cmd(struct xmit_frame *xmit_frame, u8 page_boundary);
 bool rtw_IOL_applied(struct adapter  *adapter);
-int rtw_IOL_append_DELAY_US_cmd(struct xmit_frame *xmit_frame, u16 us);
-int rtw_IOL_append_DELAY_MS_cmd(struct xmit_frame *xmit_frame, u16 ms);
 int rtw_IOL_append_END_cmd(struct xmit_frame *xmit_frame);
 
 void read_efuse_from_txpktbuf(struct adapter *adapter, int bcnhead,
-- 
1.7.10.4

