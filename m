Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaIBNds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:33:48 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33392 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaIBNdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:33:46 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] fat: Simplify calc_fat_clusters code
Date: Tue,  2 Sep 2014 22:33:30 +0900
Message-Id: <1409664810-31960-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code for fat12 and fat16/32 can be merged to one.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/fat/inode.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 756aead..6992dea 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1307,12 +1307,9 @@ static unsigned long calc_fat_clusters(struct super_block *sb)
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
 	/* Divide first to avoid overflow */
-	if (sbi->fat_bits != 12) {
-		unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
-		return ent_per_sec * sbi->fat_length;
-	}
+	unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
 
-	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+	return ent_per_sec * sbi->fat_length;
 }
 
 static bool fat_bpb_is_zero(struct fat_boot_sector *b)
-- 
1.7.9.5

