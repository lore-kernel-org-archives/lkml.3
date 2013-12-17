Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3LQJhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:37:08 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42736 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3LQJhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:37:04 -0500
Date: Tue, 17 Dec 2013 15:06:54 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 11/11] drivers: acpi: Include header file in debugfs.c and
 rectify prototype declaration in internal.h
Message-ID: <37de640470c91e2e54ab68a158e19dde3938f18a.1387271324.git.rashika.kheria@gmail.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include header file internal.h in debugfs.c and change the return
value's type in header file internal.h.

This eliminates the following warning in debugfs.c:
drivers/acpi/debugfs.c:16:13: warning: no previous prototype for ‘acpi_debugfs_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/acpi/debugfs.c  |    3 +++
 drivers/acpi/internal.h |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/debugfs.c b/drivers/acpi/debugfs.c
index b55d6a2..96bcaf7 100644
--- a/drivers/acpi/debugfs.c
+++ b/drivers/acpi/debugfs.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/debugfs.h>
 #include <acpi/acpi_drivers.h>
+#include "internal.h"
 
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("debugfs");
@@ -13,7 +14,9 @@ ACPI_MODULE_NAME("debugfs");
 struct dentry *acpi_debugfs_dir;
 EXPORT_SYMBOL_GPL(acpi_debugfs_dir);
 
+#ifdef  CONFIG_DEBUG_FS
 void __init acpi_debugfs_init(void)
 {
 	acpi_debugfs_dir = debugfs_create_dir("acpi", NULL);
 }
+#endif
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 8ef9787..c2e35bd 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -63,7 +63,7 @@ void acpi_scan_hotplug_enabled(struct acpi_hotplug_profile *hotplug, bool val);
 
 #ifdef CONFIG_DEBUG_FS
 extern struct dentry *acpi_debugfs_dir;
-int acpi_debugfs_init(void);
+void acpi_debugfs_init(void);
 #else
 static inline void acpi_debugfs_init(void) { return; }
 #endif
-- 
1.7.9.5

