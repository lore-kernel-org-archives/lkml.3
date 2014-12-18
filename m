Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaLRGay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:30:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaLRGaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:30:52 -0500
Date: Wed, 17 Dec 2014 22:30:12 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-1ldjhvioch1uczilno5e1epl@git.kernel.org>
Cc: bp@suse.de, peterz@infradead.org, efault@gmx.de, eranian@google.com,
        acme@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, paulus@samba.org, mingo@kernel.org,
        fweisbec@gmail.com, hpa@zytor.com, dsahern@gmail.com,
        namhyung@kernel.org, dzickus@redhat.com, adrian.hunter@intel.com
Reply-To: dsahern@gmail.com, namhyung@kernel.org, hpa@zytor.com,
        adrian.hunter@intel.com, dzickus@redhat.com, efault@gmx.de,
        eranian@google.com, acme@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, bp@suse.de, peterz@infradead.org,
        paulus@samba.org, fweisbec@gmail.com, mingo@kernel.org,
        jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Move code originally from asm-generic/
 atomic.h into tools/include/asm-generic/
Git-Commit-ID: cae68d4f6a0a1f8fb7c979f356e994a3c17543c1
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

Commit-ID:  cae68d4f6a0a1f8fb7c979f356e994a3c17543c1
Gitweb:     http://git.kernel.org/tip/cae68d4f6a0a1f8fb7c979f356e994a3c17543c1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 15 Dec 2014 16:44:26 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:11:52 -0300

tools: Move code originally from asm-generic/atomic.h into tools/include/asm-generic/

To match the Linux kernel source code structure from where this code came from.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1ldjhvioch1uczilno5e1epl@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm-generic/bitops/atomic.h | 22 ++++++++++++++++++++++
 tools/perf/MANIFEST                       |  1 +
 tools/perf/Makefile.perf                  |  1 +
 tools/perf/util/include/linux/bitops.h    | 16 +---------------
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/tools/include/asm-generic/bitops/atomic.h b/tools/include/asm-generic/bitops/atomic.h
new file mode 100644
index 0000000..4bccd7c3
--- /dev/null
+++ b/tools/include/asm-generic/bitops/atomic.h
@@ -0,0 +1,22 @@
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_
+
+#include <asm/types.h>
+
+static inline void set_bit(int nr, unsigned long *addr)
+{
+	addr[nr / __BITS_PER_LONG] |= 1UL << (nr % __BITS_PER_LONG);
+}
+
+static inline void clear_bit(int nr, unsigned long *addr)
+{
+	addr[nr / __BITS_PER_LONG] &= ~(1UL << (nr % __BITS_PER_LONG));
+}
+
+static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
+{
+	return ((1UL << (nr % __BITS_PER_LONG)) &
+		(((unsigned long *)addr)[nr / __BITS_PER_LONG])) != 0;
+}
+
+#endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_ */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index db7827f..67d48e2 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -5,6 +5,7 @@ tools/lib/api
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
+tools/include/asm-generic/bitops/atomic.h
 tools/include/asm-generic/bitops/__ffs.h
 tools/include/linux/compiler.h
 tools/include/linux/export.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ec2be64..604349d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -232,6 +232,7 @@ LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
+LIB_H += ../include/asm-generic/bitops/atomic.h
 LIB_H += ../include/asm-generic/bitops/__ffs.h
 LIB_H += ../include/linux/compiler.h
 LIB_H += ../include/linux/log2.h
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 762bb83..71f017d 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -29,21 +29,7 @@
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
-static inline void set_bit(int nr, unsigned long *addr)
-{
-	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
-}
-
-static inline void clear_bit(int nr, unsigned long *addr)
-{
-	addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
-}
-
-static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
-{
-	return ((1UL << (nr % BITS_PER_LONG)) &
-		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
-}
+#include <asm-generic/bitops/atomic.h>
 
 static inline unsigned long hweight_long(unsigned long w)
 {
