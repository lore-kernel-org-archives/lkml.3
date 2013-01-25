Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab3AYOPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:15:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57632 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3AYOPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:15:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 11/19] regmap: avoid undefined return from regmap_read_debugfs
Date: Fri, 25 Jan 2013 14:14:28 +0000
Message-Id: <1359123276-15833-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:kZTXcQz3aWdaiZWGqfGNk6j2S9yvK9i0rDqBr9X8CHF
 E9xd1KrHcu1iU1EwVV8DrpsLb6bCaG4mAbasRDLOTYK3Kndrk3
 A1daxj1Kgg9xQxud4xyku0o9ePz6+TgadN4Wy8yUHzCyaRUqrI
 2+9yGvii9K2APc9vEZUCzu0CBogAc+J9j4RGb9xQ5Dk3YNDEMi
 tLdgwqbvjudlqVt4GHgm3ujHHRLdLnepm7RNtZ8CWiUo7NWMH5
 3pjKOxBsxEK/+6mtC8CWbRmKsGJ+Gc0PghirOhHv75bJsxW8SS
 ESCWN9nbWaBpMtY9+AoUUYV9uG3ksFgXRA6Q4YASAVtQrPARjX
 eZZlaRvUGc7RknFwUHTXisFwz3I0r47YfN3B10hcT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc warns about the case where regmap_read_debugfs tries
to walk an empty map->debugfs_off_cache list, which results
in uninitialized variable getting returned.

Setting this variable to 0 first avoids the warning and
the potentially undefined value.

Without this patch, building mxs_defconfig results in:

drivers/base/regmap/regmap-debugfs.c: In function 'regmap_read_debugfs':
drivers/base/regmap/regmap-debugfs.c:147:9: : warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 46a213a..31cc656 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -80,7 +80,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 {
 	struct regmap_debugfs_off_cache *c = NULL;
 	loff_t p = 0;
-	unsigned int i, ret;
+	unsigned int i, ret = 0;
 
 	/*
 	 * If we don't have a cache build one so we don't have to do a
-- 
1.8.0

