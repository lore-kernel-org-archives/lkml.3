Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731Ab3HNJvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:51:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49843 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab3HNJvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:51:18 -0400
Date: Wed, 14 Aug 2013 12:51:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] bfs: iget_locked() doesn't return an ERR_PTR
Message-ID: <20130814095103.GG521@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iget_locked() returns a NULL on error, it doesn't return an ERR_PTR.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 5e376bb..8defc6b 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -40,7 +40,7 @@ struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 	int block, off;
 
 	inode = iget_locked(sb, ino);
-	if (IS_ERR(inode))
+	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
 		return inode;
