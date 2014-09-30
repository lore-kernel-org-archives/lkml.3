Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaI3Vnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:43:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32931 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaI3VjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 090/103] regmap: Don't attempt block writes when syncing cache on single_rw devices
Date: Tue, 30 Sep 2014 14:31:35 -0700
Message-Id: <1412112708-27356-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 5c1ebe7f73f9166893c3459915db8a09d6d1d715 upstream.

If the device can't support block writes then don't attempt to use raw
syncing which will automatically generate block writes for adjacent
registers, use the existing _single() block syncing implementation.

Reported-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/regmap/regcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d4dd771..154e7a8 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -701,7 +701,7 @@ int regcache_sync_block(struct regmap *map, void *block,
 			unsigned int block_base, unsigned int start,
 			unsigned int end)
 {
-	if (regmap_can_raw_write(map))
+	if (regmap_can_raw_write(map) && !map->use_single_rw)
 		return regcache_sync_block_raw(map, block, cache_present,
 					       block_base, start, end);
 	else
-- 
1.9.1

