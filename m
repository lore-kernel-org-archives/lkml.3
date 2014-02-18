Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaBRVRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:17:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35687 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaBRVJJ (ORCPT
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
Subject: [PATCH 19/32] perf tools: Move hash.h header
Date: Tue, 18 Feb 2014 18:08:38 -0300
Message-Id: <1392757731-32619-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Put it into tools/include/ for general usage.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rric@kernel.org>
Link: http://lkml.kernel.org/r/1391611914-26054-3-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/linux/hash.h           | 5 +++++
 tools/perf/MANIFEST                  | 1 +
 tools/perf/Makefile.perf             | 2 +-
 tools/perf/util/include/linux/hash.h | 5 -----
 4 files changed, 7 insertions(+), 6 deletions(-)
 create mode 100644 tools/include/linux/hash.h
 delete mode 100644 tools/perf/util/include/linux/hash.h

diff --git a/tools/include/linux/hash.h b/tools/include/linux/hash.h
new file mode 100644
index 000000000000..d026c6573018
--- /dev/null
+++ b/tools/include/linux/hash.h
@@ -0,0 +1,5 @@
+#include "../../../include/linux/hash.h"
+
+#ifndef _TOOLS_LINUX_HASH_H
+#define _TOOLS_LINUX_HASH_H
+#endif
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index f41572d0dd76..c0c87c87b60f 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -6,6 +6,7 @@ tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
 tools/include/linux/compiler.h
+tools/include/linux/hash.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 869b34a51c8c..496871ae4590 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -208,7 +208,7 @@ LIB_H += ../../include/uapi/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
 LIB_H += ../../include/uapi/linux/const.h
-LIB_H += ../../include/linux/hash.h
+LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
diff --git a/tools/perf/util/include/linux/hash.h b/tools/perf/util/include/linux/hash.h
deleted file mode 100644
index 201f57397997..000000000000
--- a/tools/perf/util/include/linux/hash.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#include "../../../../include/linux/hash.h"
-
-#ifndef PERF_HASH_H
-#define PERF_HASH_H
-#endif
-- 
1.8.1.4

