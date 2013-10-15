Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab3JOFsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:48:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32789 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab3JOFWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:22:17 -0400
Date: Mon, 14 Oct 2013 22:21:42 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-pups75313afhn7p96qwhzs9v@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify rlmimit resources
Git-Commit-ID: c045bf02e47664af67f8970a6a67065ff51acf62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:21:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c045bf02e47664af67f8970a6a67065ff51acf62
Gitweb:     http://git.kernel.org/tip/c045bf02e47664af67f8970a6a67065ff51acf62
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 4 Sep 2013 11:52:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:10:42 -0300

perf trace: Beautify rlmimit resources

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
index 7aa6bca..7ce036e 100644
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
