Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbaGITLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:11:18 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:53758 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaGITLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:11:14 -0400
From: James A Shackleford <shack@linux.com>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 2/3] staging: rtl8712: remove wrapper function _set_workitem()
Date: Wed,  9 Jul 2014 15:10:46 -0400
Message-Id: <1404933047-23071-2-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404933047-23071-1-git-send-email-shack@linux.com>
References: <1404933047-23071-1-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline function _set_workitem() simply wraps schedule_work().  Removed.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h   | 5 -----
 drivers/staging/rtl8712/rtl8712_led.c     | 2 +-
 drivers/staging/rtl8712/rtl871x_pwrctrl.c | 4 ++--
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 2cf9a02..43795e7 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -81,11 +81,6 @@ static inline void _cancel_timer(struct timer_list *ptimer, u8 *bcancelled)
 	*bcancelled = true; /*true ==1; false==0*/
 }
 
-static inline void _set_workitem(_workitem *pwork)
-{
-	schedule_work(pwork);
-}
-
 #ifndef BIT
 	#define BIT(x)	(1 << (x))
 #endif
diff --git a/drivers/staging/rtl8712/rtl8712_led.c b/drivers/staging/rtl8712/rtl8712_led.c
index a84ae2f..56e8add 100644
--- a/drivers/staging/rtl8712/rtl8712_led.c
+++ b/drivers/staging/rtl8712/rtl8712_led.c
@@ -827,7 +827,7 @@ static void BlinkTimerCallback(unsigned long data)
 	if ((pLed->padapter->bSurpriseRemoved == true) ||
 	    (pLed->padapter->bDriverStopped == true))
 		return;
-	_set_workitem(&(pLed->BlinkWorkItem));
+	schedule_work(&pLed->BlinkWorkItem);
 }
 
 /*	Description:
diff --git a/drivers/staging/rtl8712/rtl871x_pwrctrl.c b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
index 6cf051f..89ce527 100644
--- a/drivers/staging/rtl8712/rtl871x_pwrctrl.c
+++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
@@ -83,7 +83,7 @@ void r8712_set_ps_mode(struct _adapter *padapter, uint ps_mode, uint smart_ps)
 			pwrpriv->bSleep = false;
 		pwrpriv->pwr_mode = ps_mode;
 		pwrpriv->smart_ps = smart_ps;
-		_set_workitem(&(pwrpriv->SetPSModeWorkItem));
+		schedule_work(&pwrpriv->SetPSModeWorkItem);
 	}
 }
 
@@ -133,7 +133,7 @@ static void _rpwm_check_handler (struct _adapter *padapter)
 	    padapter->bSurpriseRemoved == true)
 		return;
 	if (pwrpriv->cpwm != pwrpriv->rpwm)
-		_set_workitem(&(pwrpriv->rpwm_workitem));
+		schedule_work(&pwrpriv->rpwm_workitem);
 }
 
 static void SetPSModeWorkItemCallback(struct work_struct *work)
-- 
1.9.1

