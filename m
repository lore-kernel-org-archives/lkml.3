Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750776Ab3IFEDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:03:15 -0400
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:47134 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702Ab3IFEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:03:14 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2013 00:03:13 EDT
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 2/5] Squashfs: fix corruption checks in squashfs_lookup()
Date: Fri,  6 Sep 2013 04:54:38 +0100
Message-Id: <1378439682-12830-3-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
References: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
X-MDF-HostID: 19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dir_count and size fields when read from disk are sanity
checked for correctness.  However, the sanity checks only check the
values are not greater than expected.  As dir_count and size were
incorrectly defined as signed ints, this can lead to corrupted values
appearing as negative which are not trapped.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 342a5aa..67cad77 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -147,7 +147,8 @@ static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
 	struct squashfs_dir_entry *dire;
 	u64 block = squashfs_i(dir)->start + msblk->directory_table;
 	int offset = squashfs_i(dir)->offset;
-	int err, length, dir_count, size;
+	int err, length;
+	unsigned int dir_count, size;
 
 	TRACE("Entered squashfs_lookup [%llx:%x]\n", block, offset);
 
-- 
1.8.3.2

