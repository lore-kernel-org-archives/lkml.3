Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883Ab3HHHGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:06:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55531 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665Ab3HHHGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:06:03 -0400
X-AuditID: cbfee691-b7fef6d000002d62-1d-52034359d18e
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] f2fs: fix a build failure due to missing the kobject header
Date: Thu, 08 Aug 2013 16:05:32 +0900
Message-id: <1375945532-15766-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t8zQ91IZ+Ygg2uT5C2u7/rLZHFpkbvF
	nr0nWSwu75rDZvFjer0Dq8fuBZ+ZPPq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvjy5enbAX7
	OSvu7O9gbGB8zN7FyMkhIWAiMe3oNxYIW0ziwr31bF2MXBxCAssYJRZc64Er2vHgJlRiOqNE
	07VPLBBOG5PEqRVPgBwODjYBbYnN+w1AGkQEmCUWTD3PCFLDLLCTUaLh8FsmkISwgI/E750H
	waayCKhKTHsykQmkl1fAXWLRcgWIZboSi04cZAXplRB4zCZxa9YPFoh6AYlvkw+B7ZIQkJXY
	dIAZol5S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAgJxYk7GO8fsD7E
	mAw0biKzlGhyPjCU80riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXAqMTHXPnaIeOpi4PPwRI908k88vttuQ/2bjZ7d0xuyvvFn7T6j9R9PXDx8sSL
	pxxnW97Y+pG/zN4uovEUS/RS24N7P03Z/vDr8QuTp7El5Co5TFH9qOfzgYW1bWFLpUfcklPN
	jzyKp5QU+jh46/nWSy7vncUQl8q8ymOFwN/rhjdf+b1X/d0yXYmlOCPRUIu5qDgRAKerA9Jb	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQd1IZ+Ygg5/XpCyu7/rLZHFpkbvF
	nr0nWSwu75rDZvFjer0Dq8fuBZ+ZPPq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x48uXp2wF+zkr7uzvYGxgfMzexcjJISFgIrHjwU02CFtM4sK99UA2
	F4eQwHRGiaZrn1ggnDYmiVMrngA5HBxsAtoSm/cbgDSICDBLLJh6nhGkhllgJ6NEw+G3TCAJ
	YQEfid87D4JtYBFQlZj2ZCITSC+vgLvEouUKEMt0JRadOMg6gZF7ASPDKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzgQH8mtYNxZYPFIUYBDkYlHt6OAKYgIdbEsuLK3EOMEhzMSiK8F4uB
	QrwpiZVVqUX58UWlOanFhxiTgZZPZJYSTc4HRmFeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0D
	hQTSE0tSs1NTC1KLYLYwcXBKNTAmX5XYxL5/QpC5Q596UJj/U13VkLNbzi+JzZ++eXdllM1k
	zviJKrdfaftkGEX0P+RUYOSanHnS9dXF0PiQSqZpjc7eHca/y15e8F+2OGlqaRzXfLfXjwpD
	rWStMw5bLjGTWfwo8c3Bn9f2sRfmC9wKETovuyW2t/zYHMFjMer/HTdmJ8z82afEUpyRaKjF
	XFScCABePlXVuAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should resolve the following error reported by kbuild test robot.

All error/warnings:

   In file included from fs/f2fs/dir.c:13:0:
   >> fs/f2fs/f2fs.h:435:17: error: field 's_kobj' has incomplete type
        struct kobject s_kobj;

The failure was caused by missing the kobject header file in dir.c.
So, this patch move the header file to the right location, f2fs.h.

CC: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  | 1 +
 fs/f2fs/super.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 13db10b..d8e386ce 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/crc32.h>
 #include <linux/magic.h>
+#include <linux/kobject.h>
 
 /*
  * For mount options
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 94c0e20..66d1ec1 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -23,7 +23,6 @@
 #include <linux/exportfs.h>
 #include <linux/blkdev.h>
 #include <linux/f2fs_fs.h>
-#include <linux/kobject.h>
 #include <linux/sysfs.h>
 
 #include "f2fs.h"
-- 
1.8.3.1.437.g0dbd812

