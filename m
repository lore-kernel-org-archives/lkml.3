Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3GVMo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:44:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab3GVMoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:44:55 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 5/5] perf tests: Add broken install-* tests into tests/make
Date: Mon, 22 Jul 2013 14:43:34 +0200
Message-Id: <1374497014-2817-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
References: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding install-* tests into tests/make. Those tests are
broken, so commenting them out right away.

* Nothing get installed for install-man, install_doc and
  install_html targets, they just rebuild the documentation.

* I've got following error for 'install-info':

  $ make -f tests/make make_install_info
  - make_install_info: cd . && make -f Makefile DESTDIR=/tmp/tmp.Xi4mb9J1a0 install-info

  $ tail -f make_install_info
  ...
  PERF_VERSION = 3.11.rc1.g9b3c2d
  make[2]: *** No rule to make target `user-manual.xml', needed by `user-manual.texi'.  Stop.
  make[1]: *** [install-info] Error 2

* I've got following error for 'install-pdf':

  $ make -f tests/make make_install_pdf
  - make_install_pdf: cd . && make -f Makefile DESTDIR=/tmp/tmp.fXseECBbt1 install-pdf

  $ tail -f make_install_pdf
  ...
  PERF_VERSION = 3.11.rc1.g9b3c2d
  make[2]: *** No rule to make target `user-manual.xml', needed by `user-manual.pdf'.  Stop.
  make[1]: *** [install-pdf] Error 2

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
---
 tools/perf/tests/make | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index d3819f2..2ca0abf 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -29,6 +29,11 @@ make_perf_o         := perf.o
 make_util_map_o     := util/map.o
 make_install        := install
 make_install_bin    := install-bin
+make_install_doc    := install-doc
+make_install_man    := install-man
+make_install_html   := install-html
+make_install_info   := install-info
+make_install_pdf    := install-pdf
 
 # all the NO_* variable combined
 make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
@@ -60,6 +65,12 @@ run += make_perf_o
 run += make_util_map_o
 run += make_install
 run += make_install_bin
+# FIXME 'install-*' commented out till they're fixed
+# run += make_install_doc
+# run += make_install_man
+# run += make_install_html
+# run += make_install_info
+# run += make_install_pdf
 run += make_minimal
 
 ifneq ($(call has,ctags),)
@@ -100,6 +111,26 @@ test_make_install_O     := $(test_make_install)
 test_make_install_bin   := $(test_make_install)
 test_make_install_bin_O := $(test_make_install)
 
+# FIXME nothing gets installed
+test_make_install_man    := test -f $$TMP_DEST/share/man/man1/perf.1
+test_make_install_man_O  := $(test_make_install_man)
+
+# FIXME nothing gets installed
+test_make_install_doc    := $(test_ok)
+test_make_install_doc_O  := $(test_ok)
+
+# FIXME nothing gets installed
+test_make_install_html   := $(test_ok)
+test_make_install_html_O := $(test_ok)
+
+# FIXME nothing gets installed
+test_make_install_info   := $(test_ok)
+test_make_install_info_O := $(test_ok)
+
+# FIXME nothing gets installed
+test_make_install_pdf    := $(test_ok)
+test_make_install_pdf_O  := $(test_ok)
+
 # Kbuild tests only
 #test_make_python_perf_so_O := test -f $$TMP/tools/perf/python/perf.so
 #test_make_perf_o_O         := test -f $$TMP/tools/perf/perf.o
-- 
1.7.11.7

