Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3I1TNu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:13:50 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:65479 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3I1TNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:13:22 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/7] perf util: Add priv variable to intlist
Date: Sat, 28 Sep 2013 13:13:02 -0600
Message-Id: <1380395584-9025-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
References: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows commands to leverage intlist infrastructure for opaque
structures. For example an upcoming perf-trace change will use
this as a means of tracking syscalls statistics by task.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/intlist.c |    1 +
 tools/perf/util/intlist.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index 11a8d86..826d7b3 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -20,6 +20,7 @@ static struct rb_node *intlist__node_new(struct rblist *rblist __maybe_unused,
 
 	if (node != NULL) {
 		node->i = i;
+		node->priv = NULL;
 		rc = &node->rb_node;
 	}
 
diff --git a/tools/perf/util/intlist.h b/tools/perf/util/intlist.h
index 62351da..0eb00ac 100644
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
1.7.10.1

