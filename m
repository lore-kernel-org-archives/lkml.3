Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763358Ab3DDQkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:40:55 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:40152 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762912Ab3DDQky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:40:54 -0400
Message-ID: <515DAD0D.1010806@semaphore.gr>
Date: Thu, 04 Apr 2013 19:40:45 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] regmap: cache: Fix format specifier in dev_dbg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format specifier in dev_dbg and suppress the following warning

drivers/base/regmap/regcache.c: In function
‘regcache_sync_block_raw_flush’:
drivers/base/regmap/regcache.c:593:2: warning: format ‘%d’ expects
argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat]

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/base/regmap/regcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d81f605..a469748 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -590,7 +590,7 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 
 	count = cur - base;
 
-	dev_dbg(map->dev, "Writing %d bytes for %d registers from 0x%x-0x%x\n",
+	dev_dbg(map->dev, "Writing %zu bytes for %d registers from 0x%x-0x%x\n",
 		count * val_bytes, count, base, cur - 1);
 
 	map->cache_bypass = 1;
-- 
1.8.1.4

