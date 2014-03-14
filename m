Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaCNGh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:37:29 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51646 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaCNGh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:37:27 -0400
X-AuditID: 9c93017e-b7cf9ae000004b4b-da-5322a3a5acd5
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Evans <je@fb.com>, Minchan Kim <minchan@kernel.org>
Subject: [RFC 1/6] mm: clean up PAGE_MAPPING_FLAGS
Date: Fri, 14 Mar 2014 15:37:45 +0900
Message-Id: <1394779070-8545-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394779070-8545-1-git-send-email-minchan@kernel.org>
References: <1394779070-8545-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's preparation to squeeze a new flag PAGE_MAPPING_LZFREE so
functions to get a anon_vma from mapping shouldn't assume that
+/- PAGE_MAPPING_ANON is enough.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/rmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index d9d42316a99a..76069afa6b81 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -412,7 +412,7 @@ struct anon_vma *page_get_anon_vma(struct page *page)
 	if (!page_mapped(page))
 		goto out;
 
-	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
+	anon_vma = page_rmapping(page);
 	if (!atomic_inc_not_zero(&anon_vma->refcount)) {
 		anon_vma = NULL;
 		goto out;
@@ -455,7 +455,7 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 	if (!page_mapped(page))
 		goto out;
 
-	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
+	anon_vma = page_rmapping(page);
 	root_anon_vma = ACCESS_ONCE(anon_vma->root);
 	if (down_read_trylock(&root_anon_vma->rwsem)) {
 		/*
-- 
1.9.0

