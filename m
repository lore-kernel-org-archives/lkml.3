Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3AZKBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:01:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35748 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052Ab3AZKB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:01:29 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <v-stehle@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: debugfs: Work around GCC flow analysis false positives
Date: Sat, 26 Jan 2013 18:01:18 +0800
Message-Id: <1359194478-31666-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Vincent Stehlé <v-stehle@ti.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index d9a6c94..c6dc2e9 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -133,6 +133,13 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 		return base;
 	}
 
+	/*
+	 * Work around GCC flow analysis - it can't figure out we have
+	 * at least one loop iteration.
+	 */
+	*pos = c->min;
+	ret = c->base_reg;
+
 	/* Find the relevant block */
 	list_for_each_entry(c, &map->debugfs_off_cache, list) {
 		if (from >= c->min && from <= c->max) {
-- 
1.7.10.4

