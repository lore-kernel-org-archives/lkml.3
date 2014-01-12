Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaALSey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:34:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaALSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:34:50 -0500
Date: Sun, 12 Jan 2014 10:34:24 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-bdebbacd421184234b5551c468e53956a9b6edf5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1387460527-15030-6-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add global QUIET_CC_FPIC build output
Git-Commit-ID: bdebbacd421184234b5551c468e53956a9b6edf5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:34:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdebbacd421184234b5551c468e53956a9b6edf5
Gitweb:     http://git.kernel.org/tip/bdebbacd421184234b5551c468e53956a9b6edf5
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:42:03 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:18:10 -0300

tools lib traceevent: Add global QUIET_CC_FPIC build output

Adding global QUIET_CC_FPIC build output variable and getting rid of
local print_fpic_compile and print_plugin_obj_compile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile  | 16 ++--------------
 tools/scripts/Makefile.include |  1 +
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index e852a8d..24203cc 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -152,33 +152,21 @@ override CFLAGS += $(udis86-flags) -D_GNU_SOURCE
 
 ifeq ($(VERBOSE),1)
   Q =
-  print_fpic_compile =
   print_shared_lib_compile =
-  print_plugin_obj_compile =
   print_plugin_build =
   print_install =
 else
   Q = @
-  print_fpic_compile =		echo '  CC FPIC  '$(OBJ);
   print_shared_lib_compile =	echo '  BUILD    SHARED LIB '$(OBJ);
-  print_plugin_obj_compile =	echo '  CC FPIC  '$(OBJ);
   print_plugin_build =		echo '  BUILD    PLUGIN '$(OBJ);
   print_static_lib_build =	echo '  BUILD    STATIC LIB '$(OBJ);
   print_install =		echo '  INSTALL  '$1;
 endif
 
-do_fpic_compile =					\
-	($(print_fpic_compile)				\
-	$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@)
-
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
 	$(CC) --shared $^ -o $@)
 
-do_compile_plugin_obj =				\
-	($(print_plugin_obj_compile)		\
-	$(CC) -c $(CFLAGS) -fPIC -o $@ $<)
-
 do_plugin_build =				\
 	($(print_plugin_build)			\
 	$(CC) $(CFLAGS) -shared -nostartfiles -o $@ $<)
@@ -236,10 +224,10 @@ libtraceevent.a: $(PEVENT_LIB_OBJS)
 plugins: $(PLUGINS)
 
 $(PEVENT_LIB_OBJS): %.o: $(src)/%.c TRACEEVENT-CFLAGS
-	$(Q)$(do_fpic_compile)
+	$(QUIET_CC_FPIC)$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@
 
 $(PLUGIN_OBJS): %.o : $(src)/%.c
-	$(Q)$(do_compile_plugin_obj)
+	$(QUIET_CC_FPIC)$(CC) -c $(CFLAGS) -fPIC -o $@ $<
 
 $(PLUGINS): %.so: %.o
 	$(Q)$(do_plugin_build)
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index e4cfbed..8abbef1 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -61,6 +61,7 @@ QUIET_SUBDIR1  =
 ifneq ($(findstring $(MAKEFLAGS),s),s)
   ifneq ($(V),1)
 	QUIET_CC       = @echo '  CC       '$@;
+	QUIET_CC_FPIC  = @echo '  CC FPIC  '$@;
 	QUIET_AR       = @echo '  AR       '$@;
 	QUIET_LINK     = @echo '  LINK     '$@;
 	QUIET_MKDIR    = @echo '  MKDIR    '$@;
