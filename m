Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab3GWHsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:48:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3GWHsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:48:06 -0400
Date: Tue, 23 Jul 2013 00:47:30 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0659e66981ab137c11a746899672c886e1973a7b@git.kernel.org>
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
In-Reply-To: <1374497014-2817-2-git-send-email-jolsa@redhat.com>
References: <1374497014-2817-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Run ctags/
 cscope make tests only with needed binaries
Git-Commit-ID: 0659e66981ab137c11a746899672c886e1973a7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:47:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0659e66981ab137c11a746899672c886e1973a7b
Gitweb:     http://git.kernel.org/tip/0659e66981ab137c11a746899672c886e1973a7b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 22 Jul 2013 14:43:30 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Jul 2013 15:35:03 -0300

perf tests: Run ctags/cscope make tests only with needed binaries

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
