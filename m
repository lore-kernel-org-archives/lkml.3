Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaEMWGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:06:15 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:44507 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaEMWFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:38 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 19/34] perf kbuild: remove legacy backtrace-related build variable
Date: Wed, 14 May 2014 00:03:14 +0200
Message-Id: <1400018609-20486-20-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove HAVE_BACKTRACE_SUPPORT (replaced by CONFIG_BACKTRACE)
---
 tools/perf/Kconfig         | 1 -
 tools/perf/config/Makefile | 6 +++---
 tools/perf/util/util.c     | 5 +++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 34a8b09..fad1c48 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -244,7 +244,6 @@ config LIBUNWIND_DIR
         ---help---
 	  libunwind directory
 
-
 config NUMA
 	bool "Numa support (bench)"
 	default n
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
1.9.2

