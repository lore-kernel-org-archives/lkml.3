Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3H2KKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:10:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3H2KKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:10:19 -0400
Date: Thu, 29 Aug 2013 03:09:37 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-8nxaole8mb7zyopk47tdellj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Add aliases to remaining syscalls of the sys_enter_newfoo
Git-Commit-ID: e5959683adb6b15cc2aebfbed5aa1315e24a53db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:09:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5959683adb6b15cc2aebfbed5aa1315e24a53db
Gitweb:     http://git.kernel.org/tip/e5959683adb6b15cc2aebfbed5aa1315e24a53db
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 Aug 2013 12:21:41 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Aug 2013 17:25:54 -0300

perf trace: Add aliases to remaining syscalls of the sys_enter_newfoo

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
