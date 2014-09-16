Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaIPLGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:06:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:13338 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbaIPLGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:06:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="386756238"
From: "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        vinod.koul@intel.com,
        "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>
Subject: [PATCH] PM: Add helper to mark last busy and autosuspend
Date: Tue, 16 Sep 2014 16:13:51 +0530
Message-Id: <1410864231-10334-1-git-send-email-subhransu.s.prusty@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_runtime_mark_last_busy and pm_runtime_put_autosuspend are used together
in quite a lot of places. Add a helper for these.

Signed-off-by: Subhransu S. Prusty <subhransu.s.prusty@intel.com>
---
 include/linux/pm_runtime.h | 6 ++++++
 1 file changed, 6 insertions(+)

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
1.9.0

