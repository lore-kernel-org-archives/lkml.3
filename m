Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaAPNoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:44:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaAPNiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:38:14 -0500
Date: Thu, 16 Jan 2014 05:37:54 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-504586e0954bcf9550dfdea37d3234174ed1d68f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1389750340-15965-4-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of malloc_or_die()
  in trace_seq_init()
Git-Commit-ID: 504586e0954bcf9550dfdea37d3234174ed1d68f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:38:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  504586e0954bcf9550dfdea37d3234174ed1d68f
Gitweb:     http://git.kernel.org/tip/504586e0954bcf9550dfdea37d3234174ed1d68f
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 15 Jan 2014 10:45:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Jan 2014 15:10:32 -0300

tools lib traceevent: Get rid of malloc_or_die() in trace_seq_init()

Use plain malloc() and check its return value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389750340-15965-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/trace-seq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index e454a2c..ec3bd16 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -57,8 +57,11 @@ void trace_seq_init(struct trace_seq *s)
 	s->len = 0;
 	s->readpos = 0;
 	s->buffer_size = TRACE_SEQ_BUF_SIZE;
-	s->buffer = malloc_or_die(s->buffer_size);
-	s->state = TRACE_SEQ__GOOD;
+	s->buffer = malloc(s->buffer_size);
+	if (s->buffer != NULL)
+		s->state = TRACE_SEQ__GOOD;
+	else
+		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
 }
 
 /**
