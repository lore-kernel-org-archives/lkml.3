Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab3CMTT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:19:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48036 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024Ab3CMTT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:19:58 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: core: Warn on invalid operation combinations
Date: Wed, 13 Mar 2013 19:19:54 +0000
Message-Id: <1363202395-4759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't grind to a screaming halt, just generate a warning.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index fed91ac..e4faed1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -950,7 +950,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	size_t len;
 	int i;
 
-	BUG_ON(!map->bus);
+	WARN_ON(!map->bus);
 
 	/* Check for unwritable registers before we start */
 	if (map->writeable_reg)
@@ -1106,7 +1106,7 @@ static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 	struct regmap_range_node *range;
 	struct regmap *map = context;
 
-	BUG_ON(!map->bus || !map->format.format_write);
+	WARN_ON(!map->bus || !map->format.format_write);
 
 	range = _regmap_range_lookup(map, reg);
 	if (range) {
@@ -1132,7 +1132,7 @@ static int _regmap_bus_raw_write(void *context, unsigned int reg,
 {
 	struct regmap *map = context;
 
-	BUG_ON(!map->bus || !map->format.format_val);
+	WARN_ON(!map->bus || !map->format.format_val);
 
 	map->format.format_val(map->work_buf + map->format.reg_bytes
 			       + map->format.pad_bytes, val, 0);
@@ -1358,7 +1358,7 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	u8 *u8 = map->work_buf;
 	int ret;
 
-	BUG_ON(!map->bus);
+	WARN_ON(!map->bus);
 
 	range = _regmap_range_lookup(map, reg);
 	if (range) {
@@ -1413,7 +1413,7 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	int ret;
 	void *context = _regmap_map_get_context(map);
 
-	BUG_ON(!map->reg_read);
+	WARN_ON(!map->reg_read);
 
 	if (!map->cache_bypass) {
 		ret = regcache_read(map, reg, val);
-- 
1.7.10.4

