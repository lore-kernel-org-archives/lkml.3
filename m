Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab3FCRe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:34:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33536 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3FCRez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:34:55 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regmap: assume registers are volatile iff no cache
Date: Mon,  3 Jun 2013 11:34:48 -0600
Message-Id: <1370280888-15072-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

If a regmap has a cache, it's likely that registers are not volatile,
perhaps with exceptions. Otherwise, the cache would not be useful. Encode
this assumption into regmap_volatile()'s default return value, for the
case where a regmap doesn't specify which registers are volatile.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 1a01553..feb37af 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -123,7 +123,7 @@ bool regmap_volatile(struct regmap *map, unsigned int reg)
 	if (map->volatile_table)
 		return regmap_check_range_table(map, reg, map->volatile_table);
 
-	return true;
+	return (map->cache_type == REGCACHE_NONE);
 }
 
 bool regmap_precious(struct regmap *map, unsigned int reg)
-- 
1.7.10.4

