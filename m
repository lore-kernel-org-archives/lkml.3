Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaF1NdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:33:09 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61417 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaF1NdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:33:08 -0400
Date: Sat, 28 Jun 2014 19:03:02 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ntfs: Drop cast
Message-ID: <20140628133302.GA4722@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the cast on data of type void * as it is not needed.
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
 fs/ntfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index f47af5e..b3c55fc 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1817,7 +1817,7 @@ int ntfs_read_inode_mount(struct inode *vi)
 	i = vol->mft_record_size;
 	if (i < sb->s_blocksize)
 		i = sb->s_blocksize;
-	m = (MFT_RECORD*)ntfs_malloc_nofs(i);
+	m = ntfs_malloc_nofs(i);
 	if (!m) {
 		ntfs_error(sb, "Failed to allocate buffer for $MFT record 0.");
 		goto err_out;
-- 
1.9.1

