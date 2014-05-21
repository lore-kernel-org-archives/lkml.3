Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaEUFzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:55:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaEUFzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:55:38 -0400
Date: Tue, 20 May 2014 22:54:28 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-0680ee7db16de9c02d1d4b1a935a5daf754fe8a1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove usage of trace_sched_wakeup(
 .success)
Git-Commit-ID: 0680ee7db16de9c02d1d4b1a935a5daf754fe8a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0680ee7db16de9c02d1d4b1a935a5daf754fe8a1
Gitweb:     http://git.kernel.org/tip/0680ee7db16de9c02d1d4b1a935a5daf754fe8a1
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 12 May 2014 20:19:46 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 12 May 2014 21:13:44 +0200

perf tools: Remove usage of trace_sched_wakeup(.success)

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
 
