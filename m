Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaALSej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:34:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaALSef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:34:35 -0500
Date: Sun, 12 Jan 2014 10:34:14 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c3d090f498a4d7a8905c92dbf83ae2aa4810fbef@git.kernel.org>
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
In-Reply-To: <1387460527-15030-5-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Use global QUIET_CC build output
Git-Commit-ID: c3d090f498a4d7a8905c92dbf83ae2aa4810fbef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:34:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3d090f498a4d7a8905c92dbf83ae2aa4810fbef
Gitweb:     http://git.kernel.org/tip/c3d090f498a4d7a8905c92dbf83ae2aa4810fbef
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:42:02 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:18:09 -0300

tools lib traceevent: Use global QUIET_CC build output

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
