Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3G2F20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:28:26 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51848 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3G2F2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:28:25 -0400
X-AuditID: 9c930179-b7c49ae000000e68-ad-51f5fd77d3bb
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
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 0/9] mm, hugetlb: clean-up and possible bug fix
Date: Mon, 29 Jul 2013 14:28:12 +0900
Message-Id: <1375075701-5998-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First 5 patches are almost trivial clean-up patches.

The others are for fixing three bugs.
Perhaps, these problems are minor, because this codes are used
for a long time, and there is no bug reporting for these problems.

These patches are based on v3.10.0 and
passed the libhugetlbfs test suite.

Changes from v2.
There is no code change in all patches from v2.
Omit patch 2('clean-up alloc_huge_page()') which try to remove one
goto label.
Add more comments to changelog as Michal's opinion.
Add reviewed-by or acked-by.

Changes from v1.
Split patch 1 into two patches to clear it's purpose.
Remove useless indentation changes in 'clean-up alloc_huge_page()'
Fix new iteration code bug.
Add reviewed-by or acked-by.

Joonsoo Kim (9):
  mm, hugetlb: move up the code which check availability of free huge
    page
  mm, hugetlb: trivial commenting fix
  mm, hugetlb: clean-up alloc_huge_page()
  mm, hugetlb: fix and clean-up node iteration code to alloc or free
  mm, hugetlb: remove redundant list_empty check in
    gather_surplus_pages()
  mm, hugetlb: do not use a page in page cache for cow optimization
  mm, hugetlb: add VM_NORESERVE check in vma_has_reserves()
  mm, hugetlb: remove decrement_hugepage_resv_vma()
  mm, hugetlb: decrement reserve count if VM_NORESERVE alloc page cache

 mm/hugetlb.c |  243 ++++++++++++++++++++++++++--------------------------------
 1 file changed, 110 insertions(+), 133 deletions(-)

-- 
1.7.9.5

