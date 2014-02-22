Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaBVSAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:00:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaBVSAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:00:00 -0500
Date: Sat, 22 Feb 2014 09:59:28 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-5072f2733afe26c354aa9d277cb1544e4b0b3846@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        rric@kernel.org
In-Reply-To: <1391611914-26054-4-git-send-email-bp@alien8.de>
References: <1391611914-26054-4-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Drop prefetch.h
Git-Commit-ID: 5072f2733afe26c354aa9d277cb1544e4b0b3846
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

Commit-ID:  5072f2733afe26c354aa9d277cb1544e4b0b3846
Gitweb:     http://git.kernel.org/tip/5072f2733afe26c354aa9d277cb1544e4b0b3846
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 5 Feb 2014 15:51:54 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:49 -0300

perf tools: Drop prefetch.h

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

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 496871a..77b153f 100644
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
index 1d928a0..bfe0a2a 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -1,5 +1,4 @@
 #include <linux/kernel.h>
-#include <linux/prefetch.h>
 
 #include "../../../../include/linux/list.h"
 
diff --git a/tools/perf/util/include/linux/prefetch.h b/tools/perf/util/include/linux/prefetch.h
deleted file mode 100644
index 7841e48..0000000
--- a/tools/perf/util/include/linux/prefetch.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef PERF_LINUX_PREFETCH_H
-#define PERF_LINUX_PREFETCH_H
-
-static inline void prefetch(void *a __attribute__((unused))) { }
-
-#endif
