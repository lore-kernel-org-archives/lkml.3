Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3AWJBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:01:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:25634 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab3AWJBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:01:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,520,1355126400"; 
   d="scan'208";a="277359116"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com,
        yanmin_zhang@linux.intel.com, ShuoX Liu <shuox.liu@intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: [PATCH] PM / Runtime: Add new helper function: pm_runtime_active()
Date: Wed, 23 Jan 2013 16:54:01 +0800
Message-Id: <1358931241-32375-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

This boolean function simply returns whether or not the runtime
status of the device is 'active'. The typical scenario is driver
calls pm_runtime_get firstly, then check pm_runtime_active in
atomic environment.

Also add entry to Documentation/power/runtime.txt

Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
 Documentation/power/runtime_pm.txt |    4 ++++
 include/linux/pm_runtime.h         |    7 +++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index 03591a7..6c9f5d9 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -426,6 +426,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       'power.runtime_error' is set or 'power.disable_depth' is greater than
       zero)
 
+  bool pm_runtime_active(struct device *dev);
+    - return true if the device's runtime PM status is 'active' or its
+      'power.disable_depth' field is not equal to zero, or false otherwise
+
   bool pm_runtime_suspended(struct device *dev);
     - return true if the device's runtime PM status is 'suspended' and its
       'power.disable_depth' field is equal to zero, or false otherwise
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index f271860..c785c21 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -80,6 +80,12 @@ static inline bool pm_runtime_suspended(struct device *dev)
 		&& !dev->power.disable_depth;
 }
 
+static inline bool pm_runtime_active(struct device *dev)
+{
+	return dev->power.runtime_status == RPM_ACTIVE
+		|| dev->power.disable_depth;
+}
+
 static inline bool pm_runtime_status_suspended(struct device *dev)
 {
 	return dev->power.runtime_status == RPM_SUSPENDED;
@@ -132,6 +138,7 @@ static inline void pm_runtime_put_noidle(struct device *dev) {}
 static inline bool device_run_wake(struct device *dev) { return false; }
 static inline void device_set_run_wake(struct device *dev, bool enable) {}
 static inline bool pm_runtime_suspended(struct device *dev) { return false; }
+static inline bool pm_runtime_active(struct device *dev) { return true; }
 static inline bool pm_runtime_status_suspended(struct device *dev) { return false; }
 static inline bool pm_runtime_enabled(struct device *dev) { return false; }
 
-- 
1.7.1

