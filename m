Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab3ILN3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:29:07 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:52339 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3ILN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:29:05 -0400
Date: Thu, 12 Sep 2013 15:29:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, acme@redhat.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-tip-commits@vger.kernel.org
Subject: perf/compat: Fill in new definitions for madvise()/mmap() flags
Message-ID: <20130912132900.GE23826@gmail.com>
References: <tip-w28d1o3uslden0k57653kda7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-w28d1o3uslden0k57653kda7@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

builtin-trace.c started using various new syscall features not defined in 
the header files of older distros - resulting in build failures.

Fill in the (ABI) constants if they are not defined.

(There might be a better place to put this than builtin-trace.c, into a 
compat header or so.)

Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f5aa637..e640e28 100644
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
