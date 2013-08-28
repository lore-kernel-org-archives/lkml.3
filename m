Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3H1PDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:03:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40603 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3H1O7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/21] perf trace: Add aliases to remaining syscalls of the sys_enter_newfoo
Date: Wed, 28 Aug 2013 11:59:31 -0300
Message-Id: <1377701977-2085-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Before:

  2392.918 ( 0.008 ms): 21581 lstat(arg0: 140734915488448, arg1: 140734915488240, arg2: 140734915488240, arg3: 3, arg4: 24426352, arg5: 98) = 0

After:

  7408.087 ( 0.013 ms): 21969 lstat(filename: 0x7fff44b4bf20, statbuf: 0x7fff44b4be50               ) = 0

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8nxaole8mb7zyopk47tdellj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b2038fd..2d759f5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -32,16 +32,20 @@ static struct syscall_fmt {
 	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat", },
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
 	{ .name	    = "futex",	    .errmsg = true, },
+	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
 	{ .name	    = "mmap",	    .hexret = true, },
 	{ .name	    = "mremap",	    .hexret = true, },
 	{ .name	    = "open",	    .errmsg = true, },
 	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
+	{ .name	    = "pread",	    .errmsg = true, .alias = "pread64", },
+	{ .name	    = "pwrite",	    .errmsg = true, .alias = "pwrite64", },
 	{ .name	    = "read",	    .errmsg = true, },
 	{ .name	    = "recvfrom",   .errmsg = true, },
 	{ .name	    = "select",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "socket",	    .errmsg = true, },
 	{ .name	    = "stat",	    .errmsg = true, .alias = "newstat", },
+	{ .name	    = "uname",	    .errmsg = true, .alias = "newuname", },
 };
 
 static int syscall_fmt__cmp(const void *name, const void *fmtp)
-- 
1.8.1.4

