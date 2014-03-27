Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaC0Xts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 19:49:48 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:58131 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946AbaC0XtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 19:49:22 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf bench: Fix segfault at the end of an 'all' execution
Date: Thu, 27 Mar 2014 19:50:19 -0400
Message-Id: <1395964219-22173-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
In-Reply-To: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
References: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the end of

  $ perf bench all

the program segfaults because it attempts to dereference a NULL
pointer. Fix this fault.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-bench.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index f600b74..1e6e777 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -86,7 +86,7 @@ static struct collection collections[] = {
 
 /* Iterate over all benchmarks within a collection: */
 #define for_each_bench(coll, bench) \
-	for (bench = coll->benchmarks; bench->name; bench++)
+	for (bench = coll->benchmarks; bench && bench->name; bench++)
 
 static void dump_benchmarks(struct collection *coll)
 {
-- 
1.9.0.431.g014438b

