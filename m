Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaFVIxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:53:09 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58868 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaFVIxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:53:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 40/42] staging: rtl8188eu: Remove function thread_enter()
Date: Sun, 22 Jun 2014 14:21:44 +0530
Message-Id: <1403427107-12744-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |    3 +--
 drivers/staging/rtl8188eu/core/rtw_mp.c           |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    5 -----
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 343a6ca..e65d8ef 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -285,8 +285,7 @@ int rtw_cmd_thread(void *context)
 	struct adapter *padapter = (struct adapter *)context;
 	struct cmd_priv *pcmdpriv = &(padapter->cmdpriv);
 
-
-	thread_enter("RTW_CMD_THREAD");
+	allow_signal(SIGTERM);
 
 	pcmdbuf = pcmdpriv->cmd_buf;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index ca323db..919c4c2 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -597,7 +597,7 @@ static int mp_xmit_packet_thread(void *context)
 	padapter = pmp_priv->papdater;
 	pxmitpriv = &(padapter->xmitpriv);
 
-	thread_enter("RTW_MP_THREAD");
+	allow_signal(SIGTERM);
 
 	/* DBG_88E("%s:pkTx Start\n", __func__); */
 	while (1) {
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 6c3234b..e7bbc28 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -164,11 +164,6 @@ u32  rtw_systime_to_ms(u32 systime);
 u32  rtw_ms_to_systime(u32 ms);
 s32  rtw_get_passing_time_ms(u32 start);
 
-static inline void thread_enter(char *name)
-{
-	allow_signal(SIGTERM);
-}
-
 static inline void flush_signals_thread(void)
 {
 	if (signal_pending(current))
-- 
1.7.10.4

