Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbaGYPh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:37:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:34971 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:37:52 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/27] perf tools: Add cpu to struct thread
Date: Fri, 25 Jul 2014 12:36:50 -0300
Message-Id: <1406302629-11790-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Tools may wish to track on which cpu a thread is running.  Add 'cpu' to
struct thread for that purpose.

This will be used to determine the cpu when decoding a per-thread
Instruction Trace.

E.g: Intel PT decoding uses sched_switch events to determine which task
is running on which cpu.  The Intel PT data comes straight from the
hardware which doesn't know about linux threads.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-16-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c | 1 +
 tools/perf/util/thread.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 9692c06a9e21..12c7a253a63c 100644
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
index 3c0c2724f82c..716b7723cce2 100644
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
1.9.3

