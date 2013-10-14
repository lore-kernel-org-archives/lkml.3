Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab3JNUwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:52:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38438 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab3JNUCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 016/161] tools/perf/build: Split out feature check: 'libelf-getphdrnum'
Date: Mon, 14 Oct 2013 17:00:05 -0300
Message-Id: <1381780950-25642-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-wa9qstb8erbjreLxiHepzjfw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                | 5 +++--
 tools/perf/config/feature-checks/Makefile                 | 4 ++++
 tools/perf/config/feature-checks/test-libelf-getphdrnum.c | 7 +++++++
 3 files changed, 14 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libelf-getphdrnum.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index bf1f021d2467..718b47611340 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -112,6 +112,7 @@ FEATURE_TESTS =				\
 	glibc				\
 	dwarf				\
 	libelf-mmap			\
+	libelf-getphdrnum		\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -207,7 +208,7 @@ ifndef NO_LIBELF
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
   endif
 
-  ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_GETPHDRNUM_SUPPORT),y)
+  ifeq ($(feature-libelf-getphdrnum), 1)
     CFLAGS += -DHAVE_ELF_GETPHDRNUM_SUPPORT
   endif
 
@@ -230,7 +231,7 @@ ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
   ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
-  endif # try-cc
+  endif
 endif # NO_LIBELF
 
 # There's only x86 (both 32 and 64) support for CFI unwind so far
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index bf96e34509f4..83b3a02b64d8 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -10,6 +10,7 @@ FILES=					\
 	test-glibc			\
 	test-dwarf			\
 	test-libelf-mmap		\
+	test-libelf-getphdrnum		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -50,6 +51,9 @@ test-dwarf:
 test-libelf-mmap:
 	$(BUILD) -lelf
 
+test-libelf-getphdrnum:
+	$(BUILD) -lelf
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-libelf-getphdrnum.c b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
new file mode 100644
index 000000000000..58eca5332520
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
@@ -0,0 +1,7 @@
+#include <libelf.h>
+#
+int main(void)
+{
+	size_t dst;
+	return elf_getphdrnum(0, &dst);
+}
-- 
1.8.1.4

