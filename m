Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3GVMoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3GVMoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:44:14 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 4/5] perf tests: Add 'make install/install-bin' tests into tests/make
Date: Mon, 22 Jul 2013 14:43:33 +0200
Message-Id: <1374497014-2817-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
References: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 'make install' and 'make install-bin' tests into
tests/make. It's run as part of the suite, but could be
run separately like:

  $ make -f tests/make make_install
  - make_install: cd . && make -f Makefile DESTDIR=/tmp/tmp.LpkYbk5pfs install
    test: test -x /tmp/tmp.LpkYbk5pfs/bin/perf
  $ make -f tests/make make_install_bin
  - make_install_bin: cd . && make -f Makefile DESTDIR=/tmp/tmp.dMxePBMcFT
    install-bin
    test: test -x /tmp/tmp.dMxePBMcFT/bin/perf

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
 tools/perf/tests/make | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 7646a00..d3819f2 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -27,6 +27,8 @@ make_help           := help
 make_doc            := doc
 make_perf_o         := perf.o
 make_util_map_o     := util/map.o
+make_install        := install
+make_install_bin    := install-bin
 
 # all the NO_* variable combined
 make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
@@ -56,6 +58,8 @@ run += make_help
 run += make_doc
 run += make_perf_o
 run += make_util_map_o
+run += make_install
+run += make_install_bin
 run += make_minimal
 
 ifneq ($(call has,ctags),)
@@ -91,6 +95,11 @@ test_make_python_perf_so := test -f $(PERF)/python/perf.so
 test_make_perf_o     := test -f $(PERF)/perf.o
 test_make_util_map_o := test -f $(PERF)/util/map.o
 
+test_make_install       := test -x $$TMP_DEST/bin/perf
+test_make_install_O     := $(test_make_install)
+test_make_install_bin   := $(test_make_install)
+test_make_install_bin_O := $(test_make_install)
+
 # Kbuild tests only
 #test_make_python_perf_so_O := test -f $$TMP/tools/perf/python/perf.so
 #test_make_perf_o_O         := test -f $$TMP/tools/perf/perf.o
-- 
1.7.11.7

