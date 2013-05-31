Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3EaK5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:57:18 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:52106 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3EaK5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:57:13 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Max Filippov <jcmvbkbc@gmail.com>,
        "Vineet Gupta" <Vineet.Gupta1@synopsys.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] mm: tlb_fast_mode check missing in tlb_finish_mmu()
Date: Fri, 31 May 2013 16:23:50 +0530
Message-ID: <1369997630-6522-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369997630-6522-1-git-send-email-vgupta@synopsys.com>
References: <1369997630-6522-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.154]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes some unused generated code for tlb_fast_mode() == true

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org
Cc: linux-arch@vger.kernel.org <linux-arch@vger.kernel.org>
---
 mm/memory.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index d9d5fd9..569ffe1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -269,6 +269,9 @@ void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long e
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
+	if (tlb_fast_mode(tlb))
+		return;
+
 	for (batch = tlb->local.next; batch; batch = next) {
 		next = batch->next;
 		free_pages((unsigned long)batch, 0);
-- 
1.7.10.4

