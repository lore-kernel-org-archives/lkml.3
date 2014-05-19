Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaESMb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:31:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbaESMbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:31:23 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 3/8] perf sched: Cleanup, remove unused variables in map_switch_event()
Date: Mon, 19 May 2014 14:30:51 +0200
Message-Id: <1400502656-20751-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
References: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

In map_switch_event(), we don't care the previous process currently,
this patch remove the infomation we get but not used.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/1400218625-14613-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-sched.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 0b4fe53..d717683 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1266,9 +1266,8 @@ static int process_sched_wakeup_event(struct perf_tool *tool,
 static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 			    struct perf_sample *sample, struct machine *machine)
 {
-	const u32 prev_pid = perf_evsel__intval(evsel, sample, "prev_pid"),
-		  next_pid = perf_evsel__intval(evsel, sample, "next_pid");
-	struct thread *sched_out __maybe_unused, *sched_in;
+	const u32 next_pid = perf_evsel__intval(evsel, sample, "next_pid");
+	struct thread *sched_in;
 	int new_shortname;
 	u64 timestamp0, timestamp = sample->time;
 	s64 delta;
@@ -1291,7 +1290,6 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, 0, prev_pid);
 	sched_in = machine__findnew_thread(machine, 0, next_pid);
 
 	sched->curr_thread[this_cpu] = sched_in;
-- 
1.8.3.1

