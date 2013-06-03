Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527Ab3FCRG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:06:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45862 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268Ab3FCRGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:06:55 -0400
From: Mark Brown <broonie@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@linaro.org>
Date: Mon,  3 Jun 2013 18:06:31 +0100
Message-Id: <1370279191-15721-1-git-send-email-broonie@linaro.org>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: core: Cache all registers by default when cache is enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all register maps with a cache need to provide a volatile
callback since the default is to assume all registers are volatile.
This is not sensible if we have a cache so change the default to be
fully cached if a cache is provided.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 1a01553..ed152e3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -123,7 +123,10 @@ bool regmap_volatile(struct regmap *map, unsigned int reg)
 	if (map->volatile_table)
 		return regmap_check_range_table(map, reg, map->volatile_table);
 
-	return true;
+	if (map->cache_ops)
+		return false;
+	else
+		return true;
 }
 
 bool regmap_precious(struct regmap *map, unsigned int reg)
-- 
1.7.10.4

