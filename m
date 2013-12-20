Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3LTTKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38556 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3LTTJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/35] perf tools: Making QUIET_(CLEAN|INSTAL) variables global
Date: Fri, 20 Dec 2013 16:08:54 -0300
Message-Id: <1387566550-3524-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving QUIET_(CLEAN|INSTAL) variables into:

  tools/scripts/Makefile.include

to be usable by other tools. The change to use them in libtraceevent is
in following patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/utilities.mak | 7 -------
 tools/scripts/Makefile.include  | 3 +++
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index f168debc5be2..4d985e0f03f5 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -178,10 +178,3 @@ endef
 _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
-
-ifneq ($(findstring $(MAKEFLAGS),s),s)
-  ifneq ($(V),1)
-    QUIET_CLEAN		= @printf '  CLEAN    %s\n' $1;
-    QUIET_INSTALL	= @printf '  INSTALL  %s\n' $1;
-  endif
-endif
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index ee76544deecb..e4cfbedcaf11 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -76,5 +76,8 @@ ifneq ($(findstring $(MAKEFLAGS),s),s)
 		+@echo	       '  DESCEND  '$(1); \
 		mkdir -p $(OUTPUT)$(1) && \
 		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
+
+	QUIET_CLEAN    = @printf '  CLEAN    %s\n' $1;
+	QUIET_INSTALL  = @printf '  INSTALL  %s\n' $1;
   endif
 endif
-- 
1.8.1.4

