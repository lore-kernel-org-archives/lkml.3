Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3JJG5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:57:09 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:35940 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3JJG5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:57:07 -0400
Date: Thu, 10 Oct 2013 08:57:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tools/perf/build: Simplify the libelf logic
Message-ID: <20131010065703.GF10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-16-git-send-email-mingo@kernel.org>
 <8761t5k6mf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761t5k6mf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/config/Makefile | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 3227107..587dd7e 100644
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
