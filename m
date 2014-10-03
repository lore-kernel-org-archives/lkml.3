Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaJCFQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:16:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49862 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaJCFQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:16:45 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] perf: Fix typos in sample code in the perf_event.h header
Date: Thu,  2 Oct 2014 22:16:36 -0700
Message-Id: <320ba26391a8123cc16e5f02d24d34bd404332fd.1412313343.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct perf_event_mmap_page has members called "index" and
"cap_user_rdpmc".  Spell them correctly in the examples.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/uapi/linux/perf_event.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9269de254874..9d845404d875 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -364,7 +364,7 @@ struct perf_event_mmap_page {
 	/*
 	 * Bits needed to read the hw events in user-space.
 	 *
-	 *   u32 seq, time_mult, time_shift, idx, width;
+	 *   u32 seq, time_mult, time_shift, index, width;
 	 *   u64 count, enabled, running;
 	 *   u64 cyc, time_offset;
 	 *   s64 pmc = 0;
@@ -383,11 +383,11 @@ struct perf_event_mmap_page {
 	 *       time_shift  = pc->time_shift;
 	 *     }
 	 *
-	 *     idx = pc->index;
+	 *     index = pc->index;
 	 *     count = pc->offset;
-	 *     if (pc->cap_usr_rdpmc && idx) {
+	 *     if (pc->cap_user_rdpmc && index) {
 	 *       width = pc->pmc_width;
-	 *       pmc = rdpmc(idx - 1);
+	 *       pmc = rdpmc(index - 1);
 	 *     }
 	 *
 	 *     barrier();
@@ -415,7 +415,7 @@ struct perf_event_mmap_page {
 	};
 
 	/*
-	 * If cap_usr_rdpmc this field provides the bit-width of the value
+	 * If cap_user_rdpmc this field provides the bit-width of the value
 	 * read using the rdpmc() or equivalent instruction. This can be used
 	 * to sign extend the result like:
 	 *
@@ -439,10 +439,10 @@ struct perf_event_mmap_page {
 	 *
 	 * Where time_offset,time_mult,time_shift and cyc are read in the
 	 * seqcount loop described above. This delta can then be added to
-	 * enabled and possible running (if idx), improving the scaling:
+	 * enabled and possible running (if index), improving the scaling:
 	 *
 	 *   enabled += delta;
-	 *   if (idx)
+	 *   if (index)
 	 *     running += delta;
 	 *
 	 *   quot = count / running;
-- 
1.9.3

