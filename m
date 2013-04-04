Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3DDJSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:18:05 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:64392 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab3DDJSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:18:04 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        sachin.kamat@linaro.org
Subject: [PATCH 1/1] regmap: cache: Make regcache_sync_block_raw static
Date: Thu,  4 Apr 2013 14:36:18 +0530
Message-Id: <1365066378-3384-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regcache_sync_block_raw is used only in this file. Hence make it static.
Silences the following warning:
drivers/base/regmap/regcache.c:608:5: warning:
symbol 'regcache_sync_block_raw' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/base/regmap/regcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d81f605..3ae8d9b 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -605,7 +605,7 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 	return ret;
 }
 
-int regcache_sync_block_raw(struct regmap *map, void *block,
+static int regcache_sync_block_raw(struct regmap *map, void *block,
 			    unsigned int block_base, unsigned int start,
 			    unsigned int end)
 {
-- 
1.7.9.5

