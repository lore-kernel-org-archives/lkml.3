Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3FNHcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:32:01 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34551 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3FNHbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:31:07 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 5/8] mm/page_alloc: fix blank in show_free_areas
Date: Fri, 14 Jun 2013 15:30:38 +0800
Message-Id: <1371195041-26654-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061418-3568-0000-0000-000003C586F5
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
index c3edb62..3c5ba4e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3001,12 +3001,12 @@ void show_free_areas(unsigned int filter)
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

