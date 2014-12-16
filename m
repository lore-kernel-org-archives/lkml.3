Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaLPQ6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:58:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:47051 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaLPQ6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:58:44 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/18] tools: Adopt fls_long and deps
Date: Tue, 16 Dec 2014 13:57:15 -0300
Message-Id: <1418749040-31807-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used when adopting rounddown_pow_of_two.

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
Link: http://lkml.kernel.org/n/tip-9m0tt5300q1ygv51hejjas82@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm-generic/bitops.h       | 3 +++
 tools/include/asm-generic/bitops/__fls.h | 1 +
 tools/include/asm-generic/bitops/fls.h   | 1 +
 tools/include/asm-generic/bitops/fls64.h | 1 +
 tools/include/linux/bitops.h             | 7 +++++++
 tools/perf/MANIFEST                      | 3 +++
 tools/perf/Makefile.perf                 | 3 +++
 7 files changed, 19 insertions(+)
 create mode 100644 tools/include/asm-generic/bitops/__fls.h
 create mode 100644 tools/include/asm-generic/bitops/fls.h
 create mode 100644 tools/include/asm-generic/bitops/fls64.h

diff --git a/tools/include/asm-generic/bitops.h b/tools/include/asm-generic/bitops.h
index 6dfd9d5fd828..6eedba1f7732 100644
--- a/tools/include/asm-generic/bitops.h
+++ b/tools/include/asm-generic/bitops.h
@@ -13,6 +13,9 @@
  */
 
 #include <asm-generic/bitops/__ffs.h>
+#include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
+#include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>
 
 #ifndef _TOOLS_LINUX_BITOPS_H_
diff --git a/tools/include/asm-generic/bitops/__fls.h b/tools/include/asm-generic/bitops/__fls.h
new file mode 100644
index 000000000000..2218b9add4c1
--- /dev/null
+++ b/tools/include/asm-generic/bitops/__fls.h
@@ -0,0 +1 @@
+#include <../../../../include/asm-generic/bitops/__fls.h>
diff --git a/tools/include/asm-generic/bitops/fls.h b/tools/include/asm-generic/bitops/fls.h
new file mode 100644
index 000000000000..dbf711a28f71
--- /dev/null
+++ b/tools/include/asm-generic/bitops/fls.h
@@ -0,0 +1 @@
+#include <../../../../include/asm-generic/bitops/fls.h>
diff --git a/tools/include/asm-generic/bitops/fls64.h b/tools/include/asm-generic/bitops/fls64.h
new file mode 100644
index 000000000000..980b1f63c047
--- /dev/null
+++ b/tools/include/asm-generic/bitops/fls64.h
@@ -0,0 +1 @@
+#include <../../../../include/asm-generic/bitops/fls64.h>
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
index 5237bc9f6266..26005a15e7e2 100644
--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -43,4 +43,11 @@ static inline unsigned long hweight_long(unsigned long w)
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
+static inline unsigned fls_long(unsigned long l)
+{
+	if (sizeof(l) == 4)
+		return fls(l);
+	return fls64(l);
+}
+
 #endif
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 7729af9f417a..0c6cc8de007f 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -8,7 +8,10 @@ tools/lib/util/find_next_bit.c
 tools/include/asm/bug.h
 tools/include/asm-generic/bitops/atomic.h
 tools/include/asm-generic/bitops/__ffs.h
+tools/include/asm-generic/bitops/__fls.h
 tools/include/asm-generic/bitops/find.h
+tools/include/asm-generic/bitops/fls64.h
+tools/include/asm-generic/bitops/fls.h
 tools/include/asm-generic/bitops.h
 tools/include/linux/bitops.h
 tools/include/linux/compiler.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 55b9c97cafc2..6b7153f8b056 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -234,7 +234,10 @@ LIB_H += util/include/linux/bitmap.h
 LIB_H += ../include/linux/bitops.h
 LIB_H += ../include/asm-generic/bitops/atomic.h 
 LIB_H += ../include/asm-generic/bitops/find.h 
+LIB_H += ../include/asm-generic/bitops/fls64.h
+LIB_H += ../include/asm-generic/bitops/fls.h
 LIB_H += ../include/asm-generic/bitops/__ffs.h 
+LIB_H += ../include/asm-generic/bitops/__fls.h
 LIB_H += ../include/asm-generic/bitops.h
 LIB_H += ../include/linux/compiler.h
 LIB_H += ../include/linux/log2.h
-- 
1.9.3

