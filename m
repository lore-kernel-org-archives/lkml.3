Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbaIQI5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:57:03 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:33857 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaIQI5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:57:01 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: dhowells@redhat.com
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
        linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk
Subject: [PATCH] fs/fscache/object-list.c: use __seq_open_private()
Date: Wed, 17 Sep 2014 09:56:40 +0100
Message-Id: <1410944200-24288-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce boilerplate code by using __seq_open_private() instead of seq_open()
in fscache_objlist_open().

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---

Note that sparse generates a warning on this file but it is outside the
remit of this patch. 

Note 2, it looks to me like the sparse warning may be a false positive.

 fs/fscache/object-list.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
index b5ebc2d..a1ca2f9 100644
--- a/fs/fscache/object-list.c
+++ b/fs/fscache/object-list.c
@@ -380,26 +380,14 @@ no_config:
 static int fscache_objlist_open(struct inode *inode, struct file *file)
 {
 	struct fscache_objlist_data *data;
-	struct seq_file *m;
-	int ret;
 
-	ret = seq_open(file, &fscache_objlist_ops);
-	if (ret < 0)
-		return ret;
-
-	m = file->private_data;
-
-	/* buffer for key extraction */
-	data = kmalloc(sizeof(struct fscache_objlist_data), GFP_KERNEL);
-	if (!data) {
-		seq_release(inode, file);
+	data = __seq_open_private(file, &fscache_objlist_ops, sizeof(*data));
+	if (!data)
 		return -ENOMEM;
-	}
 
 	/* get the configuration key */
 	fscache_objlist_config(data);
 
-	m->private = data;
 	return 0;
 }
 
-- 
1.7.10.4

