Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3GWHsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:48:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56281 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3GWHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:48:26 -0400
Date: Tue, 23 Jul 2013 00:48:01 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c0ec11088800e1a5efbccc291a42580727798123@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, bp@alien8.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        bp@alien8.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1374497014-2817-5-git-send-email-jolsa@redhat.com>
References: <1374497014-2817-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add 'make install/install-bin'
  tests into tests/make
Git-Commit-ID: c0ec11088800e1a5efbccc291a42580727798123
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:48:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0ec11088800e1a5efbccc291a42580727798123
Gitweb:     http://git.kernel.org/tip/c0ec11088800e1a5efbccc291a42580727798123
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 22 Jul 2013 14:43:33 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Jul 2013 16:54:06 -0300

perf tests: Add 'make install/install-bin' tests into tests/make

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
