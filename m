Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3EFPGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:06:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42477 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755061Ab3EFPGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:06:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regcache: Always make cache_present big enough for max_register
Date: Mon,  6 May 2013 16:06:08 +0100
Message-Id: <1367852768-31389-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in continually reallocating the cache_present bitmap
when we know how big it could possibly be.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 8a0ab5f..14c6eef 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -463,6 +463,9 @@ int regcache_set_reg_present(struct regmap *map, unsigned int reg)
 	int i;
 
 	nregs = reg + 1;
+	if (nregs < map->max_register + 1)
+		nregs = map->max_register + 1;
+
 	cache_present_size = BITS_TO_LONGS(nregs);
 	cache_present_size *= sizeof(long);
 
-- 
1.7.10.4

