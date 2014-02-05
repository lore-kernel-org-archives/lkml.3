Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaBEOwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:52:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55353 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbaBEOwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:52:01 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/3] perf: Move hash.h header
Date: Wed,  5 Feb 2014 15:51:53 +0100
Message-Id: <1391611914-26054-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <1391611914-26054-1-git-send-email-bp@alien8.de>
References: <1391611914-26054-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Put it into tools/include/ for general usage.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/include/linux/hash.h           | 5 +++++
 tools/perf/MANIFEST                  | 2 +-
 tools/perf/Makefile.perf             | 2 +-
 tools/perf/util/include/linux/hash.h | 5 -----
 4 files changed, 7 insertions(+), 7 deletions(-)
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
index f41572d0dd76..9883d79d77fb 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -6,11 +6,11 @@ tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
 tools/include/linux/compiler.h
+tools/include/linux/hash.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
 include/linux/list.h
-include/linux/hash.h
 include/linux/stringify.h
 lib/rbtree.c
 include/linux/swab.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 455008461c90..1afe52f72d1c 100644
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
1.8.5.2.192.g7794a68

