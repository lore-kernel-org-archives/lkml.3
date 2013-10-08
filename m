Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3JHKMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:12:52 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45289 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab3JHKMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:41 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 41/52] tools/perf/build: Standardize the various messages output by parallel make
Date: Tue,  8 Oct 2013 12:11:11 +0200
Message-Id: <1381227082-22039-42-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
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
index 04d9dc0..65e0fad 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -179,9 +179,9 @@ endif
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
1.8.3.1

