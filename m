Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3FPBPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 21:15:44 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38826 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3FPBPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 21:15:09 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 4/7] mm/page_alloc: fix blank in show_free_areas
Date: Sun, 16 Jun 2013 09:14:47 +0800
Message-Id: <1371345290-19588-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371345290-19588-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371345290-19588-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061601-8878-0000-0000-0000078DC258
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a blank in show_free_areas which lead to dump messages aren't
aligned. This patch remove blank.

Before patch:

[155219.720141] active_anon:50675 inactive_anon:35273 isolated_anon:0
[155219.720141]  active_file:215421 inactive_file:344268 isolated_file:0
[155219.720141]  unevictable:0 dirty:35 writeback:0 unstable:0
[155219.720141]  free:1334870 slab_reclaimable:28833 slab_unreclaimable:5115
[155219.720141]  mapped:25233 shmem:35511 pagetables:1705 bounce:0
[155219.720141]  free_cma:0

After patch:

[   73.913889] active_anon:39578 inactive_anon:32082 isolated_anon:0
[   73.913889] active_file:14621 inactive_file:57993 isolated_file:0
[   73.913889] unevictable:0dirty:263 writeback:0 unstable:0
[   73.913889] free:1865614 slab_reclaimable:3264 slab_unreclaimable:4566
[   73.913889] mapped:21192 shmem:32327 pagetables:1572 bounce:0
[   73.913889] free_cma:0

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 18102e1..e6e881a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3004,12 +3004,12 @@ void show_free_areas(unsigned int filter)
 	}
 
 	printk("active_anon:%lu inactive_anon:%lu isolated_anon:%lu\n"
-		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
-		" unevictable:%lu"
-		" dirty:%lu writeback:%lu unstable:%lu\n"
-		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
-		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
-		" free_cma:%lu\n",
+		"active_file:%lu inactive_file:%lu isolated_file:%lu\n"
+		"unevictable:%lu"
+		"dirty:%lu writeback:%lu unstable:%lu\n"
+		"free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
+		"mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+		"free_cma:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_INACTIVE_ANON),
 		global_page_state(NR_ISOLATED_ANON),
-- 
1.8.1.2

