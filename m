Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab3GVUXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:23:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52109 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338Ab3GVUW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:22:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/11] perf tests: Add 'make install/install-bin' tests into tests/make
Date: Mon, 22 Jul 2013 17:22:37 -0300
Message-Id: <1374524559-9839-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374524559-9839-1-git-send-email-acme@infradead.org>
References: <1374524559-9839-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding 'make install' and 'make install-bin' tests into tests/make. It's
run as part of the suite, but could be run separately like:

  $ make -f tests/make make_install
  - make_install: cd . && make -f Makefile DESTDIR=/tmp/tmp.LpkYbk5pfs install
    test: test -x /tmp/tmp.LpkYbk5pfs/bin/perf
  $ make -f tests/make make_install_bin
  - make_install_bin: cd . && make -f Makefile DESTDIR=/tmp/tmp.dMxePBMcFT
    install-bin
    test: test -x /tmp/tmp.dMxePBMcFT/bin/perf

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374497014-2817-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

