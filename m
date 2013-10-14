Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab3JNUaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:30:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38898 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab3JNUDD (ORCPT
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
Subject: [PATCH 063/161] perf trace: Beautify rlmimit resources
Date: Mon, 14 Oct 2013 17:00:52 -0300
Message-Id: <1381780950-25642-64-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

On the getrlimit, setrlimit and prlimit64 syscalls.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pups75313afhn7p96qwhzs9v@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7aa6bcacd51f..7ce036ee863b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -252,6 +252,13 @@ static const char *fcntl_cmds[] = {
 };
 static DEFINE_STRARRAY(fcntl_cmds);
 
+static const char *rlimit_resources[] = {
+	"CPU", "FSIZE", "DATA", "STACK", "CORE", "RSS", "NPROC", "NOFILE",
+	"MEMLOCK", "AS", "LOCKS", "SIGPENDING", "MSGQUEUE", "NICE", "RTPRIO",
+	"RTTIME",
+};
+static DEFINE_STRARRAY(rlimit_resources);
+
 static const char *sighow[] = { "BLOCK", "UNBLOCK", "SETMASK", };
 static DEFINE_STRARRAY(sighow);
 
@@ -466,6 +473,9 @@ static struct syscall_fmt {
 	{ .name	    = "getitimer",  .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
 	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
+	{ .name	    = "getrlimit",  .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* resource */ },
+	  .arg_parm	 = { [0] = &strarray__rlimit_resources, /* resource */ }, },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "kill",	    .errmsg = true,
@@ -498,6 +508,9 @@ static struct syscall_fmt {
 	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "pread",	    .errmsg = true, .alias = "pread64", },
+	{ .name	    = "prlimit64",  .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* resource */ },
+	  .arg_parm	 = { [1] = &strarray__rlimit_resources, /* resource */ }, },
 	{ .name	    = "pwrite",	    .errmsg = true, .alias = "pwrite64", },
 	{ .name	    = "read",	    .errmsg = true, },
 	{ .name	    = "recvfrom",   .errmsg = true, },
@@ -514,6 +527,9 @@ static struct syscall_fmt {
 	{ .name	    = "setitimer",  .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
 	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
+	{ .name	    = "setrlimit",  .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* resource */ },
+	  .arg_parm	 = { [0] = &strarray__rlimit_resources, /* resource */ }, },
 	{ .name	    = "socket",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */
 			     [1] = SCA_SK_TYPE, /* type */ },
-- 
1.8.1.4

