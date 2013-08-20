Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3HTGzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:55:31 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47488 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3HTGzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:55:23 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 3/4] mm/writeback: make writeback_inodes_wb static
Date: Tue, 20 Aug 2013 14:54:55 +0800
Message-Id: <1376981696-4312-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082006-9264-0000-0000-0000045BE4CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not used globally and could be static.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 fs/fs-writeback.c         | 2 +-
 include/linux/writeback.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 87d7781..54b3c31 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -723,7 +723,7 @@ static long __writeback_inodes_wb(struct bdi_writeback *wb,
 	return wrote;
 }
 
-long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
+static long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason)
 {
 	struct wb_writeback_work work = {
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 4e198ca..021b8a3 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -98,8 +98,6 @@ int try_to_writeback_inodes_sb(struct super_block *, enum wb_reason reason);
 int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
 				  enum wb_reason reason);
 void sync_inodes_sb(struct super_block *);
-long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
-				enum wb_reason reason);
 void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
 void inode_wait_for_writeback(struct inode *inode);
 
-- 
1.8.1.2

