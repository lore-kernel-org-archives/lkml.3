Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3LJIs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:48:57 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55928 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3LJIsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:48:55 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-c0-52a6d574db58
Date: Tue, 10 Dec 2013 17:51:47 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 4/7] mm/migrate: remove putback_lru_pages, fix comment
 on putback_movable_pages
Message-ID: <20131210085147.GD24992@lge.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1386580248-22431-5-git-send-email-iamjoonsoo.kim@lge.com>
 <52a67d8c.6966420a.7a42.555fSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52a67d8c.6966420a.7a42.555fSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >@@ -1704,6 +1688,12 @@ int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
> > 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_page,
> > 				     node, MIGRATE_ASYNC, MR_NUMA_MISPLACED);
> > 	if (nr_remaining) {
> >+		if (!list_empty(&migratepages)) {
> >+			list_del(&page->lru);
> >+			dec_zone_page_state(page, NR_ISOLATED_ANON +
> >+					page_is_file_cache(page));
> >+			putback_lru_page(page);
> >+		}
> > 		putback_lru_pages(&migratepages);
> 
> You should remove this line. Otherwise,

Yes, you are right. I will send next version. T_T

> 
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Thanks.
