Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3CRLDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:03:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3CRLDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:03:12 -0400
Date: Mon, 18 Mar 2013 04:01:56 -0700
From: tip-bot for Vinson Lee <tipbot@zytor.com>
Message-ID: <tip-d1398ccfec56e54010476efd6a316427d29045a6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, irina.tirdea@intel.com,
        tglx@linutronix.de, vlee@twitter.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, irina.tirdea@intel.com, tglx@linutronix.de,
        vlee@twitter.com
In-Reply-To: <1363214064-4671-2-git-send-email-vlee@twitter.com>
References: <1363214064-4671-2-git-send-email-vlee@twitter.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix LIBNUMA build with glibc 2.12 and older.
Git-Commit-ID: d1398ccfec56e54010476efd6a316427d29045a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 04:02:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1398ccfec56e54010476efd6a316427d29045a6
Gitweb:     http://git.kernel.org/tip/d1398ccfec56e54010476efd6a316427d29045a6
Author:     Vinson Lee <vlee@twitter.com>
AuthorDate: Wed, 13 Mar 2013 15:34:24 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Mar 2013 08:06:21 -0300

perf tools: Fix LIBNUMA build with glibc 2.12 and older.

The tokens MADV_HUGEPAGE and MADV_NOHUGEPAGE are not available with
glibc 2.12 and older. Define these tokens if they are not already
defined.

This patch fixes these build errors with older versions of glibc.

    CC bench/numa.o
bench/numa.c: In function ‘alloc_data’:
bench/numa.c:334: error: ‘MADV_HUGEPAGE’ undeclared (first use in this function)
bench/numa.c:334: error: (Each undeclared identifier is reported only once
bench/numa.c:334: error: for each function it appears in.)
bench/numa.c:341: error: ‘MADV_NOHUGEPAGE’ undeclared (first use in this function)
make: *** [bench/numa.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363214064-4671-2-git-send-email-vlee@twitter.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/bench.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index a5223e6..0fdc852 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,6 +1,30 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+/*
+ * The madvise transparent hugepage constants were added in glibc
+ * 2.13. For compatibility with older versions of glibc, define these
+ * tokens if they are not already defined.
+ *
+ * PA-RISC uses different madvise values from other architectures and
+ * needs to be special-cased.
+ */
+#ifdef __hppa__
+# ifndef MADV_HUGEPAGE
+#  define MADV_HUGEPAGE		67
+# endif
+# ifndef MADV_NOHUGEPAGE
+#  define MADV_NOHUGEPAGE	68
+# endif
+#else
+# ifndef MADV_HUGEPAGE
+#  define MADV_HUGEPAGE		14
+# endif
+# ifndef MADV_NOHUGEPAGE
+#  define MADV_NOHUGEPAGE	15
+# endif
+#endif
+
 extern int bench_numa(int argc, const char **argv, const char *prefix);
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
