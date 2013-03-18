Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab3CRLLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:11:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56009 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab3CRLLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:11:45 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355068800"; 
   d="scan'208";a="6893860"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, penberg@kernel.org, jacob.shin@amd.com,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH] x86: mm: add_pfn_range_mapped: use meaningful index to teach clean_sort_range()
Date: Mon, 18 Mar 2013 18:21:33 +0800
Message-Id: <1363602093-11965-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/18 18:17:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/18 18:18:02,
	Serialize complete at 2013/03/18 18:18:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since add_range_with_merge() return the max none zero element of the array, it's
suffice to use it to instruct clean_sort_range() to do the sort. Or the former
assignment by add_range_with_merge() is nonsense because clean_sort_range() 
will produce a accurate number of the sorted array and it never depends on
nr_pfn_mapped.

Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 arch/x86/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 59b7fc4..55ae904 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -310,7 +310,7 @@ static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
 {
 	nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
 					     nr_pfn_mapped, start_pfn, end_pfn);
-	nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
+	nr_pfn_mapped = clean_sort_range(pfn_mapped, nr_pfn_mapped);
 
 	max_pfn_mapped = max(max_pfn_mapped, end_pfn);
 
-- 
1.8.0.1

