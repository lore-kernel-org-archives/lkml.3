Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaJUEPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:15:18 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34031 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaJUEPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:15:04 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH v2 47/47] kernel: Remove pm_power_off
Date: Mon, 20 Oct 2014 21:13:03 -0700
Message-Id: <1413864783-3271-48-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=1.3
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DDC8.00CF,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 257
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 3
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users of pm_power_off are left, so it is safe to remove the function.

Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: poweroff -> power_off

 include/linux/pm.h              |  1 -
 kernel/power/poweroff_handler.c | 10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 7e0cb36..316271d 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -31,7 +31,6 @@
 /*
  * Callbacks for platform drivers to implement.
  */
-extern void (*pm_power_off)(void);
 extern void (*pm_power_off_prepare)(void);
 
 /*
diff --git a/kernel/power/poweroff_handler.c b/kernel/power/poweroff_handler.c
index 37f0b88..d2d164e 100644
--- a/kernel/power/poweroff_handler.c
+++ b/kernel/power/poweroff_handler.c
@@ -22,12 +22,6 @@
 #include <linux/types.h>
 
 /*
- * If set, calling this function will power off the system immediately.
- */
-void (*pm_power_off)(void);
-EXPORT_SYMBOL(pm_power_off);
-
-/*
  *	Notifier list for kernel code which wants to be called
  *	to power off the system.
  */
@@ -242,8 +236,6 @@ EXPORT_SYMBOL(devm_register_power_off_handler);
 void do_kernel_power_off(void)
 {
 	spin_lock(&power_off_handler_lock);
-	if (pm_power_off)
-		pm_power_off();
 	raw_notifier_call_chain(&power_off_handler_list, 0, NULL);
 	spin_unlock(&power_off_handler_lock);
 }
@@ -255,6 +247,6 @@ void do_kernel_power_off(void)
  */
 bool have_kernel_power_off(void)
 {
-	return pm_power_off != NULL || power_off_handler_list.head != NULL;
+	return power_off_handler_list.head != NULL;
 }
 EXPORT_SYMBOL(have_kernel_power_off);
-- 
1.9.1

