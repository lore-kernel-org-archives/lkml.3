Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaGAAB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:01:59 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36507 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGAAB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:01:58 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH] power/restart: Call machine_restart instead of arm_pm_restart
Date: Mon, 30 Jun 2014 17:01:50 -0700
Message-Id: <1404172910-21056-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

machine_restart is supported on non-ARM platforms, and ultimately calls
arm_pm_restart, so dont call arm_pm_restart directly but use the more
generic function.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/restart-poweroff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/reset/restart-poweroff.c b/drivers/power/reset/restart-poweroff.c
index 5758033..47f10eb 100644
--- a/drivers/power/reset/restart-poweroff.c
+++ b/drivers/power/reset/restart-poweroff.c
@@ -20,7 +20,8 @@
 
 static void restart_poweroff_do_poweroff(void)
 {
-	arm_pm_restart(REBOOT_HARD, NULL);
+	reboot_mode = REBOOT_HARD;
+	machine_restart(NULL);
 }
 
 static int restart_poweroff_probe(struct platform_device *pdev)
-- 
1.9.1

