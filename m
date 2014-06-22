Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaFVIXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:23:44 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:56886 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaFVIXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:23:41 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/42] staging: rtl8188eu: Remove unused function rtw_sleep_schedulable()
Date: Sun, 22 Jun 2014 13:49:35 +0530
Message-Id: <1403425202-11942-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |   12 ------------
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 23b75fc..7a0afab 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -211,7 +211,6 @@ u32  rtw_ms_to_systime(u32 ms);
 s32  rtw_get_passing_time_ms(u32 start);
 s32  rtw_get_time_interval_ms(u32 start, u32 end);
 
-void rtw_sleep_schedulable(int ms);
 
 u32  rtw_atoi(u8 *s);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 1ef9c49..f43ace2 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -129,18 +129,6 @@ inline s32 rtw_get_time_interval_ms(u32 start, u32 end)
 	return rtw_systime_to_ms(end-start);
 }
 
-void rtw_sleep_schedulable(int ms)
-{
-	u32 delta;
-
-	delta = (ms * HZ)/1000;/* ms) */
-	if (delta == 0)
-		delta = 1;/*  1 ms */
-	set_current_state(TASK_INTERRUPTIBLE);
-	if (schedule_timeout(delta) != 0)
-		return;
-}
-
 #define RTW_SUSPEND_LOCK_NAME "rtw_wifi"
 
 struct net_device *rtw_alloc_etherdev_with_old_priv(int sizeof_priv,
-- 
1.7.10.4

