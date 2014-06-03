Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050AbaFCWIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:08:41 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42426 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaFCWIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:38 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, dsahern@gmail.com, mingo@kernel.org,
        sam@ravnborg.org, mmarek@suse.cz,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kbuild@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/32] perf tools: Kbuild builtin source related fixies
Date: Wed,  4 Jun 2014 00:05:55 +0200
Message-Id: <1401833185-10347-3-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding CONFIG_BUILTIN_* defines to govern builtin commands.
This will be usefull for kbuild process switch.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-cmds.h           | 27 ++++++++++++++++++++++
 tools/perf/builtin-help.c           |  1 +
 tools/perf/perf.c                   | 45 +++++++++++++++++++++++++++++++++++--
 tools/perf/util/generate-cmdlist.sh | 10 +++++++++
 4 files changed, 81 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/builtin-cmds.h

diff --git a/tools/perf/builtin-cmds.h b/tools/perf/builtin-cmds.h
new file mode 100644
index 0000000..fec342a
--- /dev/null
+++ b/tools/perf/builtin-cmds.h
@@ -0,0 +1,27 @@
+#ifndef BUILTIN_CMDS_H
+#define BUILTIN_CMDS_H
+
+#define CONFIG_BUILTIN_REPORT 1
+#define CONFIG_BUILTIN_SCRIPT 1
+#define CONFIG_BUILTIN_BENCH 1
+#define CONFIG_BUILTIN_SCHED 1
+#define CONFIG_BUILTIN_TRACE 1
+#define CONFIG_BUILTIN_TOP 1
+#define CONFIG_BUILTIN_RECORD 1
+#define CONFIG_BUILTIN_BUILDID_LIST 1
+#define CONFIG_BUILTIN_INJECT 1
+#define CONFIG_BUILTIN_LOCK 1
+#define CONFIG_BUILTIN_KVM 1
+#define CONFIG_BUILTIN_BUILDID_CACHE 1
+#define CONFIG_BUILTIN_EVLIST 1
+#define CONFIG_BUILTIN_KMEM 1
+#define CONFIG_BUILTIN_STAT 1
+#define CONFIG_BUILTIN_DIFF 1
+#define CONFIG_BUILTIN_ANNOTATE 1
+#define CONFIG_BUILTIN_TIMECHART 1
+#define CONFIG_BUILTIN_LIST 1
+#define CONFIG_BUILTIN_HELP 1
+#define CONFIG_BUILTIN_PROBE 1
+#define CONFIG_BUILTIN_MEM 1
+
+#endif /* BUILTIN_CMDS_H */
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 178b88a..b6c78a6 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -7,6 +7,7 @@
 #include "util/cache.h"
 #include "builtin.h"
 #include "util/exec_cmd.h"
+#include "builtin-cmds.h"
 #include "common-cmds.h"
 #include "util/parse-options.h"
 #include "util/run-command.h"
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 431798a..c39470b 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -7,6 +7,7 @@
  * perf top, perf record, perf report, etc.) are started.
  */
 #include "builtin.h"
+#include "builtin-cmds.h"
 
 #include "util/exec_cmd.h"
 #include "util/cache.h"
@@ -33,34 +34,74 @@ struct cmd_struct {
 };
 
 static struct cmd_struct commands[] = {
+#ifdef CONFIG_BUILTIN_BUILDID_CACHE
 	{ "buildid-cache", cmd_buildid_cache, 0 },
+#endif
+#ifdef CONFIG_BUILTIN_BUILDID_LIST
 	{ "buildid-list", cmd_buildid_list, 0 },
+#endif
+#ifdef CONFIG_BUILTIN_DIFF
 	{ "diff",	cmd_diff,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_EVLIST
 	{ "evlist",	cmd_evlist,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_HELP
 	{ "help",	cmd_help,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_LIST
 	{ "list",	cmd_list,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_RECORD
 	{ "record",	cmd_record,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_REPORT
 	{ "report",	cmd_report,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_BENCH
 	{ "bench",	cmd_bench,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_STAT
 	{ "stat",	cmd_stat,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_TIMECHART
 	{ "timechart",	cmd_timechart,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_TOP
 	{ "top",	cmd_top,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_ANNOTATE
 	{ "annotate",	cmd_annotate,	0 },
+#endif
 	{ "version",	cmd_version,	0 },
+#ifdef CONFIG_BUILTIN_SCRIPT
 	{ "script",	cmd_script,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_SCHED
 	{ "sched",	cmd_sched,	0 },
-#ifdef HAVE_LIBELF_SUPPORT
+#endif
+#if defined HAVE_LIBELF_SUPPORT && defined CONFIG_BUILTIN_PROBE
 	{ "probe",	cmd_probe,	0 },
 #endif
+#ifdef CONFIG_BUILTIN_KMEM
 	{ "kmem",	cmd_kmem,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_LOCK
 	{ "lock",	cmd_lock,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_KVM
 	{ "kvm",	cmd_kvm,	0 },
+#endif
 	{ "test",	cmd_test,	0 },
-#ifdef HAVE_LIBAUDIT_SUPPORT
+#if defined HAVE_LIBAUDIT_SUPPORT && defined CONFIG_BUILTIN_TRACE
 	{ "trace",	cmd_trace,	0 },
 #endif
+#ifdef CONFIG_BUILTIN_INJECT
 	{ "inject",	cmd_inject,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_MEM
 	{ "mem",	cmd_mem,	0 },
+#endif
 };
 
 struct pager_config {
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index 36a885d..05ee30f 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -1,5 +1,11 @@
 #!/bin/sh
 
+function cfg()
+{
+     cfg=`echo $1 | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g'`
+     echo "$cfg"
+}
+
 echo "/* Automatically generated by $0 */
 struct cmdname_help
 {
@@ -13,6 +19,7 @@ sed -n -e 's/^perf-\([^ 	]*\)[ 	].* common.*/\1/p' command-list.txt |
 sort |
 while read cmd
 do
+     echo "#ifdef CONFIG_BUILTIN_$(cfg $cmd)"
      sed -n '
      /^NAME/,/perf-'"$cmd"'/H
      ${
@@ -20,6 +27,7 @@ do
             s/.*perf-'"$cmd"' - \(.*\)/  {"'"$cmd"'", "\1"},/
 	    p
      }' "Documentation/perf-$cmd.txt"
+     echo "#endif"
 done
 
 echo "#ifdef HAVE_LIBELF_SUPPORT"
@@ -27,6 +35,7 @@ sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' command-list.txt |
 sort |
 while read cmd
 do
+     echo "#ifdef CONFIG_BUILTIN_$(cfg $cmd)"
      sed -n '
      /^NAME/,/perf-'"$cmd"'/H
      ${
@@ -34,6 +43,7 @@ do
             s/.*perf-'"$cmd"' - \(.*\)/  {"'"$cmd"'", "\1"},/
 	    p
      }' "Documentation/perf-$cmd.txt"
+     echo "#endif"
 done
 echo "#endif /* HAVE_LIBELF_SUPPORT */"
 echo "};"
-- 
1.9.3

