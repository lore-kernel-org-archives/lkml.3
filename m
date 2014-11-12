Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaKLLSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:18:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54920 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbaKLLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:18:41 -0500
Date: Wed, 12 Nov 2014 11:18:35 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH] regulator: core: export function to check if regulator
	always on
Message-ID: <20141112111835.GA12635@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export a function to allow a consumer to check if its supply
regulator is always on. Drivers might wish to take different
action based on this - for example skipping time-consuming
power-saving preparations that are irrelevant if the regulator
cannot be disabled.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |   16 ++++++++++++++++
 include/linux/regulator/consumer.h |    6 ++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd87c0c..e93db90 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2184,6 +2184,22 @@ int regulator_is_enabled(struct regulator *regulator)
 EXPORT_SYMBOL_GPL(regulator_is_enabled);
 
 /**
+ * regulator_is_always_on - check if regulator is always on
+ * @regulator: regulator source
+ *
+ * Returns positive if the regulator driver backing the source/client
+ * is always on, false otherwise.
+ */
+int regulator_is_always_on(struct regulator *regulator)
+{
+	if (regulator->always_on)
+		return 1;
+	else
+		return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_is_always_on);
+
+/**
  * regulator_can_change_voltage - check if regulator can change voltage
  * @regulator: regulator source
  *
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f540b14..bd6daef 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -217,6 +217,7 @@ int regulator_bulk_force_disable(int num_consumers,
 void regulator_bulk_free(int num_consumers,
 			 struct regulator_bulk_data *consumers);
 
+int regulator_is_always_on(struct regulator *regulator);
 int regulator_can_change_voltage(struct regulator *regulator);
 int regulator_count_voltages(struct regulator *regulator);
 int regulator_list_voltage(struct regulator *regulator, unsigned selector);
@@ -425,6 +426,11 @@ static inline void regulator_bulk_free(int num_consumers,
 {
 }
 
+static inline int regulator_is_always_on(struct regulator *regulator)
+{
+	return 1;
+}
+
 static inline int regulator_can_change_voltage(struct regulator *regulator)
 {
 	return 0;
-- 
1.7.2.5

