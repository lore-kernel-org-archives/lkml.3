Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3ELB2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 21:28:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:4397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab3ELBVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 21:21:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,654,1363158000"; 
   d="scan'208";a="336134842"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCHv4 05/39] memcg, thp: charge huge cache pages
Date: Sun, 12 May 2013 04:23:02 +0300
Message-Id: <1368321816-17719-6-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

mem_cgroup_cache_charge() has check for PageCompound(). The check
prevents charging huge cache pages.

I don't see a reason why the check is present. Looks like it's just
legacy (introduced in 52d4b9a memcg: allocate all page_cgroup at boot).

Let's just drop it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fe4f123..a7de6a7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4080,8 +4080,6 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 
 	if (mem_cgroup_disabled())
 		return 0;
-	if (PageCompound(page))
-		return 0;
 
 	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
-- 
1.7.10.4

