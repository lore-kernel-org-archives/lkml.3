Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbaGBQx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:53:56 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38953 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbaGBQxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:53:54 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 36/48] staging: rtl8188eu: Remove unused members rsp_[allocated,]_buf from struct cmd_priv
Date: Wed,  2 Jul 2014 22:17:32 +0530
Message-Id: <1404319664-8327-36-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   10 ----------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    2 --
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 4c1abdd..199bbae 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -55,15 +55,6 @@ int rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 
 	pcmdpriv->cmd_buf = pcmdpriv->cmd_allocated_buf  +  CMDBUFF_ALIGN_SZ - ((size_t)(pcmdpriv->cmd_allocated_buf) & (CMDBUFF_ALIGN_SZ-1));
 
-	pcmdpriv->rsp_allocated_buf = kzalloc(MAX_RSPSZ + 4, GFP_KERNEL);
-
-	if (pcmdpriv->rsp_allocated_buf == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	pcmdpriv->rsp_buf = pcmdpriv->rsp_allocated_buf  +  4 - ((size_t)(pcmdpriv->rsp_allocated_buf) & 3);
-
 exit:
 	return res;
 }
@@ -73,7 +64,6 @@ void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv)
 
 	if (pcmdpriv) {
 		kfree(pcmdpriv->cmd_allocated_buf);
-		kfree(pcmdpriv->rsp_allocated_buf);
 	}
 }
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index ca69511..d881710 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -50,8 +50,6 @@ struct cmd_priv {
 	u8	cmd_seq;
 	u8	*cmd_buf;	/* shall be non-paged, and 4 bytes aligned */
 	u8	*cmd_allocated_buf;
-	u8	*rsp_buf;	/* shall be non-paged, and 4 bytes aligned */
-	u8	*rsp_allocated_buf;
 	u8 cmdthd_running;
 	struct adapter *padapter;
 };
-- 
1.7.10.4

