Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab3JNUYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:24:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38963 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab3JNUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 069/161] perf trace: Add option to show process COMM
Date: Mon, 14 Oct 2013 17:00:58 -0300
Message-Id: <1381780950-25642-70-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Enabled by default, disable with --no-comm, e.g.:

 181.821 (0.001 ms): deja-dup-monit/10784 recvmsg(fd: 8, msg: 0x7fff4342baf0, flags: PEEK|TRUNC|CMSG_CLOEXEC ) = 20
 181.824 (0.001 ms): deja-dup-monit/10784 geteuid(                                                           ) = 1000
 181.825 (0.001 ms): deja-dup-monit/10784 getegid(                                                           ) = 1000
 181.834 (0.002 ms): deja-dup-monit/10784 recvmsg(fd: 8, msg: 0x7fff4342baf0, flags: CMSG_CLOEXEC            ) = 20
 181.836 (0.001 ms): deja-dup-monit/10784 geteuid(                                                           ) = 1000
 181.838 (0.001 ms): deja-dup-monit/10784 getegid(                                                           ) = 1000
 181.705 (0.003 ms): evolution-addr/10924 recvmsg(fd: 10, msg: 0x7fff17dc6990, flags: PEEK|TRUNC|CMSG_CLOEXEC) = 1256
 181.710 (0.002 ms): evolution-addr/10924 geteuid(                                                           ) = 1000
 181.712 (0.001 ms): evolution-addr/10924 getegid(                                                           ) = 1000
 181.727 (0.003 ms): evolution-addr/10924 recvmsg(fd: 10, msg: 0x7fff17dc6990, flags: CMSG_CLOEXEC           ) = 1256
 181.731 (0.001 ms): evolution-addr/10924 geteuid(                                                           ) = 1000
 181.734 (0.001 ms): evolution-addr/10924 getegid(                                                           ) = 1000
 181.908 (0.002 ms): evolution-addr/10924 recvmsg(fd: 10, msg: 0x7fff17dc6990, flags: PEEK|TRUNC|CMSG_CLOEXEC) = 20
 181.913 (0.001 ms): evolution-addr/10924 geteuid(                                                           ) = 1000
 181.915 (0.001 ms): evolution-addr/10924 getegid(                                                           ) = 1000
 181.930 (0.003 ms): evolution-addr/10924 recvmsg(fd: 10, msg: 0x7fff17dc6990, flags: CMSG_CLOEXEC           ) = 20
 181.934 (0.001 ms): evolution-addr/10924 geteuid(                                                           ) = 1000
 181.937 (0.001 ms): evolution-addr/10924 getegid(                                                           ) = 1000
 220.718 (0.010 ms): at-spi2-regist/10715 sendmsg(fd: 3, msg: 0x7fffdb8756c0, flags: NOSIGNAL                ) = 200
 220.741 (0.000 ms): dbus-daemon/10711  ... [continued]: epoll_wait()) = 1
 220.759 (0.004 ms): dbus-daemon/10711 recvmsg(fd: 11, msg: 0x7ffff94594d0, flags: CMSG_CLOEXEC              ) = 200
 220.780 (0.002 ms): dbus-daemon/10711 recvmsg(fd: 11, msg: 0x7ffff94594d0, flags: CMSG_CLOEXEC              ) = 200
 220.788 (0.001 ms): dbus-daemon/10711 recvmsg(fd: 11, msg: 0x7ffff94594d0, flags: CMSG_CLOEXEC              ) = -1 EAGAIN Resource temporarily unavailable
 220.760 (0.004 ms): at-spi2-regist/10715 sendmsg(fd: 3, msg: 0x7fffdb8756c0, flags: NOSIGNAL                ) = 200
 220.771 (0.023 ms): perf/26347 open(filename: 0xf2e780, mode: 15918976                               ) = 19
 220.850 (0.002 ms): perf/26347 close(fd: 19                                                          ) = 0

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6be5jvnkdzjptdrebfn5263n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt | 3 +++
 tools/perf/builtin-trace.c              | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index a93e91aad583..37773854d5c4 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -82,6 +82,9 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --time
 	Print full timestamp rather time relative to first sample.
 
+--comm::
+        Show process COMM right beside its ID, on by default, disable with --no-comm.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8a09ba3dcd97..be658433d3bb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -726,6 +726,7 @@ struct trace {
 	struct intlist		*pid_list;
 	bool			sched;
 	bool			multiple_threads;
+	bool			show_comm;
 	double			duration_filter;
 	double			runtime_ms;
 };
@@ -755,8 +756,11 @@ static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thre
 	size_t printed = trace__fprintf_tstamp(trace, tstamp, fp);
 	printed += fprintf_duration(duration, fp);
 
-	if (trace->multiple_threads)
+	if (trace->multiple_threads) {
+		if (trace->show_comm)
+			printed += fprintf(fp, "%.14s/", thread->comm);
 		printed += fprintf(fp, "%d ", thread->tid);
+	}
 
 	return printed;
 }
@@ -1503,10 +1507,13 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 			.mmap_pages    = 1024,
 		},
 		.output = stdout,
+		.show_comm = true,
 	};
 	const char *output_name = NULL;
 	const char *ev_qualifier_str = NULL;
 	const struct option trace_options[] = {
+	OPT_BOOLEAN(0, "comm", &trace.show_comm,
+		    "show the thread COMM next to its id"),
 	OPT_STRING('e', "expr", &ev_qualifier_str, "expr",
 		    "list of events to trace"),
 	OPT_STRING('o', "output", &output_name, "file", "output file name"),
-- 
1.8.1.4

