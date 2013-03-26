Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965670Ab3CZQXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:23:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53492 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934695Ab3CZPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jan Kara <jack@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 008/150] ext3: Fix format string issues
Date: Tue, 26 Mar 2013 15:18:27 +0000
Message-Id: <1364311249-14454-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 8d0c2d10dd72c5292eda7a06231056a4c972e4cc upstream.

ext3_msg() takes the printk prefix as the second parameter and the
format string as the third parameter. Two callers of ext3_msg omit the
prefix and pass the format string as the second parameter and the first
parameter to the format string as the third parameter. In both cases
this string comes from an arbitrary source. Which means the string may
contain format string characters, which will
lead to undefined and potentially harmful behavior.

The issue was introduced in commit 4cf46b67eb("ext3: Unify log messages
in ext3") and is fixed by this patch.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext3/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 8c3a44b..4da6c46 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -364,7 +364,7 @@ static struct block_device *ext3_blkdev_get(dev_t dev, struct super_block *sb)
 	return bdev;
 
 fail:
-	ext3_msg(sb, "error: failed to open journal device %s: %ld",
+	ext3_msg(sb, KERN_ERR, "error: failed to open journal device %s: %ld",
 		__bdevname(dev, b), PTR_ERR(bdev));
 
 	return NULL;
@@ -893,7 +893,7 @@ static ext3_fsblk_t get_sb_block(void **data, struct super_block *sb)
 	/*todo: use simple_strtoll with >32bit ext3 */
 	sb_block = simple_strtoul(options, &options, 0);
 	if (*options && *options != ',') {
-		ext3_msg(sb, "error: invalid sb specification: %s",
+		ext3_msg(sb, KERN_ERR, "error: invalid sb specification: %s",
 		       (char *) *data);
 		return 1;
 	}
-- 
1.8.1.2

