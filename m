Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3FNHcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:32:25 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34546 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3FNHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:31:05 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 4/8] mm/writeback: rename WB_REASON_FORKER_THREAD to WB_REASON_WORKER_THREAD
Date: Fri, 14 Jun 2013 15:30:37 +0800
Message-Id: <1371195041-26654-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061418-3568-0000-0000-000003C586EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 839a8e86("writeback: replace custom worker pool implementation
with unbound workqueue"), there is no bdi forker thread any more. This patch
rename WB_REASON_FORKER_THREAD to WB_REASON_WORKER_THREAD since works are
done by emergency worker.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 fs/fs-writeback.c                | 2 +-
 include/linux/writeback.h        | 2 +-
 include/trace/events/writeback.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e15aa97..87d91d9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1025,7 +1025,7 @@ void bdi_writeback_workfn(struct work_struct *work)
 		 * enough for efficient IO.
 		 */
 		pages_written = writeback_inodes_wb(&bdi->wb, 1024,
-						    WB_REASON_FORKER_THREAD);
+						    WB_REASON_WORKER_THREAD);
 		trace_writeback_pages_written(pages_written);
 	}
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 8b5cec4..c153073 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -47,7 +47,7 @@ enum wb_reason {
 	WB_REASON_LAPTOP_TIMER,
 	WB_REASON_FREE_MORE_MEM,
 	WB_REASON_FS_FREE_SPACE,
-	WB_REASON_FORKER_THREAD,
+	WB_REASON_WORKER_THREAD,
 
 	WB_REASON_MAX,
 };
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 464ea82..f3b33f6 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -28,7 +28,7 @@
 		{WB_REASON_LAPTOP_TIMER,	"laptop_timer"},	\
 		{WB_REASON_FREE_MORE_MEM,	"free_more_memory"},	\
 		{WB_REASON_FS_FREE_SPACE,	"fs_free_space"},	\
-		{WB_REASON_FORKER_THREAD,	"forker_thread"}
+		{WB_REASON_WORKER_THREAD,	"worker_thread"}
 
 struct wb_writeback_work;
 
-- 
1.8.1.2

