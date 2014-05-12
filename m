Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaELSTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:19:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:36836 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaELSTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:19:48 -0400
Date: Mon, 12 May 2014 20:19:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: perf,tools: Remove usage of trace_sched_wakeup(.success)
Message-ID: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_sched_wakeup(.success) is a dead argument and has been for ages,
the only reason its still there is because of brain dead software, which
apparently includes perf tools

There's a few more instances in pearly snake shit, but that's not
supported as far as I care anyhow, so let that bitrot.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-sched.c        | 7 +------
 tools/perf/tests/evsel-tp-sched.c | 3 ---
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d3fb0ed7240a..ef33a2632abe 100644
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
index 4774f7fbb758..35d7fdb2328d 100644
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
 
