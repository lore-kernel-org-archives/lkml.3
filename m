Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3KDR7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:59:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37841 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3KDR7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:59:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 06/29] perf tools: Compare hists comm by addresses
Date: Mon,  4 Nov 2013 14:58:44 -0300
Message-Id: <1383587947-17419-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Now that comm strings are allocated only once and refcounted to be shared
among threads, these can now be safely compared by addresses. This
should remove most hists collapses on post processing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381468543-25334-8-git-send-email-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 835e8bdd869f..bf91d0e5c16e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -80,7 +80,8 @@ struct sort_entry sort_thread = {
 static int64_t
 sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return right->thread->tid - left->thread->tid;
+	/* Compare the addr that should be unique among comm */
+	return thread__comm_str(right->thread) - thread__comm_str(left->thread);
 }
 
 static int64_t
-- 
1.8.1.4

