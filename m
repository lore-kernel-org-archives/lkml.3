Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab3GJT1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:27:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57071 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3GJT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:26:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/23] perf tools: Fix build errors with O and DESTDIR make vars set
Date: Wed, 10 Jul 2013 16:19:03 -0300
Message-Id: <1373483963-19277-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
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

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Robert Richter <rric@kernel.org>
Link: http://lkml.kernel.org/r/1370964158-4135-1-git-send-email-rric@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

