Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3GVMoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:44:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab3GVMoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:44:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 2/5] perf tests: Rename TMP to TMP_O tests/make variable
Date: Mon, 22 Jul 2013 14:43:31 +0200
Message-Id: <1374497014-2817-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
References: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming TMP to TMP_O tests/make variable to make a
name space for other temp variables.

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
-- 
1.7.11.7

