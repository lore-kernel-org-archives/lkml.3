Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaEWPo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:44:29 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42722 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaEWPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:44:27 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] regulator: Constify the pointer to alias name array
Date: Fri, 23 May 2014 16:44:10 +0100
Message-Id: <1400859850-24505-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toughen-up checks for read-only regulator names.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/core.c           |  7 ++++---
 drivers/regulator/devres.c         |  6 +++---
 include/linux/mfd/core.h           |  2 +-
 include/linux/regulator/consumer.h | 36 ++++++++++++++++++++----------------
 4 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9a09f3c..ba28d29 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1597,9 +1597,10 @@ EXPORT_SYMBOL_GPL(regulator_unregister_supply_alias);
  * registered any aliases that were registered will be removed
  * before returning to the caller.
  */
-int regulator_bulk_register_supply_alias(struct device *dev, const char **id,
+int regulator_bulk_register_supply_alias(struct device *dev,
+					 const char *const *id,
 					 struct device *alias_dev,
-					 const char **alias_id,
+					 const char *const *alias_id,
 					 int num_id)
 {
 	int i;
@@ -1637,7 +1638,7 @@ EXPORT_SYMBOL_GPL(regulator_bulk_register_supply_alias);
  * aliases in one operation.
  */
 void regulator_bulk_unregister_supply_alias(struct device *dev,
-					    const char **id,
+					    const char *const *id,
 					    int num_id)
 {
 	int i;
diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
index f44818b..8f785bc 100644
--- a/drivers/regulator/devres.c
+++ b/drivers/regulator/devres.c
@@ -360,9 +360,9 @@ EXPORT_SYMBOL_GPL(devm_regulator_unregister_supply_alias);
  * will be removed before returning to the caller.
  */
 int devm_regulator_bulk_register_supply_alias(struct device *dev,
-					      const char **id,
+					      const char *const *id,
 					      struct device *alias_dev,
-					      const char **alias_id,
+					      const char *const *alias_id,
 					      int num_id)
 {
 	int i;
@@ -404,7 +404,7 @@ EXPORT_SYMBOL_GPL(devm_regulator_bulk_register_supply_alias);
  * will ensure that the resource is freed.
  */
 void devm_regulator_bulk_unregister_supply_alias(struct device *dev,
-						 const char **id,
+						 const char *const *id,
 						 int num_id)
 {
 	int i;
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index bdba8c6..f543de9 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -63,7 +63,7 @@ struct mfd_cell {
 	/* A list of regulator supplies that should be mapped to the MFD
 	 * device rather than the child device when requested
 	 */
-	const char		**parent_supplies;
+	const char * const	*parent_supplies;
 	int			num_parent_supplies;
 };
 
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 1a4a8c1..ccd3d77 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -151,11 +151,13 @@ int regulator_register_supply_alias(struct device *dev, const char *id,
 				    const char *alias_id);
 void regulator_unregister_supply_alias(struct device *dev, const char *id);
 
-int regulator_bulk_register_supply_alias(struct device *dev, const char **id,
+int regulator_bulk_register_supply_alias(struct device *dev,
+					 const char *const *id,
 					 struct device *alias_dev,
-					 const char **alias_id, int num_id);
+					 const char *const *alias_id,
+					 int num_id);
 void regulator_bulk_unregister_supply_alias(struct device *dev,
-					    const char **id, int num_id);
+					    const char * const *id, int num_id);
 
 int devm_regulator_register_supply_alias(struct device *dev, const char *id,
 					 struct device *alias_dev,
@@ -164,12 +166,12 @@ void devm_regulator_unregister_supply_alias(struct device *dev,
 					    const char *id);
 
 int devm_regulator_bulk_register_supply_alias(struct device *dev,
-					      const char **id,
+					      const char *const *id,
 					      struct device *alias_dev,
-					      const char **alias_id,
+					      const char *const *alias_id,
 					      int num_id);
 void devm_regulator_bulk_unregister_supply_alias(struct device *dev,
-						 const char **id,
+						 const char *const *id,
 						 int num_id);
 
 /* regulator output control and status */
@@ -290,17 +292,17 @@ static inline void regulator_unregister_supply_alias(struct device *dev,
 }
 
 static inline int regulator_bulk_register_supply_alias(struct device *dev,
-						       const char **id,
-						       struct device *alias_dev,
-						       const char **alias_id,
-						       int num_id)
+						const char *const *id,
+						struct device *alias_dev,
+						const char * const *alias_id,
+						int num_id)
 {
 	return 0;
 }
 
 static inline void regulator_bulk_unregister_supply_alias(struct device *dev,
-							  const char **id,
-							  int num_id)
+						const char * const *id,
+						int num_id)
 {
 }
 
@@ -317,15 +319,17 @@ static inline void devm_regulator_unregister_supply_alias(struct device *dev,
 {
 }
 
-static inline int devm_regulator_bulk_register_supply_alias(
-		struct device *dev, const char **id, struct device *alias_dev,
-		const char **alias_id, int num_id)
+static inline int devm_regulator_bulk_register_supply_alias(struct device *dev,
+						const char *const *id,
+						struct device *alias_dev,
+						const char *const *alias_id,
+						int num_id)
 {
 	return 0;
 }
 
 static inline void devm_regulator_bulk_unregister_supply_alias(
-		struct device *dev, const char **id, int num_id)
+	struct device *dev, const char *const *id, int num_id)
 {
 }
 
-- 
1.8.3.2

