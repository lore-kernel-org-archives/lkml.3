Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaFZTmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:42:09 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50557 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaFZTmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:42:07 -0400
Date: Fri, 27 Jun 2014 01:11:59 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr, Joe Perches <joe@perches.com>
Subject: [PATCH v2] ecryptfs: Drop cast
Message-ID: <20140626194159.GA7163@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does away with cast on void * and the if as it is unnecessary.

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
---
v2: remove the if statement
 fs/ecryptfs/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 4d6c7e4..e67f9f0 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -53,9 +53,7 @@ static void unlock_dir(struct dentry *dir)
 
 static int ecryptfs_inode_test(struct inode *inode, void *lower_inode)
 {
-	if (ecryptfs_inode_to_lower(inode) == (struct inode *)lower_inode)
-		return 1;
-	return 0;
+	return ecryptfs_inode_to_lower(inode) == lower_inode;
 }
 
 static int ecryptfs_inode_set(struct inode *inode, void *opaque)
-- 
1.9.1

