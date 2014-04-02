Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbaDBM1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:27:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:11762 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618AbaDBM1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,780,1389772800"; 
   d="scan'208";a="512837132"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, chiau.ee.chew@intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] phy: don't return error from the stubs
Date: Wed,  2 Apr 2014 15:25:43 +0300
Message-Id: <1396441543-11744-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Returning 0 from the stubs for the functions that are used
for PHY controlling. The interface should not appear to be
failing with every operation when the framework is not
enabled.

This fixes an issue in dwc3 driver, where the driver fails
the moment first phy_*() call is made when the framework is
not enabled.

Reported-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 include/linux/phy/phy.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index e2f5ca9..00d6949 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -174,22 +174,22 @@ void devm_of_phy_provider_unregister(struct device *dev,
 #else
 static inline int phy_pm_runtime_get(struct phy *phy)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline int phy_pm_runtime_get_sync(struct phy *phy)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline int phy_pm_runtime_put(struct phy *phy)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline int phy_pm_runtime_put_sync(struct phy *phy)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline void phy_pm_runtime_allow(struct phy *phy)
@@ -204,27 +204,27 @@ static inline void phy_pm_runtime_forbid(struct phy *phy)
 
 static inline int phy_init(struct phy *phy)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline int phy_exit(struct phy *phy)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline int phy_power_on(struct phy *phy)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline int phy_power_off(struct phy *phy)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline int phy_get_bus_width(struct phy *phy)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline void phy_set_bus_width(struct phy *phy, int bus_width)
-- 
1.9.1

