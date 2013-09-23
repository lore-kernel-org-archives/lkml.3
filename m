Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3IWKLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:11:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:62189 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab3IWKKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,961,1371106800"; 
   d="scan'208";a="405750943"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 3/7] power_supply: add throttle state
Date: Mon, 23 Sep 2013 23:34:01 +0530
Message-Id: <1379959445-28207-4-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
References: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
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

Change-Id: I390a4c7479df4a7e17f73682802e4be05ea58541
Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 include/linux/power_supply.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index c3ce514a..e99c78d 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -210,6 +210,18 @@ union power_supply_propval {
 
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
@@ -224,6 +236,9 @@ struct power_supply {
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

