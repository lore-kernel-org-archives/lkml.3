Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3LZQsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 11:48:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49145 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab3LZQrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 11:47:39 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 3/4] phy: phy-core.c: remove unnecessary initialization of local variables
Date: Thu, 26 Dec 2013 22:17:19 +0530
Message-ID: <1388076440-7620-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388076440-7620-1-git-send-email-kishon@ti.com>
References: <1388076440-7620-1-git-send-email-kishon@ti.com>
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
index 33fcbcc..645c867 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -210,7 +210,7 @@ EXPORT_SYMBOL_GPL(phy_exit);
 
 int phy_power_on(struct phy *phy)
 {
-	int ret = -ENOTSUPP;
+	int ret;
 
 	ret = phy_pm_runtime_get_sync(phy);
 	if (ret < 0 && ret != -ENOTSUPP)
@@ -238,7 +238,7 @@ EXPORT_SYMBOL_GPL(phy_power_on);
 
 int phy_power_off(struct phy *phy)
 {
-	int ret = -ENOTSUPP;
+	int ret;
 
 	mutex_lock(&phy->mutex);
 	if (phy->power_count == 1 && phy->ops->power_off) {
@@ -378,7 +378,7 @@ EXPORT_SYMBOL_GPL(of_phy_simple_xlate);
 struct phy *phy_get(struct device *dev, const char *string)
 {
 	int index = 0;
-	struct phy *phy = NULL;
+	struct phy *phy;
 
 	if (string == NULL) {
 		dev_WARN(dev, "missing string\n");
-- 
1.7.10.4

