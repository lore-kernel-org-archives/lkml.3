Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935362Ab3GSHsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:48:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35470 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3GSHsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:48:09 -0400
Date: Fri, 19 Jul 2013 00:47:50 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-cfd0e8cf7fe7ad6f6c08e23ca4410bd718eeaf0b@git.kernel.org>
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
In-Reply-To: <1370323231-14022-16-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-16-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util: No need to call read_trace_init()
  in tracing_data_header()
Git-Commit-ID: cfd0e8cf7fe7ad6f6c08e23ca4410bd718eeaf0b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:47:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfd0e8cf7fe7ad6f6c08e23ca4410bd718eeaf0b
Gitweb:     http://git.kernel.org/tip/cfd0e8cf7fe7ad6f6c08e23ca4410bd718eeaf0b
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:31 -0300

perf util: No need to call read_trace_init() in tracing_data_header()

It's useless to call the read_trace_init() function at this time as we
don't need a returned pevent and it makes me confusing. :)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-16-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index a800f2b..f3c9e55 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -476,8 +476,6 @@ static int tracing_data_header(void)
 	else
 		buf[0] = 0;
 
-	read_trace_init(buf[0], buf[0]);
-
 	if (write(output_fd, buf, 1) != 1)
 		return -1;
 
