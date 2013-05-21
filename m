Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3EUD6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:58:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32269 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3EUD6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:58:19 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-08-519af0d975c3
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/3] f2fs: add f2fs_readonly()
Date: Tue, 21 May 2013 12:56:32 +0900
Message-id: <1369108593-880-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369108593-880-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369108593-880-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zA92bH2YFGlz/IWZxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8anaaeZC/ZwVVyb
	NJutgXEfRxcjJ4eEgInEwu73jBC2mMSFe+vZuhi5OIQEljFKLF0wjR2m6NqcH4wQiemMEo+f
	n4Fy2pgkpl1dC1TFwcEmoC2xeb8BSIOIALPEgqnnwWqYBSYwSvxf9J4FJCEsoCfxufEoE4jN
	IqAqsWLBD1YQm1fAVWLO819MENt0JVb/fw62mVPATaJn0h8mkPlCQDW3XxRAlPxmkzj4qAhi
	jIDEt8mHWEBKJARkJTYdYIYokZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLz
	czcxQgJ2wg7GewesDzEmA42byCwlmpwPDPi8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTCq14pKqkrFH91es9oy06qdl+v2J/E5VcFnpbzlRK2e
	+FgWHDWY+Wn5xGfWa07PuOwtbb/tyumP+atVJ55ontjm0rSir70vjTcsOov71+4jSzpWOG3r
	Mv6Wv/9QWFPJ/E6r9n8J95NO21/a6jptd9ydrEL/F28i+Y17GC+tWfkgzX/n/s4lvOuVWIoz
	Eg21mIuKEwG97Os4bgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd2bH2YFGnw5J2xxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPGp2mnmQv2cFVcmzSbrYFxH0cXIyeHhICJxLU5PxghbDGJC/fWs3UxcnEI
	CUxnlHj8/AwjhNPGJDHt6lr2LkYODjYBbYnN+w1AGkQEmCUWTD0PVsMsMIFR4v+i9ywgCWEB
	PYnPjUeZQGwWAVWJFQt+sILYvAKuEnOe/2KC2KYrsfr/c3YQm1PATaJn0h8mkPlCQDW3XxRM
	YORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Ip5J72Bc1WBxiFGAg1GJh1fAcFag
	EGtiWXFl7iFGCQ5mJRHe781AId6UxMqq1KL8+KLSnNTiQ4zJQEdNZJYSTc4HRmteSbyhsYmZ
	kaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTBWzuIomsOVw5ZQoye5cq02
	S+XXA05lSvvnfP/L4f3fzo2lPIHvcgl3O9eNIoE4E1d/pdOOe58rhmxZ9cOKKyHv18upu50X
	r5gVdD7ifkXIzMX6ifVnft9U+ubP+uCrv/qNzo8ZLaqLrsya7xQqJBGvv2RvXZTmmZ8fTbMn
	8/fuOHJvqpbRmUlKLMUZiYZazEXFiQAR4JITzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a simple macro function for readability.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  | 5 +++++
 fs/f2fs/file.c  | 2 +-
 fs/f2fs/super.c | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9182b27..6594ce1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -887,6 +887,11 @@ static inline int cond_clear_inode_flag(struct f2fs_inode_info *fi, int flag)
 	return 0;
 }
 
+static inline int f2fs_readonly(struct super_block *sb)
+{
+	return sb->s_flags & MS_RDONLY;
+}
+
 /*
  * file.c
  */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9937ba1..316bcfe 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -114,7 +114,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		.for_reclaim = 0,
 	};
 
-	if (inode->i_sb->s_flags & MS_RDONLY)
+	if (f2fs_readonly(inode->i_sb))
 		return 0;
 
 	trace_f2fs_sync_file_enter(inode);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8555f7d..3ac305d 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -170,7 +170,7 @@ static int f2fs_freeze(struct super_block *sb)
 {
 	int err;
 
-	if (sb->s_flags & MS_RDONLY)
+	if (f2fs_readonly(sb))
 		return 0;
 
 	err = f2fs_sync_fs(sb, 1);
-- 
1.8.1.3.566.gaa39828

