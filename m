Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab3JOFik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:38:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab3JOFcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:32:15 -0400
Date: Mon, 14 Oct 2013 22:32:00 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-65fb09922d4ca5da54fe18d7b44e5961caf169ad@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1381312169-17354-3-git-send-email-mingo@kernel.org>
References: <1381312169-17354-3-git-send-email-mingo@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools:
  Harmonize the various build messages in perf, lib-traceevent, lib-lk
Git-Commit-ID: 65fb09922d4ca5da54fe18d7b44e5961caf169ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:32:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65fb09922d4ca5da54fe18d7b44e5961caf169ad
Gitweb:     http://git.kernel.org/tip/65fb09922d4ca5da54fe18d7b44e5961caf169ad
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 9 Oct 2013 11:49:27 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:18:08 -0300

tools: Harmonize the various build messages in perf, lib-traceevent, lib-lk

The various build lines from libtraceevent and perf mix up during a
parallel build and produce unaligned output like:

    CC builtin-buildid-list.o
    CC builtin-buildid-cache.o
    CC builtin-list.o
  CC FPIC            trace-seq.o
    CC builtin-record.o
  CC FPIC            parse-filter.o
    CC builtin-report.o
    CC builtin-stat.o
  CC FPIC            parse-utils.o
  CC FPIC            kbuffer-parse.o
    CC builtin-timechart.o
    CC builtin-top.o
    CC builtin-script.o
  BUILD STATIC LIB   libtraceevent.a
    CC builtin-probe.o
    CC builtin-kmem.o
    CC builtin-lock.o

To solve this, harmonize all the build message alignments to be similar
to the kernel's kbuild output: prefixed by two spaces and 11-char wide.

After the patch the output looks pretty tidy, even if output lines get
mixed up:

  CC      builtin-annotate.o
  FLAGS:  * new build flags or cross compiler
  CC      builtin-bench.o
  AR      liblk.a
  CC      bench/sched-messaging.o
  CC FPIC event-parse.o
  CC      bench/sched-pipe.o
  CC FPIC trace-seq.o
  CC      bench/mem-memcpy.o
  CC      bench/mem-memset.o
  CC FPIC parse-filter.o
  CC      builtin-diff.o
  CC      builtin-evlist.o
  CC      builtin-help.o

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1381312169-17354-3-git-send-email-mingo@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile     | 18 +++++++++---------
 tools/perf/Documentation/Makefile | 17 +++++++++--------
 tools/perf/Makefile               |  2 +-
 tools/perf/Makefile.perf          |  2 +-
 tools/scripts/Makefile.include    | 23 ++++++++++++-----------
 5 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index ca6cb77..fc15020 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -134,14 +134,14 @@ ifeq ($(VERBOSE),1)
   print_install =
 else
   Q = @
-  print_compile =		echo '  CC                 '$(OBJ);
-  print_app_build =		echo '  BUILD              '$(OBJ);
-  print_fpic_compile =		echo '  CC FPIC            '$(OBJ);
-  print_shared_lib_compile =	echo '  BUILD SHARED LIB   '$(OBJ);
-  print_plugin_obj_compile =	echo '  CC PLUGIN OBJ      '$(OBJ);
-  print_plugin_build =		echo '  CC PLUGI           '$(OBJ);
-  print_static_lib_build =	echo '  BUILD STATIC LIB   '$(OBJ);
-  print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
+  print_compile =		echo '  CC       '$(OBJ);
+  print_app_build =		echo '  BUILD    '$(OBJ);
+  print_fpic_compile =		echo '  CC FPIC  '$(OBJ);
+  print_shared_lib_compile =	echo '  BUILD    SHARED LIB '$(OBJ);
+  print_plugin_obj_compile =	echo '  BUILD    PLUGIN OBJ '$(OBJ);
+  print_plugin_build =		echo '  BUILD    PLUGIN     '$(OBJ);
+  print_static_lib_build =	echo '  BUILD    STATIC LIB '$(OBJ);
+  print_install =		echo '  INSTALL  '$1'	to	$(DESTDIR_SQ)$2';
 endif
 
 do_fpic_compile =					\
@@ -268,7 +268,7 @@ TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
 TRACEEVENT-CFLAGS: force
 	@FLAGS='$(TRACK_CFLAGS)'; \
 	    if test x"$$FLAGS" != x"`cat TRACEEVENT-CFLAGS 2>/dev/null`" ; then \
-		echo 1>&2 "    * new build flags or cross compiler"; \
+		echo 1>&2 "  FLAGS:   * new build flags or cross compiler"; \
 		echo "$$FLAGS" >TRACEEVENT-CFLAGS; \
             fi
 
diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index be5adb1..c4c300c 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -145,16 +145,17 @@ endif
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifneq ($(V),1)
-	QUIET_ASCIIDOC	= @echo '   ' ASCIIDOC $@;
-	QUIET_XMLTO	= @echo '   ' XMLTO $@;
-	QUIET_DB2TEXI	= @echo '   ' DB2TEXI $@;
-	QUIET_MAKEINFO	= @echo '   ' MAKEINFO $@;
-	QUIET_DBLATEX	= @echo '   ' DBLATEX $@;
-	QUIET_XSLTPROC	= @echo '   ' XSLTPROC $@;
-	QUIET_GEN	= @echo '   ' GEN $@;
+	QUIET_ASCIIDOC	= @echo '  ASCIIDOC '$@;
+	QUIET_XMLTO	= @echo '  XMLTO    '$@;
+	QUIET_DB2TEXI	= @echo '  DB2TEXI  '$@;
+	QUIET_MAKEINFO	= @echo '  MAKEINFO '$@;
+	QUIET_DBLATEX	= @echo '  DBLATEX  '$@;
+	QUIET_XSLTPROC	= @echo '  XSLTPROC '$@;
+	QUIET_GEN	= @echo '  GEN      '$@;
 	QUIET_STDERR	= 2> /dev/null
 	QUIET_SUBDIR0	= +@subdir=
-	QUIET_SUBDIR1	= ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+	QUIET_SUBDIR1	= ;$(NO_SUBDIR) \
+			   echo '  SUBDIR   ' $$subdir; \
 			  $(MAKE) $(PRINT_DIR) -C $$subdir
 	export V
 endif
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9580ebe..5aa3d04 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -38,7 +38,7 @@ ifneq ($(O),)
 endif
 
 define print_msg
-  @printf '    BUILD: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
+  @printf '  BUILD:   Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
 endef
 
 define make
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 250b276..f91bd5a 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -784,7 +784,7 @@ TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
 $(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
 	@FLAGS='$(TRACK_CFLAGS)'; \
 	    if test x"$$FLAGS" != x"`cat $(OUTPUT)PERF-CFLAGS 2>/dev/null`" ; then \
-		echo 1>&2 "    * new build flags or prefix"; \
+		echo 1>&2 "  FLAGS:   * new build flags or prefix"; \
 		echo "$$FLAGS" >$(OUTPUT)PERF-CFLAGS; \
             fi
 
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 1853736..ee76544 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -59,21 +59,22 @@ QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifneq ($(V),1)
-	QUIET_CC       = @echo '   ' CC $@;
-	QUIET_AR       = @echo '   ' AR $@;
-	QUIET_LINK     = @echo '   ' LINK $@;
-	QUIET_MKDIR    = @echo '   ' MKDIR $@;
-	QUIET_GEN      = @echo '   ' GEN $@;
+  ifneq ($(V),1)
+	QUIET_CC       = @echo '  CC       '$@;
+	QUIET_AR       = @echo '  AR       '$@;
+	QUIET_LINK     = @echo '  LINK     '$@;
+	QUIET_MKDIR    = @echo '  MKDIR    '$@;
+	QUIET_GEN      = @echo '  GEN      '$@;
 	QUIET_SUBDIR0  = +@subdir=
-	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '  ' SUBDIR $$subdir; \
+	QUIET_SUBDIR1  = ;$(NO_SUBDIR) \
+			  echo '  SUBDIR   '$$subdir; \
 			 $(MAKE) $(PRINT_DIR) -C $$subdir
-	QUIET_FLEX     = @echo '   ' FLEX $@;
-	QUIET_BISON    = @echo '   ' BISON $@;
+	QUIET_FLEX     = @echo '  FLEX     '$@;
+	QUIET_BISON    = @echo '  BISON    '$@;
 
 	descend = \
-		+@echo '   ' DESCEND $(1); \
+		+@echo	       '  DESCEND  '$(1); \
 		mkdir -p $(OUTPUT)$(1) && \
 		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
-endif
+  endif
 endif
