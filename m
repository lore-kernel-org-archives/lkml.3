Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3GPJde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:33:34 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43679 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3GPJdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:33:32 -0400
From: chandan <chandan@linux.vnet.ibm.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs_read_block_groups: Use enums to index btrfs_space_info->block_groups.
Date: Tue, 16 Jul 2013 15:03:12 +0530
Message-ID: <1650034.SFcoKv6ShF@localhost.localdomain>
User-Agent: KMail/4.10.5 (Linux/3.9.9-302.fc19.x86_64; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071609-8256-0000-0000-0000085C02B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 33e376755b8a928610032a1cef024dcdd980aee3 Mon Sep 17 00:00:00 2001
From: chandan <chandan@linux.vnet.ibm.com>
Date: Tue, 16 Jul 2013 12:28:56 +0530
Subject: [PATCH] btrfs_read_block_groups: Use enums to index
 btrfs_space_info->block_groups.

The current code uses integer literals to index
btrfs_space_info->block_groups[] array. Instead use corresponding
enums from 'enum btrfs_raid_types'.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent-tree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0236de7..cb18077 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8394,9 +8394,13 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		 * avoid allocating from un-mirrored block group if there are
 		 * mirrored block groups.
 		 */
-		list_for_each_entry(cache, &space_info->block_groups[3], list)
+		list_for_each_entry(cache,
+				&space_info->block_groups[BTRFS_RAID_RAID0],
+				list)
 			set_block_group_ro(cache, 1);
-		list_for_each_entry(cache, &space_info->block_groups[4], list)
+		list_for_each_entry(cache,
+				&space_info->block_groups[BTRFS_RAID_SINGLE],
+				list)
 			set_block_group_ro(cache, 1);
 	}
 
-- 
1.8.3.1


