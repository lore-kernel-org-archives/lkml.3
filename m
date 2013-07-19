Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965682Ab3GSHuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:50:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35604 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759717Ab3GSHuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:50:02 -0400
Date: Fri, 19 Jul 2013 00:49:15 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-63c2c9f8f24378ebf46d4a9d542863bb733ef05c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1372944040-32690-2-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf inject: Remove unused parameter
Git-Commit-ID: 63c2c9f8f24378ebf46d4a9d542863bb733ef05c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:49:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63c2c9f8f24378ebf46d4a9d542863bb733ef05c
Gitweb:     http://git.kernel.org/tip/63c2c9f8f24378ebf46d4a9d542863bb733ef05c
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 4 Jul 2013 16:20:20 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:47 -0300

perf inject: Remove unused parameter

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
