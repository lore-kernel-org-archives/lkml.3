Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaBJTnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:43:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaBJTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:43:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 092/124] Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()
Date: Mon, 10 Feb 2014 11:40:32 -0800
Message-Id: <1392061264-28124-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

commit 90515e7f5d7d24cbb2a4038a3f1b5cfa2921aa17 upstream.

We may return early in btrfs_drop_snapshot(), we shouldn't
call btrfs_std_err() for this case, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aa8acfa..ce5da61 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7153,7 +7153,7 @@ out:
 	 */
 	if (root_dropped == false)
 		btrfs_add_dead_root(root);
-	if (err)
+	if (err && err != -EAGAIN)
 		btrfs_std_error(root->fs_info, err);
 	return err;
 }
-- 
1.8.3.2

