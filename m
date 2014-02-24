Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaBXT6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:58:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49160 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaBXT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:55 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/12] perf tests: Add pmu-bison.o make test
Date: Mon, 24 Feb 2014 16:56:30 -0300
Message-Id: <1393271800-17505-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393271800-17505-1-git-send-email-acme@infradead.org>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding pmu-bison.o make test:

  $ make -f tests/make make_util_pmu_bison_o
  - make_util_pmu_bison_o: cd . && make -f Makefile DESTDIR=/tmp/tmp.0u99hQn8Ga util/pmu-bison.o
  $ make -f tests/make make_util_pmu_bison_o_O
  - make_util_pmu_bison_o_O: cd . && make -f Makefile O=/tmp/tmp.sWKDLGS71O DESTDIR=/tmp/tmp.htQNJAfJ0d util/pmu-bison.o
  make: *** [make_util_pmu_bison_o_O] Error 1

The 'O=' version of the test is failing at the moment, due to the OUTPUT
directory issue fixed in next patch.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392805300-14610-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index eb3671be129c..2d2495423be5 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -35,8 +35,9 @@ make_tags           := tags
 make_cscope         := cscope
 make_help           := help
 make_doc            := doc
-make_perf_o         := perf.o
-make_util_map_o     := util/map.o
+make_perf_o           := perf.o
+make_util_map_o       := util/map.o
+make_util_pmu_bison_o := util/pmu-bison.o
 make_install        := install
 make_install_bin    := install-bin
 make_install_doc    := install-doc
@@ -73,6 +74,7 @@ run += make_help
 run += make_doc
 run += make_perf_o
 run += make_util_map_o
+run += make_util_pmu_bison_o
 run += make_install
 run += make_install_bin
 # FIXME 'install-*' commented out till they're fixed
@@ -113,8 +115,9 @@ test_make_doc_O  := $(test_ok)
 
 test_make_python_perf_so := test -f $(PERF)/python/perf.so
 
-test_make_perf_o     := test -f $(PERF)/perf.o
-test_make_util_map_o := test -f $(PERF)/util/map.o
+test_make_perf_o           := test -f $(PERF)/perf.o
+test_make_util_map_o       := test -f $(PERF)/util/map.o
+test_make_util_pmu_bison_o := test -f $(PERF)/util/pmu-bison.o
 
 define test_dest_files
   for file in $(1); do				\
@@ -170,6 +173,7 @@ test_make_install_pdf_O  := $(test_ok)
 test_make_python_perf_so_O    := test -f $$TMP_O/python/perf.so
 test_make_perf_o_O            := test -f $$TMP_O/perf.o
 test_make_util_map_o_O        := test -f $$TMP_O/util/map.o
+test_make_util_pmu_bison_o_O := test -f $$TMP_O/util/pmu-bison.o
 
 test_default = test -x $(PERF)/perf
 test = $(if $(test_$1),$(test_$1),$(test_default))
-- 
1.8.1.4

