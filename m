Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaAGMuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:50:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaAGMsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:48:38 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 16/16] perf tests: Add NO_LIBDW_DWARF_UNWIND make test
Date: Tue,  7 Jan 2014 13:47:33 +0100
Message-Id: <1389098853-14466-17-git-send-email-jolsa@redhat.com>
In-Reply-To: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding make test for NO_LIBDW_DWARF_UNWIND option,
plus updating minimal build test with it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/tests/make | 63 +++++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index e341088..a38e6a0 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -14,41 +14,43 @@ endif
 has = $(shell which $1 2>/dev/null)
 
 # standard single make variable specified
-make_clean_all      := clean all
-make_python_perf_so := python/perf.so
-make_debug          := DEBUG=1
-make_no_libperl     := NO_LIBPERL=1
-make_no_libpython   := NO_LIBPYTHON=1
-make_no_scripts     := NO_LIBPYTHON=1 NO_LIBPERL=1
-make_no_newt        := NO_NEWT=1
-make_no_slang       := NO_SLANG=1
-make_no_gtk2        := NO_GTK2=1
-make_no_ui          := NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
-make_no_demangle    := NO_DEMANGLE=1
-make_no_libelf      := NO_LIBELF=1
-make_no_libunwind   := NO_LIBUNWIND=1
-make_no_backtrace   := NO_BACKTRACE=1
-make_no_libnuma     := NO_LIBNUMA=1
-make_no_libaudit    := NO_LIBAUDIT=1
-make_no_libbionic   := NO_LIBBIONIC=1
-make_tags           := tags
-make_cscope         := cscope
-make_help           := help
-make_doc            := doc
-make_perf_o         := perf.o
-make_util_map_o     := util/map.o
-make_install        := install
-make_install_bin    := install-bin
-make_install_doc    := install-doc
-make_install_man    := install-man
-make_install_html   := install-html
-make_install_info   := install-info
-make_install_pdf    := install-pdf
+make_clean_all             := clean all
+make_python_perf_so        := python/perf.so
+make_debug                 := DEBUG=1
+make_no_libperl            := NO_LIBPERL=1
+make_no_libpython          := NO_LIBPYTHON=1
+make_no_scripts            := NO_LIBPYTHON=1 NO_LIBPERL=1
+make_no_newt               := NO_NEWT=1
+make_no_slang              := NO_SLANG=1
+make_no_gtk2               := NO_GTK2=1
+make_no_ui                 := NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
+make_no_demangle           := NO_DEMANGLE=1
+make_no_libelf             := NO_LIBELF=1
+make_no_libunwind          := NO_LIBUNWIND=1
+make_no_libdw_dwarf_unwind := NO_LIBDW_DWARF_UNWIND=1
+make_no_backtrace          := NO_BACKTRACE=1
+make_no_libnuma            := NO_LIBNUMA=1
+make_no_libaudit           := NO_LIBAUDIT=1
+make_no_libbionic          := NO_LIBBIONIC=1
+make_tags                  := tags
+make_cscope                := cscope
+make_help                  := help
+make_doc                   := doc
+make_perf_o                := perf.o
+make_util_map_o            := util/map.o
+make_install               := install
+make_install_bin           := install-bin
+make_install_doc           := install-doc
+make_install_man           := install-man
+make_install_html          := install-html
+make_install_info          := install-info
+make_install_pdf           := install-pdf
 
 # all the NO_* variable combined
 make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
 make_minimal        += NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1
 make_minimal        += NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1
+make_minimal        += NO_LIBDW_DWARF_UNWIND=1
 
 # $(run) contains all available tests
 run := make_pure
@@ -65,6 +67,7 @@ run += make_no_ui
 run += make_no_demangle
 run += make_no_libelf
 run += make_no_libunwind
+run += make_no_libdw_dwarf_unwind
 run += make_no_backtrace
 run += make_no_libnuma
 run += make_no_libaudit
-- 
1.8.3.1

