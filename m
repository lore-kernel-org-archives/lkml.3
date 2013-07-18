Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965157Ab3GRUBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:01:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41645 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395Ab3GRTu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 41/76] perf inject: Remove unused parameter
Date: Thu, 18 Jul 2013 16:49:28 -0300
Message-Id: <1374177003-3706-42-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The 'machine' parameter is unused in 'perf_event__repipe_synth()' and
some callers pass NULL anyway.  So remove it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1372944040-32690-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 84ad6ab..f299ddf 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -38,8 +38,7 @@ struct event_entry {
 };
 
 static int perf_event__repipe_synth(struct perf_tool *tool,
-				    union perf_event *event,
-				    struct machine *machine __maybe_unused)
+				    union perf_event *event)
 {
 	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
 	uint32_t size;
@@ -65,20 +64,20 @@ static int perf_event__repipe_op2_synth(struct perf_tool *tool,
 					struct perf_session *session
 					__maybe_unused)
 {
-	return perf_event__repipe_synth(tool, event, NULL);
+	return perf_event__repipe_synth(tool, event);
 }
 
 static int perf_event__repipe_event_type_synth(struct perf_tool *tool,
 					       union perf_event *event)
 {
-	return perf_event__repipe_synth(tool, event, NULL);
+	return perf_event__repipe_synth(tool, event);
 }
 
 static int perf_event__repipe_tracing_data_synth(union perf_event *event,
 						 struct perf_session *session
 						 __maybe_unused)
 {
-	return perf_event__repipe_synth(NULL, event, NULL);
+	return perf_event__repipe_synth(NULL, event);
 }
 
 static int perf_event__repipe_attr(union perf_event *event,
@@ -89,15 +88,15 @@ static int perf_event__repipe_attr(union perf_event *event,
 	if (ret)
 		return ret;
 
-	return perf_event__repipe_synth(NULL, event, NULL);
+	return perf_event__repipe_synth(NULL, event);
 }
 
 static int perf_event__repipe(struct perf_tool *tool,
 			      union perf_event *event,
 			      struct perf_sample *sample __maybe_unused,
-			      struct machine *machine)
+			      struct machine *machine __maybe_unused)
 {
-	return perf_event__repipe_synth(tool, event, machine);
+	return perf_event__repipe_synth(tool, event);
 }
 
 typedef int (*inject_handler)(struct perf_tool *tool,
@@ -119,7 +118,7 @@ static int perf_event__repipe_sample(struct perf_tool *tool,
 
 	build_id__mark_dso_hit(tool, event, sample, evsel, machine);
 
-	return perf_event__repipe_synth(tool, event, machine);
+	return perf_event__repipe_synth(tool, event);
 }
 
 static int perf_event__repipe_mmap(struct perf_tool *tool,
@@ -153,7 +152,7 @@ static int perf_event__repipe_tracing_data(union perf_event *event,
 {
 	int err;
 
-	perf_event__repipe_synth(NULL, event, NULL);
+	perf_event__repipe_synth(NULL, event);
 	err = perf_event__process_tracing_data(event, session);
 
 	return err;
-- 
1.8.1.4

