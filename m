Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3LTTKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38557 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3LTTJe (ORCPT
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
Subject: [PATCH 21/35] tools lib traceevent: Use global QUIET_CC build output
Date: Fri, 20 Dec 2013 16:08:56 -0300
Message-Id: <1387566550-3524-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Using global QUIET_CC build output variable and getting rid of local
print_compile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 022c987d25b6..e852a8d54d84 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -67,6 +67,8 @@ PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
 endif
 
+include $(if $(BUILD_SRC),$(BUILD_SRC)/)../../scripts/Makefile.include
+
 # copy a bit from Linux kbuild
 
 ifeq ("$(origin V)", "command line")
@@ -150,7 +152,6 @@ override CFLAGS += $(udis86-flags) -D_GNU_SOURCE
 
 ifeq ($(VERBOSE),1)
   Q =
-  print_compile =
   print_fpic_compile =
   print_shared_lib_compile =
   print_plugin_obj_compile =
@@ -158,7 +159,6 @@ ifeq ($(VERBOSE),1)
   print_install =
 else
   Q = @
-  print_compile =		echo '  CC       '$(OBJ);
   print_fpic_compile =		echo '  CC FPIC  '$(OBJ);
   print_shared_lib_compile =	echo '  BUILD    SHARED LIB '$(OBJ);
   print_plugin_obj_compile =	echo '  CC FPIC  '$(OBJ);
@@ -188,16 +188,13 @@ do_build_static_lib =				\
 	$(RM) $@;  $(AR) rcs $@ $^)
 
 
-define do_compile
-	$(print_compile)						\
-	$(CC) -c $(CFLAGS) $(EXT) $< -o $(obj)/$@;
-endef
+do_compile = $(QUIET_CC)$(CC) -c $(CFLAGS) $(EXT) $< -o $(obj)/$@;
 
 $(obj)/%.o: $(src)/%.c
-	$(Q)$(call do_compile)
+	$(call do_compile)
 
 %.o: $(src)/%.c
-	$(Q)$(call do_compile)
+	$(call do_compile)
 
 PEVENT_LIB_OBJS  = event-parse.o
 PEVENT_LIB_OBJS += event-plugin.o
-- 
1.8.1.4

