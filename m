Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3LSNpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:45:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab3LSNma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:42:30 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/9] perf tools: Making QUIET_(CLEAN|INSTAL) variables global
Date: Thu, 19 Dec 2013 14:42:00 +0100
Message-Id: <1387460527-15030-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving QUIET_(CLEAN|INSTAL) variables into:
  tools/scripts/Makefile.include

to be usable by other tools. The change to use them
in libtraceevent is in following patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/config/utilities.mak | 7 -------
 tools/scripts/Makefile.include  | 3 +++
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index f168deb..4d985e0 100644
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
index ee76544..e4cfbed 100644
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
1.8.3.1

