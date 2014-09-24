Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaIXQ5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:57:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:49437 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbaIXQqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:46:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749217"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 01/27] PM: Add helper pm_runtime_last_busy_and_autosuspend()
Date: Wed, 24 Sep 2014 21:44:51 +0530
Message-Id: <1411575342-31048-2-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subhransu S. Prusty <subhransu.s.prusty@intel.com>

pm_runtime_mark_last_busy and pm_runtime_put_autosuspend are used together
in quite a lot of places. Add a helper for these.
Also updated Documentation for this

Signed-off-by: Subhransu S. Prusty <subhransu.s.prusty@intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 Documentation/power/runtime_pm.txt |    4 ++++
 include/linux/pm_runtime.h         |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index f32ce54..5d9565b 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -490,6 +490,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       power.use_autosuspend isn't set, otherwise returns the expiration time
       in jiffies
 
+   int pm_runtime_last_busy_and_autosuspend(struct device *dev);
+    - invoke pm_runtime_mark_last_busy(dev) and then run
+      pm_runtime_put_autosuspend(dev) and return its result
+
 It is safe to execute the following helper functions from interrupt context:
 
 pm_request_idle()
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 367f49b..256ec50 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -277,4 +277,10 @@ static inline void pm_runtime_dont_use_autosuspend(struct device *dev)
 	__pm_runtime_use_autosuspend(dev, false);
 }
 
+static inline int pm_runtime_last_busy_and_autosuspend(struct device *dev)
+{
+	pm_runtime_mark_last_busy(dev);
+	return pm_runtime_put_autosuspend(dev);
+}
+
 #endif
-- 
1.7.0.4

