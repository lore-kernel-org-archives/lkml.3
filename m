Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab3LIMNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:13:23 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:20481 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab3LIMNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:13:19 -0500
From: Rui Xiang <rui.xiang@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH RESEND 2/2] proc: set attributes of pde by accessor functions
Date: Mon, 9 Dec 2013 20:11:55 +0800
Message-ID: <1386591115-39392-2-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1386591115-39392-1-git-send-email-rui.xiang@huawei.com>
References: <1386591115-39392-1-git-send-email-rui.xiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use existing accessor proc_set_user and proc_set_size
to set attributes. Just clean up.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 fs/proc/generic.c      | 3 +--
 fs/proc/proc_devtree.c | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 737e156..2097e9e 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -49,8 +49,7 @@ static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
 	setattr_copy(inode, iattr);
 	mark_inode_dirty(inode);
 
-	de->uid = inode->i_uid;
-	de->gid = inode->i_gid;
+	proc_set_user(de, inode->i_uid, inode->i_gid);
 	de->mode = inode->i_mode;
 	return 0;
 }
diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 70779b2..c824187 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -74,9 +74,9 @@ __proc_device_tree_add_prop(struct proc_dir_entry *de, struct property *pp,
 		return NULL;
 
 	if (!strncmp(name, "security-", 9))
-		ent->size = 0; /* don't leak number of password chars */
+		proc_set_size(ent, 0); /* don't leak number of password chars */
 	else
-		ent->size = pp->length;
+		proc_set_size(ent, pp->length);
 
 	return ent;
 }
-- 
1.8.2.2


