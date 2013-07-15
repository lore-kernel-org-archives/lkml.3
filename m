Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3GOKHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:07:54 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48851 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3GOKHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:07:52 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 06:07:52 EDT
X-AuditID: 9c93017e-b7b62ae000000eeb-d9-51e3c6716da0
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
Subject: [PATCH 0/9] mm, hugetlb: clean-up and possible bug fix
Date: Mon, 15 Jul 2013 18:52:38 +0900
Message-Id: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
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
passed sanity check of libhugetlbfs.

Thanks.

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

 mm/hugetlb.c |  256 +++++++++++++++++++++++++++-------------------------------
 1 file changed, 117 insertions(+), 139 deletions(-)

-- 
1.7.9.5

