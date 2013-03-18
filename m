Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3CRFy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:54:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45832 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3CRFyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:54:52 -0400
X-AuditID: cbfee690-b7f656d0000007e3-54-5146ac2bbbcf
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix to call WRITE_FLUSH at the end of fsync
Date: Mon, 18 Mar 2013 14:54:06 +0900
Message-id: <1363586046-8693-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zI13tNW6BBst2cFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFl+gaWgttsFYf7
	9rA0MJ5i7WLk4JAQMJG4/qqki5ETyBSTuHBvPVsXIxeHkMAyRolNa+YywdQ0npeGiE9nlHja
	uJUJwmljkjjcvR2siE1AW2LzfgOQQSICzBILpp5nBKlhFpjAKPF/0XsWkISwgJPEkodrGUFs
	FgFViUe/mtlAbF4BN4lfEx8xQVyhK7H6/3N2kGYJgcdsEgce3mCGaBCQ+Db5EAvERbISmw4w
	Q9RLShxccYNlAqPgAkaGVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxghAThhB+O9A9aHGJOB
	xk1klhJNzgcGcF5JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGJc3XnroIJfZ7Vk9af9Vh1NRLc1XJ0+K4t19woVVSX+f6fEJ1ysFAoO/BP3772v3
	M+tPgpzYkdwkt8qe9QGZar5nws91vH6380vE+9h93+/qfJ65J0jXNnDHjfbEmI43gr5n+yL3
	5y+8eJC1MuNDiIfotjXVpjotK9y2syxYEnbma9GlM1pz3iixFGckGmoxFxUnAgCPrwtLVgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV3tNW6BBhvns1pc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxZfoGloLbbBWH+/awNDCeYu1i5OCQEDCRaDwv3cXICWSKSVy4t56ti5GL
	Q0hgOqPE08atTBBOG5PE4e7tTCANbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAEsIC
	ThJLHq5lBLFZBFQlHv1qZgOxeQXcJH5NfMQEsU1XYvX/5+wTGLkXMDKsYhRNLUguKE5KzzXS
	K07MLS7NS9dLzs/dxAgO8GfSOxhXNVgcYhTgYFTi4TXgcQ0UYk0sK67MPcQowcGsJMLbEOIW
	KMSbklhZlVqUH19UmpNafIgxGWj7RGYp0eR8YPTllcQbGpuYGVkamVkYmZibkyasJM57sNU6
	UEggPbEkNTs1tSC1CGYLEwenVANjJnNaSbQS7/yNNus1w5mK7iy8GOswP36y9MmAQlvNPaVn
	P5ZbMi3t9GlaNJOx9CLz/tBUb9/lRcJapee3CkeUxb64FpOR+eT01om+YRUVIVcYd6r+PBcU
	0119qSRsQ8TaPwy/38YYn3SbH2se37KIw3PdvJ7zrlevOQXaLJ5+kXEhu4lm83slluKMREMt
	5qLiRAB2vl+TtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fsync call should be ended after flushing the in-device caches.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 269645e..ff018a4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -13,6 +13,7 @@
 #include <linux/stat.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
+#include <linux/blkdev.h>
 #include <linux/falloc.h>
 #include <linux/types.h>
 #include <linux/compat.h>
@@ -178,6 +179,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		}
 		filemap_fdatawait_range(sbi->node_inode->i_mapping,
 							0, LONG_MAX);
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 	}
 out:
 	mutex_unlock(&inode->i_mutex);
-- 
1.8.1.3.566.gaa39828

