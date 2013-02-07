Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3BGKwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:52:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55255 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757693Ab3BGKv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:51:59 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] regmap: debugfs: Fix reading in register field units
Date: Thu,  7 Feb 2013 10:51:56 +0000
Message-Id: <1360234316-8749-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment, if the length of the register field format is
N bytes, we can only get anything meaningful back to userspace
by providing a buffer that is N + 2 bytes large.  Fix this
so we that we only need to provide a buffer of N bytes.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 0445f2f..96990d2 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -187,7 +187,7 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 		/* If we're in the region the user is trying to read */
 		if (p >= *ppos) {
 			/* ...but not beyond it */
-			if (buf_pos + 1 + map->debugfs_tot_len >= count)
+			if (buf_pos + map->debugfs_tot_len > count)
 				break;
 
 			/* Format the register */
-- 
1.8.1.2

