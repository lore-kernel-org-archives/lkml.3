Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3IBHmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:42:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab3IBHmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:42:47 -0400
Date: Mon, 2 Sep 2013 00:42:08 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-274481de6cb69abdb49403ff32abb63c23743413@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, vincent.weaver@maine.edu, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, vincent.weaver@maine.edu,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1308231544420.1889@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308231544420.1889@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Export struct perf_branch_entry to userspace
Git-Commit-ID: 274481de6cb69abdb49403ff32abb63c23743413
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:42:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  274481de6cb69abdb49403ff32abb63c23743413
Gitweb:     http://git.kernel.org/tip/274481de6cb69abdb49403ff32abb63c23743413
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Fri, 23 Aug 2013 15:51:03 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:42:48 +0200

perf: Export struct perf_branch_entry to userspace

If PERF_SAMPLE_BRANCH_STACK is enabled then samples are returned
with the format { u64 from, to, flags } but the flags layout
is not specified.

This field has the type struct perf_branch_entry; move this
definition into include/uapi/linux/perf_event.h so users can
access these fields.

This is similar to the existing inclusion of perf_mem_data_src in
the include/uapi/linux/perf_event.h file.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1308231544420.1889@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h      | 24 ------------------------
 include/uapi/linux/perf_event.h | 24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c43f6ea..4019d82 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -64,30 +64,6 @@ struct perf_raw_record {
 };
 
 /*
- * single taken branch record layout:
- *
- *      from: source instruction (may not always be a branch insn)
- *        to: branch target
- *   mispred: branch target was mispredicted
- * predicted: branch target was predicted
- *
- * support for mispred, predicted is optional. In case it
- * is not supported mispred = predicted = 0.
- *
- *     in_tx: running in a hardware transaction
- *     abort: aborting a hardware transaction
- */
-struct perf_branch_entry {
-	__u64	from;
-	__u64	to;
-	__u64	mispred:1,  /* target mispredicted */
-		predicted:1,/* target predicted */
-		in_tx:1,    /* in transaction */
-		abort:1,    /* transaction abort */
-		reserved:60;
-};
-
-/*
  * branch stack layout:
  *  nr: number of taken branches stored in entries[]
  *
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index a77f43a..408b8c7 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -757,4 +757,28 @@ union perf_mem_data_src {
 #define PERF_MEM_S(a, s) \
 	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
 
+/*
+ * single taken branch record layout:
+ *
+ *      from: source instruction (may not always be a branch insn)
+ *        to: branch target
+ *   mispred: branch target was mispredicted
+ * predicted: branch target was predicted
+ *
+ * support for mispred, predicted is optional. In case it
+ * is not supported mispred = predicted = 0.
+ *
+ *     in_tx: running in a hardware transaction
+ *     abort: aborting a hardware transaction
+ */
+struct perf_branch_entry {
+	__u64	from;
+	__u64	to;
+	__u64	mispred:1,  /* target mispredicted */
+		predicted:1,/* target predicted */
+		in_tx:1,    /* in transaction */
+		abort:1,    /* transaction abort */
+		reserved:60;
+};
+
 #endif /* _UAPI_LINUX_PERF_EVENT_H */
