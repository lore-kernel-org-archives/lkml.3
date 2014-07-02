Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbaGBQxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:53:42 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48031 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbaGBQxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:53:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 34/48] staging: rtl8188eu: Remove unused member cmd_issued_cnt from struct cmd_priv
Date: Wed,  2 Jul 2014 22:17:30 +0530
Message-Id: <1404319664-8327-34-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |    3 ---
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index ef5f507..4696713 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -64,7 +64,6 @@ int rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 
 	pcmdpriv->rsp_buf = pcmdpriv->rsp_allocated_buf  +  4 - ((size_t)(pcmdpriv->rsp_allocated_buf) & 3);
 
-	pcmdpriv->cmd_issued_cnt = 0;
 	pcmdpriv->cmd_done_cnt = 0;
 exit:
 	return res;
@@ -246,8 +245,6 @@ _next:
 			goto post_process;
 		}
 
-		pcmdpriv->cmd_issued_cnt++;
-
 		pcmd->cmdsz = round_up(pcmd->cmdsz, 4);
 
 		memcpy(pcmdbuf, pcmd->parmbuf, pcmd->cmdsz);
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 60f953b..b4ee2c8 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -52,7 +52,6 @@ struct cmd_priv {
 	u8	*cmd_allocated_buf;
 	u8	*rsp_buf;	/* shall be non-paged, and 4 bytes aligned */
 	u8	*rsp_allocated_buf;
-	u32	cmd_issued_cnt;
 	u32	cmd_done_cnt;
 	u8 cmdthd_running;
 	struct adapter *padapter;
-- 
1.7.10.4

