Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaEBPyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:54:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44257 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaEBPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 129/151] ocfs2: fix panic on kfree(xattr->name)
Date: Fri,  2 May 2014 08:38:37 -0700
Message-Id: <1399045139-4531-130-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit f81c20158f8d5f7938d5eb86ecc42ecc09273ce6 upstream.

Commit 9548906b2bb7 ('xattr: Constify ->name member of "struct xattr"')
missed that ocfs2 is calling kfree(xattr->name).  As a result, kernel
panic occurs upon calling kfree(xattr->name) because xattr->name refers
static constant names.  This patch removes kfree(xattr->name) from
ocfs2_mknod() and ocfs2_symlink().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Tested-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ocfs2/namei.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 4f791f6..2baabab 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -430,7 +430,6 @@ leave:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.name);
 	kfree(si.value);
 
 	ocfs2_free_dir_lookup_result(&lookup);
@@ -1818,7 +1817,6 @@ bail:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.name);
 	kfree(si.value);
 	ocfs2_free_dir_lookup_result(&lookup);
 	if (inode_ac)
-- 
1.9.1

