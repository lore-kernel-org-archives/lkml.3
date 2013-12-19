Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab3LSNoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:44:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab3LSNmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:42:32 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/9] tools lib traceevent: Use global QUIET_CC build output
Date: Thu, 19 Dec 2013 14:42:02 +0100
Message-Id: <1387460527-15030-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using global QUIET_CC build output variable and getting
rid of local print_compile.

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
 tools/lib/traceevent/Makefile | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 022c987..e852a8d 100644
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
1.8.3.1

