Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab3LFIjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:39:18 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54474 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab3LFIjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:39:13 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-44-52a18d2f4b5e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 2/4] mm/mempolicy: correct putback method for isolate pages if failed
Date: Fri,  6 Dec 2013 17:41:48 +0900
Message-Id: <1386319310-28016-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queue_pages_range() isolates hugetlbfs pages and putback_lru_pages() can't
handle these. We should change it to putback_movable_pages().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eca4a31..6d04d37 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1318,7 +1318,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 		if (nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else
-		putback_lru_pages(&pagelist);
+		putback_movable_pages(&pagelist);
 
 	up_write(&mm->mmap_sem);
  mpol_out:
-- 
1.7.9.5

