Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161015AbaEMWMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:12:15 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:43604 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbaEMWFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:30 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 13/34] perf kbuild: remove legacy libaudit-related build variables
Date: Wed, 14 May 2014 00:03:08 +0200
Message-Id: <1400018609-20486-14-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_LIBAUDIT (replaced by CONFIG_LIBAUDIT)
Remove HAVE_LIBAUDIT_SUPPORT from CFLAGS (replaced by CONFIG_LIBAUDIT)
---
 tools/perf/config/Makefile            | 8 +++-----
 tools/perf/config/Makefile.fix-config | 8 --------
 tools/perf/config/Makefile.fix-legacy | 4 ----
 3 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index fa07862..96bb232 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -392,12 +392,11 @@ ifndef NO_LIBUNWIND
   LDFLAGS += $(LIBUNWIND_LDFLAGS)
 endif
 
-ifndef NO_LIBAUDIT
+ifdef CONFIG_LIBAUDIT
   ifneq ($(feature-libaudit), 1)
-    msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
-    NO_LIBAUDIT := 1
+    msg := $(warning No libaudit.h found, disables LIBAUDIT support and 'trace' tool, please install audit-libs-devel or libaudit-dev);
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBAUDIT)
   else
-    CFLAGS += -DHAVE_LIBAUDIT_SUPPORT
     EXTLIBS += -laudit
   endif
 endif
@@ -763,7 +762,6 @@ all:
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_BACKTRACE)
 	$(call store,NO_LIBNUMA)
-	$(call store,NO_LIBAUDIT)
 	$(call store,NO_LIBBIONIC)
 	$(call store,ETC_PERFCONFIG_SQ)
 	$(call store,DESTDIR_SQ)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index a8e5539..77f9840 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -69,14 +69,6 @@ dummy := $(shell $(CONFIG) -d CONFIG_NUMA)
 endif
 endif
 
-# NO_LIBAUDIT
-ifdef CONFIG_LIBAUDIT
-ifdef NO_LIBAUDIT
-dummy := $(info Disabling CONFIG_LIBAUDIT)
-dummy := $(shell $(CONFIG) -d CONFIG_LIBAUDIT)
-endif
-endif
-
 # NO_LIBBIONIC
 ifdef CONFIG_BIONIC
 ifdef NO_LIBBIONIC
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index 18acc92..ab72582 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -33,10 +33,6 @@ ifndef CONFIG_NUMA
 export NO_LIBNUMA := 1
 endif
 
-ifndef CONFIG_LIBAUDIT
-NO_LIBAUDIT := 1
-endif
-
 ifdef CONFIG_BIONIC
 NO_LIBBIONIC := 1
 endif
-- 
1.9.2

