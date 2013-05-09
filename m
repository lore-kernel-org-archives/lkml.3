Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3EILqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:46:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35158 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345Ab3EILqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:46:44 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] regmap: debugfs: Check return value of regmap_write()
Date: Thu,  9 May 2013 12:46:41 +0100
Message-Id: <1368100001-14900-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 6cd1b78a..ee81635 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -265,6 +265,7 @@ static ssize_t regmap_map_write_file(struct file *file,
 	char *start = buf;
 	unsigned long reg, value;
 	struct regmap *map = file->private_data;
+	int ret;
 
 	buf_size = min(count, (sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
@@ -282,7 +283,9 @@ static ssize_t regmap_map_write_file(struct file *file,
 	/* Userspace has been fiddling around behind the kernel's back */
 	add_taint(TAINT_USER, LOCKDEP_NOW_UNRELIABLE);
 
-	regmap_write(map, reg, value);
+	ret = regmap_write(map, reg, value);
+	if (ret < 0)
+		return ret;
 	return buf_size;
 }
 #else
-- 
1.8.2.2

