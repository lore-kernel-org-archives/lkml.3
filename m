Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaEDPoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:44:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbaEDPnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:43:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Chen <alex.chen@huawei.com>, Joseph Qi <joseph.qi@huawei.com>,
        Srinivas Eeda <srinivas.eeda@oracle.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 41/43] ocfs2: do not put bh when buffer_uptodate failed
Date: Sun,  4 May 2014 11:42:35 -0400
Message-Id: <20140504154229.834633765@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/buffer_head_io.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -90,7 +90,6 @@ int ocfs2_write_block(struct ocfs2_super
 		 * information for this bh as it's not marked locally
 		 * uptodate. */
 		ret = -EIO;
-		put_bh(bh);
 		mlog_errno(ret);
 	}
 
@@ -420,7 +419,6 @@ int ocfs2_write_super_or_backup(struct o
 
 	if (!buffer_uptodate(bh)) {
 		ret = -EIO;
-		put_bh(bh);
 		mlog_errno(ret);
 	}
 


