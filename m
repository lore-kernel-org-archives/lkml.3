Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3GWHsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:48:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56270 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3GWHsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:48:18 -0400
Date: Tue, 23 Jul 2013 00:47:40 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-8ba7cdea321d4d5bb53ac210f4e0a4bca5b0dba5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, bp@alien8.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        bp@alien8.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1374497014-2817-3-git-send-email-jolsa@redhat.com>
References: <1374497014-2817-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Rename TMP to TMP_O tests/
 make variable
Git-Commit-ID: 8ba7cdea321d4d5bb53ac210f4e0a4bca5b0dba5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:47:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ba7cdea321d4d5bb53ac210f4e0a4bca5b0dba5
Gitweb:     http://git.kernel.org/tip/8ba7cdea321d4d5bb53ac210f4e0a4bca5b0dba5
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 22 Jul 2013 14:43:31 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Jul 2013 15:36:19 -0300

perf tests: Rename TMP to TMP_O tests/make variable

Renaming TMP to TMP_O tests/make variable to make a name space for other
temp variables.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374497014-2817-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index d1efef9..dbbb62c 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -102,7 +102,7 @@ test_make_util_map_o_O := true
 test_default = test -x $(PERF)/perf
 test = $(if $(test_$1),$(test_$1),$(test_default))
 
-test_default_O = test -x $$TMP/perf
+test_default_O = test -x $$TMP_O/perf
 test_O = $(if $(test_$1),$(test_$1),$(test_default_O))
 
 all:
@@ -127,14 +127,14 @@ $(run):
 
 $(run_O):
 	$(call clean)
-	@TMP=$$(mktemp -d); \
-	cmd="cd $(PERF) && make -f $(MK) $($(patsubst %_O,%,$@)) O=$$TMP"; \
+	@TMP_O=$$(mktemp -d); \
+	cmd="cd $(PERF) && make -f $(MK) $($(patsubst %_O,%,$@)) O=$$TMP_O"; \
 	echo "- $@: $$cmd" && echo $$cmd > $@ && \
 	( eval $$cmd ) >> $@ 2>&1 && \
 	echo "  test: $(call test_O,$@)"; \
 	$(call test_O,$@) && \
 	rm -f $@ && \
-	rm -rf $$TMP
+	rm -rf $$TMP_O
 
 all: $(run) $(run_O)
 	@echo OK
