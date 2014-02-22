Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaBVR7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:59:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaBVR7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:59:31 -0500
Date: Sat, 22 Feb 2014 09:57:04 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-b58f608e31010cb76ee953a6919f9d96b4eb58d9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1391377150-23920-2-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix memory leak in event_format__print function
Git-Commit-ID: b58f608e31010cb76ee953a6919f9d96b4eb58d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b58f608e31010cb76ee953a6919f9d96b4eb58d9
Gitweb:     http://git.kernel.org/tip/b58f608e31010cb76ee953a6919f9d96b4eb58d9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 2 Feb 2014 22:38:49 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:47 -0300

perf tools: Fix memory leak in event_format__print function

Properly destroying trace_seq object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1391377150-23920-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index e0d6d07f..c36636f 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -126,6 +126,7 @@ void event_format__print(struct event_format *event,
 	trace_seq_init(&s);
 	pevent_event_info(&s, event, &record);
 	trace_seq_do_printf(&s);
+	trace_seq_destroy(&s);
 }
 
 void parse_proc_kallsyms(struct pevent *pevent,
