Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaEUFzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:55:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaEUFzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:55:08 -0400
Date: Tue, 20 May 2014 22:54:51 -0700
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-9d372ca59bcb9339b4a34a9bf978a1fc15b68b03@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <1400218625-14613-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1400218625-14613-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Cleanup,
  remove unused variables in map_switch_event()
Git-Commit-ID: 9d372ca59bcb9339b4a34a9bf978a1fc15b68b03
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

Commit-ID:  9d372ca59bcb9339b4a34a9bf978a1fc15b68b03
Gitweb:     http://git.kernel.org/tip/9d372ca59bcb9339b4a34a9bf978a1fc15b68b03
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Fri, 16 May 2014 14:37:05 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 16 May 2014 09:17:50 +0200

perf sched: Cleanup, remove unused variables in map_switch_event()

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
