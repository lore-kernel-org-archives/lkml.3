Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3CNF4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 01:56:30 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38875 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3CNF43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 01:56:29 -0400
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH]Perf: Fix Makefile to remove all "*.o" files while "make clean"
Date: Thu, 14 Mar 2013 13:56:05 +0800
Message-Id: <1363240565-25687-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

While we run "make clean" in perf's directory, and run the command:
"fine ./ -name *.o"
we will get:
------------------------------------
./arch/x86/util/unwind.o
./arch/x86/util/header.o
./arch/x86/util/dwarf-regs.o
./util/scripting-engines/trace-event-python.o
./util/scripting-engines/trace-event-perl.o
./util/probe-finder.o
./util/dwarf-aux.o
./util/unwind.o
./lib/rbtree.o
./ui/browser.o
./ui/browsers/map.o
./ui/browsers/annotate.o
./ui/browsers/scripts.o
./ui/browsers/hists.o
./ui/tui/setup.o
./ui/tui/util.o
./ui/tui/helpline.o
./ui/tui/progress.o
./ui/gtk/browser.o
./ui/gtk/setup.o
./ui/gtk/util.o
./ui/gtk/helpline.o
./ui/gtk/annotate.o
./ui/gtk/progress.o
./ui/gtk/hists.o
./scripts/perl/Perf-Trace-Util/Context.o
./scripts/python/Perf-Trace-Util/Context.o
------------------------------------
These ".o" files are not cleaned.

This patch fixed this problem.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/Makefile |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2108ca..20ed83c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1173,6 +1173,16 @@ clean: $(LIBTRACEEVENT)-clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
 	$(RM) $(OUTPUT)util/*-bison*
 	$(RM) $(OUTPUT)util/*-flex*
+	$(RM) $(OUTPUT)util/*.o
+	$(RM) $(OUTPUT)util/scripting-engines/*.o
+	$(RM) $(OUTPUT)scripts/perl/Perf-Trace-Util/*.o
+	$(RM) $(OUTPUT)scripts/python/Perf-Trace-Util/*.o
+	$(RM) $(OUTPUT)ui/*.o
+	$(RM) $(OUTPUT)ui/browsers/*.o
+	$(RM) $(OUTPUT)ui/tui/*.o
+	$(RM) $(OUTPUT)ui/gtk/*.o
+	$(RM) $(OUTPUT)lib/*.o
+	$(RM) $(OUTPUT)arch/$(ARCH)/util/*.o
 	$(python-clean)
 
 .PHONY: all install clean strip $(LIBTRACEEVENT)
-- 
1.7.9.5

