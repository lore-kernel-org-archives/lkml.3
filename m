Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab3JNUOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:14:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39105 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 100/161] perf trace: Beautify epoll_ctl 'op' arg
Date: Mon, 14 Oct 2013 17:01:29 -0300
Message-Id: <1381780950-25642-101-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[root@sandy ~]# perf trace -e epoll_ctl
 2.490 (0.003 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: ADD, fd: 24, event: 0x7fff22314ef0) = 0
 2.621 (0.003 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: DEL, fd: 24                       ) = 0
 2.833 (0.010 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: ADD, fd: 24, event: 0x7fff22314cd0) = 0
 2.953 (0.002 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: DEL, fd: 24                       ) = 0
 3.118 (0.002 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: ADD, fd: 24, event: 0x7fff22314d20) = 0
 4.762 (0.002 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: DEL, fd: 24                       ) = 0
^C[root@sandy ~]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-88xz9phc8cbicnxonud6if8h@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f3ddbb008fb4..807e542da623 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -232,6 +232,9 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, struct sysc
 
 #define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
 
+static const char *epoll_ctl_ops[] = { [1] = "ADD", "DEL", "MOD", };
+static DEFINE_STRARRAY(epoll_ctl_ops);
+
 static const char *itimers[] = { "REAL", "VIRTUAL", "PROF", };
 static DEFINE_STRARRAY(itimers);
 
@@ -543,6 +546,9 @@ static struct syscall_fmt {
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
 	{ .name	    = "connect",    .errmsg = true, },
+	{ .name	    = "epoll_ctl",  .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* op */ },
+	  .arg_parm	 = { [1] = &strarray__epoll_ctl_ops, /* op */ }, },
 	{ .name	    = "eventfd2",   .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_EFD_FLAGS, /* flags */ }, },
 	{ .name	    = "fcntl",	    .errmsg = true,
-- 
1.8.1.4

