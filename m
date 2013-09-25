Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3IYXXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:23:34 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56591 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3IYXX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:23:29 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 24/40] mm: Drop some very expensive sorted-buddy
 related checks under DEBUG_PAGEALLOC
To: akpm@linux-foundation.org, mgorman@suse.de, dave@sr71.net,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 04:49:17 +0530
Message-ID: <20130925231915.26184.87083.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-8256-0000-0000-00000961DFC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under CONFIG_DEBUG_PAGEALLOC, we have numerous checks and balances to verify
the correctness of various sorted-buddy operations. But some of them are very
expensive and hence can't be enabled while benchmarking the code.
(They should be used only to verify that the code is working correctly, as a
precursor to benchmarking the performance).

The check to see if a page given as input to del_from_freelist() indeed
belongs to that freelist, is one such very expensive check. Drop it.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d5acea7..178f210 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -812,6 +812,7 @@ static void del_from_freelist(struct page *page, struct free_list *free_list,
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	WARN(region->nr_free < 0, "%s: nr_free is negative\n", __func__);
 
+#if 0
 	/* Verify whether this page indeed belongs to this free list! */
 
 	list_for_each(p, &free_list->list) {
@@ -820,6 +821,7 @@ static void del_from_freelist(struct page *page, struct free_list *free_list,
 	}
 
 	WARN(1, "%s: page doesn't belong to the given freelist!\n", __func__);
+#endif
 
 page_found:
 #endif

