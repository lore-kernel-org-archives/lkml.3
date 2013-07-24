Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3GXD4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:56:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38391 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3GXD42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:56:28 -0400
Date: Tue, 23 Jul 2013 20:55:54 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <20130716150907.GL23818@dyad.programming.kicks-ass.net>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Update perf_event_type documentation
Git-Commit-ID: a5cdd40c9877e9aba704c020fd65d26b5cfecf18
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 20:56:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5cdd40c9877e9aba704c020fd65d26b5cfecf18
Gitweb:     http://git.kernel.org/tip/a5cdd40c9877e9aba704c020fd65d26b5cfecf18
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 16 Jul 2013 17:09:07 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Jul 2013 12:17:08 +0200

perf: Update perf_event_type documentation

Due to a discussion with Adrian I had a good look at the perf_event_type record
layout and found the documentation to be somewhat unclear.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130716150907.GL23818@dyad.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h | 18 +++++++++++++++++-
 kernel/events/core.c            | 31 ++++++++++++++++---------------
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 0b1df41..00d8274 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -478,6 +478,16 @@ enum perf_event_type {
 	 * file will be supported by older perf tools, with these new optional
 	 * fields being ignored.
 	 *
+	 * struct sample_id {
+	 * 	{ u32			pid, tid; } && PERF_SAMPLE_TID
+	 * 	{ u64			time;     } && PERF_SAMPLE_TIME
+	 * 	{ u64			id;       } && PERF_SAMPLE_ID
+	 * 	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
+	 * 	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+	 * } && perf_event_attr::sample_id_all
+	 */
+
+	/*
 	 * The MMAP events record the PROT_EXEC mappings so that we can
 	 * correlate userspace IPs to code. They have the following structure:
 	 *
@@ -498,6 +508,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u64				id;
 	 *	u64				lost;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_LOST			= 2,
@@ -508,6 +519,7 @@ enum perf_event_type {
 	 *
 	 *	u32				pid, tid;
 	 *	char				comm[];
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_COMM			= 3,
@@ -518,6 +530,7 @@ enum perf_event_type {
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
 	 *	u64				time;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_EXIT			= 4,
@@ -528,6 +541,7 @@ enum perf_event_type {
 	 *	u64				time;
 	 *	u64				id;
 	 *	u64				stream_id;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_THROTTLE			= 5,
@@ -539,6 +553,7 @@ enum perf_event_type {
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
 	 *	u64				time;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_FORK			= 7,
@@ -549,6 +564,7 @@ enum perf_event_type {
 	 *	u32				pid, tid;
 	 *
 	 *	struct read_format		values;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_READ			= 8,
@@ -596,7 +612,7 @@ enum perf_event_type {
 	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
-	 *	{ u64			data_src;     } && PERF_SAMPLE_DATA_SRC
+	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5e2bce9..1274114 100644
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
