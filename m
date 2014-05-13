Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaEMWKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:10:44 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46701 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaEMWFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:36 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 18/34] perf kbuild: remove legacy on_exit-related build variable
Date: Wed, 14 May 2014 00:03:13 +0200
Message-Id: <1400018609-20486-19-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove HAVE_ON_EXIT_SUPPORT (replaced by CONFIG_ON_EXIT)
---
 tools/perf/Kconfig          | 6 ++++++
 tools/perf/builtin-record.c | 4 +++-
 tools/perf/config/Makefile  | 6 +++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index ffc1d81..34a8b09 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -190,6 +190,12 @@ config TIMERFD
         ---help---
 	  Timer via file descriptor
 
+config ON_EXIT
+	bool "Support of on_exit() function"
+	default n
+        ---help---
+	  On exit support
+
 config DEMANGLE
 	bool "Demangle symbols"
 	default n
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8ce62ef..372a812 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -5,6 +5,8 @@
  * (or a CPU, or a PID) into the perf.data output file - for
  * later analysis via perf report.
  */
+
+#include "generated/autoconf.h"
 #include "builtin.h"
 
 #include "perf.h"
@@ -30,7 +32,7 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#ifndef HAVE_ON_EXIT_SUPPORT
+#ifndef CONFIG_ON_EXIT
 #ifndef ATEXIT_MAX
 #define ATEXIT_MAX 32
 #endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index ff7f01c..c128f30 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -566,9 +566,9 @@ ifdef CONFIG_LIBIBERTY_ONLY
   endif
 endif
 
-ifndef NO_ON_EXIT
-  ifeq ($(feature-on-exit), 1)
-    CFLAGS += -DHAVE_ON_EXIT_SUPPORT
+ifdef CONFIG_ON_EXIT
+  ifneq ($(feature-on-exit), 1)
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_ON_EXIT)
   endif
 endif
 
-- 
1.9.2

