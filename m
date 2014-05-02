Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaEBPqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:46:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44292 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaEBPqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Chen <alex.chen@huawei.com>, Mark Fasheh <mfasheh@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 128/151] ocfs2: do not put bh when buffer_uptodate failed
Date: Fri,  2 May 2014 08:38:36 -0700
Message-Id: <1399045139-4531-129-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: alex chen <alex.chen@huawei.com>

commit f7cf4f5bfe073ad792ab49c04f247626b3e38db6 upstream.

Do not put bh when buffer_uptodate failed in ocfs2_write_block and
ocfs2_write_super_or_backup, because it will put bh in b_end_io.
Otherwise it will hit a warning "VFS: brelse: Trying to free free
buffer".

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ocfs2/buffer_head_io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 5b704c6..1edcb14 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -90,7 +90,6 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 		 * information for this bh as it's not marked locally
 		 * uptodate. */
 		ret = -EIO;
-		put_bh(bh);
 		mlog_errno(ret);
 	}
 
@@ -420,7 +419,6 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 
 	if (!buffer_uptodate(bh)) {
 		ret = -EIO;
-		put_bh(bh);
 		mlog_errno(ret);
 	}
 
-- 
1.9.1

