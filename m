Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3JGL6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:58:30 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:33952 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3JGL6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:21 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 35/50] tools/perf/build: Invoke feature-checks 'clean' target from the main Makefile
Date: Mon,  7 Oct 2013 13:56:28 +0200
Message-Id: <1381147003-2574-36-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config/Makefile is not included for the 'clean' target, so invoke the
config/feature-checks/Makefile 'clean' target from Makefile.perf.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-sh2cGvmsjbrazarlqre7pVwt@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 45df85e..4dd2caa 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -808,7 +808,14 @@ $(INSTALL_DOC_TARGETS):
 
 ### Cleaning rules
 
-clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean
+#
+# This is here, not in config/Makefile, because config/Makefile does
+# not get included for the clean target:
+#
+config-clean:
+	@$(MAKE) -C config/feature-checks clean
+
+clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean config-clean
 	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
@@ -828,6 +835,6 @@ else
     GIT-HEAD-PHONY =
 endif
 
-.PHONY: all install clean strip
+.PHONY: all install clean config-clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
-- 
1.7.11.7

