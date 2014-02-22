Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaBVR7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:59:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaBVR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:59:52 -0500
Date: Sat, 22 Feb 2014 09:59:16 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-0e55fa1131dcacfc8f18fabecc93643a105bdc14@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        rric@kernel.org
In-Reply-To: <1391611914-26054-3-git-send-email-bp@alien8.de>
References: <1391611914-26054-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move hash.h header
Git-Commit-ID: 0e55fa1131dcacfc8f18fabecc93643a105bdc14
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e55fa1131dcacfc8f18fabecc93643a105bdc14
Gitweb:     http://git.kernel.org/tip/0e55fa1131dcacfc8f18fabecc93643a105bdc14
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 5 Feb 2014 15:51:53 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:49 -0300

perf tools: Move hash.h header

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

diff --git a/tools/include/linux/hash.h b/tools/include/linux/hash.h
new file mode 100644
index 0000000..d026c65
--- /dev/null
+++ b/tools/include/linux/hash.h
@@ -0,0 +1,5 @@
+#include "../../../include/linux/hash.h"
+
+#ifndef _TOOLS_LINUX_HASH_H
+#define _TOOLS_LINUX_HASH_H
+#endif
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index f41572d..c0c87c8 100644
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
index 869b34a..496871a 100644
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
index 201f573..0000000
--- a/tools/perf/util/include/linux/hash.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#include "../../../../include/linux/hash.h"
-
-#ifndef PERF_HASH_H
-#define PERF_HASH_H
-#endif
