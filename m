Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106Ab3IDRBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:01:42 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51416 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763134Ab3IDRBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:01:40 -0400
From: Manish Sharma <manishrma@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernelnewbies@kernelnewbies.org, Manish Sharma <manishrma@gmail.com>
Subject: [PATCH 1/1] Squashfs-Optimized-uncompressed-buffer-loop-v3
Date: Wed,  4 Sep 2013 22:31:23 +0530
Message-Id: <1378314083-3677-1-git-send-email-manishrma@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Manish Sharma <manishrma@gmail.com>
---
 fs/squashfs/block.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index fb50652..41d108e 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -167,17 +167,14 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
		/*
		 * Block is uncompressed.
		 */
-		int i, in, pg_offset = 0;
-
-		for (i = 0; i < b; i++) {
-			wait_on_buffer(bh[i]);
-			if (!buffer_uptodate(bh[i]))
-				goto block_release;
-		}
+		int in, pg_offset = 0;

		for (bytes = length; k < b; k++) {
			in = min(bytes, msblk->devblksize - offset);
			bytes -= in;
+			wait_on_buffer(bh[k]);
+			if (!buffer_uptodate(bh[k]))
+				goto block_release;
			while (in) {
				if (pg_offset == PAGE_CACHE_SIZE) {
					page++;
--
1.7.9.5
