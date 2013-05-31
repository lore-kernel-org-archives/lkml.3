Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3EaMgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:36:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3EaMg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:36:26 -0400
Date: Fri, 31 May 2013 05:35:47 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-2fe7374659d68cf3c751ae9d72d8682bbdd2773d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, sam@ravnborg.org, namhyung@kernel.org,
        bp@alien8.de, jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        sam@ravnborg.org, a.p.zijlstra@chello.nl, bp@alien8.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1369398928-9809-24-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-24-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Replace multiple line assignment with multiple statements
Git-Commit-ID: 2fe7374659d68cf3c751ae9d72d8682bbdd2773d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fe7374659d68cf3c751ae9d72d8682bbdd2773d
Gitweb:     http://git.kernel.org/tip/2fe7374659d68cf3c751ae9d72d8682bbdd2773d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 15 Apr 2013 04:32:28 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 30 May 2013 16:50:21 +0300

perf tools: Replace multiple line assignment with multiple statements

Replacing multiple line assignment with multiple statements.

Suggested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369398928-9809-24-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9765993..f139dcd 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -78,13 +78,12 @@ ifdef PARSER_DEBUG
   CFLAGS             += -DPARSER_DEBUG
 endif
 
-CFLAGS += \
-  -fno-omit-frame-pointer \
-  -ggdb3 \
-  -funwind-tables \
-  -Wall \
-  -Wextra \
-  -std=gnu99
+CFLAGS += -fno-omit-frame-pointer
+CFLAGS += -ggdb3
+CFLAGS += -funwind-tables
+CFLAGS += -Wall
+CFLAGS += -Wextra
+CFLAGS += -std=gnu99
 
 EXTLIBS = -lpthread -lrt -lelf -lm
 
@@ -106,30 +105,26 @@ ifndef PERF_DEBUG
   endif
 endif
 
-CFLAGS += \
-  -I$(src-perf)/util/include \
-  -I$(src-perf)/arch/$(ARCH)/include \
-  -I$(srctree)/arch/$(ARCH)/include/uapi \
-  -I$(srctree)/arch/$(ARCH)/include \
-  -I$(srctree)/include/uapi \
-  -I$(srctree)/include
+CFLAGS += -I$(src-perf)/util/include
+CFLAGS += -I$(src-perf)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/arch/$(ARCH)/include/uapi
+CFLAGS += -I$(srctree)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/include/uapi
+CFLAGS += -I$(srctree)/include
 
 # $(obj-perf)      for generated common-cmds.h
 # $(obj-perf)/util for generated bison/flex headers
 ifneq ($(OUTPUT),)
-CFLAGS += \
-  -I$(obj-perf)/util \
-  -I$(obj-perf)
+CFLAGS += -I$(obj-perf)/util
+CFLAGS += -I$(obj-perf)
 endif
 
-CFLAGS += \
-  -I$(src-perf)/util \
-  -I$(src-perf) \
-  -I$(TRACE_EVENT_DIR) \
-  -I$(srctree)/tools/lib/
+CFLAGS += -I$(src-perf)/util
+CFLAGS += -I$(src-perf)
+CFLAGS += -I$(TRACE_EVENT_DIR)
+CFLAGS += -I$(srctree)/tools/lib/
 
-CFLAGS += \
-  -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifndef NO_BIONIC
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
