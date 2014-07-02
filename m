Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbaGBQx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:53:29 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:65263 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbaGBQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:53:25 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 32/48] staging: rtl8188eu: Rename _rtw_dequeue_cmd() to rtw_dequeue_cmd()
Date: Wed,  2 Jul 2014 22:17:28 +0530
Message-Id: <1404319664-8327-32-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   16 +++-------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    2 +-
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 81f4b94..1e6e52e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -110,7 +110,7 @@ exit:
 	return _SUCCESS;
 }
 
-struct	cmd_obj	*_rtw_dequeue_cmd(struct __queue *queue)
+struct	cmd_obj	* rtw_dequeue_cmd(struct __queue *queue)
 {
 	unsigned long irqL;
 	struct cmd_obj *obj;
@@ -181,16 +181,6 @@ exit:
 	return res;
 }
 
-struct cmd_obj	*rtw_dequeue_cmd(struct cmd_priv *pcmdpriv)
-{
-	struct cmd_obj *cmd_obj;
-
-
-	cmd_obj = _rtw_dequeue_cmd(&pcmdpriv->cmd_queue);
-
-	return cmd_obj;
-}
-
 void rtw_free_cmd_obj(struct cmd_obj *pcmd)
 {
 
@@ -248,7 +238,7 @@ _next:
 			break;
 		}
 
-		pcmd = rtw_dequeue_cmd(pcmdpriv);
+		pcmd = rtw_dequeue_cmd(&pcmdpriv->cmd_queue);
 		if (!pcmd)
 			continue;
 
@@ -304,7 +294,7 @@ post_process:
 
 	/*  free all cmd_obj resources */
 	do {
-		pcmd = rtw_dequeue_cmd(pcmdpriv);
+		pcmd = rtw_dequeue_cmd(&pcmdpriv->cmd_queue);
 		if (pcmd == NULL)
 			break;
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index cc75c7d..b3529da 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -70,7 +70,7 @@ do {\
 } while (0)
 
 u32 rtw_enqueue_cmd(struct cmd_priv *pcmdpriv, struct cmd_obj *obj);
-struct cmd_obj *rtw_dequeue_cmd(struct cmd_priv *pcmdpriv);
+struct cmd_obj *rtw_dequeue_cmd(struct __queue *queue);
 void rtw_free_cmd_obj(struct cmd_obj *pcmd);
 
 int rtw_cmd_thread(void *context);
-- 
1.7.10.4

