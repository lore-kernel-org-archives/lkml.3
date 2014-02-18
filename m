Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaBRVQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:16:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35688 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaBRVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/32] perf tools: Drop prefetch.h
Date: Tue, 18 Feb 2014 18:08:39 -0300
Message-Id: <1392757731-32619-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This was needed at the time before e66eed651fd1 ("list: remove
prefetching from regular list iterators") where the list iterators did
prefetch elements. This turned out to be counter-productive and hurt
performance and they were removed. Which makes the prefetch.h header
unused so drop it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rric@kernel.org>
Link: http://lkml.kernel.org/r/1391611914-26054-4-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf                 | 1 -
 tools/perf/util/include/linux/list.h     | 1 -
 tools/perf/util/include/linux/prefetch.h | 6 ------
 3 files changed, 8 deletions(-)
 delete mode 100644 tools/perf/util/include/linux/prefetch.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 496871ae4590..77b153fa23a5 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -219,7 +219,6 @@ LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/export.h
 LIB_H += util/include/linux/poison.h
-LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/rbtree_augmented.h
 LIB_H += util/include/linux/string.h
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
index 1d928a0ce997..bfe0a2afd0d2 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -1,5 +1,4 @@
 #include <linux/kernel.h>
-#include <linux/prefetch.h>
 
 #include "../../../../include/linux/list.h"
 
diff --git a/tools/perf/util/include/linux/prefetch.h b/tools/perf/util/include/linux/prefetch.h
deleted file mode 100644
index 7841e485d8c3..000000000000
--- a/tools/perf/util/include/linux/prefetch.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef PERF_LINUX_PREFETCH_H
-#define PERF_LINUX_PREFETCH_H
-
-static inline void prefetch(void *a __attribute__((unused))) { }
-
-#endif
-- 
1.8.1.4

