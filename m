Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3ATKYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:24:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41418 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab3ATKYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:24:39 -0500
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 4/6] cpufreq: Add a get_current_driver helper
Date: Sun, 20 Jan 2013 11:24:28 +0100
Message-Id: <1358677470-17394-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358677470-17394-1-git-send-email-bp@alien8.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Add a helper function to return cpufreq_driver->name.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/cpufreq.c | 14 ++++++++++++++
 include/linux/cpufreq.h   |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1f93dbd72355..6ed3c1377caf 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1386,6 +1386,20 @@ static struct syscore_ops cpufreq_syscore_ops = {
 	.resume		= cpufreq_bp_resume,
 };
 
+/**
+ *	cpufreq_get_current_driver - return current driver's name
+ *
+ *	Return the name string of the currently loaded cpufreq driver
+ *	or NULL, if none.
+ */
+const char *cpufreq_get_current_driver(void)
+{
+	if (cpufreq_driver)
+		return cpufreq_driver->name;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(cpufreq_get_current_driver);
 
 /*********************************************************************
  *                     NOTIFIER LISTS INTERFACE                      *
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index a55b88eaf96a..a018da2d2a7c 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -407,4 +407,5 @@ void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
 
 void cpufreq_frequency_table_put_attr(unsigned int cpu);
+extern const char *cpufreq_get_current_driver(void);
 #endif /* _LINUX_CPUFREQ_H */
-- 
1.8.1.rc3

