Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3E3SHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:07:39 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:46058 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab3E3SFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:05:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>, metin d <metdos@yahoo.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 08/10] mm: make global_dirtyable_memory() available to other mm code
Date: Thu, 30 May 2013 14:04:04 -0400
Message-Id: <1369937046-27666-9-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1369937046-27666-1-git-send-email-hannes@cmpxchg.org>
References: <1369937046-27666-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsequent patches need a rough estimate of memory available for page
cache.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/writeback.h | 1 +
 mm/page-writeback.c       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 9a9367c..832f86b 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -148,6 +148,7 @@ struct ctl_table;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int,
 				      void __user *, size_t *, loff_t *);
 
+unsigned long global_dirtyable_memory(void);
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
 unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
 			       unsigned long dirty);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index efe6814..5e302e6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -231,7 +231,7 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
  * Returns the global number of pages potentially available for dirty
  * page cache.  This is the base value for the global dirty limits.
  */
-static unsigned long global_dirtyable_memory(void)
+unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
-- 
1.8.3

