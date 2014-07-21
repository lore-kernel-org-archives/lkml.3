Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbaGUPjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:39:45 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19627 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbaGUPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:39:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Jul 2014 08:28:00 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, <devicetree@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, <broonie@kernel.org>
Subject: [PATCH v2 01/16] regmap: Add regmap_get_device
Date: Mon, 21 Jul 2014 18:38:47 +0300
Message-ID: <1405957142-19416-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function regmap_get_device to obtain the underlying struct
device from a regmap.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/base/regmap/regmap.c | 12 ++++++++++++
 include/linux/regmap.h       |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 74d8c06..5ba0263 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1073,6 +1073,18 @@ struct regmap *dev_get_regmap(struct device *dev, const char *name)
 }
 EXPORT_SYMBOL_GPL(dev_get_regmap);
 
+/**
+ * regmap_get_device(): Obtain the device from a regmap
+ *
+ * @map: Register map to operate on.
+ *
+ * Returns the underlying device that the regmap has been created for.
+ */
+struct device *regmap_get_device(struct regmap *map)
+{
+	return map->dev;
+}
+
 static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 			       struct regmap_range_node *range,
 			       unsigned int val_num)
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7b0e4b4..cd480fd 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -396,6 +396,7 @@ void regmap_exit(struct regmap *map);
 int regmap_reinit_cache(struct regmap *map,
 			const struct regmap_config *config);
 struct regmap *dev_get_regmap(struct device *dev, const char *name);
+struct device *regmap_get_device(struct regmap *map);
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
 int regmap_write_async(struct regmap *map, unsigned int reg, unsigned int val);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
@@ -729,6 +730,12 @@ static inline struct regmap *dev_get_regmap(struct device *dev,
 	return NULL;
 }
 
+static inline struct device *regmap_get_device(struct regmap *map)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 #endif
 
 #endif
-- 
1.8.1.5

