Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbaH0MJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:09:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35939 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaH0MJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:09:50 -0400
From: Mark Brown <broonie@kernel.org>
To: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Wed, 27 Aug 2014 13:09:39 +0100
Message-Id: <1409141379-18946-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: Don't attempt block writes when syncing cache on single_rw devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

If the device can't support block writes then don't attempt to use raw
syncing which will automatically generate block writes for adjacent
registers, use the existing _single() block syncing implementation.

Reported-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 29b4128da0b0..5617da6dc898 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -698,7 +698,7 @@ int regcache_sync_block(struct regmap *map, void *block,
 			unsigned int block_base, unsigned int start,
 			unsigned int end)
 {
-	if (regmap_can_raw_write(map))
+	if (regmap_can_raw_write(map) && !map->use_single_rw)
 		return regcache_sync_block_raw(map, block, cache_present,
 					       block_base, start, end);
 	else
-- 
2.1.0

