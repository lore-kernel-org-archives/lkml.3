Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3IWBpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:45:53 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65248 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3IWBpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:45:17 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/5] perf trace: Add beautifier for clock_gettime's clk_id argument - v2
Date: Sun, 22 Sep 2013 19:45:00 -0600
Message-Id: <1379900700-5186-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/builtin-trace.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f61c968..636a506 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -280,6 +280,12 @@ static DEFINE_STRARRAY(rlimit_resources);
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
@@ -566,6 +572,7 @@ static struct syscall_fmt {
 	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
+	{ .name     = "clock_gettime",  .errmsg = true, STRARRAY(0, clk_id, clockid), },
 	{ .name	    = "connect",    .errmsg = true, },
 	{ .name	    = "epoll_ctl",  .errmsg = true, STRARRAY(1, op, epoll_ctl_ops), },
 	{ .name	    = "eventfd2",   .errmsg = true,
-- 
1.7.10.1

