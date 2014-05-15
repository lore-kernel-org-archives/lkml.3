Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaEONkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:40:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:61272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaEONkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:40:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="540952692"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mike Turquette <mturquette@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 1/4] ACPI / PM: Export rest of the subsys functions
Date: Thu, 15 May 2014 16:40:23 +0300
Message-Id: <1400161226-24067-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason for excluding those two.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/acpi/device_pm.c | 2 ++
 include/linux/acpi.h     | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index d047739..7dae90b 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -923,6 +923,7 @@ int acpi_subsys_suspend(struct device *dev)
 	pm_runtime_resume(dev);
 	return pm_generic_suspend(dev);
 }
+EXPORT_SYMBOL_GPL(acpi_subsys_suspend);
 
 /**
  * acpi_subsys_suspend_late - Suspend device using ACPI.
@@ -968,6 +969,7 @@ int acpi_subsys_freeze(struct device *dev)
 	pm_runtime_resume(dev);
 	return pm_generic_freeze(dev);
 }
+EXPORT_SYMBOL_GPL(acpi_subsys_freeze);
 
 #endif /* CONFIG_PM_SLEEP */
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 7a8f2cd..47dcc0e 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -556,12 +556,16 @@ int acpi_dev_resume_early(struct device *dev);
 int acpi_subsys_prepare(struct device *dev);
 int acpi_subsys_suspend_late(struct device *dev);
 int acpi_subsys_resume_early(struct device *dev);
+int acpi_subsys_suspend(struct device *dev);
+int acpi_subsys_freeze(struct device *dev);
 #else
 static inline int acpi_dev_suspend_late(struct device *dev) { return 0; }
 static inline int acpi_dev_resume_early(struct device *dev) { return 0; }
 static inline int acpi_subsys_prepare(struct device *dev) { return 0; }
 static inline int acpi_subsys_suspend_late(struct device *dev) { return 0; }
 static inline int acpi_subsys_resume_early(struct device *dev) { return 0; }
+static inline int acpi_subsys_suspend(struct device *dev) { return 0; }
+static inline int acpi_subsys_freeze(struct device *dev) { return 0; }
 #endif
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_PM)
-- 
2.0.0.rc2

