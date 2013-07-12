Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3GLIt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:49:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab3GLIty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:49:54 -0400
Date: Fri, 12 Jul 2013 01:49:40 -0700
From: tip-bot for Robert Richter <tipbot@zytor.com>
Message-ID: <tip-107de3724eff5a6fa6474a4d2aa5460b63749ebf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, robert.richter@linaro.org,
        tglx@linutronix.de, rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, robert.richter@linaro.org,
        tglx@linutronix.de, rric@kernel.org
In-Reply-To: <1370964158-4135-1-git-send-email-rric@kernel.org>
References: <1370964158-4135-1-git-send-email-rric@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix build errors with O and DESTDIR make vars set
Git-Commit-ID: 107de3724eff5a6fa6474a4d2aa5460b63749ebf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:49:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  107de3724eff5a6fa6474a4d2aa5460b63749ebf
Gitweb:     http://git.kernel.org/tip/107de3724eff5a6fa6474a4d2aa5460b63749ebf
Author:     Robert Richter <robert.richter@linaro.org>
AuthorDate: Tue, 11 Jun 2013 17:22:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:34:00 -0300

perf tools: Fix build errors with O and DESTDIR make vars set

Fixing build errors with O and DESTDIR make vars set:

 $ make prefix=/usr/local O=$builddir DESTDIR=$destdir -C tools/ perf
 ...
 make[1]: Entering directory `.../.source/perf/tools/perf'
     CC .../.build/perf/perf/util/parse-events.o
 util/parse-events.c:14:32: fatal error: parse-events-bison.h: No such file or directory
 compilation terminated.
 make[1]: *** [.../.build/perf/perf/util/parse-events.o] Error 1
 ...

and:

     LINK /.../.build/perf/perf/perf
 gcc: error: /.../.build/perf/perf//.../.source/perf/tools/lib/lk/liblk.a: No such file or directory

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Robert Richter <rric@kernel.org>
Link: http://lkml.kernel.org/r/1370964158-4135-1-git-send-email-rric@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 5 ++---
 tools/perf/config/Makefile | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 203cb0e..641fccd 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -121,17 +121,16 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-LK_PATH=$(LK_DIR)
-
 ifneq ($(OUTPUT),)
   TE_PATH=$(OUTPUT)
 ifneq ($(subdir),)
-  LK_PATH=$(OUTPUT)$(LK_DIR)
+  LK_PATH=$(objtree)/lib/lk/
 else
   LK_PATH=$(OUTPUT)
 endif
 else
   TE_PATH=$(TRACE_EVENT_DIR)
+  LK_PATH=$(LK_DIR)
 endif
 
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f139dcd..f446895 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -39,7 +39,7 @@ src-perf := $(srctree)/tools/perf
 endif
 
 ifeq ($(obj-perf),)
-obj-perf := $(objtree)
+obj-perf := $(OUTPUT)
 endif
 
 ifneq ($(obj-perf),)
