Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3LTTJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:09:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38509 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3LTTJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:30 -0500
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
Subject: [PATCH 20/35] tools lib traceevent: Remove print_app_build variable
Date: Fri, 20 Dec 2013 16:08:55 -0300
Message-Id: <1387566550-3524-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Removing print_app_build variable, because it's not needed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 0d9cbb426b44..022c987d25b6 100644
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
1.8.1.4

