Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab3GRKjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:39:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:56267 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab3GRKgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:36:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,692,1367996400"; 
   d="scan'208";a="347700754"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V8 09/15] perf: Update perf_event_type documentation
Date: Thu, 18 Jul 2013 13:42:51 +0300
Message-Id: <1374144177-24762-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Due to a discussion with Adrian I had a good look at the perf_event_type record
layout and found the documentation to be somewhat unclear.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/uapi/linux/perf_event.h | 19 ++++++++++++++++++-
 kernel/events/core.c            | 31 ++++++++++++++++---------------
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 0b1df41..876a18c 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -478,6 +478,16 @@ enum perf_event_type {
 	 * file will be supported by older perf tools, with these new optional
 	 * fields being ignored.
 	 *
+	 * struct sample_id {
+	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
+	 *	{ u64			time;     } && PERF_SAMPLE_TIME
+	 *	{ u64			id;       } && PERF_SAMPLE_ID
+	 *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
+	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+	 * } && perf_event_attr.sample_id_all
+	 */
+
+	/*
 	 * The MMAP events record the PROT_EXEC mappings so that we can
 	 * correlate userspace IPs to code. They have the following structure:
 	 *
@@ -489,6 +499,7 @@ enum perf_event_type {
 	 *	u64				len;
 	 *	u64				pgoff;
 	 *	char				filename[];
+	 *	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_MMAP			= 1,
@@ -498,6 +509,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u64				id;
 	 *	u64				lost;
+	 *	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_LOST			= 2,
@@ -508,6 +520,7 @@ enum perf_event_type {
 	 *
 	 *	u32				pid, tid;
 	 *	char				comm[];
+	 *	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_COMM			= 3,
@@ -518,6 +531,7 @@ enum perf_event_type {
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
 	 *	u64				time;
+	 *	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_EXIT			= 4,
@@ -528,6 +542,7 @@ enum perf_event_type {
 	 *	u64				time;
 	 *	u64				id;
 	 *	u64				stream_id;
+	 *	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_THROTTLE			= 5,
@@ -539,6 +554,7 @@ enum perf_event_type {
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
 	 *	u64				time;
+	 *	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_FORK			= 7,
@@ -549,6 +565,7 @@ enum perf_event_type {
 	 *	u32				pid, tid;
 	 *
 	 *	struct read_format		values;
+	 *	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_READ			= 8,
@@ -596,7 +613,7 @@ enum perf_event_type {
 	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
-	 *	{ u64			data_src;     } && PERF_SAMPLE_DATA_SRC
+	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 708ab70..c9ef899 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4462,20 +4462,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 		}
 	}
 
-	if (!event->attr.watermark) {
-		int wakeup_events = event->attr.wakeup_events;
-
-		if (wakeup_events) {
-			struct ring_buffer *rb = handle->rb;
-			int events = local_inc_return(&rb->events);
-
-			if (events >= wakeup_events) {
-				local_sub(wakeup_events, &rb->events);
-				local_inc(&rb->wakeup);
-			}
-		}
-	}
-
 	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
 		if (data->br_stack) {
 			size_t size;
@@ -4511,16 +4497,31 @@ void perf_output_sample(struct perf_output_handle *handle,
 		}
 	}
 
-	if (sample_type & PERF_SAMPLE_STACK_USER)
+	if (sample_type & PERF_SAMPLE_STACK_USER) {
 		perf_output_sample_ustack(handle,
 					  data->stack_user_size,
 					  data->regs_user.regs);
+	}
 
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		perf_output_put(handle, data->weight);
 
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		perf_output_put(handle, data->data_src.val);
+
+	if (!event->attr.watermark) {
+		int wakeup_events = event->attr.wakeup_events;
+
+		if (wakeup_events) {
+			struct ring_buffer *rb = handle->rb;
+			int events = local_inc_return(&rb->events);
+
+			if (events >= wakeup_events) {
+				local_sub(wakeup_events, &rb->events);
+				local_inc(&rb->wakeup);
+			}
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
-- 
1.7.11.7

