Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965587AbaFCWNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:13:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46577 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaFCWJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:09:01 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 18/32] perf kbuild: remove legacy backtrace-related build variable
Date: Wed,  4 Jun 2014 00:06:11 +0200
Message-Id: <1401833185-10347-19-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove HAVE_BACKTRACE_SUPPORT (replaced by CONFIG_BACKTRACE)
---
 tools/perf/config/Makefile | 6 +++---
 tools/perf/util/util.c     | 5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c128f30..4a21452 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -572,9 +572,9 @@ ifdef CONFIG_ON_EXIT
   endif
 endif
 
-ifndef NO_BACKTRACE
-  ifeq ($(feature-backtrace), 1)
-    CFLAGS += -DHAVE_BACKTRACE_SUPPORT
+ifdef CONFIG_BACKTRACE
+  ifneq ($(feature-backtrace), 1)
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_BACKTRACE)
   endif
 endif
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9f66549..6b5db6d 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,8 +1,9 @@
+#include "generated/autoconf.h"
 #include "../perf.h"
 #include "util.h"
 #include <api/fs/fs.h>
 #include <sys/mman.h>
-#ifdef HAVE_BACKTRACE_SUPPORT
+#ifdef CONFIG_BACKTRACE
 #include <execinfo.h>
 #endif
 #include <stdio.h>
@@ -237,7 +238,7 @@ int hex2u64(const char *ptr, u64 *long_val)
 }
 
 /* Obtain a backtrace and print it to stdout. */
-#ifdef HAVE_BACKTRACE_SUPPORT
+#ifdef CONFIG_BACKTRACE
 void dump_stack(void)
 {
 	void *array[16];
-- 
1.9.3

