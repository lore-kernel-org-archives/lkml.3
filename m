Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab3DGJdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:33:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:39076 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947Ab3DGJdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:33:08 -0400
X-Spam-Score: -100.8
Message-ID: <51613D37.6060901@asianux.com>
Date: Sun, 07 Apr 2013 17:32:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Drivers: Base: Regmap: fix warnings, use %zu instead of
 %d for printf format
References: <5160E113.9080502@asianux.com> <8761zybtdg.fsf@nemi.mork.no> <51613B16.3030406@asianux.com>
In-Reply-To: <51613B16.3030406@asianux.com>
Content-Type: text/plain; charset=UTF-8
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
1.7.7.6
