Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3BVNv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:51:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52440 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755061Ab3BVNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:51:23 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regmap: cache: Use regcache_get_value() to check if we updated
Date: Fri, 22 Feb 2013 13:51:18 +0000
Message-Id: <1361541078-31614-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361541078-31614-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1361541078-31614-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor things out a little.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index f0a3db6..6948996 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -418,25 +418,22 @@ EXPORT_SYMBOL_GPL(regcache_cache_bypass);
 bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
 		      unsigned int val)
 {
+	if (regcache_get_val(map, base, idx) == val)
+		return true;
+
 	switch (map->cache_word_size) {
 	case 1: {
 		u8 *cache = base;
-		if (cache[idx] == val)
-			return true;
 		cache[idx] = val;
 		break;
 	}
 	case 2: {
 		u16 *cache = base;
-		if (cache[idx] == val)
-			return true;
 		cache[idx] = val;
 		break;
 	}
 	case 4: {
 		u32 *cache = base;
-		if (cache[idx] == val)
-			return true;
 		cache[idx] = val;
 		break;
 	}
-- 
1.7.10.4

