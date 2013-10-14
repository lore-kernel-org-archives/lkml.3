Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab3JNUOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:14:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39083 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 106/161] perf trace: Add beautifier for clock_gettime's clk_id argument
Date: Mon, 14 Oct 2013 17:01:35 -0300
Message-Id: <1381780950-25642-107-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Before:
0.030 ( 0.002 ms): 2571 clock_gettime(which_clock: 1, tp: 0x7f3b45729cd0 ) = 0

After:
0.030 ( 0.002 ms): 2571 clock_gettime(which_clock: MONOTONIC, tp: 0x7f3b45729cd0 ) = 0

v2: Update to use the STRARRAY option

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1379900700-5186-6-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 76d9427b4b91..39a947a0d122 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -297,6 +297,12 @@ static DEFINE_STRARRAY(rlimit_resources);
 static const char *sighow[] = { "BLOCK", "UNBLOCK", "SETMASK", };
 static DEFINE_STRARRAY(sighow);
 
+static const char *clockid[] = {
+	"REALTIME", "MONOTONIC", "PROCESS_CPUTIME_ID", "THREAD_CPUTIME_ID",
+	"MONOTONIC_RAW", "REALTIME_COARSE", "MONOTONIC_COARSE",
+};
+static DEFINE_STRARRAY(clockid);
+
 static const char *socket_families[] = {
 	"UNSPEC", "LOCAL", "INET", "AX25", "IPX", "APPLETALK", "NETROM",
 	"BRIDGE", "ATMPVC", "X25", "INET6", "ROSE", "DECnet", "NETBEUI",
@@ -603,6 +609,7 @@ static struct syscall_fmt {
 	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
+	{ .name     = "clock_gettime",  .errmsg = true, STRARRAY(0, clk_id, clockid), },
 	{ .name	    = "connect",    .errmsg = true, },
 	{ .name	    = "epoll_ctl",  .errmsg = true, STRARRAY(1, op, epoll_ctl_ops), },
 	{ .name	    = "eventfd2",   .errmsg = true,
-- 
1.8.1.4

