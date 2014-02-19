Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaBSKWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:22:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaBSKWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:22:03 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/3] perf tests: Fix *.o make tests
Date: Wed, 19 Feb 2014 11:21:38 +0100
Message-Id: <1392805300-14610-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable and fix *.o object make tests. Following tests
are now available:

  $ make -f tests/make make_perf_o_O
  - make_perf_o_O: cd . && make -f Makefile O=/tmp/tmp.iF5vI5emGy DESTDIR=/tmp/tmp.epDPFVhH0s perf.o
  $ make -f tests/make make_util_map_o_O
  - make_util_map_o_O: cd . && make -f Makefile O=/tmp/tmp.BWuMf55ygC DESTDIR=/tmp/tmp.QbGBRF95oP util/map.o

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/tests/make | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 00544b8..eb3671b 100644
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
1.8.3.1

