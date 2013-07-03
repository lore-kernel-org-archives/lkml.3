Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3GCIfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:35:54 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51762 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3GCIf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:35:28 -0400
X-AuditID: 9c93016f-b7b26ae000002351-e7-51d3e244318c
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC PATCH 4/5] readahead: remove end range check
Date: Wed,  3 Jul 2013 17:34:19 +0900
Message-Id: <1372840460-5571-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/readahead.c b/mm/readahead.c
index daed28d..3932f28 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -166,6 +166,8 @@ __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 		goto out;
 
 	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
+	if (offset + nr_to_read > end_index + 1)
+		nr_to_read = end_index - offset + 1;
 
 	/*
 	 * Preallocate as many pages as we will need.
@@ -173,9 +175,6 @@ __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
 		pgoff_t page_offset = offset + page_idx;
 
-		if (page_offset > end_index)
-			break;
-
 		rcu_read_lock();
 		page = radix_tree_lookup(&mapping->page_tree, page_offset);
 		rcu_read_unlock();
-- 
1.7.9.5

