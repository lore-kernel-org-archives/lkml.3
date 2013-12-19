Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3LSOcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:32:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45509 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3LSOcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:32:13 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <kishon@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <s.nawrocki@samsung.com>, <jg1.han@samsung.com>, <mporter@linaro.org>,
        <andrew@lunn.ch>, <k.debski@samsung.com>, <gautamvivek1987@gmail.com>,
        <heikki.krogerus@linux.intel.com>, <yuvaraj.cd@gmail.com>
Subject: [PATCH 2/2] phy: phy-core.c: remove unnecessary initialization of local variables
Date: Thu, 19 Dec 2013 20:01:44 +0530
Message-ID: <1387463504-4415-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387463504-4415-1-git-send-email-kishon@ti.com>
References: <1387463504-4415-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were a few places where variables are initialized unncessarily.
Remove those initializations.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index e198259..8d9ef25 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -198,7 +198,7 @@ EXPORT_SYMBOL_GPL(phy_exit);
 
 int phy_power_on(struct phy *phy)
 {
-	int ret = -ENOTSUPP;
+	int ret;
 
 	ret = phy_pm_runtime_get_sync(phy);
 	if (ret < 0 && ret != -ENOTSUPP)
@@ -226,7 +226,7 @@ EXPORT_SYMBOL_GPL(phy_power_on);
 
 int phy_power_off(struct phy *phy)
 {
-	int ret = -ENOTSUPP;
+	int ret;
 
 	mutex_lock(&phy->mutex);
 	if (phy->power_count == 1 && phy->ops->power_off) {
@@ -369,7 +369,7 @@ EXPORT_SYMBOL_GPL(of_phy_simple_xlate);
 struct phy *phy_get(struct device *dev, const char *string)
 {
 	int index = 0;
-	struct phy *phy = NULL;
+	struct phy *phy;
 
 	if (string == NULL) {
 		dev_WARN(dev, "missing string\n");
-- 
1.7.10.4

