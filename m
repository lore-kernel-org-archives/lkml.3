Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab3KYOUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:20:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42769 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab3KYOSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:18:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/25] perf tools: Export setup_list
Date: Mon, 25 Nov 2013 11:17:54 -0300
Message-Id: <1385389075-7989-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385389075-7989-1-git-send-email-acme@infradead.org>
References: <1385389075-7989-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Used in upcoming patches (perf sched timehist command).

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1384806771-2945-6-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 2 +-
 tools/perf/util/symbol.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f55c18da1e40..ce9ce101adf4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1749,7 +1749,7 @@ out_fail:
 	return -1;
 }
 
-static int setup_list(struct strlist **list, const char *list_str,
+int setup_list(struct strlist **list, const char *list_str,
 		      const char *list_name)
 {
 	if (list_str == NULL)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ad13c5d50b91..f1031a1358a1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -274,4 +274,7 @@ void kcore_extract__delete(struct kcore_extract *kce);
 int kcore_copy(const char *from_dir, const char *to_dir);
 int compare_proc_modules(const char *from, const char *to);
 
+int setup_list(struct strlist **list, const char *list_str,
+	       const char *list_name);
+
 #endif /* __PERF_SYMBOL */
-- 
1.8.1.4

