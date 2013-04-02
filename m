Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684Ab3DBD6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:58:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60826 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760505Ab3DBDzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:17 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/23] perf: add BIONIC config option
Date: Mon,  1 Apr 2013 21:54:26 -0600
Message-Id: <1364874877-5618-13-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sets the LIBC option and is independent of LIBELF.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile |    6 ++++--
 tools/perf/Pconfig  |    7 ++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d2707ee..969bdd3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -206,8 +206,10 @@ BASIC_CFLAGS = \
 
 BASIC_LDFLAGS =
 
-ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
-	BIONIC := 1
+ifdef CONFIG_BIONIC
+    ifneq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
+        $(error No anddroid api-level.h. Unset CONFIG_BIONIC to continue)
+    endif
 	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index f744b7b..bec1ac6 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -15,12 +15,17 @@ config NEWT
 config GTK2
     bool "Enable GTK-based UI"
 
+config BIONIC
+    bool "Enable support for Bionic (e.g., Android platform)"
+    default n
+    select LIBC
+
 config LIBC
     bool "Development support for libc is available - glibc or bionic"
 
 config LIBELF
     bool "Enable support for libelf"
-    depends on LIBC
+    depends on !BIONIC && LIBC
 
 config LIBUNWIND
     bool "Enable support for libunwind"
-- 
1.7.10.1

