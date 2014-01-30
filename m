Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaA3N0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:26:40 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:31663 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753255AbaA3N0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:26:38 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] regmap: debugfs: "registers" & "access" for single register maps
Date: Thu, 30 Jan 2014 13:26:32 +0000
Message-Id: <1391088392-6504-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a map covers a single register, max_register is equal
to 0, so the "registers" & "access" files were not created.
Now they will be, as register 0 must be readable for such
map to make sense.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/base/regmap/regmap-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index c5471cd..45d812c 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -511,7 +511,7 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	debugfs_create_file("range", 0400, map->debugfs,
 			    map, &regmap_reg_ranges_fops);
 
-	if (map->max_register) {
+	if (map->max_register || regmap_readable(map, 0)) {
 		debugfs_create_file("registers", 0400, map->debugfs,
 				    map, &regmap_map_fops);
 		debugfs_create_file("access", 0400, map->debugfs,
-- 
1.8.3.2

