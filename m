Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaACOc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:32:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbaACOc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:32:58 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/2] perf tests: Fix installation tests path setup
Date: Fri,  3 Jan 2014 15:32:33 +0100
Message-Id: <1388759553-12974-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1388759553-12974-1-git-send-email-jolsa@redhat.com>
References: <1388759553-12974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jolsa@redhat.com" <jolsa@redhat.com>

Currently installation tests work only over x86_64,
adding arch check to make it work over i386 as well.

NOTE looks like x86 is the only arch running tests,
we need some IS_(32/64) flag to make this generic.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/tests/make | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index f641c35..e341088 100644
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
1.8.3.1

