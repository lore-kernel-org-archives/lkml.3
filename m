Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaDPK5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:57:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36299 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbaDPK5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:57:34 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <kishon@ti.com>, <santosh.shilimkar@ti.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2] phy: core: make NULL a valid phy reference if !CONFIG_GENERIC_PHY
Date: Wed, 16 Apr 2014 14:48:21 +0300
Message-ID: <1397648901-4450-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression on Keystone 2 platforms caused by patch
57303488cd37da58263e842de134dc65f7c626d5
"usb: dwc3: adapt dwc3 core to use Generic PHY Framework" which adds
optional support of generic phy in DWC3 core.

On Keystone 2 platforms the USB is not working now because
CONFIG_GENERIC_PHY isn't set and, as result, Generic PHY APIs stubs
return -ENOSYS always. The log shows:
 dwc3 2690000.dwc3: failed to initialize core
 dwc3: probe of 2690000.dwc3 failed with error -38

Hence, fix it by making NULL a valid phy reference in Generic PHY
APIs stubs in the same way as it was done by the patch
04c2facad8fee66c981a51852806d8923336f362 "drivers: phy: Make NULL
a valid phy reference".

CC: Kishon Vijay Abraham I <kishon@ti.com>
CC: Felipe Balbi <balbi@ti.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---

This fixes for regression in 3.15-rc1 - USB doesn't work on Keystone 2

Changes in v2:
- the same check added at stubs
   phy_pm_runtime_get(struct phy *phy)
   phy_pm_runtime_get_sync(struct phy *phy)
   phy_pm_runtime_put(struct phy *phy)
   phy_pm_runtime_put_sync(struct phy *phy)

 include/linux/phy/phy.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index e2f5ca9..2760744 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -174,21 +174,29 @@ void devm_of_phy_provider_unregister(struct device *dev,
 #else
 static inline int phy_pm_runtime_get(struct phy *phy)
 {
+	if (!phy)
+		return 0;
 	return -ENOSYS;
 }
 
 static inline int phy_pm_runtime_get_sync(struct phy *phy)
 {
+	if (!phy)
+		return 0;
 	return -ENOSYS;
 }
 
 static inline int phy_pm_runtime_put(struct phy *phy)
 {
+	if (!phy)
+		return 0;
 	return -ENOSYS;
 }
 
 static inline int phy_pm_runtime_put_sync(struct phy *phy)
 {
+	if (!phy)
+		return 0;
 	return -ENOSYS;
 }
 
@@ -204,21 +212,29 @@ static inline void phy_pm_runtime_forbid(struct phy *phy)
 
 static inline int phy_init(struct phy *phy)
 {
+	if (!phy)
+		return 0;
 	return -ENOSYS;
 }
 
 static inline int phy_exit(struct phy *phy)
 {
+	if (!phy)
+		return 0;
 	return -ENOSYS;
 }
 
 static inline int phy_power_on(struct phy *phy)
 {
+	if (!phy)
+		return 0;
 	return -ENOSYS;
 }
 
 static inline int phy_power_off(struct phy *phy)
 {
+	if (!phy)
+		return 0;
 	return -ENOSYS;
 }
 
-- 
1.7.9.5

