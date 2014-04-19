Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaDSDVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 23:21:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47667 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbaDSDVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 23:21:53 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] phy: core: make NULL a valid phy reference if !CONFIG_GENERIC_PHY
Date: Sat, 19 Apr 2014 08:51:44 +0530
Message-ID: <1397877704-2755-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397877704-2755-1-git-send-email-kishon@ti.com>
References: <1397877704-2755-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

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

Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
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

