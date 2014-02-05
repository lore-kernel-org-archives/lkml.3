Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaBEOwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:52:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55361 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaBEOwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:52:01 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/3] perf: Drop prefetch.h
Date: Wed,  5 Feb 2014 15:51:54 +0100
Message-Id: <1391611914-26054-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <1391611914-26054-1-git-send-email-bp@alien8.de>
References: <1391611914-26054-1-git-send-email-bp@alien8.de>
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
---
 tools/perf/Makefile.perf                 | 1 -
 tools/perf/util/include/linux/list.h     | 1 -
 tools/perf/util/include/linux/prefetch.h | 6 ------
 3 files changed, 8 deletions(-)
 delete mode 100644 tools/perf/util/include/linux/prefetch.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1afe52f72d1c..f4f2c3a3c094 100644
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
1.8.5.2.192.g7794a68

