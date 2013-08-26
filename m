Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3HZIwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:52:41 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:21082 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3HZIwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:52:39 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: David Howells <dhowells@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 1/2] proc: set attributes of pde by accessor functions
Date: Mon, 26 Aug 2013 16:51:51 +0800
Message-ID: <1377507112-48288-1-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up.

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
index 106a835..b38b822 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -77,9 +77,9 @@ __proc_device_tree_add_prop(struct proc_dir_entry *de, struct property *pp,
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


