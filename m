Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3GXG1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:27:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab3GXG1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:27:19 -0400
Date: Wed, 24 Jul 2013 02:26:50 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Message-ID: <1374647210-ac6q11s5-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <51ef6fd0.1019310a.5683.345bSMTPIN_ADDED_BROKEN@mx.google.com>
References: <1374183272-10153-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1374183272-10153-8-git-send-email-n-horiguchi@ah.jp.nec.com>
 <51ef6fd0.1019310a.5683.345bSMTPIN_ADDED_BROKEN@mx.google.com>
Subject: Re: [PATCH 7/8] memory-hotplug: enable memory hotplug to handle
 hugepage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <51ef6fd0.1019310a.5683.345bSMTPIN_ADDED_BROKEN@mx.google.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 02:10:07PM +0800, Wanpeng Li wrote:
...
> >diff --git v3.11-rc1.orig/mm/page_isolation.c v3.11-rc1/mm/page_isolation.c
> >index 383bdbb..cf48ef6 100644
> >--- v3.11-rc1.orig/mm/page_isolation.c
> >+++ v3.11-rc1/mm/page_isolation.c
> >@@ -6,6 +6,7 @@
> > #include <linux/page-isolation.h>
> > #include <linux/pageblock-flags.h>
> > #include <linux/memory.h>
> >+#include <linux/hugetlb.h>
> > #include "internal.h"
> >
> > int set_migratetype_isolate(struct page *page, bool skip_hwpoisoned_pages)
> >@@ -252,6 +253,10 @@ struct page *alloc_migrate_target(struct page *page, unsigned long private,
> > {
> > 	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
> >
> >+	if (PageHuge(page))
> >+		return alloc_huge_page_node(page_hstate(compound_head(page)),
> >+					    numa_node_id());
> >+
> 
> Why specify current node? Maybe current node is under remove.

Yes. One difficulty is that this function doesn't have vma and we can't
rely on mempolicy for node choice. I think that simply choosing the next
node by incrementing node id can be a work around, though it's not the
best solution.

Thanks,
Naoya Horiguchi
