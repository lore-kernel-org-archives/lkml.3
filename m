Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab3JOF2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:28:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813Ab3JOF2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:28:35 -0400
Date: Mon, 14 Oct 2013 22:27:59 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-4f8c1b74c5fdac35ee4480685d42030446724848@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1379900700-5186-6-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-6-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add beautifier for clock_gettime'
 s clk_id argument
Git-Commit-ID: 4f8c1b74c5fdac35ee4480685d42030446724848
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:28:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f8c1b74c5fdac35ee4480685d42030446724848
Gitweb:     http://git.kernel.org/tip/4f8c1b74c5fdac35ee4480685d42030446724848
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 22 Sep 2013 19:45:00 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:41:42 -0300

perf trace: Add beautifier for clock_gettime's clk_id argument

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
index 76d9427..39a947a 100644
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
