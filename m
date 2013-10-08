Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3JHKXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:23:16 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59780 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab3JHKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:22 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 16/52] tools/perf/build: Split out feature check: 'libelf-getphdrnum'
Date: Tue,  8 Oct 2013 12:10:46 +0200
Message-Id: <1381227082-22039-17-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index bf1f021..718b476 100644
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
index bf96e34..83b3a02 100644
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
index 0000000..58eca53
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
1.8.3.1

