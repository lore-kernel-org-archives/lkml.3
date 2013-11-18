Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3KRUd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:33:29 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64924 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3KRUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:33:08 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/8] perf tool: export setup_list
Date: Mon, 18 Nov 2013 13:32:48 -0700
Message-Id: <1384806771-2945-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used in next patch (perf sched timehist command)

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/symbol.c | 2 +-
 tools/perf/util/symbol.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 915eb6c4a248..92b8e0cd6266 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1754,7 +1754,7 @@ out_fail:
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
1.8.3.4 (Apple Git-47)

