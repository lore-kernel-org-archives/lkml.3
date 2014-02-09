Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaBINGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:06:34 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41283 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaBINGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:06:32 -0500
Date: Sun, 9 Feb 2014 18:36:27 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 08/21] fs: Mark function as static in ext3/dir.c
Message-ID: <999693f220bb65e2a07c4450548d99ea3ceac9d2.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in ext3/dir.c because it is not used outside
this file.

This also eliminates the following warning in ext3/dir.c:
fs/ext3/dir.c:278:8: warning: no previous prototype for ‘ext3_dir_llseek’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ext3/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index e66e480..17742ee 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -275,7 +275,7 @@ static inline loff_t ext3_get_htree_eof(struct file *filp)
  * NOTE: offsets obtained *before* ext3_set_inode_flag(dir, EXT3_INODE_INDEX)
  *       will be invalid once the directory was converted into a dx directory
  */
-loff_t ext3_dir_llseek(struct file *file, loff_t offset, int whence)
+static loff_t ext3_dir_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
 	int dx_dir = is_dx_dir(inode);
-- 
1.7.9.5

