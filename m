Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3LCOFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:05:10 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55271 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab3LCOFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:05:00 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Ned Bass <bass6@llnl.gov>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 12/15] staging/lustre: clean up SET_BUT_UNUSED/UNUSED macros
Date: Tue,  3 Dec 2013 21:58:50 +0800
Message-Id: <1386079133-6459-13-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

This is SET_BUT_UNUSED/UNUSED macro cleaning up part
of the original Lustre tree commit.

Lustre-change: http://review.whamcloud.com/6139
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3204
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Signed-off-by: Ned Bass <bass6@llnl.gov>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/include/linux/libcfs/libcfs.h   |    2 --
 drivers/staging/lustre/lnet/selftest/rpc.c         |    2 --
 drivers/staging/lustre/lnet/selftest/selftest.h    |    3 --
 drivers/staging/lustre/lnet/selftest/timer.c       |   11 ++-----
 drivers/staging/lustre/lustre/llite/dcache.c       |   34 ++++++++------------
 5 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs.h b/drivers/staging/lustre/include/linux/libcfs/libcfs.h
index 687dbab..4a6c7da 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs.h
@@ -181,8 +181,6 @@ static inline void *__container_of(void *ptr, unsigned long shift)
 #define container_of0(ptr, type, member) \
 	((type *)__container_of((void *)(ptr), offsetof(type, member)))
 
-#define SET_BUT_UNUSED(a) do { } while(sizeof(a) - sizeof(a))
-
 #define _LIBCFS_H
 
 #endif /* _LIBCFS_H */
diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index 7659a26..5ae59d2 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -124,7 +124,6 @@ srpc_bulk_t *
 srpc_alloc_bulk(int cpt, unsigned bulk_npg, unsigned bulk_len, int sink)
 {
 	srpc_bulk_t  *bk;
-	struct page  **pages;
 	int	      i;
 
 	LASSERT(bulk_npg > 0 && bulk_npg <= LNET_MAX_IOV);
@@ -140,7 +139,6 @@ srpc_alloc_bulk(int cpt, unsigned bulk_npg, unsigned bulk_len, int sink)
 	bk->bk_sink   = sink;
 	bk->bk_len    = bulk_len;
 	bk->bk_niov   = bulk_npg;
-	UNUSED(pages);
 
 	for (i = 0; i < bulk_npg; i++) {
 		struct page *pg;
diff --git a/drivers/staging/lustre/lnet/selftest/selftest.h b/drivers/staging/lustre/lnet/selftest/selftest.h
index 8053b05..cd53926 100644
--- a/drivers/staging/lustre/lnet/selftest/selftest.h
+++ b/drivers/staging/lustre/lnet/selftest/selftest.h
@@ -572,9 +572,6 @@ swi_state2str (int state)
 #undef STATE2STR
 }
 
-#define UNUSED(x)       ( (void)(x) )
-
-
 #define selftest_wait_events()	cfs_pause(cfs_time_seconds(1) / 10)
 
 
diff --git a/drivers/staging/lustre/lnet/selftest/timer.c b/drivers/staging/lustre/lnet/selftest/timer.c
index 82fd363..b8e50ef 100644
--- a/drivers/staging/lustre/lnet/selftest/timer.c
+++ b/drivers/staging/lustre/lnet/selftest/timer.c
@@ -171,19 +171,14 @@ stt_check_timers(cfs_time_t *last)
 int
 stt_timer_main(void *arg)
 {
-	int rc = 0;
-	UNUSED(arg);
-
-	SET_BUT_UNUSED(rc);
-
 	cfs_block_allsigs();
 
 	while (!stt_data.stt_shuttingdown) {
 		stt_check_timers(&stt_data.stt_prev_slot);
 
-		rc = wait_event_timeout(stt_data.stt_waitq,
-					stt_data.stt_shuttingdown,
-					cfs_time_seconds(STTIMER_SLOTTIME));
+		wait_event_timeout(stt_data.stt_waitq,
+				   stt_data.stt_shuttingdown,
+				   cfs_time_seconds(STTIMER_SLOTTIME));
 	}
 
 	spin_lock(&stt_data.stt_lock);
diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
index e7629be..cbd663e 100644
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -404,7 +404,6 @@ int ll_revalidate_it(struct dentry *de, int lookup_flags,
 		struct inode *inode = de->d_inode;
 		struct ll_inode_info *lli = ll_i2info(inode);
 		struct obd_client_handle **och_p;
-		__u64 *och_usecount;
 		__u64 ibits;
 
 		/*
@@ -418,37 +417,32 @@ int ll_revalidate_it(struct dentry *de, int lookup_flags,
 		 */
 
 
-		if (it->it_flags & FMODE_WRITE) {
+		if (it->it_flags & FMODE_WRITE)
 			och_p = &lli->lli_mds_write_och;
-			och_usecount = &lli->lli_open_fd_write_count;
-		} else if (it->it_flags & FMODE_EXEC) {
+		else if (it->it_flags & FMODE_EXEC)
 			och_p = &lli->lli_mds_exec_och;
-			och_usecount = &lli->lli_open_fd_exec_count;
-		} else {
+		else
 			och_p = &lli->lli_mds_read_och;
-			och_usecount = &lli->lli_open_fd_read_count;
-		}
+
 		/* Check for the proper lock. */
 		ibits = MDS_INODELOCK_LOOKUP;
 		if (!ll_have_md_lock(inode, &ibits, LCK_MINMODE))
 			goto do_lock;
 		mutex_lock(&lli->lli_och_mutex);
 		if (*och_p) { /* Everything is open already, do nothing */
-			/*(*och_usecount)++;  Do not let them steal our open
-			  handle from under us */
-			SET_BUT_UNUSED(och_usecount);
-			/* XXX The code above was my original idea, but in case
-			   we have the handle, but we cannot use it due to later
-			   checks (e.g. O_CREAT|O_EXCL flags set), nobody
-			   would decrement counter increased here. So we just
-			   hope the lock won't be invalidated in between. But
-			   if it would be, we'll reopen the open request to
-			   MDS later during file open path */
+			/* Originally it was idea to do not let them steal our
+			 * open handle from under us by (*och_usecount)++ here.
+			 * But in case we have the handle, but we cannot use it
+			 * due to later checks (e.g. O_CREAT|O_EXCL flags set),
+			 * nobody would decrement counter increased here. So we
+			 * just hope the lock won't be invalidated in between.
+			 * But if it would be, we'll reopen the open request to
+			 * MDS later during file open path.
+			 */
 			mutex_unlock(&lli->lli_och_mutex);
 			return 1;
-		} else {
-			mutex_unlock(&lli->lli_och_mutex);
 		}
+		mutex_unlock(&lli->lli_och_mutex);
 	}
 
 	if (it->it_op == IT_GETATTR) {
-- 
1.7.9.5

