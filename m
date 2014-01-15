Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaAOBpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:45:49 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53517 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaAOBpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:44 -0500
X-AuditID: 9c930197-b7b7cae000000e34-4b-52d5e84534af
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/17] tools lib traceevent: Get rid of malloc_or_die() in trace_seq_init()
Date: Wed, 15 Jan 2014 10:45:26 +0900
Message-Id: <1389750340-15965-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use plain malloc() and check its return value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/trace-seq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index 941d35d2cf87..339a0ffa21d5 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -47,8 +47,11 @@ void trace_seq_init(struct trace_seq *s)
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
-- 
1.7.11.7

