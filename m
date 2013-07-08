Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3GHTTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:19:37 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58010 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3GHTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:19:36 -0400
Date: Mon, 8 Jul 2013 15:25:13 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf: export struct perf_branch_entry to userspace
Message-ID: <alpine.DEB.2.10.1307081520520.10386@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In include/uapi/linux/perf_event.h we describe the 
PERF_SAMPLE_BRANCH_STACK fields in the PERF_RECORD_SAMPLE
to be of type struct perf_branch_entry, but that structure
is not exported to the user.

Should we not export that structure, something like the following?

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8873f82..65b2553 100644
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
index 0b1df41..c6e2f76 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -685,4 +685,28 @@ union perf_mem_data_src {
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
