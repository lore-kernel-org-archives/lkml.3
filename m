Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3GNJm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 05:42:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:29075 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab3GNJm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 05:42:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,662,1367996400"; 
   d="scan'208";a="369972326"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 3/3] power_supply: add throttle state
Date: Sun, 14 Jul 2013 23:08:15 +0530
Message-Id: <1373823495-2651-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charger and battery temperature contribute to the
platform thermal. The only way to control the temperature
is to control the charging. The charging can be controlled in different
way. This could be disabling charger, disabling charging, adjusting CC,
or by adjusting the INLMT. This patch adds a structure to define the
charger throttle actions. Also this patch adds a throttle_states
field to the struct power_supply which can be used by the charger
driver to define it's throttle actions for different states

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 include/linux/power_supply.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 5a24e10..516e4c4 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -209,6 +209,18 @@ union power_supply_propval {
 
 struct device_node;
 
+enum psy_throttle_action {
+
+	PSY_THROTTLE_DISABLE_CHARGER = 0,
+	PSY_THROTTLE_DISABLE_CHARGING,
+	PSY_THROTTLE_CC_LIMIT,
+	PSY_THROTTLE_INPUT_LIMIT,
+};
+
+struct psy_throttle_state {
+	enum psy_throttle_action throttle_action;
+	unsigned throttle_val;
+};
 struct power_supply {
 	const char *name;
 	enum power_supply_type type;
@@ -223,6 +235,9 @@ struct power_supply {
 	size_t num_supplies;
 	struct device_node *of_node;
 
+	struct psy_throttle_state *throttle_states;
+	size_t num_throttle_states;
+
 	int (*get_property)(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val);
-- 
1.7.9.5

