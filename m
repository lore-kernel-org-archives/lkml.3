Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaI2RuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:50:06 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:65383 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919AbaI2RuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:50:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoNAB6bKVRbtA8r/2dsb2JhbABggw6BKrYYBQFyAZpWgRUXAXuEMS8jgRo3iCoDFQGvcog9FYcehhKJOwEBTx2ENQWRPYtrlV2DZTsvgQ+BOwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ufs/balloc.c: remove unused variable
Date: Mon, 29 Sep 2014 19:49:55 +0200
Message-Id: <1412012995-13607-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ucg is defined and set in ufs_bitmap_search but never used.

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/balloc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 7bc2080..2c10360 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -784,7 +784,6 @@ static u64 ufs_bitmap_search(struct super_block *sb,
 		0x0, 0x2, 0x6, 0xe, 0x1e, 0x3e, 0x7e, 0xfe, 0x1fe
 	};
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
-	struct ufs_cylinder_group *ucg;
 	unsigned start, length, loc;
 	unsigned pos, want, blockmap, mask, end;
 	u64 result;
@@ -792,8 +791,6 @@ static u64 ufs_bitmap_search(struct super_block *sb,
 	UFSD("ENTER, cg %u, goal %llu, count %u\n", ucpi->c_cgx,
 	     (unsigned long long)goal, count);
 
-	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
-
 	if (goal)
 		start = ufs_dtogd(uspi, goal) >> 3;
 	else
-- 
1.9.3

