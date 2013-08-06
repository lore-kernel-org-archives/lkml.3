Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3HFMqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:46:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51488 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab3HFMqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:46:48 -0400
X-AuditID: cbfee68f-b7f436d000000f81-d0-5200f02e2cf4
Message-id: <1375793175.22638.18.camel@kjgkr>
Subject: Re: [PATCH] f2fs: fix a deadlock in fsync
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Jin Xu <jinuxstyle@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 06 Aug 2013 21:46:15 +0900
In-reply-to: <1375704124-22274-1-git-send-email-jinuxstyle@gmail.com>
References: <1375704124-22274-1-git-send-email-jinuxstyle@gmail.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zI129DwxBBps+qVrsfHKa2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+Pl0bXMBfN0Ki5d
	dmpgXK/SxcjJISFgInG26SELhC0mceHeerYuRi4OIYFljBIXTm9ghSlq3NzGDJFYxCjxYfc6
	VgjnNaPErzNz2UGqeAV0Jd4snAU2SljASGLlli9Aozg42AS0JTbvNwAJCwkoSrzdf5cVJCwC
	ZH/aJw0SZhbIlJjzejLYLhYBVYlXE86BTeEUcJWYunISI0Sri8SyWUfYQGx+AVGJwwu3M0P0
	qktMmreIGeJOJYnd7Z3sEHF5ic1r3jJDXCYo8WPyPRaQkyUE9rFLvGzdzQSxTEDi2+RDLCD3
	SAjISmw6ADVHUuLgihssExglZiFZMQvJ2FlIxi5gZF7FKJpakFxQnJReZKxXnJhbXJqXrpec
	n7uJERJv/TsY7x6wPsSYDLRyIrOUaHI+MF7zSuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cCok6FdFbNqzjlvn86oIxtKORO1Ne0DLTofFaWuEeb/
	Ju6808iFe/qBlJ5nrFXBW9Q4jBxenuRPz3m9hpvpyLPq3YdqrV4rZ6XWT8u2uLS88fCFUJuo
	lQ3vky6lf9jQr8a46w3ztDdpX/0Wh+1ZWJgstjPh+PtWIWbjyg9TTNimcZgqK03jSFRiKc5I
	NNRiLipOBAAlLqHMzQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAV29DwxBBlteKljsfHKa2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj5dG1zAXzdCouXXZqYFyv0sXIySEhYCLRuLmNGcIWk7hwbz1bFyMXh5DA
	IkaJD7vXsUI4rxklfp2Zyw5SxSugK/Fm4SwWEFtYwEhi5ZYvQB0cHGwC2hKb9xuAhIUEFCXe
	7r/LChIWAbI/7ZMGCTMLZErMeT2ZFcRmEVCVeDXhHNgUTgFXiakrJzFCtLpILJt1hA3E5hcQ
	lTi8cDszRK+6xKR5i6DuVJLY3d7JDhGXl9i85i0zxGWCEj8m32OZwCg0C0nLLCRls5CULWBk
	XsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHM3PpHcwrmqwOMQowMGoxMObcPV/oBBrYllx
	Ze4hRgkOZiUR3vIXDEFCvCmJlVWpRfnxRaU5qcWHGJOBvpvILCWanA9MNHkl8YbGJmZGlkZm
	FkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwGjSNWklh8PfB6aOIdc3FSu5lyh/
	89VWf7slMmPTuyCewg2brpRahPdc2pgkrXjit5974KlONtt3PFcOC/FPF1D+tyzjP3/Cfmeh
	KdoPcl9/2qY6/dvJQCeViedKF8cuTXcyi+doK+VNVvhY1n51xvI2Pr49ib17k85HmKzL3Mgl
	O4Gd53ukjRJLcUaioRZzUXEiAE9OFicqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jin,

IMO, this patch tries to fix the deadlock condition on
f2fs_write_data_pages.

I think the errorneous scenario is something like this.
When there remains only one fs_lock during the checkpoint procedure,
f2fs_write_data_pages successfully gets the last one at the moment.
Then, other operations like sync and writeback thread are definitely
blocked too.

Meanwhile, in the flow of f2fs_write_data_pages, it is able to wait on
writebacked node page, which is what you decribed.

If you indicated this scenario correctly, as I examined the flow again,
I found one more case, __set_data_blkaddr, in addition to the
update_inode. And, I can clean up another minor flow too.

Please check the below patch.
Thanks,

----> 

>From a9c62162ea89c9b6b52d39d6db3f8f27c4d2ce5c Mon Sep 17 00:00:00 2001
From: Jin Xu <jinuxstyle@gmail.com>
Date: Mon, 5 Aug 2013 20:02:04 +0800
Subject: [PATCH] f2fs: fix a deadlock in fsync
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

This patch fixes a deadlock bug that occurs quite often when there are
concurrent write and fsync on a same file.

Following is the simplified call trace when tasks get hung.

fsync thread:
- f2fs_sync_file
 ...
 - f2fs_write_data_pages
 ...
  - update_extent_cache
  ...
   - update_inode
    - wait_on_page_writeback

bdi writeback thread
- __writeback_single_inode
 - f2fs_write_data_pages
  - mutex_lock(sbi->writepages)

The deadlock happens when the fsync thread waits on a inode page that
has
been added to the f2fs' cached bio sbi->bio[NODE], and unfortunately,
no one else could be able to submit the cached bio to block layer for
writeback. This is because the fsync thread already hold a sbi->fs_lock
and
the sbi->writepages lock, causing the bdi thread being blocked when
attempt
to write data pages for the same inode. At the same time, f2fs_gc thread
does not notice the situation and could not help. Even the sync syscall
gets blocked.

To fix it, we could submit the cached bio first before waiting on a
inode page
that is being written back.

Signed-off-by: Jin Xu <jinuxstyle@gmail.com>
[Jaegeuk Kim: add more cases to use f2fs_wait_on_page_writeback]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c    |  2 +-
 fs/f2fs/f2fs.h    |  3 ++-
 fs/f2fs/gc.c      |  8 ++------
 fs/f2fs/inode.c   |  2 +-
 fs/f2fs/segment.c | 10 ++++++++++
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index f458883..a7eb529 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -37,7 +37,7 @@ static void __set_data_blkaddr(struct dnode_of_data
*dn, block_t new_addr)
 	struct page *node_page = dn->node_page;
 	unsigned int ofs_in_node = dn->ofs_in_node;
 
-	wait_on_page_writeback(node_page);
+	f2fs_wait_on_page_writeback(node_page, NODE, false);
 
 	rn = F2FS_NODE(node_page);
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 63813be..13db10b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1023,7 +1023,8 @@ int npages_for_summary_flush(struct f2fs_sb_info
*);
 void allocate_new_segments(struct f2fs_sb_info *);
 struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
 struct bio *f2fs_bio_alloc(struct block_device *, int);
-void f2fs_submit_bio(struct f2fs_sb_info *, enum page_type, bool sync);
+void f2fs_submit_bio(struct f2fs_sb_info *, enum page_type, bool);
+void f2fs_wait_on_page_writeback(struct page *, enum page_type, bool);
 void write_meta_page(struct f2fs_sb_info *, struct page *);
 void write_node_page(struct f2fs_sb_info *, struct page *, unsigned
int,
 					block_t, block_t *);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index d286d8b..e6b3ffd 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -422,8 +422,7 @@ next_step:
 
 		/* set page dirty and write it */
 		if (gc_type == FG_GC) {
-			f2fs_submit_bio(sbi, NODE, true);
-			wait_on_page_writeback(node_page);
+			f2fs_wait_on_page_writeback(node_page, NODE, true);
 			set_page_dirty(node_page);
 		} else {
 			if (!PageWriteback(node_page))
@@ -523,10 +522,7 @@ static void move_data_page(struct inode *inode,
struct page *page, int gc_type)
 	} else {
 		struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
-		if (PageWriteback(page)) {
-			f2fs_submit_bio(sbi, DATA, true);
-			wait_on_page_writeback(page);
-		}
+		f2fs_wait_on_page_writeback(page, DATA, true);
 
 		if (clear_page_dirty_for_io(page) &&
 			S_ISDIR(inode->i_mode)) {
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index debf743..9ab81e7 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -151,7 +151,7 @@ void update_inode(struct inode *inode, struct page
*node_page)
 	struct f2fs_node *rn;
 	struct f2fs_inode *ri;
 
-	wait_on_page_writeback(node_page);
+	f2fs_wait_on_page_writeback(node_page, NODE, false);
 
 	rn = F2FS_NODE(node_page);
 	ri = &(rn->i);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9b74ae2..68e344f 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -705,6 +705,16 @@ retry:
 	trace_f2fs_submit_write_page(page, blk_addr, type);
 }
 
+void f2fs_wait_on_page_writeback(struct page *page,
+				enum page_type type, bool sync)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
+	if (PageWriteback(page)) {
+		f2fs_submit_bio(sbi, type, sync);
+		wait_on_page_writeback(page);
+	}
+}
+
 static bool __has_curseg_space(struct f2fs_sb_info *sbi, int type)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
-- 
1.8.3.1.437.g0dbd812



-- 
Jaegeuk Kim
Samsung

