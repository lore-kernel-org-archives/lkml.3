Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3GVMpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:45:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270Ab3GVMpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:45:15 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 1/5] perf tests: Run ctags/cscope make tests only with needed binaries
Date: Mon, 22 Jul 2013 14:43:30 +0200
Message-Id: <1374497014-2817-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
References: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running tags and cscope make tests only if the 'ctags'
and 'cscope' binaries are installed, so we don't have
false alarm test failures.

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
 tools/perf/tests/make | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index c441a28..d1efef9 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -1,6 +1,8 @@
 PERF := .
 MK   := Makefile
 
+has = $(shell which $1 2>/dev/null)
+
 # standard single make variable specified
 make_clean_all      := clean all
 make_python_perf_so := python/perf.so
@@ -50,14 +52,19 @@ run += make_no_backtrace
 run += make_no_libnuma
 run += make_no_libaudit
 run += make_no_libbionic
-run += make_tags
-run += make_cscope
 run += make_help
 run += make_doc
 run += make_perf_o
 run += make_util_map_o
 run += make_minimal
 
+ifneq ($(call has,ctags),)
+run += make_tags
+endif
+ifneq ($(call has,cscope),)
+run += make_cscope
+endif
+
 # $(run_O) contains same portion of $(run) tests with '_O' attached
 # to distinguish O=... tests
 run_O := $(addsuffix _O,$(run))
-- 
1.7.11.7

