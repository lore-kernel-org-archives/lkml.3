Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaFVIxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:53:25 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57440 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaFVIxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:53:20 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 41/42] staging: rtl8188eu: Remove function flush_signals_thread()
Date: Sun, 22 Jun 2014 14:21:45 +0530
Message-Id: <1403427107-12744-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |    3 ++-
 drivers/staging/rtl8188eu/core/rtw_mp.c           |    3 ++-
 drivers/staging/rtl8188eu/include/osdep_service.h |    6 ------
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index e65d8ef..556d17d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -359,7 +359,8 @@ post_process:
 			rtw_free_cmd_obj(pcmd);
 		}
 
-		flush_signals_thread();
+		if (signal_pending(current))
+			flush_signals(current);
 
 		goto _next;
 	}
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index 919c4c2..d879948 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -629,7 +629,8 @@ static int mp_xmit_packet_thread(void *context)
 		    (pmptx->count == pmptx->sended))
 			goto exit;
 
-		flush_signals_thread();
+		if (signal_pending(current))
+			flush_signals(current);
 	}
 
 exit:
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index e7bbc28..2d07dea 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -164,12 +164,6 @@ u32  rtw_systime_to_ms(u32 systime);
 u32  rtw_ms_to_systime(u32 ms);
 s32  rtw_get_passing_time_ms(u32 start);
 
-static inline void flush_signals_thread(void)
-{
-	if (signal_pending(current))
-		flush_signals(current);
-}
-
 struct rtw_netdev_priv_indicator {
 	void *priv;
 	u32 sizeof_priv;
-- 
1.7.10.4

