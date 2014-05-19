Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaESMb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:31:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbaESMb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:31:26 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 1/8] perf tools: Remove usage of trace_sched_wakeup(.success)
Date: Mon, 19 May 2014 14:30:49 +0200
Message-Id: <1400502656-20751-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
References: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

trace_sched_wakeup(.success) is a dead argument and has been for ages,
the only reason its still there is because of brain dead software, which
apparently includes perf tools

There's a few more instances in pearly snake shit, but that's not
supported as far as I care anyhow, so let that bitrot.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140512181946.GG13467@laptop.programming.kicks-ass.net
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-sched.c        | 7 +------
 tools/perf/tests/evsel-tp-sched.c | 3 ---
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2579215..a3320f1 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1007,17 +1007,12 @@ static int latency_wakeup_event(struct perf_sched *sched,
 				struct perf_sample *sample,
 				struct machine *machine)
 {
-	const u32 pid	  = perf_evsel__intval(evsel, sample, "pid"),
-		  success = perf_evsel__intval(evsel, sample, "success");
+	const u32 pid	  = perf_evsel__intval(evsel, sample, "pid");
 	struct work_atoms *atoms;
 	struct work_atom *atom;
 	struct thread *wakee;
 	u64 timestamp = sample->time;
 
-	/* Note for later, it may be interesting to observe the failing cases */
-	if (!success)
-		return 0;
-
 	wakee = machine__findnew_thread(machine, 0, pid);
 	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 	if (!atoms) {
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index 4774f7f..35d7fdb 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -74,9 +74,6 @@ int test__perf_evsel__tp_sched_test(void)
 	if (perf_evsel__test_field(evsel, "prio", 4, true))
 		ret = -1;
 
-	if (perf_evsel__test_field(evsel, "success", 4, true))
-		ret = -1;
-
 	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
 		ret = -1;
 
-- 
1.8.3.1

