Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3LSNmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:42:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab3LSNme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:42:34 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/9] tools lib traceevent: Remove print_app_build variable
Date: Thu, 19 Dec 2013 14:42:01 +0100
Message-Id: <1387460527-15030-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing print_app_build variable, because it's not needed.

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
 tools/lib/traceevent/Makefile | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 0d9cbb4..022c987 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -151,7 +151,6 @@ override CFLAGS += $(udis86-flags) -D_GNU_SOURCE
 ifeq ($(VERBOSE),1)
   Q =
   print_compile =
-  print_app_build =
   print_fpic_compile =
   print_shared_lib_compile =
   print_plugin_obj_compile =
@@ -160,7 +159,6 @@ ifeq ($(VERBOSE),1)
 else
   Q = @
   print_compile =		echo '  CC       '$(OBJ);
-  print_app_build =		echo '  BUILD    '$(OBJ);
   print_fpic_compile =		echo '  CC FPIC  '$(OBJ);
   print_shared_lib_compile =	echo '  BUILD    SHARED LIB '$(OBJ);
   print_plugin_obj_compile =	echo '  CC FPIC  '$(OBJ);
@@ -173,10 +171,6 @@ do_fpic_compile =					\
 	($(print_fpic_compile)				\
 	$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@)
 
-do_app_build =						\
-	($(print_app_build)				\
-	$(CC) $^ -rdynamic -o $@ $(CONFIG_LIBS) $(LIBS))
-
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
 	$(CC) --shared $^ -o $@)
-- 
1.8.3.1

