Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaANQiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:38:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaANQiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:38:50 -0500
Date: Tue, 14 Jan 2014 08:38:09 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f7c64474242701eb24f6fe96f8df0389a2b800f7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1388759553-12974-2-git-send-email-jolsa@redhat.com>
References: <1388759553-12974-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Fix installation tests path setup
Git-Commit-ID: f7c64474242701eb24f6fe96f8df0389a2b800f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:38:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7c64474242701eb24f6fe96f8df0389a2b800f7
Gitweb:     http://git.kernel.org/tip/f7c64474242701eb24f6fe96f8df0389a2b800f7
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 3 Jan 2014 15:32:33 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:23 -0300

perf tests: Fix installation tests path setup

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
