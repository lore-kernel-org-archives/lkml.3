Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3JHKQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:16:17 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53134 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3JHKMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:44 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 43/52] tools/perf/build: Remove unused config/feature-tests.mak
Date: Tue,  8 Oct 2013 12:11:13 +0200
Message-Id: <1381227082-22039-44-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove try-cc et al. These got obsoleted by the split-out feature checks in
config/feature-checks/.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-Y6ailbiranadqlrl8Dfivjbi@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile          |   3 +-
 tools/perf/config/feature-tests.mak | 244 --------------------------------------------------------
 tools/perf/config/utilities.mak     |  14 ----
 3 files changed, 1 insertion(+), 260 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index fdc1cb0..132cf82 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -51,7 +51,6 @@ LIB_INCLUDE := $(srctree)/tools/lib/
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
-include $(src-perf)/config/feature-tests.mak
 include $(src-perf)/config/utilities.mak
 
 ifeq ($(call get-executable,$(FLEX)),)
@@ -274,7 +273,7 @@ else
       msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
       NO_DWARF := 1
     endif # Dwarf support
-  endif # SOURCE_LIBELF
+  endif # libelf support
 endif # NO_LIBELF
 
 ifndef NO_LIBELF
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index f793057..139597f 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -1,246 +1,2 @@
-define SOURCE_HELLO
-#include <stdio.h>
-int main(void)
-{
-	return puts(\"hi\");
-}
-endef
 
-ifndef NO_DWARF
-define SOURCE_DWARF
-#include <dwarf.h>
-#include <elfutils/libdw.h>
-#include <elfutils/version.h>
-#ifndef _ELFUTILS_PREREQ
-#error
-#endif
 
-int main(void)
-{
-	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
-	return (long)dbg;
-}
-endef
-endif
-
-define SOURCE_LIBELF
-#include <libelf.h>
-
-int main(void)
-{
-	Elf *elf = elf_begin(0, ELF_C_READ, 0);
-	return (long)elf;
-}
-endef
-
-define SOURCE_GLIBC
-#include <gnu/libc-version.h>
-
-int main(void)
-{
-	const char *version = gnu_get_libc_version();
-	return (long)version;
-}
-endef
-
-define SOURCE_BIONIC
-#include <android/api-level.h>
-
-int main(void)
-{
-	return __ANDROID_API__;
-}
-endef
-
-define SOURCE_ELF_MMAP
-#include <libelf.h>
-int main(void)
-{
-	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
-	return (long)elf;
-}
-endef
-
-define SOURCE_ELF_GETPHDRNUM
-#include <libelf.h>
-int main(void)
-{
-	size_t dst;
-	return elf_getphdrnum(0, &dst);
-}
-endef
-
-ifndef NO_SLANG
-define SOURCE_SLANG
-#include <slang.h>
-
-int main(void)
-{
-	return SLsmg_init_smg();
-}
-endef
-endif
-
-ifndef NO_GTK2
-define SOURCE_GTK2
-#pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
-#include <gtk/gtk.h>
-#pragma GCC diagnostic error \"-Wstrict-prototypes\"
-
-int main(int argc, char *argv[])
-{
-        gtk_init(&argc, &argv);
-
-        return 0;
-}
-endef
-
-define SOURCE_GTK2_INFOBAR
-#pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
-#include <gtk/gtk.h>
-#pragma GCC diagnostic error \"-Wstrict-prototypes\"
-
-int main(void)
-{
-	gtk_info_bar_new();
-
-	return 0;
-}
-endef
-endif
-
-ifndef NO_LIBPERL
-define SOURCE_PERL_EMBED
-#include <EXTERN.h>
-#include <perl.h>
-
-int main(void)
-{
-perl_alloc();
-return 0;
-}
-endef
-endif
-
-ifndef NO_LIBPYTHON
-define SOURCE_PYTHON_VERSION
-#include <Python.h>
-#if PY_VERSION_HEX >= 0x03000000
-	#error
-#endif
-int main(void)
-{
-	return 0;
-}
-endef
-define SOURCE_PYTHON_EMBED
-#include <Python.h>
-int main(void)
-{
-	Py_Initialize();
-	return 0;
-}
-endef
-endif
-
-define SOURCE_BFD
-#include <bfd.h>
-
-int main(void)
-{
-	bfd_demangle(0, 0, 0);
-	return 0;
-}
-endef
-
-define SOURCE_CPLUS_DEMANGLE
-extern char *cplus_demangle(const char *, int);
-
-int main(void)
-{
-	cplus_demangle(0, 0);
-	return 0;
-}
-endef
-
-define SOURCE_STRLCPY
-#include <stdlib.h>
-extern size_t strlcpy(char *dest, const char *src, size_t size);
-
-int main(void)
-{
-	strlcpy(NULL, NULL, 0);
-	return 0;
-}
-endef
-
-ifndef NO_LIBUNWIND
-define SOURCE_LIBUNWIND
-#include <libunwind.h>
-#include <stdlib.h>
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
-int main(void)
-{
-	unw_addr_space_t addr_space;
-	addr_space = unw_create_addr_space(NULL, 0);
-	unw_init_remote(NULL, addr_space, NULL);
-	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
-	return 0;
-}
-endef
-endif
-
-ifndef NO_BACKTRACE
-define SOURCE_BACKTRACE
-#include <execinfo.h>
-#include <stdio.h>
-
-int main(void)
-{
-	backtrace(NULL, 0);
-	backtrace_symbols(NULL, 0);
-	return 0;
-}
-endef
-endif
-
-ifndef NO_LIBAUDIT
-define SOURCE_LIBAUDIT
-#include <libaudit.h>
-
-int main(void)
-{
-	printf(\"error message: %s\", audit_errno_to_name(0));
-	return audit_open();
-}
-endef
-endif
-
-define SOURCE_ON_EXIT
-#include <stdio.h>
-
-int main(void)
-{
-	return on_exit(NULL, NULL);
-}
-endef
-
-define SOURCE_LIBNUMA
-#include <numa.h>
-#include <numaif.h>
-
-int main(void)
-{
-	numa_available();
-	return 0;
-}
-endef
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 94d2d4f..4d985e0 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -178,17 +178,3 @@ endef
 _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
-
-# try-cc
-# Usage: option = $(call try-cc, source-to-build, cc-options, msg)
-ifneq ($(V),1)
-TRY_CC_OUTPUT= > /dev/null 2>&1
-endif
-TRY_CC_MSG=echo "    CHK $(3)" 1>&2;
-
-try-cc = $(shell sh -c						  \
-	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
-	 $(TRY_CC_MSG)						  \
-	 echo "$(1)" |						  \
-	 $(CC) -x c - $(2) -o "$$TMP" $(TRY_CC_OUTPUT) && echo y; \
-	 rm -f "$$TMP"')
-- 
1.8.3.1

