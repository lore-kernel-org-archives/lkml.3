Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaEPGhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:37:10 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:50239 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753894AbaEPGhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:37:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,1065,1389715200"; 
   d="scan'208";a="30605796"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <acme@kernel.org>, <jolsa@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] perf_tools/sched: cleanup, remove unused variables in map_switch_event().
Date: Fri, 16 May 2014 14:37:05 +0900
Message-ID: <1400218625-14613-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In map_switch_event(), we don't care the previous process currently,
this patch remove the infomation we get but not used.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-sched.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2579215..1eb2369 100644
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
1.8.2.1

