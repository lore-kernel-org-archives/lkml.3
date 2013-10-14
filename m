Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3JNUao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:30:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38910 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab3JNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 057/161] perf trace: Beautify fcntl 'cmd' arg
Date: Mon, 14 Oct 2013 17:00:46 -0300
Message-Id: <1381780950-25642-58-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This is just for the low hanging fruit 'cmd' arg, a proper beautifier
will as well use arg->mask to ignore the third arg for some of the
cmds.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-phhvcyi9vdnxw9l11tbquvru@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7cb60526a6f1..8455a0af852c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -244,6 +244,14 @@ static const char *whences[] = { "SET", "CUR", "END",
 };
 static DEFINE_STRARRAY(whences);
 
+static const char *fcntl_cmds[] = {
+	"DUPFD", "GETFD", "SETFD", "GETFL", "SETFL", "GETLK", "SETLK",
+	"SETLKW", "SETOWN", "GETOWN", "SETSIG", "GETSIG", "F_GETLK64",
+	"F_SETLK64", "F_SETLKW64", "F_SETOWN_EX", "F_GETOWN_EX",
+	"F_GETOWNER_UIDS",
+};
+static DEFINE_STRARRAY(fcntl_cmds);
+
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 					       struct syscall_arg *arg)
 {
@@ -315,6 +323,9 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
 	{ .name	    = "mmap",	    .hexret = true, },
 	{ .name	    = "connect",    .errmsg = true, },
+	{ .name	    = "fcntl",	    .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* cmd */ },
+	  .arg_parm	 = { [1] = &strarray__fcntl_cmds, /* cmd */ }, },
 	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat", },
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
 	{ .name	    = "futex",	    .errmsg = true,
-- 
1.8.1.4

