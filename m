Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab3JOF2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:28:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33315 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab3JOF2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:28:20 -0400
Date: Mon, 14 Oct 2013 22:27:41 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-3a6cwwskobvan823pau76cm4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Use socket'
 s beautifiers in socketpair
Git-Commit-ID: 07120aa5d5a241895bcca8b6e5b5b8d7b1df1f2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:27:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07120aa5d5a241895bcca8b6e5b5b8d7b1df1f2f
Gitweb:     http://git.kernel.org/tip/07120aa5d5a241895bcca8b6e5b5b8d7b1df1f2f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Sep 2013 12:24:20 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:41:16 -0300

perf trace: Use socket's beautifiers in socketpair

For the address family and socket type.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3a6cwwskobvan823pau76cm4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 27b0ec8..bf74217 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -652,6 +652,10 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */
 			     [1] = SCA_SK_TYPE, /* type */ },
 	  .arg_parm	 = { [0] = &strarray__socket_families, /* family */ }, },
+	{ .name	    = "socketpair", .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */
+			     [1] = SCA_SK_TYPE, /* type */ },
+	  .arg_parm	 = { [0] = &strarray__socket_families, /* family */ }, },
 	{ .name	    = "stat",	    .errmsg = true, .alias = "newstat", },
 	{ .name	    = "tgkill",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_SIGNUM, /* sig */ }, },
