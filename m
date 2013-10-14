Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab3JNURD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:17:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39075 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 150/161] tools/perf/build: Simplify the libelf logic
Date: Mon, 14 Oct 2013 17:02:19 -0300
Message-Id: <1381780950-25642-151-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Ulrich Drepper and Namhyung Kim reported that the libelf logic in
config/Makefile is duplicated in part.

Remove the duplication, and also remove the now unused FLAGS_LIBELF
variable.

Reported-by: Ulrich Drepper <drepper@gmail.com>
Reported-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9524c0c4e88f..d2079220ff87 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -280,7 +280,6 @@ endif # NO_LIBELF
 
 ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
-  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
 
   ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
@@ -305,13 +304,6 @@ ifndef NO_LIBELF
   endif # NO_DWARF
 endif # NO_LIBELF
 
-ifndef NO_LIBELF
-  CFLAGS += -DHAVE_LIBELF_SUPPORT
-  ifeq ($(feature-libelf-mmap), 1)
-    CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
-  endif
-endif # NO_LIBELF
-
 # There's only x86 (both 32 and 64) support for CFI unwind so far
 ifneq ($(ARCH),x86)
   NO_LIBUNWIND := 1
-- 
1.8.1.4

