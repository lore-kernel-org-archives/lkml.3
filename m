Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3AXUOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:14:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50185 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3AXUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 72/74] perf tools: Allow passing NULL to intlist__find
Date: Thu, 24 Jan 2013 17:08:21 -0300
Message-Id: <1359058103-31645-73-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can work with optional parameters that may not set up an
intlist.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-e9tmvgdzehqrza11zs0nbg7g@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/intlist.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index 9d07400..cbf0c32 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -59,9 +59,14 @@ void intlist__remove(struct intlist *ilist, struct int_node *node)
 
 struct int_node *intlist__find(struct intlist *ilist, int i)
 {
-	struct int_node *node = NULL;
-	struct rb_node *rb_node = rblist__find(&ilist->rblist, (void *)((long)i));
+	struct int_node *node;
+	struct rb_node *rb_node;
+
+	if (ilist == NULL)
+		return NULL;
 
+	node = NULL;
+	rb_node = rblist__find(&ilist->rblist, (void *)((long)i));
 	if (rb_node)
 		node = container_of(rb_node, struct int_node, rb_node);
 
-- 
1.8.1.1.361.gec3ae6e

