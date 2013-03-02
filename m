Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3CBDkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:40:46 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:44769 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3CBDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:40:45 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/5] f2fs: change victim segmap test condition in get_victim_by_default
Date: Sat,  2 Mar 2013 12:40:37 +0900
Message-Id: <1362195637-20683-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Instead of checking for victim_segmap(FG_GC) OR
(gc_type == BG_GC) && victim_segmap(BG_GC);
to continue for the victim selection. The 2 conditions
can simply be merged and decision can directly be made using 'gc_type'.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/gc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 94b8a0c..16b4148 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -266,10 +266,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 		}
 		p.offset = ((segno / p.ofs_unit) * p.ofs_unit) + p.ofs_unit;
 
-		if (test_bit(segno, dirty_i->victim_segmap[FG_GC]))
-			continue;
-		if (gc_type == BG_GC &&
-				test_bit(segno, dirty_i->victim_segmap[BG_GC]))
+		if (test_bit(segno, dirty_i->victim_segmap[gc_type]))
 			continue;
 		if (IS_CURSEC(sbi, GET_SECNO(sbi, segno)))
 			continue;
-- 
1.7.9.5

