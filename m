Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab3JOFVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:21:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262Ab3JOFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:21:35 -0400
Date: Mon, 14 Oct 2013 22:20:58 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-e2epkc38e3x0uqmi1xie4tgc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify rt_sigprocmask 'how' arg
Git-Commit-ID: eb5b1b1475d5ce6ebe84fd4c641545a41839d5f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:21:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb5b1b1475d5ce6ebe84fd4c641545a41839d5f9
Gitweb:     http://git.kernel.org/tip/eb5b1b1475d5ce6ebe84fd4c641545a41839d5f9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 3 Sep 2013 16:37:46 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:10:06 -0300

perf trace: Beautify rt_sigprocmask 'how' arg

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
index 8455a0a..ecc83ce 100644
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
