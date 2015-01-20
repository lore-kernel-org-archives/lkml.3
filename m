Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbbATQop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:44:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbbATQm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:42:28 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 30/36] perf build: Remove PERF-CFLAGS file
Date: Tue, 20 Jan 2015 17:39:27 +0100
Message-Id: <1421771973-6022-31-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing PERF-CFLAGS file, because the build framework
stores full build command line for each object and
triggers rebuilt if necessary.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile.perf | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index d02c1f2622ca..97307a26fe10 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -365,7 +365,7 @@ LIBTRACEEVENT_FLAGS  = $(QUIET_SUBDIR1) O=$(OUTPUT)
 LIBTRACEEVENT_FLAGS += CFLAGS="-g -Wall $(EXTRA_CFLAGS)"
 LIBTRACEEVENT_FLAGS += plugin_dir=$(plugindir_SQ)
 
-$(LIBTRACEEVENT): $(TE_SOURCES) $(OUTPUT)PERF-CFLAGS
+$(LIBTRACEEVENT): $(TE_SOURCES)
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) libtraceevent.a plugins
 
 $(LIBTRACEEVENT)-clean:
@@ -444,17 +444,6 @@ cscope:
 	$(QUIET_GEN)$(RM) cscope*; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs cscope -b $(TAG_FILES)
 
-### Detect prefix changes
-TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
-             $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ):$(plugindir_SQ)
-
-$(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
-	@FLAGS='$(TRACK_CFLAGS)'; \
-	    if test x"$$FLAGS" != x"`cat $(OUTPUT)PERF-CFLAGS 2>/dev/null`" ; then \
-		echo 1>&2 "  FLAGS:   * new build flags or prefix"; \
-		echo "$$FLAGS" >$(OUTPUT)PERF-CFLAGS; \
-            fi
-
 ### Testing rules
 
 # GNU make supports exporting all variables by "export" without parameters.
@@ -544,7 +533,7 @@ clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	@find . -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
 	@$(RM) .config-detected
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
-	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
+	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(python-clean)
 
@@ -562,5 +551,5 @@ FORCE:
 
 .PHONY: all install clean config-clean strip install-gtk
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
-.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS FORCE single_dep
+.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope FORCE single_dep
 
-- 
1.9.3

