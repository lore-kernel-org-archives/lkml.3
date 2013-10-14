Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab3JNUUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:20:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39022 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 127/161] perf intlist: Add priv member
Date: Mon, 14 Oct 2013 17:01:56 -0300
Message-Id: <1381780950-25642-128-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows commands to leverage intlist infrastructure for opaque
structures.

For example an upcoming perf-trace change will use this as a means of
tracking syscalls statistics by task.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380395584-9025-6-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/intlist.c | 1 +
 tools/perf/util/intlist.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index 11a8d86f7fea..826d7b38c9a0 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -20,6 +20,7 @@ static struct rb_node *intlist__node_new(struct rblist *rblist __maybe_unused,
 
 	if (node != NULL) {
 		node->i = i;
+		node->priv = NULL;
 		rc = &node->rb_node;
 	}
 
diff --git a/tools/perf/util/intlist.h b/tools/perf/util/intlist.h
index 62351dad848f..0eb00ac39e01 100644
--- a/tools/perf/util/intlist.h
+++ b/tools/perf/util/intlist.h
@@ -9,6 +9,7 @@
 struct int_node {
 	struct rb_node rb_node;
 	int i;
+	void *priv;
 };
 
 struct intlist {
-- 
1.8.1.4

