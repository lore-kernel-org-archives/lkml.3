Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3AXSyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:54:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32945 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXSyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:54:01 -0500
Date: Thu, 24 Jan 2013 10:53:29 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-n2ni4riphpqxw7d6ziv1ndyc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don'
 t check configuration on make tags
Git-Commit-ID: 3b761f9bda66c24c2686ae795e263cb49f6d8ef4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:53:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b761f9bda66c24c2686ae795e263cb49f6d8ef4
Gitweb:     http://git.kernel.org/tip/3b761f9bda66c24c2686ae795e263cb49f6d8ef4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 29 Nov 2012 16:34:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:07 -0300

perf tools: Don't check configuration on make tags

Doing the same thing done in:

  b059dee: perf tools: Don't check configuration on make clean

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-n2ni4riphpqxw7d6ziv1ndyc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile | 2 ++
 tools/perf/Makefile               | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index f6e5901..eb30044 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -223,11 +223,13 @@ install-pdf: pdf
 #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
 
 ifneq ($(MAKECMDGOALS),clean)
+ifneq ($(MAKECMDGOALS),tags)
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) $(OUTPUT)PERF-VERSION-FILE
 
 -include $(OUTPUT)PERF-VERSION-FILE
 endif
+endif
 
 #
 # Determine "include::" file references in asciidoc files.
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 08da9fc..2a07b95 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -154,6 +154,7 @@ INSTALL = install
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
 ifneq ($(MAKECMDGOALS),clean)
+ifneq ($(MAKECMDGOALS),tags)
 -include config/feature-tests.mak
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
@@ -207,6 +208,7 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
 endif
+endif # MAKECMDGOALS != tags
 endif # MAKECMDGOALS != clean
 
 # Guard against environment variables
@@ -525,6 +527,7 @@ PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 # Platform specific tweaks
 #
 ifneq ($(MAKECMDGOALS),clean)
+ifneq ($(MAKECMDGOALS),tags)
 
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
@@ -841,6 +844,7 @@ ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
 
+endif # MAKECMDGOALS != tags
 endif # MAKECMDGOALS != clean
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
