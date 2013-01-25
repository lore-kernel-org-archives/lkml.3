Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3AYWqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:46:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3AYWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 11/19] regmap: avoid undefined return from regmap_read_debugfs
Date: Fri, 25 Jan 2013 22:44:10 +0000
Message-Id: <1359153858-31992-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:RL0RXTAA947puTDcEOtfSAJdeREYecDeYVbhuJF3RqV
 vSVIv/gFddBXSbMms7Vu76qkrm69bjlxGc8p40uSV61L9kp5AI
 wVJBqF138JcNLnAAmbasHvrCHv9Q2zfUBDUQHIMYXCwVwluQqZ
 qbc+XjJFf5F388yhC4QPSzrdNqPwZ8kIH8e6hyXjowLdVLIlv4
 mUxenrkSiUpo/gZx8D22Pu7XILrkCRPj6iymKeBVCtqSspNtMH
 q9+ZoqgtYzPZa7fu4S3HlZiHbfqXSxdgbM9Cp80Xlq4pvE+Uq5
 iry75LDZ2bUc45MB6iZapFZgvSlbu0QBhKRQeHRhiRSv+73G7C
 UDRL7aKR0eGNj9QSXcHwZUMDjHZ/ucPtJ11LNQFw9
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

