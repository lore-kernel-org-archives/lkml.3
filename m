Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaJaM3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 08:29:32 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59059 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202AbaJaM3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 08:29:31 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, Weiwei Wang <wangww631@huawei.com>
Subject: [PATCH] ocfs2: improve code readability
Date: Fri, 31 Oct 2014 17:59:21 +0530
Message-Id: <1414758561-30022-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

code was getting confusing as the priority of both the
operators ! and & are same.
this change is done to just to improve the readability
of the code.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

hi,
i hope this is the way Weiwei Wang has thought of the logic when giving that BUG_ON,
please discard this patch if this assumption was worng.


 fs/ocfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 62620ab..1a05574 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2764,7 +2764,7 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
 		goto bail_unlock_orphan;
 	}
 
-	BUG_ON(!di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL));
+	BUG_ON(!(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL)));
 
 	/* Only delete entry if OCFS2_ORPHANED_FL not set, or
 	 * there are two entries added */
-- 
1.8.1.2

