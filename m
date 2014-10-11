Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaJKVOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 17:14:35 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50130 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaJKVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 17:14:32 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 2/2] kernel: power: Drop pm_poweroff_prepare
Date: Sat, 11 Oct 2014 14:14:17 -0700
Message-Id: <1413062057-11657-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413062057-11657-1-git-send-email-linux@roeck-us.net>
References: <1413062057-11657-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of pm_poweroff_prepare was acpi, which has been converted to use
a syscore callback. Drop pm_poweroff_prepare as it is no longer necessary.

Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/pm.h | 1 -
 kernel/reboot.c    | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 383fd68..333506e 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -32,7 +32,6 @@
  * Callbacks for platform drivers to implement.
  */
 extern void (*pm_power_off)(void);
-extern void (*pm_power_off_prepare)(void);
 
 struct device; /* we have a circular dep with device.h */
 #ifdef CONFIG_VT_CONSOLE_SLEEP
diff --git a/kernel/reboot.c b/kernel/reboot.c
index 5925f5a..5ad4f0b 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -44,12 +44,6 @@ int reboot_cpu;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
-/*
- * If set, this is used for preparing the system to power off.
- */
-
-void (*pm_power_off_prepare)(void);
-
 /**
  *	emergency_restart - reboot the system
  *
@@ -257,8 +251,6 @@ EXPORT_SYMBOL_GPL(kernel_halt);
 void kernel_power_off(void)
 {
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
-	if (pm_power_off_prepare)
-		pm_power_off_prepare();
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	pr_emerg("Power down\n");
-- 
1.9.1

