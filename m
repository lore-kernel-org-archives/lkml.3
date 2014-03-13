Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaCMKSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:18:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38571 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbaCMKSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:18:34 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH][next] phy: core: make NULL a valid phy reference if !CONFIG_GENERIC_PHY
Date: Thu, 13 Mar 2014 13:11:13 +0200
Message-ID: <1394709073-1980-1-git-send-email-grygorii.strashko@ti.com>
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
 include/linux/phy/phy.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index e2f5ca9..5a9b193 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -204,21 +204,29 @@ static inline void phy_pm_runtime_forbid(struct phy *phy)
 
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

