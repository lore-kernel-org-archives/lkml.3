Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab3FEV3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:29:43 -0400
Received: from mail.ispras.ru ([83.149.199.45]:48368 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3FEV3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:29:41 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] GFS2: minor readability improvement in gfs2_mount()
Date: Thu,  6 Jun 2013 01:29:32 +0400
Message-Id: <1370467772-4587-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch makes usage pattern of IS_ERR-PTR_ERR more typical.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/gfs2/ops_fstype.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 0262c19..0d30e8e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1313,9 +1313,10 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 	}
 	s = sget(fs_type, test_gfs2_super, set_gfs2_super, flags, bdev);
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
-	error = PTR_ERR(s);
-	if (IS_ERR(s))
+	if (IS_ERR(s)) {
+		error = PTR_ERR(s);
 		goto error_bdev;
+	}
 
 	if (s->s_root)
 		blkdev_put(bdev, mode);
-- 
1.8.1.2

