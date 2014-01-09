Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaAIOCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:02:42 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:40554 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaAIOBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:01:34 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 7/8] tools lib traceevent: Get rid of malloc_or_die() in trace_seq_init()
Date: Thu,  9 Jan 2014 23:00:58 +0900
Message-Id: <1389276059-8829-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
References: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use plain malloc() and check its return value.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/trace-seq.c |    7 +++++--
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
1.7.9.2

