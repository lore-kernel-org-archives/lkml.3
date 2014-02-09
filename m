Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaBINJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:09:17 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53144 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBINJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:09:16 -0500
Date: Sun, 9 Feb 2014 18:39:11 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 09/21] fs: Mark function as static in ext3/xattr_security.c
Message-ID: <bcf66d9631e4094a46e539950331f79289e4d85a.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in ext3/xattr_security.c because it is not used
outside this file.

This eliminates the following warning in ext3/xattr_security.c:
fs/ext3/xattr_security.c:46:5: warning: no previous prototype for ‘ext3_initxattrs’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ext3/xattr_security.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 3387664..722c2bf 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -43,8 +43,9 @@ ext3_xattr_security_set(struct dentry *dentry, const char *name,
 			      name, value, size, flags);
 }
 
-int ext3_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		    void *fs_info)
+static int ext3_initxattrs(struct inode *inode,
+			   const struct xattr *xattr_array,
+			   void *fs_info)
 {
 	const struct xattr *xattr;
 	handle_t *handle = fs_info;
-- 
1.7.9.5

