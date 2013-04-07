Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419Ab3DGVWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 17:22:17 -0400
Received: from mail.ispras.ru ([83.149.199.45]:60044 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934402Ab3DGVWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 17:22:15 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 2/2] hfsplus: add printk to log allocation failure in hfs_find_init()
Date: Mon,  8 Apr 2013 01:21:35 +0400
Message-Id: <1365369695-8340-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365369695-8340-1-git-send-email-khoroshilov@ispras.ru>
References: <0199BA74-9971-4928-A133-DB1FC562DC43@dubeyko.com>
 <1365369695-8340-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add printk to log allocation failure in hfs_find_init(),
"so that there is a sign in dmesg when the error condition is triggered".
(per Hin-Tak Leung request)

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/hfsplus/bfind.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/hfsplus/bfind.c b/fs/hfsplus/bfind.c
index d73c98d..067ddb5 100644
--- a/fs/hfsplus/bfind.c
+++ b/fs/hfsplus/bfind.c
@@ -18,8 +18,10 @@ int hfs_find_init(struct hfs_btree *tree, struct hfs_find_data *fd)
 	fd->tree = tree;
 	fd->bnode = NULL;
 	ptr = kmalloc(tree->max_key_len * 2 + 4, GFP_KERNEL);
-	if (!ptr)
+	if (!ptr) {
+		printk(KERN_ERR "hfs: allocation failed in hfs_find_init()\n");
 		return -ENOMEM;
+	}
 	fd->search_key = ptr;
 	fd->key = ptr + tree->max_key_len + 2;
 	dprint(DBG_BNODE_REFS, "find_init: %d (%p)\n",
-- 
1.7.9.5

