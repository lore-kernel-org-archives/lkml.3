Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3JHKNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:13:37 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:64956 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3JHKMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:50 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 51/52] tools/perf/build: Harmonize the style of the feature testcases
Date: Tue,  8 Oct 2013 12:11:21 +0200
Message-Id: <1381227082-22039-52-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/tools/perf/config/feature-checks/test-backtrace.c b/tools/perf/config/feature-checks/test-backtrace.c
index 5b33bcf..7124aa1 100644
--- a/tools/perf/config/feature-checks/test-backtrace.c
+++ b/tools/perf/config/feature-checks/test-backtrace.c
@@ -11,4 +11,3 @@ int main(void)
 
 	return 0;
 }
-
diff --git a/tools/perf/config/feature-checks/test-cplus-demangle.c b/tools/perf/config/feature-checks/test-cplus-demangle.c
index ab29f80..610c686 100644
--- a/tools/perf/config/feature-checks/test-cplus-demangle.c
+++ b/tools/perf/config/feature-checks/test-cplus-demangle.c
@@ -12,4 +12,3 @@ int main(void)
 
 	return 0;
 }
-
diff --git a/tools/perf/config/feature-checks/test-dwarf.c b/tools/perf/config/feature-checks/test-dwarf.c
index 783dfcd..3fc1801 100644
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
index 13c66a5..b082034 100644
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
index f7e791e..afc019f 100644
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
index 1886c78..2405990 100644
--- a/tools/perf/config/feature-checks/test-libbfd.c
+++ b/tools/perf/config/feature-checks/test-libbfd.c
@@ -13,4 +13,3 @@ int main(void)
 
 	return 0;
 }
-
diff --git a/tools/perf/config/feature-checks/test-libelf-getphdrnum.c b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
index 58eca53..d710459 100644
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
index 1c64815..564427d 100644
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
index 1a08f97..08db322 100644
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
index 70510a9..4763d9c 100644
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
index 7226797..b24b28a 100644
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
index 139597f..0000000
--- a/tools/perf/config/feature-tests.mak
+++ /dev/null
@@ -1,2 +0,0 @@
-
-
-- 
1.8.3.1

