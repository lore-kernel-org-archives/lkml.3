Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3K0BKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:10:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856Ab3K0A7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.12 114/116] GFS2: d_splice_alias() cant return error
Date: Tue, 26 Nov 2013 16:58:07 -0800
Message-Id: <20131127005744.823854010@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 0d0d110720d7960b77c03c9f2597faaff4b484ae upstream.

unless it was given an IS_ERR(inode), which isn't the case here.  So clean
up the unnecessary error handling in gfs2_create_inode().

This paves the way for real fixes (hence the stable Cc).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -584,7 +584,7 @@ static int gfs2_create_inode(struct inod
 	if (!IS_ERR(inode)) {
 		d = d_splice_alias(inode, dentry);
 		error = 0;
-		if (file && !IS_ERR(d)) {
+		if (file) {
 			if (d == NULL)
 				d = dentry;
 			if (S_ISREG(inode->i_mode))
@@ -593,8 +593,6 @@ static int gfs2_create_inode(struct inod
 				error = finish_no_open(file, d);
 		}
 		gfs2_glock_dq_uninit(ghs);
-		if (IS_ERR(d))
-			return PTR_ERR(d);
 		return error;
 	} else if (error != -ENOENT) {
 		goto fail_gunlock;


