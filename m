Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3JHKPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:15:50 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43500 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab3JHKMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:45 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 45/52] tools/perf/build: Collapse the test-all.c testcase
Date: Tue,  8 Oct 2013 12:11:15 +0200
Message-Id: <1381227082-22039-46-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify test-all.c by including it all the testcases via #include.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-pcZlwqq5ou7Ebvkekvhtzfbm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/feature-checks/test-all.c | 290 +++++++++++++++++-------------------------------
 1 file changed, 100 insertions(+), 190 deletions(-)

diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index 9f7c4b1..50d4318 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -1,196 +1,106 @@
-
-#pragma GCC diagnostic ignored "-Wstrict-prototypes"
-
-#include <Python.h>
-
-#include <EXTERN.h>
-#include <perl.h>
-
-#include <stdio.h>
-#include <libelf.h>
-#include <gnu/libc-version.h>
-#include <dwarf.h>
-#include <elfutils/libdw.h>
-#include <elfutils/version.h>
-#include <libelf.h>
-#include <libunwind.h>
-#include <stdlib.h>
-#include <libaudit.h>
-#include <slang.h>
-#include <gtk/gtk.h>
-#include <bfd.h>
-#include <stdio.h>
-#include <execinfo.h>
-#include <stdio.h>
-#include <numa.h>
-#include <numaif.h>
-
-#pragma GCC diagnostic error "-Wstrict-prototypes"
-
-int main1(void)
-{
-	return puts("hi");
-}
-
-int main2(void)
-{
-	return puts("hi");
-}
-
-int main3(void)
-{
-	return puts("hi");
-}
-
-int main4(void)
-{
-	Elf *elf = elf_begin(0, ELF_C_READ, 0);
-	return (long)elf;
-}
-#
-int main5(void)
-{
-	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
-	return (long)elf;
-}
-
-int main6(void)
-{
-	const char *version = gnu_get_libc_version();
-	return (long)version;
-}
-
-int main7(void)
-{
-	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
-	return (long)dbg;
-}
-
-int main8(void)
-{
-	size_t dst;
-	return elf_getphdrnum(0, &dst);
-}
-
-extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
-                                      unw_word_t ip,
-                                      unw_dyn_info_t *di,
-                                      unw_proc_info_t *pi,
-                                      int need_unwind_info, void *arg);
-
-
-#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
-
-int main9(void)
-{
-	unw_addr_space_t addr_space;
-	addr_space = unw_create_addr_space(NULL, 0);
-	unw_init_remote(NULL, addr_space, NULL);
-	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
-	return 0;
-}
-
-int main10(void)
-{
-	printf("error message: %s\n", audit_errno_to_name(0));
-	return audit_open();
-}
-
-int main11(void)
-{
-	return SLsmg_init_smg();
-}
-
-int main12(int argc, char *argv[])
-{
-        gtk_init(&argc, &argv);
-
-        return 0;
-}
-
-int main13(void)
-{
-	gtk_info_bar_new();
-
-	return 0;
-}
-
-int main14(void)
-{
-	perl_alloc();
-
-	return 0;
-}
-
-int main15(void)
-{
-	Py_Initialize();
-	return 0;
-}
-
-#if PY_VERSION_HEX >= 0x03000000
-	#error
-#endif
-
-int main16(void)
-{
-	return 0;
-}
-
-int main17(void)
-{
-	bfd_demangle(0, 0, 0);
-	return 0;
-}
-
-void exit_function(int x, void *y)
-{
-}
-
-int main18(void)
-{
-	return on_exit(exit_function, NULL);
-}
-
-int main19(void)
-{
-	void *backtrace_fns[1];
-	size_t entries;
-
-	entries = backtrace(backtrace_fns, 1);
-	backtrace_symbols(backtrace_fns, entries);
-
-	return 0;
-}
-
-int main20(void)
-{
-	numa_available();
-	return 0;
-}
+/*
+ * test-all.c: Try to build all the main testcases at once.
+ *
+ * A well-configured system will have all the prereqs installed, so we can speed
+ * up auto-detection on such systems.
+ */
+
+/*
+ * Quirk: Python and Perl headers cannot be in arbitrary places, so keep
+ * these 3 testcases at the top:
+ */
+#define main main_test_libpython
+# include "test-libpython.c"
+#undef main
+
+#define main main_test_libpython_version
+# include "test-libpython-version.c"
+#undef main
+
+#define main main_test_libperl
+# include "test-libperl.c"
+#undef main
+
+#define main main_test_hello
+# include "test-hello.c"
+#undef main
+
+#define main main_test_libelf
+# include "test-libelf.c"
+#undef main
+
+#define main main_test_libelf_mmap
+# include "test-libelf-mmap.c"
+#undef main
+
+#define main main_test_glibc
+# include "test-glibc.c"
+#undef main
+
+#define main main_test_dwarf
+# include "test-dwarf.c"
+#undef main
+
+#define main main_test_libelf_getphdrnum
+# include "test-libelf-getphdrnum.c"
+#undef main
+
+#define main main_test_libunwind
+# include "test-libunwind.c"
+#undef main
+
+#define main main_test_libaudit
+# include "test-libaudit.c"
+#undef main
+
+#define main main_test_libslang
+# include "test-libslang.c"
+#undef main
+
+#define main main_test_gtk2
+# include "test-gtk2.c"
+#undef main
+
+#define main main_test_gtk2_infobar
+# include "test-gtk2-infobar.c"
+#undef main
+
+#define main main_test_libbfd
+# include "test-libbfd.c"
+#undef main
+
+#define main main_test_on_exit
+# include "test-on-exit.c"
+#undef main
+
+#define main main_test_backtrace
+# include "test-backtrace.c"
+#undef main
+
+#define main main_test_libnuma
+# include "test-libnuma.c"
+#undef main
 
 int main(int argc, char *argv[])
 {
-	main1();
-	main2();
-	main3();
-	main4();
-	main5();
-	main6();
-	main7();
-	main8();
-	main9();
-	main10();
-	main11();
-	main12(argc, argv);
-	main13();
-	main14();
-	main15();
-	main16();
-	main17();
-	main18();
-	main19();
-	main20();
+	main_test_libpython();
+	main_test_libpython_version();
+	main_test_libperl();
+	main_test_hello();
+	main_test_libelf();
+	main_test_libelf_mmap();
+	main_test_glibc();
+	main_test_dwarf();
+	main_test_libelf_getphdrnum();
+	main_test_libunwind();
+	main_test_libaudit();
+	main_test_libslang();
+	main_test_gtk2(argc, argv);
+	main_test_gtk2_infobar(argc, argv);
+	main_test_libbfd();
+	main_test_on_exit();
+	main_test_backtrace();
+	main_test_libnuma();
 
 	return 0;
 }
-- 
1.8.3.1

