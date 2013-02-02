Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab3BBQOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:14:37 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61464 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3BBQOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:14:35 -0500
Message-ID: <1359821653.26710.1.camel@phoenix>
Subject: [PATCH] regmap: Export regmap_async_complete_cb
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 03 Feb 2013 00:14:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error when CONFIG_REGMAP=y && CONFIG_REGMAP_SPI=m

ERROR: "regmap_async_complete_cb" [drivers/base/regmap/regmap-spi.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/base/regmap/regmap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bee8560..9a516b8b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1655,6 +1655,7 @@ void regmap_async_complete_cb(struct regmap_async *async, int ret)
 	if (wake)
 		wake_up(&map->async_waitq);
 }
+EXPORT_SYMBOL_GPL(regmap_async_complete_cb);
 
 static int regmap_async_is_done(struct regmap *map)
 {
-- 
1.7.9.5



