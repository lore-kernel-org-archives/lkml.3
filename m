Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3FKPXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:23:02 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:56702 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3FKPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:22:58 -0400
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Robert Richter <rric@kernel.org>
Subject: [PATCH] perf tools: Fix build errors with O and DESTDIR make vars set
Date: Tue, 11 Jun 2013 17:22:38 +0200
Message-Id: <1370964158-4135-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Fixing build errors with O and DESTDIR make vars set:

 $ make prefix=/usr/local O=$builddir DESTDIR=$destdir -C tools/ perf
 ...
 make[1]: Entering directory `.../.source/perf/tools/perf'
     CC .../.build/perf/perf/util/parse-events.o
 util/parse-events.c:14:32: fatal error: parse-events-bison.h: No such file or directory
 compilation terminated.
 make[1]: *** [.../.build/perf/perf/util/parse-events.o] Error 1
 ...

and:

     LINK /.../.build/perf/perf/perf
 gcc: error: /.../.build/perf/perf//.../.source/perf/tools/lib/lk/liblk.a: No such file or directory

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 tools/perf/Makefile        | 5 ++---
 tools/perf/config/Makefile | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 203cb0e..641fccd 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -121,17 +121,16 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-LK_PATH=$(LK_DIR)
-
 ifneq ($(OUTPUT),)
   TE_PATH=$(OUTPUT)
 ifneq ($(subdir),)
-  LK_PATH=$(OUTPUT)$(LK_DIR)
+  LK_PATH=$(objtree)/lib/lk/
 else
   LK_PATH=$(OUTPUT)
 endif
 else
   TE_PATH=$(TRACE_EVENT_DIR)
+  LK_PATH=$(LK_DIR)
 endif
 
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f139dcd..f446895 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -39,7 +39,7 @@ src-perf := $(srctree)/tools/perf
 endif
 
 ifeq ($(obj-perf),)
-obj-perf := $(objtree)
+obj-perf := $(OUTPUT)
 endif
 
 ifneq ($(obj-perf),)
-- 
1.8.1.1

