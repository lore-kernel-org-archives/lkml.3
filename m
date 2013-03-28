Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3C1CYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 22:24:45 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44793 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab3C1CYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 22:24:44 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] mm: remove CONFIG_HOTPLUG ifdefs
Date: Thu, 28 Mar 2013 10:23:38 +0800
Message-ID: <1364437418-9144-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HOTPLUG is going away as an option, cleanup CONFIG_HOTPLUG
ifdefs in mm files.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/vmstat.h |    7 +------
 mm/vmstat.c            |    2 --
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 5fd71a7..c586679 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -48,13 +48,8 @@ static inline void count_vm_events(enum vm_event_item item, long delta)
 }
 
 extern void all_vm_events(unsigned long *);
-#ifdef CONFIG_HOTPLUG
+
 extern void vm_events_fold_cpu(int cpu);
-#else
-static inline void vm_events_fold_cpu(int cpu)
-{
-}
-#endif
 
 #else
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index e1d8ed1..c823776 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -52,7 +52,6 @@ void all_vm_events(unsigned long *ret)
 }
 EXPORT_SYMBOL_GPL(all_vm_events);
 
-#ifdef CONFIG_HOTPLUG
 /*
  * Fold the foreign cpu events into our own.
  *
@@ -69,7 +68,6 @@ void vm_events_fold_cpu(int cpu)
 		fold_state->event[i] = 0;
 	}
 }
-#endif /* CONFIG_HOTPLUG */
 
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 
-- 
1.7.1


