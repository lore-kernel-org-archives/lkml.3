Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935420Ab3E3QKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:10:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51078 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934699Ab3E3QC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sam Ravnborg <sam@ravnborg.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 48/66] perf tools: Move paths config into config/Makefile
Date: Thu, 30 May 2013 19:01:21 +0300
Message-Id: <1369929699-8724-49-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving paths config into config/Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369398928-9809-17-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 58 ----------------------------------------------
 tools/perf/config/Makefile | 52 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 11525ac..240bf88 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -99,39 +99,6 @@ ifeq ($(config),1)
 include config/Makefile
 endif
 
-# Among the variables below, these:
-#   perfexecdir
-#   template_dir
-#   mandir
-#   infodir
-#   htmldir
-#   ETC_PERFCONFIG (but not sysconfdir)
-# can be specified as a relative path some/where/else;
-# this is interpreted as relative to $(prefix) and "perf" at
-# runtime figures out where they are based on the path to the executable.
-# This can help installing the suite in a relocatable way.
-
-# Make the path relative to DESTDIR, not to prefix
-ifndef DESTDIR
-prefix = $(HOME)
-endif
-bindir_relative = bin
-bindir = $(prefix)/$(bindir_relative)
-mandir = share/man
-infodir = share/info
-perfexecdir = libexec/perf-core
-sharedir = $(prefix)/share
-template_dir = share/perf-core/templates
-htmldir = share/doc/perf-doc
-ifeq ($(prefix),/usr)
-sysconfdir = /etc
-ETC_PERFCONFIG = $(sysconfdir)/perfconfig
-else
-sysconfdir = $(prefix)/etc
-ETC_PERFCONFIG = etc/perfconfig
-endif
-lib = lib
-
 export prefix bindir sharedir sysconfdir
 
 # sparse is architecture-neutral, which means that we need to tell it
@@ -555,23 +522,6 @@ endif
 endif # MAKECMDGOALS != tags
 endif # MAKECMDGOALS != clean
 
-# Shell quote (do not use $(call) to accommodate ancient setups);
-
-ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
-
-DESTDIR_SQ = $(subst ','\'',$(DESTDIR))
-bindir_SQ = $(subst ','\'',$(bindir))
-bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
-mandir_SQ = $(subst ','\'',$(mandir))
-infodir_SQ = $(subst ','\'',$(infodir))
-perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
-template_dir_SQ = $(subst ','\'',$(template_dir))
-htmldir_SQ = $(subst ','\'',$(htmldir))
-prefix_SQ = $(subst ','\'',$(prefix))
-sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
-
-SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
-
 LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
@@ -580,7 +530,6 @@ ALL_LDFLAGS += $(BASIC_LDFLAGS)
 
 export INSTALL SHELL_PATH
 
-
 ### Build rules
 
 SHELL = $(SHELL_PATH)
@@ -822,13 +771,6 @@ check: $(OUTPUT)common-cmds.h
 
 ### Installation rules
 
-ifneq ($(filter /%,$(firstword $(perfexecdir))),)
-perfexec_instdir = $(perfexecdir)
-else
-perfexec_instdir = $(prefix)/$(perfexecdir)
-endif
-perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
-
 install-bin: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 124c344..506c479 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -390,3 +390,55 @@ ifndef NO_LIBNUMA
 		EXTLIBS += -lnuma
 	endif
 endif
+
+# Among the variables below, these:
+#   perfexecdir
+#   template_dir
+#   mandir
+#   infodir
+#   htmldir
+#   ETC_PERFCONFIG (but not sysconfdir)
+# can be specified as a relative path some/where/else;
+# this is interpreted as relative to $(prefix) and "perf" at
+# runtime figures out where they are based on the path to the executable.
+# This can help installing the suite in a relocatable way.
+
+# Make the path relative to DESTDIR, not to prefix
+ifndef DESTDIR
+prefix = $(HOME)
+endif
+bindir_relative = bin
+bindir = $(prefix)/$(bindir_relative)
+mandir = share/man
+infodir = share/info
+perfexecdir = libexec/perf-core
+sharedir = $(prefix)/share
+template_dir = share/perf-core/templates
+htmldir = share/doc/perf-doc
+ifeq ($(prefix),/usr)
+sysconfdir = /etc
+ETC_PERFCONFIG = $(sysconfdir)/perfconfig
+else
+sysconfdir = $(prefix)/etc
+ETC_PERFCONFIG = etc/perfconfig
+endif
+lib = lib
+
+# Shell quote (do not use $(call) to accommodate ancient setups);
+ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
+DESTDIR_SQ = $(subst ','\'',$(DESTDIR))
+bindir_SQ = $(subst ','\'',$(bindir))
+mandir_SQ = $(subst ','\'',$(mandir))
+infodir_SQ = $(subst ','\'',$(infodir))
+perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
+template_dir_SQ = $(subst ','\'',$(template_dir))
+htmldir_SQ = $(subst ','\'',$(htmldir))
+prefix_SQ = $(subst ','\'',$(prefix))
+sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
+
+ifneq ($(filter /%,$(firstword $(perfexecdir))),)
+perfexec_instdir = $(perfexecdir)
+else
+perfexec_instdir = $(prefix)/$(perfexecdir)
+endif
+perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
-- 
1.8.1.4

