Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaGVNby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:31:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:45360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbaGVNUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985539"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/52] perf tools: Add cpu to struct thread
Date: Tue, 22 Jul 2014 16:17:24 +0300
Message-Id: <1406035081-14301-16-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
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
index 08f9f8b..a9df7f2 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -34,6 +34,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->pid_ = pid;
 		thread->tid = tid;
 		thread->ppid = -1;
+		thread->cpu = -1;
 		INIT_LIST_HEAD(&thread->comm_list);
 
 		comm_str = malloc(32);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 9991e21..8c75fa7 100644
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

