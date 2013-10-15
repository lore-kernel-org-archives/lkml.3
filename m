Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab3JOFVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:21:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab3JOFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:21:35 -0400
Date: Mon, 14 Oct 2013 22:20:50 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-phhvcyi9vdnxw9l11tbquvru@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify fcntl 'cmd' arg
Git-Commit-ID: 80f587d5f9424ebdf93abbe79ab87e7fb7d4699d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:20:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80f587d5f9424ebdf93abbe79ab87e7fb7d4699d
Gitweb:     http://git.kernel.org/tip/80f587d5f9424ebdf93abbe79ab87e7fb7d4699d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 3 Sep 2013 16:28:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:09:58 -0300

perf trace: Beautify fcntl 'cmd' arg

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
index 7cb6052..8455a0a 100644
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
