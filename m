Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaBYNyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:54:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50477 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbaBYNyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:54:07 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 1/4] regmap: Mark reg_defaults in regmap_multi_reg_write as const
Date: Tue, 25 Feb 2014 13:45:49 +0000
Message-Id: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no need for the writes supplied to this function to be
edited by it so mark them as const.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    4 ++--
 include/linux/regmap.h       |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 2b4e72f..1ebc6df 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1607,8 +1607,8 @@ EXPORT_SYMBOL_GPL(regmap_bulk_write);
  * A value of zero will be returned on success, a negative errno will
  * be returned in error cases.
  */
-int regmap_multi_reg_write(struct regmap *map, struct reg_default *regs,
-				int num_regs)
+int regmap_multi_reg_write(struct regmap *map, const struct reg_default *regs,
+			   int num_regs)
 {
 	int ret = 0, i;
 
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index fa4d079..ccb2ed0 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -388,7 +388,7 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len);
 int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 			size_t val_count);
-int regmap_multi_reg_write(struct regmap *map, struct reg_default *regs,
+int regmap_multi_reg_write(struct regmap *map, const struct reg_default *regs,
 			int num_regs);
 int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 			   const void *val, size_t val_len);
-- 
1.7.2.5

