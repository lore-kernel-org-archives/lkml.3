Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaG1IY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:24:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42462 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaG1IY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:24:26 -0400
Date: Mon, 28 Jul 2014 01:23:26 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-bf49c35f630452d85c9cd7205a72df841e8d99b9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-16-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-16-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add cpu to struct thread
Git-Commit-ID: bf49c35f630452d85c9cd7205a72df841e8d99b9
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

Commit-ID:  bf49c35f630452d85c9cd7205a72df841e8d99b9
Gitweb:     http://git.kernel.org/tip/bf49c35f630452d85c9cd7205a72df841e8d99b9
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:24 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 11:27:50 -0300

perf tools: Add cpu to struct thread

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
index 9692c06..12c7a25 100644
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
index 3c0c272..716b772 100644
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
