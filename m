Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaALSeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:34:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45560 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaALSe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:34:26 -0500
Date: Sun, 12 Jan 2014 10:34:04 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-db72a330587e10d6b8009e0dcf3d97aa9b1e2659@git.kernel.org>
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
In-Reply-To: <1387460527-15030-4-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Remove print_app_build variable
Git-Commit-ID: db72a330587e10d6b8009e0dcf3d97aa9b1e2659
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:34:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db72a330587e10d6b8009e0dcf3d97aa9b1e2659
Gitweb:     http://git.kernel.org/tip/db72a330587e10d6b8009e0dcf3d97aa9b1e2659
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:42:01 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:18:09 -0300

tools lib traceevent: Remove print_app_build variable

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
