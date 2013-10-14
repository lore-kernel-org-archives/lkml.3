Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab3JNUC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:02:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38506 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab3JNUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 036/161] tools/perf/build: Invoke feature-checks 'clean' target from the main Makefile
Date: Mon, 14 Oct 2013 17:00:25 -0300
Message-Id: <1381780950-25642-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

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
index df76198d45d4..6b7779b3760b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -809,7 +809,14 @@ $(INSTALL_DOC_TARGETS):
 
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
@@ -829,6 +836,6 @@ else
     GIT-HEAD-PHONY =
 endif
 
-.PHONY: all install clean strip
+.PHONY: all install clean config-clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
-- 
1.8.1.4

