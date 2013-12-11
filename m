Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3LKMiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:38:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:16968 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3LKMiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:38:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450497342"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 13/71] perf tools: Add machine__get_thread_pid()
Date: Wed, 11 Dec 2013 14:36:25 +0200
Message-Id: <1386765443-26966-14-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to get the pid from the tid.

This is needed when using the sched_switch
tracepoint to follow object code execution.
sched_switch identifies the thread but, to
find the process mmaps, we need the process
pid.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 10 ++++++++++
 tools/perf/util/machine.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index bac817a..55f3608 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1402,3 +1402,13 @@ int __machine__synthesize_threads(struct machine *machine, struct perf_tool *too
 	/* command specified */
 	return 0;
 }
+
+pid_t machine__get_thread_pid(struct machine *machine, pid_t tid)
+{
+	struct thread *thread = machine__find_thread(machine, tid);
+
+	if (!thread)
+		return -1;
+
+	return thread->pid_;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 4771330..b800a5a 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -190,4 +190,6 @@ int machine__synthesize_threads(struct machine *machine, struct target *target,
 					     perf_event__process, data_mmap);
 }
 
+pid_t machine__get_thread_pid(struct machine *machine, pid_t tid);
+
 #endif /* __PERF_MACHINE_H */
-- 
1.8.5.1

