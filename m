Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3HTLW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:22:28 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:50327 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3HTLUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:30 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 03/12] Btrfs: Format PAGE_SIZE as unsigned long
Date: Tue, 20 Aug 2013 13:20:09 +0200
Message-Id: <1376997618-13573-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PAGE_SIZE is "unsigned long" everywhere, so there's no need to cast it to
"unsigned long long" and format it as a 64-bit number.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/scrub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6ed2187..f2bc6df 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2859,9 +2859,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (fs_info->chunk_root->sectorsize != PAGE_SIZE) {
 		/* not supported for data w/o checksums */
 		printk(KERN_ERR
-		       "btrfs_scrub: size assumption sectorsize != PAGE_SIZE (%d != %lld) fails\n",
-		       fs_info->chunk_root->sectorsize,
-		       (unsigned long long)PAGE_SIZE);
+		       "btrfs_scrub: size assumption sectorsize != PAGE_SIZE (%d != %lu) fails\n",
+		       fs_info->chunk_root->sectorsize, PAGE_SIZE);
 		return -EINVAL;
 	}
 
-- 
1.7.9.5

