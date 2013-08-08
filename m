Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab3HHCz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:55:58 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36019 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810Ab3HHCvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:17 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/19] perf sched: Remove thread lookup in sample handler
Date: Wed,  7 Aug 2013 22:50:45 -0400
Message-Id: <1375930261-77273-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not used in the function, so no sense in doing the lookup here. Thread look
up will be done in the timehist command, and no sense in doing it twice.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-sched.c |    7 -------
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
1.7.10.1

