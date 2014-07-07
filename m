Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaGGSm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:42:27 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39794 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaGGSmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:42:24 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/13] staging: rtl8188eu: Use msecs_to_jiffies() instead of rtw_ms_to_systime()
Date: Tue,  8 Jul 2014 00:10:10 +0530
Message-Id: <1404758413-12859-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c      |   10 +++++-----
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    5 -----
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
index 439bc8f..27ed83c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
@@ -551,7 +551,7 @@ void rtw_init_pwrctrl_priv(struct adapter *padapter)
 inline void rtw_set_ips_deny(struct adapter *padapter, u32 ms)
 {
 	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
-	pwrpriv->ips_deny_time = jiffies + rtw_ms_to_systime(ms);
+	pwrpriv->ips_deny_time = jiffies + msecs_to_jiffies(ms);
 }
 
 /*
@@ -568,9 +568,9 @@ int _rtw_pwr_wakeup(struct adapter *padapter, u32 ips_deffer_ms, const char *cal
 	unsigned long expires;
 	int ret = _SUCCESS;
 
-	expires = jiffies + rtw_ms_to_systime(ips_deffer_ms);
+	expires = jiffies + msecs_to_jiffies(ips_deffer_ms);
 	if (time_before(pwrpriv->ips_deny_time, expires))
-		pwrpriv->ips_deny_time = jiffies + rtw_ms_to_systime(ips_deffer_ms);
+		pwrpriv->ips_deny_time = jiffies + msecs_to_jiffies(ips_deffer_ms);
 
 {
 	u32 start = jiffies;
@@ -624,9 +624,9 @@ int _rtw_pwr_wakeup(struct adapter *padapter, u32 ips_deffer_ms, const char *cal
 	}
 
 exit:
-	expires = jiffies + rtw_ms_to_systime(ips_deffer_ms);
+	expires = jiffies + msecs_to_jiffies(ips_deffer_ms);
 	if (time_before(pwrpriv->ips_deny_time, expires))
-		pwrpriv->ips_deny_time = jiffies + rtw_ms_to_systime(ips_deffer_ms);
+		pwrpriv->ips_deny_time = jiffies + msecs_to_jiffies(ips_deffer_ms);
 	return ret;
 }
 
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 3ddaa34..238930c 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -154,7 +154,6 @@ u32  _rtw_down_sema(struct semaphore *sema);
 
 void _rtw_init_queue(struct __queue *pqueue);
 
-u32  rtw_ms_to_systime(u32 ms);
 s32  rtw_get_passing_time_ms(u32 start);
 
 struct rtw_netdev_priv_indicator {
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 96f8eb8..db6ee31 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -77,11 +77,6 @@ void	_rtw_init_queue(struct __queue *pqueue)
 	spin_lock_init(&(pqueue->lock));
 }
 
-inline u32 rtw_ms_to_systime(u32 ms)
-{
-	return ms * HZ / 1000;
-}
-
 /*  the input parameter start must be in jiffies */
 inline s32 rtw_get_passing_time_ms(u32 start)
 {
-- 
1.7.10.4

