Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaCYSFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:05:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaCYRRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 02/81] kernel.h: undef clashing U64_MAX, U32_MAX size limits
Date: Tue, 25 Mar 2014 10:15:15 -0700
Message-Id: <1395767794-5012-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

For 3.8-stable only.

Clean up after 3.8-stable's "4a7625f kernel.h: define u8, s8, u32, etc. limits"

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/rbd.c    | 4 ----
 fs/reiserfs/reiserfs.h | 2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 5ac4a17..f2a4099 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -52,10 +52,6 @@
 #define	SECTOR_SHIFT	9
 #define	SECTOR_SIZE	(1ULL << SECTOR_SHIFT)
 
-/* It might be useful to have this defined elsewhere too */
-
-#define	U64_MAX	((u64) (~0ULL))
-
 #define RBD_DRV_NAME "rbd"
 #define RBD_DRV_NAME_LONG "rbd (rados block device)"
 
diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 157e474..635a142 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -1954,8 +1954,6 @@ struct treepath var = {.path_length = ILLEGAL_PATH_ELEMENT_OFFSET, .reada = 0,}
 #define MAX_US_INT 0xffff
 
 // reiserfs version 2 has max offset 60 bits. Version 1 - 32 bit offset
-#define U32_MAX (~(__u32)0)
-
 static inline loff_t max_reiserfs_offset(struct inode *inode)
 {
 	if (get_inode_item_key_version(inode) == KEY_FORMAT_3_5)
-- 
1.8.3.2

