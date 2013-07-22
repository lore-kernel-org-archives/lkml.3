Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3GVIgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:36:40 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56098 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab3GVIgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:36:38 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-c4-51ecef13bccc
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 00/10] mm, hugetlb: clean-up and possible bug fix
Date: Mon, 22 Jul 2013 17:36:21 +0900
Message-Id: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First 6 patches are almost trivial clean-up patches.

The others are for fixing three bugs.
Perhaps, these problems are minor, because this codes are used
for a long time, and there is no bug reporting for these problems.

These patches are based on v3.10.0 and
passed the libhugetlbfs test suite.

Changes from v1.
Split patch 1 into two patches to clear it's purpose.
Remove useless indentation changes in 'clean-up alloc_huge_page()'
Fix new iteration code bug.
Add reviewed-by or acked-by.

Joonsoo Kim (10):
  mm, hugetlb: move up the code which check availability of free huge
    page
  mm, hugetlb: remove err label in dequeue_huge_page_vma()
  mm, hugetlb: trivial commenting fix
  mm, hugetlb: clean-up alloc_huge_page()
  mm, hugetlb: fix and clean-up node iteration code to alloc or free
  mm, hugetlb: remove redundant list_empty check in
    gather_surplus_pages()
  mm, hugetlb: do not use a page in page cache for cow optimization
  mm, hugetlb: add VM_NORESERVE check in vma_has_reserves()
  mm, hugetlb: remove decrement_hugepage_resv_vma()
  mm, hugetlb: decrement reserve count if VM_NORESERVE alloc page cache

 mm/hugetlb.c |  250 ++++++++++++++++++++++++++--------------------------------
 1 file changed, 112 insertions(+), 138 deletions(-)

-- 
1.7.9.5

