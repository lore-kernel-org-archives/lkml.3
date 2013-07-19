Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807Ab3GSHpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:45:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35250 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3GSHp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:45:27 -0400
Date: Fri, 19 Jul 2013 00:44:53 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-b3824404ebbd489858f3a7097c715120118fa5cd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1372793245-4136-3-git-send-email-dsahern@gmail.com>
References: <1372793245-4136-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Fix use of uninitialized variable
Git-Commit-ID: b3824404ebbd489858f3a7097c715120118fa5cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:44:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3824404ebbd489858f3a7097c715120118fa5cd
Gitweb:     http://git.kernel.org/tip/b3824404ebbd489858f3a7097c715120118fa5cd
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 2 Jul 2013 13:27:21 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:46:12 -0300

perf evlist: Fix use of uninitialized variable

Fixes valgrind complaint:
==1870== Syscall param write(buf) points to uninitialised byte(s)
==1870==    at 0x4E3F5B0: __write_nocancel (in /lib64/libpthread-2.14.90.so)
==1870==    by 0x449D7C: perf_evlist__start_workload (evlist.c:846)
==1870==    by 0x427BC1: cmd_record (builtin-record.c:561)
==1870==    by 0x419D72: run_builtin (perf.c:319)
==1870==    by 0x4195F2: main (perf.c:376)
==1870==  Address 0x7feffcdd7 is on thread 1's stack

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1372793245-4136-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4a901be..d8f34e0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -838,7 +838,7 @@ out_close_ready_pipe:
 int perf_evlist__start_workload(struct perf_evlist *evlist)
 {
 	if (evlist->workload.cork_fd > 0) {
-		char bf;
+		char bf = 0;
 		int ret;
 		/*
 		 * Remove the cork, let it rip!
