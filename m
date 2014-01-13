Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaAMUvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:51:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaAMUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/38] perf tests: Fix installation tests path setup
Date: Mon, 13 Jan 2014 17:47:12 -0300
Message-Id: <1389646059-24881-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently installation tests work only over x86_64, adding arch check to
make it work over i386 as well.

NOTE looks like x86 is the only arch running tests, we need some
IS_(32/64) flag to make this generic.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1388759553-12974-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index f641c35f2321..e341088de8f3 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -1,6 +1,16 @@
 PERF := .
 MK   := Makefile
 
+include config/Makefile.arch
+
+# FIXME looks like x86 is the only arch running tests ;-)
+# we need some IS_(32/64) flag to make this generic
+ifeq ($(IS_X86_64),1)
+lib = lib64
+else
+lib = lib
+endif
+
 has = $(shell which $1 2>/dev/null)
 
 # standard single make variable specified
@@ -118,16 +128,16 @@ installed_files_bin := bin/perf
 installed_files_bin += etc/bash_completion.d/perf
 installed_files_bin += libexec/perf-core/perf-archive
 
-installed_files_plugins := lib64/traceevent/plugins/plugin_cfg80211.so
-installed_files_plugins += lib64/traceevent/plugins/plugin_scsi.so
-installed_files_plugins += lib64/traceevent/plugins/plugin_xen.so
-installed_files_plugins += lib64/traceevent/plugins/plugin_function.so
-installed_files_plugins += lib64/traceevent/plugins/plugin_sched_switch.so
-installed_files_plugins += lib64/traceevent/plugins/plugin_mac80211.so
-installed_files_plugins += lib64/traceevent/plugins/plugin_kvm.so
-installed_files_plugins += lib64/traceevent/plugins/plugin_kmem.so
-installed_files_plugins += lib64/traceevent/plugins/plugin_hrtimer.so
-installed_files_plugins += lib64/traceevent/plugins/plugin_jbd2.so
+installed_files_plugins := $(lib)/traceevent/plugins/plugin_cfg80211.so
+installed_files_plugins += $(lib)/traceevent/plugins/plugin_scsi.so
+installed_files_plugins += $(lib)/traceevent/plugins/plugin_xen.so
+installed_files_plugins += $(lib)/traceevent/plugins/plugin_function.so
+installed_files_plugins += $(lib)/traceevent/plugins/plugin_sched_switch.so
+installed_files_plugins += $(lib)/traceevent/plugins/plugin_mac80211.so
+installed_files_plugins += $(lib)/traceevent/plugins/plugin_kvm.so
+installed_files_plugins += $(lib)/traceevent/plugins/plugin_kmem.so
+installed_files_plugins += $(lib)/traceevent/plugins/plugin_hrtimer.so
+installed_files_plugins += $(lib)/traceevent/plugins/plugin_jbd2.so
 
 installed_files_all := $(installed_files_bin)
 installed_files_all += $(installed_files_plugins)
-- 
1.8.1.4

