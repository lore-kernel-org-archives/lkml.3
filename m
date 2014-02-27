Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaB0N2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:28:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaB0N2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:28:23 -0500
Date: Thu, 27 Feb 2014 05:27:49 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-2a94f6c455b38c0411d92b0df794bb8137bf1957@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1392805300-14610-2-git-send-email-jolsa@redhat.com>
References: <1392805300-14610-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add pmu-bison.o make test
Git-Commit-ID: 2a94f6c455b38c0411d92b0df794bb8137bf1957
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a94f6c455b38c0411d92b0df794bb8137bf1957
Gitweb:     http://git.kernel.org/tip/2a94f6c455b38c0411d92b0df794bb8137bf1957
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 19 Feb 2014 11:21:39 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 09:29:35 -0300

perf tests: Add pmu-bison.o make test

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
index eb3671b..2d24954 100644
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
