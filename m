Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966132Ab3GSHxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:53:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35869 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965772Ab3GSHxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:53:20 -0400
Date: Fri, 19 Jul 2013 00:52:53 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c85cffa5894fad8ad7c8051ccf7dd73a3a3f92b6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, trenn@suse.de, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, trenn@suse.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1373556513-3000-2-git-send-email-jolsa@redhat.com>
References: <1373556513-3000-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Use traceevent lib event-parse.h include
Git-Commit-ID: c85cffa5894fad8ad7c8051ccf7dd73a3a3f92b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:53:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c85cffa5894fad8ad7c8051ccf7dd73a3a3f92b6
Gitweb:     http://git.kernel.org/tip/c85cffa5894fad8ad7c8051ccf7dd73a3a3f92b6
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 11 Jul 2013 17:28:29 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 15 Jul 2013 16:09:07 -0300

perf timechart: Use traceevent lib event-parse.h include

Adding traceevent lib event-parse.h include to timechart command and
removing duplicated local 'enum trace_flag_type' definition.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Renninger <trenn@suse.de>
Link: http://lkml.kernel.org/r/1373556513-3000-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 4536a92..a512009 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -12,6 +12,8 @@
  * of the License.
  */
 
+#include <traceevent/event-parse.h>
+
 #include "builtin.h"
 
 #include "util/util.h"
@@ -328,25 +330,6 @@ struct wakeup_entry {
 	int   success;
 };
 
-/*
- * trace_flag_type is an enumeration that holds different
- * states when a trace occurs. These are:
- *  IRQS_OFF            - interrupts were disabled
- *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
- *  NEED_RESCED         - reschedule is requested
- *  HARDIRQ             - inside an interrupt handler
- *  SOFTIRQ             - inside a softirq handler
- */
-enum trace_flag_type {
-	TRACE_FLAG_IRQS_OFF		= 0x01,
-	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
-	TRACE_FLAG_NEED_RESCHED		= 0x04,
-	TRACE_FLAG_HARDIRQ		= 0x08,
-	TRACE_FLAG_SOFTIRQ		= 0x10,
-};
-
-
-
 struct sched_switch {
 	struct trace_entry te;
 	char prev_comm[TASK_COMM_LEN];
