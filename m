Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3ITJ5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:57:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3ITJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:57:31 -0400
Date: Fri, 20 Sep 2013 02:56:50 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-0f9654296eabf7f238661d20a6af545986cf713f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <20130912131649.GC23826@gmail.com>
References: <20130912131649.GC23826@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix old GCC build error in trace-event-parse.c:parse_proc_kallsyms()
Git-Commit-ID: 0f9654296eabf7f238661d20a6af545986cf713f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 02:56:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f9654296eabf7f238661d20a6af545986cf713f
Gitweb:     http://git.kernel.org/tip/0f9654296eabf7f238661d20a6af545986cf713f
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 12 Sep 2013 15:16:49 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Sep 2013 15:08:47 -0300

perf tools: Fix old GCC build error in trace-event-parse.c:parse_proc_kallsyms()

Old GCC (4.1) does not see through the code flow of parse_proc_kallsyms()
and gets confused about the status of 'fmt':

 util/trace-event-parse.c: In function ‘parse_proc_kallsyms’:
 util/trace-event-parse.c:189: warning: ‘fmt’ may be used uninitialized in this function
 make: *** [util/trace-event-parse.o] Error 1

Help out GCC by initializing 'fmt' to NULL.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130912131649.GC23826@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index fe7a27d..e9e1c03 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -186,7 +186,7 @@ void parse_proc_kallsyms(struct pevent *pevent,
 	char *next = NULL;
 	char *addr_str;
 	char *mod;
-	char *fmt;
+	char *fmt = NULL;
 
 	line = strtok_r(file, "\n", &next);
 	while (line) {
