Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaAUN6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:58:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbaAUN6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:58:15 -0500
From: Florian Weimer <fweimer@redhat.com>
Date: Mon, 20 Jan 2014 15:15:10 +0100
Subject: [PATCH 1/3] vfs: Introduce XATTR_SET_MASK
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Message-Id: <20140121135811.1754B401159C7@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used to separate the xattr operations from the AT_* flags.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Florian Weimer <fweimer@redhat.com>
---
 fs/xattr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 3377dff..9e44641 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -24,6 +24,8 @@
 
 #include <asm/uaccess.h>
 
+#define XATTR_SET_MASK (XATTR_CREATE | XATTR_REPLACE)
+
 /*
  * Check permissions for extended attribute access.  This is a bit complicated
  * because different namespaces have very different rules.
@@ -327,7 +329,7 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
 	void *vvalue = NULL;	/* If non-NULL, we used vmalloc() */
 	char kname[XATTR_NAME_MAX + 1];
 
-	if (flags & ~(XATTR_CREATE|XATTR_REPLACE))
+	if (flags & ~XATTR_SET_MASK)
 		return -EINVAL;
 
 	error = strncpy_from_user(kname, name, sizeof(kname));
-- 
1.8.3.1

