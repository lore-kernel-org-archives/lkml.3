Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161424Ab3DGDAD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 23:00:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46005 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161345Ab3DGDAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 23:00:02 -0400
X-Spam-Score: -100.8
Message-ID: <5160E113.9080502@asianux.com>
Date: Sun, 07 Apr 2013 10:59:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Drivers: Base: Regmap: fix warnings, use %lu instead of %d
 for printf format
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  fix warnings (with EXTRA_CFLAGS=-W):
    format ‘%d’ expects argument of type ‘int’,
    but argument 4 has type ‘size_t’ [-Wformat]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/base/regmap/regcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d81f605..275a2d2 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -590,7 +590,7 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 
 	count = cur - base;
 
-	dev_dbg(map->dev, "Writing %d bytes for %d registers from 0x%x-0x%x\n",
+	dev_dbg(map->dev, "Writing %lu bytes for %d registers from 0x%x-0x%x\n",
 		count * val_bytes, count, base, cur - 1);
 
 	map->cache_bypass = 1;
-- 
1.7.7.6
