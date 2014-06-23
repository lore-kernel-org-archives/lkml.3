Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaFWBff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:35:35 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49306 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaFWBfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:35:33 -0400
Message-ID: <53A7845F.40404@gmail.com>
Date: Mon, 23 Jun 2014 09:35:27 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, anton@tuxera.com
CC: linux-ntfs-dev@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>,
        "lennox.wu@gmail.com >> Lennox Wu" <lennox.wu@gmail.com>
Subject: [PATCH] fs/ntfs: Use '%tx' instead of '%zx'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For subtraction between 2 pointers, the result's type is 'ptrdiff_t', so
need use '%tx' instead of '%zx'.

The related warning (allmodconfig under unicore32):

    CC [M]  fs/ntfs/compress.o
  fs/ntfs/compress.c: In function 'ntfs_decompress':
  fs/ntfs/compress.c:207:2: warning: format '%zx' expects argument of type 'size_t', but argument 5 has type 'long int' [-Wformat=]
    ntfs_debug("Beginning sub-block at offset = 0x%zx in the cb.",
    ^
    CC [M]  fs/ntfs/dir.o
  fs/ntfs/dir.c: In function 'ntfs_readdir':
  fs/ntfs/dir.c:1197:3: warning: format '%zx' expects argument of type 'size_t', but argument 5 has type 'long int' [-Wformat=]
     ntfs_debug("In index root, offset 0x%zx.", (u8*)ie - (u8*)ir);
     ^

Also let the related code match linux kernel styles which is found by
'scripts/checkpatch.pl'.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 fs/ntfs/compress.c | 2 +-
 fs/ntfs/dir.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index f82498c..2ba8280 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -204,7 +204,7 @@ static int ntfs_decompress(struct page *dest_pages[], int *dest_index,
 
 	ntfs_debug("Entering, cb_size = 0x%x.", cb_size);
 do_next_sb:
-	ntfs_debug("Beginning sub-block at offset = 0x%zx in the cb.",
+	ntfs_debug("Beginning sub-block at offset = 0x%tx in the cb.",
 			cb - cb_start);
 	/*
 	 * Have we reached the end of the compression block or the end of the
diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index 9e38daf..2d3c32d 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -1194,7 +1194,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *actor)
 	 * or signals an error (both covered by the rc test).
 	 */
 	for (;; ie = (INDEX_ENTRY*)((u8*)ie + le16_to_cpu(ie->length))) {
-		ntfs_debug("In index root, offset 0x%zx.", (u8*)ie - (u8*)ir);
+		ntfs_debug("In index root, offset 0x%tx.", (u8 *)ie - (u8 *)ir);
 		/* Bounds checks. */
 		if (unlikely((u8*)ie < (u8*)ir || (u8*)ie +
 				sizeof(INDEX_ENTRY_HEADER) > index_end ||
-- 
1.9.2.459.g68773ac
