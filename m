Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaFZSnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:43:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50483 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaFZSnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:43:02 -0400
Date: Fri, 27 Jun 2014 00:12:33 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ecryptfs: Drop cast
Message-ID: <20140626184233.GA4275@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does away with casts on void * as they are unnecessary.

The following Coccinelle semantic patch was used for making the change:

@r@
expression x;
void* e;
type T;
identifier f;
@@

(
  *((T *)e)
|
  ((T *)x)[...]
|
  ((T *)x)->f
|
- (T *)
  e
)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 fs/ecryptfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 4d6c7e4..5459792 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -53,7 +53,7 @@ static void unlock_dir(struct dentry *dir)
 
 static int ecryptfs_inode_test(struct inode *inode, void *lower_inode)
 {
-	if (ecryptfs_inode_to_lower(inode) == (struct inode *)lower_inode)
+	if (ecryptfs_inode_to_lower(inode) == lower_inode)
 		return 1;
 	return 0;
 }
-- 
1.9.1

