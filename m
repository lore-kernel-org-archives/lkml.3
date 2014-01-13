Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaAMUwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:52:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40440 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaAMUsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 26/38] tools include: Define likely/unlikely in linux/compiler.h
Date: Mon, 13 Jan 2014 17:47:27 -0300
Message-Id: <1389646059-24881-27-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389276059-8829-3-git-send-email-namhyung@kernel.org
[ Added the new header to tools/perf/MANIFEST ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/linux/compiler.h | 8 ++++++++
 tools/perf/MANIFEST            | 1 +
 2 files changed, 9 insertions(+)

diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index 0135ccf2a00c..fbc6665c6d53 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -27,4 +27,12 @@
 # define __weak			__attribute__((weak))
 #endif
 
+#ifndef likely
+# define likely(x)		__builtin_expect(!!(x), 1)
+#endif
+
+#ifndef unlikely
+# define unlikely(x)		__builtin_expect(!!(x), 0)
+#endif
+
 #endif /* _TOOLS_LINUX_COMPILER_H */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 3170a7ff5782..285f28f7f821 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -4,6 +4,7 @@ tools/lib/traceevent
 tools/lib/lk
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
+tools/include/linux/compiler.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
-- 
1.8.1.4

