Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3ISSmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:42:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43993 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3ISSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:40:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/9] perf tools: Fill in new definitions for madvise()/mmap() flags
Date: Thu, 19 Sep 2013 15:40:25 -0300
Message-Id: <1379616032-13061-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379616032-13061-1-git-send-email-acme@infradead.org>
References: <1379616032-13061-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

builtin-trace.c started using various new syscall features not defined
in the header files of older distros - resulting in build failures.

Fill in the (ABI) constants if they are not defined.

(There might be a better place to put this than builtin-trace.c, into a
compat header or so.)

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-tip-commits@vger.kernel.org
Link: http://lkml.kernel.org/r/20130912132900.GE23826@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f5aa637..fd48534 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -16,6 +16,23 @@
 #include <sys/mman.h>
 #include <linux/futex.h>
 
+/* For older distros: */
+#ifndef MAP_STACK
+# define MAP_STACK		0x20000
+#endif
+
+#ifndef MADV_HWPOISON
+# define MADV_HWPOISON		100
+#endif
+
+#ifndef MADV_MERGEABLE
+# define MADV_MERGEABLE		12
+#endif
+
+#ifndef MADV_UNMERGEABLE
+# define MADV_UNMERGEABLE	13
+#endif
+
 static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
 					 unsigned long arg,
 					 u8 arg_idx __maybe_unused,
-- 
1.8.1.4

