Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbbA2Kw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:52:26 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41273 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770AbbA2KwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:52:23 -0500
Date: Thu, 29 Jan 2015 19:49:35 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mfasheh@suse.com
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ocfs2: removes mlog_errno() call twice in
 ocfs2_find_dir_space_el()
Message-ID: <20150129104935.GA6089@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mlog_errno() function is called twice when some functions are
failed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/dir.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 940be6d..b08050b 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3456,10 +3456,8 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 	int blocksize = dir->i_sb->s_blocksize;
 
 	status = ocfs2_read_dir_block(dir, 0, &bh, 0);
-	if (status) {
-		mlog_errno(status);
+	if (status)
 		goto bail;
-	}
 
 	rec_len = OCFS2_DIR_REC_LEN(namelen);
 	offset = 0;
@@ -3480,10 +3478,9 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 			status = ocfs2_read_dir_block(dir,
 					     offset >> sb->s_blocksize_bits,
 					     &bh, 0);
-			if (status) {
-				mlog_errno(status);
+			if (status)
 				goto bail;
-			}
+
 			/* move to next block */
 			de = (struct ocfs2_dir_entry *) bh->b_data;
 		}
-- 
1.7.1

