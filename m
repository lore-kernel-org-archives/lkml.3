Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab3JJQId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:08:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52682 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3JJPpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:45:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>, Steve French <sfrench@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 046/104] cifs: fix filp leak in cifs_atomic_open()
Date: Thu, 10 Oct 2013 08:41:34 -0700
Message-Id: <1381419752-29733-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit dfb1d61b0e9f9e2c542e9adc8d970689f4114ff6 upstream.

If an error occurs after having called finish_open() then fput() needs to
be called on the already opened file.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 8719bbe..adaee05 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -488,6 +488,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
 		cifs_del_pending_open(&open);
+		fput(file);
 		rc = -ENOMEM;
 	}
 
-- 
1.8.1.2

