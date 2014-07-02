Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbaGBQ6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:58:53 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54149 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaGBQxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:53:10 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 30/48] staging: rtl8188eu: Rename _rtw_init_cmd_priv() to rtw_init_cmd_priv()
Date: Wed,  2 Jul 2014 22:17:26 +0530
Message-Id: <1404319664-8327-30-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |    9 +--------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    2 +-
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index b9c61e3..e26a582 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -30,7 +30,7 @@ Caller and the rtw_cmd_thread can protect cmd_q by spin_lock.
 No irqsave is necessary.
 */
 
-int _rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
+int rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 {
 	int res = _SUCCESS;
 
@@ -130,13 +130,6 @@ struct	cmd_obj	*_rtw_dequeue_cmd(struct __queue *queue)
 	return obj;
 }
 
-u32 rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
-{
-	u32	res;
-	res = _rtw_init_cmd_priv(pcmdpriv);
-	return res;
-}
-
 void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv)
 {
 	RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_, ("rtw_free_cmd_priv\n"));
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index d6b8724..cc75c7d 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -75,7 +75,7 @@ void rtw_free_cmd_obj(struct cmd_obj *pcmd);
 
 int rtw_cmd_thread(void *context);
 
-u32 rtw_init_cmd_priv(struct cmd_priv *pcmdpriv);
+int rtw_init_cmd_priv(struct cmd_priv *pcmdpriv);
 void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv);
 
 enum rtw_drvextra_cmd_id {
-- 
1.7.10.4

