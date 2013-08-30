Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3H3N0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:26:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52254 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab3H3N0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:26:32 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 26/35] mm: Drop some very expensive sorted-buddy
 related checks under DEBUG_PAGEALLOC
To: akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        tony.luck@intel.com, matthew.garrett@nebula.com, dave@sr71.net,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 18:52:15 +0530
Message-ID: <20130830132212.4947.97714.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083013-5806-0000-0000-000022964FF3
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
index 7e82872a..9be946e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -811,6 +811,7 @@ static void del_from_freelist(struct page *page, struct free_list *free_list,
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	WARN(region->nr_free < 0, "%s: nr_free is negative\n", __func__);
 
+#if 0
 	/* Verify whether this page indeed belongs to this free list! */
 
 	list_for_each(p, &free_list->list) {
@@ -819,6 +820,7 @@ static void del_from_freelist(struct page *page, struct free_list *free_list,
 	}
 
 	WARN(1, "%s: page doesn't belong to the given freelist!\n", __func__);
+#endif
 
 page_found:
 #endif

