Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422753Ab3LFW1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:27:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161142Ab3LFVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.12 78/83] aio: checking for NULL instead of IS_ERR
Date: Fri,  6 Dec 2013 13:52:08 -0800
Message-Id: <20131206214647.290501892@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7f62656be8a8ef14c168db2d98021fb9c8cc1076 upstream.

alloc_anon_inode() returns an ERR_PTR(), it doesn't return NULL.

Fixes: 71ad7490c1f3 ('rework aio migrate pages to use aio fs')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -164,8 +164,8 @@ static struct file *aio_private_file(str
 	struct file *file;
 	struct path path;
 	struct inode *inode = alloc_anon_inode(aio_mnt->mnt_sb);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
 	inode->i_mapping->a_ops = &aio_ctx_aops;
 	inode->i_mapping->private_data = ctx;


