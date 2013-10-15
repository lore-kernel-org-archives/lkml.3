Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3JOFSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:18:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3JOFR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:17:57 -0400
Date: Mon, 14 Oct 2013 22:17:43 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-de0f03fb8dc268de63d366e735cc576a22df201b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Invoke feature-checks 'clean'
  target from the main Makefile
Git-Commit-ID: de0f03fb8dc268de63d366e735cc576a22df201b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:17:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de0f03fb8dc268de63d366e735cc576a22df201b
Gitweb:     http://git.kernel.org/tip/de0f03fb8dc268de63d366e735cc576a22df201b
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 2 Oct 2013 09:43:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:52 +0200

tools/perf/build: Invoke feature-checks 'clean' target from the main Makefile

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
index df76198..6b7779b 100644
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
