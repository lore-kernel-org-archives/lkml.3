Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaBXT6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:58:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49152 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaBXT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/12] perf tests: Fix *.o make tests
Date: Mon, 24 Feb 2014 16:56:29 -0300
Message-Id: <1393271800-17505-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393271800-17505-1-git-send-email-acme@infradead.org>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Enable and fix *.o object make tests. Following tests are now available:

  $ make -f tests/make make_perf_o_O
  - make_perf_o_O: cd . && make -f Makefile O=/tmp/tmp.iF5vI5emGy DESTDIR=/tmp/tmp.epDPFVhH0s perf.o
  $ make -f tests/make make_util_map_o_O
  - make_util_map_o_O: cd . && make -f Makefile O=/tmp/tmp.BWuMf55ygC DESTDIR=/tmp/tmp.QbGBRF95oP util/map.o

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392805300-14610-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 00544b8b644b..eb3671be129c 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -167,13 +167,9 @@ test_make_install_info_O := $(test_ok)
 test_make_install_pdf    := $(test_ok)
 test_make_install_pdf_O  := $(test_ok)
 
-# Kbuild tests only
-#test_make_python_perf_so_O := test -f $$TMP/tools/perf/python/perf.so
-#test_make_perf_o_O         := test -f $$TMP/tools/perf/perf.o
-#test_make_util_map_o_O     := test -f $$TMP/tools/perf/util/map.o
-
-test_make_perf_o_O     := true
-test_make_util_map_o_O := true
+test_make_python_perf_so_O    := test -f $$TMP_O/python/perf.so
+test_make_perf_o_O            := test -f $$TMP_O/perf.o
+test_make_util_map_o_O        := test -f $$TMP_O/util/map.o
 
 test_default = test -x $(PERF)/perf
 test = $(if $(test_$1),$(test_$1),$(test_default))
-- 
1.8.1.4

