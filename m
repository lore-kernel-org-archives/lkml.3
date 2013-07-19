Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935379Ab3GSHsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:48:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935322Ab3GSHsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:48:17 -0400
Date: Fri, 19 Jul 2013 00:47:59 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-45a9ee1b3fa2d8c3fb7a0c7e5a7b77281a4239a6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1370323231-14022-17-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-17-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util:
  Remove unused enum and macro in trace-event.h
Git-Commit-ID: 45a9ee1b3fa2d8c3fb7a0c7e5a7b77281a4239a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:48:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45a9ee1b3fa2d8c3fb7a0c7e5a7b77281a4239a6
Gitweb:     http://git.kernel.org/tip/45a9ee1b3fa2d8c3fb7a0c7e5a7b77281a4239a6
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:33 -0300

perf util: Remove unused enum and macro in trace-event.h

They're internals of ftrace ring-buffer and not used in perf code
directly.  As it now resides on libtraceevent/kbuffer.h, just get rid of
them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-17-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index ed30c9c..669a64a 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -12,16 +12,6 @@ struct perf_tool;
 
 extern struct pevent *perf_pevent;
 
-enum {
-	RINGBUF_TYPE_PADDING		= 29,
-	RINGBUF_TYPE_TIME_EXTEND	= 30,
-	RINGBUF_TYPE_TIME_STAMP		= 31,
-};
-
-#ifndef TS_SHIFT
-#define TS_SHIFT		27
-#endif
-
 int bigendian(void);
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
