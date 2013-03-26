Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934737Ab3CZQ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:28:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:62041 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933755Ab3CZQ0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:26:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="276202584"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: amit.daniel@samsung.com, durgadoss.r@intel.com, andi@lisas.de,
        Zhang Rui <rui.zhang@intel.com>
Subject: [RFC PATCH 4/5] Thermal: governor API cleanup
Date: Wed, 27 Mar 2013 00:26:08 +0800
Message-Id: <1364315169-15427-5-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364315169-15427-1-git-send-email-rui.zhang@intel.com>
References: <1364315169-15427-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/thermal_core.c |    2 --
 drivers/thermal/thermal_core.h |    2 ++
 include/linux/thermal.h        |    3 ---
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index eac9745..f645757 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -99,7 +99,6 @@ int thermal_register_governor(struct thermal_governor *governor)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(thermal_register_governor);
 
 void thermal_unregister_governor(struct thermal_governor *governor)
 {
@@ -127,7 +126,6 @@ void thermal_unregister_governor(struct thermal_governor *governor)
 	mutex_unlock(&thermal_governor_lock);
 	return;
 }
-EXPORT_SYMBOL_GPL(thermal_unregister_governor);
 
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index f84ea0f..a1f8278 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -50,6 +50,8 @@ struct thermal_instance {
 	struct list_head cdev_node; /* node in cdev->thermal_instances */
 };
 
+extern int thermal_register_governor(struct thermal_governor *);
+extern void thermal_unregister_governor(struct thermal_governor *);
 
 #ifdef CONFIG_THERMAL_GOV_STEP_WISE
 extern int thermal_gov_step_wise_register(void);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 2eeec01..af03ea6 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -243,9 +243,6 @@ struct thermal_instance *get_thermal_instance(struct thermal_zone_device *,
 void thermal_cdev_update(struct thermal_cooling_device *);
 void notify_thermal_framework(struct thermal_zone_device *, int);
 
-int thermal_register_governor(struct thermal_governor *);
-void thermal_unregister_governor(struct thermal_governor *);
-
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
 						enum events event);
-- 
1.7.9.5

