Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab3CMTUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:20:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48037 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933047Ab3CMTT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:19:58 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: core: Make raw write available to regcache
Date: Wed, 13 Mar 2013 19:19:55 +0000
Message-Id: <1363202395-4759-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363202395-4759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1363202395-4759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the cache to sync values directly to the device when stored
in native format and also allows asynchronous I/O.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    3 +++
 drivers/base/regmap/regmap.c   |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index f0e0ca4..9fc351f0 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -196,6 +196,9 @@ bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
 		      unsigned int val);
 int regcache_lookup_reg(struct regmap *map, unsigned int reg);
 
+int _regmap_raw_write(struct regmap *map, unsigned int reg,
+		      const void *val, size_t val_len, bool async);
+
 void regmap_async_complete_cb(struct regmap_async *async, int ret);
 
 extern struct regcache_ops regcache_rbtree_ops;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e4faed1..29ed823 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -937,8 +937,8 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 	return 0;
 }
 
-static int _regmap_raw_write(struct regmap *map, unsigned int reg,
-			     const void *val, size_t val_len, bool async)
+int _regmap_raw_write(struct regmap *map, unsigned int reg,
+		      const void *val, size_t val_len, bool async)
 {
 	struct regmap_range_node *range;
 	unsigned long flags;
-- 
1.7.10.4

