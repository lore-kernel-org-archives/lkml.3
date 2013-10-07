Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab3JGL6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:58:37 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:58174 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3JGL60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:26 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 40/50] tools/perf/build: Standardize the various messages output by parallel make
Date: Mon,  7 Oct 2013 13:56:33 +0200
Message-Id: <1381147003-2574-41-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-mky0rtpwxi3ivxsvdjoOEmhr@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile        | 23 ++++++++++++++++++++---
 tools/perf/config/Makefile |  4 ++--
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ce7874b..3b925ad 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -13,13 +13,30 @@ endif
 
 export JOBS
 
-$(info $(shell printf '# [ perf build: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build. ]\n'))
+define print_msg
+  @printf '    BUILD: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
+endef
+
+define make
+  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) $@
+endef
 
 #
 # Needed if no target specified:
 #
 all:
-	@$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) $@
+	$(print_msg)
+	$(make)
+
+#
+# The clean target is not really parallel, don't print the jobs info:
+#
+clean:
+	$(make)
 
+#
+# All other targets get passed through:
+#
 %:
-	@$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) $@
+	$(print_msg)
+	$(make)
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 7b104e4..6dfd432 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -178,9 +178,9 @@ endif
 feature_print = $(eval $(feature_print_code))
 define feature_print_code
   ifeq ($(feature-$(1)), 1)
-    MSG := $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
+    MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
   else
-    MSG := $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
+    MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
   endif
   $(info $(MSG))
 endef
-- 
1.7.11.7

