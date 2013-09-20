Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3ITJ4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:56:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3ITJ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:56:31 -0400
Date: Fri, 20 Sep 2013 02:55:50 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-456857bded19a4160bbe083bae926e23f483b7f7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <20130912132900.GE23826@gmail.com>
References: <20130912132900.GE23826@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fill in new definitions for madvise
 ()/mmap() flags
Git-Commit-ID: 456857bded19a4160bbe083bae926e23f483b7f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 02:55:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  456857bded19a4160bbe083bae926e23f483b7f7
Gitweb:     http://git.kernel.org/tip/456857bded19a4160bbe083bae926e23f483b7f7
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 12 Sep 2013 15:29:00 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Sep 2013 11:32:17 -0300

perf tools: Fill in new definitions for madvise()/mmap() flags

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
