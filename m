Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaLRGc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:32:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaLRGcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:32:25 -0500
Date: Wed, 17 Dec 2014 22:31:45 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-9m0tt5300q1ygv51hejjas82@git.kernel.org>
Cc: adrian.hunter@intel.com, eranian@google.com, dsahern@gmail.com,
        dzickus@redhat.com, paulus@samba.org, fweisbec@gmail.com, bp@suse.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        efault@gmx.de, tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com,
        acme@redhat.com, namhyung@kernel.org
Reply-To: paulus@samba.org, fweisbec@gmail.com, dzickus@redhat.com,
        dsahern@gmail.com, eranian@google.com, adrian.hunter@intel.com,
        peterz@infradead.org, bp@suse.de, efault@gmx.de, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Adopt fls_long and deps
Git-Commit-ID: afcd4f6235659c611f0e62236f6a7bc0ae08af1e
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

Commit-ID:  afcd4f6235659c611f0e62236f6a7bc0ae08af1e
Gitweb:     http://git.kernel.org/tip/afcd4f6235659c611f0e62236f6a7bc0ae08af1e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 16 Dec 2014 11:26:35 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:58:08 -0300

tools: Adopt fls_long and deps

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
 tools/perf/MANIFEST                      | 6 ++++++
 tools/perf/Makefile.perf                 | 3 +++
 7 files changed, 22 insertions(+)

diff --git a/tools/include/asm-generic/bitops.h b/tools/include/asm-generic/bitops.h
index 6dfd9d5..6eedba1 100644
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
index 0000000..2218b9a
--- /dev/null
+++ b/tools/include/asm-generic/bitops/__fls.h
@@ -0,0 +1 @@
+#include <../../../../include/asm-generic/bitops/__fls.h>
diff --git a/tools/include/asm-generic/bitops/fls.h b/tools/include/asm-generic/bitops/fls.h
new file mode 100644
index 0000000..dbf711a
--- /dev/null
+++ b/tools/include/asm-generic/bitops/fls.h
@@ -0,0 +1 @@
+#include <../../../../include/asm-generic/bitops/fls.h>
diff --git a/tools/include/asm-generic/bitops/fls64.h b/tools/include/asm-generic/bitops/fls64.h
new file mode 100644
index 0000000..980b1f6
--- /dev/null
+++ b/tools/include/asm-generic/bitops/fls64.h
@@ -0,0 +1 @@
+#include <../../../../include/asm-generic/bitops/fls64.h>
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
index 5237bc9..26005a15 100644
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
index 7729af9..83e2887 100644
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
@@ -16,6 +19,9 @@ tools/include/linux/export.h
 tools/include/linux/hash.h
 tools/include/linux/log2.h
 tools/include/linux/types.h
+include/asm-generic/bitops/fls64.h
+include/asm-generic/bitops/__fls.h
+include/asm-generic/bitops/fls.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 28e590e..67a03a82 100644
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
