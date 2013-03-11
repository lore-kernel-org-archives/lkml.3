Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3CKR1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:27:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39208 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063Ab3CKR1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:27:04 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: Initialize `map->debugfs' before regcache
Date: Mon, 11 Mar 2013 17:27:02 +0000
Message-Id: <1363022822-18859-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the rbtree code we are exposing statistics relating to the
number of nodes/registers of the rbtree cache for each of the
devices.  Ensure that `map->debugfs' has been initialized before
we attempt to initialize the debugfs entry for the rbtree cache.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 3d23675..50ef277 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -710,12 +710,12 @@ skip_format_initialization:
 		}
 	}
 
+	regmap_debugfs_init(map, config->name);
+
 	ret = regcache_init(map, config);
 	if (ret != 0)
 		goto err_range;
 
-	regmap_debugfs_init(map, config->name);
-
 	/* Add a devres resource for dev_get_regmap() */
 	m = devres_alloc(dev_get_regmap_release, sizeof(*m), GFP_KERNEL);
 	if (!m) {
-- 
1.8.1.5

