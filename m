Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaGGSmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:42:17 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54757 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaGGSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:42:14 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/13] staging: rtl8188eu: use jiffies_to_msecs() instead of rtw_systime_to_ms()
Date: Tue,  8 Jul 2014 00:10:09 +0530
Message-Id: <1404758413-12859-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index a52dcd5..3ddaa34 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -154,7 +154,6 @@ u32  _rtw_down_sema(struct semaphore *sema);
 
 void _rtw_init_queue(struct __queue *pqueue);
 
-u32  rtw_systime_to_ms(u32 systime);
 u32  rtw_ms_to_systime(u32 ms);
 s32  rtw_get_passing_time_ms(u32 start);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 93c76d7..96f8eb8 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -77,11 +77,6 @@ void	_rtw_init_queue(struct __queue *pqueue)
 	spin_lock_init(&(pqueue->lock));
 }
 
-inline u32 rtw_systime_to_ms(u32 systime)
-{
-	return systime * 1000 / HZ;
-}
-
 inline u32 rtw_ms_to_systime(u32 ms)
 {
 	return ms * HZ / 1000;
@@ -90,7 +85,7 @@ inline u32 rtw_ms_to_systime(u32 ms)
 /*  the input parameter start must be in jiffies */
 inline s32 rtw_get_passing_time_ms(u32 start)
 {
-	return rtw_systime_to_ms(jiffies-start);
+	return jiffies_to_msecs(jiffies-start);
 }
 
 struct net_device *rtw_alloc_etherdev_with_old_priv(int sizeof_priv,
-- 
1.7.10.4

