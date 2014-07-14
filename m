Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbaGNKOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:14:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:41917 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbaGNKFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434519"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 24/41] perf tools: Add cpu to struct thread
Date: Mon, 14 Jul 2014 13:02:48 +0300
Message-Id: <1405332185-4050-25-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tools may wish to track on which cpu a thread
is running.  Add 'cpu' to struct thread for
that purpose.

This will be used to determine the cpu when
decoding a per-thread Instruction Trace.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/thread.c | 1 +
 tools/perf/util/thread.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index b9a3ee4..2f8c0c1 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -69,6 +69,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->pid_ = pid;
 		thread->tid = tid;
 		thread->ppid = -1;
+		thread->cpu = -1;
 		INIT_LIST_HEAD(&thread->comm_list);
 
 		comm_str = malloc(32);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index b4269af..e4920ff 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -17,6 +17,7 @@ struct thread {
 	pid_t			pid_; /* Not all tools update this */
 	pid_t			tid;
 	pid_t			ppid;
+	int			cpu;
 	char			shortname[3];
 	bool			comm_set;
 	bool			dead; /* if set thread has exited */
-- 
1.8.3.2

