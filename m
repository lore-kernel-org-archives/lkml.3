Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaB0N2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:28:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0N2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:28:13 -0500
Date: Thu, 27 Feb 2014 05:27:37 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-04b01a1db46cc17f6ab2ac2bada27d8e671710e1@git.kernel.org>
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
In-Reply-To: <1392805300-14610-1-git-send-email-jolsa@redhat.com>
References: <1392805300-14610-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Fix *.o make tests
Git-Commit-ID: 04b01a1db46cc17f6ab2ac2bada27d8e671710e1
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

Commit-ID:  04b01a1db46cc17f6ab2ac2bada27d8e671710e1
Gitweb:     http://git.kernel.org/tip/04b01a1db46cc17f6ab2ac2bada27d8e671710e1
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 19 Feb 2014 11:21:38 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 09:29:35 -0300

perf tests: Fix *.o make tests

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
