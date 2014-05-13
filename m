Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaEMWGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:06:07 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:47645 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaEMWFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:41 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 21/34] perf kbuild: remove legacy bionic-related build variable
Date: Wed, 14 May 2014 00:03:16 +0200
Message-Id: <1400018609-20486-22-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_BIONIC (replaced by CONFIG_BIONIC)
---
 tools/perf/config/Makefile            | 4 +++-
 tools/perf/config/Makefile.fix-config | 8 --------
 tools/perf/config/Makefile.fix-legacy | 4 ----
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 770675f..f0f51cd 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -270,12 +270,14 @@ CFLAGS += -I$(LIB_INCLUDE)
 
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
-ifndef NO_BIONIC
+ifdef CONFIG_BIONIC
   $(call feature_check,bionic)
   ifeq ($(feature-bionic), 1)
     BIONIC := 1
     EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
     EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  else
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_BIONIC)
   endif
 endif
 
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 46842f9..5575a55 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -37,12 +37,4 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBUNWIND)
 endif
 endif
 
-# NO_LIBBIONIC
-ifdef CONFIG_BIONIC
-ifdef NO_LIBBIONIC
-dummy := $(info Disabling CONFIG_BIONIC)
-dummy := $(shell $(CONFIG) -d CONFIG_BIONIC)
-endif
-endif
-
 all:
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index 15a328e..00244f5 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -12,7 +12,3 @@ endif
 ifndef CONFIG_LIBUNWIND
 NO_LIBUNWIND := 1
 endif
-
-ifdef CONFIG_BIONIC
-NO_LIBBIONIC := 1
-endif
-- 
1.9.2

