Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab3GVUXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:23:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52107 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab3GVUW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:22:57 -0400
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
Subject: [PATCH 06/11] perf tests: Run ctags/cscope make tests only with needed binaries
Date: Mon, 22 Jul 2013 17:22:34 -0300
Message-Id: <1374524559-9839-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374524559-9839-1-git-send-email-acme@infradead.org>
References: <1374524559-9839-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Running tags and cscope make tests only if the 'ctags' and 'cscope'
binaries are installed, so we don't have false alarm test failures.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374497014-2817-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

