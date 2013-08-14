Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688Ab3HNLwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:52:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39640 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3HNLwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:52:34 -0400
Date: Wed, 14 Aug 2013 14:52:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] pstore: d_alloc_name() doesn't return an ERR_PTR
Message-ID: <20130814115218.GC8044@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_alloc_name() returns NULL on error.  Also I changed the error code
from -ENOSPC to -ENOMEM to reflect that we were short on RAM not disk
space.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 71bf5f4..6a4123d 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -345,9 +345,8 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 
 	mutex_lock(&root->d_inode->i_mutex);
 
-	rc = -ENOSPC;
 	dentry = d_alloc_name(root, name);
-	if (IS_ERR(dentry))
+	if (!dentry)
 		goto fail_lockedalloc;
 
 	memcpy(private->data, data, size);
