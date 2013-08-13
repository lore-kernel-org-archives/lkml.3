Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3HMHFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:05:04 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:61132 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3HMHFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:05:02 -0400
X-AuditID: 9c93017e-b7c76ae000003897-cc-5209da9c27b6
From: Minchan Kim <minchan@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, k.kozlowski@samsung.com,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, guz.fnst@cn.fujitsu.com,
        Benjamin LaHaise <bcrl@kvack.org>, Dave Hansen <dave.hansen@intel.com>,
        lliubbo@gmail.com, aquini@redhat.com, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 1/3] mm: Introduce new page flag
Date: Tue, 13 Aug 2013 16:05:00 +0900
Message-Id: <1376377502-28207-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376377502-28207-1-git-send-email-minchan@kernel.org>
References: <1376377502-28207-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/page-flags.h |    2 ++
 mm/page_alloc.c            |    1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6d53675..75ce843 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -109,6 +109,7 @@ enum pageflags {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	PG_compound_lock,
 #endif
+	PG_pin,
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -197,6 +198,7 @@ struct page;	/* forward declaration */
 
 TESTPAGEFLAG(Locked, locked)
 PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
+PAGEFLAG(Pin, pin) TESTCLEARFLAG(Pin, pin)
 PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
 PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
 PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b100255..5dd8b43 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6345,6 +6345,7 @@ static const struct trace_print_flags pageflag_names[] = {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{1UL << PG_compound_lock,	"compound_lock"	},
 #endif
+	{1UL << PG_pin,			"pin"		},
 };
 
 static void dump_page_flags(unsigned long flags)
-- 
1.7.9.5

