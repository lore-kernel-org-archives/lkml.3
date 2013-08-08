Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999Ab3HHCvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:51:48 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46436 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946Ab3HHCvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:45 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/19] perf sched: pass event to evsel handlers using data element
Date: Wed,  7 Aug 2013 22:50:56 -0400
Message-Id: <1375930261-77273-15-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcoming timehist command needs access to the event. Use the existing
handler.data element to do that.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f809cc7..1ec1ff4 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1415,7 +1415,7 @@ typedef int (*tracepoint_handler)(struct perf_tool *tool,
 				  struct machine *machine);
 
 static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_unused,
-						 union perf_event *event __maybe_unused,
+						 union perf_event *event,
 						 struct perf_sample *sample,
 						 struct perf_evsel *evsel,
 						 struct machine *machine)
@@ -1427,6 +1427,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
+		evsel->handler.data = event;
 		err = f(tool, evsel, sample, machine);
 	}
 
-- 
1.7.10.1

