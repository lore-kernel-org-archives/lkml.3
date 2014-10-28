Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbaJ1LJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:09:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaJ1LJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:09:40 -0400
Date: Tue, 28 Oct 2014 04:08:47 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-b438b1ab35507bbccc28d13f0b8286ffcf24019d@git.kernel.org>
Cc: torvalds@linux-foundation.org, luto@amacapital.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com, acme@kernel.org,
        tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org
Reply-To: luto@amacapital.net, linux-kernel@vger.kernel.org, hpa@zytor.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, acme@kernel.org,
        peterz@infradead.org, mingo@kernel.org
In-Reply-To: <320ba26391a8123cc16e5f02d24d34bd404332fd.1412313343.git.luto@amacapital.net>
References: <320ba26391a8123cc16e5f02d24d34bd404332fd.1412313343.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Fix typos in sample code in the perf_event.h header
Git-Commit-ID: b438b1ab35507bbccc28d13f0b8286ffcf24019d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b438b1ab35507bbccc28d13f0b8286ffcf24019d
Gitweb:     http://git.kernel.org/tip/b438b1ab35507bbccc28d13f0b8286ffcf24019d
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 2 Oct 2014 22:16:36 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:51:02 +0100

perf: Fix typos in sample code in the perf_event.h header

struct perf_event_mmap_page has members called "index" and
"cap_user_rdpmc".  Spell them correctly in the examples.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-api@vger.kernel.org
Link: http://lkml.kernel.org/r/320ba26391a8123cc16e5f02d24d34bd404332fd.1412313343.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9269de2..9d84540 100644
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
