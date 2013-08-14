Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab3HNSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:25:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34339 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760199Ab3HNSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/21] perf sched: Remove thread lookup in sample handler
Date: Wed, 14 Aug 2013 15:24:58 -0300
Message-Id: <1376504715-28107-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Not used in the function, so no sense in doing the lookup here. Thread
look up will be done in the timehist command, and no sense in doing it
twice.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 34ce57d..5285024 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1425,15 +1425,8 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 						 struct perf_evsel *evsel,
 						 struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
 	int err = 0;
 
-	if (thread == NULL) {
-		pr_debug("problem processing %s event, skipping it.\n",
-			 perf_evsel__name(evsel));
-		return -1;
-	}
-
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 
-- 
1.8.1.4

