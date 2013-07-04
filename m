Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3GDNOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:14:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:61212 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab3GDNOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:14:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,995,1363158000"; 
   d="scan'208";a="264087778"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V4 01/21] perf tools: remove unused parameter
Date: Thu,  4 Jul 2013 16:20:20 +0300
Message-Id: <1372944040-32690-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'machine' is unused in 'perf_event__repipe_synth()' and some
callers pass NULL anyway.  So remove it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
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
1.7.11.7

