Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaAGDBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:01:06 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42663 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbaAGDAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:00:19 -0500
X-AuditID: 9c930179-b7c89ae000006438-c8-52cb6dc0b8be
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/5] tools lib traceevent: Get rid of malloc_or_die() in trace_seq_init()
Date: Tue,  7 Jan 2014 12:00:11 +0900
Message-Id: <1389063612-18173-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
References: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
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
index b139d55a6bf9..e858bfd3b104 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -46,8 +46,11 @@ void trace_seq_init(struct trace_seq *s)
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

