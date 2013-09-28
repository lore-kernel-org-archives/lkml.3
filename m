Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3I1TNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:13:54 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60955 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3I1TNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:13:24 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/7] perf util: Add findnew method to intlist
Date: Sat, 28 Sep 2013 13:13:03 -0600
Message-Id: <1380395584-9025-7-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
References: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to other findnew based methods if the requested
object is not found, add it to the list.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/intlist.c |   10 ++++++++++
 tools/perf/util/intlist.h |    1 +
 2 files changed, 11 insertions(+)

diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index 826d7b3..60d7da5 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -74,6 +74,16 @@ struct int_node *intlist__find(struct intlist *ilist, int i)
 	return node;
 }
 
+struct int_node *intlist__findnew(struct intlist *ilist, int i)
+{
+	struct int_node *node = intlist__find(ilist, i);
+
+	if ((node == NULL) && (intlist__add(ilist, i) == 0))
+		node = intlist__find(ilist, i);
+
+	return node;
+}
+
 static int intlist__parse_list(struct intlist *ilist, const char *s)
 {
 	char *sep;
diff --git a/tools/perf/util/intlist.h b/tools/perf/util/intlist.h
index 0eb00ac..aa6877d 100644
--- a/tools/perf/util/intlist.h
+++ b/tools/perf/util/intlist.h
@@ -24,6 +24,7 @@ int intlist__add(struct intlist *ilist, int i);
 
 struct int_node *intlist__entry(const struct intlist *ilist, unsigned int idx);
 struct int_node *intlist__find(struct intlist *ilist, int i);
+struct int_node *intlist__findnew(struct intlist *ilist, int i);
 
 static inline bool intlist__has_entry(struct intlist *ilist, int i)
 {
-- 
1.7.10.1

