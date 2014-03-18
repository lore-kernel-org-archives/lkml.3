Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbaCRUpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:45:34 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:40386 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaCRUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:45:31 -0400
From: Dylan Reid <dgreid@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, Dylan Reid <dgreid@chromium.org>
Subject: [PATCH 1/2] regmap: cache: Step by stride in default sync.
Date: Tue, 18 Mar 2014 13:45:08 -0700
Message-Id: <1395175509-19113-1-git-send-email-dgreid@chromium.org>
X-Mailer: git-send-email 1.8.1.3.605.g02339dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default sync operation was still assuming a stride of one, fix it
to respect the reg_stride set in the map.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
---
 drivers/base/regmap/regcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index c6b1ac1..44af125 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -249,7 +249,7 @@ static int regcache_default_sync(struct regmap *map, unsigned int min,
 {
 	unsigned int reg;
 
-	for (reg = min; reg <= max; reg++) {
+	for (reg = min; reg <= max; reg += map->reg_stride) {
 		unsigned int val;
 		int ret;
 
-- 
1.8.1.3.605.g02339dd

