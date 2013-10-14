Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab3JNUdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:33:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38880 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3JNUDD (ORCPT
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
Subject: [PATCH 058/161] perf trace: Beautify rt_sigprocmask 'how' arg
Date: Mon, 14 Oct 2013 17:00:47 -0300
Message-Id: <1381780950-25642-59-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-e2epkc38e3x0uqmi1xie4tgc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8455a0af852c..ecc83ce99bfe 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -252,6 +252,9 @@ static const char *fcntl_cmds[] = {
 };
 static DEFINE_STRARRAY(fcntl_cmds);
 
+static const char *sighow[] = { "BLOCK", "UNBLOCK", "SETMASK", };
+static DEFINE_STRARRAY(sighow);
+
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 					       struct syscall_arg *arg)
 {
@@ -366,6 +369,9 @@ static struct syscall_fmt {
 	{ .name	    = "pwrite",	    .errmsg = true, .alias = "pwrite64", },
 	{ .name	    = "read",	    .errmsg = true, },
 	{ .name	    = "recvfrom",   .errmsg = true, },
+	{ .name	    = "rt_sigprocmask", .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* how */ },
+	  .arg_parm	 = { [0] = &strarray__sighow, /* how */ }, },
 	{ .name	    = "select",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "setitimer",  .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
-- 
1.8.1.4

