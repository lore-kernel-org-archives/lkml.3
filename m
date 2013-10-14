Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349Ab3JNUlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:41:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38590 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab3JNUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 051/161] tools/perf/build: Harmonize the style of the feature testcases
Date: Mon, 14 Oct 2013 17:00:40 -0300
Message-Id: <1381780950-25642-52-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

The various testcases used different styles, which was not really
visible as long as they hid in feature-tests.mak. Now that they
are out in the open make them prettier.

( Also delete the leftover, empty feature-tests.mak file. )

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-drDWk8xltndjdsespzjbhu6w@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/feature-checks/test-backtrace.c         | 1 -
 tools/perf/config/feature-checks/test-cplus-demangle.c    | 1 -
 tools/perf/config/feature-checks/test-dwarf.c             | 1 +
 tools/perf/config/feature-checks/test-glibc.c             | 2 +-
 tools/perf/config/feature-checks/test-libaudit.c          | 1 +
 tools/perf/config/feature-checks/test-libbfd.c            | 1 -
 tools/perf/config/feature-checks/test-libelf-getphdrnum.c | 3 ++-
 tools/perf/config/feature-checks/test-libelf-mmap.c       | 3 ++-
 tools/perf/config/feature-checks/test-libelf.c            | 1 +
 tools/perf/config/feature-checks/test-libnuma.c           | 1 +
 tools/perf/config/feature-checks/test-libpython.c         | 3 ++-
 tools/perf/config/feature-tests.mak                       | 2 --
 12 files changed, 11 insertions(+), 9 deletions(-)
 delete mode 100644 tools/perf/config/feature-tests.mak

diff --git a/tools/perf/config/feature-checks/test-backtrace.c b/tools/perf/config/feature-checks/test-backtrace.c
index 5b33bcf12c27..7124aa1dc8fb 100644
--- a/tools/perf/config/feature-checks/test-backtrace.c
+++ b/tools/perf/config/feature-checks/test-backtrace.c
@@ -11,4 +11,3 @@ int main(void)
 
 	return 0;
 }
-
diff --git a/tools/perf/config/feature-checks/test-cplus-demangle.c b/tools/perf/config/feature-checks/test-cplus-demangle.c
index ab29f80570af..610c686e0009 100644
--- a/tools/perf/config/feature-checks/test-cplus-demangle.c
+++ b/tools/perf/config/feature-checks/test-cplus-demangle.c
@@ -12,4 +12,3 @@ int main(void)
 
 	return 0;
 }
-
diff --git a/tools/perf/config/feature-checks/test-dwarf.c b/tools/perf/config/feature-checks/test-dwarf.c
index 783dfcd9a5c4..3fc1801ce4a9 100644
--- a/tools/perf/config/feature-checks/test-dwarf.c
+++ b/tools/perf/config/feature-checks/test-dwarf.c
@@ -5,5 +5,6 @@
 int main(void)
 {
 	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
+
 	return (long)dbg;
 }
diff --git a/tools/perf/config/feature-checks/test-glibc.c b/tools/perf/config/feature-checks/test-glibc.c
index 13c66a58f2ec..b0820345cd98 100644
--- a/tools/perf/config/feature-checks/test-glibc.c
+++ b/tools/perf/config/feature-checks/test-glibc.c
@@ -3,6 +3,6 @@
 int main(void)
 {
 	const char *version = gnu_get_libc_version();
+
 	return (long)version;
 }
-
diff --git a/tools/perf/config/feature-checks/test-libaudit.c b/tools/perf/config/feature-checks/test-libaudit.c
index f7e791efa6d1..afc019f08641 100644
--- a/tools/perf/config/feature-checks/test-libaudit.c
+++ b/tools/perf/config/feature-checks/test-libaudit.c
@@ -5,5 +5,6 @@ extern int printf(const char *format, ...);
 int main(void)
 {
 	printf("error message: %s\n", audit_errno_to_name(0));
+
 	return audit_open();
 }
diff --git a/tools/perf/config/feature-checks/test-libbfd.c b/tools/perf/config/feature-checks/test-libbfd.c
index 1886c78c30e7..24059907e990 100644
--- a/tools/perf/config/feature-checks/test-libbfd.c
+++ b/tools/perf/config/feature-checks/test-libbfd.c
@@ -13,4 +13,3 @@ int main(void)
 
 	return 0;
 }
-
diff --git a/tools/perf/config/feature-checks/test-libelf-getphdrnum.c b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
index 58eca5332520..d710459306c3 100644
--- a/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
+++ b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
@@ -1,7 +1,8 @@
 #include <libelf.h>
-#
+
 int main(void)
 {
 	size_t dst;
+
 	return elf_getphdrnum(0, &dst);
 }
diff --git a/tools/perf/config/feature-checks/test-libelf-mmap.c b/tools/perf/config/feature-checks/test-libelf-mmap.c
index 1c648159c705..564427d7ef18 100644
--- a/tools/perf/config/feature-checks/test-libelf-mmap.c
+++ b/tools/perf/config/feature-checks/test-libelf-mmap.c
@@ -1,7 +1,8 @@
 #include <libelf.h>
-#
+
 int main(void)
 {
 	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
+
 	return (long)elf;
 }
diff --git a/tools/perf/config/feature-checks/test-libelf.c b/tools/perf/config/feature-checks/test-libelf.c
index 1a08f9717344..08db322d8957 100644
--- a/tools/perf/config/feature-checks/test-libelf.c
+++ b/tools/perf/config/feature-checks/test-libelf.c
@@ -3,5 +3,6 @@
 int main(void)
 {
 	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+
 	return (long)elf;
 }
diff --git a/tools/perf/config/feature-checks/test-libnuma.c b/tools/perf/config/feature-checks/test-libnuma.c
index 70510a923e5a..4763d9cd587d 100644
--- a/tools/perf/config/feature-checks/test-libnuma.c
+++ b/tools/perf/config/feature-checks/test-libnuma.c
@@ -4,5 +4,6 @@
 int main(void)
 {
 	numa_available();
+
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-libpython.c b/tools/perf/config/feature-checks/test-libpython.c
index 72267972fa98..b24b28ad6324 100644
--- a/tools/perf/config/feature-checks/test-libpython.c
+++ b/tools/perf/config/feature-checks/test-libpython.c
@@ -1,7 +1,8 @@
 #include <Python.h>
-#
+
 int main(void)
 {
 	Py_Initialize();
+
 	return 0;
 }
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
deleted file mode 100644
index 139597f9cb07..000000000000
--- a/tools/perf/config/feature-tests.mak
+++ /dev/null
@@ -1,2 +0,0 @@
-
-
-- 
1.8.1.4

